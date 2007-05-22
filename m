Return-Path: <linux-kernel-owner+w=401wt.eu-S935957AbXEVPbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935957AbXEVPbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934920AbXEVPTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:54 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:4995
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965838AbXEVPTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:18 -0400
Message-Id: <20070522141253.724096312@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:10:13 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir@xensource.com>
Subject: [patch 32/33] xen: Place vcpu_info structure into per-cpu memory, if possible
Content-Disposition: inline; filename=xen-place-vcpu.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

An experimental patch for Xen allows guests to place their vcpu_info
structs anywhere.  We try to use this to place the vcpu_info into the
PDA, which allows direct access.

If this works, then switch to using direct access operations for
irq_enable, disable, save_fl and restore_fl.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Keir Fraser <keir@xensource.com>
---
 arch/i386/xen/enlighten.c    |  121 +++++++++++++++++++++++++++++++++++++++++-
 arch/i386/xen/setup.c        |    8 --
 include/xen/interface/vcpu.h |   13 ++++
 3 files changed, 133 insertions(+), 9 deletions(-)

===================================================================
--- a/arch/i386/xen/enlighten.c
+++ b/arch/i386/xen/enlighten.c
@@ -61,9 +61,55 @@ struct start_info *xen_start_info;
 struct start_info *xen_start_info;
 EXPORT_SYMBOL_GPL(xen_start_info);
 
+static /* __initdata */ struct shared_info dummy_shared_info;
+
+/*
+ * Point at some empty memory to start with. We map the real shared_info
+ * page as soon as fixmap is up and running.
+ */
+struct shared_info *HYPERVISOR_shared_info = (void *)&dummy_shared_info;
+
+/* tristate - -1: not tested, 0: not available, 1: available */
+static int have_vcpu_info_placement = -1;
+
 void xen_vcpu_setup(int cpu)
 {
+	struct vcpu_register_vcpu_info info;
+	int err;
+	struct vcpu_info *vcpup;
+
 	per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
+
+	if (!have_vcpu_info_placement)
+		return;		/* already tested, not available */
+
+	vcpup = &per_cpu(xen_vcpu_info, cpu);
+
+	printk("setting up vcpu for %d: xen_vcpu_info=%p\n",
+	       cpu, vcpup);
+
+	info.mfn = virt_to_mfn(vcpup);
+	info.offset = offset_in_page(vcpup);
+
+	printk("trying to map vcpu_info %d at %p, mfn %x, offset %d\n",
+	       cpu, vcpup, info.mfn, info.offset);
+
+	/* Check to see if the hypervisor will put the vcpu_info
+	   structure where we want it, which allows direct access via
+	   a percpu-variable. */
+	err = HYPERVISOR_vcpu_op(VCPUOP_register_vcpu_info, cpu, &info);
+
+	BUG_ON(err != 0 && err != -ENOSYS);
+	BUG_ON(err && have_vcpu_info_placement==1);  /* all or nothing */
+
+	have_vcpu_info_placement = 0;
+
+	if (err == 0) {
+		have_vcpu_info_placement = 1;
+		per_cpu(xen_vcpu, cpu) = vcpup;
+		printk("cpu %d using vcpu_info at %p\n",
+		       cpu, vcpup);
+	}
 }
 
 static void __init xen_banner(void)
@@ -123,6 +169,20 @@ static unsigned long xen_save_fl(void)
 	return (-flags) & X86_EFLAGS_IF;
 }
 
+static unsigned long xen_save_fl_direct(void)
+{
+	unsigned long flags;
+
+	/* flag has opposite sense of mask */
+	flags = !x86_read_percpu(xen_vcpu_info.evtchn_upcall_mask);
+
+	/* convert to IF type flag
+	   -0 -> 0x00000000
+	   -1 -> 0xffffffff
+	*/
+	return (-flags) & X86_EFLAGS_IF;
+}
+
 static void xen_restore_fl(unsigned long flags)
 {
 	struct vcpu_info *vcpu;
@@ -149,6 +209,25 @@ static void xen_restore_fl(unsigned long
 	}
 }
 
+static void xen_restore_fl_direct(unsigned long flags)
+{
+	/* convert from IF type flag */
+	flags = !(flags & X86_EFLAGS_IF);
+
+	/* This is an atomic update, so no need to worry about
+	   preemption. */
+	x86_write_percpu(xen_vcpu_info.evtchn_upcall_mask, flags);
+
+	/* If we get preempted here, then any pending event will be
+	   handled anyway. */
+
+	if (flags == 0) {
+		barrier(); /* unmask then check (avoid races) */
+		if (unlikely(x86_read_percpu(xen_vcpu_info.evtchn_upcall_pending)))
+			force_evtchn_callback();
+	}
+}
+
 static void xen_irq_disable(void)
 {
 	/* There's a one instruction preempt window here.  We need to
@@ -157,6 +236,12 @@ static void xen_irq_disable(void)
 	preempt_disable();
 	x86_read_percpu(xen_vcpu)->evtchn_upcall_mask = 1;
 	preempt_enable_no_resched();
+}
+
+static void xen_irq_disable_direct(void)
+{
+	/* Atomic update, so preemption not a concern. */
+	x86_write_percpu(xen_vcpu_info.evtchn_upcall_mask, 1);
 }
 
 static void xen_irq_enable(void)
@@ -176,6 +261,19 @@ static void xen_irq_enable(void)
 
 	barrier(); /* unmask then check (avoid races) */
 	if (unlikely(vcpu->evtchn_upcall_pending))
+		force_evtchn_callback();
+}
+
+static void xen_irq_enable_direct(void)
+{
+	/* Atomic update, so preemption not a concern. */
+	x86_write_percpu(xen_vcpu_info.evtchn_upcall_mask, 0);
+
+	/* Doesn't matter if we get preempted here, because any
+	   pending event will get dealt with anyway. */
+
+	barrier(); /* unmask then check (avoid races) */
+	if (unlikely(x86_read_percpu(xen_vcpu_info.evtchn_upcall_pending)))
 		force_evtchn_callback();
 }
 
@@ -538,9 +636,19 @@ static void xen_flush_tlb_others(const c
 	xen_mc_issue(PARAVIRT_LAZY_MMU);
 }
 
+static void xen_write_cr2(unsigned long cr2)
+{
+	x86_read_percpu(xen_vcpu)->arch.cr2 = cr2;
+}
+
 static unsigned long xen_read_cr2(void)
 {
 	return x86_read_percpu(xen_vcpu)->arch.cr2;
+}
+
+static unsigned long xen_read_cr2_direct(void)
+{
+	return x86_read_percpu(xen_vcpu_info.arch.cr2);
 }
 
 static void xen_write_cr4(unsigned long cr4)
@@ -775,7 +883,7 @@ static const struct paravirt_ops xen_par
 	.write_cr0 = native_write_cr0,
 
 	.read_cr2 = xen_read_cr2,
-	.write_cr2 = native_write_cr2,
+	.write_cr2 = xen_write_cr2,
 
 	.read_cr3 = xen_read_cr3,
 	.write_cr3 = xen_write_cr3,
@@ -963,6 +1071,17 @@ static asmlinkage void __init xen_start_
 	x86_write_percpu(xen_cr3, __pa(pgd));
 	xen_vcpu_setup(0);
 
+	/* xen_vcpu_setup managed to place the vcpu_info within the
+	   pda, so make use of it */
+	BUG_ON(have_vcpu_info_placement == -1);
+	if (have_vcpu_info_placement) {
+		paravirt_ops.save_fl = xen_save_fl_direct;
+		paravirt_ops.restore_fl = xen_restore_fl_direct;
+		paravirt_ops.irq_disable = xen_irq_disable_direct;
+		paravirt_ops.irq_enable = xen_irq_enable_direct;
+		paravirt_ops.read_cr2 = xen_read_cr2_direct;
+	}
+
 	paravirt_ops.kernel_rpl = 1;
 	if (xen_feature(XENFEAT_supervisor_mode_kernel))
 		paravirt_ops.kernel_rpl = 0;
===================================================================
--- a/arch/i386/xen/setup.c
+++ b/arch/i386/xen/setup.c
@@ -22,14 +22,6 @@
 /* These are code, but not functions.  Defined in entry.S */
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
-
-static __initdata struct shared_info init_shared;
-
-/*
- * Point at some empty memory to start with. We map the real shared_info
- * page as soon as fixmap is up and running.
- */
-struct shared_info *HYPERVISOR_shared_info = &init_shared;
 
 unsigned long *phys_to_machine_mapping;
 EXPORT_SYMBOL(phys_to_machine_mapping);
===================================================================
--- a/include/xen/interface/vcpu.h
+++ b/include/xen/interface/vcpu.h
@@ -151,6 +151,19 @@ struct vcpu_set_singleshot_timer {
 #define _VCPU_SSHOTTMR_future (0)
 #define VCPU_SSHOTTMR_future  (1U << _VCPU_SSHOTTMR_future)
 
+/*
+ * Register a memory location in the guest address space for the
+ * vcpu_info structure.  This allows the guest to place the vcpu_info
+ * structure in a convenient place, such as in a per-cpu data area.
+ * The pointer need not be page aligned, but the structure must not
+ * cross a page boundary.
+ */
+#define VCPUOP_register_vcpu_info   10  /* arg == struct vcpu_info */
+struct vcpu_register_vcpu_info {
+    uint32_t mfn;               /* mfn of page to place vcpu_info */
+    uint32_t offset;            /* offset within page */
+};
+
 #endif /* __XEN_PUBLIC_VCPU_H__ */
 
 /*

-- 

