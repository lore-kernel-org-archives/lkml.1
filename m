Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbXGQNXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbXGQNXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXGQNWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:22:46 -0400
Received: from il.qumranet.com ([82.166.9.18]:43818 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbXGQNWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:22:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 1/3] KVM: MMU: Store nx bit for large page shadows
Date: Tue, 17 Jul 2007 16:22:50 +0300
Message-Id: <11846785722530-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <11846785722851-git-send-email-avi@qumranet.com>
References: <11846785722851-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We need to distinguish between large page shadows which have the nx bit set
and those which don't.  The problem shows up when booting a newer smp Linux
kernel, where the trampoline page (which is in real mode, which uses the
same shadow pages as large pages) is using the same mapping as a kernel data
page, which is mapped using nx, causing kvm to spin on that page.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    4 ++--
 drivers/kvm/paging_tmpl.h |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index a7c5e6b..65ab268 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -121,7 +121,7 @@ struct kvm_pte_chain {
  *   bits 4:7 - page table level for this shadow (1-4)
  *   bits 8:9 - page table quadrant for 2-level guests
  *   bit   16 - "metaphysical" - gfn is not a real page (huge page/real mode)
- *   bits 17:18 - "access" - the user and writable bits of a huge page pde
+ *   bits 17:19 - "access" - the user, writable, and nx bits of a huge page pde
  */
 union kvm_mmu_page_role {
 	unsigned word;
@@ -131,7 +131,7 @@ union kvm_mmu_page_role {
 		unsigned quadrant : 2;
 		unsigned pad_for_nice_hex_output : 6;
 		unsigned metaphysical : 1;
-		unsigned hugepage_access : 2;
+		unsigned hugepage_access : 3;
 	};
 };
 
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index a7c5cb0..4b5391c 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -366,6 +366,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			metaphysical = 1;
 			hugepage_access = *guest_ent;
 			hugepage_access &= PT_USER_MASK | PT_WRITABLE_MASK;
+			if (*guest_ent & PT64_NX_MASK)
+				hugepage_access |= (1 << 2);
 			hugepage_access >>= PT_WRITABLE_SHIFT;
 			table_gfn = (*guest_ent & PT_BASE_ADDR_MASK)
 				>> PAGE_SHIFT;
-- 
1.5.2.4

