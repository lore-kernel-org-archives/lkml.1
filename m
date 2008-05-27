Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbYE0L2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbYE0L2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 07:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757776AbYE0L2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 07:28:24 -0400
Received: from as4.cineca.com ([130.186.84.251]:55509 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774AbYE0L2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 07:28:23 -0400
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2008 07:28:22 EDT
From: Andrea Righi <righi.andrea@gmail.com>
To: nagar@watson.ibm.com
Cc: Mark.Seger@hp.com, balbir@linux.vnet.ibm.com, matt@bluehost.com,
       jes@sgi.com, csturtiv@sgi.com, tee@sgi.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] Distinct tgid/tid I/O statistics
Message-Id: <1211886575-16111-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Date: Tue, 27 May 2008 13:09:34 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report per-thread I/O statistics in /proc/pid/task/tid/io and aggregate parent
I/O statistics in /proc/pid/io. This approach follows the same model used to
account per-process and per-thread CPU times.

As a practial application, this allows for example to quickly find the top I/O
consumer when a process spawns many child threads that perform the actual I/O
work, because the aggregated I/O statistics can always be found in
/proc/pid/io.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 fs/proc/base.c        |   86 ++++++++++++++++++++++++++++++++++++++++--------
 include/linux/sched.h |    4 ++
 kernel/exit.c         |   27 +++++++++++++++
 kernel/fork.c         |    6 +++
 4 files changed, 108 insertions(+), 15 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index c447e07..37ba5c5 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2356,29 +2356,82 @@ static int proc_base_fill_cache(struct file *filp, void *dirent,
 }
 
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-static int proc_pid_io_accounting(struct task_struct *task, char *buffer)
-{
+static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
+{
+	u64 rchar, wchar, syscr, syscw;
+	struct task_io_accounting ioac;
+
+	if (!whole) {
+		rchar = task->rchar;
+		wchar = task->wchar;
+		syscr = task->syscr;
+		syscw = task->syscw;
+		memcpy(&ioac, &task->ioac, sizeof(ioac));
+	} else {
+		unsigned long flags;
+		struct task_struct *t = task;
+		rchar = wchar = syscr = syscw = 0;
+		memset(&ioac, 0, sizeof(ioac));
+
+		rcu_read_lock();
+		do {
+			rchar += t->rchar;
+			wchar += t->wchar;
+			syscr += t->syscr;
+			syscw += t->syscw;
+
+			ioac.read_bytes += t->ioac.read_bytes;
+			ioac.write_bytes += t->ioac.write_bytes;
+			ioac.cancelled_write_bytes +=
+					t->ioac.cancelled_write_bytes;
+			t = next_thread(t);
+		} while (t != task);
+		rcu_read_unlock();
+
+		if (lock_task_sighand(task, &flags)) {
+			struct signal_struct *sig = task->signal;
+
+			rchar += sig->rchar;
+			wchar += sig->wchar;
+			syscr += sig->syscr;
+			syscw += sig->syscw;
+
+			ioac.read_bytes += sig->ioac.read_bytes;
+			ioac.write_bytes += sig->ioac.write_bytes;
+			ioac.cancelled_write_bytes +=
+					sig->ioac.cancelled_write_bytes;
+
+			unlock_task_sighand(task, &flags);
+		}
+	}
+
 	return sprintf(buffer,
-#ifdef CONFIG_TASK_XACCT
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
 			"syscw: %llu\n"
-#endif
 			"read_bytes: %llu\n"
 			"write_bytes: %llu\n"
 			"cancelled_write_bytes: %llu\n",
-#ifdef CONFIG_TASK_XACCT
-			(unsigned long long)task->rchar,
-			(unsigned long long)task->wchar,
-			(unsigned long long)task->syscr,
-			(unsigned long long)task->syscw,
-#endif
-			(unsigned long long)task->ioac.read_bytes,
-			(unsigned long long)task->ioac.write_bytes,
-			(unsigned long long)task->ioac.cancelled_write_bytes);
+			(unsigned long long)rchar,
+			(unsigned long long)wchar,
+			(unsigned long long)syscr,
+			(unsigned long long)syscw,
+			(unsigned long long)ioac.read_bytes,
+			(unsigned long long)ioac.write_bytes,
+			(unsigned long long)ioac.cancelled_write_bytes);
+}
+
+static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
+{
+	return do_io_accounting(task, buffer, 0);
 }
-#endif
+
+static int proc_tgid_io_accounting(struct task_struct *task, char *buffer)
+{
+	return do_io_accounting(task, buffer, 1);
+}
+#endif /* CONFIG_TASK_IO_ACCOUNTING */
 
 /*
  * Thread groups
@@ -2450,7 +2503,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("coredump_filter", S_IRUGO|S_IWUSR, coredump_filter),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, pid_io_accounting),
+	INF("io",	S_IRUGO, tgid_io_accounting),
 #endif
 };
 
@@ -2778,6 +2831,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
 #endif
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	INF("io",	S_IRUGO, tid_io_accounting),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file * filp,
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5395a61..d4d9adf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -504,6 +504,10 @@ struct signal_struct {
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
+#ifdef CONFIG_TASK_XACCT
+	u64 rchar, wchar, syscr, syscw;
+#endif
+	struct task_io_accounting ioac;
 
 	/*
 	 * Cumulative ns of scheduled CPU time for dead threads in the
diff --git a/kernel/exit.c b/kernel/exit.c
index 1510f78..1f3c0ec 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -120,6 +120,18 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->nivcsw += tsk->nivcsw;
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
+#ifdef CONFIG_TASK_XACCT
+		sig->rchar += tsk->rchar;
+		sig->wchar += tsk->wchar;
+		sig->syscr += tsk->syscr;
+		sig->syscw += tsk->syscw;
+#endif /* CONFIG_TASK_XACCT */
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+		sig->ioac.read_bytes += tsk->ioac.read_bytes;
+		sig->ioac.write_bytes += tsk->ioac.write_bytes;
+		sig->ioac.cancelled_write_bytes +=
+					tsk->ioac.cancelled_write_bytes;
+#endif /* CONFIG_TASK_IO_ACCOUNTING */
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 		sig = NULL; /* Marker for below. */
 	}
@@ -1321,6 +1333,21 @@ static int wait_task_zombie(struct task_struct *p, int noreap,
 		psig->coublock +=
 			task_io_get_oublock(p) +
 			sig->oublock + sig->coublock;
+#ifdef CONFIG_TASK_XACCT
+		psig->rchar += p->rchar + sig->rchar;
+		psig->wchar += p->wchar + sig->wchar;
+		psig->syscr += p->syscr + sig->syscr;
+		psig->syscw += p->syscw + sig->syscw;
+#endif /* CONFIG_TASK_XACCT */
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+		psig->ioac.read_bytes +=
+			p->ioac.read_bytes + sig->ioac.read_bytes;
+		psig->ioac.write_bytes +=
+			p->ioac.write_bytes + sig->ioac.write_bytes;
+		psig->ioac.cancelled_write_bytes +=
+				p->ioac.cancelled_write_bytes +
+				sig->ioac.cancelled_write_bytes;
+#endif /* CONFIG_TASK_IO_ACCOUNTING */
 		spin_unlock_irq(&p->parent->sighand->siglock);
 	}
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 19908b2..b495758 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -785,6 +785,12 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
+#ifdef CONFIG_TASK_XACCT
+	sig->rchar = sig->wchar = sig->syscr = sig->syscw = 0;
+#endif
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	memset(&sig->ioac, 0, sizeof(sig->ioac));
+#endif
 	sig->sum_sched_runtime = 0;
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
-- 
1.5.4.3

