Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbZHSNIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbZHSNIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZHSNIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:08:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50573 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751994AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 35/47] KVM: ignore AMDs HWCR register access to set the FFDIS bit
Date: Wed, 19 Aug 2009 16:02:31 +0300
Message-Id: <1250686963-8357-36-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

Linux tries to disable the flush filter on all AMD K8 CPUs. Since KVM
does not handle the needed MSR, the injected #GP will panic the Linux
kernel. Ignore setting of the HWCR.FFDIS bit in this MSR to let Linux
boot with an AMD K8 family guest CPU.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    1 -
 arch/x86/kvm/x86.c |    8 ++++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 081d00a..d664157 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2138,7 +2138,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 		break;
 	case MSR_VM_CR:
 	case MSR_VM_IGNNE:
-	case MSR_K7_HWCR:
 		pr_unimpl(vcpu, "unimplemented wrmsr: 0x%x data 0x%llx\n", ecx, data);
 		break;
 	default:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e9b0982..cae5b12 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -833,6 +833,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	case MSR_EFER:
 		set_efer(vcpu, data);
 		break;
+	case MSR_K7_HWCR:
+		data &= ~(u64)0x40;	/* ignore flush filter disable */
+		if (data != 0) {
+			pr_unimpl(vcpu, "unimplemented HWCR wrmsr: 0x%llx\n",
+				data);
+			return 1;
+		}
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!data) {
 			/* We support the non-activated case already */
-- 
1.6.3.3

