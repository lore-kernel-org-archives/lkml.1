Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYIWNs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYIWNs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYIWNrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52348 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYIWNrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:07 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 05/40] KVM: MMU: Separate the code for unlinking a shadow page from its parents
Date: Tue, 23 Sep 2008 16:46:19 +0300
Message-Id: <1222177614-26669-6-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Place into own function, in preparation for further cleanups.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3da2508..81016a3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -991,11 +991,10 @@ static void kvm_mmu_reset_last_pte_updated(struct kvm *kvm)
 			kvm->vcpus[i]->arch.last_pte_updated = NULL;
 }
 
-static void kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+static void kvm_mmu_unlink_parents(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	u64 *parent_pte;
 
-	++kvm->stat.mmu_shadow_zapped;
 	while (sp->multimapped || sp->parent_pte) {
 		if (!sp->multimapped)
 			parent_pte = sp->parent_pte;
@@ -1010,7 +1009,13 @@ static void kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 		kvm_mmu_put_page(sp, parent_pte);
 		set_shadow_pte(parent_pte, shadow_trap_nonpresent_pte);
 	}
+}
+
+static void kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	++kvm->stat.mmu_shadow_zapped;
 	kvm_mmu_page_unlink_children(kvm, sp);
+	kvm_mmu_unlink_parents(kvm, sp);
 	if (!sp->root_count) {
 		if (!sp->role.metaphysical && !sp->role.invalid)
 			unaccount_shadowed(kvm, sp->gfn);
-- 
1.6.0.1

