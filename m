Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbZDGJJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbZDGJJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbZDGJIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:08:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:47030 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688AbZDGJIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:08:42 -0400
Date: Tue, 7 Apr 2009 09:08:01 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094517.899767331@chello.nl>
References: <20090406094517.899767331@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: fix the mlock accounting
Message-ID: <tip-ebb3c4c4cb81d64cc041356915ec015e2c57092a@git.kernel.org>
Git-Commit-ID: ebb3c4c4cb81d64cc041356915ec015e2c57092a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:08:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ebb3c4c4cb81d64cc041356915ec015e2c57092a
Gitweb:     http://git.kernel.org/tip/ebb3c4c4cb81d64cc041356915ec015e2c57092a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:45:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:48:57 +0200

perf_counter: fix the mlock accounting

Reading through the code I saw I forgot the finish the mlock accounting.
Do so now.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094517.899767331@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 195e976..c841563 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1461,13 +1461,14 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 
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
@@ -1499,24 +1500,32 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
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
