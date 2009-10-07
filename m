Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbZJGJjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbZJGJjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 05:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbZJGJjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 05:39:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbZJGJjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 05:39:16 -0400
Message-ID: <4ACC6244.3010302@redhat.com>
Date: Wed, 07 Oct 2009 17:41:24 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ben Woodard <bwoodard@llnl.gov>, David Howells <dhowells@redhat.com>,
       akpm@linux-foundation.org, Brian Behlendorf <behlendorf1@llnl.gov>
Subject: Re: [Patch v3] rwsem: fix rwsem_is_locked() bugs
References: <20091006065815.3927.12069.sendpatchset@localhost.localdomain>
In-Reply-To: <20091006065815.3927.12069.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David, any comments on this version? :)

Thanks.


Amerigo Wang wrote:
> rwsem_is_locked() tests ->activity without locks, so we should always
> keep ->activity consistent. However, the code in __rwsem_do_wake()
> breaks this rule, it updates ->activity after _all_ readers waken up,
> this may give some reader a wrong ->activity value, thus cause
> rwsem_is_locked() behaves wrong.
> 
> Quote from Andrew:
> 
> "
> - we have one or more processes sleeping in down_read(), waiting for access.
> 
> - we wake one or more processes up without altering ->activity
> 
> - they start to run and they do rwsem_is_locked().  This incorrectly
>   returns "false", because the waker process is still crunching away in
>   __rwsem_do_wake().
> 
> - the waker now alters ->activity, but it was too late.
> 
> And the patch fixes this by updating ->activity prior to waking the
> sleeping processes.  So when they run, they'll see a non-zero value of
> ->activity.
> "
> 
> Also, we have more problems, as pointed by David:
> 
> "... the case where the active readers run out, but there's a
> writer on the queue (see __up_read()), nor the case where the active writer
> ends, but there's a waiter on the queue (see __up_write()).  In both cases,
> the lock is still held, though sem->activity is 0."
> 
> This patch fixes this too.
> 
> David also said we may have "the potential to cause more cacheline ping-pong
> under contention", but "this change shouldn't cause a significant slowdown."
> 
> With this patch applied, I can't trigger that bug any more.
> 
> Reported-by: Brian Behlendorf <behlendorf1@llnl.gov>
> Cc: Ben Woodard <bwoodard@llnl.gov>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/include/linux/rwsem-spinlock.h b/include/linux/rwsem-spinlock.h
> index 6c3c0f6..1a65776 100644
> --- a/include/linux/rwsem-spinlock.h
> +++ b/include/linux/rwsem-spinlock.h
> @@ -71,7 +71,14 @@ extern void __downgrade_write(struct rw_semaphore *sem);
>  
>  static inline int rwsem_is_locked(struct rw_semaphore *sem)
>  {
> -	return (sem->activity != 0);
> +	int ret;
> +
> +	if (spin_trylock_irq(&sem->wait_lock)) {
> +		ret = !(list_empty(&sem->wait_list) && sem->activity == 0);
> +		spin_unlock_irq(&sem->wait_lock);
> +		return ret;
> +	}
> +	return 1;
>  }
>  
>  #endif /* __KERNEL__ */
> diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
> index 9df3ca5..234d83f 100644
> --- a/lib/rwsem-spinlock.c
> +++ b/lib/rwsem-spinlock.c
> @@ -78,7 +78,12 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
>  
>  	/* grant an infinite number of read locks to the front of the queue */
>   dont_wake_writers:
> -	woken = 0;
> +	/*
> +	 * we increase ->activity just to make rwsem_is_locked() happy,
> +	 * to avoid potential cache line ping-pong, we don't do this
> +	 * within the following loop.
> +	 */
> +	woken = sem->activity++;
>  	while (waiter->flags & RWSEM_WAITING_FOR_READ) {
>  		struct list_head *next = waiter->list.next;
>  
> @@ -94,7 +99,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
>  		waiter = list_entry(next, struct rwsem_waiter, list);
>  	}
>  
> -	sem->activity += woken;
> +	sem->activity = woken;
>  
>   out:
>  	return sem;

