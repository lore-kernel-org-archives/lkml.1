Return-Path: <linux-kernel-owner+w=401wt.eu-S935183AbXEVP1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935183AbXEVP1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934827AbXEVPTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:38 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:5007
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965709AbXEVPTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:15 -0400
Message-Id: <20070522141252.554886649@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:10:01 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       john stultz <johnstul@us.ibm.com>
Subject: [patch 20/33] xen: Implement xen_sched_clock
Content-Disposition: inline; filename=xen-sched-clock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement xen_sched_clock, which returns the number of ns the current
vcpu has been actually in an unstolen state (ie, running or blocked,
vs runnable-but-not-running, or offline) since boot.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
Cc: john stultz <johnstul@us.ibm.com>

---
 arch/i386/xen/enlighten.c |    2 +-
 arch/i386/xen/time.c      |   27 ++++++++++++++++++++++++++-
 arch/i386/xen/xen-ops.h   |    3 +--
 3 files changed, 28 insertions(+), 4 deletions(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -679,7 +679,7 @@ static const struct paravirt_ops xen_par
 	.set_wallclock = xen_set_wallclock,
 	.get_wallclock = xen_get_wallclock,
 	.get_cpu_khz = xen_cpu_khz,
-	.sched_clock = xen_clocksource_read,
+	.sched_clock = xen_sched_clock,
 
 	.cpuid = xen_cpuid,
 
===================================================================
--- a/arch/i386/xen/time.c
+++ b/arch/i386/xen/time.c
@@ -26,6 +26,8 @@
 #define TIMER_SLOP	100000	/* Xen may fire a timer up to this many ns early */
 #define NS_PER_TICK	(1000000000ll / HZ)
 
+static cycle_t xen_clocksource_read(void);
+
 /* These are perodically updated in shared_info, and then copied here. */
 struct shadow_time_info {
 	u64 tsc_timestamp;     /* TSC at last update of time vals.  */
@@ -169,6 +171,29 @@ static void do_stolen_accounting(void)
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
+	s64 offset;
+
+	get_runstate_snapshot(&state);
+
+	WARN_ON(state.state != RUNSTATE_running);
+
+	offset = now - state.state_entry_time;
+	if (offset < 0)
+		offset = 0;
+
+ 	return state.time[RUNSTATE_blocked] +
+ 		state.time[RUNSTATE_running] +
+		offset;
+}
 
 
 /* Get the CPU speed from Xen */
@@ -258,7 +283,7 @@ static u64 get_nsec_offset(struct shadow
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

