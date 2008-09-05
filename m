Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYIESuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYIESuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbYIEStx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:49:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34897 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYIEStw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:49:52 -0400
Date: Fri, 5 Sep 2008 20:49:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20080905184938.GA3872@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

the linecount looks a bit scary because the task_*time() functions had 
to be made available from the core kernel toward kernel/exit.c - but 
it's reasonable safe otherwise. [ array.c depends on proc-y so we 
couldnt just export it from there. ]

Thanks,

	Ingo

------------------>
Balbir Singh (1):
      sched: fix process time monotonicity

Peter Zijlstra (1):
      sched_clock: fix NOHZ interaction


 fs/proc/array.c          |   59 ----------------------------------------------
 include/linux/sched.h    |    4 +++
 kernel/exit.c            |    6 ++--
 kernel/sched.c           |   59 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/time/tick-sched.c |    3 ++
 5 files changed, 69 insertions(+), 62 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 0d6eb33..71c9be5 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -337,65 +337,6 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cfb0d87..3d9120c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1475,6 +1475,10 @@ static inline void put_task_struct(struct task_struct *t)
 		__put_task_struct(t);
 }
 
+extern cputime_t task_utime(struct task_struct *p);
+extern cputime_t task_stime(struct task_struct *p);
+extern cputime_t task_gtime(struct task_struct *p);
+
 /*
  * Per process flags
  */
diff --git a/kernel/exit.c b/kernel/exit.c
index 25ed2ad..1639564 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -112,9 +112,9 @@ static void __exit_signal(struct task_struct *tsk)
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
diff --git a/kernel/sched.c b/kernel/sched.c
index 9a1ddb8..1a5f73c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4179,6 +4179,65 @@ void account_steal_time(struct task_struct *p, cputime_t steal)
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
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 7a46bde..a87b046 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -162,6 +162,8 @@ void tick_nohz_stop_idle(int cpu)
 		ts->idle_lastupdate = now;
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		ts->idle_active = 0;
+
+		sched_clock_idle_wakeup_event(0);
 	}
 }
 
@@ -177,6 +179,7 @@ static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 	}
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
+	sched_clock_idle_sleep_event();
 	return now;
 }
 
