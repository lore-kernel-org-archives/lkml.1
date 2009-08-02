Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZHBNOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZHBNOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 09:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZHBNOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 09:14:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:33866 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbZHBNOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 09:14:17 -0400
Date: Sun, 2 Aug 2009 13:13:40 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:sched/core] sched: Add debug check to task_of()
Message-ID: <tip-8f48894fcc89ddec62e1762f73a0825793e59e91@git.kernel.org>
Git-Commit-ID: 8f48894fcc89ddec62e1762f73a0825793e59e91
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 02 Aug 2009 13:13:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f48894fcc89ddec62e1762f73a0825793e59e91
Gitweb:     http://git.kernel.org/tip/8f48894fcc89ddec62e1762f73a0825793e59e91
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 24 Jul 2009 12:25:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 2 Aug 2009 14:26:14 +0200

sched: Add debug check to task_of()

A frequent mistake appears to be to call task_of() on a
scheduler entity that is not actually a task, which can result
in a wild pointer.

Add a check to catch these mistakes.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/sched_fair.c |   20 ++++++++++++++------
 kernel/sched_rt.c   |   16 ++++++++++++----
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 4934729..342000b 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -79,11 +79,6 @@ static const struct sched_class fair_sched_class;
  * CFS operations on generic schedulable entities:
  */
 
-static inline struct task_struct *task_of(struct sched_entity *se)
-{
-	return container_of(se, struct task_struct, se);
-}
-
 #ifdef CONFIG_FAIR_GROUP_SCHED
 
 /* cpu runqueue to which this cfs_rq is attached */
@@ -95,6 +90,14 @@ static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
 /* An entity is a task if it doesn't "own" a runqueue */
 #define entity_is_task(se)	(!se->my_q)
 
+static inline struct task_struct *task_of(struct sched_entity *se)
+{
+#ifdef CONFIG_SCHED_DEBUG
+	WARN_ON_ONCE(!entity_is_task(se));
+#endif
+	return container_of(se, struct task_struct, se);
+}
+
 /* Walk up scheduling entities hierarchy */
 #define for_each_sched_entity(se) \
 		for (; se; se = se->parent)
@@ -186,7 +189,12 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 	}
 }
 
-#else	/* CONFIG_FAIR_GROUP_SCHED */
+#else	/* !CONFIG_FAIR_GROUP_SCHED */
+
+static inline struct task_struct *task_of(struct sched_entity *se)
+{
+	return container_of(se, struct task_struct, se);
+}
 
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
 {
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 13f728e..f365e66 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -3,15 +3,18 @@
  * policies)
  */
 
+#ifdef CONFIG_RT_GROUP_SCHED
+
+#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
+
 static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
 {
+#ifdef CONFIG_SCHED_DEBUG
+	WARN_ON_ONCE(!rt_entity_is_task(rt_se));
+#endif
 	return container_of(rt_se, struct task_struct, rt);
 }
 
-#ifdef CONFIG_RT_GROUP_SCHED
-
-#define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
-
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
 	return rt_rq->rq;
@@ -26,6 +29,11 @@ static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
 
 #define rt_entity_is_task(rt_se) (1)
 
+static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
+{
+	return container_of(rt_se, struct task_struct, rt);
+}
+
 static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
 {
 	return container_of(rt_rq, struct rq, rt);
