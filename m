Return-Path: <linux-kernel-owner+w=401wt.eu-S1764823AbXHPP6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764823AbXHPP6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 11:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759587AbXHPP5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 11:57:54 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56839 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764731AbXHPP5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 11:57:52 -0400
Message-ID: <46C47405.6050505@bull.net>
Date: Thu, 16 Aug 2007 17:57:57 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: kvm-devel@lists.sourceforge.net
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC 2/4]Introduce a new field "guest" in task_struct
References: <46C4719A.2060308@bull.net> <46C4720F.7030304@bull.net>
In-Reply-To: <46C4720F.7030304@bull.net>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 16/08/2007 18:03:00,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 16/08/2007 18:03:02,
	Serialize complete at 16/08/2007 18:03:02
Content-Type: multipart/mixed;
 boundary="------------010508010305010200010001"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010508010305010200010001
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

PATCH 2/4] like for cpustat, introduce the "guest" and "cguest" fields for the
tasks. Modify
signal_struct and task_struct. Modify /proc/<pid>/stat to display these new field

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

--------------010508010305010200010001
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="proc_task_stat_guest"
Content-Disposition: inline;
 filename="proc_task_stat_guest"

Index: kvm/fs/proc/array.c
===================================================================
--- kvm.orig/fs/proc/array.c	2007-08-16 15:23:52.000000000 +0200
+++ kvm/fs/proc/array.c	2007-08-16 15:36:54.000000000 +0200
@@ -354,6 +354,13 @@
 	return stime;
 }
 
+static clock_t task_gtime(struct task_struct *p)
+{
+	clock_t gtime = cputime_to_clock_t(p->gtime);
+
+	return gtime;
+}
+
 static int do_task_stat(struct task_struct *task, char *buffer, int whole)
 {
 	unsigned long vsize, eip, esp, wchan = ~0UL;
@@ -368,8 +375,8 @@
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
 	unsigned long  min_flt = 0,  maj_flt = 0;
-	cputime_t cutime, cstime;
-	clock_t utime, stime;
+	cputime_t cutime, cstime, cgtime;
+	clock_t utime, stime, gtime;
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
@@ -387,8 +394,8 @@
 
 	sigemptyset(&sigign);
 	sigemptyset(&sigcatch);
-	cutime = cstime = cputime_zero;
-	utime = stime = 0;
+	cutime = cstime = cgtime = cputime_zero;
+	utime = stime = gtime = 0;
 
 	rcu_read_lock();
 	if (lock_task_sighand(task, &flags)) {
@@ -406,6 +413,7 @@
 		cmaj_flt = sig->cmaj_flt;
 		cutime = sig->cutime;
 		cstime = sig->cstime;
+		cgtime = sig->cgtime;
 		rsslim = sig->rlim[RLIMIT_RSS].rlim_cur;
 
 		/* add up live thread stats at the group level */
@@ -416,6 +424,7 @@
 				maj_flt += t->maj_flt;
 				utime += task_utime(t);
 				stime += task_stime(t);
+				gtime += task_gtime(t);
 				t = next_thread(t);
 			} while (t != task);
 
@@ -423,6 +432,7 @@
 			maj_flt += sig->maj_flt;
 			utime += cputime_to_clock_t(sig->utime);
 			stime += cputime_to_clock_t(sig->stime);
+			gtime += cputime_to_clock_t(sig->gtime);
 		}
 
 		sid = signal_session(sig);
@@ -440,6 +450,7 @@
 		maj_flt = task->maj_flt;
 		utime = task_utime(task);
 		stime = task_stime(task);
+		gtime = task_gtime(task);
 	}
 
 	/* scale priority and nice values from timeslices to -20..20 */
@@ -457,7 +468,7 @@
 
 	res = sprintf(buffer, "%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu\n",
+%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
 		task->pid,
 		tcomm,
 		state,
@@ -502,7 +513,10 @@
 		task_cpu(task),
 		task->rt_priority,
 		task->policy,
-		(unsigned long long)delayacct_blkio_ticks(task));
+		(unsigned long long)delayacct_blkio_ticks(task),
+		gtime,
+		cputime_to_clock_t(cgtime)
+		);
 	if (mm)
 		mmput(mm);
 	return res;
Index: kvm/include/linux/sched.h
===================================================================
--- kvm.orig/include/linux/sched.h	2007-08-16 15:23:52.000000000 +0200
+++ kvm/include/linux/sched.h	2007-08-16 15:36:54.000000000 +0200
@@ -514,7 +514,7 @@
 	 * Live threads maintain their own counters and add to these
 	 * in __exit_signal, except for the group leader.
 	 */
-	cputime_t utime, stime, cutime, cstime;
+	cputime_t utime, stime, gtime, cutime, cstime, cgtime;
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
@@ -1018,7 +1018,7 @@
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
 	unsigned int rt_priority;
-	cputime_t utime, stime;
+	cputime_t utime, stime, gtime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
Index: kvm/kernel/exit.c
===================================================================
--- kvm.orig/kernel/exit.c	2007-08-16 15:23:52.000000000 +0200
+++ kvm/kernel/exit.c	2007-08-16 15:36:54.000000000 +0200
@@ -120,6 +120,7 @@
 		 */
 		sig->utime = cputime_add(sig->utime, tsk->utime);
 		sig->stime = cputime_add(sig->stime, tsk->stime);
+		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
@@ -1255,6 +1256,11 @@
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
Index: kvm/kernel/fork.c
===================================================================
--- kvm.orig/kernel/fork.c	2007-08-16 15:23:52.000000000 +0200
+++ kvm/kernel/fork.c	2007-08-16 15:39:07.000000000 +0200
@@ -876,7 +876,8 @@
 	sig->leader = 0;	/* session leadership doesn't inherit */
 	sig->tty_old_pgrp = NULL;
 
-	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
+	sig->utime = sig->stime = sig->gtime = sig->cutime =
+				sig->cstime = sig->cgtime = cputime_zero;
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
@@ -1045,6 +1046,7 @@
 
 	p->utime = cputime_zero;
 	p->stime = cputime_zero;
+	p->gtime = cputime_zero;
 
 #ifdef CONFIG_TASK_XACCT
 	p->rchar = 0;		/* I/O counter: bytes read */

--------------010508010305010200010001--
