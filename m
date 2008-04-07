Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYDGWF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYDGWF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYDGWFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:05:19 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49128 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbYDGWFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:05:17 -0400
Date: Tue, 8 Apr 2008 01:05:14 +0300 (EEST)
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
In-Reply-To: <47FA94AE.4070803@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0804080104170.23980@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0804062348001.19446@blonde.site> 
 <Pine.LNX.4.64.0804062213230.18148@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0804072000410.18591@blonde.site> <1207598115.29991.23.camel@lappy>
 <Pine.LNX.4.64.0804072121320.28744@blonde.site> <47FA8B5A.5090104@cs.helsinki.fi>
 <47FA8CB0.6070106@cs.helsinki.fi> <alpine.LFD.1.00.0804071409150.2886@woody.linux-foundation.org>
 <47FA937E.6000009@cs.helsinki.fi> <47FA94AE.4070803@cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Pekka Enberg wrote:
> Actually, a trivial way to implement that is to have a few "emergency kmalloc"
> caches say for sizes 64, 128, 256, and 512 that have some pre-allocated pages
> into which these GFP_TEMPORARY allocations are allowed to dip into on OOM and
> OOM only.

So something like the following (totally untested) patch modulo the 
pre-allocation bits.

		Pekka

diff --git a/mm/slub.c b/mm/slub.c
index acc975f..e8f7cf3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -264,6 +264,67 @@ static inline void stat(struct kmem_cache_cpu *c, enum stat_item si)
 #endif
 }
 
+/*
+ * Emergency caches are for GFP_TEMPORARY allocations to dip into when we're
+ * OOM to make sure we can make some progress for writeback.
+ */
+
+#define MIN_EMERGENCY_SIZE 32
+#define NR_EMERGENCY_CACHES 4
+
+struct kmem_cache *emergency_caches[NR_EMERGENCY_CACHES];
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
+		emergency_caches[i] = cache;
+
+		size *= 2;
+	}
+}
+
+static struct kmem_cache *lookup_emergency_cache(unsigned long size)
+{
+	unsigned long cache_size = MIN_EMERGENCY_SIZE;
+	int i;
+
+	for (i = 0; i < NR_EMERGENCY_CACHES; i++) {
+		if (size < cache_size)
+			return emergency_caches[i];
+
+		cache_size *= 2;
+	}
+	return NULL;
+}
+
+static void *emergency_alloc(struct kmem_cache *cache, gfp_t gfp)
+{
+	struct kmem_cache *emergency_cache;
+	void *p;
+
+	emergency_cache = lookup_emergency_cache(cache->objsize);
+	if (!emergency_cache)
+		return NULL;
+
+	p = kmem_cache_alloc(emergency_cache, gfp);
+	if (p && cache->ctor)
+		cache->ctor(cache, p);
+	return p;
+}
+
 /********************************************************************
  * 			Core slab cache functions
  *******************************************************************/
@@ -1528,6 +1589,9 @@ new_slab:
 		goto load_freelist;
 	}
 
+	if ((gfpflags & GFP_TEMPORARY) == GFP_TEMPORARY)
+		return emergency_alloc(s, gfpflags);
+
 	/*
 	 * No memory available.
 	 *
@@ -2970,6 +3034,7 @@ void __init kmem_cache_init(void)
 #else
 	kmem_size = sizeof(struct kmem_cache);
 #endif
+	init_emergency_caches();
 
 	printk(KERN_INFO
 		"SLUB: Genslabs=%d, HWalign=%d, Order=%d-%d, MinObjects=%d,"
