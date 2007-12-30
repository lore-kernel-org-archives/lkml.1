Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbXL3HYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbXL3HYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXL3HLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:32 -0500
Received: from il.qumranet.com ([82.166.9.18]:59478 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbXL3HKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:52 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 51/52] KVM: MMU: Introduce gfn_to_gpa()
Date: Sun, 30 Dec 2007 09:10:37 +0200
Message-Id: <1198998638-22713-52-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting a frame number to an address is tricky since the data type changes
size.  Introduce a function to do it.  This fixes an actual bug when
accessing guest ptes.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    4 ++++
 drivers/kvm/paging_tmpl.h |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 048849d..eda82cd 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -499,6 +499,10 @@ static inline int memslot_id(struct kvm *kvm, struct kvm_memory_slot *slot)
 	return slot - kvm->memslots;
 }
 
+static inline gpa_t gfn_to_gpa(gfn_t gfn)
+{
+	return (gpa_t)gfn << PAGE_SHIFT;
+}
 
 enum kvm_stat_kind {
 	KVM_STAT_VM,
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index a3da98b..b24bc7c 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -110,7 +110,7 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 		index = PT_INDEX(addr, walker->level);
 
 		table_gfn = gpte_to_gfn(pte);
-		pte_gpa = table_gfn << PAGE_SHIFT;
+		pte_gpa = gfn_to_gpa(table_gfn);
 		pte_gpa += index * sizeof(pt_element_t);
 		walker->table_gfn[walker->level - 1] = table_gfn;
 		pgprintk("%s: table_gfn[%d] %lx\n", __FUNCTION__,
@@ -442,7 +442,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr)
 	r = FNAME(walk_addr)(&walker, vcpu, vaddr, 0, 0, 0);
 
 	if (r) {
-		gpa = (gpa_t)walker.gfn << PAGE_SHIFT;
+		gpa = gfn_to_gpa(walker.gfn);
 		gpa |= vaddr & ~PAGE_MASK;
 	}
 
-- 
1.5.3.7

