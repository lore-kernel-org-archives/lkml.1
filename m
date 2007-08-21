Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbXHUCV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbXHUCV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 22:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbXHUCVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 22:21:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43028 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753028AbXHUCVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 22:21:17 -0400
From: Jonathan Lim <jlim@sgi.com>
Message-Id: <200708210222.l7L2MFcJ377626@sabah.engr.sgi.com>
Subject: [PATCH] Send exit code through for taskstats.ac_exitcode
To: linux-kernel@vger.kernel.org
Date: Mon, 20 Aug 2007 19:22:15 -0700 (PDT)
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

taskstats.ac_exitcode is assigned to task_struct.exit_code in bacct_add_tsk()
through the following kernel function calls: 

  do_exit()
    taskstats_exit_send()
      fill_pid()
        bacct_add_tsk()

The problem is that in do_exit(), task_struct.exit_code is set to 'code' 
only after taskstats_exit_send() has been called.  So we need to send 'code'
through to bacct_add_tsk().

Diff'd against: linux/kernel/git/stable/linux-2.6.22.y.git

Signed-off-by: Jonathan Lim <jlim@sgi.com>

--- a/kernel/exit.c	2007-08-20 16:37:55.000000000 -0700
+++ b/kernel/exit.c	2007-08-20 16:37:55.000000000 -0700
@@ -941,7 +941,7 @@ fastcall NORET_TYPE void do_exit(long co
 	if (unlikely(tsk->audit_context))
 		audit_free(tsk);
 
-	taskstats_exit(tsk, group_dead);
+	taskstats_exit(code, tsk, group_dead);
 
 	exit_mm(tsk);
 
--- a/kernel/taskstats.c	2007-08-20 16:37:55.000000000 -0700
+++ b/kernel/taskstats.c	2007-08-20 16:37:55.000000000 -0700
@@ -168,7 +168,7 @@ static void send_cpu_listeners(struct sk
 	up_write(&listeners->sem);
 }
 
-static int fill_pid(pid_t pid, struct task_struct *tsk,
+static int fill_pid(long exitcode, pid_t pid, struct task_struct *tsk,
 		struct taskstats *stats)
 {
 	int rc = 0;
@@ -196,7 +196,7 @@ static int fill_pid(pid_t pid, struct ta
 
 	/* fill in basic acct fields */
 	stats->version = TASKSTATS_VERSION;
-	bacct_add_tsk(stats, tsk);
+	bacct_add_tsk(exitcode, stats, tsk);
 
 	/* fill in extended acct fields */
 	xacct_add_tsk(stats, tsk);
@@ -452,7 +452,7 @@ ret:
 }
 
 /* Send pid data out on exit */
-void taskstats_exit(struct task_struct *tsk, int group_dead)
+void taskstats_exit(long exitcode, struct task_struct *tsk, int group_dead)
 {
 	int rc;
 	struct listener_list *listeners;
@@ -490,7 +490,7 @@ void taskstats_exit(struct task_struct *
 	if (!stats)
 		goto err;
 
-	rc = fill_pid(tsk->pid, tsk, stats);
+	rc = fill_pid(exitcode, tsk->pid, tsk, stats);
 	if (rc < 0)
 		goto err;
 
--- a/kernel/tsacct.c	2007-08-20 16:37:55.000000000 -0700
+++ b/kernel/tsacct.c	2007-08-20 16:37:55.000000000 -0700
@@ -25,7 +25,7 @@
 /*
  * fill in basic accounting fields
  */
-void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+void bacct_add_tsk(long exitcode, struct taskstats *stats, struct task_struct *tsk)
 {
 	struct timespec uptime, ts;
 	s64 ac_etime;
@@ -41,7 +41,7 @@ void bacct_add_tsk(struct taskstats *sta
 	stats->ac_etime = ac_etime;
 	stats->ac_btime = xtime.tv_sec - ts.tv_sec;
 	if (thread_group_leader(tsk)) {
-		stats->ac_exitcode = tsk->exit_code;
+		stats->ac_exitcode = exitcode;
 		if (tsk->flags & PF_FORKNOEXEC)
 			stats->ac_flag |= AFORK;
 	}

--- a/include/linux/taskstats_kern.h	2007-08-20 18:13:11.000000000 -0700
+++ b/include/linux/taskstats_kern.h	2007-08-20 18:16:12.000000000 -0700
@@ -26,10 +26,10 @@ static inline void taskstats_tgid_free(s
                kmem_cache_free(taskstats_cache, sig->stats);
 }
 
-extern void taskstats_exit(struct task_struct *, int group_dead);
+extern void taskstats_exit(long exitcode, struct task_struct *, int group_dead);
 extern void taskstats_init_early(void);
 #else
-static inline void taskstats_exit(struct task_struct *tsk, int group_dead)
+static inline void taskstats_exit(long exitcode, struct task_struct *tsk, int group_dead)
 {}
 static inline void taskstats_tgid_init(struct signal_struct *sig)
 {}

--- a/include/linux/tsacct_kern.h	2007-08-20 18:13:11.000000000 -0700
+++ b/include/linux/tsacct_kern.h	2007-08-20 18:17:55.000000000 -0700
@@ -10,9 +10,9 @@
 #include <linux/taskstats.h>
 
 #ifdef CONFIG_TASKSTATS
-extern void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk);
+extern void bacct_add_tsk(long exitcode, struct taskstats *stats, struct task_struct *tsk);
 #else
-static inline void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static inline void bacct_add_tsk(long exitcode, struct taskstats *stats, struct task_struct *tsk)
 {}
 #endif /* CONFIG_TASKSTATS */
 
