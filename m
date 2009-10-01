Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbZJAIKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbZJAIKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbZJAIKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:10:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:38394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755893AbZJAIKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:10:30 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/19] workqueue: merge feature parametesr into flags
Date: Thu,  1 Oct 2009 17:09:08 +0900
Message-Id: <1254384558-1018-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 08:09:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, __create_workqueue_key() takes @singlethread and
@freezeable paramters and store them separately in workqueue_struct.
Merge them into a single flags parameter and field and use
WQ_FREEZEABLE and WQ_SINGLE_THREAD.

NOT_SIGNED_OFF_YET
---
 include/linux/workqueue.h |   25 +++++++++++++++----------
 kernel/workqueue.c        |   17 +++++++----------
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 05f0998..d3334a0 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -163,13 +163,17 @@ struct execute_work {
 #define work_clear_pending(work) \
 	clear_bit(WORK_STRUCT_PENDING, work_data_bits(work))
 
+enum {
+	WQ_FREEZEABLE		= 1 << 0, /* freeze during suspend */
+	WQ_SINGLE_THREAD	= 1 << 1, /* no per-cpu worker */
+};
 
 extern struct workqueue_struct *
-__create_workqueue_key(const char *name, int singlethread, int freezeable,
+__create_workqueue_key(const char *name, unsigned int flags,
 		       struct lock_class_key *key, const char *lock_name);
 
 #ifdef CONFIG_LOCKDEP
-#define __create_workqueue(name, singlethread, freezeable)	\
+#define __create_workqueue(name, flags)				\
 ({								\
 	static struct lock_class_key __key;			\
 	const char *__lock_name;				\
@@ -179,19 +183,20 @@ __create_workqueue_key(const char *name, int singlethread, int freezeable,
 	else							\
 		__lock_name = #name;				\
 								\
-	__create_workqueue_key((name), (singlethread),		\
-			       (freezeable), &__key,		\
+	__create_workqueue_key((name), (flags), &__key,		\
 			       __lock_name);			\
 })
 #else
-#define __create_workqueue(name, singlethread, freezeable)	\
-	__create_workqueue_key((name), (singlethread), (freezeable), \
-			       NULL, NULL)
+#define __create_workqueue(name, flags)				\
+	__create_workqueue_key((name), (flags), NULL, NULL)
 #endif
 
-#define create_workqueue(name) __create_workqueue((name), 0, 0)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
-#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0)
+#define create_workqueue(name)					\
+	__create_workqueue((name), 0)
+#define create_freezeable_workqueue(name)			\
+	__create_workqueue((name), WQ_FREEZEABLE | WQ_SINGLE_THREAD)
+#define create_singlethread_workqueue(name)			\
+	__create_workqueue((name), WQ_SINGLE_THREAD)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 10c0cc4..befda6c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -69,11 +69,10 @@ struct cpu_workqueue_struct {
  * per-CPU workqueues:
  */
 struct workqueue_struct {
+	unsigned int		flags;		/* I: WQ_* flags */
 	struct cpu_workqueue_struct *cpu_wq;	/* I: cwq's */
 	struct list_head	list;		/* W: list of all workqueues */
 	const char		*name;		/* I: workqueue name */
-	int singlethread;
-	int freezeable;		/* Freeze threads during suspend */
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
 #endif
@@ -95,9 +94,9 @@ static const struct cpumask *cpu_singlethread_map __read_mostly;
 static cpumask_var_t cpu_populated_map __read_mostly;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
-static inline int is_wq_single_threaded(struct workqueue_struct *wq)
+static inline bool is_wq_single_threaded(struct workqueue_struct *wq)
 {
-	return wq->singlethread;
+	return wq->flags & WQ_SINGLE_THREAD;
 }
 
 static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
@@ -363,7 +362,7 @@ static int worker_thread(void *__cwq)
 	/* set workqueue scheduler */
 	switch_sched_workqueue(current, true);
 
-	if (cwq->wq->freezeable)
+	if (cwq->wq->flags & WQ_FREEZEABLE)
 		set_freezable();
 
 	for (;;) {
@@ -832,8 +831,7 @@ static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 }
 
 struct workqueue_struct *__create_workqueue_key(const char *name,
-						int singlethread,
-						int freezeable,
+						unsigned int flags,
 						struct lock_class_key *key,
 						const char *lock_name)
 {
@@ -849,13 +847,12 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 	if (!wq->cpu_wq)
 		goto err;
 
+	wq->flags = flags;
 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
-	wq->singlethread = singlethread;
-	wq->freezeable = freezeable;
 	INIT_LIST_HEAD(&wq->list);
 
-	if (singlethread) {
+	if (flags & WQ_SINGLE_THREAD) {
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
 		err = create_workqueue_thread(cwq, singlethread_cpu);
 		start_workqueue_thread(cwq, -1);
-- 
1.6.4.2

