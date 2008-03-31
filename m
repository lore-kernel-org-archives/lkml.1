Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYCaOm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYCaOm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYCaOhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:40 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51308
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbYCaOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/40] KVM: align valid EFER bits with the features of the host system
Date: Mon, 31 Mar 2008 17:37:01 +0300
Message-Id: <1206974244-9716-18-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch aligns the bits the guest can set in the EFER register with the
features in the host processor. Currently it lets EFER.NX disabled if the
processor does not support it and enables EFER.LME and EFER.LMA only for KVM on
64 bit hosts.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |    3 +++
 arch/x86/kvm/vmx.c |    4 ++++
 arch/x86/kvm/x86.c |   10 +++++++++-
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1a582f1..ff3bc74 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -403,6 +403,9 @@ static __init int svm_hardware_setup(void)
 	set_msr_interception(msrpm_va, MSR_IA32_SYSENTER_ESP, 1, 1);
 	set_msr_interception(msrpm_va, MSR_IA32_SYSENTER_EIP, 1, 1);
 
+	if (boot_cpu_has(X86_FEATURE_NX))
+		kvm_enable_efer_bits(EFER_NX);
+
 	for_each_online_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1157e8a..a509910 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1117,6 +1117,10 @@ static __init int hardware_setup(void)
 {
 	if (setup_vmcs_config(&vmcs_config) < 0)
 		return -EIO;
+
+	if (boot_cpu_has(X86_FEATURE_NX))
+		kvm_enable_efer_bits(EFER_NX);
+
 	return alloc_kvm_area();
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ec9265b..db16f23 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -41,7 +41,15 @@
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_VMXE))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
-static u64 __read_mostly efer_reserved_bits = 0xfffffffffffff2fe;
+/* EFER defaults:
+ * - enable syscall per default because its emulated by KVM
+ * - enable LME and LMA per default on 64 bit KVM
+ */
+#ifdef CONFIG_X86_64
+static u64 __read_mostly efer_reserved_bits = 0xfffffffffffffafeULL;
+#else
+static u64 __read_mostly efer_reserved_bits = 0xfffffffffffffffeULL;
+#endif
 
 #define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
 #define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
-- 
1.5.4.5

