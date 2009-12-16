Return-Path: <linux-kernel-owner+w=401wt.eu-S1760679AbZLPDKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbZLPDKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZLPDKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:10:37 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50545 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515AbZLPDKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:10:36 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Dec 2009 12:07:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, andi@firstfloor.org,
       minchan.kim@gmail.com
Subject: [mm][RFC][PATCH 7/11] mm accessor for inifiniband
Message-Id: <20091216120724.cb424ed3.kamezawa.hiroyu@jp.fujitsu.com>
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

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Replacing mmap_sem with mm_accessor, for inifiniband.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 drivers/infiniband/core/umem.c                 |   14 +++++++-------
 drivers/infiniband/hw/ipath/ipath_user_pages.c |   12 ++++++------
 drivers/infiniband/hw/ipath/ipath_user_sdma.c  |    4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

Index: mmotm-mm-accessor/drivers/infiniband/hw/ipath/ipath_user_pages.c
===================================================================
--- mmotm-mm-accessor.orig/drivers/infiniband/hw/ipath/ipath_user_pages.c
+++ mmotm-mm-accessor/drivers/infiniband/hw/ipath/ipath_user_pages.c
@@ -162,24 +162,24 @@ int ipath_get_user_pages(unsigned long s
 {
 	int ret;
 
-	down_write(&current->mm->mmap_sem);
+	mm_write_lock(current->mm);
 
 	ret = __get_user_pages(start_page, num_pages, p, NULL);
 
-	up_write(&current->mm->mmap_sem);
+	mm_write_unlock(current->mm);
 
 	return ret;
 }
 
 void ipath_release_user_pages(struct page **p, size_t num_pages)
 {
-	down_write(&current->mm->mmap_sem);
+	mm_write_lock(current->mm);
 
 	__ipath_release_user_pages(p, num_pages, 1);
 
 	current->mm->locked_vm -= num_pages;
 
-	up_write(&current->mm->mmap_sem);
+	mm_write_unlock(current->mm);
 }
 
 struct ipath_user_pages_work {
@@ -193,9 +193,9 @@ static void user_pages_account(struct wo
 	struct ipath_user_pages_work *work =
 		container_of(_work, struct ipath_user_pages_work, work);
 
-	down_write(&work->mm->mmap_sem);
+	mm_write_lock(work->mm);
 	work->mm->locked_vm -= work->num_pages;
-	up_write(&work->mm->mmap_sem);
+	mm_write_unlock(work->mm);
 	mmput(work->mm);
 	kfree(work);
 }
Index: mmotm-mm-accessor/drivers/infiniband/hw/ipath/ipath_user_sdma.c
===================================================================
--- mmotm-mm-accessor.orig/drivers/infiniband/hw/ipath/ipath_user_sdma.c
+++ mmotm-mm-accessor/drivers/infiniband/hw/ipath/ipath_user_sdma.c
@@ -811,9 +811,9 @@ int ipath_user_sdma_writev(struct ipath_
 	while (dim) {
 		const int mxp = 8;
 
-		down_write(&current->mm->mmap_sem);
+		mm_write_lock(current->mm);
 		ret = ipath_user_sdma_queue_pkts(dd, pq, &list, iov, dim, mxp);
-		up_write(&current->mm->mmap_sem);
+		mm_write_unlock(current->mm);
 
 		if (ret <= 0)
 			goto done_unlock;
Index: mmotm-mm-accessor/drivers/infiniband/core/umem.c
===================================================================
--- mmotm-mm-accessor.orig/drivers/infiniband/core/umem.c
+++ mmotm-mm-accessor/drivers/infiniband/core/umem.c
@@ -133,7 +133,7 @@ struct ib_umem *ib_umem_get(struct ib_uc
 
 	npages = PAGE_ALIGN(size + umem->offset) >> PAGE_SHIFT;
 
-	down_write(&current->mm->mmap_sem);
+	mm_write_lock(current->mm);
 
 	locked     = npages + current->mm->locked_vm;
 	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -207,7 +207,7 @@ out:
 	} else
 		current->mm->locked_vm = locked;
 
-	up_write(&current->mm->mmap_sem);
+	mm_write_unlock(current->mm);
 	if (vma_list)
 		free_page((unsigned long) vma_list);
 	free_page((unsigned long) page_list);
@@ -220,9 +220,9 @@ static void ib_umem_account(struct work_
 {
 	struct ib_umem *umem = container_of(work, struct ib_umem, work);
 
-	down_write(&umem->mm->mmap_sem);
+	mm_write_lock(umem->mm);
 	umem->mm->locked_vm -= umem->diff;
-	up_write(&umem->mm->mmap_sem);
+	mm_write_unlock(umem->mm);
 	mmput(umem->mm);
 	kfree(umem);
 }
@@ -256,7 +256,7 @@ void ib_umem_release(struct ib_umem *ume
 	 * we defer the vm_locked accounting to the system workqueue.
 	 */
 	if (context->closing) {
-		if (!down_write_trylock(&mm->mmap_sem)) {
+		if (!mm_write_trylock(mm)) {
 			INIT_WORK(&umem->work, ib_umem_account);
 			umem->mm   = mm;
 			umem->diff = diff;
@@ -265,10 +265,10 @@ void ib_umem_release(struct ib_umem *ume
 			return;
 		}
 	} else
-		down_write(&mm->mmap_sem);
+		mm_write_lock(mm);
 
 	current->mm->locked_vm -= diff;
-	up_write(&mm->mmap_sem);
+	mm_write_unlock(mm);
 	mmput(mm);
 	kfree(umem);
 }

