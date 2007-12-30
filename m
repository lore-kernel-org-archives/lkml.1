Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXL3HTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXL3HTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756357AbXL3HLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:18 -0500
Received: from il.qumranet.com ([82.166.9.18]:59478 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbXL3HKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 33/52] KVM: MMU: Fix potential memory leak with smp real-mode
Date: Sun, 30 Dec 2007 09:10:19 +0200
Message-Id: <1198998638-22713-34-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

When we map a page, we check whether some other vcpu mapped it for us and if
so, bail out.  But we should decrease the refcount on the page as we do so.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 87d8e70..8add4d5 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -907,8 +907,10 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 
 			pte = table[index];
 			was_rmapped = is_rmap_pte(pte);
-			if (is_shadow_present_pte(pte) && is_writeble_pte(pte))
+			if (is_shadow_present_pte(pte) && is_writeble_pte(pte)) {
+				kvm_release_page(pfn_to_page(p >> PAGE_SHIFT));
 				return 0;
+			}
 			mark_page_dirty(vcpu->kvm, v >> PAGE_SHIFT);
 			page_header_update_slot(vcpu->kvm, table, v);
 			table[index] = p | PT_PRESENT_MASK | PT_WRITABLE_MASK |
-- 
1.5.3.7

