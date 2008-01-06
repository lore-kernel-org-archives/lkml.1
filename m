Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbYAFOsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbYAFOsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758520AbYAFOkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:14 -0500
Received: from il.qumranet.com ([82.166.9.18]:46605 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904AbYAFOjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 31/33] KVM: MMU: Move kvm_free_some_pages() into critical section
Date: Sun,  6 Jan 2008 16:39:37 +0200
Message-Id: <1199630379-28638-32-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If some other cpu steals mmu pages between our check and an attempt to
allocate, we can run out of mmu pages.  Fix by moving the check into the
same critical section as the allocation.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |    9 +++------
 arch/x86/kvm/paging_tmpl.h |    1 +
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 834698d..c478ee2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -291,7 +291,6 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	kvm_mmu_free_some_pages(vcpu);
 	r = mmu_topup_memory_cache(&vcpu->arch.mmu_pte_chain_cache,
 				   pte_chain_cache, 4);
 	if (r)
@@ -569,9 +568,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu_page *sp;
 
-	if (!vcpu->kvm->arch.n_free_mmu_pages)
-		return NULL;
-
 	sp = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache, sizeof *sp);
 	sp->spt = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
 	sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache, PAGE_SIZE);
@@ -1024,6 +1020,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	page = gfn_to_page(vcpu->kvm, gfn);
 
 	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_free_some_pages(vcpu);
 	r = __nonpaging_map(vcpu, v, write, gfn, page);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
@@ -1275,6 +1272,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	if (r)
 		goto out;
 	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_free_some_pages(vcpu);
 	mmu_alloc_roots(vcpu);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_x86_ops->set_cr3(vcpu, vcpu->arch.mmu.root_hpa);
@@ -1413,6 +1411,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	pgprintk("%s: gpa %llx bytes %d\n", __FUNCTION__, gpa, bytes);
 	mmu_guess_page_from_pte_write(vcpu, gpa, new, bytes);
 	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_free_some_pages(vcpu);
 	++vcpu->kvm->stat.mmu_pte_write;
 	kvm_mmu_audit(vcpu, "pre pte write");
 	if (gfn == vcpu->arch.last_pt_write_gfn
@@ -1505,7 +1504,6 @@ int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 {
-	spin_lock(&vcpu->kvm->mmu_lock);
 	while (vcpu->kvm->arch.n_free_mmu_pages < KVM_REFILL_PAGES) {
 		struct kvm_mmu_page *sp;
 
@@ -1514,7 +1512,6 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 		kvm_mmu_zap_page(vcpu->kvm, sp);
 		++vcpu->kvm->stat.mmu_recycled;
 	}
-	spin_unlock(&vcpu->kvm->mmu_lock);
 }
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code)
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a35b83a..3499205 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -402,6 +402,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 	page = gfn_to_page(vcpu->kvm, walker.gfn);
 
 	spin_lock(&vcpu->kvm->mmu_lock);
+	kvm_mmu_free_some_pages(vcpu);
 	shadow_pte = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
 				  &write_pt, page);
 	pgprintk("%s: shadow pte %p %llx ptwrite %d\n", __FUNCTION__,
-- 
1.5.3.7

