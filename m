Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbXITUdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbXITUdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXITUdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:33:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51405 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751416AbXITUdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:33:36 -0400
Date: Thu, 20 Sep 2007 15:33:34 -0500
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][VER 4] mspec: handle shrinking virtual memory areas
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070920203335.013542166F4@attica.americas.sgi.com>
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Stress testing revealed the need for more revision.
This is a revision of Andrew's mspec-handle-shrinking-virtual-memory-areas.patch

Version 4: clear/release fetchop pages only when vma_data is no longer shared

Version 3: single thread the clearing of vma_data maddr[]
Version 2: refcount maintained as atomic_t (as before the version 1 patch)

The shrinking of a virtual memory area that is mmap(2)'d to a memory
special file (device drivers/char/mspec.c) can cause a panic.

If the mapped size of the vma (vm_area_struct) is very large, mspec allocates
a large vma_data structure with vmalloc(). But such a vma can be shrunk by
an munmap(2).  The current driver uses the current size of each vma to
deduce whether its vma_data structure was allocated by kmalloc() or vmalloc().
So if the vma was shrunk it appears to have been allocated by kmalloc(),
and mspec attempts to free it with kfree().  This results in a panic.

This patch avoids the panic (by preserving the type of the allocation) and
also makes mspec work correctly as the vma is split into pieces by the
munmap(2)'s.

All vma's derived from such a split vma share the same vma_data structure that
represents all the pages mapped into this set of vma's.  The mpec driver
must be made capable of using the right portion of the structure for each
member vma.  In other words, it must index into the array of page addresses
using the portion of the array that represents the current vma. This is
enabled by storing the vma group's vm_start in the vma_data structure.

The shared vma_data's are not protected by mm->mmap_sem in the fork() case
so the reference count is left as atomic_t.

The vma_data structure may be shared by vma's from multiple tasks, with
no way of knowing which areas are shared or not shared, so release/clear
pages only when the refcount (of vma's) goes to zero.

Diffed against 2.6.23-rc5

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Acked-by: Jes Sorensen <jes@sgi.com>
---
 drivers/char/mspec.c |   64 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 23 deletions(-)

Index: linus.070912/drivers/char/mspec.c
===================================================================
--- linus.070912.orig/drivers/char/mspec.c
+++ linus.070912/drivers/char/mspec.c
@@ -67,7 +67,7 @@
 /*
  * Page types allocated by the device.
  */
-enum {
+enum mspec_page_type {
 	MSPEC_FETCHOP = 1,
 	MSPEC_CACHED,
 	MSPEC_UNCACHED
@@ -83,15 +83,25 @@ static int is_sn2;
  * One of these structures is allocated when an mspec region is mmaped. The
  * structure is pointed to by the vma->vm_private_data field in the vma struct.
  * This structure is used to record the addresses of the mspec pages.
+ * This structure is shared by all vma's that are split off from the
+ * original vma when split_vma()'s are done.
+ *
+ * The refcnt is incremented atomically because mm->mmap_sem does not
+ * protect in fork case where multiple tasks share the vma_data.
  */
 struct vma_data {
 	atomic_t refcnt;	/* Number of vmas sharing the data. */
-	spinlock_t lock;	/* Serialize access to the vma. */
+	spinlock_t lock;	/* Serialize access to this structure. */
 	int count;		/* Number of pages allocated. */
-	int type;		/* Type of pages allocated. */
+	enum mspec_page_type type; /* Type of pages allocated. */
+	int flags;		/* See VMD_xxx below. */
+	unsigned long vm_start;	/* Original (unsplit) base. */
+	unsigned long vm_end;	/* Original (unsplit) end. */
 	unsigned long maddr[0];	/* Array of MSPEC addresses. */
 };
 
+#define VMD_VMALLOCED 0x1	/* vmalloc'd rather than kmalloc'd */
+
 /* used on shub2 to clear FOP cache in the HUB */
 static unsigned long scratch_page[MAX_NUMNODES];
 #define SH2_AMO_CACHE_ENTRIES	4
@@ -129,8 +139,8 @@ mspec_zero_block(unsigned long addr, int
  * mspec_open
  *
  * Called when a device mapping is created by a means other than mmap
- * (via fork, etc.).  Increments the reference count on the underlying
- * mspec data so it is not freed prematurely.
+ * (via fork, munmap, etc.).  Increments the reference count on the
+ * underlying mspec data so it is not freed prematurely.
  */
 static void
 mspec_open(struct vm_area_struct *vma)
@@ -145,40 +155,41 @@ mspec_open(struct vm_area_struct *vma)
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
-	int i, pages, result, vdata_size;
+	int index, last_index;
+	unsigned long my_page;
 
 	vdata = vma->vm_private_data;
+
 	if (!atomic_dec_and_test(&vdata->refcnt))
 		return;
 
-	pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-	vdata_size = sizeof(struct vma_data) + pages * sizeof(long);
-	for (i = 0; i < pages; i++) {
-		if (vdata->maddr[i] == 0)
+	last_index = (vdata->vm_end - vdata->vm_start) >> PAGE_SHIFT;
+	for (index=0; index < last_index; index++) {
+		if (vdata->maddr[index] == 0)
 			continue;
 		/*
 		 * Clear the page before sticking it back
 		 * into the pool.
 		 */
-		result = mspec_zero_block(vdata->maddr[i], PAGE_SIZE);
-		if (!result)
-			uncached_free_page(vdata->maddr[i]);
+		my_page = vdata->maddr[index];
+		vdata->maddr[index] = 0;
+		if (!mspec_zero_block(my_page, PAGE_SIZE))
+			uncached_free_page(my_page);
 		else
 			printk(KERN_WARNING "mspec_close(): "
-			       "failed to zero page %i\n",
-			       result);
+			       "failed to zero page %ld\n", my_page);
 	}
 
-	if (vdata_size <= PAGE_SIZE)
-		kfree(vdata);
-	else
+	if (vdata->flags & VMD_VMALLOCED)
 		vfree(vdata);
+	else
+		kfree(vdata);
 }
 
 
@@ -195,7 +206,8 @@ mspec_nopfn(struct vm_area_struct *vma, 
 	int index;
 	struct vma_data *vdata = vma->vm_private_data;
 
-	index = (address - vma->vm_start) >> PAGE_SHIFT;
+	BUG_ON(address < vdata->vm_start || address >= vdata->vm_end);
+	index = (address - vdata->vm_start) >> PAGE_SHIFT;
 	maddr = (volatile unsigned long) vdata->maddr[index];
 	if (maddr == 0) {
 		maddr = uncached_alloc_page(numa_node_id());
@@ -237,10 +249,11 @@ static struct vm_operations_struct mspec
  * underlying pages.
  */
 static int
-mspec_mmap(struct file *file, struct vm_area_struct *vma, int type)
+mspec_mmap(struct file *file, struct vm_area_struct *vma,
+					enum mspec_page_type type)
 {
 	struct vma_data *vdata;
-	int pages, vdata_size;
+	int pages, vdata_size, flags = 0;
 
 	if (vma->vm_pgoff != 0)
 		return -EINVAL;
@@ -255,12 +268,17 @@ mspec_mmap(struct file *file, struct vm_
 	vdata_size = sizeof(struct vma_data) + pages * sizeof(long);
 	if (vdata_size <= PAGE_SIZE)
 		vdata = kmalloc(vdata_size, GFP_KERNEL);
-	else
+	else {
 		vdata = vmalloc(vdata_size);
+		flags = VMD_VMALLOCED;
+	}
 	if (!vdata)
 		return -ENOMEM;
 	memset(vdata, 0, vdata_size);
 
+	vdata->vm_start = vma->vm_start;
+	vdata->vm_end = vma->vm_end;
+	vdata->flags = flags;
 	vdata->type = type;
 	spin_lock_init(&vdata->lock);
 	vdata->refcnt = ATOMIC_INIT(1);
