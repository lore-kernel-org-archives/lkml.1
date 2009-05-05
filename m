Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbZEEQUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbZEEQUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755669AbZEEQSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:18:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbZEEQSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:18:09 -0400
Message-Id: <20090505155437.112113632@chello.nl>
References: <20090505155020.309162852@chello.nl>
User-Agent: quilt/0.46-1
Date: Tue, 05 May 2009 17:50:24 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/7] perf_counter: provide an mlock threshold
Content-Disposition: inline; filename=perf_counter-mlock-sysctl.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a threshold to relax the mlock accounting, increasing usability.

Each counter gets perf_counter_mlock_kb for free.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |   15 +++++++++++----
 kernel/sysctl.c              |    8 ++++++++
 3 files changed, 21 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
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
 
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -44,6 +44,7 @@ static atomic_t nr_munmap_tracking __rea
 static atomic_t nr_comm_tracking __read_mostly;
 
 int sysctl_perf_counter_priv __read_mostly; /* do we need to be privileged */
+int sysctl_perf_counter_mlock __read_mostly = 128; /* 'free' kb per counter */
 
 /*
  * Lock for (sysadmin-configurable) counter reservations:
@@ -1461,7 +1462,7 @@ static void perf_mmap_close(struct vm_ar
 
 	if (atomic_dec_and_mutex_lock(&counter->mmap_count,
 				      &counter->mmap_mutex)) {
-		vma->vm_mm->locked_vm -= counter->data->nr_pages + 1;
+		vma->vm_mm->locked_vm -= counter->data->nr_locked;
 		perf_mmap_data_free(counter);
 		mutex_unlock(&counter->mmap_mutex);
 	}
@@ -1480,6 +1481,7 @@ static int perf_mmap(struct file *file, 
 	unsigned long nr_pages;
 	unsigned long locked, lock_limit;
 	int ret = 0;
+	long extra;
 
 	if (!(vma->vm_flags & VM_SHARED) || (vma->vm_flags & VM_WRITE))
 		return -EINVAL;
@@ -1507,8 +1509,12 @@ static int perf_mmap(struct file *file, 
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
@@ -1524,7 +1530,8 @@ static int perf_mmap(struct file *file, 
 		goto unlock;
 
 	atomic_set(&counter->mmap_count, 1);
-	vma->vm_mm->locked_vm += nr_pages + 1;
+	vma->vm_mm->locked_vm += extra;
+	counter->data->nr_locked = extra;
 unlock:
 	mutex_unlock(&counter->mmap_mutex);
 
Index: linux-2.6/kernel/sysctl.c
===================================================================
--- linux-2.6.orig/kernel/sysctl.c
+++ linux-2.6/kernel/sysctl.c
@@ -924,6 +924,14 @@ static struct ctl_table kern_table[] = {
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

-- 

