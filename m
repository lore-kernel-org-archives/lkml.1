Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZFSFAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZFSFAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 01:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZFSFAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 01:00:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62465 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZFSFAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 01:00:24 -0400
Message-ID: <4A3B1BC9.9010601@cn.fujitsu.com>
Date: Fri, 19 Jun 2009 13:02:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/filters: restore orignal filter when new
 filter isn't applicable
References: <4A38AD7F.2070408@cn.fujitsu.com>	 <1245304705.6207.78.camel@tropicana>	 <alpine.DEB.2.00.0906181915350.6890@gandalf.stny.rr.com> <1245386803.9918.49.camel@tropicana>
In-Reply-To: <1245386803.9918.49.camel@tropicana>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Zanussi wrote:
> On Thu, 2009-06-18 at 19:18 -0400, Steven Rostedt wrote:
>>
>> On Thu, 18 Jun 2009, Tom Zanussi wrote:
>>
>>> Hi,
>>>
>>> On Wed, 2009-06-17 at 16:46 +0800, Li Zefan wrote:
>>>> | commit 7ce7e4249921d5073e764f7ff7ad83cfa9894bd7
>>>> | Author: Tom Zanussi <tzanussi@gmail.com>
>>>> | Date:   Sun Mar 22 03:31:04 2009 -0500
>>>> |
>>>> |     tracing: add per-event filtering
>>>> |     ...
>>>> |
>>>> |     Filters can also be set or cleared for a complete subsystem by writing
>>>> |     the same filter as would be written to an individual event to the
>>>> |     filter file at the root of the subsytem.  Note however, that if any
>>>> |     event in the subsystem lacks a field specified in the filter being
>>>> |     set, the set will fail and all filters in the subsytem are
>>>> |     automatically cleared.  This change from the previous version was made
>>>> |     because using only the fields that happen to exist for a given event
>>>> |     would most likely result in a meaningless filter.
>>>>
>>>> I really don't like this change. It is inconvenient, and makes subsystem
>>>> filter much less useful:
>>>>
>>>>   # echo 'vec == 1' > irq/softirq_entry/filter
>>>>   # echo 'irq == 5' > irq/filter
>>>>   bash: echo: write error: Invalid argument
>>>>   # cat irq/softirq_entry/filter
>>>>   none
>>>>
>>>> I'd expect this will set the filter for irq_handler_entry and
>>>> irq_handler_exit, and won't touch softirq_entry and softirq_exit.
>>>>
>>>> But it just failed, and what's worse, each event's filter was
>>>> cleared.
>>>>
>>> The idea behind the change was that after setting a subsystem filter,
>>> you'd be guaranteed that all or none of the events in the subsystem
>>> would have the same filter at that point, and not some mix of different
>>> filters depending on which ones failed or not, which to me seemed
>>> nonintuitive.
>>>
>>> If I set a filter like "vec == 1 && irq == 5", which really has no
>>> overall meaning, I wouldn't expect softirq_entry to get "vec == 1" and
>>> irq_handler_entry to get "irq == 5" - I'd rather get an error, but
>>> that's just me.
>>>
>>> So if it makes more sense to users to have subsystem filters propagate
>>> to whichever events will take them, this patch would be fine with me.
>>>
>> I disagree. If a subsystem filter is set, it should be valid for all 
>> filters underneath, if it is not, it should error.
>>
>> But Li has a point, if you get an error, it should not reset all filters 
>> underneath. That is, if the irq/filter setting took an error, then 
>> irq/softirq_entry/filter should still stay the same.
>>
>> Perhaps you need to run through it twice. See if the setting of a filter 
>> is valid for all filters underneath, if it is not, then fail. If it is, 
>> then reset all of them, and assign the filter.
>>
> 
> Yeah, I agree that this is better than just clearing them all on an
> error, but it still means that a subsystem filter will succeed only when
> it names common_ (or commonly named) fields.
> 
> I think what Li is saying is that that restriction makes the subsystem
> filters less useful, and you should for convenience' sake be allowed to
> propagate a filter to a subset and ignore the ones that don't make
> sense.
> 

Yeah, being able to do this should be very useful:

  # echo 'irq == 1' > irq/filter
  # echo 'vec == 5' > irq/filter

Otherwise I have to set each filter one by one.

After setting subsystem/filter, one can change a single event's filter,
and then the subsys/filter is not consistent with it's members' filter.

So subsystem/filter is much more useful in writing but not reading.

> Note that there's a danger in this case that a filter might be applied
> but not really make sense e.g. two events might have a 'vec' field that
> mean completely different things but the filter would be applied to both
> just because they have the same name.  The only way to ensure that they

This should be rare. In a subsys, if 2 events have a field with the
same name, they normally means the same thing.

And even in this case, it's not that dangerous I think. ;)

> would always make sense would be to restrict the subsystem filter to
> just the common_ fields.
> 
> But that's less useful, and maybe it would be better to leave the choice
> up the user...
> 

