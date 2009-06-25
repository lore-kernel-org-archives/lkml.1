Return-Path: <linux-kernel-owner+w=401wt.eu-S1759169AbZFYTbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbZFYTbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 15:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbZFYTbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 15:31:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43866 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbZFYTbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 15:31:36 -0400
Date: Thu, 25 Jun 2009 12:31:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: cl@linux-foundation.org, penberg@cs.helsinki.fi, mpm@selenic.com,
       jdb@comx.dk
Subject: [PATCH RFC] fix RCU-callback-after-kmem_cache_destroy problem in
	sl[aou]b
Message-ID: <20090625193137.GA16861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Jesper noted that kmem_cache_destroy() invokes synchronize_rcu() rather
than rcu_barrier() in the SLAB_DESTROY_BY_RCU case, which could result
in RCU callbacks accessing a kmem_cache after it had been destroyed.

The following untested (might not even compile) patch proposes a fix.

Reported-by: Jesper Dangaard Brouer <jdb@comx.dk>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 slab.c |    2 +-
 slob.c |    2 ++
 slub.c |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/slab.c b/mm/slab.c
index e74a16e..5241b65 100644
--- a/mm/slab.c
+++ b/mm/slab.c
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
