Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbZIKHpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbZIKHpt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbZIKHps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:45:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62358 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZIKHpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:45:47 -0400
Message-ID: <4AAA0001.2060703@cn.fujitsu.com>
Date: Fri, 11 Sep 2009 15:45:05 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       jens.axboe@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
 added to -mm tree
References: <200907310030.n6V0Uqgw001644@imap1.linux-foundation.org> <1252616988.7205.102.camel@laptop>
In-Reply-To: <1252616988.7205.102.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Thu, 2009-07-30 at 17:30 -0700, akpm@linux-foundation.org wrote:
> 
>> ------------------------------------------------------
>> Subject: generic-ipi: fix the race between generic_smp_call_function_*() and hotplug_cfd()
>> From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>>
>> There is a race between generic_smp_call_function_*() and hotplug_cfd() in
>> many cases, see below examples:
>>
>> 1: hotplug_cfd() can free cfd->cpumask, the system will crash if the
>>    cpu's cfd still in the call_function list:
>>
>>
>>       CPU A:                         CPU B
>>
>>  smp_call_function_many()	    ......
>>    cpu_down()                      ......
>>   hotplug_cfd() ->                 ......
>>  free_cpumask_var(cfd->cpumask)  (receive function IPI interrupte)
>>                                 /* read cfd->cpumask */
>>                           generic_smp_call_function_interrupt() ->
>>                          cpumask_test_and_clear_cpu(cpu, data->cpumask)
>>
>>                          	CRASH!!!
>>
>> 2: It's not handle call_function list when cpu down, It's will lead to
>>    dead-wait if other path is waiting this cpu to execute function
>>
>>     CPU A:                           CPU B
>>
>>  smp_call_function_many(wait=0)
>>         ......			    CPU B down
>>    smp_call_function_many() -->  (cpu down before recevie function
>>     csd_lock(&data->csd);         IPI interrupte)
>>
>>     DEAD-WAIT!!!!
>>
>>   So, CPU A will dead-wait in csd_lock(), the same as
>>   smp_call_function_single()
> 
> On re-reading this, I'm wondering if 2 is a real case.
> 
> I'm thinking it should never happen since you're supposed to do things
> like get_online_cpus() around stuff like this, but then again, I doubt
> we actually do.
> 

I think that get_online_cpus() and stop_machine() can't avoid this
race,

1: For the first example in my patch's changlog:

      CPU A:                         CPU B

 smp_call_function_many(wait=0)	    ......
   cpu_down()                      ......
  hotplug_cfd() ->                 ......
 free_cpumask_var(cfd->cpumask)  (receive function IPI interrupte)
                                /* read cfd->cpumask */
                          generic_smp_call_function_interrupt() ->
                         cpumask_test_and_clear_cpu(cpu, data->cpumask)

                         	CRASH!!!

CPU A call smp_call_function_many(wait=0) that want CPU B to call
a specific function, after smp_call_function_many() return, we let
CPU A offline immediately. Unfortunately, if CPU B receives this
IPI interrupt after CPU A down, it will crash like above description.

2: For the second example in my patch's changlog:

If CPU B is dying, like below:

_cpu_down()
{
	......
	
	/* We suppose that have below sequences:
	 * before call __stop_machine(), CPU B is online (in cpu_online_mask),
	 * in this time, CPU A call smp_call_function_many(wait=0) and want
	 * CPU B to call a specific function, after CPU A finish it, CPU B
	 * go to __stop_machine() and disable it's interrupt
	 * (suppose CPU B not receive IPI interrupt in this time now)
	 */
	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
	......
}

Now, CPU B is down, but it's not handle CPU A's request, it cause that
can't clean the CSD_FLAG_LOCK flag of CPU A's cfd_data, if CPU A
call smp_call_function_many() next time. it will block in 
csd_lock() -> csd_lock_wait(data) forever.

>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Jens Axboe <jens.axboe@oracle.com>
>> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  kernel/smp.c |   38 ++++++++++++++++++++++++++++----------
>>  1 file changed, 28 insertions(+), 10 deletions(-)
>>
>> diff -puN kernel/smp.c~generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd kernel/smp.c
>> --- a/kernel/smp.c~generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd
>> +++ a/kernel/smp.c
>> @@ -113,14 +113,10 @@ void generic_exec_single(int cpu, struct
>>  		csd_lock_wait(data);
>>  }
>>  
>> -/*
>> - * Invoked by arch to handle an IPI for call function. Must be called with
>> - * interrupts disabled.
>> - */
>> -void generic_smp_call_function_interrupt(void)
>> +static void
>> +__generic_smp_call_function_interrupt(int cpu, int run_callbacks)
>>  {
>>  	struct call_function_data *data;
>> -	int cpu = smp_processor_id();
>>  
>>  	/*
>>  	 * Ensure entry is visible on call_function_queue after we have
> 
> Also, if this is the last version, we're still not using run_callbacks
> for anything..
> 

It's not the last version and fixed in another patch, see below URL please:
http://marc.info/?l=linux-mm-commits&m=124900028228350&w=2

Thanks,
Xiao
