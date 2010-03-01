Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107Ab0CAOVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 09:21:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:49504 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab0CAOV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 09:21:29 -0500
Message-ID: <4B8BCDB7.4090304@kernel.org>
Date: Mon, 01 Mar 2010 23:22:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 07/43] sched: implement try_to_wake_up_local()
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-8-git-send-email-tj@kernel.org> <20100228123313.GA5495@redhat.com>
In-Reply-To: <20100228123313.GA5495@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 14:19:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On 02/28/2010 09:33 PM, Oleg Nesterov wrote:
> Wow ;)

:-)

> I didn't read the whole series yet, still I'd like to ask a couple
> of questions right now. Tejun, I am just trying to understand this
> code.

Sure.

>> @@ -2438,6 +2438,10 @@ static inline void ttwu_post_activation(struct task_struct *p, struct rq *rq,
>>  		rq->idle_stamp = 0;
>>  	}
>>  #endif
>> +	/*
>> +	 * Wake up is complete, fire wake up notifier.  This allows
>> +	 * try_to_wake_up_local() to be called from wake up notifiers.
>> +	 */
>>  	if (success)
>>  		fire_sched_notifiers(p, wakeup);
> 
> Could you explain the comment? ttwu_post_activation() sets state =
> TASK_RUNNING few lines above, what try_to_wake_up_local() can do if
> called from ->wakeup() notifier ?

It can wake up another task on the same rq.

>> +bool try_to_wake_up_local(struct task_struct *p, unsigned int state,
>> +			  int wake_flags)
>> +{
>> ...
>> +	if (!p->se.on_rq) {
>> +		if (likely(!task_running(rq, p))) {
>> +			schedstat_inc(rq, ttwu_count);
>> +			schedstat_inc(rq, ttwu_local);
>> +		}
>> +		ttwu_activate(p, rq, wake_flags & WF_SYNC, false, true);
>> +		success = true;
>> +	}
> 
> Shouldn't try_to_wake_up_local() check task_contributes_to_load() to
> account ->nr_uninterruptible?

try_to_wake_up() does that because the task may be moved to a
different CPU via select_task_rq() for local wakeups, the accounting
can be safely handled by activate_task().

>> @@ -5498,6 +5549,11 @@ need_resched_nonpreemptible:
>>  		if (unlikely(signal_pending_state(prev->state, prev))) {
>>  			prev->state = TASK_RUNNING;
>>  		} else {
>> +			/*
>> +			 * Fire sleep notifier before changing any scheduler
>> +			 * state.  This allows try_to_wake_up_local() to be
>> +			 * called from sleep notifiers.
>> +			 */
>>  			fire_sched_notifiers(prev, sleep);
>>  			deactivate_task(rq, prev, 1);
> 
> Again, I don't understand the comment... If ->sleep() notifier wakes up
> this task, we shouldn't do deactivate_task() ?
>
> Probably both comment mean a notifier could wake up another task bound
> to this rq, in this case it looks a bit confusing, imho.

Correct.  I'll update the comment.

> Off-topic, but it is a bit sad wait_task_inactive() can not use ->sleep()
> notifier to avoid schedule_timeout(), afaics we can't add the notifier
> to !current task.

Agreed.  The whole thing avoids sync cost by only allowing current to
adjust the notifiers and it's a bit sad that wait_task_inactive()
can't use it for that.

Thanks.

-- 
tejun
