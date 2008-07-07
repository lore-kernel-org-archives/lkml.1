Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYGGKom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYGGKom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 06:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYGGKod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 06:44:33 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:56820 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752663AbYGGKod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 06:44:33 -0400
Date: Mon, 7 Jul 2008 18:44:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: austin zhang <austin_zhang@linux.intel.com>
Cc: davem@davemloft.net, chaapala@cisco.com, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com
Subject: Re: [Fwd: [PATCH]Using Intel CRC32 instruction to implement hardware accelerated CRC32c algorithm.]
Message-ID: <20080707104425.GA10924@gondor.apana.org.au>
References: <1215422258.19059.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215422258.19059.26.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 05:17:38AM -0400, austin zhang wrote:
>  From NHM processor onward, Intel processors can support hardware accelerated
>  CRC32c algorithm with the new CRC32 instruction in SSE 4.2 instruction set. 
>  The patch detects the availability of the feature, and chooses the most proper 
>  way to calculate CRC32c checksum.
>  Byte code instructions are used for compiler compatibility. No MMX / XMM 
>  registers is involved in the implementation.
>  
>  After basic testing with iSCSI and confirmed that the iSCSI head digest 
>  routines can be speeded up by 4x - 10x.
>  
>  This patch is created against mainline 2.6.26-rc8
> 
>  Signed-off-by: Austin Zhang <austin_zhang@linux.intel.com>
>  Signed-off-by: Kent Liu <kent.liu@linux.intel.com>

Thanks Austin! I love the idea :)

However, the way it's done in lib is a bit iffy.  For a start
testing an x86-specific variable at run-time is not a goer. In
any case, supporting hardware implementations transparently is
what the crypto API is meant to do so why don't we just use that.

I've done a grep on the users of crc32c.  I think what we should
do is:

1) Utilise the brand new crypto ahash interface (note that it's
designed to support sync just as well as async despite the name)
to rewrite the crypto/crc32c implementation such that one tfm can
be used by multiple users.  All that has to be done is to move
the state from the tfm into the request object.

2) Convert all crc32c users to use the crypto interface and phase
out lib/crc32c completely.

3) Add the Intel-specific crc32c implementation through the crypto
API.

That way none of this iffy testing will be necessary.  Even better,
most users can share one common tfm and therefore there will only
be one test for the CPU flag at boot time rather than every time
it's used.

In fact, we could even skip 2) and reimplement lib/crc32c as a
wrapper on the crypto crc32c interface with a shared tfm so you
don't need to modify its existing users.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
