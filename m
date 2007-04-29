Return-Path: <linux-kernel-owner+w=401wt.eu-S1030820AbXD2Ra6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030820AbXD2Ra6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030812AbXD2Ra4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:30:56 -0400
Received: from gw.goop.org ([64.81.55.164]:59060 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbXD2Rad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:33 -0400
Message-Id: <20070429172913.130362000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:28:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       john stultz <johnstul@us.ibm.com>, Rik van Riel <riel@redhat.com>
Subject: [patch 13/32] xen: Account for time stolen by Xen
Content-Disposition: inline; filename=xen-stolen-time.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This accounts for the time Xen steals from our VCPUs.  This accounting
gets run on each timer interrupt, just as a way to get it run
relatively often, and when interesting things are going on.

Stolen time is not really used by much in the kernel; it is reported
in /proc/stats, and that's about it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
---
 arch/i386/xen/time.c |  106 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 105 insertions(+), 1 deletion(-)

===================================================================
--- a/arch/i386/xen/time.c
+++ b/arch/i386/xen/time.c
@@ -2,6 +2,7 @@
 #include <linux/interrupt.h>
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
+#include <linux/kernel_stat.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
@@ -14,6 +15,7 @@
 
 #define XEN_SHIFT 22
 #define TIMER_SLOP	100000	/* Xen may fire a timer up to this many ns early */
+#define NS_PER_TICK	(1000000000ll / HZ)
 
 /* These are perodically updated in shared_info, and then copied here. */
 struct shadow_time_info {
@@ -26,6 +28,104 @@ struct shadow_time_info {
 
 static DEFINE_PER_CPU(struct shadow_time_info, shadow_time);
 
+/* runstate info updated by Xen */
+static DEFINE_PER_CPU(struct vcpu_runstate_info, runstate);
+
+/* snapshots of runstate info */
+static DEFINE_PER_CPU(struct vcpu_runstate_info, runstate_snapshot);
+
+/* unused ns of stolen and blocked time */
+static DEFINE_PER_CPU(u64, residual_stolen);
+static DEFINE_PER_CPU(u64, residual_blocked);
+
+/*
+ * Runstate accounting
+ */
+static void get_runstate_snapshot(struct vcpu_runstate_info *res)
+{
+	u64 state_time;
+	struct vcpu_runstate_info *state;
+
+	preempt_disable();
+
+	state = &__get_cpu_var(runstate);
+
+	/*
+	 * The runstate info is always updated by the hypervisor on
+	 * the current CPU, so there's no need to use anything
+	 * stronger than a compiler barrier when fetching it.
+	 */
+	do {
+		state_time = state->state_entry_time;
+		barrier();
+		*res = *state;
+		barrier();
+	} while(state->state_entry_time != state_time);
+
+	preempt_enable();
+}
+
+static void setup_runstate_info(void)
+{
+	struct vcpu_register_runstate_memory_area area;
+
+	area.addr.v = &__get_cpu_var(runstate);
+
+	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
+			       smp_processor_id(), &area))
+		BUG();
+
+	get_runstate_snapshot(&__get_cpu_var(runstate_snapshot));
+}
+
+static void do_stolen_accounting(void)
+{
+	struct vcpu_runstate_info state;
+	struct vcpu_runstate_info *snap;
+	u64 blocked, runnable, offline, stolen;
+	cputime_t ticks;
+
+	get_runstate_snapshot(&state);
+
+	WARN_ON(state.state != RUNSTATE_running);
+
+	snap = &__get_cpu_var(runstate_snapshot);
+
+	/* work out how much time the VCPU has not been runn*ing*  */
+	blocked = state.time[RUNSTATE_blocked] - snap->time[RUNSTATE_blocked];
+	runnable = state.time[RUNSTATE_runnable] - snap->time[RUNSTATE_runnable];
+	offline = state.time[RUNSTATE_offline] - snap->time[RUNSTATE_offline];
+
+	*snap = state;
+
+	/* Add the appropriate number of ticks of stolen time,
+	   including any left-overs from last time.  Passing NULL to
+	   account_steal_time accounts the time as stolen. */
+	stolen = runnable + offline + __get_cpu_var(residual_stolen);
+	ticks = 0;
+	while(stolen >= NS_PER_TICK) {
+		ticks++;
+		stolen -= NS_PER_TICK;
+	}
+	__get_cpu_var(residual_stolen) = stolen;
+	account_steal_time(NULL, ticks);
+
+	/* Add the appropriate number of ticks of blocked time,
+	   including any left-overs from last time.  Passing idle to
+	   account_steal_time accounts the time as idle/wait. */
+	blocked += __get_cpu_var(residual_blocked);
+	ticks = 0;
+	while(blocked >= NS_PER_TICK) {
+		ticks++;
+		blocked -= NS_PER_TICK;
+	}
+	__get_cpu_var(residual_blocked) = blocked;
+	account_steal_time(idle_task(smp_processor_id()), ticks);
+}
+
+
+
+/* Get the CPU speed from Xen */
 unsigned long xen_cpu_khz(void)
 {
 	u64 cpu_khz = 1000000ULL << 32;
@@ -338,6 +438,8 @@ static irqreturn_t xen_timer_interrupt(i
 		ret = IRQ_HANDLED;
 	}
 
+	do_stolen_accounting();
+
 	return ret;
 }
 
@@ -364,6 +466,8 @@ static void xen_setup_timer(int cpu)
 	evt->irq = irq;
 	clockevents_register_device(evt);
 
+	setup_runstate_info();
+
 	put_cpu_var(xen_clock_events);
 }
 
@@ -376,7 +480,7 @@ __init void xen_time_init(void)
 	clocksource_register(&xen_clocksource);
 
 	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {
-		/* Successfully turned off 100hz tick, so we have the
+		/* Successfully turned off 100Hz tick, so we have the
 		   vcpuop-based timer interface */
 		printk(KERN_DEBUG "Xen: using vcpuop timer interface\n");
 		xen_clockevent = &xen_vcpuop_clockevent;

-- 

