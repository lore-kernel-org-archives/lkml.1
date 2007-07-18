Return-Path: <linux-kernel-owner+w=401wt.eu-S934455AbXGRATM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934455AbXGRATM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbXGRAS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:18:58 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:35026 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757732AbXGRAS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:18:57 -0400
Date: Wed, 18 Jul 2007 09:18:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: clameter@sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.23 compile failure - slab/slob interspanking
Message-ID: <20070718001836.GA30154@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jan Engelhardt <jengelh@computergmbh.de>, clameter@sgi.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matt Mackall <mpm@selenic.com>
References: <Pine.LNX.4.64.0707172148310.27468@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707172148310.27468@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 10:00:08PM +0200, Jan Engelhardt wrote:
> 81cda6626178cd55297831296ba8ecedbfd8b52d is first bad commit
> commit 81cda6626178cd55297831296ba8ecedbfd8b52d
> Author: Christoph Lameter <clameter@sgi.com>
> Date:   Tue Jul 17 04:03:29 2007 -0700
> 
>     Slab allocators: Cleanup zeroing allocations
>     
>     It becomes now easy to support the zeroing allocs with generic inline
>     functions in slab.h.  Provide inline definitions to allow the continued use of
>     kzalloc, kmem_cache_zalloc etc but remove other definitions of zeroing
>     functions from the slab allocators and util.c.
>     
>     Signed-off-by: Christoph Lameter <clameter@sgi.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
This fixes it for me with your .config:

slob: Kill off duplicate kzalloc() definition.

With the slab zeroing allocations cleanups Christoph stubbed in a generic
kzalloc(), which was missed on SLOB. Follow the SLAB/SLUB changes and
kill off the __kzalloc() wrapper that SLOB was using.

Reported-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 include/linux/slob_def.h |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/slob_def.h b/include/linux/slob_def.h
index a2daf2d..59a3fa4 100644
--- a/include/linux/slob_def.h
+++ b/include/linux/slob_def.h
@@ -33,14 +33,4 @@ static inline void *__kmalloc(size_t size, gfp_t flags)
 	return kmalloc(size, flags);
 }
 
-/**
- * kzalloc - allocate memory. The memory is set to zero.
- * @size: how many bytes of memory are required.
- * @flags: the type of memory to allocate (see kcalloc).
- */
-static inline void *kzalloc(size_t size, gfp_t flags)
-{
-	return __kzalloc(size, flags);
-}
-
 #endif /* __LINUX_SLOB_DEF_H */
