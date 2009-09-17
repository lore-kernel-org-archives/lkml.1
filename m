Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZIQAnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZIQAnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbZIQAni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:43:38 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37629 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbZIQAni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:43:38 -0400
Message-ID: <4AB185E7.1090007@bk.jp.nec.com>
Date: Thu, 17 Sep 2009 09:42:15 +0900
From: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, fweisbec@gmail.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
       systemtap@sources.redhat.com
Subject: Re: [PATCH 2/2] tracing: Export ftrace API for kernel modules
References: <4AAF6728.6010807@bk.jp.nec.com>	 <1253022224.20020.102.camel@gandalf.stny.rr.com>	 <4AAF9E30.5030705@redhat.com>	 <1253024944.20020.109.camel@gandalf.stny.rr.com>	 <4AB08133.4070504@bk.jp.nec.com> <1253106255.20020.191.camel@gandalf.stny.rr.com>
In-Reply-To: <1253106255.20020.191.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 2009-09-16 at 15:09 +0900, Atsushi Tsuji wrote:
> 
>>> I don't want to disable preemption when I don't have to. The function
>>> tracer that is called can. But actually, it's ever more that that. If
>>> you only register a single function, it will call that function
>>> directly. Then there will always be a race window between when the
>>> function gets called and disabling preemption, even if the called
>>> function disables preemption as the first thing it does.
>> Thank you for detailed explanation.
>>
>> I may be wrong, but I think function_trace_probe_call using 
>> register_ftrace_function_probe is almost enough for modules,
> 
> Heh, I forgot about function_probe. Yeah, looking at that, it does seem
> that it would be safe for modules.
> 
>> since it disables preemption while a probe is calling and it
>> called every time even if only one probe function is registered.
>> So is it enough to make a new registering function using
>> it and upping module ref count for module safe?  
> 
> Yes, upping the module ref count for every function probe would be
> required. Unfortunately, this would require adding another variable to
> struct ftrace_func_probe, which I hate to do.
> 
> 
>> Or should I make another handler for modules not using
>> function_trace_probe_call?
> 
> Maybe another handler might be better. But it may be similar to
> function_probe.

I see. I'll try to make a new handler for modules.

Thanks,
Atsushi

> 
>>>>> It will still need to up the mod ref count when a probe is added, but it
>>>>> can also remove it.
>>>>>
>>>>>
>>>>> The problem with the current method, is that a probe can be executing at
>>>>> anytime. Here's an example if we did it your way.
>>>>>
>>>>> 1. module installed
>>>>> 2. module adds probe
>>>>> 3. function X in kernel calls probe but gets preempted.
>>>>> 4. module removes probe
>>>>> 5. module unistalled
>>>>> 6. function X in kernel continues to run probe but probe no longer
>>>>> exists --- Oops!
>>>> Agreed, if mcount doesn't disable preemption, this will happen.
>>> And it does not.
>> I think the preemption is disabled in not register_ftrace_function
>> but register_ftrace_function_probe, is that wrong?
> 
> No that's correct. It's been a while since I worked on the probe code,
> so I forgot about it :-)
> 
> -- Steve
> 
> 
> 
> 

