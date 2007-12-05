Return-Path: <linux-kernel-owner+w=401wt.eu-S1754177AbXLEH4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177AbXLEH4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXLEHzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:55:21 -0500
Received: from mail.suse.de ([195.135.220.2]:38635 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbXLEHzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:55:10 -0500
Message-Id: <20071205071627.251516000@nick.local0.net>
References: <20071205071547.701344000@nick.local0.net>
User-Agent: quilt/0.46-14
Date: Wed, 05 Dec 2007 18:15:52 +1100
From: npiggin@suse.de
To: akpm@linux-foundation.org
Cc: kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       linux-kernel@vger.kernel.org
Subject: [patch 05/18] kvm: nopage
Content-Disposition: inline; filename=kvm-nopage.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert KVM from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: kvm-devel@lists.sourceforge.net
Cc: avi@qumranet.com
Cc: linux-kernel@vger.kernel.org
---
 drivers/kvm/kvm_main.c |   38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

Index: linux-2.6/drivers/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm_main.c
+++ linux-2.6/drivers/kvm/kvm_main.c
@@ -2533,30 +2533,24 @@ static int kvm_vcpu_ioctl_debug_guest(st
 	return r;
 }
 
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
@@ -3111,27 +3105,21 @@ out:
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
-	page = gfn_to_page(kvm, pgoff);
+	page = gfn_to_page(kvm, vmf->pgoff);
 	if (!page)
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
 
 static struct vm_operations_struct kvm_vm_vm_ops = {
-	.nopage = kvm_vm_nopage,
+	.fault = kvm_vm_fault,
 };
 
 static int kvm_vm_mmap(struct file *file, struct vm_area_struct *vma)

-- 

