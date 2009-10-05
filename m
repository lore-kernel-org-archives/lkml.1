Return-Path: <linux-kernel-owner+w=401wt.eu-S1758443AbZJEDZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443AbZJEDZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 23:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758346AbZJEDZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 23:25:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758331AbZJEDZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 23:25:55 -0400
Message-ID: <4AC96773.3070408@redhat.com>
Date: Mon, 05 Oct 2009 11:26:43 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, Brian Behlendorf <behlendorf1@llnl.gov>,
       Ben Woodard <bwoodard@llnl.gov>, Stable Team <stable@kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [Patch] rwsem: fix rwsem_is_locked() bug
References: <20090930032138.3919.72085.sendpatchset@localhost.localdomain> <9705.1254400470@redhat.com>
In-Reply-To: <9705.1254400470@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Amerigo Wang <amwang@redhat.com> wrote:
> 
>> rwsem_is_locked() tests ->activity without locks, so we should always
>> keep ->activity consistent. However, the code in __rwsem_do_wake()
>> breaks this rule, it updates ->activity after _all_ readers waken up,
>> this may give some reader a wrong ->activity value, thus cause
>> rwsem_is_locked() behaves wrong.
> 
> NAK.
> 
> This does not fix the case where the active readers run out, but there's a
> writer on the queue (see __up_read()), nor the case where the active writer
> ends, but there's a waiter on the queue (see __up_write()).  In both cases,
> the lock is still held, though sem->activity is 0.


Hmm, so the algorithm used in rwsem_is_locked() is not right.:-/

> 
> I'm leary of endorsing the presence of rwsem_is_locked() since, unless the
> function calling it knows that the process it is running in has the rwsem
> locked, the value is obsolete the moment the test has been performed.
> 
> The other problem with this change is that it has the potential to cause more
> cacheline ping-pong under contention.  That said, contention on an rwsem is
> much less likely, I think, than on, say, a spinlock, so this change shouldn't
> cause a significant slowdown.
> 
> Your patch would probably be better as:
> 
> -	woken = 0;
> +	woken = ++sem->activity;
> 	while (waiter->flags & RWSEM_WAITING_FOR_READ) {
> 		struct list_head *next = waiter->list.next;
> 
> 		list_del(&waiter->list);
> 		tsk = waiter->task;
> 		smp_mb();
> 		waiter->task = NULL;
> 		wake_up_process(tsk);
> 		put_task_struct(tsk);
> 		woken++;
> 		if (list_empty(&sem->wait_list))
> 			break;
> 		waiter = list_entry(next, struct rwsem_waiter, list);
> 	}
> 
> -	sem->activity += woken;
> +	sem->activity = woken;
> 
> However, as I said above, that is not sufficient.  You really do need to put
> spinlocks in rwsem_is_locked():
> 
> 	static inline int rwsem_is_locked(struct rw_semaphore *sem)
> 	{
> 		unsigned long flags;
> 		__s32 activity;
> 
> 		spin_lock_irqsave(&sem->wait_lock, flags);
> 		activity = sem->activity;
> 		spin_unlock_irqrestore(&sem->wait_lock, flags);
> 		return activity != 0;
> 	}


Sure, adding spinlocks can solve this, but that would be expensive,
wouldn't it?

> 
> You also need to check over lib/rwsem.c.  rwsem_is_locked() is unreliable for
> that algorithm.

Yeah, I agree, I will try another fix.

Thank you!
