Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbZAPHMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbZAPHMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 02:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbZAPHMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 02:12:10 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:38592 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755066AbZAPHMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:12:09 -0500
Date: Fri, 16 Jan 2009 18:12:04 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH crypto -v5 1/2] AES-NI: Add support to access
	underlying blkcipher under cryptd ablkcipher
Message-ID: <20090116071203.GA12661@gondor.apana.org.au>
References: <1232089820.13948.28.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232089820.13948.28.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 03:10:20PM +0800, Huang Ying wrote:
>
> v5:
> 
> - Move declaration to crypto/cryptd.h
> 
> - Fix allocation error processing in cryptd_alloc_ablkcipher()
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

OK we're nearly there :)

> +struct cryptd_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
> +						  u32 type, u32 mask)
> +{
> +	char cryptd_alg_name[CRYPTO_MAX_ALG_NAME];
> +	struct crypto_ablkcipher *tfm;
> +
> +	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
> +		     "cryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
> +		return ERR_PTR(-EINVAL);
> +	tfm = crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);
> +	if (IS_ERR(tfm))
> +		return ERR_CAST(tfm);
> +	if (crypto_ablkcipher_tfm(tfm)->__crt_alg->cra_module != THIS_MODULE)
> +		return ERR_PTR(-EINVAL);

Need to free the tfm here or it'll be leaked.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
