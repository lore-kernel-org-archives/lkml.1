Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYGRFEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYGRFEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 01:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbYGRFEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 01:04:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:23129 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYGRFEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 01:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=EW+3ktgjvIG768h9jFN7cyRlaRUvlWb1sZm9mpncRhkNfrP5nf+A7UwsnDG+Pp1DRx
         uE0wsi7N/Z54PD24zimb8fwZmzD3Pb7uwi8fKM02dvmU4yEZsJcsNkqRIDvCsPz3SqYd
         DBpF4sPtGLbJEf2f61z47nJ/xogjxsxp+AfTA=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, hjk@linutronix.de, gregkh@suse.de,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 14:04:18 +0900
Message-Id: <20080718050418.16250.59161.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
References: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
Subject: [PATCH 02/06] uio: Pass struct uio_mem to mmap functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This patch makes the UIO code pass a struct uio_mem pointer to the
mmap functions. This change allows us to remove one uio_find_mem()
call and an error check.

The error check can be removed since the struct uio_mem pointer has
already been verified in uio_mmap().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/uio/uio.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- 0002/drivers/uio/uio.c
+++ work/drivers/uio/uio.c	2008-07-18 12:40:42.000000000 +0900
@@ -477,17 +477,10 @@ static struct vm_operations_struct uio_v
 	.fault = uio_vma_fault,
 };
 
-static int uio_mmap_physical(struct vm_area_struct *vma)
+static int uio_mmap_physical(struct vm_area_struct *vma, struct uio_mem *imem)
 {
-	struct uio_mem *imem = uio_find_mem(vma);
-
-	if (!imem)
-		return -EINVAL;
-
 	vma->vm_flags |= VM_IO | VM_RESERVED;
-
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-
 	return remap_pfn_range(vma,
 			       vma->vm_start,
 			       imem->addr >> PAGE_SHIFT,
@@ -495,7 +488,7 @@ static int uio_mmap_physical(struct vm_a
 			       vma->vm_page_prot);
 }
 
-static int uio_mmap_logical(struct vm_area_struct *vma)
+static int uio_mmap_logical(struct vm_area_struct *vma, struct uio_mem *imem)
 {
 	vma->vm_flags |= VM_RESERVED;
 	vma->vm_ops = &uio_vm_ops;
@@ -532,10 +525,10 @@ static int uio_mmap(struct file *filep, 
 
 	switch (imem->memtype) {
 		case UIO_MEM_PHYS:
-			return uio_mmap_physical(vma);
+			return uio_mmap_physical(vma, imem);
 		case UIO_MEM_LOGICAL:
 		case UIO_MEM_VIRTUAL:
-			return uio_mmap_logical(vma);
+			return uio_mmap_logical(vma, imem);
 		default:
 			return -EINVAL;
 	}
