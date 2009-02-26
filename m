Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZBZOQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZBZOQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZBZOPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:15:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43047 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbZBZOPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: [PATCH 02/40] KVM: SVM: Move EFER and MSR constants to generic x86 code
Date: Thu, 26 Feb 2009 16:14:52 +0200
Message-Id: <1235657730-27683-3-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

MSR_EFER_SVME_MASK, MSR_VM_CR and MSR_VM_HSAVE_PA are set in KVM
specific headers. Linux does have nice header files to collect
EFER bits and MSR IDs, so IMHO we should put them there.

While at it, I also changed the naming scheme to match that
of the other defines.

(introduced in v6)

Acked-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h  |    1 +
 arch/x86/include/asm/msr-index.h |    7 +++++++
 arch/x86/include/asm/svm.h       |    4 ----
 arch/x86/include/asm/virtext.h   |    2 +-
 arch/x86/kvm/svm.c               |    6 +++---
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 730843d..2998efe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -22,6 +22,7 @@
 #include <asm/pvclock-abi.h>
 #include <asm/desc.h>
 #include <asm/mtrr.h>
+#include <asm/msr-index.h>
 
 #define KVM_MAX_VCPUS 16
 #define KVM_MEMORY_SLOTS 32
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 358acc5..46e9646 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -18,11 +18,13 @@
 #define _EFER_LME		8  /* Long mode enable */
 #define _EFER_LMA		10 /* Long mode active (read-only) */
 #define _EFER_NX		11 /* No execute enable */
+#define _EFER_SVME		12 /* Enable virtualization */
 
 #define EFER_SCE		(1<<_EFER_SCE)
 #define EFER_LME		(1<<_EFER_LME)
 #define EFER_LMA		(1<<_EFER_LMA)
 #define EFER_NX			(1<<_EFER_NX)
+#define EFER_SVME		(1<<_EFER_SVME)
 
 /* Intel MSRs. Some also available on other CPUs */
 #define MSR_IA32_PERFCTR0		0x000000c1
@@ -360,4 +362,9 @@
 #define MSR_IA32_VMX_PROCBASED_CTLS2    0x0000048b
 #define MSR_IA32_VMX_EPT_VPID_CAP       0x0000048c
 
+/* AMD-V MSRs */
+
+#define MSR_VM_CR                       0xc0010114
+#define MSR_VM_HSAVE_PA                 0xc0010117
+
 #endif /* _ASM_X86_MSR_INDEX_H */
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1b8afa7..82ada75 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -174,10 +174,6 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_CPUID_FEATURE_SHIFT 2
 #define SVM_CPUID_FUNC 0x8000000a
 
-#define MSR_EFER_SVME_MASK (1ULL << 12)
-#define MSR_VM_CR       0xc0010114
-#define MSR_VM_HSAVE_PA 0xc0010117ULL
-
 #define SVM_VM_CR_SVM_DISABLE 4
 
 #define SVM_SELECTOR_S_SHIFT 4
diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 5936362..e0f9aa1 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -118,7 +118,7 @@ static inline void cpu_svm_disable(void)
 
 	wrmsrl(MSR_VM_HSAVE_PA, 0);
 	rdmsrl(MSR_EFER, efer);
-	wrmsrl(MSR_EFER, efer & ~MSR_EFER_SVME_MASK);
+	wrmsrl(MSR_EFER, efer & ~EFER_SVME);
 }
 
 /** Makes sure SVM is disabled, if it is supported on the CPU
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 33407d9..e4eb3fd 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -198,7 +198,7 @@ static void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	if (!npt_enabled && !(efer & EFER_LMA))
 		efer &= ~EFER_LME;
 
-	to_svm(vcpu)->vmcb->save.efer = efer | MSR_EFER_SVME_MASK;
+	to_svm(vcpu)->vmcb->save.efer = efer | EFER_SVME;
 	vcpu->arch.shadow_efer = efer;
 }
 
@@ -292,7 +292,7 @@ static void svm_hardware_enable(void *garbage)
 	svm_data->tss_desc = (struct kvm_ldttss_desc *)(gdt + GDT_ENTRY_TSS);
 
 	rdmsrl(MSR_EFER, efer);
-	wrmsrl(MSR_EFER, efer | MSR_EFER_SVME_MASK);
+	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
 	wrmsrl(MSR_VM_HSAVE_PA,
 	       page_to_pfn(svm_data->save_area) << PAGE_SHIFT);
@@ -559,7 +559,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
 	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
 
-	save->efer = MSR_EFER_SVME_MASK;
+	save->efer = EFER_SVME;
 	save->dr6 = 0xffff0ff0;
 	save->dr7 = 0x400;
 	save->rflags = 2;
-- 
1.6.0.6

