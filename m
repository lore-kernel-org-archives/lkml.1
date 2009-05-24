Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbZEXP4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbZEXP4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758617AbZEXPw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:52:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41849 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbZEXPue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:34 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 28/45] KVM: x86: check for cr3 validity in mmu_alloc_roots
Date: Sun, 24 May 2009 18:50:13 +0300
Message-Id: <1243180230-2480-29-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Verify the cr3 address stored in vcpu->arch.cr3 points to an existant
memslot. If not, inject a triple fault.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |   27 +++++++++++++++++++++++----
 arch/x86/kvm/x86.c |    1 +
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 80c76f4..479e748 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1912,7 +1912,19 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 }
 
-static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
+static int mmu_check_root(struct kvm_vcpu *vcpu, gfn_t root_gfn)
+{
+	int ret = 0;
+
+	if (!kvm_is_visible_gfn(vcpu->kvm, root_gfn)) {
+		set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
+		ret = 1;
+	}
+
+	return ret;
+}
+
+static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
 {
 	int i;
 	gfn_t root_gfn;
@@ -1927,13 +1939,15 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		ASSERT(!VALID_PAGE(root));
 		if (tdp_enabled)
 			direct = 1;
+		if (mmu_check_root(vcpu, root_gfn))
+			return 1;
 		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
 				      PT64_ROOT_LEVEL, direct,
 				      ACC_ALL, NULL);
 		root = __pa(sp->spt);
 		++sp->root_count;
 		vcpu->arch.mmu.root_hpa = root;
-		return;
+		return 0;
 	}
 	direct = !is_paging(vcpu);
 	if (tdp_enabled)
@@ -1950,6 +1964,8 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 			root_gfn = vcpu->arch.pdptrs[i] >> PAGE_SHIFT;
 		} else if (vcpu->arch.mmu.root_level == 0)
 			root_gfn = 0;
+		if (mmu_check_root(vcpu, root_gfn))
+			return 1;
 		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
 				      PT32_ROOT_LEVEL, direct,
 				      ACC_ALL, NULL);
@@ -1958,6 +1974,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		vcpu->arch.mmu.pae_root[i] = root | PT_PRESENT_MASK;
 	}
 	vcpu->arch.mmu.root_hpa = __pa(vcpu->arch.mmu.pae_root);
+	return 0;
 }
 
 static void mmu_sync_roots(struct kvm_vcpu *vcpu)
@@ -1976,7 +1993,7 @@ static void mmu_sync_roots(struct kvm_vcpu *vcpu)
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->arch.mmu.pae_root[i];
 
-		if (root) {
+		if (root && VALID_PAGE(root)) {
 			root &= PT64_BASE_ADDR_MASK;
 			sp = page_header(root);
 			mmu_sync_children(vcpu, sp);
@@ -2311,9 +2328,11 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 		goto out;
 	spin_lock(&vcpu->kvm->mmu_lock);
 	kvm_mmu_free_some_pages(vcpu);
-	mmu_alloc_roots(vcpu);
+	r = mmu_alloc_roots(vcpu);
 	mmu_sync_roots(vcpu);
 	spin_unlock(&vcpu->kvm->mmu_lock);
+	if (r)
+		goto out;
 	kvm_x86_ops->set_cr3(vcpu, vcpu->arch.mmu.root_hpa);
 	kvm_mmu_flush_tlb(vcpu);
 out:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ecc35c6..33f850b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4564,6 +4564,7 @@ int kvm_arch_set_memory_region(struct kvm *kvm,
 void kvm_arch_flush_shadow(struct kvm *kvm)
 {
 	kvm_mmu_zap_all(kvm);
+	kvm_reload_remote_mmus(kvm);
 }
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
-- 
1.6.0.6

