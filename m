Return-Path: <linux-kernel-owner+w=401wt.eu-S1761911AbXIZRJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761911AbXIZRJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 13:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761332AbXIZRIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 13:08:42 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38597
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761284AbXIZRIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 13:08:40 -0400
X-IronPort-AV: E=Sophos;i="4.21,198,1188770400"; 
   d="scan'208";a="3292254"
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH 5/8] taskstats: factor out version and context switch
	accounting
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>, Balbir Singh <balbir@in.ibm.com>,
       Jay Lan <jlan@engr.sgi.com>, Jonathan Lim <jlim@sgi.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Date: Wed, 26 Sep 2007 19:08:39 +0200
Message-ID: <20070926170839.31221.1349.stgit@cheypa.inria.fr>
In-Reply-To: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
References: <20070926170818.31221.33994.stgit@cheypa.inria.fr>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All the specific taskstats fields should only be manipulated in
{add_tsk,fill_threadgroup}_stats().

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---

 kernel/taskstats.c |   21 ++++++++-------------
 kernel/tsacct.c    |    3 +++
 2 files changed, 11 insertions(+), 13 deletions(-)


diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 972bbfa..f25bf03 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -218,6 +218,8 @@ static void fill_threadgroup_stats(struct taskstats *stats,
 	 *	per-task-foo-fill_threadgroup(stats, task);
 	 */
 
+	stats->version = TASKSTATS_VERSION;
+
 	/* fill in basic acct fields */
 	bacct_fill_threadgroup(stats, task);
 
@@ -241,9 +243,6 @@ static int fill_pid(pid_t pid, struct task_struct *tsk, struct taskstats *stats)
 		get_task_struct(tsk);
 
 	memset(stats, 0, sizeof(*stats));
-	stats->version = TASKSTATS_VERSION;
-	stats->nvcsw = tsk->nvcsw;
-	stats->nivcsw = tsk->nivcsw;
 	add_tsk_stats(stats, tsk);
 	fill_threadgroup_stats(stats, tsk);
 
@@ -278,15 +277,12 @@ static int fill_tgid(pid_t tgid, struct task_struct *first,
 
 	tsk = first;
 	do {
-		if (tsk->exit_state)
-			continue;
-		/*
-		 * This check is racy as a thread could exit just right
-		 * now and have its statistics accounted twice.
-		 */
-		add_tsk_stats(stats, tsk);
-		stats->nvcsw += tsk->nvcsw;
-		stats->nivcsw += tsk->nivcsw;
+		if (!tsk->exit_state)
+			/*
+			 * This check is racy as a thread could exit just right
+			 * now and have its statistics accounted twice.
+			 */
+			add_tsk_stats(stats, tsk);
 	} while_each_thread(first, tsk);
 
 	fill_threadgroup_stats(stats, first->group_leader);
@@ -294,7 +290,6 @@ static int fill_tgid(pid_t tgid, struct task_struct *first,
 	rc = 0;
 out:
 	rcu_read_unlock();
-	stats->version = TASKSTATS_VERSION;
 	return rc;
 }
 
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 4caea73..73b4c69 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -57,6 +57,9 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
 		cputime_to_msecs(tsk->stimescaled) * USEC_PER_MSEC;
 	stats->ac_minflt	+= tsk->min_flt;
 	stats->ac_majflt	+= tsk->maj_flt;
+
+	stats->nvcsw		+= tsk->nvcsw;
+	stats->nivcsw		+= tsk->nivcsw;
 }
 
 void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *tsk)
