Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab0BMIDr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:03:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab0BMICH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:07 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 31/39] KVM: PPC: Add support for FPU/Altivec/VSX
Date: Sat, 13 Feb 2010 10:01:51 +0200
Message-Id: <1266048119-14325-32-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

When our guest starts using either the FPU, Altivec or VSX we need to make
sure Linux knows about it and sneak into its process switching code
accordingly.

This patch makes accesses to the above parts of the system work inside the
VM.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_host.h |   14 +++-
 arch/powerpc/kvm/book3s.c           |  193 ++++++++++++++++++++++++++++++++++-
 2 files changed, 201 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index f7215e6..c30a70c 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -172,9 +172,20 @@ struct kvm_vcpu_arch {
 	struct kvmppc_mmu mmu;
 #endif
 
-	u64 fpr[32];
 	ulong gpr[32];
 
+	u64 fpr[32];
+	u32 fpscr;
+
+#ifdef CONFIG_ALTIVEC
+	vector128 vr[32];
+	vector128 vscr;
+#endif
+
+#ifdef CONFIG_VSX
+	u64 vsr[32];
+#endif
+
 	ulong pc;
 	ulong ctr;
 	ulong lr;
@@ -188,6 +199,7 @@ struct kvm_vcpu_arch {
 #ifdef CONFIG_PPC64
 	ulong shadow_msr;
 	ulong hflags;
+	ulong guest_owned_ext;
 #endif
 	u32 mmucr;
 	ulong sprg0;
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 02861fd..2cb1813 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -33,6 +33,9 @@
 
 /* #define EXIT_DEBUG */
 /* #define EXIT_DEBUG_SIMPLE */
+/* #define DEBUG_EXT */
+
+static void kvmppc_giveup_ext(struct kvm_vcpu *vcpu, ulong msr);
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "exits",       VCPU_STAT(sum_exits) },
@@ -77,6 +80,10 @@ void kvmppc_core_vcpu_put(struct kvm_vcpu *vcpu)
 	memcpy(&to_book3s(vcpu)->shadow_vcpu, &get_paca()->shadow_vcpu,
 	       sizeof(get_paca()->shadow_vcpu));
 	to_book3s(vcpu)->slb_shadow_max = get_paca()->kvm_slb_max;
+
+	kvmppc_giveup_ext(vcpu, MSR_FP);
+	kvmppc_giveup_ext(vcpu, MSR_VEC);
+	kvmppc_giveup_ext(vcpu, MSR_VSX);
 }
 
 #if defined(EXIT_DEBUG)
@@ -97,9 +104,9 @@ void kvmppc_set_msr(struct kvm_vcpu *vcpu, u64 msr)
 	msr &= to_book3s(vcpu)->msr_mask;
 	vcpu->arch.msr = msr;
 	vcpu->arch.shadow_msr = msr | MSR_USER32;
-	vcpu->arch.shadow_msr &= ( MSR_VEC | MSR_VSX | MSR_FP | MSR_FE0 |
-				   MSR_USER64 | MSR_SE | MSR_BE | MSR_DE |
-				   MSR_FE1);
+	vcpu->arch.shadow_msr &= (MSR_FE0 | MSR_USER64 | MSR_SE | MSR_BE |
+				  MSR_DE | MSR_FE1);
+	vcpu->arch.shadow_msr |= (msr & vcpu->arch.guest_owned_ext);
 
 	if (msr & (MSR_WE|MSR_POW)) {
 		if (!vcpu->arch.pending_exceptions) {
@@ -551,6 +558,117 @@ int kvmppc_handle_pagefault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	return r;
 }
 
+static inline int get_fpr_index(int i)
+{
+#ifdef CONFIG_VSX
+	i *= 2;
+#endif
+	return i;
+}
+
+/* Give up external provider (FPU, Altivec, VSX) */
+static void kvmppc_giveup_ext(struct kvm_vcpu *vcpu, ulong msr)
+{
+	struct thread_struct *t = &current->thread;
+	u64 *vcpu_fpr = vcpu->arch.fpr;
+	u64 *vcpu_vsx = vcpu->arch.vsr;
+	u64 *thread_fpr = (u64*)t->fpr;
+	int i;
+
+	if (!(vcpu->arch.guest_owned_ext & msr))
+		return;
+
+#ifdef DEBUG_EXT
+	printk(KERN_INFO "Giving up ext 0x%lx\n", msr);
+#endif
+
+	switch (msr) {
+	case MSR_FP:
+		giveup_fpu(current);
+		for (i = 0; i < ARRAY_SIZE(vcpu->arch.fpr); i++)
+			vcpu_fpr[i] = thread_fpr[get_fpr_index(i)];
+
+		vcpu->arch.fpscr = t->fpscr.val;
+		break;
+	case MSR_VEC:
+#ifdef CONFIG_ALTIVEC
+		giveup_altivec(current);
+		memcpy(vcpu->arch.vr, t->vr, sizeof(vcpu->arch.vr));
+		vcpu->arch.vscr = t->vscr;
+#endif
+		break;
+	case MSR_VSX:
+#ifdef CONFIG_VSX
+		__giveup_vsx(current);
+		for (i = 0; i < ARRAY_SIZE(vcpu->arch.vsr); i++)
+			vcpu_vsx[i] = thread_fpr[get_fpr_index(i) + 1];
+#endif
+		break;
+	default:
+		BUG();
+	}
+
+	vcpu->arch.guest_owned_ext &= ~msr;
+	current->thread.regs->msr &= ~msr;
+	kvmppc_set_msr(vcpu, vcpu->arch.msr);
+}
+
+/* Handle external providers (FPU, Altivec, VSX) */
+static int kvmppc_handle_ext(struct kvm_vcpu *vcpu, unsigned int exit_nr,
+			     ulong msr)
+{
+	struct thread_struct *t = &current->thread;
+	u64 *vcpu_fpr = vcpu->arch.fpr;
+	u64 *vcpu_vsx = vcpu->arch.vsr;
+	u64 *thread_fpr = (u64*)t->fpr;
+	int i;
+
+	if (!(vcpu->arch.msr & msr)) {
+		kvmppc_book3s_queue_irqprio(vcpu, exit_nr);
+		return RESUME_GUEST;
+	}
+
+#ifdef DEBUG_EXT
+	printk(KERN_INFO "Loading up ext 0x%lx\n", msr);
+#endif
+
+	current->thread.regs->msr |= msr;
+
+	switch (msr) {
+	case MSR_FP:
+		for (i = 0; i < ARRAY_SIZE(vcpu->arch.fpr); i++)
+			thread_fpr[get_fpr_index(i)] = vcpu_fpr[i];
+
+		t->fpscr.val = vcpu->arch.fpscr;
+		t->fpexc_mode = 0;
+		kvmppc_load_up_fpu();
+		break;
+	case MSR_VEC:
+#ifdef CONFIG_ALTIVEC
+		memcpy(t->vr, vcpu->arch.vr, sizeof(vcpu->arch.vr));
+		t->vscr = vcpu->arch.vscr;
+		t->vrsave = -1;
+		kvmppc_load_up_altivec();
+#endif
+		break;
+	case MSR_VSX:
+#ifdef CONFIG_VSX
+		for (i = 0; i < ARRAY_SIZE(vcpu->arch.vsr); i++)
+			thread_fpr[get_fpr_index(i) + 1] = vcpu_vsx[i];
+		kvmppc_load_up_vsx();
+#endif
+		break;
+	default:
+		BUG();
+	}
+
+	vcpu->arch.guest_owned_ext |= msr;
+
+	kvmppc_set_msr(vcpu, vcpu->arch.msr);
+
+	return RESUME_GUEST;
+}
+
 int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
                        unsigned int exit_nr)
 {
@@ -674,11 +792,17 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		kvmppc_book3s_queue_irqprio(vcpu, exit_nr);
 		r = RESUME_GUEST;
 		break;
-	case BOOK3S_INTERRUPT_MACHINE_CHECK:
 	case BOOK3S_INTERRUPT_FP_UNAVAIL:
-	case BOOK3S_INTERRUPT_TRACE:
+		r = kvmppc_handle_ext(vcpu, exit_nr, MSR_FP);
+		break;
 	case BOOK3S_INTERRUPT_ALTIVEC:
+		r = kvmppc_handle_ext(vcpu, exit_nr, MSR_VEC);
+		break;
 	case BOOK3S_INTERRUPT_VSX:
+		r = kvmppc_handle_ext(vcpu, exit_nr, MSR_VSX);
+		break;
+	case BOOK3S_INTERRUPT_MACHINE_CHECK:
+	case BOOK3S_INTERRUPT_TRACE:
 		kvmppc_book3s_queue_irqprio(vcpu, exit_nr);
 		r = RESUME_GUEST;
 		break;
@@ -959,6 +1083,10 @@ extern int __kvmppc_vcpu_entry(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu);
 int __kvmppc_vcpu_run(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 {
 	int ret;
+	struct thread_struct ext_bkp;
+	bool save_vec = current->thread.used_vr;
+	bool save_vsx = current->thread.used_vsr;
+	ulong ext_msr;
 
 	/* No need to go into the guest when all we do is going out */
 	if (signal_pending(current)) {
@@ -966,6 +1094,35 @@ int __kvmppc_vcpu_run(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 		return -EINTR;
 	}
 
+	/* Save FPU state in stack */
+	if (current->thread.regs->msr & MSR_FP)
+		giveup_fpu(current);
+	memcpy(ext_bkp.fpr, current->thread.fpr, sizeof(current->thread.fpr));
+	ext_bkp.fpscr = current->thread.fpscr;
+	ext_bkp.fpexc_mode = current->thread.fpexc_mode;
+
+#ifdef CONFIG_ALTIVEC
+	/* Save Altivec state in stack */
+	if (save_vec) {
+		if (current->thread.regs->msr & MSR_VEC)
+			giveup_altivec(current);
+		memcpy(ext_bkp.vr, current->thread.vr, sizeof(ext_bkp.vr));
+		ext_bkp.vscr = current->thread.vscr;
+		ext_bkp.vrsave = current->thread.vrsave;
+	}
+	ext_bkp.used_vr = current->thread.used_vr;
+#endif
+
+#ifdef CONFIG_VSX
+	/* Save VSX state in stack */
+	if (save_vsx && (current->thread.regs->msr & MSR_VSX))
+			__giveup_vsx(current);
+	ext_bkp.used_vsr = current->thread.used_vsr;
+#endif
+
+	/* Remember the MSR with disabled extensions */
+	ext_msr = current->thread.regs->msr;
+
 	/* XXX we get called with irq disabled - change that! */
 	local_irq_enable();
 
@@ -973,6 +1130,32 @@ int __kvmppc_vcpu_run(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 
 	local_irq_disable();
 
+	current->thread.regs->msr = ext_msr;
+
+	/* Make sure we save the guest FPU/Altivec/VSX state */
+	kvmppc_giveup_ext(vcpu, MSR_FP);
+	kvmppc_giveup_ext(vcpu, MSR_VEC);
+	kvmppc_giveup_ext(vcpu, MSR_VSX);
+
+	/* Restore FPU state from stack */
+	memcpy(current->thread.fpr, ext_bkp.fpr, sizeof(ext_bkp.fpr));
+	current->thread.fpscr = ext_bkp.fpscr;
+	current->thread.fpexc_mode = ext_bkp.fpexc_mode;
+
+#ifdef CONFIG_ALTIVEC
+	/* Restore Altivec state from stack */
+	if (save_vec && current->thread.used_vr) {
+		memcpy(current->thread.vr, ext_bkp.vr, sizeof(ext_bkp.vr));
+		current->thread.vscr = ext_bkp.vscr;
+		current->thread.vrsave= ext_bkp.vrsave;
+	}
+	current->thread.used_vr = ext_bkp.used_vr;
+#endif
+
+#ifdef CONFIG_VSX
+	current->thread.used_vsr = ext_bkp.used_vsr;
+#endif
+
 	return ret;
 }
 
-- 
1.6.5.3

