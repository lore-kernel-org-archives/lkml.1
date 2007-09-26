Return-Path: <linux-kernel-owner+w=401wt.eu-S1761409AbXIZRIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409AbXIZRIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 13:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbXIZRI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 13:08:26 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38597
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756078AbXIZRIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 13:08:25 -0400
X-IronPort-AV: E=Sophos;i="4.21,198,1188770400"; 
   d="scan'208";a="3292246"
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH 2/8] taskstats: split the basic accounting fields
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>, Balbir Singh <balbir@in.ibm.com>,
       Jay Lan <jlan@engr.sgi.com>, Jonathan Lim <jlim@sgi.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Wed, 26 Sep 2007 19:08:24 +0200
Message-ID: <20070926170824.31221.13784.stgit@cheypa.inria.fr>
In-Reply-To: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
References: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Split the basic accounting taskstats fields into the threadgroup specific ones
and the thread specific ones. This should have no effect on the execution.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---

 kernel/tsacct.c |   53 +++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 37 insertions(+), 16 deletions(-)


diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 4ab1b58..d32378f 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -25,13 +25,11 @@
 /*
  * fill in basic accounting fields
  */
-void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static void fill_wall_times(struct taskstats *stats, struct task_struct *tsk)
 {
 	struct timespec uptime, ts;
 	s64 ac_etime;
 
-	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
-
 	/* calculate task elapsed time in timespec */
 	do_posix_clock_monotonic_gettime(&uptime);
 	ts = timespec_sub(uptime, tsk->start_time);
@@ -40,17 +38,47 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 	do_div(ac_etime, NSEC_PER_USEC);
 	stats->ac_etime = ac_etime;
 	stats->ac_btime = get_seconds() - ts.tv_sec;
-	if (thread_group_leader(tsk)) {
-		stats->ac_exitcode = tsk->exit_code;
-		if (tsk->flags & PF_FORKNOEXEC)
-			stats->ac_flag |= AFORK;
-	}
+}
+
+/*
+ * Later on, XXX_add_tsk() will need to be called after XXX_fill_threadgroup(),
+ * so put the functions in this order
+ */
+static void bacct_fill_threadgroup(struct taskstats *stats,
+				   struct task_struct *tsk);
+
+void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+{
 	if (tsk->flags & PF_SUPERPRIV)
 		stats->ac_flag |= ASU;
 	if (tsk->flags & PF_DUMPCORE)
 		stats->ac_flag |= ACORE;
 	if (tsk->flags & PF_SIGNALED)
 		stats->ac_flag |= AXSIG;
+
+	stats->ac_utime	+= cputime_to_msecs(tsk->utime) * USEC_PER_MSEC;
+	stats->ac_stime += cputime_to_msecs(tsk->stime) * USEC_PER_MSEC;
+	stats->ac_utimescaled	+=
+		cputime_to_msecs(tsk->utimescaled) * USEC_PER_MSEC;
+	stats->ac_stimescaled	+=
+		cputime_to_msecs(tsk->stimescaled) * USEC_PER_MSEC;
+	stats->ac_minflt	+= tsk->min_flt;
+	stats->ac_majflt	+= tsk->maj_flt;
+
+	bacct_fill_threadgroup(stats, tsk);
+}
+
+static void bacct_fill_threadgroup(struct taskstats *stats,
+				   struct task_struct *tsk)
+{
+	fill_wall_times(stats, tsk);
+
+	if (thread_group_leader(tsk)) {
+		stats->ac_exitcode = tsk->exit_code;
+		if (tsk->flags & PF_FORKNOEXEC)
+			stats->ac_flag |= AFORK;
+	}
+
 	stats->ac_nice	 = task_nice(tsk);
 	stats->ac_sched	 = tsk->policy;
 	stats->ac_uid	 = tsk->uid;
@@ -60,15 +88,8 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 	stats->ac_ppid	 = pid_alive(tsk) ?
 				rcu_dereference(tsk->real_parent)->tgid : 0;
 	rcu_read_unlock();
-	stats->ac_utime	 = cputime_to_msecs(tsk->utime) * USEC_PER_MSEC;
-	stats->ac_stime	 = cputime_to_msecs(tsk->stime) * USEC_PER_MSEC;
-	stats->ac_utimescaled =
-		cputime_to_msecs(tsk->utimescaled) * USEC_PER_MSEC;
-	stats->ac_stimescaled =
-		cputime_to_msecs(tsk->stimescaled) * USEC_PER_MSEC;
-	stats->ac_minflt = tsk->min_flt;
-	stats->ac_majflt = tsk->maj_flt;
 
+	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
 }
 
