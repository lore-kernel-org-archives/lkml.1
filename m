Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYI1Pqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYI1Pqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYI1PpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50836 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbYI1PpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 04/25] KVM: Add statistics for guest irq injections
Date: Sun, 28 Sep 2008 18:44:40 +0300
Message-Id: <1222616701-1206-5-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

These can help show whether a guest is making progress or not.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c         |    1 +
 arch/x86/kvm/vmx.c         |    1 +
 arch/x86/kvm/x86.c         |    1 +
 include/asm-x86/kvm_host.h |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6022888..9b54550 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1519,6 +1519,7 @@ static inline void svm_inject_irq(struct vcpu_svm *svm, int irq)
 
 	KVMTRACE_1D(INJ_VIRQ, &svm->vcpu, (u32)irq, handler);
 
+	++svm->vcpu.stat.irq_injections;
 	control = &svm->vmcb->control;
 	control->int_vector = irq;
 	control->int_ctl &= ~V_INTR_PRIO_MASK;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 71e57ae..e7e8c86 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2341,6 +2341,7 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu, int irq)
 
 	KVMTRACE_1D(INJ_VIRQ, vcpu, (u32)irq, handler);
 
+	++vcpu->stat.irq_injections;
 	if (vcpu->arch.rmode.active) {
 		vmx->rmode.irq.pending = true;
 		vmx->rmode.irq.vector = irq;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e3b8966..3f3cb71 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -92,6 +92,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	{ "fpu_reload", VCPU_STAT(fpu_reload) },
 	{ "insn_emulation", VCPU_STAT(insn_emulation) },
 	{ "insn_emulation_fail", VCPU_STAT(insn_emulation_fail) },
+	{ "irq_injections", VCPU_STAT(irq_injections) },
 	{ "mmu_shadow_zapped", VM_STAT(mmu_shadow_zapped) },
 	{ "mmu_pte_write", VM_STAT(mmu_pte_write) },
 	{ "mmu_pte_updated", VM_STAT(mmu_pte_updated) },
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 982b6b2..815efc3 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -413,6 +413,7 @@ struct kvm_vcpu_stat {
 	u32 insn_emulation;
 	u32 insn_emulation_fail;
 	u32 hypercalls;
+	u32 irq_injections;
 };
 
 struct descriptor_table {
-- 
1.6.0.1

