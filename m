Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZG2ADa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZG2ADa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZG1Xtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:36 -0400
Received: from kroah.org ([198.145.64.141]:35633 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbZG1Xtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:52 2009
Message-Id: <20090728234152.003836704@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Matt Mackall <mpm@selenic.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 05/71] fix RCU-callback-after-kmem_cache_destroy problem in sl[aou]b
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=fix-rcu-callback-after-kmem_cache_destroy-problem-in-slb.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

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
@@ -2592,7 +2592,7 @@ void kmem_cache_destroy(struct kmem_cach
 	}
 
 	if (unlikely(cachep->flags & SLAB_DESTROY_BY_RCU))
-		synchronize_rcu();
+		rcu_barrier();
 
 	__kmem_cache_destroy(cachep);
 	mutex_unlock(&cache_chain_mutex);
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -590,6 +590,8 @@ EXPORT_SYMBOL(kmem_cache_create);
 
 void kmem_cache_destroy(struct kmem_cache *c)
 {
+	if (c->flags & SLAB_DESTROY_BY_RCU)
+		rcu_barrier();
 	slob_free(c, sizeof(struct kmem_cache));
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2490,6 +2490,8 @@ static inline int kmem_cache_close(struc
  */
 void kmem_cache_destroy(struct kmem_cache *s)
 {
+	if (s->flags & SLAB_DESTROY_BY_RCU)
+		rcu_barrier();
 	down_write(&slub_lock);
 	s->refcount--;
 	if (!s->refcount) {


