Return-Path: <linux-kernel-owner+w=401wt.eu-S1751887AbZHKLyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbZHKLyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbZHKLyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:54:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42897 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbZHKLyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:35 -0400
Message-Id: <20090811111607.310739140@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Tue, 11 Aug 2009 21:09:06 +1000
From: npiggin@suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch 4/4] ipc: sem optimise simple operations
References: <20090811110902.255877673@suse.de>
Content-Disposition: inline; filename=ipc-sem-simple-lists.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sysv semaphores are used as a simple semaphore/mutex (single semop
operation on a single sem in the sem-array), the current implementation
is suboptimal because it has to handle the complex cases of multiple
operations atomically on multiple semaphores.

To optimise the simple case, add operations lists to struct sem, where
simple operations are added. When there are complex operations pending,
we ignore the simple lists and continue to use the old algorithm, however
when there are no complex operations, subsequent simple operations need
only look at the simple lists which can be done in a much simper way
(no need to search the list multiple times).

Timed with a simple test program to fork a number of threads which each
lock/unlock a sysv semaphore a number of times (with 1us busyloop in
each critical section and 10us busyloop outside). Run on 2s8c Opteron.

procs    time per loop vanilla  patched
    1     11986ns               11837ns
   32     10650ns                7746ns
  128     17103ns                8472ns
 1024    385885ns                9699ns

We hae a report of an SAP application with high idle time caused by very
high wait-time on a sysv semaphore, on which it is performing these "simple"
operations. Semaphore wait times are somewhat improved with this patch, and
sysv semaphore kernel functions are reduced by 40% in the profile (with this
and the previous patches combined). It is quite significant considering it
is measured on quite a small system (4s16c) and only with 64 processes.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 include/linux/sem.h |    6 ++
 ipc/sem.c           |  130 +++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 123 insertions(+), 13 deletions(-)

Index: linux-2.6/ipc/sem.c
===================================================================
--- linux-2.6.orig/ipc/sem.c
+++ linux-2.6/ipc/sem.c
@@ -240,6 +240,7 @@ static int newary(struct ipc_namespace *
 	key_t key = params->key;
 	int nsems = params->u.nsems;
 	int semflg = params->flg;
+	int i;
 
 	if (!nsems)
 		return -EINVAL;
@@ -272,6 +273,15 @@ static int newary(struct ipc_namespace *
 	ns->used_sems += nsems;
 
 	sma->sem_base = (struct sem *) &sma[1];
+
+	for (i = 0; i < nsems; i++) {
+		struct sem *s = &sma->sem_base[i];
+
+		INIT_LIST_HEAD(&s->negv_pending);
+		INIT_LIST_HEAD(&s->zero_pending);
+	}
+
+	sma->complex_count = 0;
 	INIT_LIST_HEAD(&sma->sem_pending);
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
@@ -335,7 +345,7 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
  * all at once. Return 0 if yes, 1 if need to sleep, else return error code.
  */
 
-static int try_atomic_semop (struct sem_array * sma, struct sembuf * sops,
+static int try_atomic_semop(struct sem_array * sma, struct sembuf * sops,
 			     int nsops, struct sem_undo *un, int pid)
 {
 	int result, sem_op;
@@ -421,7 +431,7 @@ static void wake_up_sem_queue(struct sem
 /* Go through the pending queue for the indicated semaphore
  * looking for tasks that can be completed.
  */
-static void update_queue (struct sem_array * sma)
+static void update_queue(struct sem_array *sma)
 {
 	struct sem_queue *q, *tq;
 
@@ -438,23 +448,94 @@ again:
 			continue;
 
 		list_del(&q->list);
+		if (q->nsops == 1)
+			list_del(&q->simple_list);
+		else
+			sma->complex_count--;
+
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
 
+static void update_zero_queue(struct sem_array *sma, struct sem *sem)
+{
+	struct sem_queue *q, *tq;
+
+	list_for_each_entry_safe(q, tq, &sem->zero_pending, simple_list) {
+		int error;
+
+		BUG_ON(q->nsops != 1);
+		BUG_ON(q->alter);
+		error = try_atomic_semop(sma, q->sops, q->nsops,
+					 q->undo, q->pid);
+		BUG_ON(error);
+
+		list_del(&q->list);
+		list_del(&q->simple_list);
+		wake_up_sem_queue(q, error);
+	}
+}
+
+static void update_negv_queue(struct sem_array *sma, struct sem *sem)
+{
+	struct sem_queue *q, *tq;
+
+	list_for_each_entry_safe(q, tq, &sem->negv_pending, simple_list) {
+		int error;
+
+		BUG_ON(q->nsops != 1);
+		BUG_ON(!q->alter);
+		error = try_atomic_semop(sma, q->sops, q->nsops,
+					 q->undo, q->pid);
+
+		/* Does q->sleeper still need to sleep? */
+		if (error > 0)
+			continue;
+
+		 /* Continue scanning as in update_queue */
+		list_del(&q->list);
+		list_del(&q->simple_list);
+		wake_up_sem_queue(q, error);
+
+		/*
+		 * negv queue should only decrease queue value, so there is
+		 * no point in retrying failed ops on the negv queue after
+		 * altering the sem value here. If the semval is not greater
+		 * than zero, then there will be nothing else to do either.
+		 */
+		if (sem->semval <= 0)
+			break;
+	}
+}
+
+static void update_queue_simple(struct sem_array *sma, ushort semnum)
+{
+	if (unlikely(sma->complex_count)) {
+		update_queue(sma);
+	} else {
+		struct sem *sem;
+
+		sem = &sma->sem_base[semnum];
+		if (sem->semval > 0)
+			update_negv_queue(sma, sem);
+		if (sem->semval == 0)
+			update_zero_queue(sma, sem);
+	}
+}
+
 /* The following counts are associated to each semaphore:
  *   semncnt        number of tasks waiting on semval being nonzero
  *   semzcnt        number of tasks waiting on semval being zero
@@ -532,6 +613,9 @@ static void freeary(struct ipc_namespace
 	/* Wake up all pending processes and let them fail with EIDRM. */
 	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
 		list_del(&q->list);
+		list_del(&q->simple_list);
+		if (q->nsops > 1)
+			sma->complex_count--;
 
 		wake_up_sem_queue(q, -EIDRM);
 	}
@@ -796,7 +880,7 @@ static int semctl_main(struct ipc_namesp
 		curr->sempid = task_tgid_vnr(current);
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue_simple(sma, semnum);
 		err = 0;
 		goto out_unlock;
 	}
@@ -1169,10 +1253,14 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	if (error)
 		goto out_unlock_free;
 
-	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
+	error = try_atomic_semop(sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
-		if (alter && error == 0)
-			update_queue (sma);
+		if (alter && !error) {
+			if (nsops == 1)
+				update_queue_simple(sma, sops->sem_num);
+			else
+				update_queue(sma);
+		}
 		goto out_unlock_free;
 	}
 
@@ -1189,6 +1277,17 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 		list_add_tail(&queue.list, &sma->sem_pending);
 	else
 		list_add(&queue.list, &sma->sem_pending);
+	if (nsops == 1) {
+		struct sem *curr;
+		curr = &sma->sem_base[sops->sem_num];
+		if (alter)
+			list_add_tail(&queue.simple_list, &curr->negv_pending);
+		else
+			list_add_tail(&queue.simple_list, &curr->zero_pending);
+	} else {
+		INIT_LIST_HEAD(&queue.simple_list);
+		sma->complex_count++;
+	}
 
 	queue.status = -EINTR;
 	queue.sleeper = current;
@@ -1232,6 +1331,10 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
 	list_del(&queue.list);
+	if (nsops == 1)
+		list_del(&queue.simple_list);
+	else
+		sma->complex_count--;
 
 out_unlock_free:
 	sem_unlock(sma);
@@ -1356,11 +1459,14 @@ void exit_sem(struct task_struct *tsk)
 				if (semaphore->semval > SEMVMX)
 					semaphore->semval = SEMVMX;
 				semaphore->sempid = task_tgid_vnr(current);
+				if (likely(!sma->complex_count))
+					update_queue_simple(sma, i);
 			}
 		}
 		sma->sem_otime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		if (unlikely(sma->complex_count))
+			update_queue(sma);
 		sem_unlock(sma);
 
 		call_rcu(&un->rcu, free_un);
@@ -1374,7 +1480,7 @@ static int sysvipc_sem_proc_show(struct
 	struct sem_array *sma = it;
 
 	return seq_printf(s,
-			  "%10d %10d  %4o %10lu %5u %5u %5u %5u %10lu %10lu\n",
+			  "%10d %10d  %4o %10u %5u %5u %5u %5u %10lu %10lu\n",
 			  sma->sem_perm.key,
 			  sma->sem_perm.id,
 			  sma->sem_perm.mode,
Index: linux-2.6/include/linux/sem.h
===================================================================
--- linux-2.6.orig/include/linux/sem.h
+++ linux-2.6/include/linux/sem.h
@@ -86,6 +86,8 @@ struct task_struct;
 struct sem {
 	int	semval;		/* current value */
 	int	sempid;		/* pid of last operation */
+	struct list_head	negv_pending;
+	struct list_head	zero_pending;
 };
 
 /* One sem_array data structure for each set of semaphores in the system. */
@@ -96,11 +98,13 @@ struct sem_array {
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


