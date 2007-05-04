Return-Path: <linux-kernel-owner+w=401wt.eu-S1422919AbXEDXws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422919AbXEDXws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422954AbXEDXnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:43:10 -0400
Received: from 116.sub-75-210-58.myvzw.com ([75.210.58.116]:33789 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422919AbXEDXmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:42:38 -0400
Message-Id: <20070504232120.789766517@goop.org>
References: <20070504232051.411946839@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 May 2007 16:21:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 18/29] xen: deal with negative stolen time
Content-Disposition: inline; filename=xen-time-cleanups.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stolen time should never be negative; if it ever is, it probably
indicates some other bug.  However, if it does happen, then its better
to just clamp it at zero, rather than trying to account for it as a
huge positive number.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>

---
 arch/i386/xen/smp.c     |    4 +
 arch/i386/xen/time.c    |  112 ++++++++++++++++++++++++++++++++---------------
 arch/i386/xen/xen-ops.h |    3 -
 3 files changed, 83 insertions(+), 36 deletions(-)

===================================================================
--- a/arch/i386/xen/smp.c
+++ b/arch/i386/xen/smp.c
@@ -72,10 +72,11 @@ static __cpuinit void cpu_bringup_and_id
 	int cpu = smp_processor_id();
 
 	cpu_init();
-	xen_setup_timer();
 
 	preempt_disable();
 	per_cpu(cpu_state, cpu) = CPU_ONLINE;
+
+	xen_setup_cpu_clockevents();
 
 	/* We can take interrupts now: we're officially "up". */
 	local_irq_enable();
@@ -263,6 +264,7 @@ int __cpuinit xen_cpu_up(unsigned int cp
 	per_cpu(current_task, cpu) = idle;
 	xen_vcpu_setup(cpu);
 	irq_ctx_init(cpu);
+	xen_setup_timer(cpu);
 
 	/* make sure interrupts start blocked */
 	per_cpu(xen_vcpu, cpu)->evtchn_upcall_mask = 1;
===================================================================
--- a/arch/i386/xen/time.c
+++ b/arch/i386/xen/time.c
@@ -49,6 +49,35 @@ static DEFINE_PER_CPU(u64, residual_stol
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
@@ -67,31 +96,29 @@ static void get_runstate_snapshot(struct
 	 * stronger than a compiler barrier when fetching it.
 	 */
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
 {
 	struct vcpu_runstate_info state;
 	struct vcpu_runstate_info *snap;
-	u64 blocked, runnable, offline, stolen;
+	s64 blocked, runnable, offline, stolen;
 	cputime_t ticks;
 
 	get_runstate_snapshot(&state);
@@ -111,6 +138,10 @@ static void do_stolen_accounting(void)
 	   including any left-overs from last time.  Passing NULL to
 	   account_steal_time accounts the time as stolen. */
 	stolen = runnable + offline + __get_cpu_var(residual_stolen);
+
+	if (stolen < 0)
+		stolen = 0;
+
 	ticks = 0;
 	while(stolen >= NS_PER_TICK) {
 		ticks++;
@@ -123,6 +154,10 @@ static void do_stolen_accounting(void)
 	   including any left-overs from last time.  Passing idle to
 	   account_steal_time accounts the time as idle/wait. */
 	blocked += __get_cpu_var(residual_blocked);
+
+	if (blocked < 0)
+		blocked = 0;
+
 	ticks = 0;
 	while(blocked >= NS_PER_TICK) {
 		ticks++;
@@ -141,7 +176,8 @@ unsigned long long xen_sched_clock(void)
 {
 	struct vcpu_runstate_info state;
 	cycle_t now;
-	unsigned long long ret;
+	u64 ret;
+	s64 offset;
 
 	/*
 	 * Ideally sched_clock should be called on a per-cpu basis
@@ -156,9 +192,13 @@ unsigned long long xen_sched_clock(void)
 
 	WARN_ON(state.state != RUNSTATE_running);
 
+	offset = now - state.state_entry_time;
+	if (offset < 0)
+		offset = 0;
+
 	ret = state.time[RUNSTATE_blocked] +
 		state.time[RUNSTATE_running] +
-		(now - state.state_entry_time);
+		offset;
 
 	preempt_enable();
 
@@ -186,12 +226,10 @@ unsigned long xen_cpu_khz(void)
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
@@ -206,7 +244,7 @@ static void get_time_values_from_xen(voi
 		rmb();
 	} while ((src->version & 1) | (dst->version ^ src->version));
 
-	preempt_enable();
+	return dst->version;
 }
 
 /*
@@ -250,7 +288,7 @@ static u64 get_nsec_offset(struct shadow
 static u64 get_nsec_offset(struct shadow_time_info *shadow)
 {
 	u64 now, delta;
-	rdtscll(now);
+	now = native_read_tsc();
 	delta = now - shadow->tsc_timestamp;
 	return scale_delta(delta, shadow->tsc_to_nsec_mul, shadow->tsc_shift);
 }
@@ -259,10 +297,14 @@ static cycle_t xen_clocksource_read(void
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
 
@@ -484,9 +526,8 @@ static irqreturn_t xen_timer_interrupt(i
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
@@ -501,23 +542,25 @@ void xen_setup_timer(void)
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
 
@@ -535,5 +578,6 @@ __init void xen_time_init(void)
 
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

