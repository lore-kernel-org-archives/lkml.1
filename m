Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbYF3NPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbYF3NPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761985AbYF3NN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:13:56 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:63631 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761919AbYF3NNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:13:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:message-id;
        b=xlM2TXc000gQmlaEpTTZgGSrHLuY4Blkv2HB9GlhU1tMYM6j+UgUNZFFkmXKKULLJm
         ZlQWRb51kD1nP2QgCGRhKua9m+VoO5p1IDhTz23K3wzFJ1v+Be9ja24Pva65xzdHdaso
         0FEAyOwH4GFgSEMPmdZCqCtLjEypS/pzQ6Mpo=
To: linux-kernel@vger.kernel.org
Subject: [patch 05/19] perfmon2 minimal v3:  X86 generic code
From: eranian@googlemail.com
Date: Mon, 30 Jun 2008 06:13:48 -0700 (PDT)
Message-ID: <4868dc0c.1c185e0a.6825.ffffed1a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the X86 generic perfmon2 code. It is in charge of
implementing certain key functionalities required by the generic
code such as read/write of the PMU registers, low-level interrupt
handling.

Signed-off-by: Stephane Eranian <eranian@gmail.com>
--

Index: linux-next/arch/x86/perfmon/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/arch/x86/perfmon/Kconfig	2008-06-26 19:47:14.000000000 +0200
@@ -0,0 +1,18 @@
+menu "Hardware Performance Monitoring support"
+config PERFMON
+	bool "Perfmon2 performance monitoring interface"
+	select X86_LOCAL_APIC
+	default n
+	help
+	Enables the perfmon2 interface to access the hardware
+	performance counters. See <http://perfmon2.sf.net/> for
+	more details.
+
+config PERFMON_DEBUG
+	bool "Perfmon debugging"
+	default n
+	depends on PERFMON
+	help
+	Enables perfmon debugging support
+
+endmenu
Index: linux-next/arch/x86/perfmon/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/arch/x86/perfmon/Makefile	2008-06-26 19:47:14.000000000 +0200
@@ -0,0 +1,5 @@
+#
+# Copyright (c) 2005-2007 Hewlett-Packard Development Company, L.P.
+# Contributed by Stephane Eranian <eranian@hpl.hp.com>
+#
+obj-$(CONFIG_PERFMON)			+= perfmon.o
Index: linux-next/arch/x86/perfmon/perfmon.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/arch/x86/perfmon/perfmon.c	2008-06-26 19:47:14.000000000 +0200
@@ -0,0 +1,634 @@
+/*
+ * This file implements the X86 specific support for the perfmon2 interface
+ *
+ * Copyright (c) 2005-2007 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *
+ * Copyright (c) 2007 Advanced Micro Devices, Inc.
+ * Contributed by Robert Richter <robert.richter@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+ */
+#include <linux/interrupt.h>
+#include <linux/perfmon_kern.h>
+#include <linux/kprobes.h>
+#include <linux/kdebug.h>
+#include <linux/nmi.h>
+
+#include <asm/apic.h>
+
+DEFINE_PER_CPU(unsigned long, real_iip);
+DEFINE_PER_CPU(int, pfm_using_nmi);
+DEFINE_PER_CPU(unsigned long, saved_lvtpc);
+
+/**
+ * pfm_arch_ctxswin_thread - thread context switch in
+ * @task: task switched in
+ * @ctx: context for the task
+ * @set: active event set
+ *
+ * Called from pfm_ctxsw(). Task is guaranteed to be current.
+ * set cannot be NULL. Context is locked. Interrupts are masked.
+ *
+ * Caller has already restored all PMD and PMC registers, if
+ * necessary (i.e., lazy restore scheme).
+ *
+ * On x86, the only common code just needs to unsecure RDPMC if necessary
+ *
+ * On model-specific features, e.g., PEBS, IBS, are taken care of in the
+ * corresponding PMU description module
+ */
+void pfm_arch_ctxswin_thread(struct task_struct *task, struct pfm_context *ctx)
+{
+	struct pfm_arch_context *ctx_arch;
+
+	ctx_arch = pfm_ctx_arch(ctx);
+
+	/*
+	 *  restore saved real iip
+	 */
+	if (ctx->active_set->npend_ovfls)
+		__get_cpu_var(real_iip) = ctx_arch->saved_real_iip;
+
+	/*
+	 * enable RDPMC on this CPU
+	 */
+	if (ctx_arch->flags.insecure)
+		set_in_cr4(X86_CR4_PCE);
+}
+
+/**
+ * pfm_arch_ctxswout_thread - context switch out thread
+ * @task: task switched out
+ * @ctx : context switched out
+ *
+ * Called from pfm_ctxsw(). Task is guaranteed to be current.
+ * Context is locked. Interrupts are masked. Monitoring may be active.
+ * PMU access is guaranteed. PMC and PMD registers are live in PMU.
+ *
+ * Return:
+ * 	non-zero : did not save PMDs (as part of stopping the PMU)
+ * 	       0 : saved PMDs (no need to save them in caller)
+ */
+int pfm_arch_ctxswout_thread(struct task_struct *task, struct pfm_context *ctx)
+{
+	struct pfm_arch_context *ctx_arch;
+	struct pfm_arch_pmu_info *pmu_info;
+
+	ctx_arch = pfm_ctx_arch(ctx);
+	pmu_info = pfm_pmu_info();
+
+	/*
+	 * disable lazy restore of PMCS on ctxswin because
+	 * we modify some of them.
+	 */
+	ctx->active_set->priv_flags |= PFM_SETFL_PRIV_MOD_PMCS;
+
+	if (ctx->active_set->npend_ovfls)
+		ctx_arch->saved_real_iip = __get_cpu_var(real_iip);
+
+	/*
+	 * disable RDPMC on this CPU
+	 */
+	if (ctx_arch->flags.insecure)
+		clear_in_cr4(X86_CR4_PCE);
+
+	return pmu_info->stop_save(ctx, ctx->active_set);
+}
+
+/**
+ * pfm_arch_stop - deactivate monitoring
+ * @task: task to stop
+ * @ctx: context to stop
+ *
+ * Called from pfm_stop()
+ * Interrupts are masked. Context is locked. Set is the active set.
+ *
+ * For per-thread:
+ *   task is not necessarily current. If not current task, then
+ *   task is guaranteed stopped and off any cpu. Access to PMU
+ *   is not guaranteed.
+ *
+ * For system-wide:
+ * 	task is current
+ *
+ * must disable active monitoring. ctx cannot be NULL
+ */
+void pfm_arch_stop(struct task_struct *task, struct pfm_context *ctx)
+{
+	struct pfm_arch_pmu_info *pmu_info;
+
+	pmu_info = pfm_pmu_info();
+
+	/*
+	 * no need to go through stop_save()
+	 * if we are already stopped
+	 */
+	if (!ctx->flags.started)
+		return;
+
+	if (task != current)
+		return;
+
+	pmu_info->stop_save(ctx, ctx->active_set);
+}
+
+
+/**
+ * pfm_arch_start - activate monitoring
+ * @task: task to start
+ * @ctx: context to stop
+ *
+ * Interrupts are masked. Context is locked.
+ *
+ * For per-thread:
+ * 	Task is not necessarily current. If not current task, then task
+ * 	is guaranteed stopped and off any cpu. No access to PMU is task
+ *	is not current.
+ *
+ * For system-wide:
+ * 	task is always current
+ */
+void pfm_arch_start(struct task_struct *task, struct pfm_context *ctx)
+{
+	struct pfm_event_set *set;
+	u64 *mask;
+	u16 i, num;
+
+	set = ctx->active_set;
+
+	/*
+	 * cannot restore PMC if no access to PMU. Will be done
+	 * when the thread is switched back in
+	 */
+	if (task != current)
+		return;
+
+	/*
+	 * we actually install all implemented pmcs registers because
+	 * until started, we do not write any PMC registers.
+	 * Note that registers used  by other subsystems (e.g. NMI) are
+	 * removed from pmcs.
+	 *
+	 * XXX: we may be able to optimize this for non-P4 PMU as pmcs are
+	 * independent from each others. That would need to be in model
+	 * specific start routine.
+	 */
+	num = pfm_pmu_conf->regs.num_pmcs;
+	mask = pfm_pmu_conf->regs.pmcs;
+	for (i = 0; num; i++) {
+		if (test_bit(i, cast_ulp(mask))) {
+			pfm_arch_write_pmc(ctx, i, set->pmcs[i]);
+			num--;
+		}
+	}
+}
+
+/**
+ * pfm_arch_restore_pmds - reload PMD registers
+ * @ctx: context to restore from
+ * @set: current event set
+ *
+ * function called from pfm_context_load(), pfm_ctxsw()
+ *
+ * Context is locked. Interrupts are masked. Set cannot be NULL.
+ * Access to the PMU is guaranteed.
+ */
+void pfm_arch_restore_pmds(struct pfm_context *ctx, struct pfm_event_set *set)
+{
+	u16 i, num;
+
+	num = set->nused_pmds;
+
+	/*
+	 * we can restore only the PMD we use because:
+	 *
+	 * 	- can only read with pfm_read_pmds() the registers
+	 * 	  declared used via pfm_write_pmds(), smpl_pmds, reset_pmds
+	 *
+	 * 	- if cr4.pce=1, only counters are exposed to user. RDPMC
+	 * 	  does not work with other types of PMU registers.Thus, no
+	 * 	  address is ever exposed by counters
+	 *
+	 * 	- there is never a dependency between one pmd register and
+	 * 	  another
+	 */
+	for (i = 0; num; i++) {
+		if (likely(test_bit(i, cast_ulp(set->used_pmds)))) {
+			pfm_write_pmd(ctx, i, set->pmds[i].value);
+			num--;
+		}
+	}
+}
+
+/**
+ * pfm_arch_restore_pmcs - reload PMC registers
+ * @ctx: context to restore from
+ * @set: current event set
+ *
+ * function called from pfm_context_load(), pfm_ctxsw().
+ *
+ * Context is locked. Interrupts are masked. set cannot be NULL.
+ * Access to the PMU is guaranteed.
+ *
+ * function must restore all PMC registers from set
+ */
+void pfm_arch_restore_pmcs(struct pfm_context *ctx, struct pfm_event_set *set)
+{
+	u16 i, num;
+
+	/*
+	 * we need to restore PMCs only when:
+	 * 	- context is not masked
+	 * 	- monitoring activated
+	 *
+	 * Masking monitoring after an overflow does not change the
+	 * value of flags.started
+	 */
+	if (!ctx->flags.started)
+		return;
+
+	/*
+	 * restore all pmcs
+	 *
+	 * It is not possible to restore only the pmcs we used because
+	 * certain PMU models (e.g. Pentium 4) have dependencies. Thus
+	 * we do not want one application using stale PMC coming from
+	 * another one.
+	 *
+	 * On PMU models where there is no dependencies between pmc, then
+	 * it is possible to optimize by only restoring the registers that
+	 * are used, and this can be done with the models-specific override
+	 * for this function.
+	 */
+	num = set->nused_pmcs;
+	for (i = 0; num; i++) {
+		if (test_bit(i, cast_ulp(set->used_pmcs))) {
+			pfm_arch_write_pmc(ctx, i, set->pmcs[i]);
+			num--;
+		}
+	}
+}
+
+/**
+ * smp_pmu_interrupt - lowest level PMU interrupt handler for X86
+ * @regs: machine state
+ *
+ * The PMU interrupt is handled through an interrupt gate, therefore
+ * the CPU automatically clears the EFLAGS.IF, i.e., masking interrupts.
+ *
+ * The perfmon interrupt handler MUST run with interrupts disabled due
+ * to possible race with other, higher priority interrupts, such as timer
+ * or IPI function calls.
+ *
+ * See description in IA-32 architecture manual, Vol 3 section 5.8.1
+ */
+void smp_pmu_interrupt(struct pt_regs *regs)
+{
+	unsigned long iip;
+	int using_nmi;
+
+	using_nmi = __get_cpu_var(pfm_using_nmi);
+
+	ack_APIC_irq();
+
+	irq_enter();
+
+	/*
+	 * when using NMI, pfm_handle_nmi() gets called
+	 * first. It stops monitoring and record the
+	 * iip into real_iip, then it repost the interrupt
+	 * using the lower priority vector LOCAL_PERFMON_VECTOR
+	 *
+	 * On some processors, e.g., P4, it may be that some
+	 * state is already recorded from pfm_handle_nmi()
+	 * and it only needs to be copied back into the normal
+	 * fields so it can be used transparently by higher level
+	 * code.
+	 */
+	if (using_nmi)
+		iip = __get_cpu_var(real_iip);
+	else
+		iip = instruction_pointer(regs);
+
+	pfm_interrupt_handler(iip, regs);
+
+	/*
+	 * On Intel processors:
+	 * 	- it is necessary to clear the MASK field for the LVTPC
+	 * 	  vector. Otherwise interrupts remain masked. See
+	 * 	  section 8.5.1
+	 * AMD X86-64:
+	 * 	- the documentation does not stipulate the behavior but
+	 * 	  it seems to work without the write, so we skip
+	 */
+	if (!using_nmi && current_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		apic_write(APIC_LVTPC, LOCAL_PERFMON_VECTOR);
+
+	irq_exit();
+}
+
+/**
+ * pfm_handle_nmi - PMU NMI handler notifier callback
+ * @nb ; notifier block
+ * @val: type of die notifier
+ * @data: die notifier-specific data
+ *
+ * called from notify_die() notifier from an trap handler path. We only
+ * care about NMI related callbacks, and ignore everything else.
+ *
+ * Cannot grab any locks, include the perfmon context lock
+ *
+ * Must detect if NMI interrupt comes from perfmon, and if so it must
+ * stop the PMU and repost a lower-priority interrupt. The perfmon interrupt
+ * handler needs to grab the context lock, thus is cannot be run directly
+ * from the NMI interrupt call path.
+ */
+static int __kprobes pfm_handle_nmi(struct notifier_block *nb,
+				    unsigned long val,
+				    void *data)
+{
+	struct die_args *args = data;
+	struct pfm_context *ctx;
+	struct pfm_arch_pmu_info *pmu_info;
+
+	/*
+	 * only NMI related calls
+	 */
+	if (val != DIE_NMI_IPI)
+		return NOTIFY_DONE;
+
+	/*
+	 * perfmon not using NMI
+	 */
+	if (!__get_cpu_var(pfm_using_nmi))
+		return NOTIFY_DONE;
+
+	/*
+	 * No context
+	 */
+	ctx = __get_cpu_var(pmu_ctx);
+	if (!ctx) {
+		PFM_DBG_ovfl("no ctx");
+		return NOTIFY_DONE;
+	}
+
+	/*
+	 * Detect if we have overflows, i.e., NMI interrupt
+	 * caused by PMU
+	 */
+	pmu_info = pfm_pmu_info();
+	if (!pmu_info->has_ovfls(ctx)) {
+		PFM_DBG_ovfl("no ovfl");
+		return NOTIFY_DONE;
+	}
+
+	/*
+	 * we stop the PMU to avoid further overflow before this
+	 * one is treated by lower priority interrupt handler
+	 */
+	pmu_info->quiesce();
+
+	/*
+	 * record actual instruction pointer
+	 */
+	__get_cpu_var(real_iip) = instruction_pointer(args->regs);
+
+	/*
+	 * post lower priority interrupt (LOCAL_PERFMON_VECTOR)
+	 */
+	pfm_arch_resend_irq(ctx);
+
+	/*
+	 * we need to rewrite the APIC vector on Intel
+	 */
+	if (current_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
+
+	/*
+	 * the notification was for us
+	 */
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block pfm_nmi_nb = {
+	.notifier_call = pfm_handle_nmi
+};
+
+/**
+ * pfm_arch_resend_irq - post perfmon interrupt on regular vector
+ *
+ * called from pfm_ctxswin_thread() and pfm_handle_nmi()
+ */
+void pfm_arch_resend_irq(struct pfm_context *ctx)
+{
+	unsigned long val, dest;
+	/*
+	 * we cannot use hw_resend_irq() because it goes to
+	 * the I/O APIC. We need to go to the Local APIC.
+	 *
+	 * The "int vec" is not the right solution either
+	 * because it triggers a software intr. We need
+	 * to regenerate the interrupt and have it pended
+	 * until we unmask interrupts.
+	 *
+	 * Instead we send ourself an IPI on the perfmon
+	 * vector.
+	 */
+	val  = APIC_DEST_SELF|APIC_INT_ASSERT|
+	       APIC_DM_FIXED|LOCAL_PERFMON_VECTOR;
+
+	dest = apic_read(APIC_ID);
+	apic_write(APIC_ICR2, dest);
+	apic_write(APIC_ICR, val);
+}
+
+/**
+ * pfm_arch_pmu_acquire_percpu - setup APIC per CPU
+ * @data: contains pmu flags
+ */
+static void pfm_arch_pmu_acquire_percpu(void *data)
+{
+
+	unsigned int tmp, vec;
+	unsigned long flags = (unsigned long)data;
+	unsigned long lvtpc;
+
+	/*
+	 * we only reprogram the LVTPC vector if we have detected
+	 * no sharing, otherwise it means the APIC is already programmed
+	 * and we use whatever vector (likely NMI) is there
+	 */
+	if (!(flags & PFM_X86_FL_SHARING)) {
+		vec = LOCAL_PERFMON_VECTOR;
+
+		tmp = apic_read(APIC_LVTERR);
+		apic_write(APIC_LVTERR, tmp | APIC_LVT_MASKED);
+		apic_write(APIC_LVTPC, vec);
+		apic_write(APIC_LVTERR, tmp);
+	}
+	lvtpc = (unsigned long)apic_read(APIC_LVTPC);
+
+	__get_cpu_var(pfm_using_nmi) = lvtpc == APIC_DM_NMI;
+
+	PFM_DBG("LTVPC=0x%lx using_nmi=%d", lvtpc, __get_cpu_var(pfm_using_nmi));
+}
+
+/**
+ * pfm_arch_pmu_acquire - acquire PMU resource from system
+ * @unavail_pmcs : bitmask to use to set unavailable pmcs
+ * @unavail_pmds : bitmask to use to set unavailable pmds
+ *
+ * interrupts are not masked
+ *
+ * Grab PMU registers from lower level MSR allocator
+ *
+ * Program the APIC according the possible interrupt vector
+ * either LOCAL_PERFMON_VECTOR or NMI
+ */
+int pfm_arch_pmu_acquire(u64 *unavail_pmcs, u64 *unavail_pmds)
+{
+	struct pfm_arch_pmu_info *pmu_info;
+	struct pfm_regmap_desc *d;
+	u16 i, nlost;
+
+	pmu_info = pfm_pmu_conf->pmu_info;
+	pmu_info->flags &= ~PFM_X86_FL_SHARING;
+
+	nlost = 0;
+
+	d = pfm_pmu_conf->pmc_desc;
+	for (i = 0; i < pfm_pmu_conf->num_pmc_entries;  i++, d++) {
+		if (!(d->type & PFM_REG_I))
+			continue;
+
+		/*
+		 * reserve register with lower-level allocator
+		 */
+		if (!reserve_evntsel_nmi(d->hw_addr)) {
+			PFM_DBG("pmc%d(%s) already used", i, d->desc);
+			__set_bit(i, cast_ulp(unavail_pmcs));
+			nlost++;
+			continue;
+		}
+	}
+	PFM_DBG("nlost=%d info_flags=0x%x\n", nlost, pmu_info->flags);
+	/*
+	 * some PMU models (e.g., P6) do not support sharing
+	 * so check if we found less than the expected number of PMC registers
+	 */
+	if (nlost) {
+		if (pmu_info->flags & PFM_X86_FL_NO_SHARING) {
+			PFM_INFO("PMU already used by another subsystem, "
+				 "PMU does not support sharing, "
+				 "try disabling Oprofile or "
+				 "reboot with nmi_watchdog=0");
+			goto undo;
+		}
+		pmu_info->flags |= PFM_X86_FL_SHARING;
+	}
+
+	d = pfm_pmu_conf->pmd_desc;
+	for (i = 0; i < pfm_pmu_conf->num_pmd_entries;  i++, d++) {
+		if (!(d->type & PFM_REG_I))
+			continue;
+
+		if (!reserve_perfctr_nmi(d->hw_addr)) {
+			PFM_DBG("pmd%d(%s) already used", i, d->desc);
+			__set_bit(i, cast_ulp(unavail_pmds));
+		}
+	}
+	/*
+	 * program APIC on each CPU
+	 */
+	on_each_cpu(pfm_arch_pmu_acquire_percpu,
+		    (void *)(unsigned long)pmu_info->flags , 0, 1);
+
+	return 0;
+undo:
+	/*
+	 * must undo reservation of pmcs in case of error
+	 */
+	d = pfm_pmu_conf->pmc_desc;
+	for (i = 0; i < pfm_pmu_conf->num_pmc_entries;  i++, d++) {
+		if (!(d->type & PFM_REG_I))
+			continue;
+		if (!test_bit(i, cast_ulp(unavail_pmcs)))
+			release_evntsel_nmi(d->hw_addr);
+	}
+	return -EBUSY;
+}
+
+/**
+ * pfm-arch_pmu_release_percpu - clear NMI state for one CPU
+ *
+ */
+static void pfm_arch_pmu_release_percpu(void *data)
+{
+	__get_cpu_var(pfm_using_nmi) = 0;
+}
+
+/**
+ * pfm_arch_pmu_release - release PMU resource to system
+ *
+ * called from pfm_pmu_release()
+ * interrupts are not masked
+ *
+ * On x86, we return the PMU registers to the MSR allocator
+ */
+void pfm_arch_pmu_release(void)
+{
+	struct pfm_regmap_desc *d;
+	u16 i, n;
+
+	d = pfm_pmu_conf->pmc_desc;
+	n = pfm_pmu_conf->regs.num_pmcs;
+	for (i = 0; n; i++, d++) {
+		if (!test_bit(i, cast_ulp(pfm_pmu_conf->regs.pmcs)))
+			continue;
+		release_evntsel_nmi(d->hw_addr);
+		n--;
+		PFM_DBG("pmc%u released", i);
+	}
+	d = pfm_pmu_conf->pmd_desc;
+	n = pfm_pmu_conf->regs.num_pmds;
+	for (i = 0; n; i++, d++) {
+		if (!test_bit(i, cast_ulp(pfm_pmu_conf->regs.pmds)))
+			continue;
+		release_perfctr_nmi(d->hw_addr);
+		n--;
+		PFM_DBG("pmd%u released", i);
+	}
+
+	/* clear NMI variable if used */
+	if (__get_cpu_var(pfm_using_nmi))
+		on_each_cpu(pfm_arch_pmu_release_percpu, NULL , 0, 1);
+}
+
+/**
+ * pfm_arch_init - one time global arch-specific initialization
+ *
+ * called from pfm_init()
+ */
+int __init pfm_arch_init(void)
+{
+	/*
+	 * we need to register our NMI handler when the kernels boots
+	 * to avoid a deadlock condition with the NMI watchdog or Oprofile
+	 * if we were to try and register/unregister on-demand.
+	 */
+	register_die_notifier(&pfm_nmi_nb);
+	return 0;
+}
Index: linux-next/include/asm-x86/perfmon.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/include/asm-x86/perfmon.h	2008-06-26 19:47:14.000000000 +0200
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c) 2007 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *
+ * This file contains i386/x86_64 specific definitions for the perfmon
+ * interface.
+ *
+ * This file MUST never be included directly. Use linux/perfmon.h.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+  */
+#ifndef _ASM_X86_PERFMON__H_
+#define _ASM_X86_PERFMON__H_
+
+/*
+ * arch-specific user visible interface definitions
+ */
+
+#define PFM_ARCH_MAX_PMCS	(256+64) /* 256 HW 64 SW */
+#define PFM_ARCH_MAX_PMDS	(256+64) /* 256 HW 64 SW */
+
+#endif /* _ASM_X86_PERFMON_H_ */
Index: linux-next/include/asm-x86/perfmon_kern.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/include/asm-x86/perfmon_kern.h	2008-06-26 19:47:14.000000000 +0200
@@ -0,0 +1,376 @@
+/*
+ * Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
+ * Contributed by Stephane Eranian <eranian@hpl.hp.com>
+ *
+ * Copyright (c) 2007 Advanced Micro Devices, Inc.
+ * Contributed by Robert Richter <robert.richter@amd.com>
+ *
+ * This file contains X86 Processor Family specific definitions
+ * for the perfmon interface. This covers P6, Pentium M, P4/Xeon
+ * (32-bit and 64-bit, i.e., EM64T) and AMD X86-64.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
+ * 02111-1307 USA
+  */
+#ifndef _ASM_X86_PERFMON_KERN_H_
+#define _ASM_X86_PERFMON_KERN_H_
+
+#ifdef CONFIG_PERFMON
+#include <linux/unistd.h>
+#ifdef CONFIG_4KSTACKS
+#define PFM_ARCH_PMD_STK_ARG	2
+#define PFM_ARCH_PMC_STK_ARG	2
+#else
+#define PFM_ARCH_PMD_STK_ARG	4 /* about 700 bytes of stack space */
+#define PFM_ARCH_PMC_STK_ARG	4 /* about 200 bytes of stack space */
+#endif
+
+struct pfm_arch_pmu_info {
+	u32 flags;		/* PMU feature flags */
+	/*
+	 * mandatory model-specific callbacks
+	 */
+	int  (*stop_save)(struct pfm_context *ctx, struct pfm_event_set *set);
+	int  (*has_ovfls)(struct pfm_context *ctx);
+	void (*quiesce)(void);
+
+	/*
+	 * optional model-specific callbacks
+	 */
+//	void (*acquire_pmu_percpu)(void);
+//	void (*release_pmu_percpu)(void);
+	int (*load_context)(struct pfm_context *ctx);
+	void (*unload_context)(struct pfm_context *ctx);
+};
+
+/*
+ * PMU feature flags
+ */
+#define PFM_X86_FL_NO_SHARING	0x02	/* no sharing with other subsystems */
+#define PFM_X86_FL_SHARING	0x04	/* PMU is being shared */
+
+struct pfm_x86_ctx_flags {
+	unsigned int insecure:1;  /* rdpmc per-thread self-monitoring */
+	unsigned int reserved:31; /* for future use */
+};
+
+struct pfm_arch_context {
+	u64 saved_real_iip;		/* instr pointer of last NMI intr */
+	struct pfm_x86_ctx_flags flags;	/* flags */
+};
+
+/*
+ * functions implemented as inline on x86
+ */
+
+/**
+ * pfm_arch_write_pmc - write a single PMC register
+ * @ctx: context to work on
+ * @cnum: PMC index
+ * @value: PMC 64-bit value
+ *
+ * in certain situations, ctx may be NULL
+ */
+static inline void pfm_arch_write_pmc(struct pfm_context *ctx,
+				      unsigned int cnum, u64 value)
+{
+	/*
+	 * we only write to the actual register when monitoring is
+	 * active (pfm_start was issued)
+	 */
+	if (ctx && ctx->flags.started == 0)
+		return;
+
+	PFM_DBG_ovfl("pfm_arch_write_pmc(0x%lx, 0x%Lx)",
+		     pfm_pmu_conf->pmc_desc[cnum].hw_addr,
+		     (unsigned long long) value);
+
+	wrmsrl(pfm_pmu_conf->pmc_desc[cnum].hw_addr, value);
+}
+
+/**
+ * pfm_arch_write_pmd - write a single PMD register
+ * @ctx: context to work on
+ * @cnum: PMD index
+ * @value: PMD 64-bit value
+ */
+static inline void pfm_arch_write_pmd(struct pfm_context *ctx,
+				      unsigned int cnum, u64 value)
+{
+	/*
+	 * to make sure the counter overflows, we set the
+	 * upper bits. we also clear any other unimplemented
+	 * bits as this may cause crash on some processors.
+	 */
+	if (pfm_pmu_conf->pmd_desc[cnum].type & PFM_REG_C64)
+		value = (value | ~pfm_pmu_conf->ovfl_mask)
+		      & ~pfm_pmu_conf->pmd_desc[cnum].rsvd_msk;
+
+	PFM_DBG_ovfl("pfm_arch_write_pmd(0x%lx, 0x%Lx)",
+		     pfm_pmu_conf->pmd_desc[cnum].hw_addr,
+		     (unsigned long long) value);
+
+	wrmsrl(pfm_pmu_conf->pmd_desc[cnum].hw_addr, value);
+}
+
+/**
+ * pfm_arch_read_pmd - read a single PMD register
+ * @ctx: context to work on
+ * @cnum: PMD index
+ *
+ * return value is register 64-bit value
+ */
+static inline u64 pfm_arch_read_pmd(struct pfm_context *ctx, unsigned int cnum)
+{
+	u64 tmp;
+
+	rdmsrl(pfm_pmu_conf->pmd_desc[cnum].hw_addr, tmp);
+
+	PFM_DBG_ovfl("pfm_arch_read_pmd(0x%lx) = 0x%Lx",
+		     pfm_pmu_conf->pmd_desc[cnum].hw_addr,
+		     (unsigned long long) tmp);
+	return tmp;
+}
+
+/**
+ * pfm_arch_read_pmc - read a single PMC register
+ * @ctx: context to work on
+ * @cnum: PMC index
+ *
+ * return value is register 64-bit value
+ */
+static inline u64 pfm_arch_read_pmc(struct pfm_context *ctx, unsigned int cnum)
+{
+	u64 tmp;
+
+	rdmsrl(pfm_pmu_conf->pmc_desc[cnum].hw_addr, tmp);
+
+	PFM_DBG_ovfl("pfm_arch_read_pmc(0x%lx) = 0x%016Lx",
+		     pfm_pmu_conf->pmc_desc[cnum].hw_addr,
+		     (unsigned long long) tmp);
+	return tmp;
+}
+
+/**
+ * pfm_arch_is_active - return non-zero is monitoring has been started
+ * @ctx: context to check
+ *
+ * At certain points, perfmon needs to know if monitoring has been
+ * explicitly started.
+ *
+ * On x86, there is not other way but to use pfm_start/pfm_stop
+ * to activate monitoring, thus we can simply check flags.started
+ */
+static inline int pfm_arch_is_active(struct pfm_context *ctx)
+{
+	return ctx->flags.started;
+}
+
+
+/**
+ * pfm_arch_unload_context - detach context from thread or CPU
+ * @ctx: context to detach
+ *
+ * in system-wide ctx->task is NULL, otherwise it points to the
+ * attached thread
+ */
+static inline void pfm_arch_unload_context(struct pfm_context *ctx)
+{
+	struct pfm_arch_pmu_info *pmu_info;
+	struct pfm_arch_context *ctx_arch;
+
+	ctx_arch = pfm_ctx_arch(ctx);
+	pmu_info = pfm_pmu_info();
+
+	if (ctx_arch->flags.insecure) {
+		PFM_DBG("clear cr4.pce");
+		clear_in_cr4(X86_CR4_PCE);
+	}
+
+	if (pmu_info->unload_context)
+		pmu_info->unload_context(ctx);
+}
+
+/**
+ * pfm_arch_load_context - attach context to thread or CPU
+ * @ctx: context to attach
+ */
+static inline int pfm_arch_load_context(struct pfm_context *ctx)
+{
+	struct pfm_arch_pmu_info *pmu_info;
+	struct pfm_arch_context *ctx_arch;
+	int ret = 0;
+
+	ctx_arch = pfm_ctx_arch(ctx);
+	pmu_info = pfm_pmu_info();
+
+	/*
+	 * RDPMC authorized in system-wide and
+	 * per-thread self-monitoring.
+	 *
+	 * RDPMC only gives access to counts.
+	 *
+	 * The context-switch routine code does not restore
+	 * all the PMD registers (optimization), thus there
+	 * is a possible leak of counts there in per-thread
+	 * mode.
+	 */
+	if (ctx->task == current) {
+		PFM_DBG("set cr4.pce");
+		set_in_cr4(X86_CR4_PCE);
+		ctx_arch->flags.insecure = 1;
+	}
+
+	if (pmu_info->load_context)
+		ret = pmu_info->load_context(ctx);
+
+	return ret;
+}
+
+void pfm_arch_restore_pmcs(struct pfm_context *ctx, struct pfm_event_set *set);
+void pfm_arch_start(struct task_struct *task, struct pfm_context *ctx);
+void pfm_arch_stop(struct task_struct *task, struct pfm_context *ctx);
+
+/**
+ * pfm_arch_intr_freeze_pmu - stop monitoring when handling PMU interrupt
+ * @ctx: current context
+ * @set: current event set
+ *
+ * called from __pfm_interrupt_handler().
+ * ctx is not NULL. ctx is locked. interrupts are masked
+ *
+ * The following actions must take place:
+ *  - stop all monitoring to ensure handler has consistent view.
+ *  - collect overflowed PMDs bitmask into povfls_pmds and
+ *    npend_ovfls. If no interrupt detected then npend_ovfls
+ *    must be set to zero.
+ */
+static inline void pfm_arch_intr_freeze_pmu(struct pfm_context *ctx,
+					    struct pfm_event_set *set)
+{
+	/*
+	 * on X86, freezing is equivalent to stopping
+	 */
+	pfm_arch_stop(current, ctx);
+
+	/*
+	 * we mark monitoring as stopped to avoid
+	 * certain side effects especially in
+	 * pfm_switch_sets_from_intr() and
+	 * pfm_arch_restore_pmcs()
+	 */
+	ctx->flags.started = 0;
+}
+
+/**
+ * pfm_arch_intr_unfreeze_pmu - conditionally reactive monitoring
+ * @ctx: current context
+ *
+ * current context may be not when dealing when spurious interrupts
+ *
+ * Must re-activate monitoring if context is not MASKED.
+ * interrupts are masked.
+ */
+static inline void pfm_arch_intr_unfreeze_pmu(struct pfm_context *ctx)
+{
+	if (ctx == NULL)
+		return;
+
+	PFM_DBG_ovfl("state=%d", ctx->state);
+
+	/*
+	 * restore flags.started which is cleared in
+	 * pfm_arch_intr_freeze_pmu()
+	 */
+	ctx->flags.started = 1;
+
+	pfm_arch_restore_pmcs(ctx, ctx->active_set);
+}
+
+/**
+ * pfm_arch_ovfl_reset_pmd - reset pmd on overflow
+ * @ctx: current context
+ * @cnum: PMD index
+ *
+ * On some CPUs, the upper bits of a counter must be set in order for the
+ * overflow interrupt to happen. On overflow, the counter has wrapped around,
+ * and the upper bits are cleared. This function may be used to set them back.
+ *
+ * For x86, the current version loses whatever is remaining in the counter,
+ * which is usually has a small count. In order not to loose this count,
+ * we do a read-modify-write to set the upper bits while preserving the
+ * low-order bits. This is slow but works.
+ */
+static inline void pfm_arch_ovfl_reset_pmd(struct pfm_context *ctx, unsigned int cnum)
+{
+	u64 val;
+	val = pfm_arch_read_pmd(ctx, cnum);
+	pfm_arch_write_pmd(ctx, cnum, val);
+}
+
+/**
+ * pfm_arch_context_create - create context
+ * @ctx: newly created context
+ * @flags: context flags as passed by user
+ *
+ * called from __pfm_create_context()
+ */
+static inline int pfm_arch_context_create(struct pfm_context *ctx, u32 ctx_flags)
+{
+	return 0;
+}
+
+/**
+ * pfm_arch_context_free - free context
+ * @ctx: context to free
+ */
+static inline void pfm_arch_context_free(struct pfm_context *ctx)
+{}
+
+/*
+ * functions implemented in arch/x86/perfmon/perfmon.c
+ */
+int  pfm_arch_init(void);
+void pfm_arch_resend_irq(struct pfm_context *ctx);
+
+int  pfm_arch_ctxswout_thread(struct task_struct *task, struct pfm_context *ctx);
+void pfm_arch_ctxswin_thread(struct task_struct *task, struct pfm_context *ctx);
+
+void pfm_arch_restore_pmds(struct pfm_context *ctx, struct pfm_event_set *set);
+int  pfm_arch_pmu_config_init(struct pfm_pmu_config *cfg);
+void pfm_arch_pmu_config_remove(void);
+char *pfm_arch_get_pmu_module_name(void);
+int pfm_arch_pmu_acquire(u64 *unavail_pmcs, u64 *unavail_pmds);
+void pfm_arch_pmu_release(void);
+
+static inline void pfm_arch_serialize(void)
+{}
+
+static inline void pfm_arch_arm_handle_work(struct task_struct *task)
+{}
+
+static inline void pfm_arch_disarm_handle_work(struct task_struct *task)
+{}
+
+#define PFM_ARCH_CTX_SIZE	(sizeof(struct pfm_arch_context))
+/*
+ * x86 does not need extra alignment requirements for the sampling buffer
+ */
+#define PFM_ARCH_SMPL_ALIGN_SIZE	0
+
+asmlinkage void  pmu_interrupt(void);
+
+#endif /* CONFIG_PEFMON */
+
+#endif /* _ASM_X86_PERFMON_KERN_H_ */
Index: linux-next/arch/x86/Kconfig
===================================================================
--- linux-next.orig/arch/x86/Kconfig	2008-06-26 17:46:24.000000000 +0200
+++ linux-next/arch/x86/Kconfig	2008-06-26 19:47:14.000000000 +0200
@@ -1381,6 +1381,8 @@
 
 	  If unsure, say Y.
 
+source "arch/x86/perfmon/Kconfig"
+
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
Index: linux-next/arch/x86/Makefile
===================================================================
--- linux-next.orig/arch/x86/Makefile	2008-06-26 17:46:24.000000000 +0200
+++ linux-next/arch/x86/Makefile	2008-06-26 19:47:14.000000000 +0200
@@ -159,6 +159,8 @@
 core-y += arch/x86/kernel/
 core-y += arch/x86/mm/
 
+core-$(CONFIG_PERFMON) += arch/x86/perfmon/
+
 # Remaining sub architecture files
 core-y += $(mcore-y)
 
Index: linux-next/include/asm-x86/Kbuild
===================================================================
--- linux-next.orig/include/asm-x86/Kbuild	2008-06-26 17:46:27.000000000 +0200
+++ linux-next/include/asm-x86/Kbuild	2008-06-26 19:47:14.000000000 +0200
@@ -11,6 +11,7 @@
 header-y += sigcontext32.h
 header-y += ucontext.h
 header-y += processor-flags.h
+header-y += perfmon.h
 
 unifdef-y += e820.h
 unifdef-y += ist.h

-- 

