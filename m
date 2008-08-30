Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYH3GXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYH3GXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 02:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYH3GXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 02:23:23 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:44801 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751357AbYH3GXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 02:23:22 -0400
Date: Sat, 30 Aug 2008 16:23:15 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, squashfs-devel@lists.sourceforge.net,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] crypto: Add a zlib crypto module
Message-ID: <20080830062315.GA18441@gondor.apana.org.au>
References: <20080829134158.108976037@vixen.sonytel.be> <20080829134418.874948211@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829134418.874948211@vixen.sonytel.be>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 01:41:59PM +0000, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> 
> Add a (de)compression module for the "zlib" format using the crypto API.

I think we can safely conclude that our current compression
interface sucks for what you're trying to achieve :)

> While both the "zlib" and "deflate" crypto modules are implemented on top of
> the zlib library, they differ in the following aspects:
>   - The "deflate" crypto module (used by IPSec and UBIFS) does not support
>     partial decompression, i.e. all compressed data has to be passed at once.
>     The "zlib" crypto module does support partial decompression;
>     zlib_decompress() will return -EAGAIN if not all compressed data has been
>     passed.
>   - The deflate crypto module uses the raw deflate data format (zlib is
>     initialized with a windowBits parameter of -DEFLATE_DEF_WINBITS = -11),
>     while e.g. squashfs and axfs use the zlib data format, with the default
>     windowBits parameter DEF_WBITS = 15.
>     Both parameters are incompatible with each other due to the different data
>     formats, as indicated by the sign of the windowbits parameter.
>     The absolute value of this parameter is the base two logarithm of the
>     maximum window size, and larger values are backwards compatible with
>     smaller values (as far as decompression is concerned).

Therefore I suggest that we change the interface rather than
mutilate the implementations.

So here are a few things we should add:

1) Separate alloc functions for comp/decomp to avoid the memory
   wastage you've identified.

2) Provide parameters to these alloc functions through an opaque
   pointer.  The format of the paramters will be determined by the
   name of the algorithm, i.e., if you want to change the parameters
   then you should change the name as well (e.g., deflate => deflate2).

   This removes the need to dupliate the implementation just because
   you want 15 instead of -11.

3) Provide init/update/final (one set each for comp and decomp)
   functions similar to crypto_hash, in addition to the current
   comp/decomp functions.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
