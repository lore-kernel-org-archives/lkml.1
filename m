Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbYH1WwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbYH1WwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbYH1WwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:52:03 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:60635 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbYH1WwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:52:01 -0400
Date: Fri, 29 Aug 2008 04:21:57 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: Fw: Re: Still seeing decreasing stime/utime
Message-ID: <20080828225157.GA2323@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline

Forgot to cc lkml (the original email did not either, but I need comments on
the patch).

-- 
	Balbir

--FL5UXtIhxfXey3p5
Content-Type: message/rfc822
Content-Disposition: inline

Date: Fri, 29 Aug 2008 04:15:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Spencer Candland <spencer@bluehost.com>
Cc: a.p.zijlstra@chello.nl, dmitry.adamushko@gmail.com, mingo@elte.hu
Subject: Re: Still seeing decreasing stime/utime
Message-ID: <20080828224502.GA1540@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <48B5C4C7.8040509@bluehost.com> <48B66BCC.8030207@linux.vnet.ibm.com> <48B702FA.8060308@bluehost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <48B702FA.8060308@bluehost.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)

* Spencer Candland <spencer@bluehost.com> [2008-08-28 13:56:42]:

> Yes, CONFIG_VIRT_CPU_ACCOUNTING is not enabled, I am seeing this on
> x86/x86_64.
> 
> I can not seem to duplicate this when booting with nosmp.
>

Thanks for the config and the update. I ran the same test on a quad
core machine on 2.6.27-rc3 (mmotm a few days old) (x86_64)

50 600
52 658
58 706
62 760
66 810
70 864
72 914
78 964
...


Here is an experimental patch (I've just compiled and booted a machine
with it, I am unable to reproduce your problem), could you please test
it for me and see if it helps solve the problem


Reported-by: spencer@bluehost.com

Spencer Candland reported a problem where utime and stime were going negative
despite the fixes in commit b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa. The
suspected reason for the problem is that signal_struct maintains it's own utime 
and stime (of exited tasks), these are not updated using the new task_utime()
routine, hence sig->utime can go backwards and cause the same problem
to occur (sig->utime, adds tsk->utime and not task_utime()). This patch
fixes the problem

TODO: using max(task->prev_utime, derived utime) works for now, but a more
generic solution is to implement cputime_max() and use the cputime_gt()
function for comparison.

Comments? (If the inline functions don't look good, I'll gladly move
the functions over to sched.c)

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 fs/proc/array.c       |   59 --------------------------------------------------
 include/linux/sched.h |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/exit.c         |    6 ++---
 3 files changed, 62 insertions(+), 62 deletions(-)

diff -puN kernel/exit.c~fix-utime-stime-moving-backwards kernel/exit.c
--- linux-2.6.27-rc3/kernel/exit.c~fix-utime-stime-moving-backwards	2008-08-29 03:14:57.000000000 +0530
+++ linux-2.6.27-rc3-balbir/kernel/exit.c	2008-08-29 03:21:18.000000000 +0530
@@ -115,9 +115,9 @@ static void __exit_signal(struct task_st
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		sig->utime = cputime_add(sig->utime, tsk->utime);
-		sig->stime = cputime_add(sig->stime, tsk->stime);
-		sig->gtime = cputime_add(sig->gtime, tsk->gtime);
+		sig->utime = cputime_add(sig->utime, task_utime(tsk));
+		sig->stime = cputime_add(sig->stime, task_stime(tsk));
+		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
 		sig->nvcsw += tsk->nvcsw;
diff -puN fs/proc/array.c~fix-utime-stime-moving-backwards fs/proc/array.c
--- linux-2.6.27-rc3/fs/proc/array.c~fix-utime-stime-moving-backwards	2008-08-29 03:14:58.000000000 +0530
+++ linux-2.6.27-rc3-balbir/fs/proc/array.c	2008-08-29 03:16:09.000000000 +0530
@@ -349,65 +349,6 @@ int proc_pid_status(struct seq_file *m, 
 	return 0;
 }
 
-/*
- * Use precise platform statistics if available:
- */
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-static cputime_t task_utime(struct task_struct *p)
-{
-	return p->utime;
-}
-
-static cputime_t task_stime(struct task_struct *p)
-{
-	return p->stime;
-}
-#else
-static cputime_t task_utime(struct task_struct *p)
-{
-	clock_t utime = cputime_to_clock_t(p->utime),
-		total = utime + cputime_to_clock_t(p->stime);
-	u64 temp;
-
-	/*
-	 * Use CFS's precise accounting:
-	 */
-	temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
-
-	if (total) {
-		temp *= utime;
-		do_div(temp, total);
-	}
-	utime = (clock_t)temp;
-
-	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
-	return p->prev_utime;
-}
-
-static cputime_t task_stime(struct task_struct *p)
-{
-	clock_t stime;
-
-	/*
-	 * Use CFS's precise accounting. (we subtract utime from
-	 * the total, to make sure the total observed by userspace
-	 * grows monotonically - apps rely on that):
-	 */
-	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
-			cputime_to_clock_t(task_utime(p));
-
-	if (stime >= 0)
-		p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
-
-	return p->prev_stime;
-}
-#endif
-
-static cputime_t task_gtime(struct task_struct *p)
-{
-	return p->gtime;
-}
-
 static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task, int whole)
 {
diff -puN include/linux/sched.h~fix-utime-stime-moving-backwards include/linux/sched.h
--- linux-2.6.27-rc3/include/linux/sched.h~fix-utime-stime-moving-backwards	2008-08-29 03:14:58.000000000 +0530
+++ linux-2.6.27-rc3-balbir/include/linux/sched.h	2008-08-29 03:49:04.000000000 +0530
@@ -1431,6 +1431,65 @@ static inline void put_task_struct(struc
 }
 
 /*
+ * Use precise platform statistics if available:
+ */
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+static inline cputime_t task_utime(struct task_struct *p)
+{
+	return p->utime;
+}
+
+static inline cputime_t task_stime(struct task_struct *p)
+{
+	return p->stime;
+}
+#else
+static inline cputime_t task_utime(struct task_struct *p)
+{
+	clock_t utime = cputime_to_clock_t(p->utime),
+		total = utime + cputime_to_clock_t(p->stime);
+	u64 temp;
+
+	/*
+	 * Use CFS's precise accounting:
+	 */
+	temp = (u64)nsec_to_clock_t(p->se.sum_exec_runtime);
+
+	if (total) {
+		temp *= utime;
+		do_div(temp, total);
+	}
+	utime = (clock_t)temp;
+
+	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
+	return p->prev_utime;
+}
+
+static inline cputime_t task_stime(struct task_struct *p)
+{
+	clock_t stime;
+
+	/*
+	 * Use CFS's precise accounting. (we subtract utime from
+	 * the total, to make sure the total observed by userspace
+	 * grows monotonically - apps rely on that):
+	 */
+	stime = nsec_to_clock_t(p->se.sum_exec_runtime) -
+			cputime_to_clock_t(task_utime(p));
+
+	if (stime >= 0)
+		p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
+
+	return p->prev_stime;
+}
+#endif
+
+static inline cputime_t task_gtime(struct task_struct *p)
+{
+	return p->gtime;
+}
+
+/*
  * Per process flags
  */
 #define PF_ALIGNWARN	0x00000001	/* Print alignment warning msgs */
_
 
-- 
	Balbir

--FL5UXtIhxfXey3p5--
