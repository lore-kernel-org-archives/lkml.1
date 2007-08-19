Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbXHSTjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbXHSTjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 15:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXHSTi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 15:38:57 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:59129 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbXHSTi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 15:38:56 -0400
Date: Sun, 19 Aug 2007 21:34:35 +0200
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@engr.sgi.com>, Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] Add all thread stats for TASKSTATS_CMD_ATTR_TGID
Message-ID: <20070819213435.72b287ad@localhost.localdomain>
In-Reply-To: <20070802120427.270e5589.akpm@linux-foundation.org>
References: <3d8471ca0708020653l575db8cam464a3cffce68fb26@mail.gmail.com>
 <20070802120427.270e5589.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TASKSTATS_CMD_ATTR_TGID used to return only the delay accounting stats,
not the basic and extended accounting. With this patch,
TASKSTATS_CMD_ATTR_TGID returns also the min, max or sum (depending on
the semantic of the field) of the accounting info for all threads of a
thread group. This makes TASKSTATS_CMD_ATTR_TGID usable in a similar
fashion to TASKSTATS_CMD_ATTR_PID, for commands like iotop -P
(http://guichaz.free.fr/misc/iotop.py).

Changelog since V1 (http://lkml.org/lkml/2007/8/2/185):
- Update combined stats of exited threads in fill_tgid_exit() as
suggested by Balbir Singh.
- Very light cleanup of fill_tgid_exit() by the way.
- bacct fields are also combined for all threads.
- Instead of assuming memory stats are identical for all threads, we
take the max of all threads (hiwater_rss and hiwater_vm).

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
---

 kernel/taskstats.c |   15 ++++++++++-----
 kernel/tsacct.c    |   43 ++++++++++++++++++++++---------------------
 2 files changed, 32 insertions(+), 26 deletions(-)

diff -r 73eff559debc kernel/taskstats.c
--- a/kernel/taskstats.c	Sat Aug 18 17:15:17 2007 -0700
+++ b/kernel/taskstats.c	Sun Aug 19 17:20:15 2007 +0200
@@ -246,6 +246,8 @@ static int fill_tgid(pid_t tgid, struct 
 
 		stats->nvcsw += tsk->nvcsw;
 		stats->nivcsw += tsk->nivcsw;
+		bacct_add_tsk(stats, tsk);
+		xacct_add_tsk(stats, tsk);
 	} while_each_thread(first, tsk);
 
 	unlock_task_sighand(first, &flags);
@@ -265,21 +267,24 @@ static void fill_tgid_exit(struct task_s
 static void fill_tgid_exit(struct task_struct *tsk)
 {
 	unsigned long flags;
+	struct taskstats *tg_stats;
 
 	spin_lock_irqsave(&tsk->sighand->siglock, flags);
-	if (!tsk->signal->stats)
+	tg_stats = tsk->signal->stats;
+	if (!tg_stats)
 		goto ret;
 
 	/*
 	 * Each accounting subsystem calls its functions here to
 	 * accumalate its per-task stats for tsk, into the per-tgid structure
 	 *
-	 *	per-task-foo(tsk->signal->stats, tsk);
-	 */
-	delayacct_add_tsk(tsk->signal->stats, tsk);
+	 *	per-task-foo(tg_stats, tsk);
+	 */
+	bacct_add_tsk(tg_stats, tsk);
+	xacct_add_tsk(tg_stats, tsk);
+	delayacct_add_tsk(tg_stats, tsk);
 ret:
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
-	return;
 }
 
 static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
diff -r 73eff559debc kernel/tsacct.c
--- a/kernel/tsacct.c	Sat Aug 18 17:15:17 2007 -0700
+++ b/kernel/tsacct.c	Sun Aug 19 17:20:43 2007 +0200
@@ -38,8 +38,9 @@ void bacct_add_tsk(struct taskstats *sta
 	/* rebase elapsed time to usec */
 	ac_etime = timespec_to_ns(&ts);
 	do_div(ac_etime, NSEC_PER_USEC);
-	stats->ac_etime = ac_etime;
-	stats->ac_btime = get_seconds() - ts.tv_sec;
+	stats->ac_etime = max_t(u64, stats->ac_etime, ac_etime);
+	stats->ac_btime = min_t(u32, stats->ac_btime,
+				get_seconds() - ts.tv_sec);
 	if (thread_group_leader(tsk)) {
 		stats->ac_exitcode = tsk->exit_code;
 		if (tsk->flags & PF_FORKNOEXEC)
@@ -60,10 +61,12 @@ void bacct_add_tsk(struct taskstats *sta
 	stats->ac_ppid	 = pid_alive(tsk) ?
 				rcu_dereference(tsk->real_parent)->tgid : 0;
 	rcu_read_unlock();
-	stats->ac_utime	 = cputime_to_msecs(tsk->utime) * USEC_PER_MSEC;
-	stats->ac_stime	 = cputime_to_msecs(tsk->stime) * USEC_PER_MSEC;
-	stats->ac_minflt = tsk->min_flt;
-	stats->ac_majflt = tsk->maj_flt;
+	stats->ac_utime	 = max_t(u64, stats->ac_utime,
+				 cputime_to_msecs(tsk->utime) * USEC_PER_MSEC);
+	stats->ac_stime	 = max_t(u64, stats->ac_stime,
+				 cputime_to_msecs(tsk->stime) * USEC_PER_MSEC);
+	stats->ac_minflt = max_t(u64, stats->ac_minflt, tsk->min_flt);
+	stats->ac_majflt = max_t(u64, stats->ac_majflt, tsk->maj_flt);
 
 	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
 }
@@ -81,27 +84,25 @@ void xacct_add_tsk(struct taskstats *sta
 	struct mm_struct *mm;
 
 	/* convert pages-jiffies to Mbyte-usec */
-	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
-	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
+	stats->coremem += jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
+	stats->virtmem += jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
 	mm = get_task_mm(p);
 	if (mm) {
 		/* adjust to KB unit */
-		stats->hiwater_rss   = mm->hiwater_rss * PAGE_SIZE / KB;
-		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
+		stats->hiwater_rss = max_t(u64, stats->hiwater_rss,
+					   mm->hiwater_rss * PAGE_SIZE / KB);
+		stats->hiwater_vm  = max_t(u64, stats->hiwater_vm,
+					   mm->hiwater_vm * PAGE_SIZE / KB);
 		mmput(mm);
 	}
-	stats->read_char	= p->rchar;
-	stats->write_char	= p->wchar;
-	stats->read_syscalls	= p->syscr;
-	stats->write_syscalls	= p->syscw;
+	stats->read_char	+= p->rchar;
+	stats->write_char	+= p->wchar;
+	stats->read_syscalls	+= p->syscr;
+	stats->write_syscalls	+= p->syscw;
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	stats->read_bytes	= p->ioac.read_bytes;
-	stats->write_bytes	= p->ioac.write_bytes;
-	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes;
-#else
-	stats->read_bytes	= 0;
-	stats->write_bytes	= 0;
-	stats->cancelled_write_bytes = 0;
+	stats->read_bytes	+= p->ioac.read_bytes;
+	stats->write_bytes	+= p->ioac.write_bytes;
+	stats->cancelled_write_bytes += p->ioac.cancelled_write_bytes;
 #endif
 }
 #undef KB
