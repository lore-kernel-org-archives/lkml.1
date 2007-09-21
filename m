Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbXIUXdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbXIUXdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761961AbXIUXcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:32:43 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:41299 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761674AbXIUXcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:32:42 -0400
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH 2/3] taskstats: tell fill_thread_group() whether it replies
	with PID or TGID stats
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jonathan Lim <jlim@sgi.com>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Sep 2007 01:30:49 +0200
Message-ID: <20070921233049.21607.39807.stgit@localhost.localdomain>
In-Reply-To: <20070921233038.21607.51089.stgit@localhost.localdomain>
References: <20070921233038.21607.51089.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fill_thread_group() may want to know if it is filling TASKSTATS_CMD_ATTR_TGID
or TASKSTATS_CMD_ATTR_PID stats, so give it this information in the tg_stats
boolean.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---

 include/linux/tsacct_kern.h |    4 ++--
 kernel/taskstats.c          |   12 +++++++-----
 kernel/tsacct.c             |    3 ++-
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/tsacct_kern.h b/include/linux/tsacct_kern.h
index 93dffc2..5652ae0 100644
--- a/include/linux/tsacct_kern.h
+++ b/include/linux/tsacct_kern.h
@@ -10,10 +10,10 @@
 #include <linux/taskstats.h>
 
 #ifdef CONFIG_TASKSTATS
-void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task);
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task, bool tg_stats);
 void bacct_add_tsk(struct taskstats *stats, struct task_struct *task);
 #else
-static inline void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+static inline void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task, bool tg_stats)
 {}
 static inline void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
 {}
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index ce43fae..42d3110 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -172,6 +172,7 @@ static void send_cpu_listeners(struct sk_buff *skb,
  * fill_threadgroup - initialize some common stats for the thread group
  * @stats: the taskstats to write into
  * @task: the thread representing the whole group
+ * @tg_stats: whether in the end thread group stats are requested
  *
  * There are two types of taskstats fields when considering a thread group:
  *	- those that can be aggregated from each thread in the group (like CPU
@@ -181,7 +182,8 @@ static void send_cpu_listeners(struct sk_buff *skb,
  * XXX_threadgroup() methods deal with the first type while XXX_add_tsk() with
  * the second.
  */
-static void fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+static void fill_threadgroup(struct taskstats *stats, struct task_struct *task,
+			     bool tg_stats)
 {
 	/*
 	 * Each accounting subsystem adds calls to its functions to initialize
@@ -193,7 +195,7 @@ static void fill_threadgroup(struct taskstats *stats, struct task_struct *task)
 	stats->version = TASKSTATS_VERSION;
 
 	/* fill in basic acct fields */
-	bacct_fill_threadgroup(stats, task);
+	bacct_fill_threadgroup(stats, task, tg_stats);
 
 	/* fill in extended acct fields */
 	xacct_fill_threadgroup(stats, task);
@@ -248,7 +250,7 @@ static int fill_pid(pid_t pid, struct task_struct *tsk,
 
 	memset(stats, 0, sizeof(*stats));
 	add_tsk(stats, tsk);
-	fill_threadgroup(stats, tsk);
+	fill_threadgroup(stats, tsk, false);
 
 	/* Define err: label here if needed */
 	put_task_struct(tsk);
@@ -289,7 +291,7 @@ static int fill_tgid(pid_t tgid, struct task_struct *first,
 			add_tsk(stats, tsk);
 	while_each_thread(first, tsk);
 
-	fill_threadgroup(stats, first->group_leader);
+	fill_threadgroup(stats, first->group_leader, true);
 	unlock_task_sighand(first, &flags);
 	rc = 0;
 out:
@@ -545,7 +547,7 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
 	 */
 
 	memcpy(stats, tsk->signal->stats, sizeof(*stats));
-	fill_threadgroup(stats, tsk->group_leader);
+	fill_threadgroup(stats, tsk->group_leader, true);
 
 send:
 	send_cpu_listeners(rep_skb, listeners);
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 9541a1a..24056aa 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -41,7 +41,8 @@ static void fill_wall_times(struct taskstats *stats, struct task_struct *tsk)
  * fill in basic accounting fields
  */
 
-void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task,
+			    bool tg_stats)
 {
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 

