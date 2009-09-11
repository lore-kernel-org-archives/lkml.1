Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbZIKTJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbZIKTJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZIKTJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:09:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:46825 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZIKTJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:09:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,372,1249282800"; 
   d="scan'208";a="549814413"
Subject: Re: +
 generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
 added to -mm tree
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AAA0001.2060703@cn.fujitsu.com>
References: <200907310030.n6V0Uqgw001644@imap1.linux-foundation.org>
	 <1252616988.7205.102.camel@laptop>  <4AAA0001.2060703@cn.fujitsu.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 11 Sep 2009 12:08:52 -0700
Message-Id: <1252696132.3756.21.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 00:45 -0700, Xiao Guangrong wrote:
> I think that get_online_cpus() and stop_machine() can't avoid this
> race,
> 
> 1: For the first example in my patch's changlog:
> 
>       CPU A:                         CPU B
> 
>  smp_call_function_many(wait=0)	    ......
>    cpu_down()                      ......
>   hotplug_cfd() ->                 ......
>  free_cpumask_var(cfd->cpumask)  (receive function IPI interrupte)
>                                 /* read cfd->cpumask */
>                           generic_smp_call_function_interrupt() ->
>                          cpumask_test_and_clear_cpu(cpu, data->cpumask)
> 
>                          	CRASH!!!
> 
> CPU A call smp_call_function_many(wait=0) that want CPU B to call
> a specific function, after smp_call_function_many() return, we let
> CPU A offline immediately. Unfortunately, if CPU B receives this
> IPI interrupt after CPU A down, it will crash like above description.

How can cpu B receive the IPI interrupt after cpu A is down?

As part of the cpu A going down, we first do the stop machine. i.e.,
schedule the stop machine worker threads on each cpu. So, by the time
all the worker threads on all the cpu's get scheduled and synchronized,
ipi on B should get delivered.

> 
> 2: For the second example in my patch's changlog:
> 
> If CPU B is dying, like below:
> 
> _cpu_down()
> {
> 	......
> 	
> 	/* We suppose that have below sequences:
> 	 * before call __stop_machine(), CPU B is online (in cpu_online_mask),
> 	 * in this time, CPU A call smp_call_function_many(wait=0) and want
> 	 * CPU B to call a specific function, after CPU A finish it, CPU B
> 	 * go to __stop_machine() and disable it's interrupt
> 	 * (suppose CPU B not receive IPI interrupt in this time now)
> 	 */
> 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
> 	......
> }
> 
> Now, CPU B is down, but it's not handle CPU A's request, it cause that
> can't clean the CSD_FLAG_LOCK flag of CPU A's cfd_data, if CPU A
> call smp_call_function_many() next time. it will block in 
> csd_lock() -> csd_lock_wait(data) forever.

Here also, by the time the stop machine threads are scheduled on cpu B,
cpu B should service that IPI.

smp_call_function with wait=0 will still ensure that IPI's are
registered at the destination cpu. But smp_call_function call will
return before the interrupt handler is run and completed.

So, by the time we schedule stop machine threads and when they are all
online and get synchronized (after this point only we disable interrupts
by moving to STOPMACHINE_DISABLE_IRQ state), we should have serviced the
pending smp call function IPI's.

I am still not convinced about the need for this patch. Am I missing
something? Please elaborate the need with more sequence of steps.

thanks,
suresh

