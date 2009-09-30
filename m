Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZI3XJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZI3XJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZI3XJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:09:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754699AbZI3XJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:09:37 -0400
Date: Wed, 30 Sep 2009 16:08:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, behlendorf1@llnl.gov, dhowells@redhat.com,
       bwoodard@llnl.gov, amwang@redhat.com, stable@kernel.org
Subject: Re: [Patch] rwsem: fix rwsem_is_locked() bug
Message-Id: <20090930160823.6e0b9f15.akpm@linux-foundation.org>
In-Reply-To: <20090930032138.3919.72085.sendpatchset@localhost.localdomain>
References: <20090930032138.3919.72085.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 23:19:02 -0400
Amerigo Wang <amwang@redhat.com> wrote:

> 
> rwsem_is_locked() tests ->activity without locks, so we should always
> keep ->activity consistent. However, the code in __rwsem_do_wake()
> breaks this rule, it updates ->activity after _all_ readers waken up,
> this may give some reader a wrong ->activity value, thus cause
> rwsem_is_locked() behaves wrong.
> 
> Brian has a kernel module to reproduce this, I can include it
> if any of you need. Of course, with Brian's approval.
> 
> With this patch applied, I can't trigger that bug any more.
> 

Changelog doesn't describe the bug well.

> 
> ---
> diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
> index 9df3ca5..44e4484 100644
> --- a/lib/rwsem-spinlock.c
> +++ b/lib/rwsem-spinlock.c
> @@ -49,7 +49,6 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
>  {
>  	struct rwsem_waiter *waiter;
>  	struct task_struct *tsk;
> -	int woken;
>  
>  	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
>  
> @@ -78,24 +77,21 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
>  
>  	/* grant an infinite number of read locks to the front of the queue */
>   dont_wake_writers:
> -	woken = 0;
>  	while (waiter->flags & RWSEM_WAITING_FOR_READ) {
>  		struct list_head *next = waiter->list.next;
>  
> +		sem->activity++;
>  		list_del(&waiter->list);
>  		tsk = waiter->task;
>  		smp_mb();
>  		waiter->task = NULL;
>  		wake_up_process(tsk);
>  		put_task_struct(tsk);
> -		woken++;
>  		if (list_empty(&sem->wait_list))
>  			break;
>  		waiter = list_entry(next, struct rwsem_waiter, list);
>  	}
>  
> -	sem->activity += woken;
> -
>   out:
>  	return sem;
>  }

So if I understand this correctly

- we have one or more processes sleeping in down_read(), waiting for access.

- we wake one or more processes up without altering ->activity

- they start to run and they do rwsem_is_locked().  This incorrectly
  returns "false", because the waker process is still crunching away in
  __rwsem_do_wake().

- the waker now alters ->activity, but it was too late.

And the patch fixes this by updating ->activity prior to waking the
sleeping processes.  So when they run, they'll see a non-zero value of
->activity.

Fair enough, I guess.

I don't know if we really need this in -stable.  Do we expect that
there will be any real runtime bugs arising from this?
