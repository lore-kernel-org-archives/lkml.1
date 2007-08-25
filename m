Return-Path: <linux-kernel-owner+w=401wt.eu-S1764578AbXHYR0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764578AbXHYR0U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 13:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbXHYR0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 13:26:12 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35130 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbXHYR0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 13:26:11 -0400
Message-ID: <46D065DC.2030902@us.ibm.com>
Date: Sat, 25 Aug 2007 10:24:44 -0700
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: taoyue <yue.tao@windriver.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] sigqueue_free: fix the race with collect_signal()
References: <20070823134538.GA1358@tv-sign.ru> <46CEEA94.2070902@windriver.com> <20070824074558.GA86@tv-sign.ru> <46CF4DCB.6030304@windriver.com> <20070824110836.GA74@tv-sign.ru> <46CF3988.1020408@us.ibm.com> <20070824202305.GA274@tv-sign.ru>
In-Reply-To: <20070824202305.GA274@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 08/24, Sukadev Bhattiprolu wrote:
>   
>> Oleg Nesterov wrote:
>>     
>>> On 08/24, taoyue wrote:
>>>  
>>>       
>>>> Oleg Nesterov wrote:
>>>>    
>>>>         
>>>>>> collect_signal:				sigqueue_free:
>>>>>>
>>>>>> 	list_del_init(&first->list);
>>>>>>                                      spin_lock_irqsave(lock, flags);
>>>>>>   
>>>>>>        
>>>>>>             
>>>>>                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>>
>>>>>      
>>>>>           
>>>>>>                                      if (!list_empty(&q->list))
>>>>>>                                            list_del_init(&q->list);
>>>>>>                                      spin_unlock_irqrestore(lock, 
>>>>>>                                      flags);
>>>>>>                                      q->flags &= ~SIGQUEUE_PREALLOC;
>>>>>>
>>>>>>      __sigqueue_free(first);		__sigqueue_free(q);
>>>>>>   
>>>>>>        
>>>>>>             
>>>>> collect_signal() is always called under ->siglock which is also taken by
>>>>> sigqueue_free(), so this is not possible.
>>>>>
>>>>>
>>>>>      
>>>>>           
>>>> I know, using current->sighand->siglock to prevent one sigqueue
>>>> is free twice. I want to know whether it is possible that the two
>>>> function is called in different thread. If that, the spin_lock is useless.
>>>>    
>>>>         
>>> Not sure I understand. Yes, it is possible they are called by 2 different
>>> threads, that is why we had a race. But all threads in the same thread
>>> group have the same ->sighand, and thus the same ->sighand->siglock.
>>>  
>>>       
>> Oleg, if one thread can be in collect_signal() and another in 
>> sigqueue_free() and both operate on the exact same sigqueue object, its 
>> not clear how we prevent two calls to __sigqueue_free() to
>> the same object. In that case the lock (or some lock) should be around 
>> __sigqueue_free() - no ?
>>
>> i.e if we enter sigqueue_free(), we will call __sigqueue_free() 
>> regardless of the state.
>>     
>
> Yes. They both will call __sigqueue_free(). But please note that __sigqueue_free()
> checks SIGQUEUE_PREALLOC, which is cleared by sigqueue_free().
>
> IOW, when sigqueue_free() unlocks ->siglock, we know that it can't be used
> by collect_signal() from another thread. So we can clear SIGQUEUE_PREALLOC
> and free sigqueue. We don't need this lock around sigqueue_free() to prevent
> the race. collect_signal() can "see" only those sigqueues which are on list.
>
> IOW, when sigqueue_free() takes ->siglock, colect_signal() can't run, because
> it needs the same lock. Now we delete this sigqueue from list, nobody can
> see it, it can't have other references. So we can unlock ->siglock, mark
> sigqueue as freeable (clear SIGQUEUE_PREALLOC), and free it.
>
> Do you agree?
>   

Yes. I see it now. I had missed the SIGQUEUE_PREALLOC in __sigqueue_free().

Thanks for clarifying

Suka


