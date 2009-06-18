Return-Path: <linux-kernel-owner+w=401wt.eu-S1759710AbZFRD0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759710AbZFRD0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 23:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759666AbZFRD0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 23:26:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:44634 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759464AbZFRD0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 23:26:10 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <1245290413.21602.40.camel@pasglop>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
	 <20090615101254.GB10294@wotan.suse.de> <1245062388.12400.17.camel@pasglop>
	 <20090615112205.GA6012@wotan.suse.de> <20090615112827.GC6012@wotan.suse.de>
	 <1245101567.12400.38.camel@pasglop>
	 <alpine.DEB.1.10.0906161104480.26093@gentwo.org>
	 <alpine.LFD.2.01.0906161208100.3282@localhost.localdomain>
	 <alpine.DEB.1.10.0906161522370.29941@gentwo.org>
	 <alpine.LFD.2.01.0906161231020.3282@localhost.localdomain>
	 <1245215916.5604.5.camel@penberg-laptop>
	 <alpine.LFD.2.01.0906170941490.16802@localhost.localdomain>
	 <1245290413.21602.40.camel@pasglop>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 13:24:12 +1000
Message-Id: <1245295452.21602.42.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 12:00 +1000, Benjamin Herrenschmidt wrote:
> > So I'm very much ok with the whole "use magic gfp_mask to indicate what 
> > works at what stage". And yes, I think it makes sense to extend it to the 
> > page allocator and might_sleep too, because GFP_KERNEL has all the same 
> > issues regardless of whether it's about page allocation or about slab 
> > allocators. And any "might_sleep" suppression really does tend to be about 
> > the exact same thing.
> 
> Argh... still broken.
> 
> In fact, my initial patch added it to the page allocator, which worked
> for me. Pekka patch removed that and made it slab-only. So I'm blowing
> up at boot in lockdep or so because I'm allocating page tables on
> ppc32 with __get_free_pages() and GFP_KERNEL.
> 
> I'll cook up a patch.

Here it is:

mm: Extend gfp masking to the page allocator

The page allocator also needs the masking of gfp flags during boot,
so this moves it out of slab/slub and uses it with the page allocator
as well.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

This will also make it easier to use it for limiting allocations that
can block during suspend/resume, though doing this really fool-proof
will require some kind of synchronization in set_gfp_allowed_mask()
vs. allocations that have already started sleeping waiting for IOs.

Index: linux-work/include/linux/gfp.h
===================================================================
--- linux-work.orig/include/linux/gfp.h	2009-06-18 12:03:14.000000000 +1000
+++ linux-work/include/linux/gfp.h	2009-06-18 12:08:21.000000000 +1000
@@ -99,7 +99,7 @@ struct vm_area_struct;
 			__GFP_NORETRY|__GFP_NOMEMALLOC)
 
 /* Control slab gfp mask during early boot */
-#define SLAB_GFP_BOOT_MASK __GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS)
+#define GFP_BOOT_MASK __GFP_BITS_MASK & ~(__GFP_WAIT|__GFP_IO|__GFP_FS)
 
 /* Control allocation constraints */
 #define GFP_CONSTRAINT_MASK (__GFP_HARDWALL|__GFP_THISNODE)
@@ -348,4 +348,11 @@ static inline void oom_killer_enable(voi
 	oom_killer_disabled = false;
 }
 
+extern gfp_t gfp_allowed_mask;
+
+static inline void set_gfp_allowed_mask(gfp_t mask)
+{
+	gfp_allowed_mask = mask;
+}
+
 #endif /* __LINUX_GFP_H */
Index: linux-work/init/main.c
===================================================================
--- linux-work.orig/init/main.c	2009-06-18 12:06:49.000000000 +1000
+++ linux-work/init/main.c	2009-06-18 12:08:35.000000000 +1000
@@ -642,6 +642,10 @@ asmlinkage void __init start_kernel(void
 				 "enabled early\n");
 	early_boot_irqs_on();
 	local_irq_enable();
+
+	/* Interrupts are enabled now so all GFP allocations are safe. */
+	set_gfp_allowed_mask(__GFP_BITS_MASK);
+
 	kmem_cache_init_late();
 
 	/*
Index: linux-work/mm/page_alloc.c
===================================================================
--- linux-work.orig/mm/page_alloc.c	2009-06-18 12:04:58.000000000 +1000
+++ linux-work/mm/page_alloc.c	2009-06-18 12:09:27.000000000 +1000
@@ -73,6 +73,7 @@ unsigned long totalram_pages __read_most
 unsigned long totalreserve_pages __read_mostly;
 unsigned long highest_memmap_pfn __read_mostly;
 int percpu_pagelist_fraction;
+gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 int pageblock_order __read_mostly;
@@ -1863,6 +1864,8 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	struct page *page;
 	int migratetype = allocflags_to_migratetype(gfp_mask);
 
+	gfp_mask &= gfp_allowed_mask;
+
 	lockdep_trace_alloc(gfp_mask);
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
Index: linux-work/mm/slab.c
===================================================================
--- linux-work.orig/mm/slab.c	2009-06-18 12:05:47.000000000 +1000
+++ linux-work/mm/slab.c	2009-06-18 12:06:19.000000000 +1000
@@ -305,12 +305,6 @@ struct kmem_list3 {
 };
 
 /*
- * The slab allocator is initialized with interrupts disabled. Therefore, make
- * sure early boot allocations don't accidentally enable interrupts.
- */
-static gfp_t slab_gfp_mask __read_mostly = SLAB_GFP_BOOT_MASK;
-
-/*
  * Need this for bootstrapping a per node allocator.
  */
 #define NUM_INIT_LISTS (3 * MAX_NUMNODES)
@@ -1559,11 +1553,6 @@ void __init kmem_cache_init_late(void)
 {
 	struct kmem_cache *cachep;
 
-	/*
-	 * Interrupts are enabled now so all GFP allocations are safe.
-	 */
-	slab_gfp_mask = __GFP_BITS_MASK;
-
 	/* 6) resize the head arrays to their final sizes */
 	mutex_lock(&cache_chain_mutex);
 	list_for_each_entry(cachep, &cache_chain, next)
@@ -3307,7 +3296,7 @@ __cache_alloc_node(struct kmem_cache *ca
 	unsigned long save_flags;
 	void *ptr;
 
-	flags &= slab_gfp_mask;
+	flags &= gfp_allowed_mask;
 
 	lockdep_trace_alloc(flags);
 
@@ -3392,7 +3381,7 @@ __cache_alloc(struct kmem_cache *cachep,
 	unsigned long save_flags;
 	void *objp;
 
-	flags &= slab_gfp_mask;
+	flags &= gfp_allowed_mask;
 
 	lockdep_trace_alloc(flags);
 
Index: linux-work/mm/slub.c
===================================================================
--- linux-work.orig/mm/slub.c	2009-06-18 12:02:46.000000000 +1000
+++ linux-work/mm/slub.c	2009-06-18 12:06:35.000000000 +1000
@@ -179,12 +179,6 @@ static enum {
 	SYSFS		/* Sysfs up */
 } slab_state = DOWN;
 
-/*
- * The slab allocator is initialized with interrupts disabled. Therefore, make
- * sure early boot allocations don't accidentally enable interrupts.
- */
-static gfp_t slab_gfp_mask __read_mostly = SLAB_GFP_BOOT_MASK;
-
 /* A list of all slab caches on the system */
 static DECLARE_RWSEM(slub_lock);
 static LIST_HEAD(slab_caches);
@@ -1692,7 +1686,7 @@ static __always_inline void *slab_alloc(
 	unsigned long flags;
 	unsigned int objsize;
 
-	gfpflags &= slab_gfp_mask;
+	gfpflags &= gfp_allowed_mask;
 
 	lockdep_trace_alloc(gfpflags);
 	might_sleep_if(gfpflags & __GFP_WAIT);
@@ -3220,10 +3214,6 @@ void __init kmem_cache_init(void)
 
 void __init kmem_cache_init_late(void)
 {
-	/*
-	 * Interrupts are enabled now so all GFP allocations are safe.
-	 */
-	slab_gfp_mask = __GFP_BITS_MASK;
 }
 
 /*


