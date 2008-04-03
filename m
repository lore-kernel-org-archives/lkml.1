Return-Path: <linux-kernel-owner+w=401wt.eu-S1763422AbYDCTj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763422AbYDCTj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761129AbYDCTdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:18 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:39115
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760253AbYDCTdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:33:00 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Izik Eidus <izike@qumranet.com>
Subject: [PATCH 30/35] KVM: MMU: fix dirty bit setting when removing write permissions
Date: Thu,  3 Apr 2008 22:32:45 +0300
Message-Id: <1207251170-5013-31-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

When mmu_set_spte() checks if a page related to spte should be release as
dirty or clean, it check if the shadow pte was writeble, but in case
rmap_write_protect() is called called it is possible for shadow ptes that were
writeble to become readonly and therefor mmu_set_spte will release the pages
as clean.

This patch fix this issue by marking the page as dirty inside
rmap_write_protect().

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a5872b3..dd4b95b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -626,6 +626,14 @@ static void rmap_write_protect(struct kvm *kvm, u64 gfn)
 		}
 		spte = rmap_next(kvm, rmapp, spte);
 	}
+	if (write_protected) {
+		struct page *page;
+
+		spte = rmap_next(kvm, rmapp, NULL);
+		page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
+		SetPageDirty(page);
+	}
+
 	/* check for huge page mappings */
 	rmapp = gfn_to_rmap(kvm, gfn, 1);
 	spte = rmap_next(kvm, rmapp, NULL);
-- 
1.5.4.5

