Return-Path: <linux-kernel-owner+w=401wt.eu-S1759072AbZJGMUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759072AbZJGMUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758780AbZJGMUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:20:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbZJGMUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:20:12 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091006065815.3927.12069.sendpatchset@localhost.localdomain>
References: <20091006065815.3927.12069.sendpatchset@localhost.localdomain>
To: Amerigo Wang <amwang@redhat.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       Ben Woodard <bwoodard@llnl.gov>, akpm@linux-foundation.org,
       Brian Behlendorf <behlendorf1@llnl.gov>
Subject: Re: [Patch v3] rwsem: fix rwsem_is_locked() bugs
Date: Wed, 07 Oct 2009 13:19:11 +0100
Message-ID: <13922.1254917951@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> wrote:

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

Yep...  This seems a reasonable approach, though I contend that if you're
holding the spinlock, then sem->wait_list _must_ be empty if sem->activity is
0 - so that half of the test is redundant.

sem->activity == 0 and sem->wait_list not being empty is a transitional state
that can only occur in ups and downgrades whilst they hold the spinlock.

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

This change to __rwsem_do_wake() is all unnecessary - you're defending against
the test of sem->activity by rwsem_is_locked() - but that now happens with the
spinlock held.

David
