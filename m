Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbZD3U1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbZD3U1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 16:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755393AbZD3U1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 16:27:36 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:59222 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbZD3U1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 16:27:35 -0400
Date: Thu, 30 Apr 2009 16:17:39 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yuriy Lalym <ylalym@gmail.com>, Tejun Heo <tj@kernel.org>,
       ltt-dev@lists.casi.polymtl.ca,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090430194158.GB12926@Krystal>
Message-ID: <alpine.DEB.1.10.0904301559500.11923@qirst.com>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <20090430062140.GA9559@elte.hu> <20090430063306.GA27431@Krystal> <20090430065055.GA16277@elte.hu>
 <alpine.DEB.1.10.0904300926530.22262@qirst.com> <20090430141211.GB5922@Krystal> <alpine.DEB.1.10.0904301009530.14178@qirst.com> <20090430194158.GB12926@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Mathieu Desnoyers wrote:

> On architectures with irq-safe percpu_add :
> - No need to disable interrupts at all

They may have other options like fall back to classic atomic ops.

> Let's assume we change the stat_threshold values in mm/vmstat.c so they
> become power of 2 (so we don't care when the u8 overflow occurs so it
> becomes a free running counter). This model does not support
> "overstep" (yet).

The problem with such an approach is that the counters may wrap if
sufficiently many processors are in a ZVC update. Lets say a new interrupt
is occuring while irq is held off that increments the same counter. When
interrupts are reenabled, we increment again from the new interrupt.
We then check for overflow only after the new interrupt that modified the
counter has completed. The differentials must be constant while the ZVC
update functions are running and with your modifications that is no longer
guaranteed.

> Note that all the fast-path would execute with preemption enabled if the
> architecture supports irqsave percpu atomic ops.

What would work is to use a percpu cmpxchg for the ZVC updates.
I wrote a patch like that over a year ago. There is no percpu_cmpxchg
coming with the percpu ops as of today so we'd need to add that first.

Not sure if this is a performance win though. Complexity increases
somewhat.

---
 include/linux/vmstat.h |   17 ++++--
 mm/vmstat.c            |  122 ++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 127 insertions(+), 12 deletions(-)

Index: linux-2.6/include/linux/vmstat.h
===================================================================
--- linux-2.6.orig/include/linux/vmstat.h	2007-11-07 18:36:03.000000000 -0800
+++ linux-2.6/include/linux/vmstat.h	2007-11-07 18:38:27.000000000 -0800
@@ -202,15 +202,22 @@ extern void inc_zone_state(struct zone *
 void __mod_zone_page_state(struct zone *, enum zone_stat_item item, int);
 void __inc_zone_page_state(struct page *, enum zone_stat_item);
 void __dec_zone_page_state(struct page *, enum zone_stat_item);
+void __inc_zone_state(struct zone *, enum zone_stat_item);
+void __dec_zone_state(struct zone *, enum zone_stat_item);

+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+#define inc_zone_page_state __inc_zone_page_state
+#define dec_zone_page_state __dec_zone_page_state
+#define mod_zone_page_state __mod_zone_page_state
+#define inc_zone_state __inc_zone_state
+#define dec_zone_state __dec_zone_state
+#else
 void mod_zone_page_state(struct zone *, enum zone_stat_item, int);
 void inc_zone_page_state(struct page *, enum zone_stat_item);
 void dec_zone_page_state(struct page *, enum zone_stat_item);
-
-extern void inc_zone_state(struct zone *, enum zone_stat_item);
-extern void __inc_zone_state(struct zone *, enum zone_stat_item);
-extern void dec_zone_state(struct zone *, enum zone_stat_item);
-extern void __dec_zone_state(struct zone *, enum zone_stat_item);
+void inc_zone_state(struct zone *, enum zone_stat_item);
+void dec_zone_state(struct zone *, enum zone_stat_item);
+#endif

 void refresh_cpu_vm_stats(int);
 #else /* CONFIG_SMP */
Index: linux-2.6/mm/vmstat.c
===================================================================
--- linux-2.6.orig/mm/vmstat.c	2007-11-07 17:20:16.000000000 -0800
+++ linux-2.6/mm/vmstat.c	2007-11-07 18:55:57.000000000 -0800
@@ -151,8 +151,109 @@ static void refresh_zone_stat_thresholds
 	}
 }

+#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
+				int delta)
+{
+	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
+	s8 *p = pcp->vm_stat_diff + item;
+	s8 old;
+	unsigned long new;
+	unsigned long add;
+
+	do {
+		add = 0;
+		old = *p;
+		new = old + delta;
+
+		if (unlikely(new > pcp->stat_threshold ||
+				new < -pcp->stat_threshold)) {
+			add = new;
+			new = 0;
+		}
+
+	} while (cmpxchg_local(p, old, new) != old);
+
+	if (add)
+		zone_page_state_add(add, zone, item);
+}
+EXPORT_SYMBOL(__mod_zone_page_state);
+
+/*
+ * Optimized increment and decrement functions implemented using
+ * cmpxchg_local. These do not require interrupts to be disabled
+ * and enabled.
+ */
+void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
+{
+	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
+	s8 *p = pcp->vm_stat_diff + item;
+	int add;
+	unsigned long old;
+	unsigned long new;
+
+	do {
+		add = 0;
+		old = *p;
+		new = old + 1;
+
+		if (unlikely(new > pcp->stat_threshold)) {
+			add = new + pcp->stat_threshold / 2;
+			new = -(pcp->stat_threshold / 2);
+		}
+	} while (cmpxchg_local(p, old, new) != old);
+
+	if (add)
+		zone_page_state_add(add, zone, item);
+}
+
+void __inc_zone_page_state(struct page *page, enum zone_stat_item item)
+{
+	__inc_zone_state(page_zone(page), item);
+}
+EXPORT_SYMBOL(__inc_zone_page_state);
+
+void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
+{
+	struct per_cpu_pageset *pcp = zone_pcp(zone, smp_processor_id());
+	s8 *p = pcp->vm_stat_diff + item;
+	int sub;
+	unsigned long old;
+	unsigned long new;
+
+	do {
+		sub = 0;
+		old = *p;
+		new = old - 1;
+
+		if (unlikely(new < - pcp->stat_threshold)) {
+			sub = new - pcp->stat_threshold / 2;
+			new = pcp->stat_threshold / 2;
+		}
+	} while (cmpxchg_local(p, old, new) != old);
+
+	if (sub)
+		zone_page_state_add(sub, zone, item);
+}
+
+void __dec_zone_page_state(struct page *page, enum zone_stat_item item)
+{
+	__dec_zone_state(page_zone(page), item);
+}
+EXPORT_SYMBOL(__dec_zone_page_state);
+
+static inline void sync_diff(struct zone *zone, struct per_cpu_pageset *p, int i)
+{
+	/*
+	 * xchg_local() would be useful here but that does not exist.
+	 */
+	zone_page_state_add(xchg(&p->vm_stat_diff[i], 0), zone, i);
+}
+
+#else /* CONFIG_FAST_CMPXCHG_LOCAL */
+
 /*
- * For use when we know that interrupts are disabled.
+ * Functions that do not rely on cmpxchg_local
  */
 void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 				int delta)
@@ -281,6 +382,17 @@ void dec_zone_page_state(struct page *pa
 }
 EXPORT_SYMBOL(dec_zone_page_state);

+static inline void sync_diff(struct zone *zone, struct per_cpu_pageset *p, int i)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	zone_page_state_add(p->vm_stat_diff[i], zone, i);
+	p->vm_stat_diff[i] = 0;
+	local_irq_restore(flags);
+}
+#endif /* !CONFIG_FAST_CMPXCHG_LOCAL */
+
 /*
  * Update the zone counters for one cpu.
  *
@@ -299,7 +411,6 @@ void refresh_cpu_vm_stats(int cpu)
 {
 	struct zone *zone;
 	int i;
-	unsigned long flags;

 	for_each_zone(zone) {
 		struct per_cpu_pageset *p;
@@ -311,15 +422,12 @@ void refresh_cpu_vm_stats(int cpu)

 		for (i = 0; i < NR_VM_ZONE_STAT_ITEMS; i++)
 			if (p->vm_stat_diff[i]) {
-				local_irq_save(flags);
-				zone_page_state_add(p->vm_stat_diff[i],
-					zone, i);
-				p->vm_stat_diff[i] = 0;
+				sync_diff(zone, p, i);
+
 #ifdef CONFIG_NUMA
 				/* 3 seconds idle till flush */
 				p->expire = 3;
 #endif
-				local_irq_restore(flags);
 			}
 #ifdef CONFIG_NUMA
 		/*
