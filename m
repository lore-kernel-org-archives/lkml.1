Return-Path: <linux-kernel-owner+w=401wt.eu-S1031600AbXFHTk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031600AbXFHTk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbXFHTkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:40:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59313 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750792AbXFHTkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:40:16 -0400
Date: Fri, 8 Jun 2007 12:40:15 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 00/12] Slab defragmentation V3
In-Reply-To: <Pine.LNX.4.64.0706081207400.2082@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706081239340.2447@schroedinger.engr.sgi.com>
References: <20070607215529.147027769@sgi.com>  <466999A2.8020608@googlemail.com>
  <Pine.LNX.4.64.0706081110580.1464@schroedinger.engr.sgi.com>
 <6bffcb0e0706081156u4ad0cc9dkf6d55ebcbd79def2@mail.gmail.com>
 <Pine.LNX.4.64.0706081207400.2082@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Christoph Lameter wrote:

> On Fri, 8 Jun 2007, Michal Piotrowski wrote:
> 
> > Yes, it does. Thanks!
> 
> Ahhh... That leds to the discovery more sysfs problems. I need to make 
> sure not to be holding locks while calling into sysfs. More cleanup...

Could you remove the trylock patch and see how this one fares? We may need 
both but this should avoid taking the slub_lock around any possible alloc 
of sysfs.


SLUB: Move sysfs operations outside of slub_lock

Sysfs can do a gazillion things when called. Make sure that we do
not call any sysfs functions while holding the slub_lock. Let sysfs
fend for itself locking wise.

Just protect the essentials: The modifications to the slab lists
and the ref counters of the slabs.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-06-08 12:21:56.000000000 -0700
+++ slub/mm/slub.c	2007-06-08 12:30:23.000000000 -0700
@@ -2179,12 +2179,13 @@ void kmem_cache_destroy(struct kmem_cach
 	s->refcount--;
 	if (!s->refcount) {
 		list_del(&s->list);
+		up_write(&slub_lock);
 		if (kmem_cache_close(s))
 			WARN_ON(1);
 		sysfs_slab_remove(s);
 		kfree(s);
-	}
-	up_write(&slub_lock);
+	} else
+		up_write(&slub_lock);
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 
@@ -2637,26 +2638,33 @@ struct kmem_cache *kmem_cache_create(con
 		 */
 		s->objsize = max(s->objsize, (int)size);
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
+		up_write(&slub_lock);
+
 		if (sysfs_slab_alias(s, name))
 			goto err;
-	} else {
-		s = kmalloc(kmem_size, GFP_KERNEL);
-		if (s && kmem_cache_open(s, GFP_KERNEL, name,
+
+		return s;
+	}
+
+	s = kmalloc(kmem_size, GFP_KERNEL);
+	if (s) {
+		if (kmem_cache_open(s, GFP_KERNEL, name,
 				size, align, flags, ctor)) {
-			if (sysfs_slab_add(s)) {
-				kfree(s);
-				goto err;
-			}
 			list_add(&s->list, &slab_caches);
+			up_write(&slub_lock);
 			raise_kswapd_order(s->order);
-		} else
-			kfree(s);
+
+			if (sysfs_slab_add(s))
+				goto err;
+
+			return s;
+
+		}
+		kfree(s);
 	}
 	up_write(&slub_lock);
-	return s;
 
 err:
-	up_write(&slub_lock);
 	if (flags & SLAB_PANIC)
 		panic("Cannot create slabcache %s\n", name);
 	else
