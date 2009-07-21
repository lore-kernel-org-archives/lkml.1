Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbZGUGgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbZGUGgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZGUGgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:36:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57665 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754912AbZGUGgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:36:40 -0400
Message-ID: <4A656194.50700@cn.fujitsu.com>
Date: Tue, 21 Jul 2009 14:35:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/filters: Improve subsystem filter
References: <4A63D485.7030703@cn.fujitsu.com> <1248154585.6323.26.camel@tropicana>
In-Reply-To: <1248154585.6323.26.camel@tropicana>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Zanussi wrote:
> Hi,
> 
> On Mon, 2009-07-20 at 10:20 +0800, Li Zefan wrote:
>> Currently a subsystem filter should be applicable to all events
>> under the subsystem, and if it failed, all the event filters
>> will be cleared. Those behaviors make subsys filter much less
>> useful:
>>
>>   # echo 'vec == 1' > irq/softirq_entry/filter
>>   # echo 'irq == 5' > irq/filter
>>   bash: echo: write error: Invalid argument
>>   # cat irq/softirq_entry/filter
>>   none
>>
>> I'd expect it set the filter for irq_handler_entry/exit, and
>> not touch softirq_entry/exit.
>>
>> The basic idea is, try to see if the filter can be applied
>> to which events, and then just apply to the those events:
>>
>>   # echo 'vec == 1' > softirq_entry/filter
>>   # echo 'irq == 5' > filter
>>   # cat irq_handler_entry/filter
>>   irq == 5
>>   # cat softirq_entry/filter
>>   vec == 1
>>
> 
> It looks like it accomplishes the goal, but I wonder if you could
> simplify it by getting rid of the no_reset flag and all the state-saving
> while keeping the dry_run param on filter_add_pred to use from
> filter_add_subsysystem_pred() e.g. something like this:
> 
> filter_add_subsystem_pred(...)
> {
> 	...
> 	list_for_each_entry(call, &ftrace_events, list) {
> 		err = filter_add_pred(ps, call, pred, dry_run = 1);
> 		if (!err)
> 			filter_add_pred(ps, call, pred, dry_run = 0);

This is the same with just call "filter_add_pred(ps, call, pred)"

> 		...
> 	}
> }
> 
> IIRC the state-saving was necessary if the idea was to back out of (or
> avoid setting) all the filters if one failed, but the new model is to
> set whichever apply while leaving the rest alone.  I think the simpler
> approach above accomplishes that, but I may be missing something or have
> forgotten the original motivation for doing it this way.
> 

This won't work as expected. The state-saving is necessary, because
if any pred is not appliable for an event, the whole operation should
fail for that event.

What this patch does is apply the filter to those events that the
filter is appliable, but not apply parts of the filter to each event.

Imaging the result for those filters with the above code:

  # echo 'irq == 5 && vec == 1' > filter
  # echo 'irq == 5 || vec == 1' > filter
  # echo 'irq == 5 || foo == bar' > fitler
  # echo '(irq == 5 && vec == 1) || irq == 2' > filter

