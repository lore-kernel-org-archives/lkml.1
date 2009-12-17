Return-Path: <linux-kernel-owner+w=401wt.eu-S1764652AbZLQMUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764652AbZLQMUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764643AbZLQMTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:19:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764645AbZLQMTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:19:10 -0500
Message-Id: <20091217121830.060186433@chello.nl>
References: <20091217121626.682772324@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 17 Dec 2009 13:16:30 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/6] sched: Assert task state bits at build time
Content-Disposition: inline; filename=sched-state-3.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since everybody is lazy and prone to forgetting things, make the
compiler help us a bit.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 fs/proc/array.c       |   18 ++++++++++--------
 include/linux/sched.h |    4 ++++
 2 files changed, 14 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/proc/array.c
===================================================================
--- linux-2.6.orig/fs/proc/array.c
+++ linux-2.6/fs/proc/array.c
@@ -134,14 +134,14 @@ static inline void task_name(struct seq_
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
@@ -151,6 +151,8 @@ static inline const char *get_task_state
 	unsigned int state = (tsk->state & TASK_REPORT) | tsk->exit_state;
 	const char **p = &task_state_array[0];
 
+	BUILD_BUG_ON(1 + ilog2(TASK_STATE_MAX) != ARRAY_SIZE(task_state_array));
+
 	while (state) {
 		p++;
 		state >>= 1;
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -192,9 +192,13 @@ print_cfs_rq(struct seq_file *m, int cpu
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

-- 

