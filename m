Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbZHOKJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbZHOKJQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 06:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbZHOKJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 06:09:15 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:37563 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbZHOKJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 06:09:12 -0400
Message-ID: <4A86899A.6050502@colorfullife.com>
Date: Sat, 15 Aug 2009 12:10:34 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
References: <200908141946.n7EJkh7B018160@mail.q-ag.de> <20090815045237.GC19195@wotan.suse.de>
In-Reply-To: <20090815045237.GC19195@wotan.suse.de>
Content-Type: multipart/mixed;
 boundary="------------050501060607020604030308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050501060607020604030308
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 08/15/2009 06:52 AM, Nick Piggin wrote:
>
> The problem with using the same algorithm is that we don't need to
> "restart scanning" the simple-op lists when one of them succeeds.
> This is because if a negative op fails, then no amount of subsequent
> simple negative ops will make it succeed.
>
> With multi-ops, it can be adding and subtracting and waiting for
> zero of different sems etc, so in order to try to stay strictly
> FIFO, then we always have to recheck all previous failed ops after
> one succeeds.
>    
What prevents us from optimizing the complex algorithm?

Right now, the rule is "restart if q->alter".
What about "restart if at least one operation was an increment or if at 
least one
semaphore got 0"?

> The other problem is that we have to scan all ops in the multi-op
> list because we don't know what combination of sem values might
> allow the op to succeed. With the single-op lists, we know if the
> semval is 0, then we don't have to scan the negative list, and if
> it is non-0 then we don't have to scan the zero list.
>    
If semval is 0, then the negative list is empty - it doesn't cost 
anything to scan it, especially if the negative list is the first part 
of a joint list.

But you describe one difference between the simple and complex operations:
- complex "increment" operations can be in the queue.
- simple "increment" operations always succeed immediately.

Thus it is possible to stop scanning the simple queue if an "alter" 
operation is found and the semaphore value is 0.
For the complex queue, this optimization doesn't appear to be that simple.

AFAICS this is a realistic case:
- 1000 threads are waiting with "decrement by 1".
- semval is 0.
- an increment by 1 arrives.

I've optimized that case, too - it's just one test.

With both optimizations, I see only one case left where your algorithm 
is better:
- semaphore value 1.
- 1000 threads waiting for zero.
- an increment by 1 arrives.

My code would scan the 1000 entries, your code doesn't.
But: Does that exist in real life?

Btw,
- semaphore value 1
- 1000 threads with "decrement 2" are waiting
- an decrement by 1 arrives.
My code doesn't scan at all, AFAICS you would scan all 1000 entries.
The same argument applies:
I would bet that this case doesn't exist in real life.

Could you create a dump of the pending list from a test run?
Does your database use "wait for zero", or increment/decrement 
operations with offsets that are not +-1?
Do you see a common case where separate algorithms are necessary?

> Combine these two problems and that is where the O(n^2) behaviour
> comes in to the complex-op algorithm.
>    
Yes - the worst case remains O(n^2), but only if there are increments.
(to be fair: with the optimizations O(n*m) with n waiting tasks and m 
increments)

But OTHO neither of our patches solves that.

--
     Manfred

--------------050501060607020604030308
Content-Type: text/plain;
 name="0001--ipc-sem-optimise-simple-operations-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001--ipc-sem-optimise-simple-operations-v2.patch"

>From 563903cbc136b1b9c5b5f2b52d8acb0bbb6a8732 Mon Sep 17 00:00:00 2001
From: Manfred Spraul <manfred@colorfullife.com>
Date: Sat, 15 Aug 2009 11:48:21 +0200
Subject: [PATCH] [PATCH 4a/4] ipc: sem optimise simple operations, v2

An alternative patch to Nick's proposal:
http://lkml.org/lkml/2009/8/11/11
The patch is based on Nick's patch.

The patch is ontop of the first three patches from Nick.

I've added two additional optimizations for two common cases:
- do not restart scanning for all "alter" operations, only if necessary.
- stop scanning decrements if the semaphore value is already 0.

Identical with Nick's patch:
- per semaphore list to optimize single sop semop calls:
This avoids that the semaphore operations have to scan through all waiting
tasks, even for the tasks that are waiting on a different semaphore from
the same array.

Differences:
- same code for per-semaphore and global list.
- both simple and complex operations are improved.
- one list for both wait-for-zero and decrement instead of two lists.
- unlink_queue helper function.
- do not use likely/unlikely in exit_sem(): complex_count depends on the
  application, the kernel doesn't know anything about the running app.
  And: it's a very rare path.

Open points:
- further testing

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/sem.h |    5 ++-
 ipc/sem.c           |  148 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 122 insertions(+), 31 deletions(-)

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
index 3629ef8..ee49b38 100644
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
@@ -335,13 +344,16 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
  * all at once. Return 0 if yes, 1 if need to sleep, else return error code.
  */
 
-static int try_atomic_semop (struct sem_array * sma, struct sembuf * sops,
-			     int nsops, struct sem_undo *un, int pid)
+static int try_atomic_semop(struct sem_array * sma, struct sembuf * sops,
+			     int nsops, struct sem_undo *un, int pid,
+			     int *phelps)
 {
-	int result, sem_op;
+	int result, sem_op, helps;
 	struct sembuf *sop;
 	struct sem * curr;
 
+	helps = 0;
+
 	for (sop = sops; sop < sops + nsops; sop++) {
 		curr = sma->sem_base + sop->sem_num;
 		sem_op = sop->sem_op;
@@ -363,6 +375,15 @@ static int try_atomic_semop (struct sem_array * sma, struct sembuf * sops,
 			if (undo < (-SEMAEM - 1) || undo > SEMAEM)
 				goto out_of_range;
 		}
+		/* If we incremented a semaphore, or decremented
+		 * a semaphore to 0, then this might allow other operations to
+		 * proceed. Remember that.
+		 * Note: helps is only an optimization, it doesn't matter that
+		 * is is a bit conservative (e.g. decrement by 3, increment
+		 * that sem by 2 doesn't help, but the code returns "helps=1").
+		 */
+		if (sem_op > 0 || (sem_op < 0 && result == 0))
+			helps = 1;
 		curr->semval = result;
 	}
 
@@ -375,6 +396,7 @@ static int try_atomic_semop (struct sem_array * sma, struct sembuf * sops,
 	}
 	
 	sma->sem_otime = get_seconds();
+	*phelps = helps;
 	return 0;
 
 out_of_range:
@@ -394,6 +416,8 @@ undo:
 		sop--;
 	}
 
+	/* a failed operation can never help other operations. */
+	*phelps = 0;
 	return result;
 }
 
@@ -418,40 +442,85 @@ static void wake_up_sem_queue(struct sem_queue *q, int error)
 	preempt_enable();
 }
 
-/* Go through the pending queue for the indicated semaphore
- * looking for tasks that can be completed.
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
+/**
+ * update_queue(sma, semnum): Look for tasks that can be completed.
+ * @sma: semaphore array.
+ * @semnum: semaphore that was modified.
+ *
+ * update_queue must be called after a semaphore in a semaphore array
+ * was modified. If multiple semaphore were modified, then @semnum
+ * must be set to -1.
  */
-static void update_queue (struct sem_array * sma)
+static void update_queue(struct sem_array *sma, int semnum)
 {
 	struct sem_queue *q, *tq;
+	struct list_head *pending_list;
+
+	/* if there are complex operations around, then knowing the semaphore
+	 * that was modified doesn't help us. Assume that multiple semaphores
+	 * were modified.
+	 */
+	if (sma->complex_count)
+		semnum = -1;
+
+	if (semnum == -1)
+		pending_list = &sma->sem_pending;
+	else
+		pending_list = &sma->sem_base[semnum].sem_pending;
 
 again:
-	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
+	list_for_each_entry_safe(q, tq, pending_list, list) {
 		int error;
-		int alter;
+		int could_help;
+
+		/* If we are looking for only one semaphore and that semaphore
+		 * is 0, then it does not make sense to scan the "alter"
+		 * entries: simple increments that affect only one entry
+		 * succeed immediately and cannot be in the pending queue,
+		 * and decrements cannot succeed if the value is already 0.
+		 */
+		if (semnum != -1 && sma->sem_base[semnum].semval == 0 &&
+				q->alter)
+			break;
 
 		error = try_atomic_semop(sma, q->sops, q->nsops,
-					 q->undo, q->pid);
+					 q->undo, q->pid, &could_help);
 
-		/* Does q->sleeper still need to sleep? */
+		/* q still needs to sleep, nothing happened */
 		if (error > 0)
 			continue;
 
-		list_del(&q->list);
+		/* q must be woken up:
+		 * The semaphore operation was processed, either successfully
+		 * (error=0) or it failed (e.g. UNDO overflow).
+		 */
+		unlink_queue(sma, q);
+		wake_up_sem_queue(q, error);
 
 		/*
 		 * The next operation that must be checked depends on the type
 		 * of the completed operation:
-		 * - if the operation modified the array, then restart from the
-		 *   head of the queue and check for threads that might be
-		 *   waiting for semaphore values to become 0.
-		 * - if the operation didn't modify the array, then just
-		 *   continue.
+		 * - if we incremented something or if a semaphore value got 0,
+		 *   then restart from the head of pending list: there could
+		 *   be tasks that are waiting for this event.
 		 */
-		alter = q->alter;
-		wake_up_sem_queue(q, error);
-		if (alter)
+		if (could_help)
 			goto again;
+		/* - Otherwise: just continue scanning.
+		 */
 	}
 }
 
@@ -531,8 +600,7 @@ static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
 	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
-		list_del(&q->list);
-
+		unlink_queue(sma, q);
 		wake_up_sem_queue(q, -EIDRM);
 	}
 
@@ -754,7 +822,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, -1);
 		err = 0;
 		goto out_unlock;
 	}
@@ -796,7 +864,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		curr->sempid = task_tgid_vnr(current);
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, semnum);
 		err = 0;
 		goto out_unlock;
 	}
@@ -1072,7 +1140,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	struct sembuf fast_sops[SEMOPM_FAST];
 	struct sembuf* sops = fast_sops, *sop;
 	struct sem_undo *un;
-	int undos = 0, alter = 0, max;
+	int undos = 0, alter = 0, max, could_help;
 	struct sem_queue queue;
 	unsigned long jiffies_left = 0;
 	struct ipc_namespace *ns;
@@ -1169,10 +1237,15 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	if (error)
 		goto out_unlock_free;
 
-	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
+	error = try_atomic_semop(sma, sops, nsops, un,
+					task_tgid_vnr(current), &could_help);
 	if (error <= 0) {
-		if (alter && error == 0)
-			update_queue (sma);
+		if (could_help) {
+			if (nsops == 1)
+				update_queue(sma, sops->sem_num);
+			else
+				update_queue(sma, -1);
+		}
 		goto out_unlock_free;
 	}
 
@@ -1189,6 +1262,18 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
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
@@ -1231,7 +1316,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	 */
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
-	list_del(&queue.list);
+	unlink_queue(sma, &queue);
 
 out_unlock_free:
 	sem_unlock(sma);
@@ -1356,11 +1441,14 @@ void exit_sem(struct task_struct *tsk)
 				if (semaphore->semval > SEMVMX)
 					semaphore->semval = SEMVMX;
 				semaphore->sempid = task_tgid_vnr(current);
+				if (!sma->complex_count)
+					update_queue(sma, i);
 			}
 		}
 		sma->sem_otime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		if (sma->complex_count)
+			update_queue(sma, -1);
 		sem_unlock(sma);
 
 		call_rcu(&un->rcu, free_un);
@@ -1374,7 +1462,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 	struct sem_array *sma = it;
 
 	return seq_printf(s,
-			  "%10d %10d  %4o %10lu %5u %5u %5u %5u %10lu %10lu\n",
+			  "%10d %10d  %4o %10u %5u %5u %5u %5u %10lu %10lu\n",
 			  sma->sem_perm.key,
 			  sma->sem_perm.id,
 			  sma->sem_perm.mode,
-- 
1.6.2.5


--------------050501060607020604030308--
