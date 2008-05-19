Return-Path: <linux-kernel-owner+w=401wt.eu-S1764326AbYESV60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764326AbYESV60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764127AbYESV5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:57:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:63677 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764060AbYESV5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=PXjsQgMKuDXoHvaiADHXtkGdNwB4w05MBIborOKoTtmNG1PFKFi8r23FhbBSDp1tKqVSQHvm6jPFON2TKGE+e3K0tw+Bs0/LnwQofZ1sukaWdhf0+D/m5jBdatZpcxhlXKovdXfY2ovFcENYZ+hEQh40EOpYeTDBIlXIIQykiGY=
Message-ID: <4831F7C4.2050704@users.sourceforge.net>
Date: Mon, 19 May 2008 23:57:24 +0200
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Swiftdove 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Shailabh Nagar <nagar@watson.ibm.com>, Mark Seger <Mark.Seger@hp.com>
CC: Jes Sorensen <jes@sgi.com>, Chris Sturtivant <csturtiv@sgi.com>,
       Tony Ernst <tee@sgi.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] distinct tgid/tid I/O statistics
References: <482DF0C0.6050208@users.sourceforge.net> <4831BDBA.6090609@linux.vnet.ibm.com> <4831C7E7.2090804@users.sourceforge.net> <4831DE4D.7020602@users.sourceforge.net>
In-Reply-To: <4831DE4D.7020602@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes based on Balbir Singh feedback:
- fix: correcly account children threads i/o activity
- removed CONFIG_TASK_XACCT #ifdefs inside CONFIG_TASK_IO_ACCOUNTING

Tested in latest Linus git.
---
Subject: [PATCH] distinct tgid/tid I/O statistics
From: Andrea Righi <righiandr@users.sourceforge.net>

Report per-thread I/O statistics in /proc/pid/task/tid/io and aggregate
parent I/O statistics in /proc/pid/io. This approach follows the same
model used to account per-process and per-thread CPU times.

As a practial application, this allows for example to quickly find the
top I/O consumer when a process spawns many child threads that perform
the actual I/O work, because the aggregated I/O statistics can always be
found in /proc/pid/io.

Bug reported by Mark Seger <Mark.Seger@hp.com>.

Signed-off-by: Andrea Righi <righiandr@users.sourceforge.net>
---
 fs/proc/base.c        |   84 ++++++++++++++++++++++++++++++++++++++++--------
 include/linux/sched.h |    4 ++
 kernel/exit.c         |   27 ++++++++++++++++
 kernel/fork.c         |    6 +++
 4 files changed, 107 insertions(+), 14 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 808cbdc..b905c6d 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2356,29 +2356,82 @@ static int proc_base_fill_cache(struct file *filp, void *dirent,
 }
 
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-static int proc_pid_io_accounting(struct task_struct *task, char *buffer)
+static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 {
+	unsigned long flags;
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
+		rcu_read_unlock();
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
 }
-#endif
+
+static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
+{
+	return do_io_accounting(task, buffer, 0);
+}
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
index 933e60e..bad9981 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -915,6 +915,12 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
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
