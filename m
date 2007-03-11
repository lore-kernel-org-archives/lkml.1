Return-Path: <linux-kernel-owner+w=401wt.eu-S1752133AbXCKKHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbXCKKHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 06:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXCKKHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 06:07:11 -0400
Received: from il.qumranet.com ([82.166.9.18]:51139 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbXCKKHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 06:07:10 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH] KVM: MMU: Fix host memory corruption on i386 with >= 4GB ram
Date: Sun, 11 Mar 2007 12:07:08 +0200
Message-Id: <11736076282800-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11736076283998-git-send-email-avi@qumranet.com>
References: <11736076283998-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

PAGE_MASK is an unsigned long, so using it to mask physical addresses on
i386 (which are 64-bit wide) leads to truncation.  This can result in
page->private of unrelated memory pages being modified, with disasterous
results.

Fix by not using PAGE_MASK for physical addresses; instead calculate
the correct value directly from PAGE_SIZE.  Also fix a similar BUG_ON().

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 2cb4893..e85b4c7 100644
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
1.5.0.2

