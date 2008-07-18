Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYGRFFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYGRFFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 01:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbYGRFEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 01:04:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:23129 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbYGRFEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 01:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lR+QcUkx/FAw+Swzunzyn2aRl2VD5KmTsew7EQjFkD+TSR+RSPBhkRlVoPePoshDys
         1b1LYykReno2xPXtvNq8EwBjlSiOIJNTaZ6Zl+wvdT6COhVSuO1LxeDSxgmWt2Ekklo9
         DwF8TmZK47hWcAZ6Acw3cfy4KLzqqZYUm1/bc=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, hjk@linutronix.de, gregkh@suse.de,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 14:04:35 +0900
Message-Id: <20080718050435.16250.39097.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
References: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
Subject: [PATCH 04/06] uio: Store struct uio_mem ptr in vma->vm_private_data
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Store a struct uio_mem pointer in vma->vm_private_data. This improves
performance since it allows us to remove a call to uio_find_mem()
from uio_vma_fault(). This change also moves the vma_count member from
struct uio_device to struct uio_mem.

The VM_FAULT_SIGBUS error case in uio_vma_fault() case is simply
removed since we've verified the struct uio_mem pointer earlier when
setting up the vma->vm_private_data.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/uio/uio.c          |   17 ++++++-----------
 include/linux/uio_driver.h |    1 +
 2 files changed, 7 insertions(+), 11 deletions(-)

--- 0004/drivers/uio/uio.c
+++ work/drivers/uio/uio.c	2008-07-18 12:43:22.000000000 +0900
@@ -32,7 +32,6 @@ struct uio_device {
 	atomic_t		event;
 	struct fasync_struct	*async_queue;
 	wait_queue_head_t	wait;
-	int			vma_count;
 	struct uio_info		*info;
 	struct kobject		*map_dir;
 };
@@ -443,25 +442,21 @@ static struct uio_mem *uio_find_mem(stru
 
 static void uio_vma_open(struct vm_area_struct *vma)
 {
-	struct uio_device *idev = vma->vm_private_data;
-	idev->vma_count++;
+	struct uio_mem *imem = vma->vm_private_data;
+	imem->vma_count++;
 }
 
 static void uio_vma_close(struct vm_area_struct *vma)
 {
-	struct uio_device *idev = vma->vm_private_data;
-	idev->vma_count--;
+	struct uio_mem *imem = vma->vm_private_data;
+	imem->vma_count--;
 }
 
 static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	struct uio_device *idev = vma->vm_private_data;
-	struct uio_mem *imem = uio_find_mem(idev, vma);
+	struct uio_mem *imem = vma->vm_private_data;
 	struct page *page;
 
-	if (!imem)
-		return VM_FAULT_SIGBUS;
-
 	if (imem->memtype == UIO_MEM_LOGICAL)
 		page = virt_to_page(imem->addr);
 	else
@@ -521,7 +516,7 @@ static int uio_mmap(struct file *filep, 
 		return ret;
 	}
 
-	vma->vm_private_data = idev;
+	vma->vm_private_data = imem;
 
 	switch (imem->memtype) {
 		case UIO_MEM_PHYS:
--- 0001/include/linux/uio_driver.h
+++ work/include/linux/uio_driver.h	2008-07-18 12:43:22.000000000 +0900
@@ -34,6 +34,7 @@ struct uio_mem {
 	int			memtype;
 	void __iomem		*internal_addr;
 	struct uio_map		*map;
+	int			vma_count;
 };
 
 #define MAX_UIO_MAPS 	5
