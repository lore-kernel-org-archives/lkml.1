Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbYG0P33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbYG0P33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 11:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYG0P3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 11:29:22 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:23578 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYG0P3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 11:29:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=h98dHFzjADPfEJ/4A7R5O5JS2slKI8/g2nqmk/cPu7/XCVT6hx+LSoh8K4qrwk+wSG
         BGFoVIO8JXcaQ70fi8FojhC+NLH26Wdcw2zbeqF9r/a3JRTG3JSLCeQRU0MXO/XlokFe
         OqPho0gm9Z9nhgbDz6n/USGB7WT2Qh6dfZFHc=
From: Andrea Righi <righi.andrea@gmail.com>
To: torvalds@linux-foundation.org
Cc: Oleg Nesterov <oleg@tv-sign.ru>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com, matt@bluehost.com,
       linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH 1/1] task IO accounting: improve code readability
Date: Sun, 27 Jul 2008 17:29:15 +0200
Message-Id: <1217172555-8335-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put all i/o statistics in struct proc_io_accounting and use inline functions to
initialize and increment statistics, removing a lot of single variable
assignments.

This also reduces the kernel size as following (with CONFIG_TASK_XACCT=y and
CONFIG_TASK_IO_ACCOUNTING=y).

    text    data     bss     dec     hex filename
   11651       0       0   11651    2d83 kernel/exit.o.before
   11619       0       0   11619    2d63 kernel/exit.o.after
   10886     132     136   11154    2b92 kernel/fork.o.before
   10758     132     136   11026    2b12 kernel/fork.o.after

 3082029  807968 4818600 8708597  84e1f5 vmlinux.o.before
 3081869  807968 4818600 8708437  84e155 vmlinux.o.after

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 fs/proc/base.c                         |   57 +++++++++-----------------------
 include/linux/sched.h                  |   19 +++-------
 include/linux/task_io_accounting.h     |   27 +++++++++++++--
 include/linux/task_io_accounting_ops.h |   56 +++++++++++++++++++++++++-----
 kernel/exit.c                          |   30 ++---------------
 kernel/fork.c                          |   15 +-------
 kernel/tsacct.c                        |   14 ++++----
 7 files changed, 104 insertions(+), 114 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index e74308b..3d94906 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -53,6 +53,7 @@
 #include <linux/time.h>
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
+#include <linux/task_io_accounting_ops.h>
 #include <linux/init.h>
 #include <linux/capability.h>
 #include <linux/file.h>
@@ -2402,44 +2403,17 @@ static int proc_base_fill_cache(struct file *filp, void *dirent,
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 {
-	u64 rchar, wchar, syscr, syscw;
-	struct task_io_accounting ioac;
-
-	rchar = task->rchar;
-	wchar = task->wchar;
-	syscr = task->syscr;
-	syscw = task->syscw;
-	memcpy(&ioac, &task->ioac, sizeof(ioac));
-
-	if (whole) {
-		unsigned long flags;
-
-		if (lock_task_sighand(task, &flags)) {
-			struct signal_struct *sig = task->signal;
-			struct task_struct *t = task;
-
-			rchar += sig->rchar;
-			wchar += sig->wchar;
-			syscr += sig->syscr;
-			syscw += sig->syscw;
-
-			ioac.read_bytes += sig->ioac.read_bytes;
-			ioac.write_bytes += sig->ioac.write_bytes;
-			ioac.cancelled_write_bytes +=
-					sig->ioac.cancelled_write_bytes;
-			while_each_thread(task, t) {
-				rchar += t->rchar;
-				wchar += t->wchar;
-				syscr += t->syscr;
-				syscw += t->syscw;
-
-				ioac.read_bytes += t->ioac.read_bytes;
-				ioac.write_bytes += t->ioac.write_bytes;
-				ioac.cancelled_write_bytes +=
-					t->ioac.cancelled_write_bytes;
-			}
-			unlock_task_sighand(task, &flags);
-		}
+	struct proc_io_accounting acct = task->ioac;
+	unsigned long flags;
+
+	if (whole && lock_task_sighand(task, &flags)) {
+		struct task_struct *t = task;
+
+		task_io_accounting_add(&acct, &task->signal->ioac);
+		while_each_thread(task, t)
+			task_io_accounting_add(&acct, &t->ioac);
+
+		unlock_task_sighand(task, &flags);
 	}
 	return sprintf(buffer,
 			"rchar: %llu\n"
@@ -2449,9 +2423,10 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 			"read_bytes: %llu\n"
 			"write_bytes: %llu\n"
 			"cancelled_write_bytes: %llu\n",
-			rchar, wchar, syscr, syscw,
-			ioac.read_bytes, ioac.write_bytes,
-			ioac.cancelled_write_bytes);
+			acct.chr.rchar, acct.chr.wchar,
+			acct.chr.syscr, acct.chr.syscw,
+			acct.blk.read_bytes, acct.blk.write_bytes,
+			acct.blk.cancelled_write_bytes);
 }
 
 static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f59318a..034c1ca 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -505,10 +505,7 @@ struct signal_struct {
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
-#ifdef CONFIG_TASK_XACCT
-	u64 rchar, wchar, syscr, syscw;
-#endif
-	struct task_io_accounting ioac;
+	struct proc_io_accounting ioac;
 
 	/*
 	 * Cumulative ns of scheduled CPU time for dead threads in the
@@ -1256,11 +1253,7 @@ struct task_struct {
 
 	unsigned long ptrace_message;
 	siginfo_t *last_siginfo; /* For ptrace use.  */
-#ifdef CONFIG_TASK_XACCT
-/* i/o counters(bytes read/written, #syscalls */
-	u64 rchar, wchar, syscr, syscw;
-#endif
-	struct task_io_accounting ioac;
+	struct proc_io_accounting ioac;
 #if defined(CONFIG_TASK_XACCT)
 	u64 acct_rss_mem1;	/* accumulated rss usage */
 	u64 acct_vm_mem1;	/* accumulated virtual memory usage */
@@ -2190,22 +2183,22 @@ extern long sched_group_rt_period(struct task_group *tg);
 #ifdef CONFIG_TASK_XACCT
 static inline void add_rchar(struct task_struct *tsk, ssize_t amt)
 {
-	tsk->rchar += amt;
+	tsk->ioac.chr.rchar += amt;
 }
 
 static inline void add_wchar(struct task_struct *tsk, ssize_t amt)
 {
-	tsk->wchar += amt;
+	tsk->ioac.chr.wchar += amt;
 }
 
 static inline void inc_syscr(struct task_struct *tsk)
 {
-	tsk->syscr++;
+	tsk->ioac.chr.syscr++;
 }
 
 static inline void inc_syscw(struct task_struct *tsk)
 {
-	tsk->syscw++;
+	tsk->ioac.chr.syscw++;
 }
 #else
 static inline void add_rchar(struct task_struct *tsk, ssize_t amt)
diff --git a/include/linux/task_io_accounting.h b/include/linux/task_io_accounting.h
index 44d00e9..165390f 100644
--- a/include/linux/task_io_accounting.h
+++ b/include/linux/task_io_accounting.h
@@ -1,5 +1,5 @@
 /*
- * task_io_accounting: a structure which is used for recording a single task's
+ * proc_io_accounting: a structure which is used for recording a single task's
  * IO statistics.
  *
  * Don't include this header file directly - it is designed to be dragged in via
@@ -8,6 +8,22 @@
  * Blame akpm@osdl.org for all this.
  */
 
+#ifdef CONFIG_TASK_XACCT
+struct task_chr_io_accounting {
+	/* bytes read */
+	u64 rchar;
+	/*  bytes written */
+	u64 wchar;
+	/* # of read syscalls */
+	u64 syscr;
+	/* # of write syscalls */
+	u64 syscw;
+};
+#else /* CONFIG_TASK_XACCT */
+struct task_chr_io_accounting {
+};
+#endif /* CONFIG_TASK_XACCT */
+
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 struct task_io_accounting {
 	/*
@@ -31,7 +47,12 @@ struct task_io_accounting {
 	 */
 	u64 cancelled_write_bytes;
 };
-#else
+#else /* CONFIG_TASK_IO_ACCOUNTING */
 struct task_io_accounting {
 };
-#endif
+#endif /* CONFIG_TASK_IO_ACCOUNTING */
+
+struct proc_io_accounting {
+	struct task_chr_io_accounting chr;
+	struct task_io_accounting blk;
+};
diff --git a/include/linux/task_io_accounting_ops.h b/include/linux/task_io_accounting_ops.h
index ff46c6f..e6f958e 100644
--- a/include/linux/task_io_accounting_ops.h
+++ b/include/linux/task_io_accounting_ops.h
@@ -9,7 +9,7 @@
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 static inline void task_io_account_read(size_t bytes)
 {
-	current->ioac.read_bytes += bytes;
+	current->ioac.blk.read_bytes += bytes;
 }
 
 /*
@@ -18,12 +18,12 @@ static inline void task_io_account_read(size_t bytes)
  */
 static inline unsigned long task_io_get_inblock(const struct task_struct *p)
 {
-	return p->ioac.read_bytes >> 9;
+	return p->ioac.blk.read_bytes >> 9;
 }
 
 static inline void task_io_account_write(size_t bytes)
 {
-	current->ioac.write_bytes += bytes;
+	current->ioac.blk.write_bytes += bytes;
 }
 
 /*
@@ -32,17 +32,25 @@ static inline void task_io_account_write(size_t bytes)
  */
 static inline unsigned long task_io_get_oublock(const struct task_struct *p)
 {
-	return p->ioac.write_bytes >> 9;
+	return p->ioac.blk.write_bytes >> 9;
 }
 
 static inline void task_io_account_cancelled_write(size_t bytes)
 {
-	current->ioac.cancelled_write_bytes += bytes;
+	current->ioac.blk.cancelled_write_bytes += bytes;
 }
 
-static inline void task_io_accounting_init(struct task_struct *tsk)
+static inline void task_io_accounting_init(struct proc_io_accounting *ioac)
 {
-	memset(&tsk->ioac, 0, sizeof(tsk->ioac));
+	memset(ioac, 0, sizeof(*ioac));
+}
+
+static inline void task_blk_io_accounting_add(struct proc_io_accounting *dst,
+						struct proc_io_accounting *src)
+{
+	dst->blk.read_bytes += src->blk.read_bytes;
+	dst->blk.write_bytes += src->blk.write_bytes;
+	dst->blk.cancelled_write_bytes += src->blk.cancelled_write_bytes;
 }
 
 #else
@@ -69,9 +77,37 @@ static inline void task_io_account_cancelled_write(size_t bytes)
 {
 }
 
-static inline void task_io_accounting_init(struct task_struct *tsk)
+static inline void task_io_accounting_init(struct proc_io_accounting *ioac)
+{
+}
+
+static inline void task_blk_io_accounting_add(struct proc_io_accounting *dst,
+						struct proc_io_accounting *src)
 {
 }
 
-#endif		/* CONFIG_TASK_IO_ACCOUNTING */
-#endif		/* __TASK_IO_ACCOUNTING_OPS_INCLUDED */
+#endif /* CONFIG_TASK_IO_ACCOUNTING */
+
+#ifdef CONFIG_TASK_XACCT
+static inline void task_chr_io_accounting_add(struct proc_io_accounting *dst,
+						struct proc_io_accounting *src)
+{
+	dst->chr.rchar += src->chr.rchar;
+	dst->chr.wchar += src->chr.wchar;
+	dst->chr.syscr += src->chr.syscr;
+	dst->chr.syscw += src->chr.syscw;
+}
+#else
+static inline void task_chr_io_accounting_add(struct proc_io_accounting *dst,
+						struct proc_io_accounting *src)
+{
+}
+#endif /* CONFIG_TASK_XACCT */
+
+static inline void task_io_accounting_add(struct proc_io_accounting *dst,
+						struct proc_io_accounting *src)
+{
+	task_chr_io_accounting_add(dst, src);
+	task_blk_io_accounting_add(dst, src);
+}
+#endif /* __TASK_IO_ACCOUNTING_OPS_INCLUDED */
diff --git a/kernel/exit.c b/kernel/exit.c
index 0caf590..eb4d647 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -121,18 +121,7 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->nivcsw += tsk->nivcsw;
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
-#ifdef CONFIG_TASK_XACCT
-		sig->rchar += tsk->rchar;
-		sig->wchar += tsk->wchar;
-		sig->syscr += tsk->syscr;
-		sig->syscw += tsk->syscw;
-#endif /* CONFIG_TASK_XACCT */
-#ifdef CONFIG_TASK_IO_ACCOUNTING
-		sig->ioac.read_bytes += tsk->ioac.read_bytes;
-		sig->ioac.write_bytes += tsk->ioac.write_bytes;
-		sig->ioac.cancelled_write_bytes +=
-					tsk->ioac.cancelled_write_bytes;
-#endif /* CONFIG_TASK_IO_ACCOUNTING */
+		task_io_accounting_add(&sig->ioac, &tsk->ioac);
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 		sig = NULL; /* Marker for below. */
 	}
@@ -1363,21 +1352,8 @@ static int wait_task_zombie(struct task_struct *p, int options,
 		psig->coublock +=
 			task_io_get_oublock(p) +
 			sig->oublock + sig->coublock;
-#ifdef CONFIG_TASK_XACCT
-		psig->rchar += p->rchar + sig->rchar;
-		psig->wchar += p->wchar + sig->wchar;
-		psig->syscr += p->syscr + sig->syscr;
-		psig->syscw += p->syscw + sig->syscw;
-#endif /* CONFIG_TASK_XACCT */
-#ifdef CONFIG_TASK_IO_ACCOUNTING
-		psig->ioac.read_bytes +=
-			p->ioac.read_bytes + sig->ioac.read_bytes;
-		psig->ioac.write_bytes +=
-			p->ioac.write_bytes + sig->ioac.write_bytes;
-		psig->ioac.cancelled_write_bytes +=
-				p->ioac.cancelled_write_bytes +
-				sig->ioac.cancelled_write_bytes;
-#endif /* CONFIG_TASK_IO_ACCOUNTING */
+		task_io_accounting_add(&psig->ioac, &p->ioac);
+		task_io_accounting_add(&psig->ioac, &sig->ioac);
 		spin_unlock_irq(&p->parent->sighand->siglock);
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 5e050c1..8214ba7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -806,12 +806,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
-#ifdef CONFIG_TASK_XACCT
-	sig->rchar = sig->wchar = sig->syscr = sig->syscw = 0;
-#endif
-#ifdef CONFIG_TASK_IO_ACCOUNTING
-	memset(&sig->ioac, 0, sizeof(sig->ioac));
-#endif
+	task_io_accounting_init(&sig->ioac);
 	sig->sum_sched_runtime = 0;
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
@@ -994,13 +989,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->last_switch_timestamp = 0;
 #endif
 
-#ifdef CONFIG_TASK_XACCT
-	p->rchar = 0;		/* I/O counter: bytes read */
-	p->wchar = 0;		/* I/O counter: bytes written */
-	p->syscr = 0;		/* I/O counter: read syscalls */
-	p->syscw = 0;		/* I/O counter: write syscalls */
-#endif
-	task_io_accounting_init(p);
+	task_io_accounting_init(&p->ioac);
 	acct_clear_integrals(p);
 
 	p->it_virt_expires = cputime_zero;
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 3da47cc..f9cd256 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -94,14 +94,14 @@ void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
 		mmput(mm);
 	}
-	stats->read_char	= p->rchar;
-	stats->write_char	= p->wchar;
-	stats->read_syscalls	= p->syscr;
-	stats->write_syscalls	= p->syscw;
+	stats->read_char	= p->ioac.chr.rchar;
+	stats->write_char	= p->ioac.chr.wchar;
+	stats->read_syscalls	= p->ioac.chr.syscr;
+	stats->write_syscalls	= p->ioac.chr.syscw;
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	stats->read_bytes	= p->ioac.read_bytes;
-	stats->write_bytes	= p->ioac.write_bytes;
-	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes;
+	stats->read_bytes	= p->ioac.blk.read_bytes;
+	stats->write_bytes	= p->ioac.blk.write_bytes;
+	stats->cancelled_write_bytes = p->ioac.blk.cancelled_write_bytes;
 #else
 	stats->read_bytes	= 0;
 	stats->write_bytes	= 0;
-- 
1.5.4.3

