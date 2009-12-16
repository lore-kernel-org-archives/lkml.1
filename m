Return-Path: <linux-kernel-owner+w=401wt.eu-S1761141AbZLPDNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761141AbZLPDNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760228AbZLPDNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:13:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50646 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997AbZLPDNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:13:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Dec 2009 12:10:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, andi@firstfloor.org,
       minchan.kim@gmail.com
Subject: [mm][RFC][PATCH 10/11] mm accessor for misc drivers
Message-Id: <20091216121023.5340308a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm accessor for misc. drivers.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 drivers/dma/iovlock.c          |    4 ++--
 drivers/oprofile/buffer_sync.c |   10 +++++-----
 drivers/scsi/st.c              |    4 ++--
 drivers/video/pvr2fb.c         |    4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

Index: mmotm-mm-accessor/drivers/dma/iovlock.c
===================================================================
--- mmotm-mm-accessor.orig/drivers/dma/iovlock.c
+++ mmotm-mm-accessor/drivers/dma/iovlock.c
@@ -94,7 +94,7 @@ struct dma_pinned_list *dma_pin_iovec_pa
 		pages += page_list->nr_pages;
 
 		/* pin pages down */
-		down_read(&current->mm->mmap_sem);
+		mm_read_lock(current->mm);
 		ret = get_user_pages(
 			current,
 			current->mm,
@@ -104,7 +104,7 @@ struct dma_pinned_list *dma_pin_iovec_pa
 			0,	/* force */
 			page_list->pages,
 			NULL);
-		up_read(&current->mm->mmap_sem);
+		mm_read_unlock(current->mm);
 
 		if (ret != page_list->nr_pages)
 			goto unpin;
Index: mmotm-mm-accessor/drivers/oprofile/buffer_sync.c
===================================================================
--- mmotm-mm-accessor.orig/drivers/oprofile/buffer_sync.c
+++ mmotm-mm-accessor/drivers/oprofile/buffer_sync.c
@@ -87,11 +87,11 @@ munmap_notify(struct notifier_block *sel
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *mpnt;
 
-	down_read(&mm->mmap_sem);
+	mm_read_lock(mm);
 
 	mpnt = find_vma(mm, addr);
 	if (mpnt && mpnt->vm_file && (mpnt->vm_flags & VM_EXEC)) {
-		up_read(&mm->mmap_sem);
+		mm_read_unlock(mm);
 		/* To avoid latency problems, we only process the current CPU,
 		 * hoping that most samples for the task are on this CPU
 		 */
@@ -99,7 +99,7 @@ munmap_notify(struct notifier_block *sel
 		return 0;
 	}
 
-	up_read(&mm->mmap_sem);
+	mm_read_unlock(mm);
 	return 0;
 }
 
@@ -410,7 +410,7 @@ static void release_mm(struct mm_struct 
 {
 	if (!mm)
 		return;
-	up_read(&mm->mmap_sem);
+	mm_read_unlock(mm);
 	mmput(mm);
 }
 
@@ -419,7 +419,7 @@ static struct mm_struct *take_tasks_mm(s
 {
 	struct mm_struct *mm = get_task_mm(task);
 	if (mm)
-		down_read(&mm->mmap_sem);
+		mm_read_lock(mm);
 	return mm;
 }
 
Index: mmotm-mm-accessor/drivers/scsi/st.c
===================================================================
--- mmotm-mm-accessor.orig/drivers/scsi/st.c
+++ mmotm-mm-accessor/drivers/scsi/st.c
@@ -4553,7 +4553,7 @@ static int sgl_map_user_pages(struct st_
 		return -ENOMEM;
 
         /* Try to fault in all of the necessary pages */
-	down_read(&current->mm->mmap_sem);
+	mm_read_lock(current->mm);
         /* rw==READ means read from drive, write into memory area */
 	res = get_user_pages(
 		current,
@@ -4564,7 +4564,7 @@ static int sgl_map_user_pages(struct st_
 		0, /* don't force */
 		pages,
 		NULL);
-	up_read(&current->mm->mmap_sem);
+	mm_read_unlock(current->mm);
 
 	/* Errors and no page mapped should return here */
 	if (res < nr_pages)
Index: mmotm-mm-accessor/drivers/video/pvr2fb.c
===================================================================
--- mmotm-mm-accessor.orig/drivers/video/pvr2fb.c
+++ mmotm-mm-accessor/drivers/video/pvr2fb.c
@@ -686,10 +686,10 @@ static ssize_t pvr2fb_write(struct fb_in
 	if (!pages)
 		return -ENOMEM;
 
-	down_read(&current->mm->mmap_sem);
+	mm_read_lock(current->mm);
 	ret = get_user_pages(current, current->mm, (unsigned long)buf,
 			     nr_pages, WRITE, 0, pages, NULL);
-	up_read(&current->mm->mmap_sem);
+	mm_read_unlock(current->mm);
 
 	if (ret < nr_pages) {
 		nr_pages = ret;

