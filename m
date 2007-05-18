Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbXERHIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbXERHIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbXERHIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:08:31 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4229 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756035AbXERHI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:08:29 -0400
Date: Fri, 18 May 2007 17:08:23 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Benjamin Gilbert <bgilbert@cs.cmu.edu>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] x86-optimized SHA1 hash for CryptoAPI
Message-ID: <20070518070822.GA17928@gondor.apana.org.au>
References: <20061023175020.23fabf00.bgilbert@cs.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061023175020.23fabf00.bgilbert@cs.cmu.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bejamin:

On Mon, Oct 23, 2006 at 05:50:20PM -0400, Benjamin Gilbert wrote:
> This is a new CryptoAPI module containing an x86-optimized implementation of
> SHA1, taken from Nettle.

Thanks for the patch! Sorry for the very late response.  I just
discovered this while cleaning up my mailbox :)
 
> 1.  Recognizing that arch/i386/crypto/sha1.c contains almost the same
> functionality as crypto/sha1.c, I could abstract out common code between the
> two implementations.  However, given the length of the files in question, I
> suspect the complexity isn't worth it.  In-tree, AES uses duplicated code
> between the asm and C versions, while Twofish pulls out common code into a
> separate module.

Considering the simplicity of sha1.c, I'd say that you should just
duplicate it.

> 2.  Since the optimized part of the code is the SHA1 compression function,
> and since crypto/sha1.c is just a wrapper around the compression function in
> lib/sha1.c, I could eliminate the separate CryptoAPI module and switch the
> kernel between the C and asm compression functions based on a config option
> -- so that all SHA1 users get the optimized version, instead of just
> CryptoAPI.  There is an API issue though: the optimized code needs to
> allocate its workspace on the stack for register-allocation reasons, and the
> C version expects the caller to allocate a temporary buffer (to minimize the
> number of times the workspace needs to be cleared when hashing several times
> in a row).  If the optimized code was used with the current API, the caller
> would be doing a bunch of allocation and clearing for nothing.  (Note: the
> only direct users of lib/sha1.c right now are /dev/random and syncookies.)
> 
> Which (if any) is the preferred approach?

I think the best solution is to replace SHA_WORKSPACE_WORDS with an
inline function/macro that returns zero for the optimised version.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
