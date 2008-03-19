Return-Path: <linux-kernel-owner+w=401wt.eu-S965501AbYCSVFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965501AbYCSVFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760842AbYCSTzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:55:55 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:2963 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbYCSTzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:55:41 -0400
Message-ID: <47E13E60.9050706@dso.org.sg>
Date: Thu, 20 Mar 2008 00:25:04 +0800
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Peter Teoh <htmldeveloper@gmail.com>,
       Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: per cpun+ spin locks coexistence?
References: <804dabb00803120917w451b16e6q685016d464a2edde@mail.gmail.com>	 <47DABBCE.5010803@goop.org>	 <804dabb00803160930t40b7c415ic38f2b9955b515ac@mail.gmail.com>	 <87bq5e1kvm.fsf@saeurebad.de>	 <804dabb00803171006i4423c5b6w58bd95116510d3f5@mail.gmail.com>	 <47DEC4F4.5010703@cosmosbay.com> <804dabb00803181000g408b8ab9oe1075952dc859823@mail.gmail.com> <47E0033E.4010300@cosmosbay.com>
In-Reply-To: <47E0033E.4010300@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
From: Peter Teoh <htmldeveloper@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Peter Teoh a écrit :
>> On 3/18/08, Eric Dumazet <dada1@cosmosbay.com> wrote:
>>
>>  
>>> You are right Peter, that fs/file.c contains some leftover from 
>>> previous
>>>  implementation of defer queue,
>>>  that was using a timer.
>>>
>>>  So we can probably provide a patch that :
>>>
>>>  - Use spin_lock() & spin_unlock() instead of spin_lock_bh() &
>>>  spin_unlock_bh() in free_fdtable_work()
>>>  since we dont anymore use a softirq (timer) to reschedule the 
>>> workqueue.
>>>
>>>  ( this timer was deleted by the following patch :
>>>  http://readlist.com/lists/vger.kernel.org/linux-kernel/50/251040.html
>>>
>>>
>>>  But, you cannot avoid use of spin_lock()/spin_unlock() because
>>>  schedule_work() makes no garantee that the work will be done by 
>>> this cpu.
>>>     
>>
>> Ah.....u have hit the nail....and combine with Johannes Weiner's
>> explanation, I have pieced together the full scenario:
>>
>> First, the following is possible:
>>
>>                 fddef = &get_cpu_var(fdtable_defer_list);
>>                 spin_lock(&fddef->lock);
>>                 fdt->next = fddef->next;
>>                 fddef->next = fdt;==============>executing at CPU A
>>                 /* vmallocs are handled from the workqueue context */
>>                 schedule_work(&fddef->wq);
>>                 spin_unlock(&fddef->lock);==============>executing at 
>> CPU B
>>                 put_cpu_var(fdtable_defer_list);
>>
>> where the execution can switch CPU after the schedule_work() API, then
>> LOGICALLY u definitely need the spin_lock(), and the per_cpu data is
>> really not necessary.
>>
>> But without the per_cpu structure, then the following "dedicated
>> chunk" can only execute on one processor, with the possibility of
>> switching to another processor after schedule_work():
>>   
> Hum, you misunderstood the point.
>
> schedule_work(); wont switch your current CPU, since you are inside a 
> spin_lock
> ()/spin_unlock() pair, so preemption is not possible.
>
>
>
>> So then we introduce the per_cpu structure - so that the "dedicated
>> chunk" can be executing on multiple processor ALL AT THE SAME TIME,
>> without interferring each other, as fddef are per-cpu (rightfully
>> owned only before schedule_work() is called, but after schedule_work()
>> is called, an arbitrary CPU will be executing this fddef).
>>
>> spin_lock() is necessary because of the possibility of CPU switch
>> (schedule_work()).
>>
>> and per_cpu is so that the same chunk of code can be executing at
>> multiple CPUs all at the same time.
>>
>> Now the key issue rises up - as I have just asked before u answered 
>> my question:
>>
>> http://mail.nl.linux.org/kernelnewbies/2008-03/msg00236.html
>>
>> can schedule_work() sleep?   (just like schedule(), whcih can sleep 
>> right?)
>> schedule_work() is guaranteed to execute the work queue at least once,
>> and so this thread may or may not sleep. correct?   Or wrong?
>>
>>   
> schedule_work() cannot sleep. It only queues a work to be done later 
> by a special thread.
>
> We need this because vfree() should not be called from softirq handler 
> (rcu in this case), so we queue a (small) job.
>> Problem is when u sleep and never wake up, then the spin_lock become
>> permanently locked, and when later the same CPU (have to be the same
>> fddef CPU) is being reschedule to execute the get_cpu_var() again, it
>> will spin_lock() infinitely, resulting in 100% CPU utilization error.
>>
>> To prevent these types of error, spin_lock are always not to be used
>> with to wrap around functions that can sleep, and can only containing
>> short routines between lock and unlock.
>>
>> Is my analysis correct?
>>
>>   
> Not exactly :) , but please continue to learn :)
>

Thank you everyone here for a very informative education.   I will go 
back and analyse in more detail. :-).


