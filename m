Return-Path: <linux-kernel-owner+w=401wt.eu-S1754060AbZI3DWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbZI3DWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 23:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZI3DWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 23:22:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbZI3DWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 23:22:02 -0400
Date: Tue, 29 Sep 2009 23:19:02 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Brian Behlendorf <behlendorf1@llnl.gov>,
       David Howells <dhowells@redhat.com>, Ben Woodard <bwoodard@llnl.gov>,
       Amerigo Wang <amwang@redhat.com>, Stable Team <stable@kernel.org>,
       akpm@linux-foundation.org
Message-Id: <20090930032138.3919.72085.sendpatchset@localhost.localdomain>
Subject: [Patch] rwsem: fix rwsem_is_locked() bug
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


rwsem_is_locked() tests ->activity without locks, so we should always
keep ->activity consistent. However, the code in __rwsem_do_wake()
breaks this rule, it updates ->activity after _all_ readers waken up,
this may give some reader a wrong ->activity value, thus cause
rwsem_is_locked() behaves wrong.

Brian has a kernel module to reproduce this, I can include it
if any of you need. Of course, with Brian's approval.

With this patch applied, I can't trigger that bug any more.

Reported-by: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: Ben Woodard <bwoodard@llnl.gov>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Stable Team <stable@kernel.org>

---
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
