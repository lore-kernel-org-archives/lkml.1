Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab0CCTPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:15:16 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:39841
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754888Ab0CCTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:13:24 -0500
X-SpamScore: 3
X-BigFish: VPS3(zz936eMab9bhab78ozz1202hzzz32i6bh2a8h87h43h66h)
X-Spam-TCS-SCL: 5:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ017-01-LLZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/18] KVM: X86: Introduce a tdp_set_cr3 function
Date: Wed, 3 Mar 2010 20:12:07 +0100
Message-ID: <1267643541-451-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0548 (UTC) FILETIME=[7FB80F40:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a special set_tdp_cr3 function pointer
in kvm_x86_ops which is only used for tpd enabled mmu
contexts. This allows to remove some hacks from svm code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/mmu.c              |    2 +-
 arch/x86/kvm/svm.c              |   23 ++++++++++++++---------
 arch/x86/kvm/vmx.c              |    3 +++
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 887a1f7..1bf8501 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -537,6 +537,7 @@ struct kvm_x86_ops {
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 	int (*get_lpage_level)(void);
 	bool (*rdtscp_supported)(void);
+	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
 	const struct trace_print_flags *exit_reasons_str;
 };
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ec3da11..84e3209 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2398,7 +2398,7 @@ static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
 	context->root_hpa = INVALID_PAGE;
 	vcpu->arch.mmu.tdp_enabled = true;
-	vcpu->arch.mmu.set_cr3 = kvm_x86_ops->set_cr3;
+	vcpu->arch.mmu.set_cr3 = kvm_x86_ops->set_tdp_cr3;
 
 	if (!is_paging(vcpu)) {
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 15b8852..a7a76f5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3044,9 +3044,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	gs_selector = kvm_read_gs();
 	ldt_selector = kvm_read_ldt();
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
-	/* required for live migration with NPT */
-	if (npt_enabled)
-		svm->vmcb->save.cr3 = vcpu->arch.cr3;
 
 	clgi();
 
@@ -3155,16 +3152,22 @@ static void svm_set_cr3(struct kvm_vcpu *vcpu, unsigned long root)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (npt_enabled) {
-		svm->vmcb->control.nested_cr3 = root;
-		force_new_asid(vcpu);
-		return;
-	}
-
 	svm->vmcb->save.cr3 = root;
 	force_new_asid(vcpu);
 }
 
+static void set_tdp_cr3(struct kvm_vcpu *vcpu, unsigned long root)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->control.nested_cr3 = root;
+
+	/* Also sync guest cr3 here in case we live migrate */
+	svm->vmcb->save.cr3 = vcpu->arch.cr3;
+
+	force_new_asid(vcpu);
+}
+
 static int is_disabled(void)
 {
 	u64 vm_cr;
@@ -3361,6 +3364,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.cpuid_update = svm_cpuid_update,
 
 	.rdtscp_supported = svm_rdtscp_supported,
+
+	.set_tdp_cr3 = set_tdp_cr3,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ae3217d..530d14d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4212,11 +4212,14 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.get_mt_mask = vmx_get_mt_mask,
 
 	.exit_reasons_str = vmx_exit_reasons_str,
+
 	.get_lpage_level = vmx_get_lpage_level,
 
 	.cpuid_update = vmx_cpuid_update,
 
 	.rdtscp_supported = vmx_rdtscp_supported,
+
+	.set_tdp_cr3 = vmx_set_cr3,
 };
 
 static int __init vmx_init(void)
-- 
1.7.0


