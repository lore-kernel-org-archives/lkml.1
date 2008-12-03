Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYLCXW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYLCXW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYLCXWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:22:48 -0500
Received: from ozlabs.org ([203.10.76.45]:54347 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbYLCXWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:22:47 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Yet more ARM breakage in linux-next
Date: Thu, 4 Dec 2008 09:52:44 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <20081203192905.GA12502@flint.arm.linux.org.uk> <20081203124109.79f8f15b.akpm@linux-foundation.org>
In-Reply-To: <20081203124109.79f8f15b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812040952.44957.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008 07:11:09 Andrew Morton wrote:
> On Wed, 3 Dec 2008 19:29:05 +0000
>
> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > This seems to be causing lots of ARM breakage:
> >
> > lib/find_next_bit.c:183: error: implicit declaration of function '__fls'
> >
> > Whoever's responsible,
>
> git-blame?

It's me.  Turns out sparc, avr32 and arm all don't define __fls in their
asm/bitops.h, and I'm the first one to use it in generic code.

But as I prepared this patch, I note that the armv5 __fls/fls is wrong:

  /* Implement fls() in C so that 64-bit args are suitably truncated */
  static inline int fls(int x)
  {
      return __fls(x);
  }

__fls(x) returns a bit number (0-31).  fls() returns 0 or bitnumber+1.

(Yes, classic useless kerneldoc documentation doesn't actually *say* 
this clearly).

But here's the linux-next fix:

arm: define __fls for pre v5 ARM

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -239,6 +239,7 @@ extern int _find_next_bit_be(const unsig
 #include <asm-generic/bitops/ffz.h>
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/__fls.h>
 #include <asm-generic/bitops/ffs.h>
 
 #else

