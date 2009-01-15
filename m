Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbZAODPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbZAODPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 22:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZAODPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 22:15:01 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:44224 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753814AbZAODPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 22:15:00 -0500
Date: Thu, 15 Jan 2009 14:14:54 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH crypto -v3 1/2] AES-NI: Add support to access
	underlying blkcipher under cryptd ablkcipher
Message-ID: <20090115031454.GA27821@gondor.apana.org.au>
References: <1231919046.5937.159.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231919046.5937.159.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 03:44:06PM +0800, Huang Ying wrote:
> cryptd_alloc_ablkcipher() will allocate a cryptd-ed ablkcipher for
> specified algorithm name. The new allocated one is guaranteed to be
> cryptd-ed ablkcipher, so the blkcipher underlying can be gotten via
> cryptd_ablkcipher_child().
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Thanks for the patch!
  
> +struct crypto_ablkcipher *cryptd_alloc_ablkcipher(const char *alg_name,
> +						  u32 type, u32 mask)

It should have its own type so that we get compiler type checking.
Something like,

	struct cryptd_ablkcipher {
		struct crypto_ablkcipher *cipher;
	};

> +	if (snprintf(cryptd_alg_name, CRYPTO_MAX_ALG_NAME,
> +		     "cryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
> +		return ERR_PTR(-EINVAL);
> +	return crypto_alloc_ablkcipher(cryptd_alg_name, type, mask);

We should also check that the new tfm's module matches ours, i.e.,

	crypto_ablkcipher_tfm(cipher)->__crt_alg->cra_module ==
	THIS_MODULE

Granted this doesn't do much if we're built-in but it's better
than nothing.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
