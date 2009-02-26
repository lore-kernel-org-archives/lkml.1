Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbZBZOYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbZBZOYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbZBZOQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:16:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43067 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbZBZOPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:42 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: [PATCH 05/40] KVM: SVM: Implement hsave
Date: Thu, 26 Feb 2009 16:14:55 +0200
Message-Id: <1235657730-27683-6-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Implement the hsave MSR, that gives the VCPU a GPA to save the
old guest state in.

v2 allows userspace to save/restore hsave
v4 dummys out the hsave MSR, so we use a host page
v6 remembers the guest's hsave and exports the MSR

Acked-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/kvm_svm.h |    2 ++
 arch/x86/kvm/svm.c     |   13 +++++++++++++
 arch/x86/kvm/x86.c     |    2 +-
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/kvm_svm.h b/arch/x86/kvm/kvm_svm.h
index 8e5ee99..a0877ca 100644
--- a/arch/x86/kvm/kvm_svm.h
+++ b/arch/x86/kvm/kvm_svm.h
@@ -41,6 +41,8 @@ struct vcpu_svm {
 	unsigned long host_dr7;
 
 	u32 *msrpm;
+	struct vmcb *hsave;
+	u64 hsave_msr;
 };
 
 #endif
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 79cc06b..59aaff1 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -626,6 +626,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	struct vcpu_svm *svm;
 	struct page *page;
 	struct page *msrpm_pages;
+	struct page *hsave_page;
 	int err;
 
 	svm = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
@@ -651,6 +652,11 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	svm->msrpm = page_address(msrpm_pages);
 	svm_vcpu_init_msrpm(svm->msrpm);
 
+	hsave_page = alloc_page(GFP_KERNEL);
+	if (!hsave_page)
+		goto uninit;
+	svm->hsave = page_address(hsave_page);
+
 	svm->vmcb = page_address(page);
 	clear_page(svm->vmcb);
 	svm->vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
@@ -680,6 +686,7 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 
 	__free_page(pfn_to_page(svm->vmcb_pa >> PAGE_SHIFT));
 	__free_pages(virt_to_page(svm->msrpm), MSRPM_ALLOC_ORDER);
+	__free_page(virt_to_page(svm->hsave));
 	kvm_vcpu_uninit(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, svm);
 }
@@ -1377,6 +1384,9 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 	case MSR_IA32_LASTINTTOIP:
 		*data = svm->vmcb->save.last_excp_to;
 		break;
+	case MSR_VM_HSAVE_PA:
+		*data = svm->hsave_msr;
+		break;
 	default:
 		return kvm_get_msr_common(vcpu, ecx, data);
 	}
@@ -1471,6 +1481,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 		pr_unimpl(vcpu, "unimplemented perfctr wrmsr: 0x%x data 0x%llx\n", ecx, data);
 
 		break;
+	case MSR_VM_HSAVE_PA:
+		svm->hsave_msr = data;
+		break;
 	default:
 		return kvm_set_msr_common(vcpu, ecx, data);
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 758b7a1..99165a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -456,7 +456,7 @@ static u32 msrs_to_save[] = {
 	MSR_CSTAR, MSR_KERNEL_GS_BASE, MSR_SYSCALL_MASK, MSR_LSTAR,
 #endif
 	MSR_IA32_TIME_STAMP_COUNTER, MSR_KVM_SYSTEM_TIME, MSR_KVM_WALL_CLOCK,
-	MSR_IA32_PERF_STATUS, MSR_IA32_CR_PAT
+	MSR_IA32_PERF_STATUS, MSR_IA32_CR_PAT, MSR_VM_HSAVE_PA
 };
 
 static unsigned num_msrs_to_save;
-- 
1.6.0.6

