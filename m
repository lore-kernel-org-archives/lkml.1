Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0CHHbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 02:31:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61535 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab0CHHbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 02:31:47 -0500
Message-ID: <4B94A816.4090608@cn.fujitsu.com>
Date: Mon, 08 Mar 2010 15:32:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.33: ftrace triggers soft lockup
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com> <1267710847.10871.102.camel@gandalf.stny.rr.com> <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com> <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com> <1267801603.10871.1725.camel@gandalf.stny.rr.com> <20100305171614.GC5244@nowhere>
In-Reply-To: <20100305171614.GC5244@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>>> I am not sure if this is ftrace's fault, but it is ftrace who triggers
>>>>>> the soft lockup. On my machine, it is pretty easy, just run:
>>>>>>
>>>>>> echo function_graph > current_tracer
>>>>>>
>>>> I can't say that because I didn't try -rc6.
>>>>
>>> Sigh, 2.6.33-rc6 doesn't work, even 2.6.32 doesn't work...
>> So basically you are saying that the function_graph tracer, when enabled
>> has a high overhead? Well, unfortunately, that's expected.
>>
>> The function_graph tracer traces the start and end of every function. It
>> uses the same mechanism as function tracer to trace the start of the
>> function (mcount), but to trace the exit of a function, in the enter of
>> the function it hijacks the return address and replaces it to call a
>> trampoline. This trampoline will do the trace and then jump back to the
>> original return address.
>>
>> Doing this breaks branch prediction in the CPU, as the CPU uses call/ret
>> as part of its branch prediction analysis. So function graph tracing is
>> not just twice as slow as function tracing, it actually has a bigger
>> impact than that.
> 
> 
> It's true it has a high overhead, but not to the point of
> making the whole system unusable. We are supposed to be even
> far from that. I'm currently able to turn on the function graph
> tracer and use firefox without problems. It's just a bit slower
> but it's far from a visible starvation.
> 
> And Li seems to see the same thing.

Yes, and more than this. I can see segmentation fault while testing,
both my testing threads and kernel building threads that are running
at the same time can get segfault.

> For now I can not test, but I will try this week-end.
> 
