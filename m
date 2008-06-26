Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYFZMbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYFZMbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYFZM2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:41 -0400
Received: from il.qumranet.com ([212.179.150.194]:32343 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbYFZM2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:35 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 07/50] KVM: SVM: add missing kvmtrace markers
Date: Thu, 26 Jun 2008 15:27:49 +0300
Message-Id: <1214483312-9265-8-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds the missing kvmtrace markers to the svm
module of kvm.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0eac1a5..8953292 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -949,7 +949,9 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *svm_data)
 
 static unsigned long svm_get_dr(struct kvm_vcpu *vcpu, int dr)
 {
-	return to_svm(vcpu)->db_regs[dr];
+	unsigned long val = to_svm(vcpu)->db_regs[dr];
+	KVMTRACE_2D(DR_READ, vcpu, (u32)dr, (u32)val, handler);
+	return val;
 }
 
 static void svm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long value,
@@ -1004,6 +1006,12 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 
 	fault_address  = svm->vmcb->control.exit_info_2;
 	error_code = svm->vmcb->control.exit_info_1;
+
+	if (!npt_enabled)
+		KVMTRACE_3D(PAGE_FAULT, &svm->vcpu, error_code,
+			    (u32)fault_address, (u32)(fault_address >> 32),
+			    handler);
+
 	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code);
 }
 
@@ -1083,12 +1091,14 @@ static int io_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 
 static int nmi_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
+	KVMTRACE_0D(NMI, &svm->vcpu, handler);
 	return 1;
 }
 
 static int intr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	++svm->vcpu.stat.irq_exits;
+	KVMTRACE_0D(INTR, &svm->vcpu, handler);
 	return 1;
 }
 
@@ -1230,6 +1240,9 @@ static int rdmsr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	if (svm_get_msr(&svm->vcpu, ecx, &data))
 		kvm_inject_gp(&svm->vcpu, 0);
 	else {
+		KVMTRACE_3D(MSR_READ, &svm->vcpu, ecx, (u32)data,
+			    (u32)(data >> 32), handler);
+
 		svm->vmcb->save.rax = data & 0xffffffff;
 		svm->vcpu.arch.regs[VCPU_REGS_RDX] = data >> 32;
 		svm->next_rip = svm->vmcb->save.rip + 2;
@@ -1315,6 +1328,10 @@ static int wrmsr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	u32 ecx = svm->vcpu.arch.regs[VCPU_REGS_RCX];
 	u64 data = (svm->vmcb->save.rax & -1u)
 		| ((u64)(svm->vcpu.arch.regs[VCPU_REGS_RDX] & -1u) << 32);
+
+	KVMTRACE_3D(MSR_WRITE, &svm->vcpu, ecx, (u32)data, (u32)(data >> 32),
+		    handler);
+
 	svm->next_rip = svm->vmcb->save.rip + 2;
 	if (svm_set_msr(&svm->vcpu, ecx, data))
 		kvm_inject_gp(&svm->vcpu, 0);
@@ -1334,6 +1351,8 @@ static int msr_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 static int interrupt_window_interception(struct vcpu_svm *svm,
 				   struct kvm_run *kvm_run)
 {
+	KVMTRACE_0D(PEND_INTR, &svm->vcpu, handler);
+
 	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
 	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
 	/*
@@ -1408,6 +1427,9 @@ static int handle_exit(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 exit_code = svm->vmcb->control.exit_code;
 
+	KVMTRACE_3D(VMEXIT, vcpu, exit_code, (u32)svm->vmcb->save.rip,
+		    (u32)((u64)svm->vmcb->save.rip >> 32), entryexit);
+
 	if (npt_enabled) {
 		int mmu_reload = 0;
 		if ((vcpu->arch.cr0 ^ svm->vmcb->save.cr0) & X86_CR0_PG) {
@@ -1481,6 +1503,8 @@ static inline void svm_inject_irq(struct vcpu_svm *svm, int irq)
 {
 	struct vmcb_control_area *control;
 
+	KVMTRACE_1D(INJ_VIRQ, &svm->vcpu, (u32)irq, handler);
+
 	control = &svm->vmcb->control;
 	control->int_vector = irq;
 	control->int_ctl &= ~V_INTR_PRIO_MASK;
-- 
1.5.6

