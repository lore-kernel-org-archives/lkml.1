Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZDTGMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZDTGMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 02:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZDTGMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 02:12:08 -0400
Received: from mail.renesas.com ([202.234.163.13]:35927 "EHLO
	mail02.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751526AbZDTGMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 02:12:07 -0400
X-AuditID: ac140385-0000000b000002de-df-49ec11fb3093
Date: Mon, 20 Apr 2009 15:11:12 +0900
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: [PATCH] RFC: mm: Fix build error SLBQ when CONFIG_SMP is not enable
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Paul Mundt <lethal@linux-sh.org>,
       Nick Piggin <npiggin@suse.de>
Message-id: <49EC1200.6020707@renesas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I fixed build error and tested source code base only,
because I don't know test method of SLAB.
Please give me an opinion about this revision.

Thanks,
 Nobuhiro

---

Kernel become build error, because functions depending on COMFIG_SMP enabled.

----
  CC      mm/slqb.o
mm/slqb.c: In function '__slab_free':
mm/slqb.c:1735: error: implicit declaration of function 'slab_free_to_remote'
mm/slqb.c: In function 'kmem_cache_open':
mm/slqb.c:2274: error: implicit declaration of function 'kmem_cache_dyn_array_free'
mm/slqb.c:2275: warning: label 'error_cpu_array' defined but not used
mm/slqb.c: In function 'kmem_cache_destroy':
mm/slqb.c:2395: error: implicit declaration of function 'claim_remote_free_list'
mm/slqb.c: In function 'kmem_cache_init':
mm/slqb.c:2885: error: 'per_cpu__kmem_cpu_nodes' undeclared (first use in this function)
mm/slqb.c:2885: error: (Each undeclared identifier is reported only once
mm/slqb.c:2885: error: for each function it appears in.)
mm/slqb.c:2886: error: 'kmem_cpu_cache' undeclared (first use in this function)
make[1]: *** [mm/slqb.o] Error 1
make: *** [mm] Error 2
----

Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Nick Piggin <npiggin@suse.de>
CC: Paul Mundt <lethal@linux-sh.org>
---
 mm/slqb.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/mm/slqb.c b/mm/slqb.c
index 37949f5..1858b3d 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -1728,7 +1728,7 @@ static __always_inline void __slab_free(struct kmem_cache *s,
 			flush_free_list(s, l);

 	} else {
-#ifdef CONFIG_NUMA
+#ifdef CONFIG_SMP
 		/*
 		 * Freeing an object that was allocated on a remote node.
 		 */
@@ -1937,7 +1937,9 @@ static DEFINE_PER_CPU(struct kmem_cache_node, kmem_cpu_nodes); /* XXX per-nid */

 #ifdef CONFIG_NUMA
 static struct kmem_cache kmem_node_cache;
+# ifdef CONFIG_SMP
 static DEFINE_PER_CPU(struct kmem_cache_cpu, kmem_node_cpus);
+# endif
 static DEFINE_PER_CPU(struct kmem_cache_node, kmem_node_nodes); /*XXX per-nid */
 #endif

@@ -2270,7 +2272,7 @@ static int kmem_cache_open(struct kmem_cache *s,
 error_nodes:
 	free_kmem_cache_nodes(s);
 error_node_array:
-#ifdef CONFIG_NUMA
+#if defined(CONFIG_NUMA) && defined(CONFIG_SMP)
 	kmem_cache_dyn_array_free(s->node_slab);
 error_cpu_array:
 #endif
@@ -2392,7 +2394,9 @@ void kmem_cache_destroy(struct kmem_cache *s)
 			continue;
 		l = &n->list;

+#ifdef CONFIG_SMP
 		claim_remote_free_list(s, l);
+#endif
 		flush_free_list_all(s, l);

 		WARN_ON(l->freelist.nr);
@@ -2623,7 +2627,9 @@ int kmem_cache_shrink(struct kmem_cache *s)
 		l = &n->list;

 		spin_lock_irq(&n->list_lock);
+#ifdef CONFIG_SMP
 		claim_remote_free_list(s, l);
+#endif
 		flush_free_list(s, l);
 		spin_unlock_irq(&n->list_lock);
 	}
@@ -2650,7 +2656,9 @@ static void kmem_cache_reap_percpu(void *arg)
 		}

 		if (phase == 1) {
+#ifdef CONFIG_SMP
 			claim_remote_free_list(s, l);
+#endif
 			flush_free_list_all(s, l);
 		}
 	}
@@ -2676,7 +2684,9 @@ static void kmem_cache_reap(void)
 			l = &n->list;

 			spin_lock_irq(&n->list_lock);
+#ifdef CONFIG_SMP
 			claim_remote_free_list(s, l);
+#endif
 			flush_free_list_all(s, l);
 			spin_unlock_irq(&n->list_lock);
 		}
@@ -2703,7 +2713,9 @@ static void cache_trim_worker(struct work_struct *w)
 			struct kmem_cache_list *l = &n->list;

 			spin_lock_irq(&n->list_lock);
+#ifdef CONFIG_SMP
 			claim_remote_free_list(s, l);
+#endif
 			flush_free_list(s, l);
 			spin_unlock_irq(&n->list_lock);
 		}
@@ -2881,11 +2893,11 @@ void __init kmem_cache_init(void)
 		n = &per_cpu(kmem_cache_nodes, i);
 		init_kmem_cache_node(&kmem_cache_cache, n);
 		kmem_cache_cache.node_slab[i] = n;
-
+#ifdef CONFIG_SMP
 		n = &per_cpu(kmem_cpu_nodes, i);
 		init_kmem_cache_node(&kmem_cpu_cache, n);
 		kmem_cpu_cache.node_slab[i] = n;
-
+#endif
 		n = &per_cpu(kmem_node_nodes, i);
 		init_kmem_cache_node(&kmem_node_cache, n);
 		kmem_node_cache.node_slab[i] = n;
-- 1.6.2.2
