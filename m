Return-Path: <linux-kernel-owner+w=401wt.eu-S1030950AbXD2RdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030950AbXD2RdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXD2RcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:32:00 -0400
Received: from gw.goop.org ([64.81.55.164]:58988 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372AbXD2RaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:17 -0400
Message-Id: <20070429172913.320003000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:28:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       john stultz <johnstul@us.ibm.com>
Subject: [patch 14/32] xen: Implement xen_sched_clock
Content-Disposition: inline; filename=xen-sched-clock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement xen_sched_clock, which returns the number of ns the current
vcpu has been actually in an unstolen state (ie, running or blocked,
vs runnable-but-not-running, or offline) since boot.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: john stultz <johnstul@us.ibm.com>

---
 arch/i386/xen/enlighten.c |    2 +-
 arch/i386/xen/time.c      |   22 +++++++++++++++++++++-
 arch/i386/xen/xen-ops.h   |    3 +--
 3 files changed, 23 insertions(+), 4 deletions(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -676,7 +676,7 @@ static const struct paravirt_ops xen_par
 	.set_wallclock = xen_set_wallclock,
 	.get_wallclock = xen_get_wallclock,
 	.get_cpu_khz = xen_cpu_khz,
-	.sched_clock = xen_clocksource_read,
+	.sched_clock = xen_sched_clock,
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	.apic_write = paravirt_nop,
===================================================================
--- a/arch/i386/xen/time.c
+++ b/arch/i386/xen/time.c
@@ -16,6 +16,8 @@
 #define XEN_SHIFT 22
 #define TIMER_SLOP	100000	/* Xen may fire a timer up to this many ns early */
 #define NS_PER_TICK	(1000000000ll / HZ)
+
+static cycle_t xen_clocksource_read(void);
 
 /* These are perodically updated in shared_info, and then copied here. */
 struct shadow_time_info {
@@ -118,6 +120,24 @@ static void do_stolen_accounting(void)
 	account_steal_time(idle_task(smp_processor_id()), ticks);
 }
 
+/*
+ * Xen sched_clock implementation.  Returns the number of unstolen
+ * nanoseconds, which is nanoseconds the VCPU spent in RUNNING+BLOCKED
+ * states.
+ */
+unsigned long long xen_sched_clock(void)
+{
+	struct vcpu_runstate_info state;
+	cycle_t now = xen_clocksource_read();
+
+	get_runstate_snapshot(&state);
+
+	WARN_ON(state.state != RUNSTATE_running);
+
+	return state.time[RUNSTATE_blocked] +
+		state.time[RUNSTATE_running] +
+		(now - state.state_entry_time);
+}
 
 
 /* Get the CPU speed from Xen */
@@ -209,7 +229,7 @@ static u64 get_nsec_offset(struct shadow
 	return scale_delta(delta, shadow->tsc_to_nsec_mul, shadow->tsc_shift);
 }
 
-cycle_t xen_clocksource_read(void)
+static cycle_t xen_clocksource_read(void)
 {
 	struct shadow_time_info *shadow = &get_cpu_var(shadow_time);
 	cycle_t ret;
===================================================================
--- a/arch/i386/xen/xen-ops.h
+++ b/arch/i386/xen/xen-ops.h
@@ -2,7 +2,6 @@
 #define XEN_OPS_H
 
 #include <linux/init.h>
-#include <linux/clocksource.h>
 
 DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DECLARE_PER_CPU(unsigned long, xen_cr3);
@@ -18,7 +17,7 @@ void __init xen_time_init(void);
 void __init xen_time_init(void);
 unsigned long xen_get_wallclock(void);
 int xen_set_wallclock(unsigned long time);
-cycle_t xen_clocksource_read(void);
+unsigned long long xen_sched_clock(void);
 
 void xen_mark_init_mm_pinned(void);
 

-- 

