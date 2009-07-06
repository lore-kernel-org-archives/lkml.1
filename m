Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZGFH5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZGFH5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 03:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbZGFH5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 03:57:00 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39733 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbZGFH47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 03:56:59 -0400
Date: Mon, 6 Jul 2009 10:57:01 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hawk@comx.dk, mpm@selenic.com,
       paulmck@linux.vnet.ibm.com, stable@kernel.org,
       venkatesh.pallipadi@intel.com
Subject: [GIT PULL] SLAB fixes for 2.6.31-rc2
Message-ID: <Pine.LNX.4.64.0907061054430.6925@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a regression fix for SLAB lockdep annotation breakage caused by the 
early slab patches and a fix for kmem_cache_destroy() RCU problems from 
Paul McKenney.

			Pekka

The following changes since commit 8e4a718ff38d8539938ec3421935904c27e00c39:
  Linus Torvalds (1):
        Linux 2.6.31-rc2

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 for-linus

Paul E. McKenney (1):
      fix RCU-callback-after-kmem_cache_destroy problem in sl[aou]b

Pekka Enberg (2):
      SLAB: Fix lockdep annotations
      Merge branch 'slab/urgent' into for-linus

 mm/slab.c |    8 ++++----
 mm/slob.c |    2 ++
 mm/slub.c |    2 ++
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index e74a16e..7b5d4de 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1544,9 +1544,6 @@ void __init kmem_cache_init(void)
 	}
 
 	g_cpucache_up = EARLY;
-
-	/* Annotate slab for lockdep -- annotate the malloc caches */
-	init_lock_keys();
 }
 
 void __init kmem_cache_init_late(void)
@@ -1563,6 +1560,9 @@ void __init kmem_cache_init_late(void)
 	/* Done! */
 	g_cpucache_up = FULL;
 
+	/* Annotate slab for lockdep -- annotate the malloc caches */
+	init_lock_keys();
+
 	/*
 	 * Register a cpu startup notifier callback that initializes
 	 * cpu_cache_get for all new cpus
@@ -2547,7 +2547,7 @@ void kmem_cache_destroy(struct kmem_cache *cachep)
 	}
 
 	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU))
-		synchronize_rcu();
+		rcu_barrier();
 
 	__kmem_cache_destroy(cachep);
 	mutex_unlock(&cache_chain_mutex);
diff --git a/mm/slob.c b/mm/slob.c
index c78742d..9641da3 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -595,6 +595,8 @@ EXPORT_SYMBOL(kmem_cache_create);
 void kmem_cache_destroy(struct kmem_cache *c)
 {
 	kmemleak_free(c);
+	if (c->flags & SLAB_DESTROY_BY_RCU)
+		rcu_barrier();
 	slob_free(c, sizeof(struct kmem_cache));
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
diff --git a/mm/slub.c b/mm/slub.c
index 819f056..a9201d8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2595,6 +2595,8 @@ static inline int kmem_cache_close(struct kmem_cache *s)
  */
 void kmem_cache_destroy(struct kmem_cache *s)
 {
+	if (s->flags & SLAB_DESTROY_BY_RCU)
+		rcu_barrier();
 	down_write(&slub_lock);
 	s->refcount--;
 	if (!s->refcount) {
