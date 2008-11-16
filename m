Return-Path: <linux-kernel-owner+w=401wt.eu-S1756855AbYKPEjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855AbYKPEjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 23:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYKPEhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 23:37:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61349 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbYKPEhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 23:37:32 -0500
Message-ID: <491FA2C5.2000303@cn.fujitsu.com>
Date: Sun, 16 Nov 2008 12:34:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Jes Sorensen <jes@sgi.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] mspec: use simple_malloc()/simple_free()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use simple_malloc()/simple_free() instead of current codes.
and avoid use VMD_VMALLOCED flags

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index 30f095a..2a814f8 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -94,14 +94,11 @@ struct vma_data {
 	spinlock_t lock;	/* Serialize access to this structure. */
 	int count;		/* Number of pages allocated. */
 	enum mspec_page_type type; /* Type of pages allocated. */
-	int flags;		/* See VMD_xxx below. */
 	unsigned long vm_start;	/* Original (unsplit) base. */
 	unsigned long vm_end;	/* Original (unsplit) end. */
 	unsigned long maddr[0];	/* Array of MSPEC addresses. */
 };
 
-#define VMD_VMALLOCED 0x1	/* vmalloc'd rather than kmalloc'd */
-
 /* used on shub2 to clear FOP cache in the HUB */
 static unsigned long scratch_page[MAX_NUMNODES];
 #define SH2_AMO_CACHE_ENTRIES	4
@@ -186,10 +183,7 @@ mspec_close(struct vm_area_struct *vma)
 			       "failed to zero page %ld\n", my_page);
 	}
 
-	if (vdata->flags & VMD_VMALLOCED)
-		vfree(vdata);
-	else
-		kfree(vdata);
+	simple_free(vdata);
 }
 
 /*
@@ -257,7 +251,7 @@ mspec_mmap(struct file *file, struct vm_area_struct *vma,
 					enum mspec_page_type type)
 {
 	struct vma_data *vdata;
-	int pages, vdata_size, flags = 0;
+	int pages, vdata_size;
 
 	if (vma->vm_pgoff != 0)
 		return -EINVAL;
@@ -270,19 +264,13 @@ mspec_mmap(struct file *file, struct vm_area_struct *vma,
 
 	pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	vdata_size = sizeof(struct vma_data) + pages * sizeof(long);
-	if (vdata_size <= PAGE_SIZE)
-		vdata = kmalloc(vdata_size, GFP_KERNEL);
-	else {
-		vdata = vmalloc(vdata_size);
-		flags = VMD_VMALLOCED;
-	}
+	vdata = simple_malloc(vdata_size);
 	if (!vdata)
 		return -ENOMEM;
 	memset(vdata, 0, vdata_size);
 
 	vdata->vm_start = vma->vm_start;
 	vdata->vm_end = vma->vm_end;
-	vdata->flags = flags;
 	vdata->type = type;
 	spin_lock_init(&vdata->lock);
 	vdata->refcnt = ATOMIC_INIT(1);

