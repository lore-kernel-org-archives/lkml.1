Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbZJAMf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbZJAMf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 08:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932177AbZJAMf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 08:35:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175AbZJAMf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 08:35:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090930032138.3919.72085.sendpatchset@localhost.localdomain>
References: <20090930032138.3919.72085.sendpatchset@localhost.localdomain>
To: Amerigo Wang <amwang@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Brian Behlendorf <behlendorf1@llnl.gov>,
       Ben Woodard <bwoodard@llnl.gov>, Stable Team <stable@kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [Patch] rwsem: fix rwsem_is_locked() bug
Date: Thu, 01 Oct 2009 13:34:30 +0100
Message-ID: <9705.1254400470@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> wrote:

> rwsem_is_locked() tests ->activity without locks, so we should always
> keep ->activity consistent. However, the code in __rwsem_do_wake()
> breaks this rule, it updates ->activity after _all_ readers waken up,
> this may give some reader a wrong ->activity value, thus cause
> rwsem_is_locked() behaves wrong.

NAK.

This does not fix the case where the active readers run out, but there's a
writer on the queue (see __up_read()), nor the case where the active writer
ends, but there's a waiter on the queue (see __up_write()).  In both cases,
the lock is still held, though sem->activity is 0.

I'm leary of endorsing the presence of rwsem_is_locked() since, unless the
function calling it knows that the process it is running in has the rwsem
locked, the value is obsolete the moment the test has been performed.

The other problem with this change is that it has the potential to cause more
cacheline ping-pong under contention.  That said, contention on an rwsem is
much less likely, I think, than on, say, a spinlock, so this change shouldn't
cause a significant slowdown.

Your patch would probably be better as:

-	woken = 0;
+	woken = ++sem->activity;
	while (waiter->flags & RWSEM_WAITING_FOR_READ) {
		struct list_head *next = waiter->list.next;

		list_del(&waiter->list);
		tsk = waiter->task;
		smp_mb();
		waiter->task = NULL;
		wake_up_process(tsk);
		put_task_struct(tsk);
		woken++;
		if (list_empty(&sem->wait_list))
			break;
		waiter = list_entry(next, struct rwsem_waiter, list);
	}

-	sem->activity += woken;
+	sem->activity = woken;

However, as I said above, that is not sufficient.  You really do need to put
spinlocks in rwsem_is_locked():

	static inline int rwsem_is_locked(struct rw_semaphore *sem)
	{
		unsigned long flags;
		__s32 activity;

		spin_lock_irqsave(&sem->wait_lock, flags);
		activity = sem->activity;
		spin_unlock_irqrestore(&sem->wait_lock, flags);
		return activity != 0;
	}

You also need to check over lib/rwsem.c.  rwsem_is_locked() is unreliable for
that algorithm.

David
