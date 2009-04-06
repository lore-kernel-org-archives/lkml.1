Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZDFJrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZDFJrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbZDFJom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:44:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:42347 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559AbZDFJog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:44:36 -0400
Message-Id: <20090406094517.899767331@chello.nl>
References: <20090406094458.977814421@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 11:45:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/15] perf_counter: fix the mlock accounting
Content-Disposition: inline; filename=perf_counter-finish-mlock-accounting.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading through the code I saw I forgot the finish the mlock accounting.
Do so now.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1461,13 +1461,14 @@ static void perf_mmap_close(struct vm_ar
 
 	if (atomic_dec_and_mutex_lock(&counter->mmap_count,
 				      &counter->mmap_mutex)) {
+		vma->vm_mm->locked_vm -= counter->data->nr_pages + 1;
 		perf_mmap_data_free(counter);
 		mutex_unlock(&counter->mmap_mutex);
 	}
 }
 
 static struct vm_operations_struct perf_mmap_vmops = {
-	.open = perf_mmap_open,
+	.open  = perf_mmap_open,
 	.close = perf_mmap_close,
 	.fault = perf_mmap_fault,
 };
@@ -1499,24 +1500,32 @@ static int perf_mmap(struct file *file, 
 	if (vma->vm_pgoff != 0)
 		return -EINVAL;
 
-	locked = vma_size >>  PAGE_SHIFT;
-	locked += vma->vm_mm->locked_vm;
+	mutex_lock(&counter->mmap_mutex);
+	if (atomic_inc_not_zero(&counter->mmap_count)) {
+		if (nr_pages != counter->data->nr_pages)
+			ret = -EINVAL;
+		goto unlock;
+	}
+
+	locked = vma->vm_mm->locked_vm;
+	locked += nr_pages + 1;
 
 	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
 	lock_limit >>= PAGE_SHIFT;
 
-	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK))
-		return -EPERM;
-
-	mutex_lock(&counter->mmap_mutex);
-	if (atomic_inc_not_zero(&counter->mmap_count))
-		goto out;
+	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+		ret = -EPERM;
+		goto unlock;
+	}
 
 	WARN_ON(counter->data);
 	ret = perf_mmap_data_alloc(counter, nr_pages);
-	if (!ret)
-		atomic_set(&counter->mmap_count, 1);
-out:
+	if (ret)
+		goto unlock;
+
+	atomic_set(&counter->mmap_count, 1);
+	vma->vm_mm->locked_vm += nr_pages + 1;
+unlock:
 	mutex_unlock(&counter->mmap_mutex);
 
 	vma->vm_flags &= ~VM_MAYWRITE;

-- 

