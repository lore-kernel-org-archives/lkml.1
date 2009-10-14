Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbZJNGDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbZJNGDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZJNGDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:03:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:58692 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbZJNGDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:03:34 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, rostedt@goodmis.org, hpa@zytor.com,
       cebbert@redhat.com
Cc: Tejun Heo <tj@kernel.org>, Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 08/16] percpu: make percpu symbols in xen unique
Date: Wed, 14 Oct 2009 15:01:57 +0900
Message-Id: <1255500125-3210-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255500125-3210-1-git-send-email-tj@kernel.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:02:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates percpu related symbols in xen such that percpu
symbols are unique and don't clash with local symbols.  This serves
two purposes of decreasing the possibility of global percpu symbol
collision and allowing dropping per_cpu__ prefix from percpu symbols.

* arch/x86/xen/smp.c, arch/x86/xen/time.c, arch/ia64/xen/irq_xen.c:
  add xen_ prefix to percpu variables

* arch/ia64/xen/time.c: add xen_ prefix to percpu variables, drop
  processed_ prefix and make them static

Partly based on Rusty Russell's "alloc_percpu: rename percpu vars
which cause name clashes" patch.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
---
 arch/ia64/xen/irq_xen.c |  131 ++++++++++++++++++++++++-----------------------
 arch/ia64/xen/time.c    |   22 ++++----
 arch/x86/xen/smp.c      |   41 ++++++++-------
 arch/x86/xen/time.c     |   24 ++++----
 4 files changed, 111 insertions(+), 107 deletions(-)

diff --git a/arch/ia64/xen/irq_xen.c b/arch/ia64/xen/irq_xen.c
index f042e19..a3fb7cf 100644
--- a/arch/ia64/xen/irq_xen.c
+++ b/arch/ia64/xen/irq_xen.c
@@ -63,19 +63,19 @@ xen_free_irq_vector(int vector)
 }
 
 
-static DEFINE_PER_CPU(int, timer_irq) = -1;
-static DEFINE_PER_CPU(int, ipi_irq) = -1;
-static DEFINE_PER_CPU(int, resched_irq) = -1;
-static DEFINE_PER_CPU(int, cmc_irq) = -1;
-static DEFINE_PER_CPU(int, cmcp_irq) = -1;
-static DEFINE_PER_CPU(int, cpep_irq) = -1;
+static DEFINE_PER_CPU(int, xen_timer_irq) = -1;
+static DEFINE_PER_CPU(int, xen_ipi_irq) = -1;
+static DEFINE_PER_CPU(int, xen_resched_irq) = -1;
+static DEFINE_PER_CPU(int, xen_cmc_irq) = -1;
+static DEFINE_PER_CPU(int, xen_cmcp_irq) = -1;
+static DEFINE_PER_CPU(int, xen_cpep_irq) = -1;
 #define NAME_SIZE	15
-static DEFINE_PER_CPU(char[NAME_SIZE], timer_name);
-static DEFINE_PER_CPU(char[NAME_SIZE], ipi_name);
-static DEFINE_PER_CPU(char[NAME_SIZE], resched_name);
-static DEFINE_PER_CPU(char[NAME_SIZE], cmc_name);
-static DEFINE_PER_CPU(char[NAME_SIZE], cmcp_name);
-static DEFINE_PER_CPU(char[NAME_SIZE], cpep_name);
+static DEFINE_PER_CPU(char[NAME_SIZE], xen_timer_name);
+static DEFINE_PER_CPU(char[NAME_SIZE], xen_ipi_name);
+static DEFINE_PER_CPU(char[NAME_SIZE], xen_resched_name);
+static DEFINE_PER_CPU(char[NAME_SIZE], xen_cmc_name);
+static DEFINE_PER_CPU(char[NAME_SIZE], xen_cmcp_name);
+static DEFINE_PER_CPU(char[NAME_SIZE], xen_cpep_name);
 #undef NAME_SIZE
 
 struct saved_irq {
@@ -144,64 +144,64 @@ __xen_register_percpu_irq(unsigned int cpu, unsigned int vec,
 	if (xen_slab_ready) {
 		switch (vec) {
 		case IA64_TIMER_VECTOR:
-			snprintf(per_cpu(timer_name, cpu),
-				 sizeof(per_cpu(timer_name, cpu)),
+			snprintf(per_cpu(xen_timer_name, cpu),
+				 sizeof(per_cpu(xen_timer_name, cpu)),
 				 "%s%d", action->name, cpu);
 			irq = bind_virq_to_irqhandler(VIRQ_ITC, cpu,
 				action->handler, action->flags,
-				per_cpu(timer_name, cpu), action->dev_id);
-			per_cpu(timer_irq, cpu) = irq;
+				per_cpu(xen_timer_name, cpu), action->dev_id);
+			per_cpu(xen_timer_irq, cpu) = irq;
 			break;
 		case IA64_IPI_RESCHEDULE:
-			snprintf(per_cpu(resched_name, cpu),
-				 sizeof(per_cpu(resched_name, cpu)),
+			snprintf(per_cpu(xen_resched_name, cpu),
+				 sizeof(per_cpu(xen_resched_name, cpu)),
 				 "%s%d", action->name, cpu);
 			irq = bind_ipi_to_irqhandler(XEN_RESCHEDULE_VECTOR, cpu,
 				action->handler, action->flags,
-				per_cpu(resched_name, cpu), action->dev_id);
-			per_cpu(resched_irq, cpu) = irq;
+				per_cpu(xen_resched_name, cpu), action->dev_id);
+			per_cpu(xen_resched_irq, cpu) = irq;
 			break;
 		case IA64_IPI_VECTOR:
-			snprintf(per_cpu(ipi_name, cpu),
-				 sizeof(per_cpu(ipi_name, cpu)),
+			snprintf(per_cpu(xen_ipi_name, cpu),
+				 sizeof(per_cpu(xen_ipi_name, cpu)),
 				 "%s%d", action->name, cpu);
 			irq = bind_ipi_to_irqhandler(XEN_IPI_VECTOR, cpu,
 				action->handler, action->flags,
-				per_cpu(ipi_name, cpu), action->dev_id);
-			per_cpu(ipi_irq, cpu) = irq;
+				per_cpu(xen_ipi_name, cpu), action->dev_id);
+			per_cpu(xen_ipi_irq, cpu) = irq;
 			break;
 		case IA64_CMC_VECTOR:
-			snprintf(per_cpu(cmc_name, cpu),
-				 sizeof(per_cpu(cmc_name, cpu)),
+			snprintf(per_cpu(xen_cmc_name, cpu),
+				 sizeof(per_cpu(xen_cmc_name, cpu)),
 				 "%s%d", action->name, cpu);
 			irq = bind_virq_to_irqhandler(VIRQ_MCA_CMC, cpu,
-						      action->handler,
-						      action->flags,
-						      per_cpu(cmc_name, cpu),
-						      action->dev_id);
-			per_cpu(cmc_irq, cpu) = irq;
+						action->handler,
+						action->flags,
+						per_cpu(xen_cmc_name, cpu),
+						action->dev_id);
+			per_cpu(xen_cmc_irq, cpu) = irq;
 			break;
 		case IA64_CMCP_VECTOR:
-			snprintf(per_cpu(cmcp_name, cpu),
-				 sizeof(per_cpu(cmcp_name, cpu)),
+			snprintf(per_cpu(xen_cmcp_name, cpu),
+				 sizeof(per_cpu(xen_cmcp_name, cpu)),
 				 "%s%d", action->name, cpu);
 			irq = bind_ipi_to_irqhandler(XEN_CMCP_VECTOR, cpu,
-						     action->handler,
-						     action->flags,
-						     per_cpu(cmcp_name, cpu),
-						     action->dev_id);
-			per_cpu(cmcp_irq, cpu) = irq;
+						action->handler,
+						action->flags,
+						per_cpu(xen_cmcp_name, cpu),
+						action->dev_id);
+			per_cpu(xen_cmcp_irq, cpu) = irq;
 			break;
 		case IA64_CPEP_VECTOR:
-			snprintf(per_cpu(cpep_name, cpu),
-				 sizeof(per_cpu(cpep_name, cpu)),
+			snprintf(per_cpu(xen_cpep_name, cpu),
+				 sizeof(per_cpu(xen_cpep_name, cpu)),
 				 "%s%d", action->name, cpu);
 			irq = bind_ipi_to_irqhandler(XEN_CPEP_VECTOR, cpu,
-						     action->handler,
-						     action->flags,
-						     per_cpu(cpep_name, cpu),
-						     action->dev_id);
-			per_cpu(cpep_irq, cpu) = irq;
+						action->handler,
+						action->flags,
+						per_cpu(xen_cpep_name, cpu),
+						action->dev_id);
+			per_cpu(xen_cpep_irq, cpu) = irq;
 			break;
 		case IA64_CPE_VECTOR:
 		case IA64_MCA_RENDEZ_VECTOR:
@@ -275,30 +275,33 @@ unbind_evtchn_callback(struct notifier_block *nfb,
 
 	if (action == CPU_DEAD) {
 		/* Unregister evtchn.  */
-		if (per_cpu(cpep_irq, cpu) >= 0) {
-			unbind_from_irqhandler(per_cpu(cpep_irq, cpu), NULL);
-			per_cpu(cpep_irq, cpu) = -1;
+		if (per_cpu(xen_cpep_irq, cpu) >= 0) {
+			unbind_from_irqhandler(per_cpu(xen_cpep_irq, cpu),
+					       NULL);
+			per_cpu(xen_cpep_irq, cpu) = -1;
 		}
-		if (per_cpu(cmcp_irq, cpu) >= 0) {
-			unbind_from_irqhandler(per_cpu(cmcp_irq, cpu), NULL);
-			per_cpu(cmcp_irq, cpu) = -1;
+		if (per_cpu(xen_cmcp_irq, cpu) >= 0) {
+			unbind_from_irqhandler(per_cpu(xen_cmcp_irq, cpu),
+					       NULL);
+			per_cpu(xen_cmcp_irq, cpu) = -1;
 		}
-		if (per_cpu(cmc_irq, cpu) >= 0) {
-			unbind_from_irqhandler(per_cpu(cmc_irq, cpu), NULL);
-			per_cpu(cmc_irq, cpu) = -1;
+		if (per_cpu(xen_cmc_irq, cpu) >= 0) {
+			unbind_from_irqhandler(per_cpu(xen_cmc_irq, cpu), NULL);
+			per_cpu(xen_cmc_irq, cpu) = -1;
 		}
-		if (per_cpu(ipi_irq, cpu) >= 0) {
-			unbind_from_irqhandler(per_cpu(ipi_irq, cpu), NULL);
-			per_cpu(ipi_irq, cpu) = -1;
+		if (per_cpu(xen_ipi_irq, cpu) >= 0) {
+			unbind_from_irqhandler(per_cpu(xen_ipi_irq, cpu), NULL);
+			per_cpu(xen_ipi_irq, cpu) = -1;
 		}
-		if (per_cpu(resched_irq, cpu) >= 0) {
-			unbind_from_irqhandler(per_cpu(resched_irq, cpu),
-						NULL);
-			per_cpu(resched_irq, cpu) = -1;
+		if (per_cpu(xen_resched_irq, cpu) >= 0) {
+			unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu),
+					       NULL);
+			per_cpu(xen_resched_irq, cpu) = -1;
 		}
-		if (per_cpu(timer_irq, cpu) >= 0) {
-			unbind_from_irqhandler(per_cpu(timer_irq, cpu), NULL);
-			per_cpu(timer_irq, cpu) = -1;
+		if (per_cpu(xen_timer_irq, cpu) >= 0) {
+			unbind_from_irqhandler(per_cpu(xen_timer_irq, cpu),
+					       NULL);
+			per_cpu(xen_timer_irq, cpu) = -1;
 		}
 	}
 	return NOTIFY_OK;
diff --git a/arch/ia64/xen/time.c b/arch/ia64/xen/time.c
index dbeadb9..c1c5445 100644
--- a/arch/ia64/xen/time.c
+++ b/arch/ia64/xen/time.c
@@ -34,15 +34,15 @@
 
 #include "../kernel/fsyscall_gtod_data.h"
 
-DEFINE_PER_CPU(struct vcpu_runstate_info, runstate);
-DEFINE_PER_CPU(unsigned long, processed_stolen_time);
-DEFINE_PER_CPU(unsigned long, processed_blocked_time);
+static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate);
+static DEFINE_PER_CPU(unsigned long, xen_stolen_time);
+static DEFINE_PER_CPU(unsigned long, xen_blocked_time);
 
 /* taken from i386/kernel/time-xen.c */
 static void xen_init_missing_ticks_accounting(int cpu)
 {
 	struct vcpu_register_runstate_memory_area area;
-	struct vcpu_runstate_info *runstate = &per_cpu(runstate, cpu);
+	struct vcpu_runstate_info *runstate = &per_cpu(xen_runstate, cpu);
 	int rc;
 
 	memset(runstate, 0, sizeof(*runstate));
@@ -52,8 +52,8 @@ static void xen_init_missing_ticks_accounting(int cpu)
 				&area);
 	WARN_ON(rc && rc != -ENOSYS);
 
-	per_cpu(processed_blocked_time, cpu) = runstate->time[RUNSTATE_blocked];
-	per_cpu(processed_stolen_time, cpu) = runstate->time[RUNSTATE_runnable]
+	per_cpu(xen_blocked_time, cpu) = runstate->time[RUNSTATE_blocked];
+	per_cpu(xen_stolen_time, cpu) = runstate->time[RUNSTATE_runnable]
 					    + runstate->time[RUNSTATE_offline];
 }
 
@@ -68,7 +68,7 @@ static void get_runstate_snapshot(struct vcpu_runstate_info *res)
 
 	BUG_ON(preemptible());
 
-	state = &__get_cpu_var(runstate);
+	state = &__get_cpu_var(xen_runstate);
 
 	/*
 	 * The runstate info is always updated by the hypervisor on
@@ -103,12 +103,12 @@ consider_steal_time(unsigned long new_itm)
 	 * This function just checks and reject this effect.
 	 */
 	if (!time_after_eq(runstate.time[RUNSTATE_blocked],
-			   per_cpu(processed_blocked_time, cpu)))
+			   per_cpu(xen_blocked_time, cpu)))
 		blocked = 0;
 
 	if (!time_after_eq(runstate.time[RUNSTATE_runnable] +
 			   runstate.time[RUNSTATE_offline],
-			   per_cpu(processed_stolen_time, cpu)))
+			   per_cpu(xen_stolen_time, cpu)))
 		stolen = 0;
 
 	if (!time_after(delta_itm + new_itm, ia64_get_itc()))
@@ -147,8 +147,8 @@ consider_steal_time(unsigned long new_itm)
 		} else {
 			local_cpu_data->itm_next = delta_itm + new_itm;
 		}
-		per_cpu(processed_stolen_time, cpu) += NS_PER_TICK * stolen;
-		per_cpu(processed_blocked_time, cpu) += NS_PER_TICK * blocked;
+		per_cpu(xen_stolen_time, cpu) += NS_PER_TICK * stolen;
+		per_cpu(xen_blocked_time, cpu) += NS_PER_TICK * blocked;
 	}
 	return delta_itm;
 }
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index fe03eee..1167d98 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -35,10 +35,10 @@
 
 cpumask_var_t xen_cpu_initialized_map;
 
-static DEFINE_PER_CPU(int, resched_irq);
-static DEFINE_PER_CPU(int, callfunc_irq);
-static DEFINE_PER_CPU(int, callfuncsingle_irq);
-static DEFINE_PER_CPU(int, debug_irq) = -1;
+static DEFINE_PER_CPU(int, xen_resched_irq);
+static DEFINE_PER_CPU(int, xen_callfunc_irq);
+static DEFINE_PER_CPU(int, xen_callfuncsingle_irq);
+static DEFINE_PER_CPU(int, xen_debug_irq) = -1;
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id);
 static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id);
@@ -103,7 +103,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 				    NULL);
 	if (rc < 0)
 		goto fail;
-	per_cpu(resched_irq, cpu) = rc;
+	per_cpu(xen_resched_irq, cpu) = rc;
 
 	callfunc_name = kasprintf(GFP_KERNEL, "callfunc%d", cpu);
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_VECTOR,
@@ -114,7 +114,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 				    NULL);
 	if (rc < 0)
 		goto fail;
-	per_cpu(callfunc_irq, cpu) = rc;
+	per_cpu(xen_callfunc_irq, cpu) = rc;
 
 	debug_name = kasprintf(GFP_KERNEL, "debug%d", cpu);
 	rc = bind_virq_to_irqhandler(VIRQ_DEBUG, cpu, xen_debug_interrupt,
@@ -122,7 +122,7 @@ static int xen_smp_intr_init(unsigned int cpu)
 				     debug_name, NULL);
 	if (rc < 0)
 		goto fail;
-	per_cpu(debug_irq, cpu) = rc;
+	per_cpu(xen_debug_irq, cpu) = rc;
 
 	callfunc_name = kasprintf(GFP_KERNEL, "callfuncsingle%d", cpu);
 	rc = bind_ipi_to_irqhandler(XEN_CALL_FUNCTION_SINGLE_VECTOR,
@@ -133,19 +133,20 @@ static int xen_smp_intr_init(unsigned int cpu)
 				    NULL);
 	if (rc < 0)
 		goto fail;
-	per_cpu(callfuncsingle_irq, cpu) = rc;
+	per_cpu(xen_callfuncsingle_irq, cpu) = rc;
 
 	return 0;
 
  fail:
-	if (per_cpu(resched_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(resched_irq, cpu), NULL);
-	if (per_cpu(callfunc_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(callfunc_irq, cpu), NULL);
-	if (per_cpu(debug_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(debug_irq, cpu), NULL);
-	if (per_cpu(callfuncsingle_irq, cpu) >= 0)
-		unbind_from_irqhandler(per_cpu(callfuncsingle_irq, cpu), NULL);
+	if (per_cpu(xen_resched_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu), NULL);
+	if (per_cpu(xen_callfunc_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
+	if (per_cpu(xen_debug_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
+	if (per_cpu(xen_callfuncsingle_irq, cpu) >= 0)
+		unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu),
+				       NULL);
 
 	return rc;
 }
@@ -348,10 +349,10 @@ static void xen_cpu_die(unsigned int cpu)
 		current->state = TASK_UNINTERRUPTIBLE;
 		schedule_timeout(HZ/10);
 	}
-	unbind_from_irqhandler(per_cpu(resched_irq, cpu), NULL);
-	unbind_from_irqhandler(per_cpu(callfunc_irq, cpu), NULL);
-	unbind_from_irqhandler(per_cpu(debug_irq, cpu), NULL);
-	unbind_from_irqhandler(per_cpu(callfuncsingle_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(xen_resched_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(xen_callfunc_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(xen_debug_irq, cpu), NULL);
+	unbind_from_irqhandler(per_cpu(xen_callfuncsingle_irq, cpu), NULL);
 	xen_uninit_lock_cpu(cpu);
 	xen_teardown_timer(cpu);
 
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 0a5aa44..26e37b7 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -31,14 +31,14 @@
 #define NS_PER_TICK	(1000000000LL / HZ)
 
 /* runstate info updated by Xen */
-static DEFINE_PER_CPU(struct vcpu_runstate_info, runstate);
+static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate);
 
 /* snapshots of runstate info */
-static DEFINE_PER_CPU(struct vcpu_runstate_info, runstate_snapshot);
+static DEFINE_PER_CPU(struct vcpu_runstate_info, xen_runstate_snapshot);
 
 /* unused ns of stolen and blocked time */
-static DEFINE_PER_CPU(u64, residual_stolen);
-static DEFINE_PER_CPU(u64, residual_blocked);
+static DEFINE_PER_CPU(u64, xen_residual_stolen);
+static DEFINE_PER_CPU(u64, xen_residual_blocked);
 
 /* return an consistent snapshot of 64-bit time/counter value */
 static u64 get64(const u64 *p)
@@ -79,7 +79,7 @@ static void get_runstate_snapshot(struct vcpu_runstate_info *res)
 
 	BUG_ON(preemptible());
 
-	state = &__get_cpu_var(runstate);
+	state = &__get_cpu_var(xen_runstate);
 
 	/*
 	 * The runstate info is always updated by the hypervisor on
@@ -97,14 +97,14 @@ static void get_runstate_snapshot(struct vcpu_runstate_info *res)
 /* return true when a vcpu could run but has no real cpu to run on */
 bool xen_vcpu_stolen(int vcpu)
 {
-	return per_cpu(runstate, vcpu).state == RUNSTATE_runnable;
+	return per_cpu(xen_runstate, vcpu).state == RUNSTATE_runnable;
 }
 
 static void setup_runstate_info(int cpu)
 {
 	struct vcpu_register_runstate_memory_area area;
 
-	area.addr.v = &per_cpu(runstate, cpu);
+	area.addr.v = &per_cpu(xen_runstate, cpu);
 
 	if (HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
 			       cpu, &area))
@@ -122,7 +122,7 @@ static void do_stolen_accounting(void)
 
 	WARN_ON(state.state != RUNSTATE_running);
 
-	snap = &__get_cpu_var(runstate_snapshot);
+	snap = &__get_cpu_var(xen_runstate_snapshot);
 
 	/* work out how much time the VCPU has not been runn*ing*  */
 	blocked = state.time[RUNSTATE_blocked] - snap->time[RUNSTATE_blocked];
@@ -133,24 +133,24 @@ static void do_stolen_accounting(void)
 
 	/* Add the appropriate number of ticks of stolen time,
 	   including any left-overs from last time. */
-	stolen = runnable + offline + __get_cpu_var(residual_stolen);
+	stolen = runnable + offline + __get_cpu_var(xen_residual_stolen);
 
 	if (stolen < 0)
 		stolen = 0;
 
 	ticks = iter_div_u64_rem(stolen, NS_PER_TICK, &stolen);
-	__get_cpu_var(residual_stolen) = stolen;
+	__get_cpu_var(xen_residual_stolen) = stolen;
 	account_steal_ticks(ticks);
 
 	/* Add the appropriate number of ticks of blocked time,
 	   including any left-overs from last time. */
-	blocked += __get_cpu_var(residual_blocked);
+	blocked += __get_cpu_var(xen_residual_blocked);
 
 	if (blocked < 0)
 		blocked = 0;
 
 	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
-	__get_cpu_var(residual_blocked) = blocked;
+	__get_cpu_var(xen_residual_blocked) = blocked;
 	account_idle_ticks(ticks);
 }
 
-- 
1.6.4.2

