Return-Path: <linux-kernel-owner+w=401wt.eu-S1755127AbYI1Pvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbYI1Pvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYI1Ppz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:45:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50887 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbYI1Ppw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:45:52 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 22/25] KVM: opencode gfn_to_page in kvm_vm_fault
Date: Sun, 28 Sep 2008 18:44:58 +0300
Message-Id: <1222616701-1206-23-git-send-email-avi@redhat.com>
In-Reply-To: <1222616701-1206-1-git-send-email-avi@redhat.com>
References: <1222616701-1206-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

kvm_vm_fault is invoked with mmap_sem held in read mode. Since gfn_to_page
will be converted to get_user_pages_fast, which requires this lock NOT
to be held, switch to opencoded get_user_pages.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f42d5c2..2907d05 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1394,17 +1394,22 @@ out:
 
 static int kvm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct page *page[1];
+	unsigned long addr;
+	int npages;
+	gfn_t gfn = vmf->pgoff;
 	struct kvm *kvm = vma->vm_file->private_data;
-	struct page *page;
 
-	if (!kvm_is_visible_gfn(kvm, vmf->pgoff))
+	addr = gfn_to_hva(kvm, gfn);
+	if (kvm_is_error_hva(addr))
 		return VM_FAULT_SIGBUS;
-	page = gfn_to_page(kvm, vmf->pgoff);
-	if (is_error_page(page)) {
-		kvm_release_page_clean(page);
+
+	npages = get_user_pages(current, current->mm, addr, 1, 1, 0, page,
+				NULL);
+	if (unlikely(npages != 1))
 		return VM_FAULT_SIGBUS;
-	}
-	vmf->page = page;
+
+	vmf->page = page[0];
 	return 0;
 }
 
-- 
1.6.0.1

