Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbZGUB1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbZGUB1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:27:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZGUB1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:27:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61224 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbZGUB1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:27:02 -0400
Message-ID: <4A651907.1090805@cn.fujitsu.com>
Date: Tue, 21 Jul 2009 09:25:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/filters: Improve subsystem filter
References: <4A63D485.7030703@cn.fujitsu.com> <alpine.DEB.2.00.0907201207390.7595@gandalf.stny.rr.com> <alpine.DEB.2.00.0907201230320.7595@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0907201230320.7595@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 20 Jul 2009, Steven Rostedt wrote:
> 
>>
>> On Mon, 20 Jul 2009, Li Zefan wrote:
>>
>>> Currently a subsystem filter should be applicable to all events
>>> under the subsystem, and if it failed, all the event filters
>>> will be cleared. Those behaviors make subsys filter much less
>>> useful:
>>>
>>>   # echo 'vec == 1' > irq/softirq_entry/filter
>>>   # echo 'irq == 5' > irq/filter
>>>   bash: echo: write error: Invalid argument
>>>   # cat irq/softirq_entry/filter
>>>   none
>>>
>>> I'd expect it set the filter for irq_handler_entry/exit, and
>>> not touch softirq_entry/exit.
>>>
>>> The basic idea is, try to see if the filter can be applied
>>> to which events, and then just apply to the those events:
>>>
>>>   # echo 'vec == 1' > softirq_entry/filter
>>>   # echo 'irq == 5' > filter
>>>   # cat irq_handler_entry/filter
>>>   irq == 5
>>>   # cat softirq_entry/filter
>>>   vec == 1
> 
> OK, I tried this and it worked as you described, but it also does 
> something that I did not like. Basically this:
> 
> # echo 'vec == 1' > filter
> # cat softirq_entry/filter
>  vec == 1
> # cat irq_handler_entry/filter
>  none
> # cat filter
>  vec == 1
> # echo 'irq == 5' > filter
> # cat irq_handler_entry/filter
>  irq == 5
> # cat softirq_entry/filter
>  vec == 1
> # cat filter
>  irq == 5
> 
> 
> That last "cat filter" should show:
>  vec == 1
>  irq == 5
> 

But I did not change the read semantic. For example, when
subsystem filter is not set at all:

 # echo 'irq == 5' > irq_handler_entry/filter
 # echo 'vec == 1' > softirq_entry/filter
 # cat filter
 none

It'll show "none".

> I can keep this version, since I do find it useful (I've now come to the 
> conclusion that having the filter work only for those filters that it 
> would work for is fine). But the top level filter should show all filters.
> 

As I said in an old mail, I think the subsystem filter is much more
useful in "write" than in "read".

I have no strong option about its read semantic, but I can do what
you like.

Suppose:
  irq_handler_entry/filter ->  irq == 5
  irq_handler_exit/filter  ->  none
  softirq_entry/filter     ->  vec == 1
  softirq_exit/filter      ->  vec == 2

Proposal 1:

  # cat filter
  irq == 5
  vec == 1
  vec == 2

Proposal 2:

  # cat filter
  irq_handler_entry: irq == 5
  irq_handler_exit: none
  softirq_entry: vec == 1
  softirq_exit: vec == 2

Which do you think is better? Or do you have some better idea?

And in the failure case:

  # echo 'irq == not_num' > filter
  bash: echo: write error: Invalid argument

1:
  # cat filter
  (still shows filters in each event like above)

or shows error message (the current behavior)

2:
  # cat filter
  irq == not_num
  ^
  parse_error: Couldn't find or set field in one of a subsystem's events

?

