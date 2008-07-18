Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYGRFEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYGRFEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 01:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYGRFEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 01:04:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:23129 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbYGRFEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 01:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=u9zy6cOv2XNcgbL32d09r/cQ4dA4zZ7DqIS0jU/b0dTXNM7Uz6a9+judD5P9sid9nh
         unJJq5HBNjH2KHDujUbUjl5WoEkqVgK57033iTLeUHfFYeQEIDpuA5Cd8s4nqP949hEN
         jLttk3BfA6GvM0AQR88lYHHT8rJxjudGsOYvM=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Magnus Damm <magnus.damm@gmail.com>, hjk@linutronix.de, gregkh@suse.de,
       akpm@linux-foundation.org
Date: Fri, 18 Jul 2008 14:04:27 +0900
Message-Id: <20080718050427.16250.82197.sendpatchset@rx1.opensource.se>
In-Reply-To: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
References: <20080718050402.16250.25213.sendpatchset@rx1.opensource.se>
Subject: [PATCH 03/06] uio: Remove vma->vm_private_data from uio_find_mem()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Pass along a struct uio_device pointer to uio_find_mem() so we can
remove the vma->vm_private_data usage. This allows us to store
different data in vma->vm_private_data in the future.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/uio/uio.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- 0003/drivers/uio/uio.c
+++ work/drivers/uio/uio.c	2008-07-18 12:42:21.000000000 +0900
@@ -427,10 +427,10 @@ static ssize_t uio_read(struct file *fil
 	return retval;
 }
 
-static struct uio_mem *uio_find_mem(struct vm_area_struct *vma)
+static struct uio_mem *uio_find_mem(struct uio_device *idev,
+				    struct vm_area_struct *vma)
 {
 	int mi;
-	struct uio_device *idev = vma->vm_private_data;
 
 	for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
 		if (idev->info->mem[mi].size == 0)
@@ -456,7 +456,7 @@ static void uio_vma_close(struct vm_area
 static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct uio_device *idev = vma->vm_private_data;
-	struct uio_mem *imem = uio_find_mem(vma);
+	struct uio_mem *imem = uio_find_mem(idev, vma);
 	struct page *page;
 
 	if (!imem)
@@ -507,9 +507,7 @@ static int uio_mmap(struct file *filep, 
 	if (vma->vm_end < vma->vm_start)
 		return -EINVAL;
 
-	vma->vm_private_data = idev;
-
-	imem = uio_find_mem(vma);
+	imem = uio_find_mem(idev, vma);
 	if (!imem)
 		return -EINVAL;
 
@@ -523,6 +521,8 @@ static int uio_mmap(struct file *filep, 
 		return ret;
 	}
 
+	vma->vm_private_data = idev;
+
 	switch (imem->memtype) {
 		case UIO_MEM_PHYS:
 			return uio_mmap_physical(vma, imem);
