Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbXDZJWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbXDZJWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933780AbXDZJWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:22:25 -0400
Received: from il.qumranet.com ([82.166.9.18]:53002 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933760AbXDZJWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 04/18] KVM: Handle partial pae pdptr
Date: Thu, 26 Apr 2007 12:22:04 +0300
Message-Id: <1177579338468-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some guests (Solaris) do not set up all four pdptrs, but leave some invalid.
kvm incorrectly treated these as valid page directories, pinning the
wrong pages and causing general confusion.

Fix by checking the valid bit of a pae pdpte.  This closes sourceforge bug
1698922.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 8bdb9ca..9ff7480 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -806,10 +806,12 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 	for (i = 0; i < 4; ++i) {
 		hpa_t root = vcpu->mmu.pae_root[i];
 
-		ASSERT(VALID_PAGE(root));
-		root &= PT64_BASE_ADDR_MASK;
-		page = page_header(root);
-		--page->root_count;
+		if (root) {
+			ASSERT(VALID_PAGE(root));
+			root &= PT64_BASE_ADDR_MASK;
+			page = page_header(root);
+			--page->root_count;
+		}
 		vcpu->mmu.pae_root[i] = INVALID_PAGE;
 	}
 	vcpu->mmu.root_hpa = INVALID_PAGE;
@@ -840,9 +842,13 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->mmu.pae_root[i];
 
 		ASSERT(!VALID_PAGE(root));
-		if (vcpu->mmu.root_level == PT32E_ROOT_LEVEL)
+		if (vcpu->mmu.root_level == PT32E_ROOT_LEVEL) {
+			if (!is_present_pte(vcpu->pdptrs[i])) {
+				vcpu->mmu.pae_root[i] = 0;
+				continue;
+			}
 			root_gfn = vcpu->pdptrs[i] >> PAGE_SHIFT;
-		else if (vcpu->mmu.root_level == 0)
+		} else if (vcpu->mmu.root_level == 0)
 			root_gfn = 0;
 		page = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
 					PT32_ROOT_LEVEL, !is_paging(vcpu),
-- 
1.5.0.6

