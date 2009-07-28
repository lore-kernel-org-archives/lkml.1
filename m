Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908AbZG1XDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbZG1XDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZG1XDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:03:44 -0400
Received: from kroah.org ([198.145.64.141]:42897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbZG1XDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:03:43 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:41 2009
Message-Id: <20090728225941.160558925@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Matt Mackall <mpm@selenic.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 01/37] fix RCU-callback-after-kmem_cache_destroy problem in sl[aou]b
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=fix-rcu-callback-after-kmem_cache_destroy-problem-in-slb.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

commit 7ed9f7e5db58c6e8c2b4b738a75d5dcd8e17aad5 upstream.

Jesper noted that kmem_cache_destroy() invokes synchronize_rcu() rather than
rcu_barrier() in the SLAB_DESTROY_BY_RCU case, which could result in RCU
callbacks accessing a kmem_cache after it had been destroyed.

Acked-by: Matt Mackall <mpm@selenic.com>
Reported-by: Jesper Dangaard Brouer <hawk@comx.dk>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/slab.c |    2 +-
 mm/slob.c |    2 ++
 mm/slub.c |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2580,7 +2580,7 @@ void kmem_cache_destroy(struct kmem_cach
 	}
 
 	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU))
-		synchronize_rcu();
+		rcu_barrier();
 
 	__kmem_cache_destroy(cachep);
 	mutex_unlock(&cache_chain_mutex);
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -561,6 +561,8 @@ EXPORT_SYMBOL(kmem_cache_create);
 
 void kmem_cache_destroy(struct kmem_cache *c)
 {
+	if (c->flags & SLAB_DESTROY_BY_RCU)
+		rcu_barrier();
 	slob_free(c, sizeof(struct kmem_cache));
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2447,6 +2447,8 @@ static inline int kmem_cache_close(struc
  */
 void kmem_cache_destroy(struct kmem_cache *s)
 {
+	if (s->flags & SLAB_DESTROY_BY_RCU)
+		rcu_barrier();
 	down_write(&slub_lock);
 	s->refcount--;
 	if (!s->refcount) {


