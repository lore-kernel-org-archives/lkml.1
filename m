Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbXFQJp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbXFQJp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbXFQJol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:41 -0400
Received: from il.qumranet.com ([82.166.9.18]:55132 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757707AbXFQJoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 03/58] KVM: Assume that writes smaller than 4 bytes are to non-pagetable pages
Date: Sun, 17 Jun 2007 12:43:44 +0300
Message-Id: <1182073479448-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to remove write protection earlier than otherwise.  Should
some mad OS choose to use byte writes to update pagetables, it will suffer
a performance hit, but still work correctly.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index e8e2281..2277b7c 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1169,6 +1169,7 @@ void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
 			continue;
 		pte_size = page->role.glevels == PT32_ROOT_LEVEL ? 4 : 8;
 		misaligned = (offset ^ (offset + bytes - 1)) & ~(pte_size - 1);
+		misaligned |= bytes < 4;
 		if (misaligned || flooded) {
 			/*
 			 * Misaligned accesses are too much trouble to fix
-- 
1.5.0.6

