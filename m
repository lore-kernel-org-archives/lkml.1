Return-Path: <linux-kernel-owner+w=401wt.eu-S1763543AbXJOVxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763543AbXJOVxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762838AbXJOVwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:52:10 -0400
Received: from zrnetservice.com ([209.133.52.163]:33265 "EHLO
	wifi.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757525AbXJOVwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:52:07 -0400
Message-Id: <20071015210115.121523711@goop.org>
References: <20071015204840.074767068@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 15 Oct 2007 13:48:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Keir Fraser <keir@xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: [PATCH 07/12] xen: deal with stale cr3 values when unpinning pagetables
Content-Disposition: inline; filename=xen-handle-lazy-cr3-on-unpin.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a pagetable is no longer in use, it must be unpinned so that its
pages can be freed.  However, this is only possible if there are no
stray uses of the pagetable.  The code currently deals with all the
usual cases, but there's a rare case where a vcpu is changing cr3, but
is doing so lazily, and the change hasn't actually happened by the time
the pagetable is unpinned, even though it appears to have been completed.

This change adds a second per-cpu cr3 variable - xen_current_cr3 -
which tracks the actual state of the vcpu cr3.  It is only updated once
the actual hypercall to set cr3 has been completed.  Other processors
wishing to unpin a pagetable can check other vcpu's xen_current_cr3
values to see if any cross-cpu IPIs are needed to clean things up.

[ Stable folks: 2.6.23 bugfix ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Stable Kernel <stable@kernel.org>

---
 arch/x86/xen/enlighten.c |   63 ++++++++++++++++++++++++++++++----------------
 arch/x86/xen/mmu.c       |   33 ++++++++++++++++++++----
 arch/x86/xen/xen-ops.h   |    1 
 3 files changed, 71 insertions(+), 26 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -55,7 +55,23 @@ DEFINE_PER_CPU(enum paravirt_lazy_mode, 
 
 DEFINE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
-DEFINE_PER_CPU(unsigned long, xen_cr3);
+
+/*
+ * Note about cr3 (pagetable base) values:
+ *
+ * xen_cr3 contains the current logical cr3 value; it contains the
+ * last set cr3.  This may not be the current effective cr3, because
+ * its update may be being lazily deferred.  However, a vcpu looking
+ * at its own cr3 can use this value knowing that it everything will
+ * be self-consistent.
+ *
+ * xen_current_cr3 contains the actual vcpu cr3; it is set once the
+ * hypercall to set the vcpu cr3 is complete (so it may be a little
+ * out of date, but it will never be set early).  If one vcpu is
+ * looking at another vcpu's cr3 value, it should use this variable.
+ */
+DEFINE_PER_CPU(unsigned long, xen_cr3);	 /* cr3 stored as physaddr */
+DEFINE_PER_CPU(unsigned long, xen_current_cr3);	 /* actual vcpu cr3 */
 
 struct start_info *xen_start_info;
 EXPORT_SYMBOL_GPL(xen_start_info);
@@ -631,32 +647,36 @@ static unsigned long xen_read_cr3(void)
 	return x86_read_percpu(xen_cr3);
 }
 
+static void set_current_cr3(void *v)
+{
+	x86_write_percpu(xen_current_cr3, (unsigned long)v);
+}
+
 static void xen_write_cr3(unsigned long cr3)
 {
+	struct mmuext_op *op;
+	struct multicall_space mcs;
+	unsigned long mfn = pfn_to_mfn(PFN_DOWN(cr3));
+
 	BUG_ON(preemptible());
 
-	if (cr3 == x86_read_percpu(xen_cr3)) {
-		/* just a simple tlb flush */
-		xen_flush_tlb();
-		return;
-	}
-
+	mcs = xen_mc_entry(sizeof(*op));  /* disables interrupts */
+
+	/* Update while interrupts are disabled, so its atomic with
+	   respect to ipis */
 	x86_write_percpu(xen_cr3, cr3);
 
-
-	{
-		struct mmuext_op *op;
-		struct multicall_space mcs = xen_mc_entry(sizeof(*op));
-		unsigned long mfn = pfn_to_mfn(PFN_DOWN(cr3));
-
-		op = mcs.args;
-		op->cmd = MMUEXT_NEW_BASEPTR;
-		op->arg1.mfn = mfn;
-
-		MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
-
-		xen_mc_issue(PARAVIRT_LAZY_CPU);
-	}
+	op = mcs.args;
+	op->cmd = MMUEXT_NEW_BASEPTR;
+	op->arg1.mfn = mfn;
+
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+
+	/* Update xen_update_cr3 once the batch has actually
+	   been submitted. */
+	xen_mc_callback(set_current_cr3, (void *)cr3);
+
+	xen_mc_issue(PARAVIRT_LAZY_CPU);  /* interrupts restored */
 }
 
 /* Early in boot, while setting up the initial pagetable, assume
@@ -1124,6 +1144,7 @@ asmlinkage void __init xen_start_kernel(
 	/* keep using Xen gdt for now; no urgent need to change it */
 
 	x86_write_percpu(xen_cr3, __pa(pgd));
+	x86_write_percpu(xen_current_cr3, __pa(pgd));
 
 #ifdef CONFIG_SMP
 	/* Don't do the full vcpu_info placement stuff until we have a
===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -564,20 +564,43 @@ static void drop_other_mm_ref(void *info
 
 	if (__get_cpu_var(cpu_tlbstate).active_mm == mm)
 		leave_mm(smp_processor_id());
+
+	/* If this cpu still has a stale cr3 reference, then make sure
+	   it has been flushed. */
+	if (x86_read_percpu(xen_current_cr3) == __pa(mm->pgd)) {
+		load_cr3(swapper_pg_dir);
+		arch_flush_lazy_cpu_mode();
+	}
 }
 
 static void drop_mm_ref(struct mm_struct *mm)
 {
+	cpumask_t mask;
+	unsigned cpu;
+
 	if (current->active_mm == mm) {
 		if (current->mm == mm)
 			load_cr3(swapper_pg_dir);
 		else
 			leave_mm(smp_processor_id());
-	}
-
-	if (!cpus_empty(mm->cpu_vm_mask))
-		xen_smp_call_function_mask(mm->cpu_vm_mask, drop_other_mm_ref,
-					   mm, 1);
+		arch_flush_lazy_cpu_mode();
+	}
+
+	/* Get the "official" set of cpus referring to our pagetable. */
+	mask = mm->cpu_vm_mask;
+
+	/* It's possible that a vcpu may have a stale reference to our
+	   cr3, because its in lazy mode, and it hasn't yet flushed
+	   its set of pending hypercalls yet.  In this case, we can
+	   look at its actual current cr3 value, and force it to flush
+	   if needed. */
+	for_each_online_cpu(cpu) {
+		if (per_cpu(xen_current_cr3, cpu) == __pa(mm->pgd))
+			cpu_set(cpu, mask);
+	}
+
+	if (!cpus_empty(mask))
+		xen_smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
 }
 #else
 static void drop_mm_ref(struct mm_struct *mm)
===================================================================
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -11,6 +11,7 @@ void xen_copy_trap_info(struct trap_info
 
 DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DECLARE_PER_CPU(unsigned long, xen_cr3);
+DECLARE_PER_CPU(unsigned long, xen_current_cr3);
 
 extern struct start_info *xen_start_info;
 extern struct shared_info *HYPERVISOR_shared_info;

-- 

