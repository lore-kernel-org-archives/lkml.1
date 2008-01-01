Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbYAAPyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbYAAPyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbYAAPhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:37:15 -0500
Received: from il.qumranet.com ([82.166.9.18]:33788 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbYAAPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:27 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: "npiggin@suse.de" <npiggin@suse.de>
Subject: [PATCH 30/54] KVM: Convert KVM from ->nopage() to ->fault()
Date: Tue,  1 Jan 2008 17:35:56 +0200
Message-Id: <1199201780-14001-31-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: npiggin@suse.de <npiggin@suse.de>

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: kvm-devel@lists.sourceforge.net
Cc: avi@qumranet.com
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   42 +++++++++++++++---------------------------
 1 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 3d1023c..cfb27ef 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -662,30 +662,24 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
-static struct page *kvm_vcpu_nopage(struct vm_area_struct *vma,
-				    unsigned long address,
-				    int *type)
+static int kvm_vcpu_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct kvm_vcpu *vcpu = vma->vm_file->private_data;
-	unsigned long pgoff;
 	struct page *page;
 
-	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	if (pgoff == 0)
+	if (vmf->pgoff == 0)
 		page = virt_to_page(vcpu->run);
-	else if (pgoff == KVM_PIO_PAGE_OFFSET)
+	else if (vmf->pgoff == KVM_PIO_PAGE_OFFSET)
 		page = virt_to_page(vcpu->pio_data);
 	else
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	get_page(page);
-	if (type != NULL)
-		*type = VM_FAULT_MINOR;
-
-	return page;
+	vmf->page = page;
+	return 0;
 }
 
 static struct vm_operations_struct kvm_vcpu_vm_ops = {
-	.nopage = kvm_vcpu_nopage,
+	.fault = kvm_vcpu_fault,
 };
 
 static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
@@ -976,31 +970,25 @@ out:
 	return r;
 }
 
-static struct page *kvm_vm_nopage(struct vm_area_struct *vma,
-				  unsigned long address,
-				  int *type)
+static int kvm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct kvm *kvm = vma->vm_file->private_data;
-	unsigned long pgoff;
 	struct page *page;
 
-	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	if (!kvm_is_visible_gfn(kvm, pgoff))
-		return NOPAGE_SIGBUS;
+	if (!kvm_is_visible_gfn(kvm, vmf->pgoff))
+		return VM_FAULT_SIGBUS;
 	/* current->mm->mmap_sem is already held so call lockless version */
-	page = __gfn_to_page(kvm, pgoff);
+	page = __gfn_to_page(kvm, vmf->pgoff);
 	if (is_error_page(page)) {
 		kvm_release_page_clean(page);
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	}
-	if (type != NULL)
-		*type = VM_FAULT_MINOR;
-
-	return page;
+	vmf->page = page;
+	return 0;
 }
 
 static struct vm_operations_struct kvm_vm_vm_ops = {
-	.nopage = kvm_vm_nopage,
+	.fault = kvm_vm_fault,
 };
 
 static int kvm_vm_mmap(struct file *file, struct vm_area_struct *vma)
-- 
1.5.3.7

