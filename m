Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbXJLCaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbXJLCaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 22:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXJLCaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 22:30:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55022 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbXJLCaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 22:30:04 -0400
Date: Fri, 12 Oct 2007 11:29:39 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@osdl.org>
Subject: [Patch 002/002] Create/delete kmem_cache_node for SLUB on memory online callback
Cc: Christoph Lameter <clameter@sgi.com>,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20071012112236.B99B.Y-GOTO@jp.fujitsu.com>
References: <20071012111008.B995.Y-GOTO@jp.fujitsu.com> <20071012112236.B99B.Y-GOTO@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071012112801.B9A1.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is to make kmem_cache_nodes of all SLUBs for new node when 
memory-hotadd is called. This fixes panic due to access NULL pointer at
discard_slab() after memory hot-add.

If pages on the new node available, slub can use it before making
new kmem_cache_nodes. So, this callback should be called
BEFORE pages on the node are available.

When memory online is called, slab_mem_going_online_callback() is
called to make kmem_cache_node(). if it (or other callbacks) fails,
then slab_mem_offline_callback() is called for rollback.

In memory offline, slab_mem_going_offline_callback() is called to
shrink cache, then slab_mem_offline_callback() is called later.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>

---
 mm/slub.c |  117 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

Index: current/mm/slub.c
===================================================================
--- current.orig/mm/slub.c	2007-10-11 20:31:37.000000000 +0900
+++ current/mm/slub.c	2007-10-11 21:58:10.000000000 +0900
@@ -20,6 +20,7 @@
 #include <linux/mempolicy.h>
 #include <linux/ctype.h>
 #include <linux/kallsyms.h>
+#include <linux/memory.h>
 
 /*
  * Lock order:
@@ -2711,6 +2712,120 @@ int kmem_cache_shrink(struct kmem_cache 
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
+#if defined(CONFIG_NUMA) && defined(CONFIG_MEMORY_HOTPLUG)
+static int slab_mem_going_offline_callback(void *arg)
+{
+	struct kmem_cache *s;
+	struct memory_notify *marg = arg;
+	int local_node, offline_node = marg->status_change_nid;
+
+	if (offline_node < 0)
+		/* node has memory yet. nothing to do. */
+		return 0;
+
+	down_read(&slub_lock);
+	list_for_each_entry(s, &slab_caches, list) {
+		local_node = page_to_nid(virt_to_page(s));
+		if (local_node == offline_node)
+			/* This slub is on the offline node. */
+			return -EBUSY;
+	}
+	up_read(&slub_lock);
+
+	kmem_cache_shrink_node(s, offline_node);
+
+	return 0;
+}
+
+static void slab_mem_offline_callback(void *arg)
+{
+	struct kmem_cache_node *n;
+	struct kmem_cache *s;
+	struct memory_notify *marg = arg;
+	int offline_node;
+
+	offline_node = marg->status_change_nid;
+
+	if (offline_node < 0)
+		/* node has memory yet. nothing to do. */
+		return;
+
+	down_read(&slub_lock);
+	list_for_each_entry(s, &slab_caches, list) {
+		n = get_node(s, offline_node);
+		if (n) {
+			/*
+			 * if n->nr_slabs > 0, offline_pages() must be fail,
+			 * because the node is used by slub yet.
+			 */
+			BUG_ON(atomic_read(&n->nr_slabs));
+
+			s->node[offline_node] = NULL;
+			kmem_cache_free(kmalloc_caches, n);
+		}
+	}
+	up_read(&slub_lock);
+}
+
+static int slab_mem_going_online_callback(void *arg)
+{
+	struct kmem_cache_node *n;
+	struct kmem_cache *s;
+	struct memory_notify *marg = arg;
+	int nid = marg->status_change_nid;
+
+	/* If the node already has memory, then nothing is necessary. */
+	if (nid < 0)
+		return 0;
+
+	/*
+	 * New memory will be onlined on the node which has no memory so far.
+	 * New kmem_cache_node is necssary for it.
+	 */
+	down_read(&slub_lock);
+	list_for_each_entry(s, &slab_caches, list) {
+  		/*
+		 * XXX: The new node's memory can't be allocated yet,
+		 *      kmem_cache_node will be allocated other node.
+  		 */
+		n = kmem_cache_alloc(kmalloc_caches, GFP_KERNEL);
+		if (!n)
+			return -ENOMEM;
+		init_kmem_cache_node(n);
+		s->node[nid] = n;
+  	}
+	up_read(&slub_lock);
+
+  	return 0;
+}
+
+static int slab_memory_callback(struct notifier_block *self,
+				unsigned long action, void *arg)
+{
+	int ret = 0;
+
+	switch (action) {
+	case MEM_GOING_ONLINE:
+		ret = slab_mem_going_online_callback(arg);
+		break;
+	case MEM_GOING_OFFLINE:
+		ret = slab_mem_going_offline_callback(arg);
+		break;
+	case MEM_OFFLINE:
+	case MEM_CANCEL_ONLINE:
+		slab_mem_offline_callback(arg);
+		break;
+	case MEM_ONLINE:
+	case MEM_CANCEL_OFFLINE:
+		break;
+	}
+
+	ret = notifier_from_errno(ret);
+	return ret;
+}
+
+#endif /* CONFIG_MEMORY_HOTPLUG */
+
 /********************************************************************
  *			Basic setup of slabs
  *******************************************************************/
@@ -2741,6 +2856,8 @@ void __init kmem_cache_init(void)
 		sizeof(struct kmem_cache_node), GFP_KERNEL);
 	kmalloc_caches[0].refcount = -1;
 	caches++;
+
+	hotplug_memory_notifier(slab_memory_callback, 1);
 #endif
 
 	/* Able to allocate the per node structures */

-- 
Yasunori Goto 


