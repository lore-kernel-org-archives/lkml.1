Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZJHJNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZJHJNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbZJHJNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:13:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220AbZJHJNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:13:54 -0400
Message-ID: <4ACDADAB.3030403@redhat.com>
Date: Thu, 08 Oct 2009 17:15:23 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, Ben Woodard <bwoodard@llnl.gov>,
       akpm@linux-foundation.org, Brian Behlendorf <behlendorf1@llnl.gov>
Subject: Re: [Patch v3] rwsem: fix rwsem_is_locked() bugs
References: <20091006065815.3927.12069.sendpatchset@localhost.localdomain> <13922.1254917951@redhat.com>
In-Reply-To: <13922.1254917951@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Amerigo Wang <amwang@redhat.com> wrote:
> 
>>  static inline int rwsem_is_locked(struct rw_semaphore *sem)
>>  {
>> -	return (sem->activity != 0);
>> +	int ret;
>> +
>> +	if (spin_trylock_irq(&sem->wait_lock)) {
>> +		ret = !(list_empty(&sem->wait_list) && sem->activity == 0);
>> +		spin_unlock_irq(&sem->wait_lock);
>> +		return ret;
>> +	}
>> +	return 1;
>>  }
> 
> Yep...  This seems a reasonable approach, though I contend that if you're
> holding the spinlock, then sem->wait_list _must_ be empty if sem->activity is
> 0 - so that half of the test is redundant.
> 
> sem->activity == 0 and sem->wait_list not being empty is a transitional state
> that can only occur in ups and downgrades whilst they hold the spinlock.
> 


Hmm, yeah...

>> diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
>> index 9df3ca5..234d83f 100644
>> --- a/lib/rwsem-spinlock.c
>> +++ b/lib/rwsem-spinlock.c
>> @@ -78,7 +78,12 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
>>  
>>  	/* grant an infinite number of read locks to the front of the queue */
>>   dont_wake_writers:
>> -	woken = 0;
>> +	/*
>> +	 * we increase ->activity just to make rwsem_is_locked() happy,
>> +	 * to avoid potential cache line ping-pong, we don't do this
>> +	 * within the following loop.
>> +	 */
>> +	woken = sem->activity++;
>>  	while (waiter->flags & RWSEM_WAITING_FOR_READ) {
>>  		struct list_head *next = waiter->list.next;
>>  
>> @@ -94,7 +99,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
>>  		waiter = list_entry(next, struct rwsem_waiter, list);
>>  	}
>>  
>> -	sem->activity += woken;
>> +	sem->activity = woken;
>>  
>>   out:
>>  	return sem;
> 
> This change to __rwsem_do_wake() is all unnecessary - you're defending against
> the test of sem->activity by rwsem_is_locked() - but that now happens with the
> spinlock held.

Ah, yes, I knew this, I kept this just for completeness.
I will remove this part then. :)

THanks!

