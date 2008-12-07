Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYLGLbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYLGLbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYLGLbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:31:07 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:47247 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753423AbYLGLbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:31:06 -0500
Date: Sun, 7 Dec 2008 19:30:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH-mm 1/2] crypto: replace private helper with common
	unaligned endian helper
Message-ID: <20081207113058.GA13736@gondor.apana.org.au>
References: <1228328019.5412.23.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228328019.5412.23.camel@brick>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 10:13:39AM -0800, Harvey Harrison wrote:
>
> @@ -101,7 +96,7 @@ static void salsa20_wordtobyte(u8 output[64], const u32 input[16])
>  	for (i = 0; i < 16; ++i)
>  		x[i] = PLUS(x[i],input[i]);
>  	for (i = 0; i < 16; ++i)
> -		U32TO8_LITTLE(output + 4 * i,x[i]);
> +		store_le32_noalign((__le32 *)(output + 4 * i), x[i]);

We can easily make "output" 4-byte aligned since its our buffer
on the stack.

>  }
>  
>  static const char sigma[16] = "expand 32-byte k";
> @@ -111,30 +106,30 @@ static void salsa20_keysetup(struct salsa20_ctx *ctx, const u8 *k, u32 kbytes)
>  {
>  	const char *constants;
>  
> -	ctx->input[1] = U8TO32_LITTLE(k + 0);
> -	ctx->input[2] = U8TO32_LITTLE(k + 4);
> -	ctx->input[3] = U8TO32_LITTLE(k + 8);
> -	ctx->input[4] = U8TO32_LITTLE(k + 12);
> +	ctx->input[1] = load_le32_noalign((__le32 *)(k + 0));
> +	ctx->input[2] = load_le32_noalign((__le32 *)(k + 4));
> +	ctx->input[3] = load_le32_noalign((__le32 *)(k + 8));
> +	ctx->input[4] = load_le32_noalign((__le32 *)(k + 12));

Since salsa sets alignmask to 3, k should already be aligned.


> +	ctx->input[11] = load_le32_noalign((__le32 *)(k + 0));
> +	ctx->input[12] = load_le32_noalign((__le32 *)(k + 4));
> +	ctx->input[13] = load_le32_noalign((__le32 *)(k + 8));
> +	ctx->input[14] = load_le32_noalign((__le32 *)(k + 12));

Ditto.

> +	ctx->input[0] = load_le32_noalign((__le32 *)(constants + 0));
> +	ctx->input[5] = load_le32_noalign((__le32 *)(constants + 4));
> +	ctx->input[10] = load_le32_noalign((__le32 *)(constants + 8));
> +	ctx->input[15] = load_le32_noalign((__le32 *)(constants + 12));

We should mark "constants" with the proper alignment.

>  static void salsa20_ivsetup(struct salsa20_ctx *ctx, const u8 *iv)
>  {
> -	ctx->input[6] = U8TO32_LITTLE(iv + 0);
> -	ctx->input[7] = U8TO32_LITTLE(iv + 4);
> +	ctx->input[6] = load_le32_noalign((__le32 *)(iv + 0));
> +	ctx->input[7] = load_le32_noalign((__le32 *)(iv + 4));

The IV should already be aligned.

So please simply get rid of all the unaligned ops and add the
appropriate alignment marking on constants and the buffer on
the stack.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
