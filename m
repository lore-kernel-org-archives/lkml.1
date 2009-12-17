Return-Path: <linux-kernel-owner+w=401wt.eu-S1764050AbZLQH16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764050AbZLQH16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 02:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764035AbZLQH1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 02:27:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61030 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1761023AbZLQH1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 02:27:52 -0500
Message-ID: <4B29DD0D.2060801@cn.fujitsu.com>
Date: Thu, 17 Dec 2009 15:26:05 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] perf/timer: 'perf timer' core code
References: <4B27702F.1080507@cn.fujitsu.com> <4B2770AD.90005@cn.fujitsu.com> <4B2770FA.7090803@cn.fujitsu.com> <4B277143.9070909@cn.fujitsu.com> <4B277191.6020500@cn.fujitsu.com> <alpine.LFD.2.00.0912151539420.2755@localhost.localdomain> <4B287690.4000305@cn.fujitsu.com> <alpine.LFD.2.00.0912161629460.2755@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912161629460.2755@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thomas Gleixner wrote:
> 
> Nothing to be sorry about. That's why we review code.
>  

Thanks.

>> Um, but not every timer has it's owner task, for example, if we start
>> a timer in interrupt handle function, this timer in not owns any tasks.
>> And itimer is started by userspace task so we can get it's owner, that
>> why i print hex address for timer/hrtimer, and print task name for itimer.
> 
> Well, lot's of timers have an owner task. At least all user space
> related ones. And if the timer is rearmed in interrupt context, then
> this does not change the owner at all.
> 

Sorry, i'm confused, for example, has below sequence:

Task1 running----->| (interrupt)
                   |------------- start timerT(start timerT in interrupt handler)

......
( After a while, schedule to another task, and interruption coming )
......

Task2 running----->| (interrupt)
                   |------------- start timerT again

Then, which task is the timerT owner?

Am I missed something?

>>>   How should that work ?
>>>
>> We put/get timer in a rb-tree base on the specify order, for example:
>> we default use this order:
>>
>> sort_dimension__add("timer", &default_cmp);
>> sort_dimension__add("itimer-type", &default_cmp);
>>
>> if timer_info->timer is bigger, we put it to left child, littler to right
>> child, if the timer_info->timer is the same, then we compare
>> timer_info->itimer_type.
> 
> Hmm, I wonder whether a hash table would be more efficient for the
> recording side.
> 

Um. i'll record it address your way.

> 
>> We search timer base on timer_info->timer and
>> timer_info->itimer_type(not timer_info->type), if we find the
>> timer's type is changed(for example, the timer is "ITIMER" before,
>> and change to "HRTIMER" later), is should a bug. this case is hardly
>> to happen but should catch it.
> 
> No, it's not a bug at all. You _can_ have a hrtimer and a timer_list
> timer at the same address in a trace. There are two ways to make that
> happen:
> 
>  1) kmalloc'ed memory contains a timer_list. timer operation is done,
>     memory is kfreed. Now another kmalloc gets the just freed memory
>     and has a hrtimer at the same address which was used by the
>     timer_list before.
> 
>  2) timer_list and hrtimer are also allocated on stack. There is no
>     guarantee that they are at different addresses.
>  

Yeah, my mistake.

> Simply because the macro hides the fact that this is an assignment of
> a value to a variable. That makes the code harder to read.
> 
>  	FILLL_RAW_FIELD_VALUE(event, value_sec, data);
> vs.	
> 	value_sec = get_value(data, event, "value_sec");
> 
> The latter is fast to parse and entirely clear.
> 

Yeah.

> Btw, you agreed above that the open coded call of raw_field_value()
> is clearer than the macro magic. :)
> 

Sorry, i misunderstand your mean before.

Thanks,
Xiao
