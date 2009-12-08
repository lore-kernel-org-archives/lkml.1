Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbZLHIcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbZLHIcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZLHIb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:31:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488AbZLHIb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:31:57 -0500
Date: Tue, 8 Dec 2009 03:30:57 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Pirko <jpirko@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Message-Id: <20091208083358.4232.28469.sendpatchset@localhost.localdomain>
Subject: [RFC Patch] getrusage: fill ru_ixrss, ru_idrss and ru_isrss fields
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently we always get 0 for ru_ixrss etc. fields with getrusage()
or wait4(). However, GNU time (i.e. /usr/bin/time) uses these fields
to report some statistics, thus we get no useful info if we don't have
a chance to read /proc/<pid>/status.

Jiri worked on this many days ago, but didn't get the patch merged.
After reading all the discussion in that thread [1], I rework on
this, without introducing new fields for task_struct, without using
CONFIG_TASK_XACCT.

In my patch, I first make vm_stat_account() independent of CONFIG_PROC_FS,
so that we can continue to use it to do statistics without procfs.
Then add the corresponding fields in signal_struct, and fill them
in the right place with the values from mm_struct.

A quick test is here:

% strace -v -ewait4 /usr/bin/time -f '%X %p %t' cat /proc/self/status
wait4(4294967295, Name:	cat
...
VmPeak:	   58916 kB
VmSize:	   58916 kB
VmLck:	       0 kB
VmHWM:	     476 kB
VmRSS:	     476 kB
VmData:	     172 kB
VmStk:	      84 kB
VmExe:	      20 kB
VmLib:	    1444 kB
VmPTE:	      40 kB
...
[{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, {ru_utime={0, 0}, ru_stime={0, 999}, ru_maxrss=512, ru_ixrss=1464, ru_idrss=172, ru_isrss=84, ru_minflt=160, ru_majflt=0, ru_nswap=0, ru_inblock=0, ru_oublock=0, ru_msgsnd=0, ru_msgrcv=0, ru_nsignals=0, ru_nvcsw=1, ru_nivcsw=1}) = 4962
--- SIGCHLD (Child exited) @ 0 (0) ---
0 0 0


Please review. Any comments are welcome.

1. http://lkml.org/lkml/2009/1/15/290

Cc: Jiri Pirko <jpirko@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 24c3956..c2607ab 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1245,14 +1245,7 @@ typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
 			       unsigned long size, pte_fn_t fn, void *data);
 
-#ifdef CONFIG_PROC_FS
 void vm_stat_account(struct mm_struct *, unsigned long, struct file *, long);
-#else
-static inline void vm_stat_account(struct mm_struct *mm,
-			unsigned long flags, struct file *file, long pages)
-{
-}
-#endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 extern int debug_pagealloc_enabled;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 89115ec..175ef61 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -631,6 +631,7 @@ struct signal_struct {
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
 	unsigned long maxrss, cmaxrss;
+	unsigned long ixrss, isrss, idrss, cixrss, cisrss, cidrss;
 	struct task_io_accounting ioac;
 
 	/*
@@ -1546,6 +1547,30 @@ struct task_struct {
 	unsigned long stack_start;
 };
 
+static inline unsigned long get_task_ixrss(struct task_struct *p)
+{
+	if (p->mm)
+		return p->mm->exec_vm * (PAGE_SIZE / 1024);
+	return 0;
+}
+static inline unsigned long get_task_isrss(struct task_struct *p)
+{
+	if (p->mm)
+		return p->mm->stack_vm * (PAGE_SIZE / 1024);
+	return 0;
+}
+static inline unsigned long get_task_idrss(struct task_struct *p)
+{
+	struct mm_struct *mm = p->mm;
+	unsigned long size;
+
+	if (mm) {
+		size = mm->total_vm - mm->shared_vm - mm->stack_vm;
+		return size * (PAGE_SIZE / 1024);
+	}
+	return 0;
+}
+
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpumask(tsk) (&(tsk)->cpus_allowed)
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 80ae941..b100cd5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -118,6 +118,9 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
 		sig->nivcsw += tsk->nivcsw;
+		sig->ixrss += get_task_ixrss(tsk);
+		sig->isrss += get_task_isrss(tsk);
+		sig->idrss += get_task_idrss(tsk);
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
@@ -946,8 +949,12 @@ NORET_TYPE void do_exit(long code)
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
 		exit_itimers(tsk->signal);
-		if (tsk->mm)
+		if (tsk->mm) {
 			setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm);
+			tsk->signal->ixrss = get_task_ixrss(tsk);
+			tsk->signal->isrss = get_task_isrss(tsk);
+			tsk->signal->idrss = get_task_idrss(tsk);
+		}
 	}
 	acct_collect(code, group_dead);
 	if (group_dead)
@@ -1265,6 +1272,9 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		maxrss = max(sig->maxrss, sig->cmaxrss);
 		if (psig->cmaxrss < maxrss)
 			psig->cmaxrss = maxrss;
+		psig->cixrss += sig->ixrss + sig->cixrss;
+		psig->cisrss += sig->isrss + sig->cisrss;
+		psig->cidrss += sig->idrss + sig->cidrss;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
 		spin_unlock_irq(&p->real_parent->sighand->siglock);
diff --git a/kernel/fork.c b/kernel/fork.c
index 3d6f121..3688d45 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -891,6 +891,8 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
 	sig->maxrss = sig->cmaxrss = 0;
+	sig->ixrss = sig->isrss = sig->idrss = 0;
+	sig->cixrss = sig->cisrss = sig->cidrss = 0;
 	task_io_accounting_init(&sig->ioac);
 	sig->sum_sched_runtime = 0;
 	taskstats_tgid_init(sig);
diff --git a/kernel/sys.c b/kernel/sys.c
index 9968c5f..013a888 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1331,6 +1331,9 @@ static void accumulate_thread_rusage(struct task_struct *t, struct rusage *r)
 	r->ru_majflt += t->maj_flt;
 	r->ru_inblock += task_io_get_inblock(t);
 	r->ru_oublock += task_io_get_oublock(t);
+	r->ru_ixrss += get_task_ixrss(t);
+	r->ru_isrss += get_task_isrss(t);
+	r->ru_idrss += get_task_idrss(t);
 }
 
 static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
@@ -1365,6 +1368,9 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 			r->ru_inblock = p->signal->cinblock;
 			r->ru_oublock = p->signal->coublock;
 			maxrss = p->signal->cmaxrss;
+			r->ru_ixrss = p->signal->cixrss;
+			r->ru_isrss = p->signal->cisrss;
+			r->ru_idrss = p->signal->cidrss;
 
 			if (who == RUSAGE_CHILDREN)
 				break;
@@ -1379,6 +1385,9 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 			r->ru_majflt += p->signal->maj_flt;
 			r->ru_inblock += p->signal->inblock;
 			r->ru_oublock += p->signal->oublock;
+			r->ru_ixrss += p->signal->ixrss;
+			r->ru_isrss += p->signal->isrss;
+			r->ru_idrss += p->signal->idrss;
 			if (maxrss < p->signal->maxrss)
 				maxrss = p->signal->maxrss;
 			t = p;
diff --git a/mm/mmap.c b/mm/mmap.c
index 292ddc3..7b612a7 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -883,7 +883,6 @@ none:
 	return NULL;
 }
 
-#ifdef CONFIG_PROC_FS
 void vm_stat_account(struct mm_struct *mm, unsigned long flags,
 						struct file *file, long pages)
 {
@@ -899,7 +898,6 @@ void vm_stat_account(struct mm_struct *mm, unsigned long flags,
 	if (flags & (VM_RESERVED|VM_IO))
 		mm->reserved_vm += pages;
 }
-#endif /* CONFIG_PROC_FS */
 
 /*
  * The caller must hold down_write(&current->mm->mmap_sem).
