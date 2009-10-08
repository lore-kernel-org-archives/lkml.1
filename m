Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbZJHJYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbZJHJYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbZJHJYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:24:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168AbZJHJYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:24:48 -0400
Date: Thu, 8 Oct 2009 05:23:53 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Woodard <bwoodard@llnl.gov>, David Howells <dhowells@redhat.com>,
       akpm@linux-foundation.org, Brian Behlendorf <behlendorf1@llnl.gov>,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20091008092632.7101.62229.sendpatchset@localhost.localdomain>
Subject: [Patch v4] rwsem: fix rwsem_is_locked() bugs
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
"

So we need get a spinlock to protect this. And rwsem_is_locked()
should not block, thus we use spin_trylock.

Reported-by: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: Ben Woodard <bwoodard@llnl.gov>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index 6c3c0f6..fb7efcb 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -71,7 +71,13 @@ extern void __downgrade_write(struct rw_semaphore *sem);
 
 static inline int rwsem_is_locked(struct rw_semaphore *sem)
 {
-	return (sem->activity != 0);
+	int ret = 1;
+
+	if (spin_trylock_irq(&sem->wait_lock)) {
+		ret = (sem->activity != 0);
+		spin_unlock_irq(&sem->wait_lock);
+	}
+	return ret;
 }
 
 #endif /* __KERNEL__ */
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index 9df3ca5..ec7804e 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -82,6 +82,10 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
 	while (waiter->flags & RWSEM_WAITING_FOR_READ) {
 		struct list_head *next = waiter->list.next;
 
+		/*
+		 * Since rwsem_is_locked() reads ->activity with spinlock,
+		 * not updating ->activity here is fine.
+		 */
 		list_del(&waiter->list);
 		tsk = waiter->task;
 		smp_mb();
