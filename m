Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbXLZLX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbXLZLX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbXLZLHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:11 -0500
Received: from il.qumranet.com ([82.166.9.18]:50486 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbXLZLGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:09 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 45/55] KVM: introduce gfn_to_hva()
Date: Wed, 26 Dec 2007 13:05:50 +0200
Message-Id: <1198667160-22953-46-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Convert a guest frame number to the corresponding host virtual address.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index e3c7f3b..d318c28 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -559,28 +559,37 @@ int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
 
+static unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot;
+
+	gfn = unalias_gfn(kvm, gfn);
+	slot = __gfn_to_memslot(kvm, gfn);
+	if (!slot)
+		return bad_hva();
+	return (slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE);
+}
+
 /*
  * Requires current->mm->mmap_sem to be held
  */
 static struct page *__gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
-	struct kvm_memory_slot *slot;
 	struct page *page[1];
+	unsigned long addr;
 	int npages;
 
 	might_sleep();
 
-	gfn = unalias_gfn(kvm, gfn);
-	slot = __gfn_to_memslot(kvm, gfn);
-	if (!slot) {
+	addr = gfn_to_hva(kvm, gfn);
+	if (kvm_is_error_hva(addr)) {
 		get_page(bad_page);
 		return bad_page;
 	}
 
-	npages = get_user_pages(current, current->mm,
-				slot->userspace_addr
-				+ (gfn - slot->base_gfn) * PAGE_SIZE, 1,
-				1, 1, page, NULL);
+	npages = get_user_pages(current, current->mm, addr, 1, 1, 1, page,
+				NULL);
+
 	if (npages != 1) {
 		get_page(bad_page);
 		return bad_page;
-- 
1.5.3.7

