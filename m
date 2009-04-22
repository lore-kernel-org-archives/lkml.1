Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZDVNiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZDVNiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZDVNiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:38:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52995 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbZDVNiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:38:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090416143351.GD6532@redhat.com>
References: <20090416143351.GD6532@redhat.com> <20090415162712.342d4c07.akpm@linux-foundation.org> <1239649429.16771.9.camel@heimdal.trondhjem.org> <20090413181733.GA10424@redhat.com> <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> 
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Trond.Myklebust@netapp.com, serue@us.ibm.com, steved@redhat.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH] Document that wake_up(), complete() and co. imply a full memory barrier
Date: Wed, 22 Apr 2009 14:37:00 +0100
Message-ID: <21239.1240407420@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> > That's an interesting question.  Should wake_up() imply a barrier of any
> > sort, I wonder.  Well, __wake_up() does impose a barrier as it uses a
> > spinlock, but I wonder if that's sufficient.
> 
> wake_up() does imply the barrier. Note the smp_wmb() in try_to_wake_up().
> And in fact this wmb() implies mb(), because spin_lock() itself is STORE,
> and the futher LOADs can't leak up before spin_lock().
> 
> But afaics, this doesn't matter? prepare_to_wait() sets task->state under
> wait_queue_head_t->lock and wake_up() takes this look too, so we can't miss
> the event.
> 
> Or I completely misunderstood the issue...

The problem is not what wake_up() and co. do, it's what you are allowed to
assume that they do.

However, I think you're right, and that we can assume they imply a full memory
barrier.  To this end, I've attached a patch to document this.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Document that wake_up(), complete() and co. imply a full memory barrier

Add to the memory barriers document to note that wake_up(), complete() and
co. all imply a full memory barrier.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/memory-barriers.txt |    4 ++++
 kernel/sched.c                    |   10 ++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)


diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index f5b7127..2c8062c 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1224,6 +1224,10 @@ Other functions that imply barriers:
 
  (*) schedule() and similar imply full memory barriers.
 
+ (*) wake_up(), try_to_wake_up() and co. imply a full memory barrier.
+
+ (*) complete() and co. imply a full memory barrier.
+
 
 =================================
 INTER-CPU LOCKING BARRIER EFFECTS
diff --git a/kernel/sched.c b/kernel/sched.c
index b902e58..faccaa0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2337,6 +2337,8 @@ static int sched_balance_self(int cpu, int flag)
  * runnable without the overhead of this.
  *
  * returns failure only if the task is already active.
+ *
+ * It may be assumed that this function implies a full memory barrier.
  */
 static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 {
@@ -5241,6 +5243,8 @@ void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
  * @mode: which threads
  * @nr_exclusive: how many wake-one or wake-many threads to wake up
  * @key: is directly passed to the wakeup function
+ *
+ * It may be assumed that this function implies a full memory barrier.
  */
 void __wake_up(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
@@ -5279,6 +5283,8 @@ void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key)
  * with each other. This can prevent needless bouncing between CPUs.
  *
  * On UP it can prevent extra preemption.
+ *
+ * It may be assumed that this function implies a full memory barrier.
  */
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, void *key)
@@ -5315,6 +5321,8 @@ EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
  * awakened in the same order in which they were queued.
  *
  * See also complete_all(), wait_for_completion() and related routines.
+ *
+ * It may be assumed that this function implies a full memory barrier.
  */
 void complete(struct completion *x)
 {
@@ -5332,6 +5340,8 @@ EXPORT_SYMBOL(complete);
  * @x:  holds the state of this particular completion
  *
  * This will wake up all threads waiting on this particular completion event.
+ *
+ * It may be assumed that this function implies a full memory barrier.
  */
 void complete_all(struct completion *x)
 {
