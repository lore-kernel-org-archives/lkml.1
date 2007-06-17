Return-Path: <linux-kernel-owner+w=401wt.eu-S1761578AbXFQJ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578AbXFQJ4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbXFQJpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:19 -0400
Received: from il.qumranet.com ([82.166.9.18]:55198 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759362AbXFQJos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:48 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 43/58] KVM: MMU: Don't cache guest access bits in the shadow page table
Date: Sun, 17 Jun 2007 12:44:24 +0300
Message-Id: <1182073481421-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This was once used to avoid accessing the guest pte when upgrading
the shadow pte from read-only to read-write.  But usually we need
to set the guest pte dirty or accessed bits anyway, so this wasn't
really exploited.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |    8 --------
 drivers/kvm/paging_tmpl.h |    1 -
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index b47391f..986d012 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -97,14 +97,6 @@ static int dbg = 1;
 #define PT_SHADOW_PS_MARK (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 #define PT_SHADOW_IO_MARK (1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 
-#define PT_SHADOW_WRITABLE_SHIFT (PT_FIRST_AVAIL_BITS_SHIFT + 1)
-#define PT_SHADOW_WRITABLE_MASK (1ULL << PT_SHADOW_WRITABLE_SHIFT)
-
-#define PT_SHADOW_USER_SHIFT (PT_SHADOW_WRITABLE_SHIFT + 1)
-#define PT_SHADOW_USER_MASK (1ULL << (PT_SHADOW_USER_SHIFT))
-
-#define PT_SHADOW_BITS_OFFSET (PT_SHADOW_WRITABLE_SHIFT - PT_WRITABLE_SHIFT)
-
 #define VALID_PAGE(x) ((x) != INVALID_PAGE)
 
 #define PT64_LEVEL_BITS 9
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index b17a4b7..adc1206 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -219,7 +219,6 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 
 	spte |= PT_PRESENT_MASK | PT_ACCESSED_MASK | PT_DIRTY_MASK;
 	spte |= *gpte & PT64_NX_MASK;
-	spte |= access_bits << PT_SHADOW_BITS_OFFSET;
 	if (!dirty)
 		access_bits &= ~PT_WRITABLE_MASK;
 
-- 
1.5.0.6

