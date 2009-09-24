Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZIXLiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZIXLiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZIXLit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:38:49 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:3810 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZIXLis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:38:48 -0400
X-IronPort-AV: E=Sophos;i="4.44,445,1249272000"; 
   d="scan'208";a="6773356"
From: <graff.yang@gmail.com>
To: <dhowells@redhat.com>, <linux-kernel@vger.kernel.org>
CC: <akpm@linux-foundation.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
       <graf.yang@analog.com>, Graff Yang <graff.yang@gmail.com>
Subject: [PATCH] mm/nommu.c: fix mmap failed due to the vm_region codes
Date: Thu, 24 Sep 2009 19:37:59 +0800
Message-ID: <1253792279-30623-1-git-send-email-graff.yang@gmail.com>
X-Mailer: git-send-email 1.6.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graff Yang <graff.yang@gmail.com>

Due to the new vm_region codes, mmap will failed if it is MAP_PRIVATE,
or the get_unmapped_area() not do actual things.

Signed-off-by: Graff Yang <graff.yang@gmail.com>
---
 mm/nommu.c |   30 +++++++++++++++++++++++-------
 1 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 8d48424..3a5e989 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1067,13 +1067,22 @@ static unsigned long determine_vm_flags(struct file *file,
  * set up a shared mapping on a file (the driver or filesystem provides and
  * pins the storage)
  */
-static int do_mmap_shared_file(struct vm_area_struct *vma)
+static int do_mmap_shared_file(struct vm_area_struct *vma,
+			   struct vm_region *region,
+			   unsigned long len)
 {
 	int ret;
 
 	ret = vma->vm_file->f_op->mmap(vma->vm_file, vma);
 	if (ret == 0) {
-		vma->vm_region->vm_top = vma->vm_region->vm_end;
+		vma->vm_region->vm_top = vma->vm_end;
+		if (region) {
+			if (!region->vm_start)
+				region->vm_start = vma->vm_start;
+			if (!region->vm_end)
+				region->vm_end = vma->vm_end;
+			add_nommu_region(region);
+		}
 		return ret;
 	}
 	if (ret != -ENOSYS)
@@ -1107,7 +1116,12 @@ static int do_mmap_private(struct vm_area_struct *vma,
 		if (ret == 0) {
 			/* shouldn't return success if we're not sharing */
 			BUG_ON(!(vma->vm_flags & VM_MAYSHARE));
-			vma->vm_region->vm_top = vma->vm_region->vm_end;
+			vma->vm_region->vm_top = vma->vm_end;
+			if (!region->vm_start)
+				region->vm_start = vma->vm_start;
+			if (!region->vm_end)
+				region->vm_end = vma->vm_end;
+			add_nommu_region(region);
 			return ret;
 		}
 		if (ret != -ENOSYS)
@@ -1187,6 +1201,7 @@ static int do_mmap_private(struct vm_area_struct *vma,
 		memset(base, 0, rlen);
 	}
 
+	add_nommu_region(region);
 	return 0;
 
 error_free:
@@ -1325,7 +1340,7 @@ unsigned long do_mmap_pgoff(struct file *file,
 				vma->vm_flags |= VM_MAPPED_COPY;
 			} else {
 				kdebug("share mmap");
-				ret = do_mmap_shared_file(vma);
+				ret = do_mmap_shared_file(vma, NULL, 0);
 				if (ret < 0) {
 					vma->vm_region = NULL;
 					vma->vm_start = 0;
@@ -1370,11 +1385,10 @@ unsigned long do_mmap_pgoff(struct file *file,
 	}
 
 	vma->vm_region = region;
-	add_nommu_region(region);
 
 	/* set up the mapping */
 	if (file && vma->vm_flags & VM_SHARED)
-		ret = do_mmap_shared_file(vma);
+		ret = do_mmap_shared_file(vma, region, len);
 	else
 		ret = do_mmap_private(vma, region, len);
 	if (ret < 0)
@@ -1397,7 +1411,9 @@ share:
 	return result;
 
 error_put_region:
-	__put_nommu_region(region);
+	up_write(&nommu_region_sem);
+	fput(region->vm_file);
+	kmem_cache_free(vm_region_jar, region);
 	if (vma) {
 		if (vma->vm_file) {
 			fput(vma->vm_file);
-- 
1.6.1

