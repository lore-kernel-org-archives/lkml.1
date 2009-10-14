Return-Path: <linux-kernel-owner+w=401wt.eu-S932303AbZJNJwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbZJNJwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 05:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932242AbZJNJwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 05:52:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222AbZJNJwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 05:52:54 -0400
Date: Wed, 14 Oct 2009 05:52:22 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ben Woodard <bwoodard@llnl.gov>, David Howells <dhowells@redhat.com>,
       akpm@linux-foundation.org, Brian Behlendorf <behlendorf1@llnl.gov>,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20091014095503.4235.63028.sendpatchset@localhost.localdomain>
Subject: [Patch v5] rwsem: fix rwsem_is_locked() bugs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v4 -> v5:
 - Uninline rwsem_is_locked().
 - Use spin_trylock_irqsave instead of spin_trylock_irq().

Thanks to Andrew and David.

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
should not block, thus we use spin_trylock_irqsave().

(David, if you think it's fine, can you Ack on this version?
Thanks!)

Reported-by: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: Ben Woodard <bwoodard@llnl.gov>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
index 6c3c0f6..571be3c 100644
--- a/include/linux/rwsem-spinlock.h
+++ b/include/linux/rwsem-spinlock.h
@@ -68,11 +68,9 @@ extern int __down_write_trylock(struct rw_semaphore *sem);
 extern void __up_read(struct rw_semaphore *sem);
 extern void __up_write(struct rw_semaphore *sem);
 extern void __downgrade_write(struct rw_semaphore *sem);
+extern int __rwsem_is_locked(struct rw_semaphore *sem);
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->activity != 0);
-}
+#define rwsem_is_locked(sem) __rwsem_is_locked(sem)
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_SPINLOCK_H */
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index 9df3ca5..7014306 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -17,6 +17,19 @@ struct rwsem_waiter {
 #define RWSEM_WAITING_FOR_WRITE	0x00000002
 };
 
+int __rwsem_is_locked(struct rw_semaphore *sem)
+{
+	int ret = 1;
+	unsigned long flags;
+
+	if (spin_trylock_irqsave(&sem->wait_lock, flags)) {
+		ret = (sem->activity != 0);
+		spin_unlock_irqrestore(&sem->wait_lock, flags);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(__rwsem_is_locked);
+
 /*
  * initialise the semaphore
  */
