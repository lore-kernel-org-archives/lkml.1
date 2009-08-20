Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbZHTKUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbZHTKUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753934AbZHTKUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:20:22 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60126 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbZHTKRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:17:52 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/6] workqueue: replace singlethread/freezable/rt parameters and variables with flags
Date: Thu, 20 Aug 2009 12:17:37 +0200
Message-Id: <1250763466-24282-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
In-Reply-To: <1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
 <1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collapse the three ints into a flags variable, in preparation for
adding another flag.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/workqueue.h |   32 ++++++++++++++++++--------------
 kernel/workqueue.c        |   22 ++++++++--------------
 2 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 13e1adf..f14e20e 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -165,12 +165,17 @@ struct execute_work {
 
 
 extern struct workqueue_struct *
-__create_workqueue_key(const char *name, int singlethread,
-		       int freezeable, int rt, struct lock_class_key *key,
-		       const char *lock_name);
+__create_workqueue_key(const char *name, unsigned int flags,
+		       struct lock_class_key *key, const char *lock_name);
+
+enum {
+	WQ_F_SINGLETHREAD	= 1,
+	WQ_F_FREEZABLE		= 2,
+	WQ_F_RT			= 4,
+};
 
 #ifdef CONFIG_LOCKDEP
-#define __create_workqueue(name, singlethread, freezeable, rt)	\
+#define __create_workqueue(name, flags)				\
 ({								\
 	static struct lock_class_key __key;			\
 	const char *__lock_name;				\
@@ -180,20 +185,19 @@ __create_workqueue_key(const char *name, int singlethread,
 	else							\
 		__lock_name = #name;				\
 								\
-	__create_workqueue_key((name), (singlethread),		\
-			       (freezeable), (rt), &__key,	\
-			       __lock_name);			\
+	__create_workqueue_key((name), (flags), &__key, __lockname);	\
 })
 #else
-#define __create_workqueue(name, singlethread, freezeable, rt)	\
-	__create_workqueue_key((name), (singlethread), (freezeable), (rt), \
-			       NULL, NULL)
+#define __create_workqueue(name, flags)				\
+	__create_workqueue_key((name), (flags), NULL, NULL)	
 #endif
 
-#define create_workqueue(name) __create_workqueue((name), 0, 0, 0)
-#define create_rt_workqueue(name) __create_workqueue((name), 0, 0, 1)
-#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1, 0)
-#define create_singlethread_workqueue(name) __create_workqueue((name), 1, 0, 0)
+#define create_workqueue(name)		__create_workqueue((name), 0)
+#define create_rt_workqueue(name)	__create_workqueue((name), WQ_F_RT)
+#define create_freezeable_workqueue(name)	\
+	__create_workqueue((name), WQ_F_SINGLETHREAD | WQ_F_FREEZABLE)
+#define create_singlethread_workqueue(name)	\
+	__create_workqueue((name), WQ_F_SINGLETHREAD)
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0668795..02ba7c9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -60,9 +60,7 @@ struct workqueue_struct {
 	struct cpu_workqueue_struct *cpu_wq;
 	struct list_head list;
 	const char *name;
-	int singlethread;
-	int freezeable;		/* Freeze threads during suspend */
-	int rt;
+	unsigned int flags;	/* WQ_F_* flags */
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map lockdep_map;
 #endif
@@ -84,9 +82,9 @@ static const struct cpumask *cpu_singlethread_map __read_mostly;
 static cpumask_var_t cpu_populated_map __read_mostly;
 
 /* If it's single threaded, it isn't in the list of workqueues. */
-static inline int is_wq_single_threaded(struct workqueue_struct *wq)
+static inline bool is_wq_single_threaded(struct workqueue_struct *wq)
 {
-	return wq->singlethread;
+	return wq->flags & WQ_F_SINGLETHREAD;
 }
 
 static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
@@ -314,7 +312,7 @@ static int worker_thread(void *__cwq)
 	struct cpu_workqueue_struct *cwq = __cwq;
 	DEFINE_WAIT(wait);
 
-	if (cwq->wq->freezeable)
+	if (cwq->wq->flags & WQ_F_FREEZABLE)
 		set_freezable();
 
 	set_user_nice(current, -5);
@@ -768,7 +766,7 @@ static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 	 */
 	if (IS_ERR(p))
 		return PTR_ERR(p);
-	if (cwq->wq->rt)
+	if (cwq->wq->flags & WQ_F_RT)
 		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
 	cwq->thread = p;
 
@@ -789,9 +787,7 @@ static void start_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
 }
 
 struct workqueue_struct *__create_workqueue_key(const char *name,
-						int singlethread,
-						int freezeable,
-						int rt,
+						unsigned int flags,
 						struct lock_class_key *key,
 						const char *lock_name)
 {
@@ -811,12 +807,10 @@ struct workqueue_struct *__create_workqueue_key(const char *name,
 
 	wq->name = name;
 	lockdep_init_map(&wq->lockdep_map, lock_name, key, 0);
-	wq->singlethread = singlethread;
-	wq->freezeable = freezeable;
-	wq->rt = rt;
+	wq->flags = flags;
 	INIT_LIST_HEAD(&wq->list);
 
-	if (singlethread) {
+	if (flags & WQ_F_SINGLETHREAD) {
 		cwq = init_cpu_workqueue(wq, singlethread_cpu);
 		err = create_workqueue_thread(cwq, singlethread_cpu);
 		start_workqueue_thread(cwq, -1);
-- 
1.6.4.173.g3f189

