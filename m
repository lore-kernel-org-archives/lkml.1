Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbZJEDVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbZJEDVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 23:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbZJEDVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 23:21:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbZJEDVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 23:21:53 -0400
Message-ID: <4AC96699.80202@redhat.com>
Date: Mon, 05 Oct 2009 11:23:05 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, behlendorf1@llnl.gov, dhowells@redhat.com,
       bwoodard@llnl.gov, stable@kernel.org
Subject: Re: [Patch] rwsem: fix rwsem_is_locked() bug
References: <20090930032138.3919.72085.sendpatchset@localhost.localdomain> <20090930160823.6e0b9f15.akpm@linux-foundation.org>
In-Reply-To: <20090930160823.6e0b9f15.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 29 Sep 2009 23:19:02 -0400
> Amerigo Wang <amwang@redhat.com> wrote:
> 
>> rwsem_is_locked() tests ->activity without locks, so we should always
>> keep ->activity consistent. However, the code in __rwsem_do_wake()
>> breaks this rule, it updates ->activity after _all_ readers waken up,
>> this may give some reader a wrong ->activity value, thus cause
>> rwsem_is_locked() behaves wrong.
>>
>> Brian has a kernel module to reproduce this, I can include it
>> if any of you need. Of course, with Brian's approval.
>>
>> With this patch applied, I can't trigger that bug any more.
>>
> 
> Changelog doesn't describe the bug well.

Sorry for my English. :-/

> 
>> ---
>> diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
>> index 9df3ca5..44e4484 100644
>> --- a/lib/rwsem-spinlock.c
>> +++ b/lib/rwsem-spinlock.c
>> @@ -49,7 +49,6 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
>>  {
>>  	struct rwsem_waiter *waiter;
>>  	struct task_struct *tsk;
>> -	int woken;
>>  
>>  	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
>>  
>> @@ -78,24 +77,21 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
>>  
>>  	/* grant an infinite number of read locks to the front of the queue */
>>   dont_wake_writers:
>> -	woken = 0;
>>  	while (waiter->flags & RWSEM_WAITING_FOR_READ) {
>>  		struct list_head *next = waiter->list.next;
>>  
>> +		sem->activity++;
>>  		list_del(&waiter->list);
>>  		tsk = waiter->task;
>>  		smp_mb();
>>  		waiter->task = NULL;
>>  		wake_up_process(tsk);
>>  		put_task_struct(tsk);
>> -		woken++;
>>  		if (list_empty(&sem->wait_list))
>>  			break;
>>  		waiter = list_entry(next, struct rwsem_waiter, list);
>>  	}
>>  
>> -	sem->activity += woken;
>> -
>>   out:
>>  	return sem;
>>  }
> 
> So if I understand this correctly
> 
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
> 
> Fair enough, I guess.


Yes, exactly.

But after reading David's comments, I realized that rwsem_is_locked()
has more problems, this only fixes one of them.

I will try another fix.

> 
> I don't know if we really need this in -stable.  Do we expect that
> there will be any real runtime bugs arising from this?

Not sure, I need an extra kernel module to trigger this bug,
so probably it doesn't affect the real kernel.

Thanks!
