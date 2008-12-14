Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYLNIO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYLNIO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbYLNIHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59931 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbYLNIHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:17 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 33/36] KVM: MMU: collapse remote TLB flushes on root sync
Date: Sun, 14 Dec 2008 10:07:06 +0200
Message-Id: <1229242029-13410-34-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Collapse remote TLB flushes on root sync.

kernbench is 2.7% faster on 4-way guest. Improvements have been seen
with other loads such as AIM7.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 7ce92f7..58c35de 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -621,7 +621,7 @@ static u64 *rmap_next(struct kvm *kvm, unsigned long *rmapp, u64 *spte)
 	return NULL;
 }
 
-static void rmap_write_protect(struct kvm *kvm, u64 gfn)
+static int rmap_write_protect(struct kvm *kvm, u64 gfn)
 {
 	unsigned long *rmapp;
 	u64 *spte;
@@ -667,8 +667,7 @@ static void rmap_write_protect(struct kvm *kvm, u64 gfn)
 		spte = rmap_next(kvm, rmapp, spte);
 	}
 
-	if (write_protected)
-		kvm_flush_remote_tlbs(kvm);
+	return write_protected;
 }
 
 static int kvm_unmap_rmapp(struct kvm *kvm, unsigned long *rmapp)
@@ -1083,7 +1082,8 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		return 1;
 	}
 
-	rmap_write_protect(vcpu->kvm, sp->gfn);
+	if (rmap_write_protect(vcpu->kvm, sp->gfn))
+		kvm_flush_remote_tlbs(vcpu->kvm);
 	kvm_unlink_unsync_page(vcpu->kvm, sp);
 	if (vcpu->arch.mmu.sync_page(vcpu, sp)) {
 		kvm_mmu_zap_page(vcpu->kvm, sp);
@@ -1162,6 +1162,14 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 
 	kvm_mmu_pages_init(parent, &parents, &pages);
 	while (mmu_unsync_walk(parent, &pages)) {
+		int protected = 0;
+
+		for_each_sp(pages, sp, parents, i)
+			protected |= rmap_write_protect(vcpu->kvm, sp->gfn);
+
+		if (protected)
+			kvm_flush_remote_tlbs(vcpu->kvm);
+
 		for_each_sp(pages, sp, parents, i) {
 			kvm_sync_page(vcpu, sp);
 			mmu_pages_clear_parents(&parents);
@@ -1226,7 +1234,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, bucket);
 	if (!metaphysical) {
-		rmap_write_protect(vcpu->kvm, gfn);
+		if (rmap_write_protect(vcpu->kvm, gfn))
+			kvm_flush_remote_tlbs(vcpu->kvm);
 		account_shadowed(vcpu->kvm, gfn);
 	}
 	if (shadow_trap_nonpresent_pte != shadow_notrap_nonpresent_pte)
-- 
1.6.0.3

