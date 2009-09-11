Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZIKAcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZIKAcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZIKAcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:32:11 -0400
Received: from kroah.org ([198.145.64.141]:38084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbZIKA3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:06 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:10 2009
Message-Id: <20090911002410.794447090@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:22:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 12/22] slub: Fix kmem_cache_destroy() with SLAB_DESTROY_BY_RCU
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=slub-fix-kmem_cache_destroy-with-slab_destroy_by_rcu.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Eric Dumazet <eric.dumazet@gmail.com>

commit d76b1590e06a63a3d8697168cd0aabf1c4b3cb3a upstream.

kmem_cache_destroy() should call rcu_barrier() *after* kmem_cache_close() and
*before* sysfs_slab_remove() or risk rcu_free_slab() being called after
kmem_cache is deleted (kfreed).

rmmod nf_conntrack can crash the machine because it has to kmem_cache_destroy()
a SLAB_DESTROY_BY_RCU enabled cache.

Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2490,8 +2490,6 @@ static inline int kmem_cache_close(struc
  */
 void kmem_cache_destroy(struct kmem_cache *s)
 {
-	if (s->flags & SLAB_DESTROY_BY_RCU)
-		rcu_barrier();
 	down_write(&slub_lock);
 	s->refcount--;
 	if (!s->refcount) {
@@ -2502,6 +2500,8 @@ void kmem_cache_destroy(struct kmem_cach
 				"still has objects.\n", s->name, __func__);
 			dump_stack();
 		}
+		if (s->flags & SLAB_DESTROY_BY_RCU)
+			rcu_barrier();
 		sysfs_slab_remove(s);
 	} else
 		up_write(&slub_lock);


