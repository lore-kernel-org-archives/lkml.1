Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbZEESfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbZEESfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 14:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756436AbZEESfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 14:35:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:58325 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850AbZEESfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 14:35:10 -0400
Date: Tue, 5 May 2009 18:34:23 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090505155437.112113632@chello.nl>
References: <20090505155437.112113632@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: provide an mlock threshold
Message-ID: <tip-c5078f78b455fbf67ea71442c7e7ca8acf9ff095@git.kernel.org>
Git-Commit-ID: c5078f78b455fbf67ea71442c7e7ca8acf9ff095
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 05 May 2009 18:34:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5078f78b455fbf67ea71442c7e7ca8acf9ff095
Gitweb:     http://git.kernel.org/tip/c5078f78b455fbf67ea71442c7e7ca8acf9ff095
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 May 2009 17:50:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 5 May 2009 20:18:32 +0200

perf_counter: provide an mlock threshold

Provide a threshold to relax the mlock accounting, increasing usability.

Each counter gets perf_counter_mlock_kb for free.

[ Impact: allow more mmap buffering ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090505155437.112113632@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |   15 +++++++++++----
 kernel/sysctl.c              |    8 ++++++++
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 0fcbf34..00081d8 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -358,6 +358,7 @@ struct file;
 struct perf_mmap_data {
 	struct rcu_head			rcu_head;
 	int				nr_pages;	/* nr of data pages  */
+	int				nr_locked;	/* nr pages mlocked  */
 
 	atomic_t			poll;		/* POLL_ for wakeups */
 	atomic_t			head;		/* write position    */
@@ -575,6 +576,7 @@ struct perf_callchain_entry {
 extern struct perf_callchain_entry *perf_callchain(struct pt_regs *regs);
 
 extern int sysctl_perf_counter_priv;
+extern int sysctl_perf_counter_mlock;
 
 extern void perf_counter_init(void);
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 6e6834e..2d13427 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -44,6 +44,7 @@ static atomic_t nr_munmap_tracking __read_mostly;
 static atomic_t nr_comm_tracking __read_mostly;
 
 int sysctl_perf_counter_priv __read_mostly; /* do we need to be privileged */
+int sysctl_perf_counter_mlock __read_mostly = 128; /* 'free' kb per counter */
 
 /*
  * Lock for (sysadmin-configurable) counter reservations:
@@ -1461,7 +1462,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 
 	if (atomic_dec_and_mutex_lock(&counter->mmap_count,
 				      &counter->mmap_mutex)) {
-		vma->vm_mm->locked_vm -= counter->data->nr_pages + 1;
+		vma->vm_mm->locked_vm -= counter->data->nr_locked;
 		perf_mmap_data_free(counter);
 		mutex_unlock(&counter->mmap_mutex);
 	}
@@ -1480,6 +1481,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long nr_pages;
 	unsigned long locked, lock_limit;
 	int ret = 0;
+	long extra;
 
 	if (!(vma->vm_flags & VM_SHARED) || (vma->vm_flags & VM_WRITE))
 		return -EINVAL;
@@ -1507,8 +1509,12 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		goto unlock;
 	}
 
-	locked = vma->vm_mm->locked_vm;
-	locked += nr_pages + 1;
+	extra = nr_pages /* + 1 only account the data pages */;
+	extra -= sysctl_perf_counter_mlock >> (PAGE_SHIFT - 10);
+	if (extra < 0)
+		extra = 0;
+
+	locked = vma->vm_mm->locked_vm + extra;
 
 	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
 	lock_limit >>= PAGE_SHIFT;
@@ -1524,7 +1530,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		goto unlock;
 
 	atomic_set(&counter->mmap_count, 1);
-	vma->vm_mm->locked_vm += nr_pages + 1;
+	vma->vm_mm->locked_vm += extra;
+	counter->data->nr_locked = extra;
 unlock:
 	mutex_unlock(&counter->mmap_mutex);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8203d70..3b05c2b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -920,6 +920,14 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "perf_counter_mlock_kb",
+		.data		= &sysctl_perf_counter_mlock,
+		.maxlen		= sizeof(sysctl_perf_counter_mlock),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #endif
 /*
  * NOTE: do not add new entries to this table unless you have read
