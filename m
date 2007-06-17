Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbXFQJrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbXFQJrv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759439AbXFQJor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:47 -0400
Received: from il.qumranet.com ([82.166.9.18]:55167 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757908AbXFQJom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 10/58] KVM: Update shadow pte on write to guest pte
Date: Sun, 17 Jun 2007 12:43:51 +0300
Message-Id: <1182073480795-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A typical demand page/copy on write pattern is:

- page fault on vaddr
- kvm propagates fault to guest
- guest handles fault, updates pte
- kvm traps write, clears shadow pte, resumes guest
- guest returns to userspace, re-faults on same vaddr
- kvm installs shadow pte, resumes guest
- guest continues

So, three vmexits for a single guest page fault.  But if instead of clearing
the page table entry, we update to correspond to the value that the guest
has just written, we eliminate the third vmexit.

This patch does exactly that, reducing kbuild time by about 10%.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |   15 +++++++++++++++
 drivers/kvm/paging_tmpl.h |   15 +++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 23dc461..9ec3df9 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1137,6 +1137,20 @@ static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 	*spte = 0;
 }
 
+static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
+				  struct kvm_mmu_page *page,
+				  u64 *spte,
+				  const void *new, int bytes)
+{
+	if (page->role.level != PT_PAGE_TABLE_LEVEL)
+		return;
+
+	if (page->role.glevels == PT32_ROOT_LEVEL)
+		paging32_update_pte(vcpu, page, spte, new, bytes);
+	else
+		paging64_update_pte(vcpu, page, spte, new, bytes);
+}
+
 void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		       const u8 *old, const u8 *new, int bytes)
 {
@@ -1212,6 +1226,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		spte += page_offset / sizeof(*spte);
 		while (npte--) {
 			mmu_pte_write_zap_pte(vcpu, page, spte);
+			mmu_pte_write_new_pte(vcpu, page, spte, new, bytes);
 			++spte;
 		}
 	}
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index bc64cce..10ba0a8 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -202,6 +202,21 @@ static void FNAME(set_pte)(struct kvm_vcpu *vcpu, u64 guest_pte,
 		       guest_pte & PT_DIRTY_MASK, access_bits, gfn);
 }
 
+static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
+			      u64 *spte, const void *pte, int bytes)
+{
+	pt_element_t gpte;
+
+	if (bytes < sizeof(pt_element_t))
+		return;
+	gpte = *(const pt_element_t *)pte;
+	if (~gpte & (PT_PRESENT_MASK | PT_ACCESSED_MASK))
+		return;
+	pgprintk("%s: gpte %llx spte %p\n", __FUNCTION__, (u64)gpte, spte);
+	FNAME(set_pte)(vcpu, gpte, spte, 6,
+		       (gpte & PT_BASE_ADDR_MASK) >> PAGE_SHIFT);
+}
+
 static void FNAME(set_pde)(struct kvm_vcpu *vcpu, u64 guest_pde,
 			   u64 *shadow_pte, u64 access_bits, gfn_t gfn)
 {
-- 
1.5.0.6

