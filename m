Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbZHSNM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbZHSNM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZHSNMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:12:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50552 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751898AbZHSNCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:46 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/47] KVM: Move performance counter MSR access interception to generic x86 path
Date: Wed, 19 Aug 2009 16:02:04 +0300
Message-Id: <1250686963-8357-9-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

The performance counter MSRs are different for AMD and Intel CPUs and they
are chosen mainly by the CPUID vendor string. This patch catches writes to
all addresses (regardless of VMX/SVM path) and handles them in the generic
MSR handler routine. Writing a 0 into the event select register is something
we perfectly emulate ;-), so don't print out a warning to dmesg in this
case.
This fixes booting a 64bit Windows guest with an AMD CPUID on an Intel host.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   16 ----------------
 arch/x86/kvm/vmx.c |   12 ------------
 arch/x86/kvm/x86.c |   30 ++++++++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a7fa87b..e1dd47d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2143,22 +2143,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 		else
 			svm_disable_lbrv(svm);
 		break;
-	case MSR_K7_EVNTSEL0:
-	case MSR_K7_EVNTSEL1:
-	case MSR_K7_EVNTSEL2:
-	case MSR_K7_EVNTSEL3:
-	case MSR_K7_PERFCTR0:
-	case MSR_K7_PERFCTR1:
-	case MSR_K7_PERFCTR2:
-	case MSR_K7_PERFCTR3:
-		/*
-		 * Just discard all writes to the performance counters; this
-		 * should keep both older linux and windows 64-bit guests
-		 * happy
-		 */
-		pr_unimpl(vcpu, "unimplemented perfctr wrmsr: 0x%x data 0x%llx\n", ecx, data);
-
-		break;
 	case MSR_VM_HSAVE_PA:
 		svm->hsave_msr = data;
 		break;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c08bb4c..6ee9292 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1025,18 +1025,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		rdtscll(host_tsc);
 		guest_write_tsc(data, host_tsc);
 		break;
-	case MSR_P6_PERFCTR0:
-	case MSR_P6_PERFCTR1:
-	case MSR_P6_EVNTSEL0:
-	case MSR_P6_EVNTSEL1:
-		/*
-		 * Just discard all writes to the performance counters; this
-		 * should keep both older linux and windows 64-bit guests
-		 * happy
-		 */
-		pr_unimpl(vcpu, "unimplemented perfctr wrmsr: 0x%x data 0x%llx\n", msr_index, data);
-
-		break;
 	case MSR_IA32_CR_PAT:
 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
 			vmcs_write64(GUEST_IA32_PAT, data);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 89862a8..30492f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -886,6 +886,36 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MC0_CTL + 4 * KVM_MAX_MCE_BANKS - 1:
 		return set_msr_mce(vcpu, msr, data);
+
+	/* Performance counters are not protected by a CPUID bit,
+	 * so we should check all of them in the generic path for the sake of
+	 * cross vendor migration.
+	 * Writing a zero into the event select MSRs disables them,
+	 * which we perfectly emulate ;-). Any other value should be at least
+	 * reported, some guests depend on them.
+	 */
+	case MSR_P6_EVNTSEL0:
+	case MSR_P6_EVNTSEL1:
+	case MSR_K7_EVNTSEL0:
+	case MSR_K7_EVNTSEL1:
+	case MSR_K7_EVNTSEL2:
+	case MSR_K7_EVNTSEL3:
+		if (data != 0)
+			pr_unimpl(vcpu, "unimplemented perfctr wrmsr: "
+				"0x%x data 0x%llx\n", msr, data);
+		break;
+	/* at least RHEL 4 unconditionally writes to the perfctr registers,
+	 * so we ignore writes to make it happy.
+	 */
+	case MSR_P6_PERFCTR0:
+	case MSR_P6_PERFCTR1:
+	case MSR_K7_PERFCTR0:
+	case MSR_K7_PERFCTR1:
+	case MSR_K7_PERFCTR2:
+	case MSR_K7_PERFCTR3:
+		pr_unimpl(vcpu, "unimplemented perfctr wrmsr: "
+			"0x%x data 0x%llx\n", msr, data);
+		break;
 	default:
 		pr_unimpl(vcpu, "unhandled wrmsr: 0x%x data %llx\n", msr, data);
 		return 1;
-- 
1.6.3.3

