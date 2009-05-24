Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbZEXPxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbZEXPxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbZEXPvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:51:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41856 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 36/45] KVM: Unprotect a page if #PF happens during NMI injection.
Date: Sun, 24 May 2009 18:50:21 +0300
Message-Id: <1243180230-2480-37-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

It is done for exception and interrupt already.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    3 +--
 arch/x86/kvm/vmx.c |    2 +-
 arch/x86/kvm/x86.h |    6 ++++++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8b5ffbd..ac3d5ba 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1122,8 +1122,7 @@ static int pf_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 	if (npt_enabled)
 		svm_flush_tlb(&svm->vcpu);
 	else {
-		if (svm->vcpu.arch.interrupt.pending ||
-				svm->vcpu.arch.exception.pending)
+		if (kvm_event_needs_reinjection(&svm->vcpu))
 			kvm_mmu_unprotect_page_virt(&svm->vcpu, fault_address);
 	}
 	return kvm_mmu_page_fault(&svm->vcpu, fault_address, error_code);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f3ab27b..8981654 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2615,7 +2615,7 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		cr2 = vmcs_readl(EXIT_QUALIFICATION);
 		KVMTRACE_3D(PAGE_FAULT, vcpu, error_code, (u32)cr2,
 			    (u32)((u64)cr2 >> 32), handler);
-		if (vcpu->arch.interrupt.pending || vcpu->arch.exception.pending)
+		if (kvm_event_needs_reinjection(vcpu))
 			kvm_mmu_unprotect_page_virt(vcpu, cr2);
 		return kvm_mmu_page_fault(vcpu, cr2, error_code);
 	}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 39350b2..21203d4 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -30,4 +30,10 @@ static inline u8 kvm_pop_irq(struct kvm_vcpu *vcpu)
 		clear_bit(word_index, &vcpu->arch.irq_summary);
 	return irq;
 }
+
+static inline bool kvm_event_needs_reinjection(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.exception.pending || vcpu->arch.interrupt.pending ||
+		vcpu->arch.nmi_injected;
+}
 #endif
-- 
1.6.0.6

