Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbYDHUmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbYDHUmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYDHUmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:42:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41609 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbYDHUma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:42:30 -0400
Date: Tue, 8 Apr 2008 23:42:27 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix sense_slab/bio swapping livelock
In-Reply-To: <alpine.LFD.1.00.0804071515320.2886@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804082340120.11104@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site> 
 <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0804072000410.18591@blonde.site> <1207598115.29991.23.camel@lappy>
 <Pine.LNX.4.64.0804072121320.28744@blonde.site> <47FA8B5A.5090104@cs.helsinki.fi>
 <47FA8CB0.6070106@cs.helsinki.fi> <alpine.LFD.1.00.0804071409150.2886@woody.linux-foundation.org>
 <47FA937E.6000009@cs.helsinki.fi> <47FA94AE.4070803@cs.helsinki.fi>
 <Pine.LNX.4.64.0804080104170.23980@sbz-30.cs.Helsinki.FI>
 <alpine.LFD.1.00.0804071515320.2886@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Pekka J Enberg wrote:
> > 
> > So something like the following (totally untested) patch modulo the 
> > pre-allocation bits.

On Mon, 7 Apr 2008, Linus Torvalds wrote:
> Hmm. I didn't check, but won't this cause problems on the freeing path 
> when we call kmem_cache_free() on the result but with the wrong "struct 
> kmem_cache" pointer?

So something like this fugly patch on top of the SLUB variable order 
patches that let the allocator fall-back to smaller page orders. Survives 
OOM in my testing and the box seems to be bit more responsive even under X 
with this.

		Pekka

---
 mm/slub.c |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 1 deletion(-)

Index: slab-2.6/mm/slub.c
===================================================================
--- slab-2.6.orig/mm/slub.c	2008-04-08 22:52:02.000000000 +0300
+++ slab-2.6/mm/slub.c	2008-04-08 23:27:27.000000000 +0300
@@ -1549,6 +1549,88 @@
 }
 
 /*
+ * Emergency caches are reserved for GFP_TEMPORARY allocations on OOM.
+ */
+
+#define MIN_EMERGENCY_SIZE 32
+#define NR_EMERGENCY_CACHES 4
+
+struct kmem_cache *emergency_caches[NR_EMERGENCY_CACHES];
+
+static void pre_alloc_cpu_slabs(struct kmem_cache *s)
+{
+	int cpu;
+
+	/*
+	 * FIXME: CPU hot-plug, stats, debug?
+	 */
+	for_each_online_cpu(cpu) {
+		struct kmem_cache_cpu *c;
+		struct page *new;
+		void **object;
+		int node;
+
+		c = get_cpu_slab(s, cpu);
+		node = cpu_to_node(cpu);
+
+		new = new_slab(s, GFP_KERNEL, node);
+		BUG_ON(!new);
+
+		slab_lock(new);
+		SetSlabFrozen(new);
+		c->page = new;
+		object = c->page->freelist;
+		c->freelist = object[c->offset];
+		c->page->inuse = c->page->objects;
+		c->page->freelist = NULL;
+		c->node = page_to_nid(c->page);
+		slab_unlock(c->page);
+	}
+}
+
+static void init_emergency_caches(void)
+{
+	unsigned long size = MIN_EMERGENCY_SIZE;
+	int i;
+
+	for (i = 0; i < NR_EMERGENCY_CACHES; i++) {
+		struct kmem_cache *cache;
+		char *name;
+
+		name = kasprintf(GFP_KERNEL, "kmalloc-%d", 1 << i);
+		BUG_ON(!name);
+
+		cache = kmem_cache_create(name, size, 0, 0, NULL);
+		BUG_ON(!cache);
+		kfree(name);
+
+		pre_alloc_cpu_slabs(cache);
+		emergency_caches[i] = cache;
+
+		size *= 2;
+	}
+}
+
+static void *emergency_alloc(struct kmem_cache *cache, gfp_t gfp)
+{
+	unsigned long cache_size = MIN_EMERGENCY_SIZE;
+	void *p = NULL;
+	int i;
+
+	for (i = 0; i < NR_EMERGENCY_CACHES; i++) {
+		if (cache->objsize < cache_size) {
+			p = kmem_cache_alloc(emergency_caches[i], gfp);
+			if (p)
+				break;
+		}
+		cache_size *= 2;
+	}
+	if (p && cache->ctor)
+		cache->ctor(cache, p);
+	return p;
+}
+
+/*
  * Slow path. The lockless freelist is empty or we need to perform
  * debugging duties.
  *
@@ -1626,6 +1708,14 @@
 		c->page = new;
 		goto load_freelist;
 	}
+
+	/*
+	 * We are really OOM. Let short-lived allocations dip into the reserves
+	 * to ensure writeback makes progress.
+	 */
+	if ((gfpflags & GFP_TEMPORARY) == GFP_TEMPORARY)
+		return emergency_alloc(s, gfpflags);
+
 	return NULL;
 debug:
 	if (!alloc_debug_processing(s, c->page, object, addr))
@@ -1791,7 +1881,7 @@
 
 	page = virt_to_head_page(x);
 
-	slab_free(s, page, x, __builtin_return_address(0));
+	slab_free(page->slab, page, x, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
@@ -3225,6 +3315,7 @@
 #else
 	kmem_size = sizeof(struct kmem_cache);
 #endif
+	init_emergency_caches();
 
 	printk(KERN_INFO
 		"SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
