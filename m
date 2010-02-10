Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab0BJRbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:31:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab0BJRXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/40] KVM: Add cpuid_update() callback to kvm_x86_ops
Date: Wed, 10 Feb 2010 19:22:42 +0200
Message-Id: <1265822589-11155-14-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Sometime, we need to adjust some state in order to reflect guest CPUID
setting, e.g. if we don't expose rdtscp to guest, we won't want to enable
it on hardware. cpuid_update() is introduced for this purpose.

Also export kvm_find_cpuid_entry() for later use.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/svm.c              |    6 ++++++
 arch/x86/kvm/vmx.c              |    6 ++++++
 arch/x86/kvm/x86.c              |    3 +++
 4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e9f4f12..7ff0ea3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -459,6 +459,7 @@ struct kvm_x86_ops {
 	int (*hardware_setup)(void);               /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
 	bool (*cpu_has_accelerated_tpr)(void);
+	void (*cpuid_update)(struct kvm_vcpu *vcpu);
 
 	/* Create, but do not attach this VCPU */
 	struct kvm_vcpu *(*vcpu_create)(struct kvm *kvm, unsigned id);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1d9b338..41777e6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2852,6 +2852,10 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return 0;
 }
 
+static void svm_cpuid_update(struct kvm_vcpu *vcpu)
+{
+}
+
 static const struct trace_print_flags svm_exit_reasons_str[] = {
 	{ SVM_EXIT_READ_CR0,           		"read_cr0" },
 	{ SVM_EXIT_READ_CR3,	      		"read_cr3" },
@@ -2976,6 +2980,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 
 	.exit_reasons_str = svm_exit_reasons_str,
 	.gb_page_enable = svm_gb_page_enable,
+
+	.cpuid_update = svm_cpuid_update,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f8f2fdc..75e8931 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3988,6 +3988,10 @@ static bool vmx_gb_page_enable(void)
 	return false;
 }
 
+static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
+{
+}
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -4052,6 +4056,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 	.exit_reasons_str = vmx_exit_reasons_str,
 	.gb_page_enable = vmx_gb_page_enable,
+
+	.cpuid_update = vmx_cpuid_update,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a2c8cf2..153f4a1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1575,6 +1575,7 @@ static int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	cpuid_fix_nx_cap(vcpu);
 	r = 0;
 	kvm_apic_set_version(vcpu);
+	kvm_x86_ops->cpuid_update(vcpu);
 
 out_free:
 	vfree(cpuid_entries);
@@ -1597,6 +1598,7 @@ static int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		goto out;
 	vcpu->arch.cpuid_nent = cpuid->nent;
 	kvm_apic_set_version(vcpu);
+	kvm_x86_ops->cpuid_update(vcpu);
 	return 0;
 
 out:
@@ -3734,6 +3736,7 @@ struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 	}
 	return best;
 }
+EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 
 int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
 {
-- 
1.6.5.3

