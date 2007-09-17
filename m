Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbXIQIjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbXIQIjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXIQIcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:45296 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbXIQIc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:28 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 042/104] KVM: Cleanup mark_page_dirty
Date: Mon, 17 Sep 2007 10:31:24 +0200
Message-Id: <11900179471610-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

For some reason, mark_page_dirty open-codes __gfn_to_memslot().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5dc6017..55639ac 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -916,28 +916,18 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
+/* WARNING: Does not work on aliased pages. */
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 {
-	int i;
 	struct kvm_memory_slot *memslot;
-	unsigned long rel_gfn;
 
-	for (i = 0; i < kvm->nmemslots; ++i) {
-		memslot = &kvm->memslots[i];
+	memslot = __gfn_to_memslot(kvm, gfn);
+	if (memslot && memslot->dirty_bitmap) {
+		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
-		if (gfn >= memslot->base_gfn
-		    && gfn < memslot->base_gfn + memslot->npages) {
-
-			if (!memslot->dirty_bitmap)
-				return;
-
-			rel_gfn = gfn - memslot->base_gfn;
-
-			/* avoid RMW */
-			if (!test_bit(rel_gfn, memslot->dirty_bitmap))
-				set_bit(rel_gfn, memslot->dirty_bitmap);
-			return;
-		}
+		/* avoid RMW */
+		if (!test_bit(rel_gfn, memslot->dirty_bitmap))
+			set_bit(rel_gfn, memslot->dirty_bitmap);
 	}
 }
 
-- 
1.5.3

