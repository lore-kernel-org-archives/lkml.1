Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbYCaOrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbYCaOrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYCaOht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:49 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51319
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbYCaOhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:35 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 31/40] KVM: SVM: enable LBR virtualization
Date: Mon, 31 Mar 2008 17:37:15 +0300
Message-Id: <1206974244-9716-32-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch implements the Last Branch Record Virtualization (LBRV) feature of
the AMD Barcelona and Phenom processors into the kvm-amd module. It will only
be enabled if the guest enables last branch recording in the DEBUG_CTL MSR. So
there is no increased world switch overhead when the guest doesn't use these
MSRs.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 281a2ff..7d73e93 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -47,6 +47,8 @@ MODULE_LICENSE("GPL");
 #define SVM_FEATURE_LBRV (1 << 1)
 #define SVM_DEATURE_SVML (1 << 2)
 
+#define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
+
 /* enable NPT for AMD64 and X86 with PAE */
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 static bool npt_enabled = true;
@@ -387,6 +389,28 @@ static void svm_vcpu_init_msrpm(u32 *msrpm)
 	set_msr_interception(msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
 }
 
+static void svm_enable_lbrv(struct vcpu_svm *svm)
+{
+	u32 *msrpm = svm->msrpm;
+
+	svm->vmcb->control.lbr_ctl = 1;
+	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
+	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
+	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
+	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
+}
+
+static void svm_disable_lbrv(struct vcpu_svm *svm)
+{
+	u32 *msrpm = svm->msrpm;
+
+	svm->vmcb->control.lbr_ctl = 0;
+	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
+	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
+	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
+	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
+}
+
 static __init int svm_hardware_setup(void)
 {
 	int cpu;
@@ -1231,8 +1255,19 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 		svm->vmcb->save.sysenter_esp = data;
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
-		pr_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
-				__FUNCTION__, data);
+		if (!svm_has(SVM_FEATURE_LBRV)) {
+			pr_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTL 0x%llx, nop\n",
+					__FUNCTION__, data);
+			break;
+		}
+		if (data & DEBUGCTL_RESERVED_BITS)
+			return 1;
+
+		svm->vmcb->save.dbgctl = data;
+		if (data & (1ULL<<0))
+			svm_enable_lbrv(svm);
+		else
+			svm_disable_lbrv(svm);
 		break;
 	case MSR_K7_EVNTSEL0:
 	case MSR_K7_EVNTSEL1:
-- 
1.5.4.5

