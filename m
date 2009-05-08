Return-Path: <linux-kernel-owner+w=401wt.eu-S1762162AbZEHBKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762162AbZEHBKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbZEHBKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:10:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50750 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbZEHBKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:10:15 -0400
Message-ID: <4A0386A8.6030501@cn.fujitsu.com>
Date: Fri, 08 May 2009 09:11:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] tracing: add hierarchical enabling of events
References: <20090507031335.815354104@goodmis.org> <20090507031434.807772092@goodmis.org> <4A025AAC.2000201@cn.fujitsu.com> <alpine.DEB.2.00.0905070912120.32734@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905070912120.32734@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Like this:
>>
>> $ cat events/irq/enable
>> 0 irq_handler_entry
>> 0 irq_handler_exit
>> 1 softirq_entry
>> 1 softirq_exit
> 
> I thought about doing something like this, but this idea for the 
> hierarchical enabling came to me around 11pm, and I had the code written 
> by 11:15pm ;-)
> 
> Which means, I figured I would do it as simple as possible. We do have 
> "set_event" that gives you a list of enabled events. My thought was still 
> having a "1" or "0" if all are either enabled or disabled. And when it is 
> a mixture, I would have a list of enabled events.
> 
> Though, it is useful. Maybe in the future. But really, the information is 
> there, and I did not expect this to be a "what is enabled" file, but 
> instead a "I want to enable/disable all these events". In other words, I 
> was much more interested in the "write" ability than the read. But who 
> knows, maybe this will change in the future.
> 

I have no strong opinion on this. So I'm fine with it, if
no one else has objections.

>> How about:
>>
>> int set = 0;
>>
>> ...
>> set |= (1 << call->enabled);
> 
> * paranoid *
> 
>   set |= (1 << !!call->enabled);
> 
>> ...
>>
>> set == 0: '?'
>> set == 1: '0'
>> set == 2: '1'
>> set == 3: 'X'
>>
>> Will this make the code simpler? :)
>>
>> Or we can go even further:
>>
>> char result[4] = { '?', '0', '1', 'X' };
>> ...
>> buf[0] = result[set];
> 
> cute, mind sending a patch ;-)
> 

Sure. :)

>>> +	ret = ftrace_set_clr_event(command, val);
>> I think we should pass "sched:" or "sched:*", instead of "sched",
>> the comment in ftrace_set_clr_event():
>>
>>          *  <name> (no ':') means all events in a subsystem with
>>          *  the name <name> or any event that matches <name>
> 
> Yeah, I thought about it too. But writing the patch in 15 minutes, I 
> decided that a "kstrdup" was easier than adding a ":" ;-)
> 

I think we can just avoid any kstrdup() or kmalloc(). I'll send a patch.
