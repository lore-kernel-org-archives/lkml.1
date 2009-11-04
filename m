Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbZKDRTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbZKDRTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbZKDRTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:19:41 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:38893 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149AbZKDRTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:19:41 -0500
Message-ID: <4AF1B7A7.6030902@gmail.com>
Date: Wed, 04 Nov 2009 18:19:35 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC,PATCH] mutex: mutex_is_owner() helper
References: <4AF19D06.3060401@gmail.com> <20091104154015.GA32567@elte.hu>
In-Reply-To: <20091104154015.GA32567@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 04 Nov 2009 18:19:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :

> To make sure this does not extend mutexes to be used a recursive 
> mutexes, mind naming it more clearly, like debug_mutex_is_owned(), and 
> adding a comment that says that this shouldnt be taken?
> 
> Also, it's somewhat imprecise: on !SMP && !DEBUG_MUTEXES we might return 
> a false '1'. Which happens to work for the rtnl usecase - but might not 
> in other cases.
>

Sure, we can chose another name, but what do you mean by a false '1' ?

1 means mutex is locked and that we could not check ownership.
(best effort, ie same imprecise result than mutex_is_locked())


BTW, I was thinking of a mutex_yield() implementation, but could not
cook it without hard thinking, maybe you already have some nice implementation ?

We have some uses of "mutex_unlock();mutex_lock();" things that are
not working nicely because current thread immediately takes again mutex.


a true mutex_yield() would force current thread to go at the end of wait_list.

int mutex_yield(struct mutex *lock)
{
	unsigned long flags;

	// OK to test list without locking
	if (list_empty(&lock->wait_list))
		return 0;

	spin_lock_mutex(&lock->wait_lock, flags);
	if (!list_empty(&lock->wait_list)) {
		atomic_xchg(&lock->count, 1);// free mutex
		list_add_tail(&waiter.list, &lock->wait_list);//insert me at tail of wait_list
		wake head of wait_list
		__mutex_lock_common_condadd(mutex, TASK_UNINTERRUPTIBLE, DONT_ADD_TAIL, ...);
	} else {
		spin_unlock_mutex(&lock->wait_lock, flags);
	}
	return 1;
}


Or maybe we should try something less complex (slowpath anyway)

int mutex_yield(struct mutex *lock)
{
	int ret = 0;

	if (mutex_needbreak(lock) || should_resched()) {
		mutex_unlock(lock); 
		__cond_resched();
		mutex_lock(lock);
		ret = 1;
	}
	return ret;
}

Thanks
