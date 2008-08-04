Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbYHDONs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbYHDONs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbYHDONk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:13:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46786 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYHDONj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:13:39 -0400
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
From: David Woodhouse <dwmw2@infradead.org>
To: Austin Zhang <austin_zhang@linux.intel.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <1217842507.20845.18.camel@localhost.localdomain>
References: <1217842507.20845.18.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 15:13:34 +0100
Message-Id: <1217859214.3454.629.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 05:35 -0400, Austin Zhang wrote:
> +static int crc32c_intel_cra_init(struct crypto_tfm *tfm)
> +{
> +	u32 *key = crypto_tfm_ctx(tfm);
> +
> +	*key = ~0;
> +
> +	tfm->crt_ahash.reqsize = sizeof(u32);
> +
> +	if (cpu_has_xmm4_2)
> +		return 0;
> +	else
> +		return -1;
> +}

 ...

> +static int __init crc32c_intel_mod_init(void)
> +{
> +	return crypto_register_alg(&alg);
> +}
> +

Am I missing something here, or are you registering the crypto algorithm
_unconditionally_ and then just causing init requests for it to fail on
older hardware?  Wouldn't it be better to register the driver _only_
when the hardware is capable? Or at least "if at least one cpu is
capable".

> --- linux-2.6/crypto/Kconfig	2008-08-04 01:08:00.000000000 -0400
> +++ linux-2.6-patch/crypto/Kconfig	2008-08-04 01:59:00.000000000 -0400
> @@ -221,6 +221,17 @@ config CRYPTO_CRC32C
>  	  See Castagnoli93.  This implementation uses lib/libcrc32c.
>            Module will be crc32c.
>  
> +config CRYPTO_CRC32C_INTEL
> +        tristate "CRC32c INTEL hardware acceleration"
> +        select CRYPTO_HASH
> +        help
> +          In Intel processor with SSE4.2 supported, the processor will
> +          support CRC32C implemetation using hardware accelerated CRC32 
> +          instruction. This option will create 'crc32c-intel' module,
> +          which will enable any routine to use the CRC32 instruction to 
> +          gain performance compared with software implementation.
> +          Module will be crc32c-intel.
> +
>  config CRYPTO_MD4
>  	tristate "MD4 digest algorithm"
>  	select CRYPTO_ALGAPI

I think that should depend on CONFIG_X86? 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



