Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbZHPJg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbZHPJg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbZHPJfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:35:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45353 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754042AbZHPJaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/48] KVM: SVM: use explicit 64bit storage for sysenter values
Date: Sun, 16 Aug 2009 12:29:38 +0300
Message-Id: <1250415008-17175-19-git-send-email-avi@redhat.com>
In-Reply-To: <1250415008-17175-1-git-send-email-avi@redhat.com>
References: <1250415008-17175-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

Since AMD does not support sysenter in 64bit mode, the VMCB fields storing
the MSRs are truncated to 32bit upon VMRUN/#VMEXIT. So store the values
in a separate 64bit storage to avoid truncation.

Signed-off-by: Christoph Egger <christoph.egger@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/kvm_svm.h |    3 +++
 arch/x86/kvm/svm.c     |   12 ++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/kvm_svm.h b/arch/x86/kvm/kvm_svm.h
index ed66e4c..39fddc0 100644
--- a/arch/x86/kvm/kvm_svm.h
+++ b/arch/x86/kvm/kvm_svm.h
@@ -27,6 +27,9 @@ struct vcpu_svm {
 	unsigned long vmcb_pa;
 	struct svm_cpu_data *svm_data;
 	uint64_t asid_generation;
+	uint64_t sysenter_cs;
+	uint64_t sysenter_esp;
+	uint64_t sysenter_eip;
 
 	u64 next_rip;
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 48b22c9..df6e7fb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1978,13 +1978,13 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
-		*data = svm->vmcb->save.sysenter_cs;
+		*data = svm->sysenter_cs;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-		*data = svm->vmcb->save.sysenter_eip;
+		*data = svm->sysenter_eip;
 		break;
 	case MSR_IA32_SYSENTER_ESP:
-		*data = svm->vmcb->save.sysenter_esp;
+		*data = svm->sysenter_esp;
 		break;
 	/* Nobody will change the following 5 values in the VMCB so
 	   we can safely return them on rdmsr. They will always be 0
@@ -2068,13 +2068,13 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
-		svm->vmcb->save.sysenter_cs = data;
+		svm->sysenter_cs = data;
 		break;
 	case MSR_IA32_SYSENTER_EIP:
-		svm->vmcb->save.sysenter_eip = data;
+		svm->sysenter_eip = data;
 		break;
 	case MSR_IA32_SYSENTER_ESP:
-		svm->vmcb->save.sysenter_esp = data;
+		svm->sysenter_esp = data;
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!svm_has(SVM_FEATURE_LBRV)) {
-- 
1.6.3.3

