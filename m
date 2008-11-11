Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbYKKTc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbYKKTc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYKKTcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:32:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53839 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbYKKTcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:32:48 -0500
Date: Tue, 11 Nov 2008 21:33:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jiri Pirko <jpirko@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC,PATCH] workqueues: turn queue_work() into the "barrier" for
	work->func()
Message-ID: <20081111203324.GA30425@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To clarify, I will be happy with the "no, we don't need this" comment.

But let's suppose we have

	int VAR;

	void work_func(struct work_struct *work)
	{
		if (VAR)
			do_something();
	}

and we are doing

	VAR = 1;
	queue_work(work);

I think the caller of queue_work() has all rights to expect that
the next invocation of work_func() must see "VAR == 1", but this
is not true if the work is already pending.

	run_workqueue:

		work_clear_pending(work)
			clear_bit(WORK_STRUCT_PENDING) // no mb()
	
		call work_func()
			if (VAR)

it is possible that CPU reads VAR before before it clears _PENDING,
and queue_work() "infiltrates" in between and fails. So we can miss
an event.

I don't know if we really have such a code in kernel, and even if
we have perhaps we should fix it and do not touch workqueues. But
perhaps the current behaviour is a bit too subtle in this respect.

For example, atkbd_event_work() happens to work correctly, but only
because it does mb() implicitly.

The patch merely adds mb() after work_clear_pending(work), another
side already has the mb semantics implied by test_and_set_bit().
>From now queue_work() always acts as a barrier for work->func().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- K-28/kernel/workqueue.c~WQ_MB	2008-11-06 19:11:02.000000000 +0100
+++ K-28/kernel/workqueue.c	2008-11-11 21:06:20.000000000 +0100
@@ -291,6 +291,12 @@ static void run_workqueue(struct cpu_wor
 
 		BUG_ON(get_wq_data(work) != cwq);
 		work_clear_pending(work);
+		/*
+		 * Ensure that either the concurrent queue_work() succeeds,
+		 * or work->func() sees all the preceding memory changes.
+		 */
+		smp_mb__after_clear_bit();
+
 		lock_map_acquire(&cwq->wq->lockdep_map);
 		lock_map_acquire(&lockdep_map);
 		f(work);

