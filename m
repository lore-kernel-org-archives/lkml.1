Return-Path: <linux-kernel-owner+w=401wt.eu-S1761778AbXIZRJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761778AbXIZRJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 13:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761239AbXIZRIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 13:08:37 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38597
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761136AbXIZRIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 13:08:36 -0400
X-IronPort-AV: E=Sophos;i="4.21,198,1188770400"; 
   d="scan'208";a="3292252"
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH 4/8] taskstats: separate PID/TGID stats producers to complete
	the TGID ones
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>, Balbir Singh <balbir@in.ibm.com>,
       Jay Lan <jlan@engr.sgi.com>, Jonathan Lim <jlim@sgi.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Wed, 26 Sep 2007 19:08:34 +0200
Message-ID: <20070926170834.31221.15444.stgit@cheypa.inria.fr>
In-Reply-To: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
References: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TASKSTATS_CMD_ATTR_TGID used to return only the delay accounting stats, not
the basic and extended accounting.  With this patch,
TASKSTATS_CMD_ATTR_TGID also aggregates the accounting info for all threads
of a thread group.

TASKSTATS_CMD_ATTR_PID output should be unchanged
TASKSTATS_CMD_ATTR_TGID output should have all fields set, unlike before the
patch where most of the fiels were set to 0.

To this aim, two functions were introduced: fill_threadgroup_stats() and
add_tsk_stats(). These functions are responsible for aggregating the
subsystem specific accounting information. Taskstats requesters (fill_pid(),
fill_tgid() and fill_tgid_exit()) should only call add_tsk_stats() and
fill_threadgroup_stats() to get the stats.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---

 Documentation/accounting/getdelays.c |    2 -
 include/linux/tsacct_kern.h          |   12 +++-
 kernel/taskstats.c                   |  107 +++++++++++++++++++++++-----------
 kernel/tsacct.c                      |   20 +-----
 4 files changed, 85 insertions(+), 56 deletions(-)


diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index cbee3a2..78773c0 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -76,7 +76,7 @@ static void usage(void)
 	fprintf(stderr, "getdelays [-dilv] [-w logfile] [-r bufsize] "
 			"[-m cpumask] [-t tgid] [-p pid]\n");
 	fprintf(stderr, "  -d: print delayacct stats\n");
-	fprintf(stderr, "  -i: print IO accounting (works only with -p)\n");
+	fprintf(stderr, "  -i: print IO accounting\n");
 	fprintf(stderr, "  -l: listen forever\n");
 	fprintf(stderr, "  -v: debug on\n");
 }
diff --git a/include/linux/tsacct_kern.h b/include/linux/tsacct_kern.h
index 7e50ac7..1568a3d 100644
--- a/include/linux/tsacct_kern.h
+++ b/include/linux/tsacct_kern.h
@@ -10,19 +10,25 @@
 #include <linux/taskstats.h>
 
 #ifdef CONFIG_TASKSTATS
-extern void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk);
+void bacct_add_tsk(struct taskstats *stats, struct task_struct *task);
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task);
 #else
-static inline void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static inline void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
+{}
+static inline void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
 {}
 #endif /* CONFIG_TASKSTATS */
 
 #ifdef CONFIG_TASK_XACCT
-extern void xacct_add_tsk(struct taskstats *stats, struct task_struct *p);
+void xacct_add_tsk(struct taskstats *stats, struct task_struct *p);
+void xacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task);
 extern void acct_update_integrals(struct task_struct *tsk);
 extern void acct_clear_integrals(struct task_struct *tsk);
 #else
 static inline void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 {}
+static inline void xacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{}
 static inline void acct_update_integrals(struct task_struct *tsk)
 {}
 static inline void acct_clear_integrals(struct task_struct *tsk)
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index a42b6c0..972bbfa 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -168,6 +168,63 @@ static void send_cpu_listeners(struct sk_buff *skb,
 	up_write(&listeners->sem);
 }
 
+/**
+ * add_tsk_stats - combine some thread specific stats in a taskstats
+ * @stats: the taskstats to write into
+ * @task: the thread to combine
+ *
+ * There are two types of taskstats fields when considering a thread group:
+ *	- those that can be aggregated from each thread in the group (like CPU
+ *	times),
+ *	- those that cannot be aggregated (like UID) or are identical (like
+ *	memory usage), so are taken from the group leader.
+ * XXX_add_tsk() methods deal with the first type while XXX_fill_threadgroup()
+ * with the second one.
+ */
+static void add_tsk_stats(struct taskstats *stats, struct task_struct *task)
+{
+	/*
+	 * Each accounting subsystem adds calls to its functions to combine
+	 * relevant parts of struct taskstsats for a single pid as follows:
+	 *
+	 *	per-task-foo-add_tsk_stats(stats, task);
+	 */
+
+	/* fill in delay acct fields */
+	delayacct_add_tsk(stats, task);
+
+	/* fill in basic acct fields */
+	bacct_add_tsk(stats, task);
+
+	/* fill in extended acct fields */
+	xacct_add_tsk(stats, task);
+}
+
+/**
+ * fill_threadgroup_stats - initialize some common stats for the thread group
+ * @stats: the taskstats to write into
+ * @task: the thread representing the whole group
+ *
+ * Will be called on the thread group leader if requesting stats for the whole
+ * thread group.
+ */
+static void fill_threadgroup_stats(struct taskstats *stats,
+				   struct task_struct *task)
+{
+	/*
+	 * Each accounting subsystem adds calls to its functions to initialize
+	 * relevant parts of struct taskstsats for a single tgid as follows:
+	 *
+	 *	per-task-foo-fill_threadgroup(stats, task);
+	 */
+
+	/* fill in basic acct fields */
+	bacct_fill_threadgroup(stats, task);
+
+	/* fill in extended acct fields */
+	xacct_fill_threadgroup(stats, task);
+}
+
 static int fill_pid(pid_t pid, struct task_struct *tsk, struct taskstats *stats)
 {
 	int rc = 0;
@@ -184,23 +241,11 @@ static int fill_pid(pid_t pid, struct task_struct *tsk, struct taskstats *stats)
 		get_task_struct(tsk);
 
 	memset(stats, 0, sizeof(*stats));
-	/*
-	 * Each accounting subsystem adds calls to its functions to
-	 * fill in relevant parts of struct taskstsats as follows
-	 *
-	 *	per-task-foo(stats, tsk);
-	 */
-
-	delayacct_add_tsk(stats, tsk);
-
-	/* fill in basic acct fields */
 	stats->version = TASKSTATS_VERSION;
 	stats->nvcsw = tsk->nvcsw;
 	stats->nivcsw = tsk->nivcsw;
-	bacct_add_tsk(stats, tsk);
-
-	/* fill in extended acct fields */
-	xacct_add_tsk(stats, tsk);
+	add_tsk_stats(stats, tsk);
+	fill_threadgroup_stats(stats, tsk);
 
 	/* Define err: label here if needed */
 	put_task_struct(tsk);
@@ -236,27 +281,20 @@ static int fill_tgid(pid_t tgid, struct task_struct *first,
 		if (tsk->exit_state)
 			continue;
 		/*
-		 * Accounting subsystem can call its functions here to
-		 * fill in relevant parts of struct taskstsats as follows
-		 *
-		 *	per-task-foo(stats, tsk);
+		 * This check is racy as a thread could exit just right
+		 * now and have its statistics accounted twice.
 		 */
-		delayacct_add_tsk(stats, tsk);
-
+		add_tsk_stats(stats, tsk);
 		stats->nvcsw += tsk->nvcsw;
 		stats->nivcsw += tsk->nivcsw;
 	} while_each_thread(first, tsk);
 
+	fill_threadgroup_stats(stats, first->group_leader);
 	unlock_task_sighand(first, &flags);
 	rc = 0;
 out:
 	rcu_read_unlock();
-
 	stats->version = TASKSTATS_VERSION;
-	/*
-	 * Accounting subsytems can also add calls here to modify
-	 * fields of taskstats.
-	 */
 	return rc;
 }
 
@@ -266,19 +304,14 @@ static void fill_tgid_exit(struct task_struct *tsk)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tsk->sighand->siglock, flags);
-	if (!tsk->signal->stats)
-		goto ret;
 
 	/*
-	 * Each accounting subsystem calls its functions here to
-	 * accumalate its per-task stats for tsk, into the per-tgid structure
-	 *
-	 *	per-task-foo(tsk->signal->stats, tsk);
+	 * The fill_threadgroup_stats() part of the statistics will be added by
+	 * the stats requester, i.e. fill_tgid() or taskstats_exit()
 	 */
-	delayacct_add_tsk(tsk->signal->stats, tsk);
-ret:
+	add_tsk_stats(tsk->signal->stats, tsk);
+
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
-	return;
 }
 
 static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
@@ -507,7 +540,13 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
 	if (!stats)
 		goto err;
 
+	/*
+	 * Race here: the last thread may have not finished its
+	 * fill_tgid_exit(), leaving an incomplete tsk->signal->stats
+	 */
+
 	memcpy(stats, tsk->signal->stats, sizeof(*stats));
+	fill_threadgroup_stats(stats, tsk->group_leader);
 
 send:
 	send_cpu_listeners(rep_skb, listeners);
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index e8c25d2..4caea73 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -40,13 +40,6 @@ static void fill_wall_times(struct taskstats *stats, struct task_struct *tsk)
 	stats->ac_btime = get_seconds() - ts.tv_sec;
 }
 
-/*
- * Later on, XXX_add_tsk() will need to be called after XXX_fill_threadgroup(),
- * so put the functions in this order
- */
-static void bacct_fill_threadgroup(struct taskstats *stats,
-				   struct task_struct *tsk);
-
 void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 {
 	if (tsk->flags & PF_SUPERPRIV)
@@ -64,12 +57,9 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 		cputime_to_msecs(tsk->stimescaled) * USEC_PER_MSEC;
 	stats->ac_minflt	+= tsk->min_flt;
 	stats->ac_majflt	+= tsk->maj_flt;
-
-	bacct_fill_threadgroup(stats, tsk);
 }
 
-static void bacct_fill_threadgroup(struct taskstats *stats,
-				   struct task_struct *tsk)
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *tsk)
 {
 	fill_wall_times(stats, tsk);
 
@@ -102,9 +92,6 @@ static void bacct_fill_threadgroup(struct taskstats *stats,
  * fill in extended accounting fields
  */
 
-static void xacct_fill_threadgroup(struct taskstats *stats,
-				   struct task_struct *tsk);
-
 void xacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 {
 	/* convert pages-jiffies to Mbyte-usec */
@@ -120,12 +107,9 @@ void xacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 	stats->write_bytes	+= tsk->ioac.write_bytes;
 	stats->cancelled_write_bytes += tsk->ioac.cancelled_write_bytes;
 #endif
-
-	xacct_fill_threadgroup(stats, tsk);
 }
 
-static void xacct_fill_threadgroup(struct taskstats *stats,
-				   struct task_struct *tsk)
+void xacct_fill_threadgroup(struct taskstats *stats, struct task_struct *tsk)
 {
 	struct mm_struct *mm;
 
