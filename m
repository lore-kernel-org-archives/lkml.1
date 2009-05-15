Return-Path: <linux-kernel-owner+w=401wt.eu-S1763367AbZEONWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763367AbZEONWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763064AbZEONV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:21:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:48714 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763113AbZEONV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:21:26 -0400
Message-Id: <20090515132018.496182835@chello.nl>
References: <20090515131925.616419905@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 15 May 2009 15:19:27 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] perf_counter: per user mlock gift
Content-Disposition: inline; filename=perf_counter-mlock.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of a per-process mlock gift for perf-counters, use a per-user gift
so that there is less of a DoS potential.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>
---
 include/linux/sched.h |    4 ++++
 kernel/perf_counter.c |   24 ++++++++++++++++--------
 2 files changed, 20 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -45,7 +45,7 @@ static atomic_t nr_munmap_tracking __rea
 static atomic_t nr_comm_tracking __read_mostly;
 
 int sysctl_perf_counter_priv __read_mostly; /* do we need to be privileged */
-int sysctl_perf_counter_mlock __read_mostly = 128; /* 'free' kb per counter */
+int sysctl_perf_counter_mlock __read_mostly = 512; /* 'free' kb per user */
 
 /*
  * Lock for (sysadmin-configurable) counter reservations:
@@ -1522,6 +1522,9 @@ static void perf_mmap_close(struct vm_ar
 
 	if (atomic_dec_and_mutex_lock(&counter->mmap_count,
 				      &counter->mmap_mutex)) {
+		struct user_struct *user = current_user();
+
+		atomic_long_sub(counter->data->nr_pages + 1, &user->locked_vm);
 		vma->vm_mm->locked_vm -= counter->data->nr_locked;
 		perf_mmap_data_free(counter);
 		mutex_unlock(&counter->mmap_mutex);
@@ -1537,11 +1540,13 @@ static struct vm_operations_struct perf_
 static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct perf_counter *counter = file->private_data;
+	struct user_struct *user = current_user();
 	unsigned long vma_size;
 	unsigned long nr_pages;
+	unsigned long user_locked, user_lock_limit;
 	unsigned long locked, lock_limit;
+	long user_extra, extra;
 	int ret = 0;
-	long extra;
 
 	if (!(vma->vm_flags & VM_SHARED) || (vma->vm_flags & VM_WRITE))
 		return -EINVAL;
@@ -1569,15 +1574,17 @@ static int perf_mmap(struct file *file, 
 		goto unlock;
 	}
 
-	extra = nr_pages /* + 1 only account the data pages */;
-	extra -= sysctl_perf_counter_mlock >> (PAGE_SHIFT - 10);
-	if (extra < 0)
-		extra = 0;
-
-	locked = vma->vm_mm->locked_vm + extra;
+	user_extra = nr_pages + 1;
+	user_lock_limit = sysctl_perf_counter_mlock >> (PAGE_SHIFT - 10);
+	user_locked = atomic_long_read(&user->locked_vm) + user_extra;
+
+	extra = 0;
+	if (user_locked > user_lock_limit)
+		extra = user_locked - user_lock_limit;
 
 	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
 	lock_limit >>= PAGE_SHIFT;
+	locked = vma->vm_mm->locked_vm + extra;
 
 	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
 		ret = -EPERM;
@@ -1590,6 +1597,7 @@ static int perf_mmap(struct file *file, 
 		goto unlock;
 
 	atomic_set(&counter->mmap_count, 1);
+	atomic_long_add(user_extra, &user->locked_vm);
 	vma->vm_mm->locked_vm += extra;
 	counter->data->nr_locked = extra;
 unlock:
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -675,6 +675,10 @@ struct user_struct {
 	struct work_struct work;
 #endif
 #endif
+
+#ifdef CONFIG_PERF_COUNTERS
+	atomic_long_t locked_vm;
+#endif
 };
 
 extern int uids_sysfs_init(void);

-- 

