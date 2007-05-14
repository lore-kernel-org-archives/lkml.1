Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbXENXq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbXENXq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 19:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbXENXqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 19:46:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52072 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754611AbXENXqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 19:46:18 -0400
Date: Mon, 14 May 2007 16:46:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: mroos@linux.ee, David Miller <davem@davemloft.net>,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
In-Reply-To: <20070514.151148.45744375.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0705141642350.13606@schroedinger.engr.sgi.com>
References: <Pine.SOC.4.64.0705142133190.17204@math>
 <20070514.151148.45744375.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, David Miller wrote:

> From: Meelis Roos <mroos@linux.ee>
> Date: Mon, 14 May 2007 21:36:42 +0300 (EEST)
> 
> > Sorry, I could not test the parport patch yet - I did git upgrade as of 
> > yesterday and the kernel hangs on boot. boot -p reveals the following 
> > slab panic:
> 
> Please enable SLUB to work around this for now, SLAB wants
> LARGE_ALLOCS enabled when it really shouldn't require that
> for a 512K or 1MB SLAB when PAGE_SIZE==8192 :-(

Ok.

> > kmem_cache_create: Early error in slab tsb_512KB
> > kernel BUG at mm/slab.c:2165!
> 
> Christoph, this is why I had to have LARGE_ALLOCS enabled on sparc64
> all this time, for that MAX_OBJ_ORDER logic in mm/slab.c in order
> to get 512K and 1MB slab caches usable.

Hmmm... The #ifdef crap there has worried me for a long time. Lets try to 
clear that mess up too.
 
> This inconsistency is painful for platforms.  If I enable LARGE_ALLOCS
> on sparc64 then SLAB works but it's a total waste for SLUB.
> 
> Right now if I enable LARGE_ALLOCS, SLUB will break again due to
> that KMALLOC_SHIFT_HIGH bug we fixed the other week, Christophe
> can you at least push that fix to Linus if you haven't already?

No I thought you had it under control so I held it in my tree.

Andrew please push this patch upstream.



SLUB: CONFIG_LARGE_ALLOCS must consider MAX_ORDER limit

Take MAX_ORDER into consideration when determing KMALLOC_SHIFT_HIGH.
Otherwise we may run into a situation where we attempt to create
general slabs larger than MAX_ORDER.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: slub/include/linux/slub_def.h
===================================================================
--- slub.orig/include/linux/slub_def.h	2007-05-10 15:19:39.000000000 -0700
+++ slub/include/linux/slub_def.h	2007-05-10 16:06:15.000000000 -0700
@@ -59,7 +59,8 @@ struct kmem_cache {
 #define KMALLOC_SHIFT_LOW 3
 
 #ifdef CONFIG_LARGE_ALLOCS
-#define KMALLOC_SHIFT_HIGH 25
+#define KMALLOC_SHIFT_HIGH ((MAX_ORDER + PAGE_SHIFT) =< 25 ? \
+				MAX_ORDER + PAGE_SHIFT - 1 : 25)
 #else
 #if !defined(CONFIG_MMU) || NR_CPUS > 512 || MAX_NUMNODES > 256
 #define KMALLOC_SHIFT_HIGH 20
@@ -86,6 +87,9 @@ static inline int kmalloc_index(int size
 	 */
 	WARN_ON_ONCE(size == 0);
 
+	if (size >= (1UL << KMALLOC_SHIFT_HIGH))
+		return -1;
+
 	if (size > 64 && size <= 96)
 		return 1;
 	if (size > 128 && size <= 192)


