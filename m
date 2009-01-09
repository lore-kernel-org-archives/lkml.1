Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbZAIHCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbZAIHCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 02:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZAIHBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 02:01:51 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:41170 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751880AbZAIHBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 02:01:50 -0500
Date: Fri, 9 Jan 2009 18:01:44 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Message-ID: <20090109070144.GA7358@gondor.apana.org.au>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 10:02:27AM +0800, Huang Ying wrote:
> 
> - Rename file name and function name to aesni_<xx>
> 
> - Move to arch/x86/crypto.
> 
> - ECB and CBC modes are implemented in parallel style to take
>   advantage of pipelined hardware implementation.
> 
> - AES key scheduling algorithm is re-implemented with higher
>   performance.

Thanks this is all good.

> - ablkcipher asynchronous machanism is used to delay a crypto request
>   to work queue context upon FPU state is using by other kernel
>   context.

Actually I was thinking of something as simple as just using
cryptd as is.  That is, register a blkcipher algorithm for your
version of cbc-aes, but don't register under the name cbc(aes),
e.g., register it under the name of __cbc-aes-aesni for both alg
name and driver name.  You can register it under cbc(aes) too
if you add the fallback in there.

Then for the real thing, just allocate the blkcipher __cbc_*,
plus the ablkcipher cryptd(__cbc_*), and invoke the right one
depending on caller context.

This is even simpler for the modes which you don't implement.
In that case you would just allocate FOO(aes-aesni) in conjunction
with cryptd(FOO(aes-aesni)).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
