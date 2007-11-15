Return-Path: <linux-kernel-owner+w=401wt.eu-S1764545AbXKOGU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764545AbXKOGU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:20:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760620AbXKOGQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51078 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762626AbXKOGQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:37 -0500
Date: Wed, 14 Nov 2007 22:15:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       xen-devel@lists.xensource.com, virtualization@lists.osdl.org,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Keir Fraser <keir@xensource.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: [patch 12/19] xen: deal with stale cr3 values when unpinning
	pagetables
Message-ID: <20071115061500.GM7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="xen-handle-lazy-cr3-on-unpin.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeremy Fitzhardinge <jeremy@goop.org>

patch 9f79991d4186089e228274196413572cc000143b in mainline.

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

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/xen/enlighten.c |   55 +++++++++++++++++++++++++++++++---------------
 arch/i386/xen/mmu.c       |   29 +++++++++++++++++++++---
 arch/i386/xen/xen-ops.h   |    1 
 3 files changed, 65 insertions(+), 20 deletions(-)

--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -56,7 +56,23 @@ DEFINE_PER_CPU(enum paravirt_lazy_mode, 
 
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
@@ -632,32 +648,36 @@ static unsigned long xen_read_cr3(void)
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
+	mcs = xen_mc_entry(sizeof(*op));  /* disables interrupts */
 
+	/* Update while interrupts are disabled, so its atomic with
+	   respect to ipis */
 	x86_write_percpu(xen_cr3, cr3);
 
+	op = mcs.args;
+	op->cmd = MMUEXT_NEW_BASEPTR;
+	op->arg1.mfn = mfn;
 
-	{
-		struct mmuext_op *op;
-		struct multicall_space mcs = xen_mc_entry(sizeof(*op));
-		unsigned long mfn = pfn_to_mfn(PFN_DOWN(cr3));
-
-		op = mcs.args;
-		op->cmd = MMUEXT_NEW_BASEPTR;
-		op->arg1.mfn = mfn;
+	MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
 
-		MULTI_mmuext_op(mcs.mc, op, 1, NULL, DOMID_SELF);
+	/* Update xen_update_cr3 once the batch has actually
+	   been submitted. */
+	xen_mc_callback(set_current_cr3, (void *)cr3);
 
-		xen_mc_issue(PARAVIRT_LAZY_CPU);
-	}
+	xen_mc_issue(PARAVIRT_LAZY_CPU);  /* interrupts restored */
 }
 
 /* Early in boot, while setting up the initial pagetable, assume
@@ -1113,6 +1133,7 @@ asmlinkage void __init xen_start_kernel(
 	/* keep using Xen gdt for now; no urgent need to change it */
 
 	x86_write_percpu(xen_cr3, __pa(pgd));
+	x86_write_percpu(xen_current_cr3, __pa(pgd));
 
 #ifdef CONFIG_SMP
 	/* Don't do the full vcpu_info placement stuff until we have a
--- a/arch/i386/xen/mmu.c
+++ b/arch/i386/xen/mmu.c
@@ -515,20 +515,43 @@ static void drop_other_mm_ref(void *info
 
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
 	}
 
-	if (!cpus_empty(mm->cpu_vm_mask))
-		xen_smp_call_function_mask(mm->cpu_vm_mask, drop_other_mm_ref,
-					   mm, 1);
+	if (!cpus_empty(mask))
+		xen_smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
 }
 #else
 static void drop_mm_ref(struct mm_struct *mm)
--- a/arch/i386/xen/xen-ops.h
+++ b/arch/i386/xen/xen-ops.h
@@ -11,6 +11,7 @@ void xen_copy_trap_info(struct trap_info
 
 DECLARE_PER_CPU(struct vcpu_info *, xen_vcpu);
 DECLARE_PER_CPU(unsigned long, xen_cr3);
+DECLARE_PER_CPU(unsigned long, xen_current_cr3);
 
 extern struct start_info *xen_start_info;
 extern struct shared_info *HYPERVISOR_shared_info;

-- 
