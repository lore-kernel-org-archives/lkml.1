Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZJEGiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZJEGiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 02:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbZJEGiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 02:38:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbZJEGiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 02:38:08 -0400
Date: Mon, 5 Oct 2009 02:36:40 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Brian Behlendorf <behlendorf1@llnl.gov>,
       David Howells <dhowells@redhat.com>, Ben Woodard <bwoodard@llnl.gov>,
       Amerigo Wang <amwang@redhat.com>, Stable Team <stable@kernel.org>,
       akpm@linux-foundation.org
Message-Id: <20091005063919.3958.65581.sendpatchset@localhost.localdomain>
Subject: [Patch v2] rwsem: fix rwsem_is_locked() bugs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rwsem_is_locked() tests ->activity without locks, so we should always
keep ->activity consistent. However, the code in __rwsem_do_wake()
breaks this rule, it updates ->activity after _all_ readers waken up,
this may give some reader a wrong ->activity value, thus cause
rwsem_is_locked() behaves wrong.

Quote from Andrew:

"
- we have one or more processes sleeping in down_read(), waiting for access.

- we wake one or more processes up without altering ->activity

- they start to run and they do rwsem_is_locked().  This incorrectly
  returns "false", because the waker process is still crunching away in
  __rwsem_do_wake().

- the waker now alters ->activity, but it was too late.

And the patch fixes this by updating ->activity prior to waking the
sleeping processes.  So when they run, they'll see a non-zero value of
->activity.
"

Also, we have more problems, as pointed by David:

"... the case where the active readers run out, but there's a
writer on the queue (see __up_read()), nor the case where the active writer
ends, but there's a waiter on the queue (see __up_write()).  In both cases,
the lock is still held, though sem->activity is 0."

This patch fixes this too.

David also said we may have "the potential to cause more cacheline ping-pong
under contention", but "this change shouldn't cause a significant slowdown."

With this patch applied, I can't trigger that bug any more.

Reported-by: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: Ben Woodard <bwoodard@llnl.gov>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Stable Team <stable@kernel.org>

---
diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index 6c3c0f6..1395bb6 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -71,7 +71,7 @@ extern void __downgrade_write(struct rw_semaphore *sem);
 
 static inline int rwsem_is_locked(struct rw_semaphore *sem)
 {
-	return (sem->activity != 0);
+	return !(sem->activity == 0 && list_empty(&sem->wait_list));
 }
 
 #endif /* __KERNEL__ */
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index 9df3ca5..44e4484 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -49,7 +49,6 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 {
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
-	int woken;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 
@@ -78,24 +77,21 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 
 	/* grant an infinite number of read locks to the front of the queue */
  dont_wake_writers:
-	woken = 0;
 	while (waiter->flags & RWSEM_WAITING_FOR_READ) {
 		struct list_head *next = waiter->list.next;
 
+		sem->activity++;
 		list_del(&waiter->list);
 		tsk = waiter->task;
 		smp_mb();
 		waiter->task = NULL;
 		wake_up_process(tsk);
 		put_task_struct(tsk);
-		woken++;
 		if (list_empty(&sem->wait_list))
 			break;
 		waiter = list_entry(next, struct rwsem_waiter, list);
 	}
 
-	sem->activity += woken;
-
  out:
 	return sem;
 }
