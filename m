Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbZLQMcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbZLQMcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933910AbZLQMc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:32:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:58103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764138AbZLQMc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:32:27 -0500
Date: Thu, 17 Dec 2009 12:31:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091217121830.060186433@chello.nl>
References: <20091217121830.060186433@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Assert task state bits at build time
Message-ID: <tip-e1781538cf5c870ab696e9b8f0a5c498d3900f2f@git.kernel.org>
Git-Commit-ID: e1781538cf5c870ab696e9b8f0a5c498d3900f2f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e1781538cf5c870ab696e9b8f0a5c498d3900f2f
Gitweb:     http://git.kernel.org/tip/e1781538cf5c870ab696e9b8f0a5c498d3900f2f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 17 Dec 2009 13:16:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 13:22:45 +0100

sched: Assert task state bits at build time

Since everybody is lazy and prone to forgetting things, make the
compiler help us a bit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20091217121830.060186433@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/array.c       |   18 ++++++++++--------
 include/linux/sched.h |    4 ++++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 96361e8..f560325 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -134,14 +134,14 @@ static inline void task_name(struct seq_file *m, struct task_struct *p)
  * simple bit tests.
  */
 static const char *task_state_array[] = {
-	"R (running)",		/*  0 */
-	"S (sleeping)",		/*  1 */
-	"D (disk sleep)",	/*  2 */
-	"T (stopped)",		/*  4 */
-	"t (tracing stop)",	/*  8 */
-	"Z (zombie)",		/* 16 */
-	"X (dead)",		/* 32 */
-	"x (dead)",		/* 64 */
+	"R (running)",		/*   0 */
+	"S (sleeping)",		/*   1 */
+	"D (disk sleep)",	/*   2 */
+	"T (stopped)",		/*   4 */
+	"t (tracing stop)",	/*   8 */
+	"Z (zombie)",		/*  16 */
+	"X (dead)",		/*  32 */
+	"x (dead)",		/*  64 */
 	"K (wakekill)",		/* 128 */
 	"W (waking)",		/* 256 */
 };
@@ -151,6 +151,8 @@ static inline const char *get_task_state(struct task_struct *tsk)
 	unsigned int state = (tsk->state & TASK_REPORT) | tsk->exit_state;
 	const char **p = &task_state_array[0];
 
+	BUILD_BUG_ON(1 + ilog2(TASK_STATE_MAX) != ARRAY_SIZE(task_state_array));
+
 	while (state) {
 		p++;
 		state >>= 1;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 94858df..3754387 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -192,9 +192,13 @@ print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 #define TASK_DEAD		64
 #define TASK_WAKEKILL		128
 #define TASK_WAKING		256
+#define TASK_STATE_MAX		512
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtZXxKW"
 
+extern char ___assert_task_state[1 - 2*!!(
+		sizeof(TASK_STATE_TO_CHAR_STR)-1 != ilog2(TASK_STATE_MAX)+1)];
+
 /* Convenience macros for the sake of set_task_state */
 #define TASK_KILLABLE		(TASK_WAKEKILL | TASK_UNINTERRUPTIBLE)
 #define TASK_STOPPED		(TASK_WAKEKILL | __TASK_STOPPED)
