Return-Path: <linux-kernel-owner+w=401wt.eu-S933375AbYBBJwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbYBBJwY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932643AbYBBJvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:51:47 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:43498 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbYBBJvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:51:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gHSu0RNaA4Qs3IwVVJtK4EykJJzR52yTcabNtRr5SR2P4nbuGKDVQlIH0PoDOkQtYTm9SN/jWxZqL8myhUDIv+4ndu0YQ9OKGUOBlcVsyVfDAx5uePpF1HSKbHuGPAd7aKLzNIl510C66ZBG/0L06OxKbtYmu59w4vBFt7eSCkE=
From: Denis Cheng <crquan@gmail.com>
To: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH 3/3] uio: vm_operations_struct ->nopage to ->fault method conversion
Date: Sat,  2 Feb 2008 17:51:37 +0800
Message-Id: <1201945897-32297-3-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201945897-32297-2-git-send-email-crquan@gmail.com>
References: <
 <1201945897-32297-1-git-send-email-crquan@gmail.com>
 <1201945897-32297-2-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/uio/uio.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index cc246fa..47e0c32 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -417,30 +417,27 @@ static void uio_vma_close(struct vm_area_struct *vma)
 	idev->vma_count--;
 }
 
-static struct page *uio_vma_nopage(struct vm_area_struct *vma,
-				   unsigned long address, int *type)
+static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct uio_device *idev = vma->vm_private_data;
-	struct page* page = NOPAGE_SIGBUS;
 
 	int mi = uio_find_mem_index(vma);
 	if (mi < 0)
-		return page;
+		return VM_FAULT_SIGBUS;
 
 	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
-		page = virt_to_page(idev->info->mem[mi].addr);
+		vmf->page = virt_to_page(idev->info->mem[mi].addr);
 	else
-		page = vmalloc_to_page((void*)idev->info->mem[mi].addr);
-	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+		vmf->page = vmalloc_to_page((void *)idev->info->mem[mi].addr);
+	get_page(vmf->page);
+
+	return 0;
 }
 
 static struct vm_operations_struct uio_vm_ops = {
 	.open = uio_vma_open,
 	.close = uio_vma_close,
-	.nopage = uio_vma_nopage,
+	.fault = uio_vma_fault,
 };
 
 static int uio_mmap_physical(struct vm_area_struct *vma)
-- 
1.5.3.8

