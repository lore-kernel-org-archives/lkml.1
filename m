Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbXLWPCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbXLWPCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbXLWOwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:17 -0500
Received: from il.qumranet.com ([82.166.9.18]:35914 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbXLWOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 35/50] KVM: MMU: Move dirty bit updates to a separate function
Date: Sun, 23 Dec 2007 16:51:20 +0200
Message-Id: <1198421495-31481-36-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 4538b15..a0f84a5 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -69,6 +69,17 @@ struct guest_walker {
 	u32 error_code;
 };
 
+static void FNAME(update_dirty_bit)(struct kvm_vcpu *vcpu,
+				    int write_fault,
+				    pt_element_t *ptep,
+				    gfn_t table_gfn)
+{
+	if (write_fault && !is_dirty_pte(*ptep)) {
+		mark_page_dirty(vcpu->kvm, table_gfn);
+		*ptep |= PT_DIRTY_MASK;
+	}
+}
+
 /*
  * Fetch a guest pte for a guest virtual address
  */
@@ -144,10 +155,8 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 		if (walker->level == PT_PAGE_TABLE_LEVEL) {
 			walker->gfn = (*ptep & PT_BASE_ADDR_MASK)
 				>> PAGE_SHIFT;
-			if (write_fault && !is_dirty_pte(*ptep)) {
-				mark_page_dirty(vcpu->kvm, table_gfn);
-				*ptep |= PT_DIRTY_MASK;
-			}
+			FNAME(update_dirty_bit)(vcpu, write_fault, ptep,
+						table_gfn);
 			break;
 		}
 
@@ -157,10 +166,8 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 			walker->gfn = (*ptep & PT_DIR_BASE_ADDR_MASK)
 				>> PAGE_SHIFT;
 			walker->gfn += PT_INDEX(addr, PT_PAGE_TABLE_LEVEL);
-			if (write_fault && !is_dirty_pte(*ptep)) {
-				mark_page_dirty(vcpu->kvm, table_gfn);
-				*ptep |= PT_DIRTY_MASK;
-			}
+			FNAME(update_dirty_bit)(vcpu, write_fault, ptep,
+						table_gfn);
 			break;
 		}
 
-- 
1.5.3.7

