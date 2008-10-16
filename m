Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbYJPRcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbYJPRcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbYJPRPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:15:12 -0400
Received: from kroah.org ([198.145.64.141]:47054 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753325AbYJPRPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:15:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Andrew G. Harvey" <agh@cisco.com>, "Hans J. Koch" <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 46/46] UIO: Fix mapping of logical and virtual memory
Date: Thu, 16 Oct 2008 10:10:47 -0700
Message-Id: <1224177047-11859-46-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew G. Harvey <agh@cisco.com>

mmap() doesn't work as expected for UIO_MEM_LOGICAL or UIO_MEM_VIRTUAL
mappings. The offset into the memory needs to be added, otherwise
uio_vma_fault always returns the first page only. Note that for UIO
userspace calls mmap() with offset = N * getpagesize() to access
mapping N. This must be compensated when calculating the offset. A
comment was added to explain this since it is not obvious.

Signed-off-by: Andrew G. Harvey <agh@cisco.com>
Signed-off-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/uio/uio.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 557e73e..5dccf05 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -490,15 +490,23 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct uio_device *idev = vma->vm_private_data;
 	struct page *page;
+	unsigned long offset;
 
 	int mi = uio_find_mem_index(vma);
 	if (mi < 0)
 		return VM_FAULT_SIGBUS;
 
+	/*
+	 * We need to subtract mi because userspace uses offset = N*PAGE_SIZE
+	 * to use mem[N].
+	 */
+	offset = (vmf->pgoff - mi) << PAGE_SHIFT;
+
 	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
-		page = virt_to_page(idev->info->mem[mi].addr);
+		page = virt_to_page(idev->info->mem[mi].addr + offset);
 	else
-		page = vmalloc_to_page((void*)idev->info->mem[mi].addr);
+		page = vmalloc_to_page((void *)idev->info->mem[mi].addr
+							+ offset);
 	get_page(page);
 	vmf->page = page;
 	return 0;
-- 
1.6.0.2

