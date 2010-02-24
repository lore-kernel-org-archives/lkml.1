Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab0BXR7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 12:59:41 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:19123
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757344Ab0BXR7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:59:38 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYCXZ0-01-2R5-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/11] KVM: SVM: Implement emulation of vm_cr msr
Date: Wed, 24 Feb 2010 18:59:15 +0100
Message-ID: <1267034360-5907-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Feb 2010 17:59:23.0668 (UTC) FILETIME=[18E3FD40:01CAB57B]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the emulation of the vm_cr msr for
nested svm.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/svm.h |    4 ++++
 arch/x86/kvm/svm.c         |   29 ++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 38638cd..b26a38d 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -115,6 +115,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
 #define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
 
+#define SVM_VM_CR_VALID_MASK	0x001fULL
+#define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
+#define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
+
 struct __attribute__ ((__packed__)) vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6b7590a..2450a7c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -70,6 +70,7 @@ struct kvm_vcpu;
 struct nested_state {
 	struct vmcb *hsave;
 	u64 hsave_msr;
+	u64 vm_cr_msr;
 	u64 vmcb;
 
 	/* These are the merged vectors */
@@ -2273,7 +2274,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 		*data = svm->nested.hsave_msr;
 		break;
 	case MSR_VM_CR:
-		*data = 0;
+		*data = svm->nested.vm_cr_msr;
 		break;
 	case MSR_IA32_UCODE_REV:
 		*data = 0x01000065;
@@ -2303,6 +2304,31 @@ static int rdmsr_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int svm_set_vm_cr(struct kvm_vcpu *vcpu, u64 data)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	int svm_dis, chg_mask;
+
+	if (data & ~SVM_VM_CR_VALID_MASK)
+		return 1;
+
+	chg_mask = SVM_VM_CR_VALID_MASK;
+
+	if (svm->nested.vm_cr_msr & SVM_VM_CR_SVM_DIS_MASK)
+		chg_mask &= ~(SVM_VM_CR_SVM_LOCK_MASK | SVM_VM_CR_SVM_DIS_MASK);
+
+	svm->nested.vm_cr_msr &= ~chg_mask;
+	svm->nested.vm_cr_msr |= (data & chg_mask);
+
+	svm_dis = svm->nested.vm_cr_msr & SVM_VM_CR_SVM_DIS_MASK;
+
+	/* check for svm_disable while efer.svme is set */
+	if (svm_dis && (vcpu->arch.efer & EFER_SVME))
+		return 1;
+
+	return 0;
+}
+
 static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -2369,6 +2395,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 		svm->nested.hsave_msr = data;
 		break;
 	case MSR_VM_CR:
+		return svm_set_vm_cr(vcpu, data);
 	case MSR_VM_IGNNE:
 		pr_unimpl(vcpu, "unimplemented wrmsr: 0x%x data 0x%llx\n", ecx, data);
 		break;
-- 
1.7.0


