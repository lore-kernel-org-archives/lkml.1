Return-Path: <linux-kernel-owner+w=401wt.eu-S1422824AbXCWMFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422824AbXCWMFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 08:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422827AbXCWMFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 08:05:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37481 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422824AbXCWMFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 08:05:20 -0400
Date: Fri, 23 Mar 2007 13:01:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Jens Axboe <jens.axboe@oracle.com>
Subject: [patch] hrtimers debug patch
Message-ID: <20070323120148.GA27505@elte.hu>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070318184908.GU752@stusta.de> <Pine.LNX.4.64.0703212023550.6730@woody.linux-foundation.org> <46020385.50301@yahoo.com.au> <Pine.LNX.4.64.0703220813340.6730@woody.linux-foundation.org> <1174612132.16068.114.camel@localhost.localdomain> <Pine.LNX.4.64.0703221830470.6730@woody.linux-foundation.org> <20070323021115.GA11147@wotan.suse.de> <6bffcb0e0703230051i5accb180r7bd0fb16de85198a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0703230051i5accb180r7bd0fb16de85198a@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4/git-config
> 
> I don't know how to reproduce this bug on 2.6.21-rc4. On 
> 2.6.21-rc2-mm1 it was very simple, just run youtube, 
> bash_shared_mapping etc. In fact I didn't see this bug for a week.

hm. The sysrq-q info you provided shows a weird (=='impossible') 
high-res timers state, in that CPU#1's hrtimer_cpu_base->expires_next is 
at KTIME_MAX, and state has been there for around 8-9 minutes. The 
timers there just stay pending and never expire. Thomas and me have just 
spent 4 hours reviewing the affected code inside out and upside down but 
we can find no credible way for this condition to trigger. But it 
obviously happened on your box, and persisted for many minutes.

So to move this issue forward, i've written a hrtimers debug patch 
(attached) - which checks a couple of key assumptions in the hrtimers.c 
code, and which also extends the SysRq-Q debug info with this:

  .expires_next   : 88378000000 nsecs
  .exp_prev       : 88377000000 nsecs
 last expires_next stacktrace:
  update_cpu_base_expires_next+5f/63
  hrtimer_interrupt+177/1b3
  smp_apic_timer_interrupt+6e/80
  apic_timer_interrupt+33/38
  <ffffffff>

knowing which codepath updated expires_next to KTIME_MAX would be very 
helpful to us.

So could you please pick up latest git (12998096c or later), undo commit 
25496caec (which broke my laptop - it might break your system too), and 
apply the attached patch, and keep lockdep enabled (so that you get 
CONFIG_STACKTRACE=y, essential for the stacktrace output above)? It 
might take some time for you to trigger this bug again, but that's the 
best idea we have so far. If we are lucky then one of the WARN_ON()s 
triggers much sooner.

if the hang occurs again then please do a SysRq-Q again and send us the 
output.

	Ingo

---------------------------->
Subject: [patch] hrtimers debug patch
From: Ingo Molnar <mingo@elte.hu>

debugging helper for hrtimers. Keep a lookout for WARN_ON messages.
Saves a stacktrace on every expires_next update, and makes that
stack-trace available in SysRq-Q (or /proc/timer_list) output.

( make sure to run this on a lockdep-enabled kernel, so that
  CONFIG_STACKTRACE=y. )

NOT-Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/i386/kernel/apic.c    |    2 +
 include/linux/hrtimer.h    |    7 +++++
 kernel/hrtimer.c           |   54 +++++++++++++++++++++++++++++++++++----------
 kernel/time/tick-oneshot.c |   13 ++++++++++
 kernel/time/timer_list.c   |   21 ++++++++++++++++-
 5 files changed, 83 insertions(+), 14 deletions(-)

Index: linux/arch/i386/kernel/apic.c
===================================================================
--- linux.orig/arch/i386/kernel/apic.c
+++ linux/arch/i386/kernel/apic.c
@@ -523,6 +523,8 @@ void __init setup_boot_APIC_clock(void)
 		 */
 		if (nmi_watchdog != NMI_IO_APIC)
 			lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+		else
+			printk(KERN_WARNING "APIC timer registered as dummy, due to nmi_watchdog=1!\n");
 	}
 
 	/* Setup the lapic or request the broadcast */
Index: linux/include/linux/hrtimer.h
===================================================================
--- linux.orig/include/linux/hrtimer.h
+++ linux/include/linux/hrtimer.h
@@ -15,6 +15,7 @@
 #ifndef _LINUX_HRTIMER_H
 #define _LINUX_HRTIMER_H
 
+#include <linux/stacktrace.h>
 #include <linux/rbtree.h>
 #include <linux/ktime.h>
 #include <linux/init.h>
@@ -196,6 +197,12 @@ struct hrtimer_cpu_base {
 	struct hrtimer_clock_base	clock_base[HRTIMER_MAX_CLOCK_BASES];
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
+# define HRTIMERS_STACK_TRACE_DEPTH	32
+# ifdef CONFIG_STACKTRACE
+	struct stack_trace		exp_trace;
+	unsigned long			exp_entries[HRTIMERS_STACK_TRACE_DEPTH];
+# endif
+	ktime_t				exp_prev;
 	int				hres_active;
 	struct list_head		cb_pending;
 	unsigned long			nr_events;
Index: linux/kernel/hrtimer.c
===================================================================
--- linux.orig/kernel/hrtimer.c
+++ linux/kernel/hrtimer.c
@@ -305,6 +305,27 @@ unsigned long ktime_divns(const ktime_t 
 /* High resolution timer related functions */
 #ifdef CONFIG_HIGH_RES_TIMERS
 
+static void update_cpu_base_expires_next(struct hrtimer_cpu_base *cpu_base,
+					 ktime_t expires_next)
+{
+	cpu_base->exp_prev = cpu_base->expires_next;
+	cpu_base->expires_next = expires_next;
+
+#ifdef CONFIG_STACKTRACE
+	{
+		struct stack_trace *trace = &cpu_base->exp_trace;
+
+		trace->nr_entries = 0;
+		trace->entries = cpu_base->exp_entries;
+		trace->max_entries = HRTIMERS_STACK_TRACE_DEPTH;
+		trace->skip = 1;
+		trace->all_contexts = 0;
+
+		save_stack_trace(trace, NULL);
+	}
+#endif
+}
+
 /*
  * High resolution timer enabled ?
  */
@@ -353,7 +374,7 @@ static void hrtimer_force_reprogram(stru
 	struct hrtimer_clock_base *base = cpu_base->clock_base;
 	ktime_t expires;
 
-	cpu_base->expires_next.tv64 = KTIME_MAX;
+	update_cpu_base_expires_next(cpu_base, (ktime_t){ .tv64 = KTIME_MAX });
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
 		struct hrtimer *timer;
@@ -363,7 +384,7 @@ static void hrtimer_force_reprogram(stru
 		timer = rb_entry(base->first, struct hrtimer, node);
 		expires = ktime_sub(timer->expires, base->offset);
 		if (expires.tv64 < cpu_base->expires_next.tv64)
-			cpu_base->expires_next = expires;
+			update_cpu_base_expires_next(cpu_base, expires);
 	}
 
 	if (cpu_base->expires_next.tv64 != KTIME_MAX)
@@ -382,7 +403,7 @@ static void hrtimer_force_reprogram(stru
 static int hrtimer_reprogram(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base)
 {
-	ktime_t *expires_next = &__get_cpu_var(hrtimer_bases).expires_next;
+	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	ktime_t expires = ktime_sub(timer->expires, base->offset);
 	int res;
 
@@ -396,7 +417,7 @@ static int hrtimer_reprogram(struct hrti
 	if (hrtimer_callback_running(timer))
 		return 0;
 
-	if (expires.tv64 >= expires_next->tv64)
+	if (expires.tv64 >= cpu_base->expires_next.tv64)
 		return 0;
 
 	/*
@@ -404,7 +425,7 @@ static int hrtimer_reprogram(struct hrti
 	 */
 	res = tick_program_event(expires, 0);
 	if (!IS_ERR_VALUE(res))
-		*expires_next = expires;
+		update_cpu_base_expires_next(cpu_base, expires);
 	return res;
 }
 
@@ -479,7 +500,7 @@ static inline void hrtimer_remove_cb_pen
  */
 static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base)
 {
-	base->expires_next.tv64 = KTIME_MAX;
+	update_cpu_base_expires_next(base, (ktime_t){ .tv64 = KTIME_MAX });
 	base->hres_active = 0;
 	INIT_LIST_HEAD(&base->cb_pending);
 }
@@ -543,7 +564,8 @@ static inline int hrtimer_enqueue_reprog
  */
 static int hrtimer_switch_to_hres(void)
 {
-	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
+	int cpu = smp_processor_id();
+	struct hrtimer_cpu_base *base = &per_cpu(hrtimer_bases, cpu);
 	unsigned long flags;
 
 	if (base->hres_active)
@@ -553,6 +575,8 @@ static int hrtimer_switch_to_hres(void)
 
 	if (tick_init_highres()) {
 		local_irq_restore(flags);
+		printk(KERN_WARNING "Could not switch to high resolution "
+				    "mode on CPU %d\n", cpu);
 		return 0;
 	}
 	base->hres_active = 1;
@@ -667,6 +691,7 @@ static void enqueue_hrtimer(struct hrtim
 	struct rb_node **link = &base->active.rb_node;
 	struct rb_node *parent = NULL;
 	struct hrtimer *entry;
+	int leftmost = 1;
 
 	/*
 	 * Find the right place in the rbtree:
@@ -678,18 +703,19 @@ static void enqueue_hrtimer(struct hrtim
 		 * We dont care about collisions. Nodes with
 		 * the same expiry time stay together.
 		 */
-		if (timer->expires.tv64 < entry->expires.tv64)
+		if (timer->expires.tv64 < entry->expires.tv64) {
 			link = &(*link)->rb_left;
-		else
+		} else {
 			link = &(*link)->rb_right;
+			leftmost = 0;
+		}
 	}
 
 	/*
 	 * Insert the timer to the rbtree and check whether it
 	 * replaces the first pending timer
 	 */
-	if (!base->first || timer->expires.tv64 <
-	    rb_entry(base->first, struct hrtimer, node)->expires.tv64) {
+	if (leftmost) {
 		/*
 		 * Reprogram the clock event device. When the timer is already
 		 * expired hrtimer_enqueue_reprogram has either called the
@@ -706,6 +732,9 @@ static void enqueue_hrtimer(struct hrtim
 
 	rb_link_node(&timer->node, parent, link);
 	rb_insert_color(&timer->node, &base->active);
+
+	WARN_ON(base->first != rb_first(&base->active));
+
 	/*
 	 * HRTIMER_STATE_ENQUEUED is or'ed to the current state to preserve the
 	 * state of a possibly running callback.
@@ -742,6 +771,7 @@ static void __remove_hrtimer(struct hrti
 				hrtimer_force_reprogram(base->cpu_base);
 		}
 		rb_erase(&timer->node, &base->active);
+		WARN_ON(base->first != rb_first(&base->active));
 	}
 	timer->state = newstate;
 }
@@ -1053,7 +1083,7 @@ void hrtimer_interrupt(struct clock_even
 		base++;
 	}
 
-	cpu_base->expires_next = expires_next;
+	update_cpu_base_expires_next(cpu_base, expires_next);
 
 	/* Reprogramming necessary ? */
 	if (expires_next.tv64 != KTIME_MAX) {
Index: linux/kernel/time/tick-oneshot.c
===================================================================
--- linux.orig/kernel/time/tick-oneshot.c
+++ linux/kernel/time/tick-oneshot.c
@@ -73,8 +73,19 @@ int tick_switch_to_oneshot(void (*handle
 	struct clock_event_device *dev = td->evtdev;
 
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
-	    !tick_device_is_functional(dev))
+		    !tick_device_is_functional(dev)) {
+
+		printk("could not switch to one-shot clockevents mode.\n");
+		if (!dev) {
+			printk("because no tick device\n");
+		} else {
+			if (!(dev->features & CLOCK_EVT_FEAT_ONESHOT))
+				printk("because %s does not support one-shot mode.\n", dev->name);
+			if (!tick_device_is_functional(dev))
+				printk("because %s is not functional.\n", dev->name);
+		}
 		return -EINVAL;
+	}
 
 	td->mode = TICKDEV_MODE_ONESHOT;
 	dev->event_handler = handler;
Index: linux/kernel/time/timer_list.c
===================================================================
--- linux.orig/kernel/time/timer_list.c
+++ linux/kernel/time/timer_list.c
@@ -46,7 +46,7 @@ static void print_name_offset(struct seq
 
 	sym_name = kallsyms_lookup(addr, &size, &offset, &modname, namebuf);
 	if (sym_name)
-		SEQ_printf(m, "%s", sym_name);
+		SEQ_printf(m, "%s+%lx/%lx", sym_name, offset, size);
 	else
 		SEQ_printf(m, "<%p>", sym);
 }
@@ -129,6 +129,23 @@ print_base(struct seq_file *m, struct hr
 	print_active_timers(m, base, now);
 }
 
+static void print_cpu_base_stack_trace(struct seq_file *m,
+				       struct hrtimer_cpu_base *cpu_base)
+{
+#ifdef CONFIG_STACKTRACE
+	struct stack_trace *trace = &cpu_base->exp_trace;
+	int i;
+
+	SEQ_printf(m, " last expires_next stacktrace:\n");
+	for (i = 0; i < trace->nr_entries; i++) {
+		SEQ_printf(m, "  ");
+		print_name_offset(m, (void *)trace->entries[i]);
+		SEQ_printf(m, "\n");
+	}
+	SEQ_printf(m, "\n");
+#endif
+}
+
 static void print_cpu(struct seq_file *m, int cpu, u64 now)
 {
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
@@ -147,6 +164,8 @@ static void print_cpu(struct seq_file *m
 
 #ifdef CONFIG_HIGH_RES_TIMERS
 	P_ns(expires_next);
+	P_ns(exp_prev);
+	print_cpu_base_stack_trace(m, cpu_base);
 	P(hres_active);
 	P(nr_events);
 #endif
