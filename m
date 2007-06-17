Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbXFQJrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbXFQJrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759292AbXFQJoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:46 -0400
Received: from il.qumranet.com ([82.166.9.18]:55166 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757707AbXFQJom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 09/58] KVM: MMU: Respect nonpae pagetable quadrant when zapping ptes
Date: Sun, 17 Jun 2007 12:43:50 +0300
Message-Id: <11820734804054-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a guest writes to a page that has an mmu shadow, we have to clear
the shadow pte corresponding to the memory location touched by the guest.

Now, in nonpae mode, a single guest page may have two or four shadow
pages (because a nonpae page maps 4MB or 4GB, whereas the pae shadow maps
2MB or 1GB), so we when we look up the page we find up to three additional
aliases for the page.  Since we _clear_ the shadow pte, it doesn't matter
except for a slight performance penalty, but if we want to _update_ the
shadow pte instead of clearing it, it is vital that we don't modify the
aliases.

Fortunately, exactly which page is needed (the "quadrant") is easily
computed, and is accessible in the shadow page header.  All we need is
to ignore shadow pages from the wrong quadrants.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index b3a83ef..23dc461 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1150,6 +1150,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	unsigned pte_size;
 	unsigned page_offset;
 	unsigned misaligned;
+	unsigned quadrant;
 	int level;
 	int flooded = 0;
 	int npte;
@@ -1202,7 +1203,10 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 				page_offset <<= 1;
 				npte = 2;
 			}
+			quadrant = page_offset >> PAGE_SHIFT;
 			page_offset &= ~PAGE_MASK;
+			if (quadrant != page->role.quadrant)
+				continue;
 		}
 		spte = __va(page->page_hpa);
 		spte += page_offset / sizeof(*spte);
-- 
1.5.0.6

