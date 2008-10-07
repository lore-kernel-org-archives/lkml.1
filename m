Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbYJGAsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbYJGAsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbYJGAnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:43:40 -0400
Received: from ns2.suse.de ([195.135.220.15]:60462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbYJGAnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:43:39 -0400
Date: Mon, 6 Oct 2008 17:38:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 23/71] sched: fix process time monotonicity
Message-ID: <20081007003826.GX3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched-fix-process-time-monotonicity.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Balbir Singh <balbir@linux.vnet.ibm.com>

commit 49048622eae698e5c4ae61f7e71200f265ccc529 upstream

Spencer reported a problem where utime and stime were going negative despite
the fixes in commit b27f03d4bdc145a09fb7b0c0e004b29f1ee555fa. The suspected
reason for the problem is that signal_struct maintains it's own utime and
stime (of exited tasks), these are not updated using the new task_utime()
routine, hence sig->utime can go backwards and cause the same problem
to occur (sig->utime, adds tsk->utime and not task_utime()). This patch
fixes the problem

TODO: using max(task->prev_utime, derived utime) works for now, but a more
generic solution is to implement cputime_max() and use the cputime_gt()
function for comparison.

Reported-by: spencer@bluehost.com
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/array.c       |   59 --------------------------------------------------
 include/linux/sched.h |    4 +++
 kernel/exit.c         |    6 ++---
 kernel/sched.c        |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 62 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -332,65 +332,6 @@ int proc_pid_status(struct seq_file *m, 
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
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1477,6 +1477,10 @@ static inline void put_task_struct(struc
 		__put_task_struct(t);
 }
 
+extern cputime_t task_utime(struct task_struct *p);
+extern cputime_t task_stime(struct task_struct *p);
+extern cputime_t task_gtime(struct task_struct *p);
+
 /*
  * Per process flags
  */
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -111,9 +111,9 @@ static void __exit_signal(struct task_st
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
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3995,6 +3995,65 @@ void account_steal_time(struct task_stru
 }
 
 /*
+ * Use precise platform statistics if available:
+ */
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+cputime_t task_utime(struct task_struct *p)
+{
+	return p->utime;
+}
+
+cputime_t task_stime(struct task_struct *p)
+{
+	return p->stime;
+}
+#else
+cputime_t task_utime(struct task_struct *p)
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
+cputime_t task_stime(struct task_struct *p)
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
+inline cputime_t task_gtime(struct task_struct *p)
+{
+	return p->gtime;
+}
+
+/*
  * This function gets called by the timer code, with HZ frequency.
  * We call it with interrupts disabled.
  *

-- 
