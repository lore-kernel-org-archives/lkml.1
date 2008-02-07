Return-Path: <linux-kernel-owner+w=401wt.eu-S1760688AbYBGMtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688AbYBGMtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbYBGMsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:48:40 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:1587 "EHLO
	outbound1-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896AbYBGMs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:48:26 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 7/8] MMU: add TDP support to the KVM MMU
Date: Thu,  7 Feb 2008 13:47:44 +0100
Message-ID: <1202388465-8657-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
References: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Feb 2008 12:47:45.0767 (UTC)
 FILETIME=[A315B770:01C86987]
MIME-Version: 1.0
X-WSS-ID: 6BB4219A0QK10781145-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the changes to the KVM MMU necessary for support of the
Nested Paging feature in AMD Barcelona and Phenom Processors.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu.h |    6 ++++
 2 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5e76963..5304d55 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1081,6 +1081,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 	int i;
 	gfn_t root_gfn;
 	struct kvm_mmu_page *sp;
+	int metaphysical = 0;
 
 	root_gfn = vcpu->arch.cr3 >> PAGE_SHIFT;
 
@@ -1089,14 +1090,20 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->arch.mmu.root_hpa;
 
 		ASSERT(!VALID_PAGE(root));
+		if (tdp_enabled)
+			metaphysical = 1;
 		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
-				      PT64_ROOT_LEVEL, 0, ACC_ALL, NULL, NULL);
+				      PT64_ROOT_LEVEL, metaphysical,
+				      ACC_ALL, NULL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
 		vcpu->arch.mmu.root_hpa = root;
 		return;
 	}
 #endif
+	metaphysical = !is_paging(vcpu);
+	if (tdp_enabled)
+		metaphysical = 1;
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu.pae_root[i];
 
@@ -1110,7 +1117,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		} else if (vcpu->arch.mmu.root_level == 0)
 			root_gfn = 0;
 		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
-				      PT32_ROOT_LEVEL, !is_paging(vcpu),
+				      PT32_ROOT_LEVEL, metaphysical,
 				      ACC_ALL, NULL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
@@ -1144,6 +1151,36 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 			     error_code & PFERR_WRITE_MASK, gfn);
 }
 
+static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
+				u32 error_code)
+{
+	struct page *page;
+	int r;
+
+	ASSERT(vcpu);
+	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
+
+	r = mmu_topup_memory_caches(vcpu);
+	if (r)
+		return r;
+
+	down_read(&current->mm->mmap_sem);
+	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+	if (is_error_page(page)) {
+		kvm_release_page_clean(page);
+		up_read(&current->mm->mmap_sem);
+		return 1;
+	}
+	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_free_some_pages(vcpu);
+	r = __direct_map(vcpu, gpa, error_code & PFERR_WRITE_MASK,
+			 gpa >> PAGE_SHIFT, page, TDP_ROOT_LEVEL);
+	spin_unlock(&vcpu->kvm->mmu_lock);
+	up_read(&current->mm->mmap_sem);
+
+	return r;
+}
+
 static void nonpaging_free(struct kvm_vcpu *vcpu)
 {
 	mmu_free_roots(vcpu);
@@ -1237,7 +1274,35 @@ static int paging32E_init_context(struct kvm_vcpu *vcpu)
 	return paging64_init_context_common(vcpu, PT32E_ROOT_LEVEL);
 }
 
-static int init_kvm_mmu(struct kvm_vcpu *vcpu)
+static int init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_mmu *context = &vcpu->arch.mmu;
+
+	context->new_cr3 = nonpaging_new_cr3;
+	context->page_fault = tdp_page_fault;
+	context->free = nonpaging_free;
+	context->prefetch_page = nonpaging_prefetch_page;
+	context->shadow_root_level = TDP_ROOT_LEVEL;
+	context->root_hpa = INVALID_PAGE;
+
+	if (!is_paging(vcpu)) {
+		context->gva_to_gpa = nonpaging_gva_to_gpa;
+		context->root_level = 0;
+	} else if (is_long_mode(vcpu)) {
+		context->gva_to_gpa = paging64_gva_to_gpa;
+		context->root_level = PT64_ROOT_LEVEL;
+	} else if (is_pae(vcpu)) {
+		context->gva_to_gpa = paging64_gva_to_gpa;
+		context->root_level = PT32E_ROOT_LEVEL;
+	} else {
+		context->gva_to_gpa = paging32_gva_to_gpa;
+		context->root_level = PT32_ROOT_LEVEL;
+	}
+
+	return 0;
+}
+
+static int init_kvm_softmmu(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
@@ -1252,6 +1317,14 @@ static int init_kvm_mmu(struct kvm_vcpu *vcpu)
 		return paging32_init_context(vcpu);
 }
 
+static int init_kvm_mmu(struct kvm_vcpu *vcpu)
+{
+	if (tdp_enabled)
+		return init_kvm_tdp_mmu(vcpu);
+	else
+		return init_kvm_softmmu(vcpu);
+}
+
 static void destroy_kvm_mmu(struct kvm_vcpu *vcpu)
 {
 	ASSERT(vcpu);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 1fce19e..e64e9f5 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -3,6 +3,12 @@
 
 #include <linux/kvm_host.h>
 
+#ifdef CONFIG_X86_64
+#define TDP_ROOT_LEVEL PT64_ROOT_LEVEL
+#else
+#define TDP_ROOT_LEVEL PT32E_ROOT_LEVEL
+#endif
+
 static inline void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
 	if (unlikely(vcpu->kvm->arch.n_free_mmu_pages < KVM_MIN_FREE_MMU_PAGES))
-- 
1.5.3.7



