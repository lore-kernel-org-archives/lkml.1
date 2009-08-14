Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbZHNUNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbZHNUNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757063AbZHNUNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:13:13 -0400
Received: from sing.entic.net ([208.64.63.147]:52783 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607AbZHNUNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:13:12 -0400
X-Greylist: delayed 1587 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Aug 2009 16:13:12 EDT
Message-Id: <200908141946.n7EJkh7B018160@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: npiggin@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 14 Aug 2009 21:16:00 +0200
Subject: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An alternative patch to Nick's proposal:
http://lkml.org/lkml/2009/8/11/11
The patch is based on Nick's patch.

The patch is ontop of the first three patches from Nick.

Identical with Nick's patch:
- per semaphore list to optimize single sop semop calls:
This avoids that the semaphore operations have to scan through all waiting
tasks, even for the tasks that are waiting on a different semaphore from
the same array.

Differences:
- same code for per-semaphore and global list.
- one list for both wait-for-zero and decrement instead of two lists.
- unlink_queue helper function

Open points:
- further testing
- understand all changes. e.g. why switch from "if (alter)" to
	"if (alter & !error)" in update_queue

>From the diffstat, it's simpler: 50 new lines instead of 110 new lines.

Nick: What do you think? Could you try your test app?

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/sem.h |    5 ++-
 ipc/sem.c           |   83 ++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 69 insertions(+), 19 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 1b191c1..ea03058 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -86,6 +86,7 @@ struct task_struct;
 struct sem {
 	int	semval;		/* current value */
 	int	sempid;		/* pid of last operation */
+	struct list_head	sem_pending;	/* pending operations to be processed */
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
index 3629ef8..495449e 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -240,6 +240,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	key_t key = params->key;
 	int nsems = params->u.nsems;
 	int semflg = params->flg;
+	int i;
 
 	if (!nsems)
 		return -EINVAL;
@@ -272,6 +273,14 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	ns->used_sems += nsems;
 
 	sma->sem_base = (struct sem *) &sma[1];
+
+	for (i = 0; i < nsems; i++) {
+		struct sem *s = &sma->sem_base[i];
+
+		INIT_LIST_HEAD(&s->sem_pending);
+	}
+
+	sma->complex_count = 0;
 	INIT_LIST_HEAD(&sma->sem_pending);
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
@@ -335,7 +344,7 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
  * all at once. Return 0 if yes, 1 if need to sleep, else return error code.
  */
 
-static int try_atomic_semop (struct sem_array * sma, struct sembuf * sops,
+static int try_atomic_semop(struct sem_array * sma, struct sembuf * sops,
 			     int nsops, struct sem_undo *un, int pid)
 {
 	int result, sem_op;
@@ -418,15 +427,35 @@ static void wake_up_sem_queue(struct sem_queue *q, int error)
 	preempt_enable();
 }
 
+static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
+{
+	list_del(&q->list);
+	if (q->nsops == 1) {
+		BUG_ON(list_empty(&q->simple_list));
+		list_del(&q->simple_list);
+	} else {
+		BUG_ON(!list_empty(&q->simple_list));
+		sma->complex_count--;
+	}
+}
+
+
 /* Go through the pending queue for the indicated semaphore
  * looking for tasks that can be completed.
  */
-static void update_queue (struct sem_array * sma)
+static void update_queue(struct sem_array *sma, int semnum)
 {
 	struct sem_queue *q, *tq;
+	struct list_head *pending_list;
 
 again:
-	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
+	if (semnum == -1 || sma->complex_count) {
+		pending_list = &sma->sem_pending;
+	} else {
+		pending_list = &sma->sem_base[semnum].sem_pending;
+	}
+
+	list_for_each_entry_safe(q, tq, pending_list, list) {
 		int error;
 		int alter;
 
@@ -436,21 +465,21 @@ again:
 		/* Does q->sleeper still need to sleep? */
 		if (error > 0)
 			continue;
+		unlink_queue(sma, q);
 
-		list_del(&q->list);
+		alter = q->alter;
+		wake_up_sem_queue(q, error);
 
 		/*
 		 * The next operation that must be checked depends on the type
 		 * of the completed operation:
 		 * - if the operation modified the array, then restart from the
 		 *   head of the queue and check for threads that might be
-		 *   waiting for semaphore values to become 0.
+		 *   waiting for this particular semaphore value.
 		 * - if the operation didn't modify the array, then just
 		 *   continue.
 		 */
-		alter = q->alter;
-		wake_up_sem_queue(q, error);
-		if (alter)
+		if (alter && !error)
 			goto again;
 	}
 }
@@ -531,8 +560,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
 	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
-		list_del(&q->list);
-
+		unlink_queue(sma, q);
 		wake_up_sem_queue(q, -EIDRM);
 	}
 
@@ -754,7 +782,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, -1);
 		err = 0;
 		goto out_unlock;
 	}
@@ -796,7 +824,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		curr->sempid = task_tgid_vnr(current);
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, semnum);
 		err = 0;
 		goto out_unlock;
 	}
@@ -1169,10 +1197,14 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	if (error)
 		goto out_unlock_free;
 
-	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
+	error = try_atomic_semop(sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
-		if (alter && error == 0)
-			update_queue (sma);
+		if (alter && !error) {
+			if (nsops == 1)
+				update_queue(sma, sops->sem_num);
+			else
+				update_queue(sma, -1);
+		}
 		goto out_unlock_free;
 	}
 
@@ -1189,6 +1221,18 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		list_add_tail(&queue.list, &sma->sem_pending);
 	else
 		list_add(&queue.list, &sma->sem_pending);
+	if (nsops == 1) {
+		struct sem *curr;
+		curr = &sma->sem_base[sops->sem_num];
+
+		if (alter)
+			list_add_tail(&queue.list, &curr->sem_pending);
+		else
+			list_add(&queue.list, &curr->sem_pending);
+	} else {
+		INIT_LIST_HEAD(&queue.simple_list);
+		sma->complex_count++;
+	}
 
 	queue.status = -EINTR;
 	queue.sleeper = current;
@@ -1231,7 +1275,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	 */
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
-	list_del(&queue.list);
+	unlink_queue(sma, &queue);
 
 out_unlock_free:
 	sem_unlock(sma);
@@ -1356,11 +1400,14 @@ void exit_sem(struct task_struct *tsk)
 				if (semaphore->semval > SEMVMX)
 					semaphore->semval = SEMVMX;
 				semaphore->sempid = task_tgid_vnr(current);
+				if (likely(!sma->complex_count))
+					update_queue(sma, i);
 			}
 		}
 		sma->sem_otime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		if (unlikely(sma->complex_count))
+			update_queue(sma, -1);
 		sem_unlock(sma);
 
 		call_rcu(&un->rcu, free_un);
@@ -1374,7 +1421,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 	struct sem_array *sma = it;
 
 	return seq_printf(s,
-			  "%10d %10d  %4o %10lu %5u %5u %5u %5u %10lu %10lu\n",
+			  "%10d %10d  %4o %10u %5u %5u %5u %5u %10lu %10lu\n",
 			  sma->sem_perm.key,
 			  sma->sem_perm.id,
 			  sma->sem_perm.mode,
-- 
1.6.2.5

