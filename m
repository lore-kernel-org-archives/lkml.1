Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823Ab0AUT65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab0AUT65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 14:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953Ab0AUT6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 14:58:55 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6933 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0AUT6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 14:58:54 -0500
Message-ID: <4B58B1B3.6000502@caviumnetworks.com>
Date: Thu, 21 Jan 2010 11:57:39 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: LKML <linux-kernel@vger.kernel.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andy Whitcroft <apw@canonical.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       linux-mips <linux-mips@linux-mips.org>
Subject: Re: Lots of bugs with current->state = TASK_*INTERRUPTIBLE
References: <1263932978.31321.53.camel@gandalf.stny.rr.com>	 <4B58A89A.8050405@caviumnetworks.com> <1264102455.31321.293.camel@gandalf.stny.rr.com>
In-Reply-To: <1264102455.31321.293.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jan 2010 19:57:39.0766 (UTC) FILETIME=[FC731D60:01CA9AD3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2010-01-21 at 11:18 -0800, David Daney wrote:
>> Steven Rostedt wrote:
>>> Peter Zijlstra and I were doing a look over of places that assign
>>> current->state = TASK_*INTERRUPTIBLE, by simply looking at places with:
>>>
>>>  $ git grep -A1 'state[[:space:]]*=[[:space:]]*TASK_[^R]'
>>>
>>> and it seems there are quite a few places that looks like bugs. To be on
>>> the safe side, everything outside of a run queue lock that sets the
>>> current state to something other than TASK_RUNNING (or dead) should be
>>> using set_current_state().
>>>
>>> 	current->state = TASK_INTERRUPTIBLE;
>>> 	schedule();
>>>
>>> is probably OK, but it would not hurt to be consistent. Here's a few
>>> examples of likely bugs:
>>>
>> [...]
>>
>> This may be a bit off topic, but exactly which type of barrier should 
>> set_current_state() be implying?
>>
>> On MIPS, set_mb() (which is used by set_current_state()) has a full mb().
>>
>> Some MIPS based processors have a much lighter weight wmb().  Could 
>> wmb() be used in place of mb() here?
> 
> Nope, wmb() is not enough. Below is an explanation.
> 
>> If not, an explanation of the required memory ordering semantics here 
>> would be appreciated.
>>
>> I know the documentation says:
>>
>>      set_current_state() includes a barrier so that the write of
>>      current->state is correctly serialised wrt the caller's subsequent
>>      test of whether to actually sleep:
>>
>>   	set_current_state(TASK_UNINTERRUPTIBLE);
>>   	if (do_i_need_to_sleep())
>>   		schedule();
>>
>>
>> Since the current CPU sees the memory accesses in order, what can be 
>> happening on other CPUs that would require a full mb()?
> 
> Lets look at a hypothetical situation with:
> 
> 	add_wait_queue();
> 	current->state = TASK_UNINTERRUPTIBLE;
> 	smp_wmb();
> 	if (!x)
> 		schedule();
> 
> 
> 
> Then somewhere we probably have:
> 
> 	x = 1;
> 	smp_wmb();
> 	wake_up(queue);
> 
> 
> 
> 	   CPU 0			   CPU 1
> 	------------			-----------
> 	add_wait_queue();
> 	(cpu pipeline sees a load
> 	 of x ahead, and preloads it)


This is what I thought.

My cpu (Cavium Octeon) does not have out of order reads, so my wmb() is 
in fact a full mb() from the point of view of the current CPU.  So I 
think I could weaken my bariers in set_current_state() and still get 
correct operation.  However as you say...


> 					x = 1;
> 					smp_wmb();
> 					wake_up(queue);
> 					(task on CPU 0 is still at
> 					 TASK_RUNNING);
> 
> 	current->state = TASK_INTERRUPTIBLE;
> 	smp_wmb(); <<-- does not prevent early loading of x
> 	if (!x)  <<-- returns true
> 		schedule();
> 
> Now the task on CPU 0 missed the wake up.
> 
> Note, places that call schedule() are not fast paths, and probably not
> called often. Adding the overhead of smp_mb() to ensure correctness is a
> small price to pay compared to search for why you have a stuck task that
> was never woken up.

... It may not be worth the trouble.


> 
> Read Documentation/memory-barriers.txt, it will be worth the time you
> spend doing so.

Indeed I have read it.  My questions arise because the semantics of my 
barrier primitives do not map exactly to the semantics prescribed for 
mb() and wmb().

A kernel programmer has only the types of barriers described in 
memory-barriers.txt available.  Since there is no 
mb_on_current_cpu_but_only_order_writes_as_seen_by_other_cpus(), we use 
  a full mb() instead.


Thanks for the explanation Steve,

David Daney
