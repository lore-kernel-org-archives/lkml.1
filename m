Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbYEGOkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbYEGOkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760393AbYEGOiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:38:01 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:59724
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760129AbYEGOhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:37:45 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 11] rwsem contended
X-Mercurial-Node: 0621238970155f8ff2d60ca4996dcdd470f9c6ce
Message-Id: <0621238970155f8ff2d6.1210170956@duo.random>
In-Reply-To: <patchbomb.1210170950@duo.random>
Date: Wed, 07 May 2008 16:35:56 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Robin Holt <holt@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@redhat.com>,
       Marcelo Tosatti <marcelo@kvack.org>, Eric Dumazet <dada1@cosmosbay.com>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Andrea Arcangeli <andrea@qumranet.com>
# Date 1210115132 -7200
# Node ID 0621238970155f8ff2d60ca4996dcdd470f9c6ce
# Parent  20bc6a66a86ef6bd60919cc77ff51d4af741b057
rwsem contended

Add a function to rw_semaphores to check if there are any processes
waiting for the semaphore. Add rwsem_needbreak to sched.h that works
in the same way as spinlock_needbreak().

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -57,6 +57,8 @@ extern void up_write(struct rw_semaphore
  */
 extern void downgrade_write(struct rw_semaphore *sem);
 
+extern int rwsem_is_contended(struct rw_semaphore *sem);
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 /*
  * nested locking. NOTE: rwsems are not allowed to recurse
diff --git a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2030,6 +2030,15 @@ static inline int spin_needbreak(spinloc
 #endif
 }
 
+static inline int rwsem_needbreak(struct rw_semaphore *sem)
+{
+#ifdef CONFIG_PREEMPT
+	return rwsem_is_contended(sem);
+#else
+	return 0;
+#endif
+}
+
 /*
  * Reevaluate whether the task has signals pending delivery.
  * Wake the task if so.
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -305,6 +305,18 @@ void __downgrade_write(struct rw_semapho
 	spin_unlock_irqrestore(&sem->wait_lock, flags);
 }
 
+int rwsem_is_contended(struct rw_semaphore *sem)
+{
+	/*
+	 * Racy check for an empty list. False positives or negatives
+	 * would be okay. False positive may cause a useless dropping of
+	 * locks. False negatives may cause locks to be held a bit
+	 * longer until the next check.
+	 */
+	return !list_empty(&sem->wait_list);
+}
+
+EXPORT_SYMBOL(rwsem_is_contended);
 EXPORT_SYMBOL(__init_rwsem);
 EXPORT_SYMBOL(__down_read);
 EXPORT_SYMBOL(__down_read_trylock);
diff --git a/lib/rwsem.c b/lib/rwsem.c
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -251,6 +251,18 @@ asmregparm struct rw_semaphore *rwsem_do
 	return sem;
 }
 
+int rwsem_is_contended(struct rw_semaphore *sem)
+{
+	/*
+	 * Racy check for an empty list. False positives or negatives
+	 * would be okay. False positive may cause a useless dropping of
+	 * locks. False negatives may cause locks to be held a bit
+	 * longer until the next check.
+	 */
+	return !list_empty(&sem->wait_list);
+}
+
+EXPORT_SYMBOL(rwsem_is_contended);
 EXPORT_SYMBOL(rwsem_down_read_failed);
 EXPORT_SYMBOL(rwsem_down_write_failed);
 EXPORT_SYMBOL(rwsem_wake);
