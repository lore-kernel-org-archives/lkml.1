Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbXHTNOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbXHTNOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 09:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbXHTNNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 09:13:51 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39396 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbXHTNNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 09:13:48 -0400
Message-ID: <46C99392.3050205@bull.net>
Date: Mon, 20 Aug 2007 15:13:54 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: [PATCH 2/4] Introduce a new fields "gtime" and "cgtime" in task_struct
 and signal_struct
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 15:19:01,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/08/2007 15:19:02,
	Serialize complete at 20/08/2007 15:19:02
Content-Type: multipart/mixed;
 boundary="------------020805080407010105080809"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020805080407010105080809
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

--------------020805080407010105080809
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="proc_task_stat_guest"
Content-Disposition: inline;
 filename="proc_task_stat_guest"

Index: kvm/fs/proc/array.c
===================================================================
--- kvm.orig/fs/proc/array.c	2007-08-20 11:11:30.000000000 +0200
+++ kvm/fs/proc/array.c	2007-08-20 13:04:03.000000000 +0200
@@ -354,6 +354,15 @@ static clock_t task_stime(struct task_st
 	return stime;
 }
 
+#ifdef CONFIG_GUEST_ACCOUNTING
+static clock_t task_gtime(struct task_struct *p)
+{
+	clock_t gtime = cputime_to_clock_t(p->gtime);
+
+	return gtime;
+}
+#endif
+
 static int do_task_stat(struct task_struct *task, char *buffer, int whole)
 {
 	unsigned long vsize, eip, esp, wchan = ~0UL;
@@ -369,6 +378,10 @@ static int do_task_stat(struct task_stru
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
 	unsigned long  min_flt = 0,  maj_flt = 0;
 	cputime_t cutime, cstime;
+#ifdef CONFIG_GUEST_ACCOUNTING
+	cputime_t cgtime;
+	clock_t gtime;
+#endif
 	clock_t utime, stime;
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
@@ -388,6 +401,10 @@ static int do_task_stat(struct task_stru
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
 	cutime = cstime = cputime_zero;
+#ifdef CONFIG_GUEST_ACCOUNTING
+	cgtime = cputime_zero;
+	gtime = 0;
+#endif
 	utime = stime = 0;
 
 	rcu_read_lock();
@@ -406,6 +423,9 @@ static int do_task_stat(struct task_stru
 		cmaj_flt = sig->cmaj_flt;
 		cutime = sig->cutime;
 		cstime = sig->cstime;
+#ifdef CONFIG_GUEST_ACCOUNTING
+		cgtime = sig->cgtime;
+#endif
 		rsslim = sig->rlim[RLIMIT_RSS].rlim_cur;
 
 		/* add up live thread stats at the group level */
@@ -416,6 +436,9 @@ static int do_task_stat(struct task_stru
 				maj_flt += t->maj_flt;
 				utime += task_utime(t);
 				stime += task_stime(t);
+#ifdef CONFIG_GUEST_ACCOUNTING
+				gtime += task_gtime(t);
+#endif
 				t = next_thread(t);
 			} while (t != task);
 
@@ -423,6 +446,9 @@ static int do_task_stat(struct task_stru
 			maj_flt += sig->maj_flt;
 			utime += cputime_to_clock_t(sig->utime);
 			stime += cputime_to_clock_t(sig->stime);
+#ifdef CONFIG_GUEST_ACCOUNTING
+			gtime += cputime_to_clock_t(sig->gtime);
+#endif
 		}
 
 		sid = signal_session(sig);
@@ -440,6 +466,9 @@ static int do_task_stat(struct task_stru
 		maj_flt = task->maj_flt;
 		utime = task_utime(task);
 		stime = task_stime(task);
+#ifdef CONFIG_GUEST_ACCOUNTING
+		gtime = task_gtime(task);
+#endif
 	}
 
 	/* scale priority and nice values from timeslices to -20..20 */
@@ -455,9 +484,13 @@ static int do_task_stat(struct task_stru
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
-	res = sprintf(buffer, "%d (%s) %c %d %d %d %d %d %u %lu \
-%lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu\n",
+	res = sprintf(buffer, "%d (%s) %c %d %d %d %d %d %u %lu "
+"%lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu "
+#ifdef CONFIG_GUEST_ACCOUNTING
+"%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
+#else
+"%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu\n",
+#endif
 		task->pid,
 		tcomm,
 		state,
@@ -502,7 +535,13 @@ static int do_task_stat(struct task_stru
 		task_cpu(task),
 		task->rt_priority,
 		task->policy,
+#ifdef CONFIG_GUEST_ACCOUNTING
+		(unsigned long long)delayacct_blkio_ticks(task),
+		gtime,
+		cputime_to_clock_t(cgtime));
+#else
 		(unsigned long long)delayacct_blkio_ticks(task));
+#endif
 	if (mm)
 		mmput(mm);
 	return res;
Index: kvm/include/linux/sched.h
===================================================================
--- kvm.orig/include/linux/sched.h	2007-08-20 11:11:30.000000000 +0200
+++ kvm/include/linux/sched.h	2007-08-20 13:00:02.000000000 +0200
@@ -515,6 +515,10 @@ struct signal_struct {
 	 * in __exit_signal, except for the group leader.
 	 */
 	cputime_t utime, stime, cutime, cstime;
+#ifdef CONFIG_GUEST_ACCOUNTING
+	cputime_t gtime;
+	cputime_t cgtime;
+#endif
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
@@ -1019,6 +1023,9 @@ struct task_struct {
 
 	unsigned int rt_priority;
 	cputime_t utime, stime;
+#ifdef CONFIG_GUEST_ACCOUNTING
+	cputime_t gtime;
+#endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
Index: kvm/kernel/exit.c
===================================================================
--- kvm.orig/kernel/exit.c	2007-08-20 11:11:30.000000000 +0200
+++ kvm/kernel/exit.c	2007-08-20 12:32:08.000000000 +0200
@@ -120,6 +120,9 @@ static void __exit_signal(struct task_st
 		 */
 		sig->utime = cputime_add(sig->utime, tsk->utime);
 		sig->stime = cputime_add(sig->stime, tsk->stime);
+#ifdef CONFIG_GUEST_ACCOUNTING
+		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
+#endif
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
@@ -1255,6 +1258,13 @@ static int wait_task_zombie(struct task_
 			cputime_add(p->stime,
 			cputime_add(sig->stime,
 				    sig->cstime)));
+#ifdef CONFIG_GUEST_ACCOUNTING
+		psig->cgtime =
+			cputime_add(psig->cgtime,
+			cputime_add(p->gtime,
+			cputime_add(sig->gtime,
+				    sig->cgtime)));
+#endif
 		psig->cmin_flt +=
 			p->min_flt + sig->min_flt + sig->cmin_flt;
 		psig->cmaj_flt +=
Index: kvm/kernel/fork.c
===================================================================
--- kvm.orig/kernel/fork.c	2007-08-20 11:11:30.000000000 +0200
+++ kvm/kernel/fork.c	2007-08-20 12:38:55.000000000 +0200
@@ -877,6 +877,10 @@ static inline int copy_signal(unsigned l
 	sig->tty_old_pgrp = NULL;
 
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
+#ifdef CONFIG_GUEST_ACCOUNTING
+	sig->gtime = cputime_zero;
+	sig->cgtime = cputime_zero;
+#endif
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
@@ -1045,6 +1049,9 @@ static struct task_struct *copy_process(
 
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
+#ifdef CONFIG_GUEST_ACCOUNTING
+	p->gtime = cputime_zero;
+#endif
 
 #ifdef CONFIG_TASK_XACCT
 	p->rchar = 0;		/* I/O counter: bytes read */

--------------020805080407010105080809--
