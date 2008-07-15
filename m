Return-Path: <linux-kernel-owner+w=401wt.eu-S1761188AbYGOMQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188AbYGOMQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757439AbYGOMMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:54 -0400
Received: from il.qumranet.com ([212.179.150.194]:30406 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205AbYGOMMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 17/19] KVM: MMU: improve invalid shadow root page handling
Date: Tue, 15 Jul 2008 15:12:36 +0300
Message-Id: <1216123958-10717-18-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Harden kvm_mmu_zap_page() against invalid root pages that
had been shadowed from memslots that are gone.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ff7cf63..7f57da6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -930,14 +930,17 @@ static void kvm_mmu_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 	}
 	kvm_mmu_page_unlink_children(kvm, sp);
 	if (!sp->root_count) {
-		if (!sp->role.metaphysical)
+		if (!sp->role.metaphysical && !sp->role.invalid)
 			unaccount_shadowed(kvm, sp->gfn);
 		hlist_del(&sp->hash_link);
 		kvm_mmu_free_page(kvm, sp);
 	} else {
+		int invalid = sp->role.invalid;
 		list_move(&sp->link, &kvm->arch.active_mmu_pages);
 		sp->role.invalid = 1;
 		kvm_reload_remote_mmus(kvm);
+		if (!sp->role.metaphysical && !invalid)
+			unaccount_shadowed(kvm, sp->gfn);
 	}
 	kvm_mmu_reset_last_pte_updated(kvm);
 }
-- 
1.5.6.1

