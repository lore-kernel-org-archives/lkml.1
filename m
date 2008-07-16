Return-Path: <linux-kernel-owner+w=401wt.eu-S1761374AbYGPA2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374AbYGPA2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758257AbYGPA0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:26:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64311 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760739AbYGPA0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:26:53 -0400
Date: Tue, 15 Jul 2008 20:26:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>
Subject: [PATCH RT] rwlock: be more conservative in locking reader_lock_count
Message-ID: <Pine.LNX.4.58.0807152023520.20814@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


John Stultz was hitting one of the rwlock warnings. This was indeed a bug.
The assumption of trying not to take locks was incorrect and prone to
bugs.  This patch adds a few locks around the needed areas to correct the
issue and make the code a bit more robust.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/rtmutex.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.24.7-rt-73/kernel/rtmutex.c
===================================================================
--- linux-2.6.24.7-rt-73.orig/kernel/rtmutex.c	2008-07-14 22:27:13.000000000 -0400
+++ linux-2.6.24.7-rt-73/kernel/rtmutex.c	2008-07-14 22:30:54.000000000 -0400
@@ -1137,16 +1137,13 @@ rt_rwlock_update_owner(struct rw_mutex *
 	if (own == RT_RW_READER)
 		return;

-	/*
-	 * We don't need to grab the pi_lock to look at the reader list
-	 * since we hold the rwm wait_lock. We only care about the pointer
-	 * to this lock, and we own the wait_lock, so that pointer
-	 * can't be changed.
-	 */
+	spin_lock(&own->pi_lock);
 	for (i = own->reader_lock_count - 1; i >= 0; i--) {
 		if (own->owned_read_locks[i].lock == rwm)
 			break;
 	}
+	spin_unlock(&own->pi_lock);
+
 	/* It is possible the owner didn't add it yet */
 	if (i < 0)
 		return;
@@ -1453,7 +1450,6 @@ __rt_read_fasttrylock(struct rw_mutex *r
 			current->owned_read_locks[reader_count].count = 1;
 		} else
 			WARN_ON_ONCE(1);
-		spin_unlock(&current->pi_lock);
 		/*
 		 * If this task is no longer the sole owner of the lock
 		 * or someone is blocking, then we need to add the task
@@ -1463,12 +1459,16 @@ __rt_read_fasttrylock(struct rw_mutex *r
 			struct rt_mutex *mutex = &rwm->mutex;
 			struct reader_lock_struct *rls;

+			/* preserve lock order, we only need wait_lock now */
+			spin_unlock(&current->pi_lock);
+
 			spin_lock(&mutex->wait_lock);
 			rls = &current->owned_read_locks[reader_count];
 			if (!rls->list.prev || list_empty(&rls->list))
 				list_add(&rls->list, &rwm->readers);
 			spin_unlock(&mutex->wait_lock);
-		}
+		} else
+			spin_unlock(&current->pi_lock);
 		local_irq_restore(flags);
 		return 1;
 	}

