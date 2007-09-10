Return-Path: <linux-kernel-owner+w=401wt.eu-S1760328AbXIJONs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328AbXIJONs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbXIJONL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:13:11 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45362 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760299AbXIJONJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:13:09 -0400
Message-ID: <46E550E6.8000308@bull.net>
Date: Mon, 10 Sep 2007 16:12:54 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RESEND 2]PATCH 2/4] Introduce a new fields "gtime" and "cgtime"
 in task_struct and signal_struct
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 16:18:48,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 16:18:49,
	Serialize complete at 10/09/2007 16:18:49
Content-Type: multipart/mixed;
 boundary="------------050403060500080008090802"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050403060500080008090802
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

[PATCH 2/4] like for cpustat, introduce the "gtime" (guest time of the task) and
"cgtime" (guest time of the task children) fields for the
tasks. Modify signal_struct and task_struct. Modify /proc/<pid>/stat to display
these new fields.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth



--------------050403060500080008090802
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="proc_task_stat_guest"
Content-Disposition: inline;
 filename="proc_task_stat_guest"

Index: linux-2.6/fs/proc/array.c
===================================================================
--- linux-2.6.orig/fs/proc/array.c	2007-09-10 14:15:54.000000000 +0200
+++ linux-2.6/fs/proc/array.c	2007-09-10 14:21:48.000000000 +0200
@@ -370,6 +370,11 @@ static cputime_t task_stime(struct task_
 }
 #endif
 
+static cputime_t task_gtime(struct task_struct *p)
+{
+	return p->gtime;
+}
+
 static int do_task_stat(struct task_struct *task, char *buffer, int whole)
 {
 	unsigned long vsize, eip, esp, wchan = ~0UL;
@@ -385,6 +390,7 @@ static int do_task_stat(struct task_stru
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
 	unsigned long  min_flt = 0,  maj_flt = 0;
 	cputime_t cutime, cstime, utime, stime;
+	cputime_t cgtime, gtime;
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
@@ -403,6 +409,7 @@ static int do_task_stat(struct task_stru
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
 	cutime = cstime = utime = stime = cputime_zero;
+	cgtime = gtime = cputime_zero;
 
 	rcu_read_lock();
 	if (lock_task_sighand(task, &flags)) {
@@ -420,6 +427,7 @@ static int do_task_stat(struct task_stru
 		cmaj_flt = sig->cmaj_flt;
 		cutime = sig->cutime;
 		cstime = sig->cstime;
+		cgtime = sig->cgtime;
 		rsslim = sig->rlim[RLIMIT_RSS].rlim_cur;
 
 		/* add up live thread stats at the group level */
@@ -430,6 +438,7 @@ static int do_task_stat(struct task_stru
 				maj_flt += t->maj_flt;
 				utime = cputime_add(utime, task_utime(t));
 				stime = cputime_add(stime, task_stime(t));
+				gtime = cputime_add(gtime, task_gtime(t));
 				t = next_thread(t);
 			} while (t != task);
 
@@ -437,6 +446,7 @@ static int do_task_stat(struct task_stru
 			maj_flt += sig->maj_flt;
 			utime = cputime_add(utime, sig->utime);
 			stime = cputime_add(stime, sig->stime);
+			gtime += cputime_add(gtime, sig->gtime);
 		}
 
 		sid = signal_session(sig);
@@ -454,6 +464,7 @@ static int do_task_stat(struct task_stru
 		maj_flt = task->maj_flt;
 		utime = task_utime(task);
 		stime = task_stime(task);
+		gtime = task_gtime(task);
 	}
 
 	/* scale priority and nice values from timeslices to -20..20 */
@@ -471,7 +482,7 @@ static int do_task_stat(struct task_stru
 
 	res = sprintf(buffer, "%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu\n",
+%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
 		task->pid,
 		tcomm,
 		state,
@@ -516,7 +527,9 @@ static int do_task_stat(struct task_stru
 		task_cpu(task),
 		task->rt_priority,
 		task->policy,
-		(unsigned long long)delayacct_blkio_ticks(task));
+		(unsigned long long)delayacct_blkio_ticks(task),
+		cputime_to_clock_t(gtime),
+		cputime_to_clock_t(cgtime));
 	if (mm)
 		mmput(mm);
 	return res;
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h	2007-09-10 14:15:54.000000000 +0200
+++ linux-2.6/include/linux/sched.h	2007-09-10 14:19:30.000000000 +0200
@@ -515,6 +515,8 @@ struct signal_struct {
 	 * in __exit_signal, except for the group leader.
 	 */
 	cputime_t utime, stime, cutime, cstime;
+	cputime_t gtime;
+	cputime_t cgtime;
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
@@ -1022,6 +1024,7 @@ struct task_struct {
 
 	unsigned int rt_priority;
 	cputime_t utime, stime;
+	cputime_t gtime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
Index: linux-2.6/kernel/exit.c
===================================================================
--- linux-2.6.orig/kernel/exit.c	2007-09-10 14:15:54.000000000 +0200
+++ linux-2.6/kernel/exit.c	2007-09-10 14:19:12.000000000 +0200
@@ -120,6 +120,7 @@ static void __exit_signal(struct task_st
 		 */
 		sig->utime = cputime_add(sig->utime, tsk->utime);
 		sig->stime = cputime_add(sig->stime, tsk->stime);
+		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
@@ -1251,6 +1252,11 @@ static int wait_task_zombie(struct task_
 			cputime_add(p->stime,
 			cputime_add(sig->stime,
 				    sig->cstime)));
+		psig->cgtime =
+			cputime_add(psig->cgtime,
+			cputime_add(p->gtime,
+			cputime_add(sig->gtime,
+				    sig->cgtime)));
 		psig->cmin_flt +=
 			p->min_flt + sig->min_flt + sig->cmin_flt;
 		psig->cmaj_flt +=
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c	2007-09-10 14:15:54.000000000 +0200
+++ linux-2.6/kernel/fork.c	2007-09-10 14:18:52.000000000 +0200
@@ -877,6 +877,8 @@ static inline int copy_signal(unsigned l
 	sig->tty_old_pgrp = NULL;
 
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
+	sig->gtime = cputime_zero;
+	sig->cgtime = cputime_zero;
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
@@ -1045,6 +1047,7 @@ static struct task_struct *copy_process(
 
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
+	p->gtime = cputime_zero;
 
 #ifdef CONFIG_TASK_XACCT
 	p->rchar = 0;		/* I/O counter: bytes read */

--------------050403060500080008090802--
