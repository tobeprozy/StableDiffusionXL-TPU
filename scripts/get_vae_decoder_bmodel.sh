#!/bin/bash
model_dir=$(dirname $(readlink -f "$0"))
outdir=../models/BM1684X/

function gen_vae_decoder_mlir()
{
    model_transform.py \
        --model_name vae_decoder \
        --model_def ../models/onnx_pt/vae_decoder/vae_decoder.pt \
        --input_shapes [[1,4,128,128]] \
        --mlir vae_decoder.mlir
}

function gen_vae_decoder_bf16bmodel()
{
    model_deploy.py \
        --mlir vae_decoder.mlir \
        --quantize BF16 \
        --chip bm1684x \
        --model vae_decoder_1684x_bf16.bmodel

    mv vae_decoder_1684x_bf16.bmodel $outdir/
}

pushd $model_dir
if [ ! -d $outdir ]; then
    mkdir -p $outdir
fi

gen_vae_decoder_mlir
gen_vae_decoder_bf16bmodel

popd