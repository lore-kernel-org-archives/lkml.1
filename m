Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbZEYME1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbZEYME1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZEYMEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:04:20 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56144 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbZEYMET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:04:19 -0400
Date: Mon, 25 May 2009 15:04:20 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       mpm@selenic.com
Subject: Re: [GIT PULL] scheduler fixes
In-Reply-To: <20090525114127.GE24071@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0905251503480.4279@melkki.cs.Helsinki.FI>
References: <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
 <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI> <4A199327.5030503@kernel.org>
 <20090525025353.GA2580@elte.hu> <4A1A2261.1000504@kernel.org>
 <20090525051521.GC23032@elte.hu> <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI>
 <20090525112504.GB24071@wotan.suse.de> <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com>
 <20090525114127.GE24071@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, May 25, 2009 at 02:37:59PM +0300, Pekka Enberg wrote:
> > On Mon, May 25, 2009 at 2:25 PM, Nick Piggin <npiggin@suse.de> wrote:
> > > The bootmem allocations of course are required because some hashes may
> > > need to be larger than MAX_ORDER without using vmalloc.
> > >
> > > kmem_cache_init (and mem_init, partially) sets up the kernel memory
> > > allocators...
> > 
> > Which comment are you talking about? The "setup kernel memory
> > allocators" one? Yeah, I should probably move it couple of lines down.
 
On Mon, 25 May 2009, Nick Piggin wrote:
> Yes, just that one.

And oh, we probably want to do this too while at it. Nick?

>From b211497261670ff6f9af6b8b0fab429e848ccc87 Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Mon, 25 May 2009 15:01:35 +0300
Subject: [PATCH] vmalloc: use kzalloc() instead of alloc_bootmem()

We can call vmalloc_init() after kmem_cache_init() and use kzalloc() instead of
the bootmem allocator when initializing vmalloc data structures.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 init/main.c  |    2 +-
 mm/vmalloc.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/init/main.c b/init/main.c
index fb0e004..766194c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -585,13 +585,13 @@ asmlinkage void __init start_kernel(void)
 		   __stop___param - __start___param,
 		   &unknown_bootoption);
 	pidhash_init();
-	vmalloc_init();
 	vfs_caches_init_early();
 	/*
 	 * Set up kernel memory allocators
 	 */
 	mem_init();
 	kmem_cache_init();
+	vmalloc_init();
 	/*
 	 * Set up the scheduler prior starting any interrupts (such as the
 	 * timer interrupt). Full topology setup happens at smp_init()
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 083716e..3235138 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -23,7 +23,6 @@
 #include <linux/rbtree.h>
 #include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
-#include <linux/bootmem.h>
 #include <linux/pfn.h>
 
 #include <asm/atomic.h>
@@ -1032,7 +1031,7 @@ void __init vmalloc_init(void)
 
 	/* Import existing vmlist entries. */
 	for (tmp = vmlist; tmp; tmp = tmp->next) {
-		va = alloc_bootmem(sizeof(struct vmap_area));
+		va = kzalloc(sizeof(struct vmap_area), GFP_NOWAIT);
 		va->flags = tmp->flags | VM_VM_AREA;
 		va->va_start = (unsigned long)tmp->addr;
 		va->va_end = va->va_start + tmp->size;
-- 
1.6.0.4

