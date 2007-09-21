Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbXIUABA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbXIUABA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 20:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXIUAAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 20:00:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37162 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751364AbXIUAAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 20:00:53 -0400
Date: Thu, 20 Sep 2007 19:00:51 -0500
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][VER 4] mspec: handle shrinking virtual memory areas
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070921000051.C4C6C3393A7@attica.americas.sgi.com>
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Stress testing revealed the need for (yet more) revision. sorry.

This is a revision of Andrew's mspec-handle-shrinking-virtual-memory-areas.patch

Version 4: clear/release fetchop pages only when vma_data is no longer shared

The vma_data structure may be shared by vma's from multiple tasks, with
no way of knowing which areas are shared or not shared, so release/clear
pages only when the refcount (of vma's) goes to zero.

Diffed against 2.6.23-rc7

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 drivers/char/mspec.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

Index: linus.070920/drivers/char/mspec.c
===================================================================
--- linus.070920.orig/drivers/char/mspec.c
+++ linus.070920/drivers/char/mspec.c
@@ -155,23 +155,22 @@ mspec_open(struct vm_area_struct *vma)
  * mspec_close
  *
  * Called when unmapping a device mapping. Frees all mspec pages
- * belonging to the vma.
+ * belonging to all the vma's sharing this vma_data structure.
  */
 static void
 mspec_close(struct vm_area_struct *vma)
 {
 	struct vma_data *vdata;
-	int index, last_index, result;
+	int index, last_index;
 	unsigned long my_page;
 
 	vdata = vma->vm_private_data;
 
-	BUG_ON(vma->vm_start < vdata->vm_start || vma->vm_end > vdata->vm_end);
+	if (!atomic_dec_and_test(&vdata->refcnt))
+		return;
 
-	spin_lock(&vdata->lock);
-	index = (vma->vm_start - vdata->vm_start) >> PAGE_SHIFT;
-	last_index = (vma->vm_end - vdata->vm_start) >> PAGE_SHIFT;
-	for (; index < last_index; index++) {
+	last_index = (vdata->vm_end - vdata->vm_start) >> PAGE_SHIFT;
+	for (index=0; index < last_index; index++) {
 		if (vdata->maddr[index] == 0)
 			continue;
 		/*
@@ -180,20 +179,12 @@ mspec_close(struct vm_area_struct *vma)
 		 */
 		my_page = vdata->maddr[index];
 		vdata->maddr[index] = 0;
-		spin_unlock(&vdata->lock);
-		result = mspec_zero_block(my_page, PAGE_SIZE);
-		if (!result)
+		if (!mspec_zero_block(my_page, PAGE_SIZE))
 			uncached_free_page(my_page);
 		else
 			printk(KERN_WARNING "mspec_close(): "
-			       "failed to zero page %i\n",
-			       result);
-		spin_lock(&vdata->lock);
+			       "failed to zero page %ld\n", my_page);
 	}
-	spin_unlock(&vdata->lock);
-
-	if (!atomic_dec_and_test(&vdata->refcnt))
-		return;
 
 	if (vdata->flags & VMD_VMALLOCED)
 		vfree(vdata);
@@ -201,7 +192,6 @@ mspec_close(struct vm_area_struct *vma)
 		kfree(vdata);
 }
 
-
 /*
  * mspec_nopfn
  *
