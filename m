Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbXL3HXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbXL3HXp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbXL3HLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:30 -0500
Received: from il.qumranet.com ([82.166.9.18]:59490 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790AbXL3HKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:51 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 49/52] KVM: MMU: Merge set_pte() and set_pte_common()
Date: Sun, 30 Dec 2007 09:10:35 +0200
Message-Id: <1198998638-22713-50-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since set_pte() is now the only caller of set_pte_common(), merge the two
functions.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 062f4f5..54a6ee8 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -186,15 +186,11 @@ err:
 	return 0;
 }
 
-static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
-				  u64 *shadow_pte,
-				  pt_element_t gpte,
-				  u64 access_bits,
-				  int user_fault,
-				  int write_fault,
-				  int *ptwrite,
-				  struct guest_walker *walker,
-				  gfn_t gfn)
+static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
+			   u64 *shadow_pte, u64 access_bits,
+			   int user_fault, int write_fault,
+			   int *ptwrite, struct guest_walker *walker,
+			   gfn_t gfn)
 {
 	int dirty = gpte & PT_DIRTY_MASK;
 	u64 spte;
@@ -206,6 +202,7 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 		 __FUNCTION__, *shadow_pte, (u64)gpte, access_bits,
 		 write_fault, user_fault, gfn);
 
+	access_bits &= gpte;
 	/*
 	 * We don't set the accessed bit, since we sometimes want to see
 	 * whether the guest actually used the pte (in order to detect
@@ -275,17 +272,6 @@ unshadowed:
 		vcpu->last_pte_updated = shadow_pte;
 }
 
-static void FNAME(set_pte)(struct kvm_vcpu *vcpu, pt_element_t gpte,
-			   u64 *shadow_pte, u64 access_bits,
-			   int user_fault, int write_fault, int *ptwrite,
-			   struct guest_walker *walker, gfn_t gfn)
-{
-	access_bits &= gpte;
-	FNAME(set_pte_common)(vcpu, shadow_pte,
-			      gpte, access_bits, user_fault, write_fault,
-			      ptwrite, walker, gfn);
-}
-
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 			      u64 *spte, const void *pte, int bytes,
 			      int offset_in_pte)
-- 
1.5.3.7

