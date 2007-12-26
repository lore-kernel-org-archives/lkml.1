Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbXLZLNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbXLZLNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXLZLGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:39 -0500
Received: from il.qumranet.com ([82.166.9.18]:50470 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbXLZLGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:06 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Anthony Liguori <aliguori@us.ibm.com>
Subject: [PATCH 23/55] KVM: Fix gfn_to_page() acquiring mmap_sem twice
Date: Wed, 26 Dec 2007 13:05:28 +0200
Message-Id: <1198667160-22953-24-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

KVM's nopage handler calls gfn_to_page() which acquires the mmap_sem when
calling out to get_user_pages().  nopage handlers are already invoked with the
mmap_sem held though.  Introduce a __gfn_to_page() for use by the nopage
handler which requires the lock to already be held.

This was noticed by tglx.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index c3dc24f..7186791 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -633,7 +633,10 @@ int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
 
-struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
+/*
+ * Requires current->mm->mmap_sem to be held
+ */
+static struct page *__gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	struct kvm_memory_slot *slot;
 	struct page *page[1];
@@ -648,12 +651,10 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 		return bad_page;
 	}
 
-	down_read(&current->mm->mmap_sem);
 	npages = get_user_pages(current, current->mm,
 				slot->userspace_addr
 				+ (gfn - slot->base_gfn) * PAGE_SIZE, 1,
 				1, 1, page, NULL);
-	up_read(&current->mm->mmap_sem);
 	if (npages != 1) {
 		get_page(bad_page);
 		return bad_page;
@@ -661,6 +662,18 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 
 	return page[0];
 }
+
+struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
+{
+	struct page *page;
+
+	down_read(&current->mm->mmap_sem);
+	page = __gfn_to_page(kvm, gfn);
+	up_read(&current->mm->mmap_sem);
+
+	return page;
+}
+
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
 void kvm_release_page(struct page *page)
@@ -2621,7 +2634,8 @@ static struct page *kvm_vm_nopage(struct vm_area_struct *vma,
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	if (!kvm_is_visible_gfn(kvm, pgoff))
 		return NOPAGE_SIGBUS;
-	page = gfn_to_page(kvm, pgoff);
+	/* current->mm->mmap_sem is already held so call lockless version */
+	page = __gfn_to_page(kvm, pgoff);
 	if (is_error_page(page)) {
 		kvm_release_page(page);
 		return NOPAGE_SIGBUS;
-- 
1.5.3.7

