Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYKMTLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYKMTLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYKMTLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:11:39 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47171 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbYKMTLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:11:38 -0500
Date: Thu, 13 Nov 2008 21:11:35 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hugh@veritas.com, jens.axboe@oracle.com,
       paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, simon@fire.lp0.eu
Subject: [GIT PULL] SLAB updates for 2.6.28-rc4
Message-ID: <Pine.LNX.4.64.0811132106500.3487@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB git tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

The branch contains a small Kconfig help text update from Simon Arlott and a
documentation update for SLAB_DESTROY_BY_RCU from Peter Zijlstra.

                Pekka

Peter Zijlstra (1):
      slab: document SLAB_DESTROY_BY_RCU

Simon Arlott (1):
      Kconfig: SLUB is the default slab allocator

 include/linux/slab.h |   28 ++++++++++++++++++++++++++++
 init/Kconfig         |    6 +++---
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index ba965c8..000da12 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -23,6 +23,34 @@
 #define SLAB_CACHE_DMA		0x00004000UL	/* Use GFP_DMA memory */
 #define SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store the last owner for bug hunting */
 #define SLAB_PANIC		0x00040000UL	/* Panic if kmem_cache_create() fails */
+/*
+ * SLAB_DESTROY_BY_RCU - **WARNING** READ THIS!
+ *
+ * This delays freeing the SLAB page by a grace period, it does _NOT_
+ * delay object freeing. This means that if you do kmem_cache_free()
+ * that memory location is free to be reused at any time. Thus it may
+ * be possible to see another object there in the same RCU grace period.
+ *
+ * This feature only ensures the memory location backing the object
+ * stays valid, the trick to using this is relying on an independent
+ * object validation pass. Something like:
+ *
+ *  rcu_read_lock()
+ * again:
+ *  obj = lockless_lookup(key);
+ *  if (obj) {
+ *    if (!try_get_ref(obj)) // might fail for free objects
+ *      goto again;
+ *
+ *    if (obj->key != key) { // not the object we expected
+ *      put_ref(obj);
+ *      goto again;
+ *    }
+ *  }
+ *  rcu_read_unlock();
+ *
+ * See also the comment on struct slab_rcu in mm/slab.c.
+ */
 #define SLAB_DESTROY_BY_RCU	0x00080000UL	/* Defer freeing slabs to RCU */
 #define SLAB_MEM_SPREAD		0x00100000UL	/* Spread some memory over cpuset */
 #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
diff --git a/init/Kconfig b/init/Kconfig
index 86b00c5..226da27 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -771,8 +771,7 @@ config SLAB
 	help
 	  The regular slab allocator that is established and known to work
 	  well in all environments. It organizes cache hot objects in
-	  per cpu and per node queues. SLAB is the default choice for
-	  a slab allocator.
+	  per cpu and per node queues.
 
 config SLUB
 	bool "SLUB (Unqueued Allocator)"
@@ -781,7 +780,8 @@ config SLUB
 	   instead of managing queues of cached objects (SLAB approach).
 	   Per cpu caching is realized using slabs of objects instead
 	   of queues of objects. SLUB can use memory efficiently
-	   and has enhanced diagnostics.
+	   and has enhanced diagnostics. SLUB is the default choice for
+	   a slab allocator.
 
 config SLOB
 	depends on EMBEDDED
