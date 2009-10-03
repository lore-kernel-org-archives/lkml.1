Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZJCRUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZJCRUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 13:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbZJCRUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 13:20:39 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:38851 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926AbZJCRUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 13:20:38 -0400
From: manfred@colorfullife.com
To: linux-kernel@vger.kernel.org
Cc: Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 6/7] ipc/sem.c: optimize single semop operations
Date: Sat,  3 Oct 2009 19:19:23 +0200
Message-Id: <1254590364-2876-4-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1254590364-2876-3-git-send-email-manfred@colorfullife.com>
References: <1254590364-2876-1-git-send-email-manfred@colorfullife.com>
 <1254590364-2876-2-git-send-email-manfred@colorfullife.com>
 <1254590364-2876-3-git-send-email-manfred@colorfullife.com>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manfred Spraul <manfred@colorfullife.com>

sysv sem has the concept of semaphore arrays that consist out of multiple
semaphores. Atomic operations that affect multiple semaphores are supported.

The patch optimizes single semaphore operation calls that affect only one
semaphore: It's not necessary to scan all pending operations, it is sufficient
to scan the per-semaphore list.

The idea is from Nick Piggin version of an ipc sem improvement, the
implementation is different:
The code tries to keep as much common code as possible.

As the result, the patch is simpler, but optimizes fewer cases.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 ipc/sem.c |   51 ++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 0cad759..66192c2 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -433,17 +433,45 @@ static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
 		sma->complex_count--;
 }
 
-/* Go through the pending queue for the indicated semaphore
- * looking for tasks that can be completed.
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
-	struct sem_queue *q, *tq;
+	struct sem_queue *q;
+	struct list_head *walk;
+	struct list_head *pending_list;
+	int offset;
+
+	/* if there are complex operations around, then knowing the semaphore
+	 * that was modified doesn't help us. Assume that multiple semaphores
+	 * were modified.
+	 */
+	if (sma->complex_count)
+		semnum = -1;
+
+	if (semnum == -1) {
+		pending_list = &sma->sem_pending;
+		offset = offsetof(struct sem_queue, list);
+	} else {
+		pending_list = &sma->sem_base[semnum].sem_pending;
+		offset = offsetof(struct sem_queue, simple_list);
+	}
 
 again:
-	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
-		int error;
-		int alter;
+	walk = pending_list->next;
+	while (walk != pending_list) {
+		int error, alter;
+
+		q = (struct sem_queue *)((char *)walk - offset);
+		walk = walk->next;
 
 		error = try_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
@@ -768,7 +796,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, -1);
 		err = 0;
 		goto out_unlock;
 	}
@@ -810,7 +838,7 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 		curr->sempid = task_tgid_vnr(current);
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, semnum);
 		err = 0;
 		goto out_unlock;
 	}
@@ -1186,7 +1214,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
-			update_queue (sma);
+			update_queue(sma, (nsops == 1) ? sops[0].sem_num : -1);
+
 		goto out_unlock_free;
 	}
 
@@ -1387,7 +1416,7 @@ void exit_sem(struct task_struct *tsk)
 		}
 		sma->sem_otime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, -1);
 		sem_unlock(sma);
 
 		call_rcu(&un->rcu, free_un);
-- 
1.6.2.5

