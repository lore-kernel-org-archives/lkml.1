Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZK3RRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZK3RRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZK3RRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:17:43 -0500
Received: from smtp4.welho.com ([213.243.153.38]:38907 "EHLO smtp4.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZK3RRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:17:42 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] SLAB: Fix lockdep annotations for CPU hotplug
Date: Mon, 30 Nov 2009 19:17:30 +0200
Message-Id: <1259601450-4235-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Paul McKenney:

  I am seeing some lockdep complaints in rcutorture runs that include
  frequent CPU-hotplug operations.  The tests are otherwise successful.
  My first thought was to send a patch that gave each array_cache
  structure's ->lock field its own struct lock_class_key, but you already
  have a init_lock_keys() that seems to be intended to deal with this.

  ------------------------------------------------------------------------

  =============================================
  [ INFO: possible recursive locking detected ]
  2.6.32-rc4-autokern1 #1
  ---------------------------------------------
  syslogd/2908 is trying to acquire lock:
   (&nc->lock){..-...}, at: [<c0000000001407f4>] .kmem_cache_free+0x118/0x2d4

  but task is already holding lock:
   (&nc->lock){..-...}, at: [<c0000000001411bc>] .kfree+0x1f0/0x324

  other info that might help us debug this:
  3 locks held by syslogd/2908:
   #0:  (&u->readlock){+.+.+.}, at: [<c0000000004556f8>] .unix_dgram_recvmsg+0x70/0x338
   #1:  (&nc->lock){..-...}, at: [<c0000000001411bc>] .kfree+0x1f0/0x324
   #2:  (&parent->list_lock){-.-...}, at: [<c000000000140f64>] .__drain_alien_cache+0x50/0xb8

  stack backtrace:
  Call Trace:
  [c0000000e8ccafc0] [c0000000000101e4] .show_stack+0x70/0x184 (unreliable)
  [c0000000e8ccb070] [c0000000000afebc] .validate_chain+0x6ec/0xf58
  [c0000000e8ccb180] [c0000000000b0ff0] .__lock_acquire+0x8c8/0x974
  [c0000000e8ccb280] [c0000000000b2290] .lock_acquire+0x140/0x18c
  [c0000000e8ccb350] [c000000000468df0] ._spin_lock+0x48/0x70
  [c0000000e8ccb3e0] [c0000000001407f4] .kmem_cache_free+0x118/0x2d4
  [c0000000e8ccb4a0] [c000000000140b90] .free_block+0x130/0x1a8
  [c0000000e8ccb540] [c000000000140f94] .__drain_alien_cache+0x80/0xb8
  [c0000000e8ccb5e0] [c0000000001411e0] .kfree+0x214/0x324
  [c0000000e8ccb6a0] [c0000000003ca860] .skb_release_data+0xe8/0x104
  [c0000000e8ccb730] [c0000000003ca2ec] .__kfree_skb+0x20/0xd4
  [c0000000e8ccb7b0] [c0000000003cf2c8] .skb_free_datagram+0x1c/0x5c
  [c0000000e8ccb830] [c00000000045597c] .unix_dgram_recvmsg+0x2f4/0x338
  [c0000000e8ccb920] [c0000000003c0f14] .sock_recvmsg+0xf4/0x13c
  [c0000000e8ccbb30] [c0000000003c28ec] .SyS_recvfrom+0xb4/0x130
  [c0000000e8ccbcb0] [c0000000003bfb78] .sys_recv+0x18/0x2c
  [c0000000e8ccbd20] [c0000000003ed388] .compat_sys_recv+0x14/0x28
  [c0000000e8ccbd90] [c0000000003ee1bc] .compat_sys_socketcall+0x178/0x220
  [c0000000e8ccbe30] [c0000000000085d4] syscall_exit+0x0/0x40

This patch fixes the issue by setting up lockdep annotations during CPU
hotplug.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |  108 ++++++++++++++++++++++++++++++++++--------------------------
 1 files changed, 61 insertions(+), 47 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 7dfa481..84de47e 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -604,6 +604,26 @@ static struct kmem_cache cache_cache = {
 
 #define BAD_ALIEN_MAGIC 0x01020304ul
 
+/*
+ * chicken and egg problem: delay the per-cpu array allocation
+ * until the general caches are up.
+ */
+static enum {
+	NONE,
+	PARTIAL_AC,
+	PARTIAL_L3,
+	EARLY,
+	FULL
+} g_cpucache_up;
+
+/*
+ * used by boot code to determine if it can use slab based allocator
+ */
+int slab_is_available(void)
+{
+	return g_cpucache_up >= EARLY;
+}
+
 #ifdef CONFIG_LOCKDEP
 
 /*
@@ -620,40 +640,52 @@ static struct kmem_cache cache_cache = {
 static struct lock_class_key on_slab_l3_key;
 static struct lock_class_key on_slab_alc_key;
 
-static inline void init_lock_keys(void)
-
+static void init_node_lock_keys(int q)
 {
-	int q;
 	struct cache_sizes *s = malloc_sizes;
 
-	while (s->cs_size != ULONG_MAX) {
-		for_each_node(q) {
-			struct array_cache **alc;
-			int r;
-			struct kmem_list3 *l3 = s->cs_cachep->nodelists[q];
-			if (!l3 || OFF_SLAB(s->cs_cachep))
-				continue;
-			lockdep_set_class(&l3->list_lock, &on_slab_l3_key);
-			alc = l3->alien;
-			/*
-			 * FIXME: This check for BAD_ALIEN_MAGIC
-			 * should go away when common slab code is taught to
-			 * work even without alien caches.
-			 * Currently, non NUMA code returns BAD_ALIEN_MAGIC
-			 * for alloc_alien_cache,
-			 */
-			if (!alc || (unsigned long)alc == BAD_ALIEN_MAGIC)
-				continue;
-			for_each_node(r) {
-				if (alc[r])
-					lockdep_set_class(&alc[r]->lock,
-					     &on_slab_alc_key);
-			}
+	if (g_cpucache_up != FULL)
+		return;
+
+	for (s = malloc_sizes; s->cs_size != ULONG_MAX; s++) {
+		struct array_cache **alc;
+		struct kmem_list3 *l3;
+		int r;
+
+		l3 = s->cs_cachep->nodelists[q];
+		if (!l3 || OFF_SLAB(s->cs_cachep))
+			return;
+		lockdep_set_class(&l3->list_lock, &on_slab_l3_key);
+		alc = l3->alien;
+		/*
+		 * FIXME: This check for BAD_ALIEN_MAGIC
+		 * should go away when common slab code is taught to
+		 * work even without alien caches.
+		 * Currently, non NUMA code returns BAD_ALIEN_MAGIC
+		 * for alloc_alien_cache,
+		 */
+		if (!alc || (unsigned long)alc == BAD_ALIEN_MAGIC)
+			return;
+		for_each_node(r) {
+			if (alc[r])
+				lockdep_set_class(&alc[r]->lock,
+					&on_slab_alc_key);
 		}
-		s++;
 	}
 }
+
+static inline void init_lock_keys(void)
+{
+	int node;
+
+	for_each_node(node)
+		init_node_lock_keys(node);
+}
 #else
+static void init_node_lock_keys(int q)
+{
+}
+
 static inline void init_lock_keys(void)
 {
 }
@@ -665,26 +697,6 @@ static inline void init_lock_keys(void)
 static DEFINE_MUTEX(cache_chain_mutex);
 static struct list_head cache_chain;
 
-/*
- * chicken and egg problem: delay the per-cpu array allocation
- * until the general caches are up.
- */
-static enum {
-	NONE,
-	PARTIAL_AC,
-	PARTIAL_L3,
-	EARLY,
-	FULL
-} g_cpucache_up;
-
-/*
- * used by boot code to determine if it can use slab based allocator
- */
-int slab_is_available(void)
-{
-	return g_cpucache_up >= EARLY;
-}
-
 static DEFINE_PER_CPU(struct delayed_work, reap_work);
 
 static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
@@ -1254,6 +1266,8 @@ static int __cpuinit cpuup_prepare(long cpu)
 		kfree(shared);
 		free_alien_cache(alien);
 	}
+	init_node_lock_keys(node);
+
 	return 0;
 bad:
 	cpuup_canceled(cpu);
-- 
1.6.3.3

