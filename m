Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbXLWPHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbXLWPHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbXLWOwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:32 -0500
Received: from il.qumranet.com ([82.166.9.18]:35908 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbXLWOvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 45/50] KVM: MMU: Add rmap_next(), a helper for walking kvm rmaps
Date: Sun, 23 Dec 2007 16:51:30 +0200
Message-Id: <1198421495-31481-46-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index f52604a..14e54e3 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -456,28 +456,53 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	}
 }
 
-static void rmap_write_protect(struct kvm *kvm, u64 gfn)
+static u64 *rmap_next(struct kvm *kvm, unsigned long *rmapp, u64 *spte)
 {
 	struct kvm_rmap_desc *desc;
+	struct kvm_rmap_desc *prev_desc;
+	u64 *prev_spte;
+	int i;
+
+	if (!*rmapp)
+		return NULL;
+	else if (!(*rmapp & 1)) {
+		if (!spte)
+			return (u64 *)*rmapp;
+		return NULL;
+	}
+	desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
+	prev_desc = NULL;
+	prev_spte = NULL;
+	while (desc) {
+		for (i = 0; i < RMAP_EXT && desc->shadow_ptes[i]; ++i) {
+			if (prev_spte == spte)
+				return desc->shadow_ptes[i];
+			prev_spte = desc->shadow_ptes[i];
+		}
+		desc = desc->more;
+	}
+	return NULL;
+}
+
+static void rmap_write_protect(struct kvm *kvm, u64 gfn)
+{
 	unsigned long *rmapp;
 	u64 *spte;
+	u64 *prev_spte;
 
 	gfn = unalias_gfn(kvm, gfn);
 	rmapp = gfn_to_rmap(kvm, gfn);
 
-	while (*rmapp) {
-		if (!(*rmapp & 1))
-			spte = (u64 *)*rmapp;
-		else {
-			desc = (struct kvm_rmap_desc *)(*rmapp & ~1ul);
-			spte = desc->shadow_ptes[0];
-		}
+	spte = rmap_next(kvm, rmapp, NULL);
+	while (spte) {
 		BUG_ON(!spte);
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		BUG_ON(!(*spte & PT_WRITABLE_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
-		rmap_remove(kvm, spte);
-		set_shadow_pte(spte, *spte & ~PT_WRITABLE_MASK);
+		prev_spte = spte;
+		spte = rmap_next(kvm, rmapp, spte);
+		rmap_remove(kvm, prev_spte);
+		set_shadow_pte(prev_spte, *prev_spte & ~PT_WRITABLE_MASK);
 		kvm_flush_remote_tlbs(kvm);
 	}
 }
-- 
1.5.3.7

