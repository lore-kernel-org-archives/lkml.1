Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbXDAOgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbXDAOgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933367AbXDAOgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:36:20 -0400
Received: from il.qumranet.com ([82.166.9.18]:47578 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933306AbXDAOfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 34/41] KVM: Use list_move()
Date: Sun,  1 Apr 2007 17:35:31 +0300
Message-Id: <11754381391161-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438139249-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com> <1175438139877-git-send-email-avi@qumranet.com> <11754381391119-git-send-email-avi@qumranet.com> <1175438139312-git-send-email-avi@qumranet.com> <11754381392527-git-send-email-avi@qumranet.com> <11754381393184-git-send-email-avi@qumranet.com> <1175438139249-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use list_move() where possible.  Noticed by Dor Laor.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 0216b77..c2487b6 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -437,9 +437,8 @@ static void kvm_mmu_free_page(struct kvm_vcpu *vcpu, hpa_t page_hpa)
 	struct kvm_mmu_page *page_head = page_header(page_hpa);
 
 	ASSERT(is_empty_shadow_page(page_hpa));
-	list_del(&page_head->link);
 	page_head->page_hpa = page_hpa;
-	list_add(&page_head->link, &vcpu->free_pages);
+	list_move(&page_head->link, &vcpu->free_pages);
 	++vcpu->kvm->n_free_mmu_pages;
 }
 
@@ -457,8 +456,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 		return NULL;
 
 	page = list_entry(vcpu->free_pages.next, struct kvm_mmu_page, link);
-	list_del(&page->link);
-	list_add(&page->link, &vcpu->kvm->active_mmu_pages);
+	list_move(&page->link, &vcpu->kvm->active_mmu_pages);
 	ASSERT(is_empty_shadow_page(page->page_hpa));
 	page->slot_bitmap = 0;
 	page->multimapped = 0;
@@ -670,10 +668,8 @@ static void kvm_mmu_zap_page(struct kvm_vcpu *vcpu,
 	if (!page->root_count) {
 		hlist_del(&page->hash_link);
 		kvm_mmu_free_page(vcpu, page->page_hpa);
-	} else {
-		list_del(&page->link);
-		list_add(&page->link, &vcpu->kvm->active_mmu_pages);
-	}
+	} else
+		list_move(&page->link, &vcpu->kvm->active_mmu_pages);
 }
 
 static int kvm_mmu_unprotect_page(struct kvm_vcpu *vcpu, gfn_t gfn)
-- 
1.5.0.5

