Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbXDVJ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbXDVJ2w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 05:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXDVJ2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 05:28:52 -0400
Received: from il.qumranet.com ([82.166.9.18]:36211 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbXDVJ2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 05:28:51 -0400
From: Avi Kivity <avi@qumranet.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH -stable] KVM: MMU: Fix host memory corruption on i386 with >= 4GB ram
Date: Sun, 22 Apr 2007 12:28:49 +0300
Message-Id: <11772341294121-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PAGE_MASK is an unsigned long, so using it to mask physical addresses on
i386 (which are 64-bit wide) leads to truncation.  This can result in
page->private of unrelated memory pages being modified, with disasterous
results.

Fix by not using PAGE_MASK for physical addresses; instead calculate
the correct value directly from PAGE_SIZE.  Also fix a similar BUG_ON().

Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 1e09d4e..1b5e189 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -131,7 +131,7 @@ static int dbg = 1;
 	(((address) >> PT32_LEVEL_SHIFT(level)) & ((1 << PT32_LEVEL_BITS) - 1))
 
 
-#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & PAGE_MASK)
+#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #define PT64_DIR_BASE_ADDR_MASK \
 	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + PT64_LEVEL_BITS)) - 1))
 
@@ -406,8 +406,8 @@ static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 			spte = desc->shadow_ptes[0];
 		}
 		BUG_ON(!spte);
-		BUG_ON((*spte & PT64_BASE_ADDR_MASK) !=
-		       page_to_pfn(page) << PAGE_SHIFT);
+		BUG_ON((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT
+		       != page_to_pfn(page));
 		BUG_ON(!(*spte & PT_PRESENT_MASK));
 		BUG_ON(!(*spte & PT_WRITABLE_MASK));
 		rmap_printk("rmap_write_protect: spte %p %llx\n", spte, *spte);
-- 
1.5.0.6

