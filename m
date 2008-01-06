Return-Path: <linux-kernel-owner+w=401wt.eu-S1760549AbYAFOtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760549AbYAFOtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758548AbYAFOkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:19 -0500
Received: from il.qumranet.com ([82.166.9.18]:46652 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756917AbYAFOjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:49 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 26/33] KVM: Disable vapic support on Intel machines with FlexPriority
Date: Sun,  6 Jan 2008 16:39:32 +0200
Message-Id: <1199630379-28638-27-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FlexPriority accelerates the tpr without any patching.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c         |    6 ++++++
 arch/x86/kvm/vmx.c         |    3 ++-
 arch/x86/kvm/x86.c         |    4 +++-
 include/asm-x86/kvm_host.h |    1 +
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 745b1ec..11e5baf 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1653,6 +1653,11 @@ static void svm_check_processor_compat(void *rtn)
 	*(int *)rtn = 0;
 }
 
+static bool svm_cpu_has_accelerated_tpr(void)
+{
+	return false;
+}
+
 static struct kvm_x86_ops svm_x86_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -1661,6 +1666,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.check_processor_compatibility = svm_check_processor_compat,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
+	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
 
 	.vcpu_create = svm_create_vcpu,
 	.vcpu_free = svm_free_vcpu,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 20c0f5e..fa72f72 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -192,7 +192,7 @@ static inline int cpu_has_secondary_exec_ctrls(void)
 		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
 }
 
-static inline int cpu_has_vmx_virtualize_apic_accesses(void)
+static inline bool cpu_has_vmx_virtualize_apic_accesses(void)
 {
 	return (vmcs_config.cpu_based_2nd_exec_ctrl &
 		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
@@ -2564,6 +2564,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
+	.cpu_has_accelerated_tpr = cpu_has_vmx_virtualize_apic_accesses,
 
 	.vcpu_create = vmx_create_vcpu,
 	.vcpu_free = vmx_free_vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e7eac27..1f48ec8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -684,9 +684,11 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SET_TSS_ADDR:
 	case KVM_CAP_EXT_CPUID:
-	case KVM_CAP_VAPIC:
 		r = 1;
 		break;
+	case KVM_CAP_VAPIC:
+		r = !kvm_x86_ops->cpu_has_accelerated_tpr();
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 6e649af..44b8925 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -329,6 +329,7 @@ struct kvm_x86_ops {
 	void (*check_processor_compatibility)(void *rtn);
 	int (*hardware_setup)(void);               /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
+	bool (*cpu_has_accelerated_tpr)(void);
 
 	/* Create, but do not attach this VCPU */
 	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned id);
-- 
1.5.3.7

