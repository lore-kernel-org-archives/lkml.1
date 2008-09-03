Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbYICJlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbYICJlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbYICJkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:40:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42050 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660AbYICJkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:40:01 -0400
Date: Wed, 3 Sep 2008 12:39:58 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: John Reiser <jreiser@BitWagon.com>
cc: Steve VanDeBogart <vandebo-lkml@nerdbox.net>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, dkegel@google.com, jiayingz@google.com
Subject: Re: [uml-devel] [PATCH 5/6] slab: Annotate slab
In-Reply-To: <48BDFC77.4060909@BitWagon.com>
Message-ID: <Pine.LNX.4.64.0809031237320.6448@melkki.cs.Helsinki.FI>
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>
 <alpine.DEB.1.00.0808291616560.15543@abydos.NerdBox.Net>
 <84144f020808300350i7cb2d23aj6d1ffcbeceaf7e9c@mail.gmail.com>
 <48BDFC77.4060909@BitWagon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2 Sep 2008, John Reiser wrote:
> With regard to Read-Copy-Update, I anticipate that RCU will require
> special annotations because of the deliberate references after kfree
> and before the next corresponding kmalloc.  These special annotations
> will require great care, because bugs in this area have high value.

For RCU, I was thinking of adding a new RCU_WAITING state that a RCU-freed 
object is set to upon freeing that we can use to detect whatever errors 
there might be. I've included an incomplete implementation of SLAB hooks 
for that. Obviously there would need to be some additional code in 
kmemcheck for that. No idea if that kind of model works for valgrind, 
though.

		Pekka

Index: linux-2.6/mm/slab.c
===================================================================
--- linux-2.6.orig/mm/slab.c	2008-08-30 13:42:17.000000000 +0300
+++ linux-2.6/mm/slab.c	2008-08-30 13:42:22.000000000 +0300
@@ -1647,11 +1647,23 @@
 	free_pages((unsigned long)addr, cachep->gfporder);
 }
 
+static void kmemcheck_rcu_free(struct kmem_cache *cache, struct slab *slab)
+{
+	int i;
+
+	for (i = 0; i < cache->num; i++) {
+		void *obj = index_to_obj(cache, slab, i);
+
+		kmemcheck_slab_rcu_free(cache, obj, obj_size(cache));
+	}
+}
+
 static void kmem_rcu_free(struct rcu_head *head)
 {
 	struct slab_rcu *slab_rcu = (struct slab_rcu *)head;
 	struct kmem_cache *cachep = slab_rcu->cachep;
 
+	kmemcheck_rcu_free(cachep, (struct slab *)slab_rcu);
 	kmem_freepages(cachep, slab_rcu->addr);
 	if (OFF_SLAB(cachep))
 		kmem_cache_free(cachep->slabp_cache, slab_rcu);
Index: linux-2.6/include/linux/kmemcheck.h
===================================================================
--- linux-2.6.orig/include/linux/kmemcheck.h	2008-08-30 13:42:21.000000000 +0300
+++ linux-2.6/include/linux/kmemcheck.h	2008-08-30 13:42:22.000000000 +0300
@@ -9,6 +9,7 @@
 	KMEMCHECK_UNINITIALIZED,
 	KMEMCHECK_INITIALIZED,
 	KMEMCHECK_FREED,
+	KMEMCHECK_RCU_WAITING,	/* waiting for RCU to free the object */
 };
 
 #ifdef CONFIG_KMEMCHECK
@@ -22,6 +23,7 @@
 void kmemcheck_free_shadow(struct kmem_cache *s, struct page *page, int order);
 void kmemcheck_slab_alloc(struct kmem_cache *s, gfp_t gfpflags, void *object,
 			  size_t size);
+void kmemcheck_slab_rcu_free(struct kmem_cache *s, void *object, size_t size);
 void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size);
 
 void kmemcheck_show_pages(struct page *p, unsigned int n);
@@ -29,7 +31,11 @@
 
 bool kmemcheck_page_is_tracked(struct page *p);
 
-void kmemcheck_mark_addr(void *address, unsigned int n, enum kmemcheck_addr_type type);
+void kmemcheck_mark_addr(void *address, unsigned int n,
+			 enum kmemcheck_addr_type type);
+
+void kmemcheck_verify_addr(void *address, unsigned int n,
+			   enum kmemcheck_addr_type type);
 
 void kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n);
 void kmemcheck_mark_uninitialized_pages(struct page *p, unsigned int n);
@@ -74,6 +80,10 @@
 {
 }
 
+static inline void kmemcheck_verify_addr(void *address, unsigned int n, enum kmemcheck_addr_type type)
+{
+}
+
 #endif /* CONFIG_KMEMCHECK */
 
 #endif /* LINUX_KMEMCHECK_H */
Index: linux-2.6/arch/x86/mm/kmemcheck/shadow.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/kmemcheck/shadow.c	2008-08-30 13:42:21.000000000 +0300
+++ linux-2.6/arch/x86/mm/kmemcheck/shadow.c	2008-08-30 13:43:01.000000000 +0300
@@ -51,6 +51,14 @@
 }
 EXPORT_SYMBOL_GPL(kmemcheck_mark_addr);
 
+void kmemcheck_verify_addr(void *address, unsigned int n, enum kmemcheck_addr_type type)
+{
+	/*
+ 	 * Vegard, please implement me!
+ 	 */
+}
+EXPORT_SYMBOL_GPL(kmemcheck_verify_addr);
+
 void kmemcheck_mark_unallocated_pages(struct page *p, unsigned int n)
 {
 	unsigned int i;
Index: linux-2.6/mm/kmemcheck.c
===================================================================
--- linux-2.6.orig/mm/kmemcheck.c	2008-08-30 13:42:21.000000000 +0300
+++ linux-2.6/mm/kmemcheck.c	2008-08-30 13:42:22.000000000 +0300
@@ -95,9 +95,23 @@
 	}
 }
 
+void kmemcheck_slab_rcu_free(struct kmem_cache *s, void *object, size_t size)
+{
+	if (WARN_ON(!(s->flags & SLAB_DESTROY_BY_RCU)))
+		return;
+
+	kmemcheck_verify_addr(object, size, KMEMCHECK_RCU_WAITING);
+
+	kmemcheck_mark_addr(object, size, KMEMCHECK_FREED);
+}
+
 void kmemcheck_slab_free(struct kmem_cache *s, void *object, size_t size)
 {
-	/* TODO: RCU freeing is unsupported for now; hide false positives. */
-	if (!s->ctor && !(s->flags & SLAB_DESTROY_BY_RCU))
+	if (s->ctor)
+		return;
+
+	if (s->flags & SLAB_DESTROY_BY_RCU)
+		kmemcheck_mark_addr(object, size, KMEMCHECK_RCU_WAITING);
+	else
 		kmemcheck_mark_addr(object, size, KMEMCHECK_FREED);
 }
