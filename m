Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab0CAPFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:05:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:33735 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab0CAPFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:05:47 -0500
Message-ID: <4B8BD822.1010402@kernel.org>
Date: Tue, 02 Mar 2010 00:07:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 10/43] stop_machine: reimplement without using workqueue
References: <1267187000-18791-1-git-send-email-tj@kernel.org> <1267187000-18791-11-git-send-email-tj@kernel.org> <20100228141135.GB5495@redhat.com>
In-Reply-To: <20100228141135.GB5495@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 15:04:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/28/2010 11:11 PM, Oleg Nesterov wrote:
> On 02/26, Tejun Heo wrote:
>>
>> +static int stop_cpu(void *unused)
>>  {
>>  	enum stopmachine_state curstate = STOPMACHINE_NONE;
>> -	struct stop_machine_data *smdata = &idle;
>> +	struct stop_machine_data *smdata;
>>  	int cpu = smp_processor_id();
>>  	int err;
>>
>> +repeat:
>> +	/* Wait for __stop_machine() to initiate */
>> +	while (true) {
>> +		set_current_state(TASK_INTERRUPTIBLE);
>> +		/* <- kthread_stop() and __stop_machine()::smp_wmb() */
>> +		if (kthread_should_stop()) {
>> +			__set_current_state(TASK_RUNNING);
>> +			return 0;
>> +		}
>> +		if (state == STOPMACHINE_PREPARE)
>> +			break;
> 
> Cosmetic nit: this doesn't matter at all, but perhaps it makes sense
> to set TASK_RUNNING here too.

Yeap, I agree that would be prettier.  Will do so.

> Actually, I was a bit confused by this "while (true)" loop. It looks
> as if a spurious wakeup is possible. It is not,

I don't think spurious wakeups are possible but without the loop the
PREPARE check should be done before schedule(), and, after the
schedule(), we'll need a matching BUG_ON() and the
kthread_should_stop() check with a comment explaining that the initial
exit condition check is done in the kthread code and thus not
necessary before the initial schedule().  It seems more complex and
fragile to me.

> and more importantly, if it was possible
> stop_machine_cpu_callback(CPU_POST_DEAD) (which is called after
> cpu_hotplug_done()) could race with stop_machine().
> stop_machine_cpu_callback(CPU_POST_DEAD) relies on fact that this
> thread has already called schedule() and it can't be woken until
> kthread_stop() sets ->should_stop.

Hmmm... I'm probably missing something but I don't see how
stop_machine_cpu_callback(CPU_POST_DEAD) depends on stop_cpu() thread
already parked in schedule().  Can you elaborate a bit?

>> +		schedule();
>> +	}
>> +	smp_rmb();	/* <- __stop_machine()::set_state() */
>> +
>> +	/* Okay, let's go */
>> +	smdata = &idle;
>>  	if (!active_cpus) {
>>  		if (cpu == cpumask_first(cpu_online_mask))
>>  			smdata = &active;
> 
> I never understood why do we need "struct stop_machine_data idle".
> stop_cpu() just needs a "bool should_call_active_fn" ?

Yeap, it's an odd way to switch to no-op.  I have no idea why the
original code looked like that.  Maybe it has some history.  At any
rate, easy to fix.  I'll write up a patch to change it.

>>  int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
>>  {
>> ...
>>  	/* Schedule the stop_cpu work on all cpus: hold this CPU so one
>>  	 * doesn't hit this CPU until we're ready. */
>>  	get_cpu();
>> +	for_each_online_cpu(i)
>> +		wake_up_process(*per_cpu_ptr(stop_machine_threads, i));
> 
> I think the comment is wrong, and we need preempt_disable() instead
> of get_cpu(). We shouldn't worry about this CPU, but we need to ensure
> the woken real-time thread can't preempt us until we wake up them all.

get_cpu() and preempt_disable() are exactly the same thing, aren't
they?  Do you think get_cpu() is wrong there for some reason?  The
comment could be right depending on how you interpret 'this CPU' -
ie. you could read it as 'hold on to the CPU which is waking up
stop_machine_threads'.  But I suppose there's no harm in clarifying
the comment.

Thanks.

-- 
tejun
