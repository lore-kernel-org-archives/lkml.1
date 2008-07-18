Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYGRFEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYGRFEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 01:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYGRFEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 01:04:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:23129 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbYGRFD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 01:03:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rkBob9JH1w0WXMCOj0GcR3EcJpsckJxa4YoQucBk9+AUeWMYiKlhMeW+nf1RIl+iak
         03znGYtRoRLoADRfh/INP60oaNNwEmpO8f7lU+/g2pXq7xlu3Qxz9ROmN2RbSmCcSkuB
         nncKd8Ad3qj5M9jIPiSEa4t+Nz/y3yoB0AGjY=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, hjk@linutronix.de, gregkh@suse.de,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 14:04:10 +0900
Message-Id: <20080718050410.16250.20327.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
References: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
Subject: [PATCH 01/06] uio: Use struct_uio_mem instead of index
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch teaches the UIO code to make use of struct uio_mem pointers.
The code is converted from:
   index = uio_find_mem_index()
   do_something(idev->info->mem[index].member)
to
   mem = uio_find_mem()
   do_something(mem->member)

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/uio/uio.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- 0001/drivers/uio/uio.c
+++ work/drivers/uio/uio.c	2008-07-18 12:39:49.000000000 +0900
@@ -427,18 +427,18 @@ static ssize_t uio_read(struct file *fil
 	return retval;
 }
 
-static int uio_find_mem_index(struct vm_area_struct *vma)
+static struct uio_mem *uio_find_mem(struct vm_area_struct *vma)
 {
 	int mi;
 	struct uio_device *idev = vma->vm_private_data;
 
 	for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
 		if (idev->info->mem[mi].size == 0)
-			return -1;
+			break;
 		if (vma->vm_pgoff == mi)
-			return mi;
+			return &idev->info->mem[mi];
 	}
-	return -1;
+	return NULL;
 }
 
 static void uio_vma_open(struct vm_area_struct *vma)
@@ -456,16 +456,16 @@ static void uio_vma_close(struct vm_area
 static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct uio_device *idev = vma->vm_private_data;
+	struct uio_mem *imem = uio_find_mem(vma);
 	struct page *page;
 
-	int mi = uio_find_mem_index(vma);
-	if (mi < 0)
+	if (!imem)
 		return VM_FAULT_SIGBUS;
 
-	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
-		page = virt_to_page(idev->info->mem[mi].addr);
+	if (imem->memtype == UIO_MEM_LOGICAL)
+		page = virt_to_page(imem->addr);
 	else
-		page = vmalloc_to_page((void*)idev->info->mem[mi].addr);
+		page = vmalloc_to_page((void *)imem->addr);
 	get_page(page);
 	vmf->page = page;
 	return 0;
@@ -479,9 +479,9 @@ static struct vm_operations_struct uio_v
 
 static int uio_mmap_physical(struct vm_area_struct *vma)
 {
-	struct uio_device *idev = vma->vm_private_data;
-	int mi = uio_find_mem_index(vma);
-	if (mi < 0)
+	struct uio_mem *imem = uio_find_mem(vma);
+
+	if (!imem)
 		return -EINVAL;
 
 	vma->vm_flags |= VM_IO | VM_RESERVED;
@@ -490,7 +490,7 @@ static int uio_mmap_physical(struct vm_a
 
 	return remap_pfn_range(vma,
 			       vma->vm_start,
-			       idev->info->mem[mi].addr >> PAGE_SHIFT,
+			       imem->addr >> PAGE_SHIFT,
 			       vma->vm_end - vma->vm_start,
 			       vma->vm_page_prot);
 }
@@ -507,7 +507,7 @@ static int uio_mmap(struct file *filep, 
 {
 	struct uio_listener *listener = filep->private_data;
 	struct uio_device *idev = listener->dev;
-	int mi;
+	struct uio_mem *imem;
 	unsigned long requested_pages, actual_pages;
 	int ret = 0;
 
@@ -516,12 +516,12 @@ static int uio_mmap(struct file *filep, 
 
 	vma->vm_private_data = idev;
 
-	mi = uio_find_mem_index(vma);
-	if (mi < 0)
+	imem = uio_find_mem(vma);
+	if (!imem)
 		return -EINVAL;
 
 	requested_pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-	actual_pages = (idev->info->mem[mi].size + PAGE_SIZE -1) >> PAGE_SHIFT;
+	actual_pages = (imem->size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (requested_pages > actual_pages)
 		return -EINVAL;
 
@@ -530,7 +530,7 @@ static int uio_mmap(struct file *filep, 
 		return ret;
 	}
 
-	switch (idev->info->mem[mi].memtype) {
+	switch (imem->memtype) {
 		case UIO_MEM_PHYS:
 			return uio_mmap_physical(vma);
 		case UIO_MEM_LOGICAL:
