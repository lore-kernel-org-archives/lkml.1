Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab0BCVjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 16:39:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42219 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637Ab0BCVjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 16:39:16 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201002031039.710275915@firstfloor.org>
In-Reply-To: <201002031039.710275915@firstfloor.org>
To: submit@firstfloor.org, linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       penberg@cs.helsinki.fi, linux-mm@kvack.org
Subject: [PATCH] [2/4] SLAB: Set up the l3 lists for the memory of freshly added memory
Message-Id: <20100203213913.D5CD4B1620@basil.firstfloor.org>
Date: Wed,  3 Feb 2010 22:39:13 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So kmalloc_node() works even if no CPU is up yet on the new node.

Requires previous refactor patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/slab.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux-2.6.33-rc3-ak/mm/slab.c
===================================================================
--- linux-2.6.33-rc3-ak.orig/mm/slab.c
+++ linux-2.6.33-rc3-ak/mm/slab.c
@@ -115,6 +115,7 @@
 #include	<linux/reciprocal_div.h>
 #include	<linux/debugobjects.h>
 #include	<linux/kmemcheck.h>
+#include	<linux/memory.h>
 
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
@@ -1560,6 +1561,20 @@ void __init kmem_cache_init(void)
 	g_cpucache_up = EARLY;
 }
 
+static int slab_memory_callback(struct notifier_block *self,
+				unsigned long action, void *arg)
+{
+	struct memory_notify *mn = (struct memory_notify *)arg;
+
+	/*
+	 * When a node goes online allocate l3s early.	 This way
+	 * kmalloc_node() works for it.
+	 */
+	if (action == MEM_ONLINE && mn->status_change_nid >= 0)
+		slab_node_prepare(mn->status_change_nid);
+	return NOTIFY_OK;
+}
+
 void __init kmem_cache_init_late(void)
 {
 	struct kmem_cache *cachep;
@@ -1583,6 +1598,8 @@ void __init kmem_cache_init_late(void)
 	 */
 	register_cpu_notifier(&cpucache_notifier);
 
+	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
+
 	/*
 	 * The reap timers are started later, with a module init call: That part
 	 * of the kernel is not yet operational.
