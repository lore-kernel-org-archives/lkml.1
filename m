Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbYFZMbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbYFZMbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYFZM2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:43 -0400
Received: from il.qumranet.com ([212.179.150.194]:32348 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbYFZM2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:36 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH 09/50] KVM: Handle vma regions with no backing page
Date: Thu, 26 Jun 2008 15:27:51 +0300
Message-Id: <1214483312-9265-10-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

This patch allows VMAs that contain no backing page to be used for guest
memory.  This is useful for assigning mmio regions to a guest.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 virt/kvm/kvm_main.c |   49 +++++++++++++++++++++++++++++++++++++------------
 1 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 764d702..4d30ac5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -532,6 +532,7 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 	struct page *page[1];
 	unsigned long addr;
 	int npages;
+	pfn_t pfn;
 
 	might_sleep();
 
@@ -544,19 +545,38 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 	npages = get_user_pages(current, current->mm, addr, 1, 1, 1, page,
 				NULL);
 
-	if (npages != 1) {
-		get_page(bad_page);
-		return page_to_pfn(bad_page);
-	}
+	if (unlikely(npages != 1)) {
+		struct vm_area_struct *vma;
 
-	return page_to_pfn(page[0]);
+		vma = find_vma(current->mm, addr);
+		if (vma == NULL || addr < vma->vm_start ||
+		    !(vma->vm_flags & VM_PFNMAP)) {
+			get_page(bad_page);
+			return page_to_pfn(bad_page);
+		}
+
+		pfn = ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+		BUG_ON(pfn_valid(pfn));
+	} else
+		pfn = page_to_pfn(page[0]);
+
+	return pfn;
 }
 
 EXPORT_SYMBOL_GPL(gfn_to_pfn);
 
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
-	return pfn_to_page(gfn_to_pfn(kvm, gfn));
+	pfn_t pfn;
+
+	pfn = gfn_to_pfn(kvm, gfn);
+	if (pfn_valid(pfn))
+		return pfn_to_page(pfn);
+
+	WARN_ON(!pfn_valid(pfn));
+
+	get_page(bad_page);
+	return bad_page;
 }
 
 EXPORT_SYMBOL_GPL(gfn_to_page);
@@ -569,7 +589,8 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);
 
 void kvm_release_pfn_clean(pfn_t pfn)
 {
-	put_page(pfn_to_page(pfn));
+	if (pfn_valid(pfn))
+		put_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
 
@@ -594,21 +615,25 @@ EXPORT_SYMBOL_GPL(kvm_set_page_dirty);
 
 void kvm_set_pfn_dirty(pfn_t pfn)
 {
-	struct page *page = pfn_to_page(pfn);
-	if (!PageReserved(page))
-		SetPageDirty(page);
+	if (pfn_valid(pfn)) {
+		struct page *page = pfn_to_page(pfn);
+		if (!PageReserved(page))
+			SetPageDirty(page);
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
 void kvm_set_pfn_accessed(pfn_t pfn)
 {
-	mark_page_accessed(pfn_to_page(pfn));
+	if (pfn_valid(pfn))
+		mark_page_accessed(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
 
 void kvm_get_pfn(pfn_t pfn)
 {
-	get_page(pfn_to_page(pfn));
+	if (pfn_valid(pfn))
+		get_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_get_pfn);
 
-- 
1.5.6

