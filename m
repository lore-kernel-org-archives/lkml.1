Return-Path: <linux-kernel-owner+w=401wt.eu-S1761336AbZFLPlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336AbZFLPlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761439AbZFLPlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:41:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60192 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbZFLPl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:41:29 -0400
Date: Fri, 12 Jun 2009 18:41:31 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       cl@linux-foundation.org, akpm@linux-foundation.org, npiggin@suse.de,
       benh@kernel.crashing.org
Subject: [PATCH 3/3] slab: setup cpu caches later on when interrupts are
 enabled
Message-ID: <Pine.LNX.4.64.0906121841150.5491@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Fixes the following boot-time warning:

  [    0.000000] ------------[ cut here ]------------
  [    0.000000] WARNING: at kernel/smp.c:369 smp_call_function_many+0x56/0x1bc()
  [    0.000000] Hardware name:
  [    0.000000] Modules linked in:
  [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30 #492
  [    0.000000] Call Trace:
  [    0.000000]  [<ffffffff8149e021>] ? _spin_unlock+0x4f/0x5c
  [    0.000000]  [<ffffffff8108f11b>] ? smp_call_function_many+0x56/0x1bc
  [    0.000000]  [<ffffffff81061764>] warn_slowpath_common+0x7c/0xa9
  [    0.000000]  [<ffffffff810617a5>] warn_slowpath_null+0x14/0x16
  [    0.000000]  [<ffffffff8108f11b>] smp_call_function_many+0x56/0x1bc
  [    0.000000]  [<ffffffff810f3e00>] ? do_ccupdate_local+0x0/0x54
  [    0.000000]  [<ffffffff810f3e00>] ? do_ccupdate_local+0x0/0x54
  [    0.000000]  [<ffffffff8108f2be>] smp_call_function+0x3d/0x68
  [    0.000000]  [<ffffffff810f3e00>] ? do_ccupdate_local+0x0/0x54
  [    0.000000]  [<ffffffff81066fd8>] on_each_cpu+0x31/0x7c
  [    0.000000]  [<ffffffff810f64f5>] do_tune_cpucache+0x119/0x454
  [    0.000000]  [<ffffffff81087080>] ? lockdep_init_map+0x94/0x10b
  [    0.000000]  [<ffffffff818133b0>] ? kmem_cache_init+0x421/0x593
  [    0.000000]  [<ffffffff810f69cf>] enable_cpucache+0x68/0xad
  [    0.000000]  [<ffffffff818133c3>] kmem_cache_init+0x434/0x593
  [    0.000000]  [<ffffffff8180987c>] ? mem_init+0x156/0x161
  [    0.000000]  [<ffffffff817f8aae>] start_kernel+0x1cc/0x3b9
  [    0.000000]  [<ffffffff817f829a>] x86_64_start_reservations+0xaa/0xae
  [    0.000000]  [<ffffffff817f837f>] x86_64_start_kernel+0xe1/0xe8
  [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slab.c |   37 +++++++++++++++++++------------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 6c0c4df..f1e9f05 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -759,6 +759,7 @@ static enum {
 	NONE,
 	PARTIAL_AC,
 	PARTIAL_L3,
+	EARLY,
 	FULL
 } g_cpucache_up;
 
@@ -767,7 +768,7 @@ static enum {
  */
 int slab_is_available(void)
 {
-	return g_cpucache_up == FULL;
+	return g_cpucache_up >= EARLY;
 }
 
 static DEFINE_PER_CPU(struct delayed_work, reap_work);
@@ -1631,19 +1632,27 @@ void __init kmem_cache_init(void)
 		}
 	}
 
-	/* 6) resize the head arrays to their final sizes */
-	{
-		struct kmem_cache *cachep;
-		mutex_lock(&cache_chain_mutex);
-		list_for_each_entry(cachep, &cache_chain, next)
-			if (enable_cpucache(cachep, GFP_NOWAIT))
-				BUG();
-		mutex_unlock(&cache_chain_mutex);
-	}
+	g_cpucache_up = EARLY;
 
 	/* Annotate slab for lockdep -- annotate the malloc caches */
 	init_lock_keys();
+}
+
+void __init kmem_cache_init_late(void)
+{
+	struct kmem_cache *cachep;
+
+	/*
+	 * Interrupts are enabled now so all GFP allocations are safe.
+	 */
+	slab_gfp_mask = __GFP_BITS_MASK;
 
+	/* 6) resize the head arrays to their final sizes */
+	mutex_lock(&cache_chain_mutex);
+	list_for_each_entry(cachep, &cache_chain, next)
+		if (enable_cpucache(cachep, GFP_NOWAIT))
+			BUG();
+	mutex_unlock(&cache_chain_mutex);
 
 	/* Done! */
 	g_cpucache_up = FULL;
@@ -1660,14 +1669,6 @@ void __init kmem_cache_init(void)
 	 */
 }
 
-void __init kmem_cache_init_late(void)
-{
-	/*
-	 * Interrupts are enabled now so all GFP allocations are safe.
-	 */
-	slab_gfp_mask = __GFP_BITS_MASK;
-}
-
 static int __init cpucache_init(void)
 {
 	int cpu;
-- 
1.6.0.4

