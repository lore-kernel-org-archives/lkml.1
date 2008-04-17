Return-Path: <linux-kernel-owner+w=401wt.eu-S1765452AbYDQJU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765452AbYDQJU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763533AbYDQJLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:24 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58976
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762793AbYDQJLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:04 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 23/45] KVM: MMU: Only mark_page_accessed() if the page was accessed by the guest
Date: Thu, 17 Apr 2008 12:10:28 +0300
Message-Id: <1208423450-29415-24-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the accessed bit is not set, the guest has never accessed this page
(at least through this spte), so there's no need to mark the page
accessed.  This provides more accurate data for the eviction algortithm.

Noted by Andrea Arcangeli.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1594ee0..5c4c166 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -549,7 +549,8 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 		return;
 	sp = page_header(__pa(spte));
 	page = spte_to_page(*spte);
-	mark_page_accessed(page);
+	if (*spte & PT_ACCESSED_MASK)
+		mark_page_accessed(page);
 	if (is_writeble_pte(*spte))
 		kvm_release_page_dirty(page);
 	else
-- 
1.5.5

