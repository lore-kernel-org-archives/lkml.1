Return-Path: <linux-kernel-owner+w=401wt.eu-S1761620AbXIZQj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761620AbXIZQj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbXIZQiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:38:15 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:60420 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869AbXIZQiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:38:14 -0400
X-IronPort-AV: E=Sophos;i="4.20,302,1186351200"; 
   d="scan'208";a="1526402"
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH 7/8] taskstats: fix stats->ac_exitcode to work on threads and
	use group_exit_code
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>
Date: Wed, 26 Sep 2007 18:28:31 +0200
Message-ID: <20070926162831.29434.29622.stgit@cheypa.inria.fr>
In-Reply-To: <20070926162800.29434.67786.stgit@cheypa.inria.fr>
References: <20070926162800.29434.67786.stgit@cheypa.inria.fr>
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

Also, document that as of this patch, fill_threadgroup_stats() must be called
after add_tsk_stats() as it may overwrite some stats.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---

 kernel/taskstats.c |    2 ++
 kernel/tsacct.c    |   12 +++++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 59fe1d8..938c0b0 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -208,6 +208,8 @@ static void add_tsk_stats(struct taskstats *stats, struct task_struct *task)
  *
  * Will be called on the thread group leader if requesting stats for the whole
  * thread group.
+ * fill_threadgroup_stats() may overwrite stats from add_tsk_stats(), so it
+ * must be called after add_tsk_stats().
  */
 static void fill_threadgroup_stats(struct taskstats *stats,
 				   struct task_struct *task, bool tg_stats)
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 8c2f470..e83f53b 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -65,13 +65,15 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *tsk,
 			    bool tg_stats)
 {
+	int group_exit_code;
+
 	fill_wall_times(stats, tsk);
 
-	if (thread_group_leader(tsk)) {
-		stats->ac_exitcode = tsk->exit_code;
-		if (tsk->flags & PF_FORKNOEXEC)
-			stats->ac_flag |= AFORK;
-	}
+	if (thread_group_leader(tsk) && ((tsk->flags & PF_FORKNOEXEC)))
+		stats->ac_flag |= AFORK;
+
+	group_exit_code = tg_stats ? tsk->signal->group_exit_code : 0;
+	stats->ac_exitcode = group_exit_code ? : tsk->exit_code;
 
 	stats->ac_nice	 = task_nice(tsk);
 	stats->ac_sched	 = tsk->policy;
