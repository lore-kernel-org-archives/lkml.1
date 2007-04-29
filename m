Return-Path: <linux-kernel-owner+w=401wt.eu-S965030AbXD2Rkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030AbXD2Rkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbXD2RbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:31:18 -0400
Received: from gw.goop.org ([64.81.55.164]:58998 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409AbXD2RaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:23 -0400
Message-Id: <20070429172914.316524000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:28:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 19/32] xen: xen time fixups
Content-Disposition: inline; filename=xen-time-fixups.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1. make sure timer state is set up before bringing up CPU
2. make sure snapshot of 64-bit time values is atomic

Be sure, however, that the clockevent source is registered on its home
CPU.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/xen/smp.c     |    4 +-
 arch/i386/xen/time.c    |   93 +++++++++++++++++++++++++++++++----------------
 arch/i386/xen/xen-ops.h |    3 +
 3 files changed, 67 insertions(+), 33 deletions(-)

===================================================================
--- a/arch/i386/xen/smp.c
+++ b/arch/i386/xen/smp.c
@@ -78,10 +78,11 @@ static __cpuinit void cpu_bringup_and_id
 	int cpu = smp_processor_id();
 
 	cpu_init();
-	xen_setup_timer();
 
 	preempt_disable();
 	per_cpu(cpu_state, cpu) = CPU_ONLINE;
+
+	xen_setup_cpu_clockevents();
 
 	/* We can take interrupts now: we're officially "up". */
 	local_irq_enable();
@@ -275,6 +276,7 @@ int __cpuinit xen_cpu_up(unsigned int cp
 	per_cpu(current_task, cpu) = idle;
 	xen_vcpu_setup(cpu);
 	irq_ctx_init(cpu);
+	xen_setup_timer(cpu);
 
 	/* make sure interrupts start blocked */
 	per_cpu(xen_vcpu, cpu)->evtchn_upcall_mask = 1;
===================================================================
--- a/arch/i386/xen/time.c
+++ b/arch/i386/xen/time.c
@@ -40,6 +40,35 @@ static DEFINE_PER_CPU(u64, residual_stol
 static DEFINE_PER_CPU(u64, residual_stolen);
 static DEFINE_PER_CPU(u64, residual_blocked);
 
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
 /*
  * Runstate accounting
  */
@@ -53,24 +82,22 @@ static void get_runstate_snapshot(struct
 	state = &__get_cpu_var(runstate);
 
 	do {
-		state_time = state->state_entry_time;
+		state_time = get64(&state->state_entry_time);
 		barrier();
 		*res = *state;
 		barrier();
-	} while(state->state_entry_time != state_time);
-}
-
-static void setup_runstate_info(void)
+	} while(get64(&state->state_entry_time) != state_time);
+}
+
+static void setup_runstate_info(int cpu)
 {
 	struct vcpu_register_runstate_memory_area area;
 
-	area.addr.v = &__get_cpu_var(runstate);
+	area.addr.v = &per_cpu(runstate, cpu);
 
 	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
-			       smp_processor_id(), &area))
+			       cpu, &area))
 		BUG();
-
-	get_runstate_snapshot(&__get_cpu_var(runstate_snapshot));
 }
 
 static void do_stolen_accounting(void)
@@ -185,12 +212,10 @@ unsigned long xen_cpu_khz(void)
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
@@ -205,7 +230,7 @@ static void get_time_values_from_xen(voi
 		rmb();
 	} while ((src->version & 1) | (dst->version ^ src->version));
 
-	preempt_enable();
+	return dst->version;
 }
 
 /*
@@ -249,7 +274,7 @@ static u64 get_nsec_offset(struct shadow
 static u64 get_nsec_offset(struct shadow_time_info *shadow)
 {
 	u64 now, delta;
-	rdtscll(now);
+	now = native_read_tsc();
 	delta = now - shadow->tsc_timestamp;
 	return scale_delta(delta, shadow->tsc_to_nsec_mul, shadow->tsc_shift);
 }
@@ -258,10 +283,14 @@ static cycle_t xen_clocksource_read(void
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
 
@@ -483,9 +512,8 @@ static irqreturn_t xen_timer_interrupt(i
 	return ret;
 }
 
-void xen_setup_timer(void)
-{
-	int cpu = smp_processor_id();
+void xen_setup_timer(int cpu)
+{
 	const char *name;
 	struct clock_event_device *evt;
 	int irq;
@@ -500,23 +528,25 @@ void xen_setup_timer(void)
 				      IRQF_DISABLED|IRQF_PERCPU|IRQF_NOBALANCING,
 				      name, NULL);
 
-	evt = &get_cpu_var(xen_clock_events);
+	evt = &per_cpu(xen_clock_events, cpu);
 	memcpy(evt, xen_clockevent, sizeof(*evt));
 
 	evt->cpumask = cpumask_of_cpu(cpu);
 	evt->irq = irq;
-	clockevents_register_device(evt);
-
-	setup_runstate_info();
-
-	put_cpu_var(xen_clock_events);
+
+	setup_runstate_info(cpu);
+}
+
+void xen_setup_cpu_clockevents(void)
+{
+	BUG_ON(preemptible());
+
+	clockevents_register_device(&__get_cpu_var(xen_clock_events));
 }
 
 __init void xen_time_init(void)
 {
 	int cpu = smp_processor_id();
-
-	get_time_values_from_xen();
 
 	clocksource_register(&xen_clocksource);
 
@@ -534,5 +564,6 @@ __init void xen_time_init(void)
 
 	tsc_disable = 0;
 
-	xen_setup_timer();
-}
+	xen_setup_timer(cpu);
+	xen_setup_cpu_clockevents();
+}
===================================================================
--- a/arch/i386/xen/xen-ops.h
+++ b/arch/i386/xen/xen-ops.h
@@ -25,7 +25,8 @@ unsigned long xen_get_wallclock(void);
 unsigned long xen_get_wallclock(void);
 int xen_set_wallclock(unsigned long time);
 unsigned long long xen_sched_clock(void);
-void xen_setup_timer(void);
+void xen_setup_timer(int cpu);
+void xen_setup_cpu_clockevents(void);
 
 void xen_mark_init_mm_pinned(void);
 

-- 

