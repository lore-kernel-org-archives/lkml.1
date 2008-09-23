Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYIWXK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYIWXK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 19:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYIWXKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 19:10:15 -0400
Received: from www.tglx.de ([62.245.132.106]:35484 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYIWXKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 19:10:13 -0400
Date: Wed, 24 Sep 2008 01:10:02 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>, "Andrew G. Harvey" <agh@cisco.com>
Subject: [PATCH] UIO: Fix mapping of logical and virtual memory
Message-ID: <20080923230959.GB4066@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I received this code by private mail from Andrew G. Harvey who found the
bug and provided a fix for it. He also tested the patch below, we
discussed it for a while, and I believe this to be correct. I simply
took his code and made a patch from it, see below.

Thanks to Andrew for pointing this out!

Hans
---------8<----------------

From: "Andrew G. Harvey" <agh@cisco.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Greg KH" <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>
Date: Wed, 24 Sep 2008 00:43:13 +0200
Subject: UIO: Fix mapping of logical and virtual memory

mmap() doesn't work as expected for UIO_MEM_LOGICAL or UIO_MEM_VIRTUAL
mappings. The offset into the memory needs to be added, otherwise
uio_vma_fault always returns the first page only. Note that for UIO
userspace calls mmap() with offset = N * getpagesize() to access
mapping N. This must be compensated when calculating the offset. A
comment was added to explain this since it is not obvious.

Signed-off-by: "Andrew G. Harvey" <agh@cisco.com>
Signed-off-by: "Hans J. Koch" <hjk@linutronix.de>
---
 drivers/uio/uio.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6.27-rc/drivers/uio/uio.c
===================================================================
--- linux-2.6.27-rc.orig/drivers/uio/uio.c	2008-09-24 00:25:17.000000000 +0200
+++ linux-2.6.27-rc/drivers/uio/uio.c	2008-09-24 00:59:40.000000000 +0200
@@ -490,15 +490,23 @@
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
