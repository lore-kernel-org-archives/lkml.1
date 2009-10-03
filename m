Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZJCRUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZJCRUM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 13:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbZJCRUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 13:20:06 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:34926 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbZJCRUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 13:20:01 -0400
From: manfred@colorfullife.com
To: linux-kernel@vger.kernel.org
Cc: Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 5/7] ipc/sem.c: add a per-semaphore pending list
Date: Sat,  3 Oct 2009 19:19:22 +0200
Message-Id: <1254590364-2876-3-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1254590364-2876-2-git-send-email-manfred@colorfullife.com>
References: <1254590364-2876-1-git-send-email-manfred@colorfullife.com>
 <1254590364-2876-2-git-send-email-manfred@colorfullife.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manfred Spraul <manfred@colorfullife.com>

Based on Nick's findings:

sysv sem has the concept of semaphore arrays that consist out of multiple
semaphores. Atomic operations that affect multiple semaphores are supported.

The patch is the first step for optimizing simple, single semaphore operations:
In addition to the global list of all pending operations, a 2nd, per-semaphore
list with the simple operations is added.

Note: this patch does not make sense by itself, the new list is used nowhere.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/sem.h |    5 ++++-
 ipc/sem.c           |   37 ++++++++++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 1b191c1..8a4adbe 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -86,6 +86,7 @@ struct task_struct;
 struct sem {
 	int	semval;		/* current value */
 	int	sempid;		/* pid of last operation */
+	struct list_head sem_pending; /* pending single-sop operations */
 };
 
 /* One sem_array data structure for each set of semaphores in the system. */
@@ -96,11 +97,13 @@ struct sem_array {
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
 	struct list_head	sem_pending;	/* pending operations to be processed */
 	struct list_head	list_id;	/* undo requests on this array */
-	unsigned long		sem_nsems;	/* no. of semaphores in array */
+	int			sem_nsems;	/* no. of semaphores in array */
+	int			complex_count;	/* pending complex operations */
 };
 
 /* One queue for each sleeping process in the system. */
 struct sem_queue {
+	struct list_head	simple_list; /* queue of pending operations */
 	struct list_head	list;	 /* queue of pending operations */
 	struct task_struct	*sleeper; /* this process */
 	struct sem_undo		*undo;	 /* undo structure */
diff --git a/ipc/sem.c b/ipc/sem.c
index 9425817..0cad759 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -240,6 +240,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	key_t key = params->key;
 	int nsems = params->u.nsems;
 	int semflg = params->flg;
+	int i;
 
 	if (!nsems)
 		return -EINVAL;
@@ -272,6 +273,11 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	ns->used_sems += nsems;
 
 	sma->sem_base = (struct sem *) &sma[1];
+
+	for (i = 0; i < nsems; i++)
+		INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
+
+	sma->complex_count = 0;
 	INIT_LIST_HEAD(&sma->sem_pending);
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
@@ -418,6 +424,15 @@ static void wake_up_sem_queue(struct sem_queue *q, int error)
 	preempt_enable();
 }
 
+static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
+{
+	list_del(&q->list);
+	if (q->nsops == 1)
+		list_del(&q->simple_list);
+	else
+		sma->complex_count--;
+}
+
 /* Go through the pending queue for the indicated semaphore
  * looking for tasks that can be completed.
  */
@@ -437,7 +452,7 @@ again:
 		if (error > 0)
 			continue;
 
-		list_del(&q->list);
+		unlink_queue(sma, q);
 
 		/*
 		 * The next operation that must be checked depends on the type
@@ -531,8 +546,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
 	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
-		list_del(&q->list);
-
+		unlink_queue(sma, q);
 		wake_up_sem_queue(q, -EIDRM);
 	}
 
@@ -1190,6 +1204,19 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	else
 		list_add(&queue.list, &sma->sem_pending);
 
+	if (nsops == 1) {
+		struct sem *curr;
+		curr = &sma->sem_base[sops->sem_num];
+
+		if (alter)
+			list_add_tail(&queue.simple_list, &curr->sem_pending);
+		else
+			list_add(&queue.simple_list, &curr->sem_pending);
+	} else {
+		INIT_LIST_HEAD(&queue.simple_list);
+		sma->complex_count++;
+	}
+
 	queue.status = -EINTR;
 	queue.sleeper = current;
 	current->state = TASK_INTERRUPTIBLE;
@@ -1231,7 +1258,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	 */
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
-	list_del(&queue.list);
+	unlink_queue(sma, &queue);
 
 out_unlock_free:
 	sem_unlock(sma);
@@ -1374,7 +1401,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 	struct sem_array *sma = it;
 
 	return seq_printf(s,
-			  "%10d %10d  %4o %10lu %5u %5u %5u %5u %10lu %10lu\n",
+			  "%10d %10d  %4o %10u %5u %5u %5u %5u %10lu %10lu\n",
 			  sma->sem_perm.key,
 			  sma->sem_perm.id,
 			  sma->sem_perm.mode,
-- 
1.6.2.5

