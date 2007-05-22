Return-Path: <linux-kernel-owner+w=401wt.eu-S936451AbXEVPdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936451AbXEVPdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934958AbXEVPT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:58 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:4999
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965795AbXEVPTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:17 -0400
Message-Id: <20070522141252.444845632@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:10:00 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       john stultz <johnstul@us.ibm.com>, Rik van Riel <riel@redhat.com>
Subject: [patch 19/33] xen: Account for time stolen by Xen
Content-Disposition: inline; filename=xen-stolen-time.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch accounts for the time Xen steals from our VCPUs.  Stolen
time is time where a vcpu is runnable and could be running, but all
available physical CPUs are being used for something else.

This accounting gets run on each timer interrupt, just as a way to get
it run relatively often, and when interesting things are going on.
Stolen time is not really used by much in the kernel; it is reported
in /proc/stats, and that's about it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
---
 arch/i386/xen/time.c |  163 ++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 153 insertions(+), 10 deletions(-)

===================================================================
--- a/arch/i386/xen/time.c
+++ b/arch/i386/xen/time.c
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
+#include <linux/kernel_stat.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
@@ -23,6 +24,7 @@
 
 #define XEN_SHIFT 22
 #define TIMER_SLOP	100000	/* Xen may fire a timer up to this many ns early */
+#define NS_PER_TICK	(1000000000ll / HZ)
 
 /* These are perodically updated in shared_info, and then copied here. */
 struct shadow_time_info {
@@ -35,6 +37,141 @@ struct shadow_time_info {
 
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
+/* return an consistent snapshot of 64-bit time/counter value */
+static u64 get64(const u64 *p)
+{
+	u64 ret;
+
+	if (BITS_PER_LONG < 64) {
+		u32 *p32 = (u32 *)p;
+		u32 h, l;
+
+		/*
+		 * Read high then low, and then make sure high is
+		 * still the same; this will only loop if low wraps
+		 * and carries into high.
+		 * XXX some clean way to make this endian-proof?
+		 */
+		do {
+			h = p32[1];
+			barrier();
+			l = p32[0];
+			barrier();
+		} while (p32[1] != h);
+
+		ret = (((u64)h) << 32) | l;
+	} else
+		ret = *p;
+
+	return ret;
+}
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
+		state_time = get64(&state->state_entry_time);
+		barrier();
+		*res = *state;
+		barrier();
+	} while(get64(&state->state_entry_time) != state_time);
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
+	s64 blocked, runnable, offline, stolen;
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
+
+	if (stolen < 0)
+		stolen = 0;
+
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
+
+	if (blocked < 0)
+		blocked = 0;
+
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
@@ -54,12 +191,10 @@ unsigned long xen_cpu_khz(void)
  * Reads a consistent set of time-base values from Xen, into a shadow data
  * area.
  */
-static void get_time_values_from_xen(void)
+static unsigned get_time_values_from_xen(void)
 {
 	struct vcpu_time_info   *src;
 	struct shadow_time_info *dst;
-
-	preempt_disable();
 
 	src = &__get_cpu_var(xen_vcpu)->time;
 	dst = &__get_cpu_var(shadow_time);
@@ -74,7 +209,7 @@ static void get_time_values_from_xen(voi
 		rmb();
 	} while ((src->version & 1) | (dst->version ^ src->version));
 
-	preempt_enable();
+	return dst->version;
 }
 
 /*
@@ -118,7 +253,7 @@ static u64 get_nsec_offset(struct shadow
 static u64 get_nsec_offset(struct shadow_time_info *shadow)
 {
 	u64 now, delta;
-	rdtscll(now);
+	now = native_read_tsc();
 	delta = now - shadow->tsc_timestamp;
 	return scale_delta(delta, shadow->tsc_to_nsec_mul, shadow->tsc_shift);
 }
@@ -127,10 +262,14 @@ cycle_t xen_clocksource_read(void)
 {
 	struct shadow_time_info *shadow = &get_cpu_var(shadow_time);
 	cycle_t ret;
-
-	get_time_values_from_xen();
-
-	ret = shadow->system_timestamp + get_nsec_offset(shadow);
+	unsigned version;
+
+	do {
+		version = get_time_values_from_xen();
+		barrier();
+		ret = shadow->system_timestamp + get_nsec_offset(shadow);
+		barrier();
+	} while(version != __get_cpu_var(xen_vcpu)->time.version);
 
 	put_cpu_var(shadow_time);
 
@@ -347,6 +486,8 @@ static irqreturn_t xen_timer_interrupt(i
 		ret = IRQ_HANDLED;
 	}
 
+	do_stolen_accounting();
+
 	return ret;
 }
 
@@ -373,6 +514,8 @@ static void xen_setup_timer(int cpu)
 	evt->irq = irq;
 	clockevents_register_device(evt);
 
+	setup_runstate_info();
+
 	put_cpu_var(xen_clock_events);
 }
 
@@ -385,7 +528,7 @@ __init void xen_time_init(void)
 	clocksource_register(&xen_clocksource);
 
 	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {
-		/* Successfully turned off 100hz tick, so we have the
+		/* Successfully turned off 100Hz tick, so we have the
 		   vcpuop-based timer interface */
 		printk(KERN_DEBUG "Xen: using vcpuop timer interface\n");
 		xen_clockevent = &xen_vcpuop_clockevent;

-- 

