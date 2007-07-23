Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbXGWWFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbXGWWFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbXGWWFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:05:07 -0400
Received: from www.osadl.org ([213.239.205.134]:56292 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754273AbXGWWFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:05:04 -0400
Subject: Re: v2.6.22.1-rt5
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
Cc: Rui Nuno Capela <rncbc@rncbc.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <1185226226.2573.147.camel@imap.mvista.com>
References: <20070723210236.GA25104@elte.hu>  <46A51D9E.8040104@rncbc.org>
	 <1185226226.2573.147.camel@imap.mvista.com>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 00:05:02 +0200
Message-Id: <1185228302.3318.40.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 14:30 -0700, Daniel Walker wrote:
> Yeah, the quicklist patch wasn't fully tested .. The delta patch below
> is what I had to change to get it working ..

My bad. I pushed the wrong queue to Ingo.

-ENOTENOUGHSLEEP

This is the delta. We'll do a -rt6 tomorrow morning.

	tglx

Index: linux-2.6.22/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.22.orig/arch/i386/kernel/hpet.c	2007-07-24 00:02:12.000000000 +0200
+++ linux-2.6.22/arch/i386/kernel/hpet.c	2007-07-24 00:05:05.000000000 +0200
@@ -9,7 +9,6 @@
 #include <linux/pm.h>
 
 #include <asm/fixmap.h>
-#include <asm/i8253.h>
 #include <asm/hpet.h>
 #include <asm/i8253.h>
 #include <asm/io.h>
Index: linux-2.6.22/arch/i386/kernel/process.c
===================================================================
--- linux-2.6.22.orig/arch/i386/kernel/process.c	2007-07-24 00:02:10.000000000 +0200
+++ linux-2.6.22/arch/i386/kernel/process.c	2007-07-24 00:05:08.000000000 +0200
@@ -189,7 +189,6 @@ void cpu_idle(void)
 
 			tick_nohz_stop_sched_tick();
 
-			check_pgt_cache();
 			rmb();
 			idle = pm_idle;
 
Index: linux-2.6.22/include/asm-generic/bug.h
===================================================================
--- linux-2.6.22.orig/include/asm-generic/bug.h	2007-07-24 00:02:11.000000000 +0200
+++ linux-2.6.22/include/asm-generic/bug.h	2007-07-24 00:05:07.000000000 +0200
@@ -92,16 +92,4 @@ struct bug_entry {
 # define WARN_ON_NONRT(condition)	WARN_ON(condition)
 #endif
 
-#ifdef CONFIG_PREEMPT_RT
-# define BUG_ON_RT(c)			BUG_ON(c)
-# define BUG_ON_NONRT(c)		do { } while (0)
-# define WARN_ON_RT(condition)		WARN_ON(condition)
-# define WARN_ON_NONRT(condition)	do { } while (0)
-#else
-# define BUG_ON_RT(c)			do { } while (0)
-# define BUG_ON_NONRT(c)		BUG_ON(c)
-# define WARN_ON_RT(condition)		do { } while (0)
-# define WARN_ON_NONRT(condition)	WARN_ON(condition)
-#endif
-
 #endif
Index: linux-2.6.22/kernel/sched.c
===================================================================
--- linux-2.6.22.orig/kernel/sched.c	2007-07-24 00:02:12.000000000 +0200
+++ linux-2.6.22/kernel/sched.c	2007-07-24 00:05:36.000000000 +0200
@@ -4924,7 +4924,6 @@ asmlinkage long sys_sched_yield(void)
 	 * no need to preempt or enable interrupts:
 	 */
 	spin_unlock_no_resched(&rq->lock);
-	rcu_read_unlock();
 
 	__schedule();
 
Index: linux-2.6.22/kernel/softirq.c
===================================================================
--- linux-2.6.22.orig/kernel/softirq.c	2007-07-24 00:02:11.000000000 +0200
+++ linux-2.6.22/kernel/softirq.c	2007-07-24 00:05:08.000000000 +0200
@@ -102,7 +102,6 @@ static void wakeup_softirqd(int softirq)
 
 	if (unlikely(!tsk))
 		return;
-#if 1
 #if defined(CONFIG_PREEMPT_SOFTIRQS) && defined(CONFIG_PREEMPT_HARDIRQS)
 	/*
 	 * Optimization: if we are in a hardirq thread context, and
@@ -117,7 +116,6 @@ static void wakeup_softirqd(int softirq)
 			(tsk->normal_prio == current->normal_prio))
 		return;
 #endif
-#endif
 	/*
 	 * Wake up the softirq task:
 	 */
Index: linux-2.6.22/include/linux/quicklist.h
===================================================================
--- linux-2.6.22.orig/include/linux/quicklist.h	2007-07-24 00:02:00.000000000 +0200
+++ linux-2.6.22/include/linux/quicklist.h	2007-07-24 00:05:08.000000000 +0200
@@ -18,7 +18,7 @@ struct quicklist {
 	int nr_pages;
 };
 
-DECLARE_PER_CPU(struct quicklist, quicklist)[CONFIG_NR_QUICK];
+DECLARE_PER_CPU_LOCKED(struct quicklist, quicklist)[CONFIG_NR_QUICK];
 
 /*
  * The two key functions quicklist_alloc and quicklist_free are inline so
@@ -30,19 +30,30 @@ DECLARE_PER_CPU(struct quicklist, quickl
  * The fast patch in quicklist_alloc touched only a per cpu cacheline and
  * the first cacheline of the page itself. There is minmal overhead involved.
  */
-static inline void *quicklist_alloc(int nr, gfp_t flags, void (*ctor)(void *))
+static inline void *__quicklist_alloc(int cpu, int nr, gfp_t flags, void (*ctor)(void *))
 {
 	struct quicklist *q;
 	void **p = NULL;
 
-	q =&get_cpu_var(quicklist)[nr];
+	q = &__get_cpu_var_locked(quicklist, cpu)[nr];
 	p = q->page;
 	if (likely(p)) {
 		q->page = p[0];
 		p[0] = NULL;
 		q->nr_pages--;
 	}
-	put_cpu_var(quicklist);
+	return p;
+}
+
+static inline void *quicklist_alloc(int nr, gfp_t flags, void (*ctor)(void *))
+{
+	struct quicklist *q;
+	void **p = NULL;
+	int cpu;
+
+	(void)get_cpu_var_locked(quicklist, &cpu)[nr];
+	p = __quicklist_alloc(cpu, nr, flags, ctor);
+	put_cpu_var_locked(quicklist, cpu);
 	if (likely(p))
 		return p;
 
Index: linux-2.6.22/mm/quicklist.c
===================================================================
--- linux-2.6.22.orig/mm/quicklist.c	2007-07-24 00:02:00.000000000 +0200
+++ linux-2.6.22/mm/quicklist.c	2007-07-24 00:05:08.000000000 +0200
@@ -19,7 +19,7 @@
 #include <linux/module.h>
 #include <linux/quicklist.h>
 
-DEFINE_PER_CPU(struct quicklist, quicklist)[CONFIG_NR_QUICK];
+DEFINE_PER_CPU_LOCKED(struct quicklist, quicklist)[CONFIG_NR_QUICK];
 
 #define FRACTION_OF_NODE_MEM	16
 
@@ -51,8 +51,9 @@ void quicklist_trim(int nr, void (*dtor)
 {
 	long pages_to_free;
 	struct quicklist *q;
+	int cpu;
 
-	q = &get_cpu_var(quicklist)[nr];
+	q = &get_cpu_var_locked(quicklist, &cpu)[nr];
 	if (q->nr_pages > min_pages) {
 		pages_to_free = min_pages_to_free(q, min_pages, max_free);
 
@@ -61,7 +62,7 @@ void quicklist_trim(int nr, void (*dtor)
 			 * We pass a gfp_t of 0 to quicklist_alloc here
 			 * because we will never call into the page allocator.
 			 */
-			void *p = quicklist_alloc(nr, 0, NULL);
+			void *p = __quicklist_alloc(cpu, nr, 0, NULL);
 
 			if (dtor)
 				dtor(p);
@@ -69,7 +70,7 @@ void quicklist_trim(int nr, void (*dtor)
 			pages_to_free--;
 		}
 	}
-	put_cpu_var(quicklist);
+	put_cpu_var_locked(quicklist, cpu);
 }
 
 unsigned long quicklist_total_size(void)




