Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbYBSO4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbYBSO4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbYBSO4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:56:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32869 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbYBSO4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:56:19 -0500
Date: Tue, 19 Feb 2008 15:55:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: Linux 2.6.25-rc2
Message-ID: <20080219145554.GE21176@elte.hu>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com> <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com> <20080219140230.GA32236@Krystal> <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com> <84144f020802190638i4a364d19o8986a457e76ec187@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020802190638i4a364d19o8986a457e76ec187@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> > Yes, this can happen. Are you saying it is not safe to be in the 
> > lockless path when an IRQ triggers?
> 
> Hmm. The barrier() in slab_free() looks fishy. The comment says it's 
> there to make sure we've retrieved c->freelist before c->page but then 
> it uses a _compiler barrier_ which doesn't affect the CPU and the 
> reads may still be re-ordered... Not sure if that matters here though.

find a fix patch for that below - most systems affected seem to be SMP 
ones.

If this (or my other patch) indeed solves the problem i'd still favor a 
full revert of the SLUB_FASTPATH (commit 1f84260c8ce3b1ce26d4), it looks 
quite un-cooked and quite un-tested for multiple independent reasons.

Sigh, why do i again have to be the messenger who brings the bad news to 
SLUB land, and again when poor Christoph went on vacation? :-/

	Ingo

-------------------------->
Subject: SLUB: barrier fix
From: Ingo Molnar <mingo@elte.hu>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c
+++ linux/mm/slub.c
@@ -1862,7 +1862,7 @@ static __always_inline void slab_free(st
 	debug_check_no_locks_freed(object, s->objsize);
 	do {
 		freelist = c->freelist;
-		barrier();
+		smp_mb();
 		/*
 		 * If the compiler would reorder the retrieval of c->page to
 		 * come before c->freelist then an interrupt could

----------------->
Subject: slub: fastpath optimization revert
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Feb 19 15:46:37 CET 2008

revert:

  commit 1f84260c8ce3b1ce26d4c1d6dedc2f33a3a29c0c
  Author: Christoph Lameter <clameter@sgi.com>
  Date:   Mon Jan 7 23:20:30 2008 -0800

      SLUB: Alternate fast paths using cmpxchg_local

it was causing problems (crashes) and was incomplete.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/slub.c |   87 --------------------------------------------------------------
 1 file changed, 87 deletions(-)

Index: linux-x86.q/mm/slub.c
===================================================================
--- linux-x86.q.orig/mm/slub.c
+++ linux-x86.q/mm/slub.c
@@ -149,13 +149,6 @@ static inline void ClearSlabDebug(struct
 /* Enable to test recovery from slab corruption on boot */
 #undef SLUB_RESILIENCY_TEST
 
-/*
- * Currently fastpath is not supported if preemption is enabled.
- */
-#if defined(CONFIG_FAST_CMPXCHG_LOCAL) && !defined(CONFIG_PREEMPT)
-#define SLUB_FASTPATH
-#endif
-
 #if PAGE_SHIFT <= 12
 
 /*
@@ -1514,11 +1507,6 @@ static void *__slab_alloc(struct kmem_ca
 {
 	void **object;
 	struct page *new;
-#ifdef SLUB_FASTPATH
-	unsigned long flags;
-
-	local_irq_save(flags);
-#endif
 	if (!c->page)
 		goto new_slab;
 
@@ -1541,9 +1529,6 @@ load_freelist:
 unlock_out:
 	slab_unlock(c->page);
 	stat(c, ALLOC_SLOWPATH);
-#ifdef SLUB_FASTPATH
-	local_irq_restore(flags);
-#endif
 	return object;
 
 another_slab:
@@ -1575,9 +1560,6 @@ new_slab:
 		c->page = new;
 		goto load_freelist;
 	}
-#ifdef SLUB_FASTPATH
-	local_irq_restore(flags);
-#endif
 	/*
 	 * No memory available.
 	 *
@@ -1619,34 +1601,6 @@ static __always_inline void *slab_alloc(
 {
 	void **object;
 	struct kmem_cache_cpu *c;
-
-/*
- * The SLUB_FASTPATH path is provisional and is currently disabled if the
- * kernel is compiled with preemption or if the arch does not support
- * fast cmpxchg operations. There are a couple of coming changes that will
- * simplify matters and allow preemption. Ultimately we may end up making
- * SLUB_FASTPATH the default.
- *
- * 1. The introduction of the per cpu allocator will avoid array lookups
- *    through get_cpu_slab(). A special register can be used instead.
- *
- * 2. The introduction of per cpu atomic operations (cpu_ops) means that
- *    we can realize the logic here entirely with per cpu atomics. The
- *    per cpu atomic ops will take care of the preemption issues.
- */
-
-#ifdef SLUB_FASTPATH
-	c = get_cpu_slab(s, raw_smp_processor_id());
-	do {
-		object = c->freelist;
-		if (unlikely(is_end(object) || !node_match(c, node))) {
-			object = __slab_alloc(s, gfpflags, node, addr, c);
-			break;
-		}
-		stat(c, ALLOC_FASTPATH);
-	} while (cmpxchg_local(&c->freelist, object, object[c->offset])
-								!= object);
-#else
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -1661,7 +1615,6 @@ static __always_inline void *slab_alloc(
 		stat(c, ALLOC_FASTPATH);
 	}
 	local_irq_restore(flags);
-#endif
 
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, c->objsize);
@@ -1698,11 +1651,6 @@ static void __slab_free(struct kmem_cach
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
 
-#ifdef SLUB_FASTPATH
-	unsigned long flags;
-
-	local_irq_save(flags);
-#endif
 	c = get_cpu_slab(s, raw_smp_processor_id());
 	stat(c, FREE_SLOWPATH);
 	slab_lock(page);
@@ -1734,9 +1682,6 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page);
-#ifdef SLUB_FASTPATH
-	local_irq_restore(flags);
-#endif
 	return;
 
 slab_empty:
@@ -1749,9 +1694,6 @@ slab_empty:
 	}
 	slab_unlock(page);
 	stat(c, FREE_SLAB);
-#ifdef SLUB_FASTPATH
-	local_irq_restore(flags);
-#endif
 	discard_slab(s, page);
 	return;
 
@@ -1777,34 +1719,6 @@ static __always_inline void slab_free(st
 {
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
-
-#ifdef SLUB_FASTPATH
-	void **freelist;
-
-	c = get_cpu_slab(s, raw_smp_processor_id());
-	debug_check_no_locks_freed(object, s->objsize);
-	do {
-		freelist = c->freelist;
-		barrier();
-		/*
-		 * If the compiler would reorder the retrieval of c->page to
-		 * come before c->freelist then an interrupt could
-		 * change the cpu slab before we retrieve c->freelist. We
-		 * could be matching on a page no longer active and put the
-		 * object onto the freelist of the wrong slab.
-		 *
-		 * On the other hand: If we already have the freelist pointer
-		 * then any change of cpu_slab will cause the cmpxchg to fail
-		 * since the freelist pointers are unique per slab.
-		 */
-		if (unlikely(page != c->page || c->node < 0)) {
-			__slab_free(s, page, x, addr, c->offset);
-			break;
-		}
-		object[c->offset] = freelist;
-		stat(c, FREE_FASTPATH);
-	} while (cmpxchg_local(&c->freelist, freelist, object) != freelist);
-#else
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -1818,7 +1732,6 @@ static __always_inline void slab_free(st
 		__slab_free(s, page, x, addr, c->offset);
 
 	local_irq_restore(flags);
-#endif
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
