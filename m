Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbZG2G60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbZG2G60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 02:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZG2G60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 02:58:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:56720 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbZG2G6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 02:58:25 -0400
Date: Wed, 29 Jul 2009 08:58:24 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       linux-kernel@vger.kernel.org
Subject: Re: slqb enables interrupts very early
Message-ID: <20090729065824.GE25390@wotan.suse.de>
References: <20090725180321.GA24814@Chamillionaire.breakpoint.cc> <4A6D59B6.3040400@cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6D59B6.3040400@cs.helsinki.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 10:39:34AM +0300, Pekka Enberg wrote:
> Sebastian Andrzej Siewior wrote:
> >I've checkout slab-2.6/linux-next and noticed that the interrupts are
> >enabled very early by accident. Please look at the following call stack:
> >
> >    start_kernel()
> >    kmem_cache_init()
> >    kmem_cache_open()
> >    down_write(&slqb_lock);
> >    __down_write()
> >    __down_write_nested()
> >
> >Now, __down_write_nested() protects its internal structure the follwing
> >way:
> >    spin_lock_irq(&sem->wait_lock);
> >    ...
> >    spin_unlock_irq(&sem->wait_lock);
> >
> >so once we return, we return with interrupts on.
> 
> Indeed. Nick, do we need to take ->slqb_lock in kmem_cache_open()? A 
> quick read on the code suggests that we could just drop it.

We need it when called from kmem_cache_create, but not from
the rest of kmem_cache_init. Thanks for finding this, how
about this?

--
Sebastian discovered that SLQB can enable interrupts early in boot due
to taking the rwsem. It should not be contended here, so XADD algorithm
implementations should not be affected, however spinlock algorithm
implementations do a spin_lock_irq in down_write fastpath and would be
affected.

Move the lock out of early init path, comment why. This also covers
a very small (and basically insignificant) race where kmem_cache_create_ok
checks succeed but kmem_cache_create still creates a duplicate named
cache because the lock was dropped and retaken.

Reported-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 mm/slqb.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6/mm/slqb.c
===================================================================
--- linux-2.6.orig/mm/slqb.c
+++ linux-2.6/mm/slqb.c
@@ -2234,6 +2234,10 @@ static void kmem_cache_dyn_array_free(vo
 }
 #endif
 
+/*
+ * Except in early boot, this should be called with slqb_lock held for write
+ * to lock out hotplug, and protect list modifications.
+ */
 static int kmem_cache_open(struct kmem_cache *s,
 			const char *name, size_t size, size_t align,
 			unsigned long flags, void (*ctor)(void *), int alloc)
@@ -2259,16 +2263,10 @@ static int kmem_cache_open(struct kmem_c
 		s->colour_range = 0;
 	}
 
-	/*
-	 * Protect all alloc_kmem_cache_cpus/nodes allocations with slqb_lock
-	 * to lock out hotplug, just in case (probably not strictly needed
-	 * here).
-	 */
-	down_write(&slqb_lock);
 #ifdef CONFIG_SMP
 	s->cpu_slab = kmem_cache_dyn_array_alloc(nr_cpu_ids);
 	if (!s->cpu_slab)
-		goto error_lock;
+		goto error;
 # ifdef CONFIG_NUMA
 	s->node_slab = kmem_cache_dyn_array_alloc(nr_node_ids);
 	if (!s->node_slab)
@@ -2286,7 +2284,6 @@ static int kmem_cache_open(struct kmem_c
 
 	sysfs_slab_add(s);
 	list_add(&s->list, &slab_caches);
-	up_write(&slqb_lock);
 
 	return 1;
 
@@ -2299,9 +2296,7 @@ error_cpu_array:
 #endif
 #ifdef CONFIG_SMP
 	kmem_cache_dyn_array_free(s->cpu_slab);
-error_lock:
 #endif
-	up_write(&slqb_lock);
 error:
 	if (flags & SLAB_PANIC)
 		panic("%s: failed to create slab `%s'\n", __func__, name);
@@ -2870,6 +2865,12 @@ void __init kmem_cache_init(void)
 	 * All the ifdefs are rather ugly here, but it's just the setup code,
 	 * so it doesn't have to be too readable :)
 	 */
+
+	/*
+	 * No need to take slqb_lock here: there should be no concurrency
+	 * anyway, and spin_unlock_irq in rwsem code could enable interrupts
+	 * too early.
+	 */
 	kmem_cache_open(&kmem_cache_cache, "kmem_cache",
 			sizeof(struct kmem_cache), 0, flags, NULL, 0);
 #ifdef CONFIG_SMP
@@ -3011,8 +3012,6 @@ static int kmem_cache_create_ok(const ch
 		return 0;
 	}
 
-	down_read(&slqb_lock);
-
 	list_for_each_entry(tmp, &slab_caches, list) {
 		char x;
 		int res;
@@ -3034,14 +3033,11 @@ static int kmem_cache_create_ok(const ch
 			printk(KERN_ERR
 			       "SLAB: duplicate cache %s\n", name);
 			dump_stack();
-			up_read(&slqb_lock);
 
 			return 0;
 		}
 	}
 
-	up_read(&slqb_lock);
-
 	WARN_ON(strchr(name, ' '));	/* It confuses parsers */
 	if (flags & SLAB_DESTROY_BY_RCU)
 		WARN_ON(flags & SLAB_POISON);
@@ -3054,6 +3050,7 @@ struct kmem_cache *kmem_cache_create(con
 {
 	struct kmem_cache *s;
 
+	down_write(&slqb_lock);
 	if (!kmem_cache_create_ok(name, size, align, flags))
 		goto err;
 
@@ -3061,12 +3058,15 @@ struct kmem_cache *kmem_cache_create(con
 	if (!s)
 		goto err;
 
-	if (kmem_cache_open(s, name, size, align, flags, ctor, 1))
+	if (kmem_cache_open(s, name, size, align, flags, ctor, 1)) {
+		up_write(&slqb_lock);
 		return s;
+	}
 
 	kmem_cache_free(&kmem_cache_cache, s);
 
 err:
+	up_write(&slqb_lock);
 	if (flags & SLAB_PANIC)
 		panic("%s: failed to create slab `%s'\n", __func__, name);
 
