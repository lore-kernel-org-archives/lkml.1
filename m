Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYJAVWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYJAVWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 17:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYJAVWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 17:22:01 -0400
Received: from ns.suse.de ([195.135.220.2]:48454 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYJAVWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 17:22:00 -0400
Subject: patch uio-fix-mapping-of-logical-and-virtual-memory.patch added to gregkh-2.6 tree
To: agh@cisco.com, gregkh@suse.de, hjk@linutronix.de,
       linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Wed, 01 Oct 2008 14:15:19 -0700
In-Reply-To: <20080923230959.GB4066@local>
Message-ID: <12228957191236@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: UIO: Fix mapping of logical and virtual memory

to my gregkh-2.6 tree.  Its filename is

    uio-fix-mapping-of-logical-and-virtual-memory.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From hjk@linutronix.de  Wed Oct  1 14:01:23 2008
From: Andrew Harvey <agh@cisco.com>
Date: Wed, 24 Sep 2008 01:10:02 +0200
Subject: UIO: Fix mapping of logical and virtual memory
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>, "Andrew G. Harvey" <agh@cisco.com>
Message-ID: <20080923230959.GB4066@local>
Content-Disposition: inline

From: "Andrew G. Harvey" <agh@cisco.com>

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
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -490,15 +490,23 @@ static int uio_vma_fault(struct vm_area_
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


Patches currently in gregkh-2.6 which might be from agh@cisco.com are

driver-core/uio-fix-mapping-of-logical-and-virtual-memory.patch
