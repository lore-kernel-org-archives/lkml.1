Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbXLWPBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbXLWPBe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbXLWOwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:12 -0500
Received: from il.qumranet.com ([82.166.9.18]:35917 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbXLWOvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:45 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 36/50] KVM: MMU: When updating the dirty bit, inform the mmu about it
Date: Sun, 23 Dec 2007 16:51:21 +0200
Message-Id: <1198421495-31481-37-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the mmu uses different shadow pages for dirty large pages and clean
large pages, this allows the mmu to drop ptes that are now invalid.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index a0f84a5..a9e687b 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -74,9 +74,14 @@ static void FNAME(update_dirty_bit)(struct kvm_vcpu *vcpu,
 				    pt_element_t *ptep,
 				    gfn_t table_gfn)
 {
+	gpa_t pte_gpa;
+
 	if (write_fault && !is_dirty_pte(*ptep)) {
 		mark_page_dirty(vcpu->kvm, table_gfn);
 		*ptep |= PT_DIRTY_MASK;
+		pte_gpa = ((gpa_t)table_gfn << PAGE_SHIFT);
+		pte_gpa += offset_in_page(ptep);
+		kvm_mmu_pte_write(vcpu, pte_gpa, (u8 *)ptep, sizeof(*ptep));
 	}
 }
 
-- 
1.5.3.7

