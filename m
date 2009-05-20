Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZETC25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZETC25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 22:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbZETC2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 22:28:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58340 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbZETC2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 22:28:49 -0400
Message-ID: <4A136A23.8040500@cn.fujitsu.com>
Date: Wed, 20 May 2009 10:25:39 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] tracing: add trace_event_read_lock()
References: <4A114806.7090302@cn.fujitsu.com> <20090518135930.GC4704@nowhere> <4A1213E1.8050608@cn.fujitsu.com> <20090520002451.GE6066@nowhere>
In-Reply-To: <20090520002451.GE6066@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, May 19, 2009 at 10:05:21AM +0800, Lai Jiangshan wrote:
>> Frederic Weisbecker wrote:
>>> On Mon, May 18, 2009 at 07:35:34PM +0800, Lai Jiangshan wrote:
>>>> I found that there is nothing to protect event_hash in
>>>> ftrace_find_event().
>>>
>>>
>>> Actually, rcu protects it, but not enough. We have neither
>>> synchronize_rcu() nor rcu_read_lock.
>> We have no rcu_read_lock(), RCU can not protects it.
>>
>>> So we protect against concurrent hlist accesses.
>>> But the event can be removed when a module is unloaded,
>>> and that can happen between the time we get the event output
>>> callback and the time we actually use it.
>>>
>> [...]
>>
>>> It could be more fine grained.
>> I think it's fine-grained enough, write-side(modules loading/unloading)
>> is happened rarely. trace_event_read_lock() will not sleep very likely.
>>
>> Thoughts?
> 
> 
> Yeah, the write lock is a rare event, that's why I think
> it's enough fine grained.
> 
>  
>>> We could have a per event rwsem, and also place the
>>> protected read section only in trace_print_entry() which is the only racy window.
>>>
>> print_trace_line() is the only racy window.
>> So I just protect print_trace_line()(except __ftrace_dump())
>>
>> I protect loops which call print_trace_line(), it
>> reduces invoke-times:
>>
>> trace_event_read_lock();
>> while (...) {
>> 	...
>> 	print_trace_line();
>> 	...
>> }
>> trace_event_read_unlock();
> 
> 
> 
> Yeah, I meant it could have been:
> 
> trace_event_read_lock();
> print_trace_line();
> trace_event_read_unlock();
> 
> It's more fine grained, but:
> 
> - the write lock path is rarely taken
> - it would add more extra calls then more overhead
> 
> IMO this is fine as an rwsem design point of view.
> 
> But I have mixed feelings when I consider it could be
> done using rcu. I will explain that in my next answer to
> Paul and will wait for your comments.
> 

rcu_read_lock() will disable preempt for im-preemptable RCU,
it will add latency to kernel, because print_trace_line() is not
a short function.


The smallest window is:
(print_trace_line() calls ftrace_find_event() by several paths)

	XXX_read_lock();
	event = ftrace_find_event(entry->type);
	if (event)
		event->YYYY();
	XXX_read_unlock();

but event->YYYY() is not a short function neither.

Since write-side is rarely taken, sleep-able read-side(rwsem)
will not block each other. So I use trace_event_read_lock()
protects the biggest window(the loops).


In LTTng, the tracing code(trace_NAME()) accesses to
event type list, so RCU is needed in LTTng for event type list.

But Ftrace's tracing code does not accesses to event type list,
I don't know this logic is still true in future. Steven may
give me an answer.

Lai.

