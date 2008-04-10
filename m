Return-Path: <linux-kernel-owner+w=401wt.eu-S1759420AbYDJXkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420AbYDJXkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbYDJXj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:39:58 -0400
Received: from ozlabs.org ([203.10.76.45]:47453 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758025AbYDJXj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:39:57 -0400
To: <linux-kernel@vger.kernel.org>
CC: Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>,
       <takata@linux-m32r.org>, <linux-m32r@ml.linux-m32r.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@ozlabs.org>
Date: Fri, 11 Apr 2008 09:36:40 +1000
Subject: [PATCH 2/2] [POWERPC] Fix kernel stack allocation alignment
Message-Id: <20080410233741.A50A5DE39A@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The powerpc kernel stacks need to be naturally aligned, as they
contain the thread info at the bottom, which is obtained by
clearing the low bits of the stack pointer.

However, when using 64K pages (the stack is smaller than a page),
we use kmalloc to allocate it, which doesn't provide that guarantee.

It appeared to work so far... until one enables SLUB debugging
which then returns unaligned pointers. Ooops...

This patch fixes it by using a slab cache with enforced alignment
for those. It replies on my previous patch that adds a
thread_info_cache_init() callback.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

---
Note that m32r seems to also have this problem.

 arch/powerpc/kernel/process.c     |   31 +++++++++++++++++++++++++++++++
 include/asm-powerpc/thread_info.h |   10 ++++------
 2 files changed, 35 insertions(+), 6 deletions(-)

--- linux-work.orig/arch/powerpc/kernel/process.c	2008-04-10 13:11:05.000000000 +1000
+++ linux-work/arch/powerpc/kernel/process.c	2008-04-10 13:14:29.000000000 +1000
@@ -1052,3 +1052,34 @@ void ppc64_runlatch_off(void)
 	}
 }
 #endif
+
+#if THREAD_SHIFT < PAGE_SHIFT
+
+static struct kmem_cache *thread_info_cache;
+
+struct thread_info *alloc_thread_info(struct task_struct *tsk)
+{
+	struct thread_info *ti;
+
+	ti = kmem_cache_alloc(thread_info_cache, GFP_KERNEL);
+	if (unlikely(ti == NULL))
+		return NULL;
+#ifdef CONFIG_DEBUG_STACK_USAGE
+	memset(ti, 0, THREAD_SIZE);
+#endif
+	return ti;
+}
+
+void free_thread_info(struct thread_info *ti)
+{
+	kmem_cache_free(thread_info_cache, ti);
+}
+
+void thread_info_cache_init(void)
+{
+	thread_info_cache = kmem_cache_create("thread_info", THREAD_SIZE,
+					      THREAD_SIZE, 0, NULL);
+	BUG_ON(thread_info_cache == NULL);
+}
+
+#endif /* THREAD_SHIFT < PAGE_SHIFT */
Index: linux-work/include/asm-powerpc/thread_info.h
===================================================================
--- linux-work.orig/include/asm-powerpc/thread_info.h	2008-04-10 13:11:05.000000000 +1000
+++ linux-work/include/asm-powerpc/thread_info.h	2008-04-10 13:14:47.000000000 +1000
@@ -80,12 +80,10 @@ struct thread_info {
 
 #else /* THREAD_SHIFT < PAGE_SHIFT */
 
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk)	kzalloc(THREAD_SIZE, GFP_KERNEL)
-#else
-#define alloc_thread_info(tsk)	kmalloc(THREAD_SIZE, GFP_KERNEL)
-#endif
-#define free_thread_info(ti)	kfree(ti)
+extern struct thread_info *alloc_thread_info(struct task_struct *tsk);
+extern void free_thread_info(struct thread_info *ti);
+extern void thread_info_cache_init(void);
+#define thread_info_cache_init thread_info_cache_init
 
 #endif /* THREAD_SHIFT < PAGE_SHIFT */
 
