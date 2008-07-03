Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYGCSyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYGCSyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 14:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYGCSyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 14:54:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbYGCSyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:54:17 -0400
Message-ID: <486D1FCC.5040205@redhat.com>
Date: Thu, 03 Jul 2008 14:51:56 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC PATCH] Kernel Tracepoints
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com> <20080625235214.GA14249@Krystal> <486403F0.4020801@redhat.com> <20080627133009.GC13751@Krystal> <48655464.5040000@redhat.com> <20080630154002.GE17388@Krystal> <48693AFB.1020304@redhat.com> <20080703151238.GA3102@Krystal>
In-Reply-To: <20080703151238.GA3102@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> Hi Mathieu,
>>
>> Mathieu Desnoyers wrote:
>>> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>>>> Mathieu Desnoyers wrote:
>>>>> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>>>>>  >
>>>>>>> Implementation of kernel tracepoints. Inspired from the Linux Kernel Markers.
>>>>>> What would you think redesigning markers on tracepoints? because most of the
>>>>>> logic (scaning sections, multiple probe and activation) seems very similar
>>>>>> to markers.
>>>>>>
>>>>> We could, although markers, because they use var args, allow to put the
>>>>> iteration on the multi probe array out-of-line. Tracepoints cannot
>>>>> afford this and the iteration must be done at the initial call-site.
>>>>>
>>>>> From what I see in your proposal, it's mostly to extract the if() call()
>>>>> code from the inner __trace_mark() macro and to put it in a separate
>>>>> macro, am I correct ? This would make the macro more readable.
>>>> Sure, I think marker and tracepoint can share below functions;
>>>> - definition of static local variables in specific sections
>>> Given that we could want to keep activation of tracepoints and markers
>>> separate (so they don't share the same namespace), declaring the static
>>> variables in separated sections seems to make sense to me.
>> Sorry, I'm not sure what is "separate activation".
>> As far as I can see, both tracepoints and markers are activated
>> when its probe handlers are registered on each tracepoint/marker.
>> Aren't it separated?
>>
> 
> Yes, it is separate. This is insured by the fact that markers and
> tracepoints are declared in different sections. Therefore, even if they
> have the same "name", they won't be used by each other.

I reviewed both marker and tracepoint deeply in these days, and
recognized what you said. Actually, markers and tracepoint would
better have separate sections.

[...]
>>>> - probe activation code (if() call())
>>>> - multi probe handling
>>> Hrm, the thing here is that because markers allow to do the iteration on
>>> the multiple probe callbacks within an internal wrapper (instead of
>>> doing it on-site as in the tracepoints), it allows to do some further
>>> optimizations (less memory allocation and less pointer dereference in
>>> the single probe case, not having to prepare the va_args in the
>>> MARK_NOARGS case) which are only done because it does not have to add
>>> code to the instrumentation site. However, tracepoints cannot have such
>>> "generic" wrapper and we have to do the iteration on callbacks in the
>>> code added to the instrumented object. Therefore, I keep it as small as
>>> possible in terms of bytes of instructions.
>> OK, I see. So, __tracepoint_block() macro can specify handler function.
>> what would you think about it?
>>
> 
> When I originally designed the markers, I tried to make sure there was
> absolutely no code duplication until I discovered that trying to read a
> huge amount of nested macros is just a pain starting from a certain
> level. If we only save a few duplicated lines but end up tying up
> markers and tracepoints, I am far from certain that it will make the
> code more readable.

After reviewing, I knew it is hard to implement markers on tracepoint.
maybe, I need to find another way or maintenance both codes.


> I'll post a tracepoint version with the modifications you proposed (it's
> now placed earlier in the patchset), except the merge with markers.

I see, if it is acceptable for upstream developers, I have no problem.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

