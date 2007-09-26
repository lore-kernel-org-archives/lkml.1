Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbXIZQit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbXIZQit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758244AbXIZQiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:38:05 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:19192 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758152AbXIZQiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:38:03 -0400
X-IronPort-AV: E=Sophos;i="4.20,302,1186351200"; 
   d="scan'208";a="1526397"
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH 6/8] taskstats: tell fill_threadgroup_stats() if it replies
	with PID or TGID stats
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>
Date: Wed, 26 Sep 2007 18:28:26 +0200
Message-ID: <20070926162826.29434.38284.stgit@cheypa.inria.fr>
In-Reply-To: <20070926162800.29434.67786.stgit@cheypa.inria.fr>
References: <20070926162800.29434.67786.stgit@cheypa.inria.fr>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fill_threadgroup_stats() may want to know if it is filling
TASKSTATS_CMD_ATTR_TGID or TASKSTATS_CMD_ATTR_PID stats, so give it this
information in the tg_stats boolean.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---

 include/linux/tsacct_kern.h |    4 ++--
 kernel/taskstats.c          |   11 ++++++-----
 kernel/tsacct.c             |    3 ++-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/tsacct_kern.h b/include/linux/tsacct_kern.h
index 1568a3d..e8d1ad6 100644
--- a/include/linux/tsacct_kern.h
+++ b/include/linux/tsacct_kern.h
@@ -11,11 +11,11 @@
 
 #ifdef CONFIG_TASKSTATS
 void bacct_add_tsk(struct taskstats *stats, struct task_struct *task);
-void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task);
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task, bool tg_stats);
 #else
 static inline void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
 {}
-static inline void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+static inline void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task, bool tg_stats)
 {}
 #endif /* CONFIG_TASKSTATS */
 
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index f25bf03..59fe1d8 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -204,12 +204,13 @@ static void add_tsk_stats(struct taskstats *stats, struct task_struct *task)
  * fill_threadgroup_stats - initialize some common stats for the thread group
  * @stats: the taskstats to write into
  * @task: the thread representing the whole group
+ * @tg_stats: whether in the end thread group stats are requested
  *
  * Will be called on the thread group leader if requesting stats for the whole
  * thread group.
  */
 static void fill_threadgroup_stats(struct taskstats *stats,
-				   struct task_struct *task)
+				   struct task_struct *task, bool tg_stats)
 {
 	/*
 	 * Each accounting subsystem adds calls to its functions to initialize
@@ -221,7 +222,7 @@ static void fill_threadgroup_stats(struct taskstats *stats,
 	stats->version = TASKSTATS_VERSION;
 
 	/* fill in basic acct fields */
-	bacct_fill_threadgroup(stats, task);
+	bacct_fill_threadgroup(stats, task, tg_stats);
 
 	/* fill in extended acct fields */
 	xacct_fill_threadgroup(stats, task);
@@ -244,7 +245,7 @@ static int fill_pid(pid_t pid, struct task_struct *tsk, struct taskstats *stats)
 
 	memset(stats, 0, sizeof(*stats));
 	add_tsk_stats(stats, tsk);
-	fill_threadgroup_stats(stats, tsk);
+	fill_threadgroup_stats(stats, tsk, false);
 
 	/* Define err: label here if needed */
 	put_task_struct(tsk);
@@ -285,7 +286,7 @@ static int fill_tgid(pid_t tgid, struct task_struct *first,
 			add_tsk_stats(stats, tsk);
 	} while_each_thread(first, tsk);
 
-	fill_threadgroup_stats(stats, first->group_leader);
+	fill_threadgroup_stats(stats, first->group_leader, true);
 	unlock_task_sighand(first, &flags);
 	rc = 0;
 out:
@@ -541,7 +542,7 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
 	 */
 
 	memcpy(stats, tsk->signal->stats, sizeof(*stats));
-	fill_threadgroup_stats(stats, tsk->group_leader);
+	fill_threadgroup_stats(stats, tsk->group_leader, true);
 
 send:
 	send_cpu_listeners(rep_skb, listeners);
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 73b4c69..8c2f470 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -62,7 +62,8 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 	stats->nivcsw		+= tsk->nivcsw;
 }
 
-void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *tsk)
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *tsk,
+			    bool tg_stats)
 {
 	fill_wall_times(stats, tsk);
 
