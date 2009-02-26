Return-Path: <linux-kernel-owner+w=401wt.eu-S1760442AbZBZOXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442AbZBZOXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbZBZOQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43082 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbZBZOPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:42 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 13/40] KVM: New guest debug interface
Date: Thu, 26 Feb 2009 16:15:03 +0200
Message-Id: <1235657730-27683-14-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

This rips out the support for KVM_DEBUG_GUEST and introduces a new IOCTL
instead: KVM_SET_GUEST_DEBUG. The IOCTL payload consists of a generic
part, controlling the "main switch" and the single-step feature. The
arch specific part adds an x86 interface for intercepting both types of
debug exceptions separately and re-injecting them when the host was not
interested. Moveover, the foundation for guest debugging via debug
registers is layed.

To signal breakpoint events properly back to userland, an arch-specific
data block is now returned along KVM_EXIT_DEBUG. For x86, the arch block
contains the PC, the debug exception, and relevant debug registers to
tell debug events properly apart.

The availability of this new interface is signaled by
KVM_CAP_SET_GUEST_DEBUG. Empty stubs for not yet supported archs are
provided.

Note that both SVM and VTX are supported, but only the latter was tested
yet. Based on the experience with all those VTX corner case, I would be
fairly surprised if SVM will work out of the box.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm.h     |    7 +++
 arch/ia64/kvm/kvm-ia64.c        |    4 +-
 arch/powerpc/include/asm/kvm.h  |    7 +++
 arch/powerpc/kvm/powerpc.c      |    4 +-
 arch/s390/include/asm/kvm.h     |    7 +++
 arch/s390/kvm/kvm-s390.c        |    4 +-
 arch/x86/include/asm/kvm.h      |   18 ++++++++
 arch/x86/include/asm/kvm_host.h |    9 +---
 arch/x86/kvm/svm.c              |   50 ++++++++++++++++++++-
 arch/x86/kvm/vmx.c              |   93 +++++++++++++++------------------------
 arch/x86/kvm/x86.c              |   14 +++---
 include/linux/kvm.h             |   51 +++++++++++++++-------
 include/linux/kvm_host.h        |    6 +-
 virt/kvm/kvm_main.c             |    6 +-
 14 files changed, 179 insertions(+), 101 deletions(-)

diff --git a/arch/ia64/include/asm/kvm.h b/arch/ia64/include/asm/kvm.h
index bfa86b6..be3fdb8 100644
--- a/arch/ia64/include/asm/kvm.h
+++ b/arch/ia64/include/asm/kvm.h
@@ -214,4 +214,11 @@ struct kvm_sregs {
 struct kvm_fpu {
 };
 
+struct kvm_debug_exit_arch {
+};
+
+/* for KVM_SET_GUEST_DEBUG */
+struct kvm_guest_debug_arch {
+};
+
 #endif
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 28f9820..de47467 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1303,8 +1303,8 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	return -EINVAL;
 }
 
-int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
-		struct kvm_debug_guest *dbg)
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg)
 {
 	return -EINVAL;
 }
diff --git a/arch/powerpc/include/asm/kvm.h b/arch/powerpc/include/asm/kvm.h
index f993e41..755f1b1 100644
--- a/arch/powerpc/include/asm/kvm.h
+++ b/arch/powerpc/include/asm/kvm.h
@@ -52,4 +52,11 @@ struct kvm_fpu {
 	__u64 fpr[32];
 };
 
+struct kvm_debug_exit_arch {
+};
+
+/* for KVM_SET_GUEST_DEBUG */
+struct kvm_guest_debug_arch {
+};
+
 #endif /* __LINUX_KVM_POWERPC_H */
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 5f81256..7c2ad40 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -240,8 +240,8 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvmppc_core_vcpu_put(vcpu);
 }
 
-int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
-                                    struct kvm_debug_guest *dbg)
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg)
 {
 	int i;
 
diff --git a/arch/s390/include/asm/kvm.h b/arch/s390/include/asm/kvm.h
index e1f5465..0b2f829 100644
--- a/arch/s390/include/asm/kvm.h
+++ b/arch/s390/include/asm/kvm.h
@@ -42,4 +42,11 @@ struct kvm_fpu {
 	__u64 fprs[16];
 };
 
+struct kvm_debug_exit_arch {
+};
+
+/* for KVM_SET_GUEST_DEBUG */
+struct kvm_guest_debug_arch {
+};
+
 #endif
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0d33893..cbfe91e 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -422,8 +422,8 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	return -EINVAL; /* not implemented yet */
 }
 
-int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
-				    struct kvm_debug_guest *dbg)
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg)
 {
 	return -EINVAL; /* not implemented yet */
 }
diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
index 886c940..32eb96c 100644
--- a/arch/x86/include/asm/kvm.h
+++ b/arch/x86/include/asm/kvm.h
@@ -212,6 +212,24 @@ struct kvm_pit_channel_state {
 	__s64 count_load_time;
 };
 
+struct kvm_debug_exit_arch {
+	__u32 exception;
+	__u32 pad;
+	__u64 pc;
+	__u64 dr6;
+	__u64 dr7;
+};
+
+#define KVM_GUESTDBG_USE_SW_BP		0x00010000
+#define KVM_GUESTDBG_USE_HW_BP		0x00020000
+#define KVM_GUESTDBG_INJECT_DB		0x00040000
+#define KVM_GUESTDBG_INJECT_BP		0x00080000
+
+/* for KVM_SET_GUEST_DEBUG */
+struct kvm_guest_debug_arch {
+	__u64 debugreg[8];
+};
+
 struct kvm_pit_state {
 	struct kvm_pit_channel_state channels[3];
 };
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5377930..c430cd5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -135,12 +135,6 @@ enum {
 
 #define KVM_NR_MEM_OBJS 40
 
-struct kvm_guest_debug {
-	int enabled;
-	unsigned long bp[4];
-	int singlestep;
-};
-
 /*
  * We don't want allocation failures within the mmu code, so we preallocate
  * enough memory for a single page fault in a cache.
@@ -448,8 +442,7 @@ struct kvm_x86_ops {
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 
 	int (*set_guest_debug)(struct kvm_vcpu *vcpu,
-			       struct kvm_debug_guest *dbg);
-	void (*guest_debug_pre)(struct kvm_vcpu *vcpu);
+			       struct kvm_guest_debug *dbg);
 	int (*get_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
 	int (*set_msr)(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 	u64 (*get_segment_base)(struct kvm_vcpu *vcpu, int seg);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0fbbde5..88d9062 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -968,9 +968,32 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 
 }
 
-static int svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
+static int svm_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
 {
-	return -EOPNOTSUPP;
+	int old_debug = vcpu->guest_debug;
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	vcpu->guest_debug = dbg->control;
+
+	svm->vmcb->control.intercept_exceptions &=
+		~((1 << DB_VECTOR) | (1 << BP_VECTOR));
+	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
+		if (vcpu->guest_debug &
+		    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
+			svm->vmcb->control.intercept_exceptions |=
+				1 << DB_VECTOR;
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
+			svm->vmcb->control.intercept_exceptions |=
+				1 << BP_VECTOR;
+	} else
+		vcpu->guest_debug = 0;
+
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		svm->vmcb->save.rflags |= X86_EFLAGS_TF | X86_EFLAGS_RF;
+	else if (old_debug & KVM_GUESTDBG_SINGLESTEP)
+		svm->vmcb->save.rflags &= ~(X86_EFLAGS_TF | X86_EFLAGS_RF);
+
+	return 0;
 }
 
 static int svm_get_irq(struct kvm_vcpu *vcpu)
@@ -1094,6 +1117,27 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code);
 }
 
+static int db_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	if (!(svm->vcpu.guest_debug &
+	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
+		kvm_queue_exception(&svm->vcpu, DB_VECTOR);
+		return 1;
+	}
+	kvm_run->exit_reason = KVM_EXIT_DEBUG;
+	kvm_run->debug.arch.pc = svm->vmcb->save.cs.base + svm->vmcb->save.rip;
+	kvm_run->debug.arch.exception = DB_VECTOR;
+	return 0;
+}
+
+static int bp_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
+{
+	kvm_run->exit_reason = KVM_EXIT_DEBUG;
+	kvm_run->debug.arch.pc = svm->vmcb->save.cs.base + svm->vmcb->save.rip;
+	kvm_run->debug.arch.exception = BP_VECTOR;
+	return 0;
+}
+
 static int ud_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	int er;
@@ -2050,6 +2094,8 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm,
 	[SVM_EXIT_WRITE_DR3]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_DR5]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_DR7]			= emulate_on_interception,
+	[SVM_EXIT_EXCP_BASE + DB_VECTOR]	= db_interception,
+	[SVM_EXIT_EXCP_BASE + BP_VECTOR]	= bp_interception,
 	[SVM_EXIT_EXCP_BASE + UD_VECTOR]	= ud_interception,
 	[SVM_EXIT_EXCP_BASE + PF_VECTOR] 	= pf_interception,
 	[SVM_EXIT_EXCP_BASE + NM_VECTOR] 	= nm_interception,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1d974c1..f55690d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -480,8 +480,13 @@ static void update_exception_bitmap(struct kvm_vcpu *vcpu)
 	eb = (1u << PF_VECTOR) | (1u << UD_VECTOR);
 	if (!vcpu->fpu_active)
 		eb |= 1u << NM_VECTOR;
-	if (vcpu->guest_debug.enabled)
-		eb |= 1u << DB_VECTOR;
+	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
+		if (vcpu->guest_debug &
+		    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
+			eb |= 1u << DB_VECTOR;
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
+			eb |= 1u << BP_VECTOR;
+	}
 	if (vcpu->arch.rmode.active)
 		eb = ~0;
 	if (vm_need_ept())
@@ -1003,40 +1008,23 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	}
 }
 
-static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_debug_guest *dbg)
+static int set_guest_debug(struct kvm_vcpu *vcpu, struct kvm_guest_debug *dbg)
 {
-	unsigned long dr7 = 0x400;
-	int old_singlestep;
-
-	old_singlestep = vcpu->guest_debug.singlestep;
-
-	vcpu->guest_debug.enabled = dbg->enabled;
-	if (vcpu->guest_debug.enabled) {
-		int i;
-
-		dr7 |= 0x200;  /* exact */
-		for (i = 0; i < 4; ++i) {
-			if (!dbg->breakpoints[i].enabled)
-				continue;
-			vcpu->guest_debug.bp[i] = dbg->breakpoints[i].address;
-			dr7 |= 2 << (i*2);    /* global enable */
-			dr7 |= 0 << (i*4+16); /* execution breakpoint */
-		}
-
-		vcpu->guest_debug.singlestep = dbg->singlestep;
-	} else
-		vcpu->guest_debug.singlestep = 0;
+	int old_debug = vcpu->guest_debug;
+	unsigned long flags;
 
-	if (old_singlestep && !vcpu->guest_debug.singlestep) {
-		unsigned long flags;
+	vcpu->guest_debug = dbg->control;
+	if (!(vcpu->guest_debug & KVM_GUESTDBG_ENABLE))
+		vcpu->guest_debug = 0;
 
-		flags = vmcs_readl(GUEST_RFLAGS);
+	flags = vmcs_readl(GUEST_RFLAGS);
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+		flags |= X86_EFLAGS_TF | X86_EFLAGS_RF;
+	else if (old_debug & KVM_GUESTDBG_SINGLESTEP)
 		flags &= ~(X86_EFLAGS_TF | X86_EFLAGS_RF);
-		vmcs_writel(GUEST_RFLAGS, flags);
-	}
+	vmcs_writel(GUEST_RFLAGS, flags);
 
 	update_exception_bitmap(vcpu);
-	vmcs_writel(GUEST_DR7, dr7);
 
 	return 0;
 }
@@ -2540,24 +2528,6 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 	return 0;
 }
 
-static void kvm_guest_debug_pre(struct kvm_vcpu *vcpu)
-{
-	struct kvm_guest_debug *dbg = &vcpu->guest_debug;
-
-	set_debugreg(dbg->bp[0], 0);
-	set_debugreg(dbg->bp[1], 1);
-	set_debugreg(dbg->bp[2], 2);
-	set_debugreg(dbg->bp[3], 3);
-
-	if (dbg->singlestep) {
-		unsigned long flags;
-
-		flags = vmcs_readl(GUEST_RFLAGS);
-		flags |= X86_EFLAGS_TF | X86_EFLAGS_RF;
-		vmcs_writel(GUEST_RFLAGS, flags);
-	}
-}
-
 static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 				  int vec, u32 err_code)
 {
@@ -2574,9 +2544,17 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 	 *        the required debugging infrastructure rework.
 	 */
 	switch (vec) {
-	case DE_VECTOR:
 	case DB_VECTOR:
+		if (vcpu->guest_debug &
+		    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
+			return 0;
+		kvm_queue_exception(vcpu, vec);
+		return 1;
 	case BP_VECTOR:
+		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
+			return 0;
+		/* fall through */
+	case DE_VECTOR:
 	case OF_VECTOR:
 	case BR_VECTOR:
 	case UD_VECTOR:
@@ -2593,7 +2571,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 intr_info, error_code;
+	u32 intr_info, ex_no, error_code;
 	unsigned long cr2, rip;
 	u32 vect_info;
 	enum emulation_result er;
@@ -2653,14 +2631,16 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		return 1;
 	}
 
-	if ((intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK)) ==
-	    (INTR_TYPE_HARD_EXCEPTION | 1)) {
+	ex_no = intr_info & INTR_INFO_VECTOR_MASK;
+	if (ex_no == DB_VECTOR || ex_no == BP_VECTOR) {
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
-		return 0;
+		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
+		kvm_run->debug.arch.exception = ex_no;
+	} else {
+		kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
+		kvm_run->ex.exception = ex_no;
+		kvm_run->ex.error_code = error_code;
 	}
-	kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
-	kvm_run->ex.exception = intr_info & INTR_INFO_VECTOR_MASK;
-	kvm_run->ex.error_code = error_code;
 	return 0;
 }
 
@@ -3600,7 +3580,6 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.vcpu_put = vmx_vcpu_put,
 
 	.set_guest_debug = set_guest_debug,
-	.guest_debug_pre = kvm_guest_debug_pre,
 	.get_msr = vmx_get_msr,
 	.set_msr = vmx_set_msr,
 	.get_segment_base = vmx_get_segment_base,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b5e9932..e990d16 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3005,9 +3005,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		goto out;
 	}
 
-	if (vcpu->guest_debug.enabled)
-		kvm_x86_ops->guest_debug_pre(vcpu);
-
 	vcpu->guest_mode = 1;
 	/*
 	 * Make sure that guest_mode assignment won't happen after
@@ -3218,7 +3215,7 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	/*
 	 * Don't leak debug flags in case they were set for guest debugging
 	 */
-	if (vcpu->guest_debug.enabled && vcpu->guest_debug.singlestep)
+	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		regs->rflags &= ~(X86_EFLAGS_TF | X86_EFLAGS_RF);
 
 	vcpu_put(vcpu);
@@ -3837,8 +3834,8 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
-				    struct kvm_debug_guest *dbg)
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg)
 {
 	int r;
 
@@ -3846,6 +3843,11 @@ int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
 
 	r = kvm_x86_ops->set_guest_debug(vcpu, dbg);
 
+	if (dbg->control & KVM_GUESTDBG_INJECT_DB)
+		kvm_queue_exception(vcpu, DB_VECTOR);
+	else if (dbg->control & KVM_GUESTDBG_INJECT_BP)
+		kvm_queue_exception(vcpu, BP_VECTOR);
+
 	vcpu_put(vcpu);
 
 	return r;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 0424326..429a2ce 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -126,6 +126,7 @@ struct kvm_run {
 			__u64 data_offset; /* relative to kvm_run start */
 		} io;
 		struct {
+			struct kvm_debug_exit_arch arch;
 		} debug;
 		/* KVM_EXIT_MMIO */
 		struct {
@@ -217,21 +218,6 @@ struct kvm_interrupt {
 	__u32 irq;
 };
 
-struct kvm_breakpoint {
-	__u32 enabled;
-	__u32 padding;
-	__u64 address;
-};
-
-/* for KVM_DEBUG_GUEST */
-struct kvm_debug_guest {
-	/* int */
-	__u32 enabled;
-	__u32 pad;
-	struct kvm_breakpoint breakpoints[4];
-	__u32 singlestep;
-};
-
 /* for KVM_GET_DIRTY_LOG */
 struct kvm_dirty_log {
 	__u32 slot;
@@ -292,6 +278,17 @@ struct kvm_s390_interrupt {
 	__u64 parm64;
 };
 
+/* for KVM_SET_GUEST_DEBUG */
+
+#define KVM_GUESTDBG_ENABLE		0x00000001
+#define KVM_GUESTDBG_SINGLESTEP		0x00000002
+
+struct kvm_guest_debug {
+	__u32 control;
+	__u32 pad;
+	struct kvm_guest_debug_arch arch;
+};
+
 #define KVM_TRC_SHIFT           16
 /*
  * kvm trace categories
@@ -396,6 +393,7 @@ struct kvm_trace_rec {
 #ifdef __KVM_HAVE_USER_NMI
 #define KVM_CAP_USER_NMI 22
 #endif
+#define KVM_CAP_SET_GUEST_DEBUG 23
 
 /*
  * ioctls for VM fds
@@ -440,7 +438,8 @@ struct kvm_trace_rec {
 #define KVM_SET_SREGS             _IOW(KVMIO,  0x84, struct kvm_sregs)
 #define KVM_TRANSLATE             _IOWR(KVMIO, 0x85, struct kvm_translation)
 #define KVM_INTERRUPT             _IOW(KVMIO,  0x86, struct kvm_interrupt)
-#define KVM_DEBUG_GUEST           _IOW(KVMIO,  0x87, struct kvm_debug_guest)
+/* KVM_DEBUG_GUEST is no longer supported, use KVM_SET_GUEST_DEBUG instead */
+#define KVM_DEBUG_GUEST           __KVM_DEPRECATED_DEBUG_GUEST
 #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
 #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
 #define KVM_SET_CPUID             _IOW(KVMIO,  0x8a, struct kvm_cpuid)
@@ -469,6 +468,26 @@ struct kvm_trace_rec {
 #define KVM_SET_MP_STATE          _IOW(KVMIO,  0x99, struct kvm_mp_state)
 /* Available with KVM_CAP_NMI */
 #define KVM_NMI                   _IO(KVMIO,  0x9a)
+/* Available with KVM_CAP_SET_GUEST_DEBUG */
+#define KVM_SET_GUEST_DEBUG       _IOW(KVMIO,  0x9b, struct kvm_guest_debug)
+
+/*
+ * Deprecated interfaces
+ */
+struct kvm_breakpoint {
+	__u32 enabled;
+	__u32 padding;
+	__u64 address;
+};
+
+struct kvm_debug_guest {
+	__u32 enabled;
+	__u32 pad;
+	struct kvm_breakpoint breakpoints[4];
+	__u32 singlestep;
+};
+
+#define __KVM_DEPRECATED_DEBUG_GUEST _IOW(KVMIO,  0x87, struct kvm_debug_guest)
 
 #define KVM_TRC_INJ_VIRQ         (KVM_TRC_HANDLER + 0x02)
 #define KVM_TRC_REDELIVER_EVT    (KVM_TRC_HANDLER + 0x03)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bf6f703..e92212f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -73,7 +73,7 @@ struct kvm_vcpu {
 	struct kvm_run *run;
 	int guest_mode;
 	unsigned long requests;
-	struct kvm_guest_debug guest_debug;
+	unsigned long guest_debug;
 	int fpu_active;
 	int guest_fpu_loaded;
 	wait_queue_head_t wq;
@@ -255,8 +255,8 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state);
 int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state);
-int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
-				    struct kvm_debug_guest *dbg);
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg);
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
 
 int kvm_arch_init(void *opaque);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 29a667c..f83ef9c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1755,13 +1755,13 @@ out_free2:
 		r = 0;
 		break;
 	}
-	case KVM_DEBUG_GUEST: {
-		struct kvm_debug_guest dbg;
+	case KVM_SET_GUEST_DEBUG: {
+		struct kvm_guest_debug dbg;
 
 		r = -EFAULT;
 		if (copy_from_user(&dbg, argp, sizeof dbg))
 			goto out;
-		r = kvm_arch_vcpu_ioctl_debug_guest(vcpu, &dbg);
+		r = kvm_arch_vcpu_ioctl_set_guest_debug(vcpu, &dbg);
 		if (r)
 			goto out;
 		r = 0;
-- 
1.6.0.6

