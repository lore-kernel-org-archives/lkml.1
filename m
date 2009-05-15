Return-Path: <linux-kernel-owner+w=401wt.eu-S1762468AbZEOOog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762468AbZEOOog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 10:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761475AbZEOOoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 10:44:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:54737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759061AbZEOOn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 10:43:57 -0400
Date: Fri, 15 May 2009 14:43:24 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090515132018.496182835@chello.nl>
References: <20090515132018.496182835@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: per user mlock gift
Message-ID: <tip-789f90fcf6b0b54e655740e9396c954378542c79@git.kernel.org>
Git-Commit-ID: 789f90fcf6b0b54e655740e9396c954378542c79
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 14:43:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  789f90fcf6b0b54e655740e9396c954378542c79
Gitweb:     http://git.kernel.org/tip/789f90fcf6b0b54e655740e9396c954378542c79
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 15 May 2009 15:19:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 15 May 2009 15:26:56 +0200

perf_counter: per user mlock gift

Instead of a per-process mlock gift for perf-counters, use a
per-user gift so that there is less of a DoS potential.

[ Impact: allow less worst-case unprivileged memory consumption ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20090515132018.496182835@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    4 ++++
 kernel/perf_counter.c |   22 +++++++++++++++-------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d185758..ff59d12 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -674,6 +674,10 @@ struct user_struct {
 	struct work_struct work;
 #endif
 #endif
+
+#ifdef CONFIG_PERF_COUNTERS
+	atomic_long_t locked_vm;
+#endif
 };
 
 extern int uids_sysfs_init(void);
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 0173738..93f4a0e 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -45,7 +45,7 @@ static atomic_t nr_munmap_tracking __read_mostly;
 static atomic_t nr_comm_tracking __read_mostly;
 
 int sysctl_perf_counter_priv __read_mostly; /* do we need to be privileged */
-int sysctl_perf_counter_mlock __read_mostly = 128; /* 'free' kb per counter */
+int sysctl_perf_counter_mlock __read_mostly = 512; /* 'free' kb per user */
 
 /*
  * Lock for (sysadmin-configurable) counter reservations:
@@ -1522,6 +1522,9 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 
 	if (atomic_dec_and_mutex_lock(&counter->mmap_count,
 				      &counter->mmap_mutex)) {
+		struct user_struct *user = current_user();
+
+		atomic_long_sub(counter->data->nr_pages + 1, &user->locked_vm);
 		vma->vm_mm->locked_vm -= counter->data->nr_locked;
 		perf_mmap_data_free(counter);
 		mutex_unlock(&counter->mmap_mutex);
@@ -1537,11 +1540,13 @@ static struct vm_operations_struct perf_mmap_vmops = {
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
@@ -1569,15 +1574,17 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		goto unlock;
 	}
 
-	extra = nr_pages /* + 1 only account the data pages */;
-	extra -= sysctl_perf_counter_mlock >> (PAGE_SHIFT - 10);
-	if (extra < 0)
-		extra = 0;
+	user_extra = nr_pages + 1;
+	user_lock_limit = sysctl_perf_counter_mlock >> (PAGE_SHIFT - 10);
+	user_locked = atomic_long_read(&user->locked_vm) + user_extra;
 
-	locked = vma->vm_mm->locked_vm + extra;
+	extra = 0;
+	if (user_locked > user_lock_limit)
+		extra = user_locked - user_lock_limit;
 
 	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
 	lock_limit >>= PAGE_SHIFT;
+	locked = vma->vm_mm->locked_vm + extra;
 
 	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
 		ret = -EPERM;
@@ -1590,6 +1597,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		goto unlock;
 
 	atomic_set(&counter->mmap_count, 1);
+	atomic_long_add(user_extra, &user->locked_vm);
 	vma->vm_mm->locked_vm += extra;
 	counter->data->nr_locked = extra;
 unlock:
