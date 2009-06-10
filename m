Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbZFJR6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbZFJR6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbZFJR6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:58:38 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39870 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbZFJR6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:58:37 -0400
Date: Wed, 10 Jun 2009 20:58:40 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
cc: cl@linux-foundation.com, mingo@elte.hu, hannes@cmpxchg.org,
       torvalds@linux-foundation.org, mpm@selenic.com, npiggin@suse.de,
       yinghai@kernel.org
Subject: [PATCH 3/3] vmalloc: use kzalloc() instead of alloc_bootmem()
Message-ID: <Pine.LNX.4.64.0906102058060.28361@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

We can call vmalloc_init() after kmem_cache_init() and use kzalloc() instead of
the bootmem allocator when initializing vmalloc data structures.

Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 init/main.c  |    2 +-
 mm/vmalloc.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/init/main.c b/init/main.c
index 8be5193..0c6f366 100644
--- a/init/main.c
+++ b/init/main.c
@@ -587,13 +587,13 @@ asmlinkage void __init start_kernel(void)
 	 * kmem_cache_init()
 	 */
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

