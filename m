Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631Ab0ARBAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0ARBAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340Ab0ARA77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:59:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:54292 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab0ARAxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:53:20 -0500
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/40] workqueue: merge feature parameters into flags
Date: Mon, 18 Jan 2010 09:57:23 +0900
Message-Id: <1263776272-382-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1263776272-382-1-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 00:52:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, __create_workqueue_key() takes @singlethread and
@freezeable paramters and store them separately in workqueue_struct.
Merge them into a single flags parameter and field and use
WQ_FREEZEABLE and WQ_SINGLE_THREAD.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |   25 +++++++++++++++----------
 kernel/workqueue.c        |   17 +++++++----------
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index ac06c55..495572a 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -184,13 +184,17 @@ static inline bool work_static(struct work_struct *work) { return false; }
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
@@ -200,19 +204,20 @@ __create_workqueue_key(const char *name, int singlethread, int freezeable,
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
index e16c457..579041f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -67,11 +67,10 @@ struct cpu_workqueue_struct {
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
@@ -203,9 +202,9 @@ static const struct cpumask *cpu_singlethread_map __read_mostly;
 static cpumask_var_t cpu_populated_map __read_mostly;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
-static inline int is_wq_single_threaded(struct workqueue_struct *wq)
+static inline bool is_wq_single_threaded(struct workqueue_struct *wq)
 {
-	return wq->singlethread;
+	return wq->flags & WQ_SINGLE_THREAD;
 }
 
 static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
@@ -456,7 +455,7 @@ static int worker_thread(void *__cwq)
 	struct cpu_workqueue_struct *cwq = __cwq;
 	DEFINE_WAIT(wait);
 
-	if (cwq->wq->freezeable)
+	if (cwq->wq->flags & WQ_FREEZEABLE)
 		set_freezable();
 
 	for (;;) {
@@ -981,8 +980,7 @@ static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 }
 
 struct workqueue_struct *__create_workqueue_key(const char *name,
-						int singlethread,
-						int freezeable,
+						unsigned int flags,
 						struct lock_class_key *key,
 						const char *lock_name)
 {
@@ -998,13 +996,12 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
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

