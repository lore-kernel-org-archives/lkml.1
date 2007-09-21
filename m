Return-Path: <linux-kernel-owner+w=401wt.eu-S1763347AbXIUXde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763347AbXIUXde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762348AbXIUXcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:32:50 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:41322 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762222AbXIUXcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:32:48 -0400
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH 3/3] taskstats: fix stats->ac_exitcode to work on threads and
	use group_exit_code
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jonathan Lim <jlim@sgi.com>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Sep 2007 01:30:55 +0200
Message-ID: <20070921233055.21607.12387.stgit@localhost.localdomain>
In-Reply-To: <20070921233038.21607.51089.stgit@localhost.localdomain>
References: <20070921233038.21607.51089.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Threads also have an exit code on their own, so report it in
TASKSTATS_CMD_ATTR_PID.

For TASKSTATS_CMD_ATTR_TGID, instead of relying only on the exit code of the
leader, we use task->signal->group_exit_code if not null as suggested by
Oleg Nesterov.

Also, document that as of this patch, fill_threadgroup() must be called after
add_tsk() as it may overwrite some stats.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---

 kernel/taskstats.c |    3 +++
 kernel/tsacct.c    |   12 +++++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 42d3110..24d7f62 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -181,6 +181,9 @@ static void send_cpu_listeners(struct sk_buff *skb,
  *	memory usage), so are taken from the group leader.
  * XXX_threadgroup() methods deal with the first type while XXX_add_tsk() with
  * the second.
+ *
+ * fill_threadgroup() may overwrite stats from add_tsk(), so it must be called
+ * after add_tsk().
  */
 static void fill_threadgroup(struct taskstats *stats, struct task_struct *task,
 			     bool tg_stats)
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 24056aa..526b134 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -44,6 +44,8 @@ static void fill_wall_times(struct taskstats *stats, struct task_struct *tsk)
 void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task,
 			    bool tg_stats)
 {
+	int group_exit_code;
+
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 
 	rcu_read_lock();
@@ -53,11 +55,11 @@ void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task,
 
 	fill_wall_times(stats, task);
 
-	if (thread_group_leader(task)) {
-		stats->ac_exitcode = task->exit_code;
-		if (task->flags & PF_FORKNOEXEC)
-			stats->ac_flag |= AFORK;
-	}
+	if (thread_group_leader(task) && (task->flags & PF_FORKNOEXEC))
+		stats->ac_flag |= AFORK;
+
+	group_exit_code = tg_stats ? task->signal->group_exit_code : 0;
+	stats->ac_exitcode	= group_exit_code ? : task->exit_code;
 
 	stats->ac_nice		= task_nice(task);
 	stats->ac_sched		= task->policy;

