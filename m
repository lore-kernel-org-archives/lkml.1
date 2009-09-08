Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZIHMKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZIHMKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 08:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZIHMKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 08:10:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46019
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754131AbZIHMKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 08:10:33 -0400
Date: Tue, 08 Sep 2009 05:10:49 -0700 (PDT)
Message-Id: <20090908.051049.141136997.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: a.p.zijlstra@chello.nl, mingo@elte.hu, jens.axboe@oracle.com
Subject: [PATCH 2/2]: perf: Allocate mmap buffer using vmalloc_user().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is necessary to make the mmap ring buffer work properly
on platforms where D-cache aliasing is an issue.

vmalloc_user() ensures that the kernel side mapping is SHMLBA
aligned, and on platforms with D-cache aliasing matters the
presence of VM_SHARED will similarly SHMLBA align the user
side mapping.

Thus the kernel and the user will be writing to the same D-cache
aliases and we'll avoid inconsistencies and corruption.

The only trick with this change is that vfree() cannot be invoked
from interrupt context, and thus it's not allowed from RCU callbacks.

We deal with this by using schedule_work().

Since the ring buffer is now completely linear even on the kernel
side, several simplifications are probably now possible in the code
where we add entries to the ring.

With help from Peter Zijlstra.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/linux/perf_counter.h |    1 +
 kernel/perf_counter.c        |   70 ++++++++++++++++++++++-------------------
 2 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index b53f700..c445b4e 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -503,6 +503,7 @@ struct file;
 
 struct perf_mmap_data {
 	struct rcu_head			rcu_head;
+	struct work_struct		work;
 	int				nr_pages;	/* nr of data pages  */
 	int				writable;	/* are we writable   */
 	int				nr_locked;	/* nr pages mlocked  */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f274e19..71da651 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -23,6 +23,7 @@
 #include <linux/hardirq.h>
 #include <linux/rculist.h>
 #include <linux/uaccess.h>
+#include <linux/vmalloc.h>
 #include <linux/syscalls.h>
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
@@ -2091,7 +2092,7 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		goto unlock;
 
 	if (vmf->pgoff == 0) {
-		vmf->page = virt_to_page(data->user_page);
+		vmf->page = vmalloc_to_page(data->user_page);
 	} else {
 		int nr = vmf->pgoff - 1;
 
@@ -2101,7 +2102,7 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		if (vmf->flags & FAULT_FLAG_WRITE)
 			goto unlock;
 
-		vmf->page = virt_to_page(data->data_pages[nr]);
+		vmf->page = vmalloc_to_page(data->data_pages[nr]);
 	}
 
 	get_page(vmf->page);
@@ -2115,10 +2116,34 @@ unlock:
 	return ret;
 }
 
+static void perf_mmap_unmark_page(void *addr)
+{
+	struct page *page = vmalloc_to_page(addr);
+
+	page->mapping = NULL;
+}
+
+static void perf_mmap_data_free_work(struct work_struct *work)
+{
+	struct perf_mmap_data *data;
+	void *base;
+	int i;
+
+	data = container_of(work, struct perf_mmap_data, work);
+
+	base = data->user_page;
+	for (i = 0; i < data->nr_pages + 1; i++)
+		perf_mmap_unmark_page(base + (i * PAGE_SIZE));
+
+	vfree(base);
+	kfree(data);
+}
+
 static int perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
 {
 	struct perf_mmap_data *data;
 	unsigned long size;
+	void *all_buf;
 	int i;
 
 	WARN_ON(atomic_read(&counter->mmap_count));
@@ -2130,15 +2155,16 @@ static int perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
 	if (!data)
 		goto fail;
 
-	data->user_page = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!data->user_page)
-		goto fail_user_page;
+	INIT_WORK(&data->work, perf_mmap_data_free_work);
 
-	for (i = 0; i < nr_pages; i++) {
-		data->data_pages[i] = (void *)get_zeroed_page(GFP_KERNEL);
-		if (!data->data_pages[i])
-			goto fail_data_pages;
-	}
+	all_buf = vmalloc_user((nr_pages + 1) * PAGE_SIZE);
+	if (!all_buf)
+		goto fail_all_buf;
+
+	data->user_page = all_buf;
+
+	for (i = 0; i < nr_pages; i++)
+		data->data_pages[i] = all_buf + ((i + 1) * PAGE_SIZE);
 
 	data->nr_pages = nr_pages;
 	atomic_set(&data->lock, -1);
@@ -2147,39 +2173,19 @@ static int perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
 
 	return 0;
 
-fail_data_pages:
-	for (i--; i >= 0; i--)
-		free_page((unsigned long)data->data_pages[i]);
-
-	free_page((unsigned long)data->user_page);
-
-fail_user_page:
+fail_all_buf:
 	kfree(data);
 
 fail:
 	return -ENOMEM;
 }
 
-static void perf_mmap_free_page(unsigned long addr)
-{
-	struct page *page = virt_to_page((void *)addr);
-
-	page->mapping = NULL;
-	__free_page(page);
-}
-
 static void __perf_mmap_data_free(struct rcu_head *rcu_head)
 {
 	struct perf_mmap_data *data;
-	int i;
 
 	data = container_of(rcu_head, struct perf_mmap_data, rcu_head);
-
-	perf_mmap_free_page((unsigned long)data->user_page);
-	for (i = 0; i < data->nr_pages; i++)
-		perf_mmap_free_page((unsigned long)data->data_pages[i]);
-
-	kfree(data);
+	schedule_work(&data->work);
 }
 
 static void perf_mmap_data_free(struct perf_counter *counter)
-- 
1.6.4.2

