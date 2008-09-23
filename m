Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYIWNtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYIWNtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYIWNrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52354 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbYIWNrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 06/40] KVM: MMU: Simplify kvm_mmu_zap_page()
Date: Tue, 23 Sep 2008 16:46:20 +0300
Message-Id: <1222177614-26669-7-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

The twisty maze of conditionals can be reduced.

[joerg: fix tlb flushing]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 81016a3..c3afbfe 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -955,7 +955,6 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 				rmap_remove(kvm, &pt[i]);
 			pt[i] = shadow_trap_nonpresent_pte;
 		}
-		kvm_flush_remote_tlbs(kvm);
 		return;
 	}
 
@@ -974,7 +973,6 @@ static void kvm_mmu_page_unlink_children(struct kvm *kvm,
 		}
 		pt[i] = shadow_trap_nonpresent_pte;
 	}
-	kvm_flush_remote_tlbs(kvm);
 }
 
 static void kvm_mmu_put_page(struct kvm_mmu_page *sp, u64 *parent_pte)
@@ -1016,18 +1014,16 @@ static void kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	++kvm->stat.mmu_shadow_zapped;
 	kvm_mmu_page_unlink_children(kvm, sp);
 	kvm_mmu_unlink_parents(kvm, sp);
+	kvm_flush_remote_tlbs(kvm);
+	if (!sp->role.invalid && !sp->role.metaphysical)
+		unaccount_shadowed(kvm, sp->gfn);
 	if (!sp->root_count) {
-		if (!sp->role.metaphysical && !sp->role.invalid)
-			unaccount_shadowed(kvm, sp->gfn);
 		hlist_del(&sp->hash_link);
 		kvm_mmu_free_page(kvm, sp);
 	} else {
-		int invalid = sp->role.invalid;
-		list_move(&sp->link, &kvm->arch.active_mmu_pages);
 		sp->role.invalid = 1;
+		list_move(&sp->link, &kvm->arch.active_mmu_pages);
 		kvm_reload_remote_mmus(kvm);
-		if (!sp->role.metaphysical && !invalid)
-			unaccount_shadowed(kvm, sp->gfn);
 	}
 	kvm_mmu_reset_last_pte_updated(kvm);
 }
@@ -1842,7 +1838,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	index = kvm_page_table_hashfn(gfn);
 	bucket = &vcpu->kvm->arch.mmu_page_hash[index];
 	hlist_for_each_entry_safe(sp, node, n, bucket, hash_link) {
-		if (sp->gfn != gfn || sp->role.metaphysical)
+		if (sp->gfn != gfn || sp->role.metaphysical || sp->role.invalid)
 			continue;
 		pte_size = sp->role.glevels == PT32_ROOT_LEVEL ? 4 : 8;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
-- 
1.6.0.1

