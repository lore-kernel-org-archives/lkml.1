Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab0BKUyI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:54:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36929 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab0BKUyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:54:06 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20100211953.850854588@firstfloor.org>
In-Reply-To: <20100211953.850854588@firstfloor.org>
To: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       haicheng.li@intel.com, rientjes@google.com
Subject: [PATCH] [3/4] SLAB: Set up the l3 lists for the memory of freshly added memory v2
Message-Id: <20100211205403.05A8EB1978@basil.firstfloor.org>
Date: Thu, 11 Feb 2010 21:54:03 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So kmalloc_node() works even if no CPU is up yet on the new node.

v2: Take cache chain mutex

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/slab.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

Index: linux-2.6.32-memhotadd/mm/slab.c
===================================================================
--- linux-2.6.32-memhotadd.orig/mm/slab.c
+++ linux-2.6.32-memhotadd/mm/slab.c
@@ -115,6 +115,7 @@
 #include	<linux/reciprocal_div.h>
 #include	<linux/debugobjects.h>
 #include	<linux/kmemcheck.h>
+#include	<linux/memory.h>
 
 #include	<asm/cacheflush.h>
 #include	<asm/tlbflush.h>
@@ -1554,6 +1555,23 @@ void __init kmem_cache_init(void)
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
+	if (action == MEM_ONLINE && mn->status_change_nid >= 0) {
+		mutex_lock(&cache_chain_mutex);
+		slab_node_prepare(mn->status_change_nid);
+		mutex_unlock(&cache_chain_mutex);
+	}
+	return NOTIFY_OK;
+}
+
 void __init kmem_cache_init_late(void)
 {
 	struct kmem_cache *cachep;
@@ -1577,6 +1595,8 @@ void __init kmem_cache_init_late(void)
 	 */
 	register_cpu_notifier(&cpucache_notifier);
 
+	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
+
 	/*
 	 * The reap timers are started later, with a module init call: That part
 	 * of the kernel is not yet operational.
