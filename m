Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbYFLPdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbYFLPdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYFLPd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:33:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbYFLPd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:33:26 -0400
Message-ID: <48514150.6090001@redhat.com>
Date: Thu, 12 Jun 2008 11:31:28 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Peter Zijlstra <peterz@infradead.org>, Hideo AOKI <haoki@redhat.com>,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Kernel marker has no performance impact on ia64.
References: <48447052.3030300@redhat.com> <1212445965.6269.22.camel@lappy.programming.kicks-ass.net> <20080602232135.GA20173@Krystal> <1212618449.19205.35.camel@lappy.programming.kicks-ass.net> <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net> <4847F811.7060406@redhat.com> <20080612140415.GC22348@Krystal>
In-Reply-To: <20080612140415.GC22348@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Mathieu Desnoyers wrote:
>> If so, I'd like to suggest below changes,
>>
>> - introduce below macro in marker.h
>>
>> #define DEFINE_TRACE(name, vargs, args...)	\
>> static inline void trace_##name vargs		\
>> {						\
>> 	trace_mark(name, #vargs, ##args);	\
>> }
>>
>> - remove __marker_check_format from __trace_mark
>> - and write a definition in sched_trace.h
>>
>> DEFINE_TRACE(sched_switch, (struct task_struct *prev, struct task_struct *next),
>> 	     prev, next);
>>
>> Thus, we can remove fmt string and also ensure the type checking, because;
>> - Type checking at the trace point is done by the compiler.
>> - Type checking of probe handler can be done by comparing #vargs strings.
>>
> 
> Hrm, interesting! The only problem I see with this is that it won't
> allow a tracer to efficiently parse the "format information". Parsing C
> code is not as straightforward and compact as parsing a format string.

Sure, Parsing C code is not a good idea. I think each tracer can have
a lookup table to get a printf-style format corresponding to each
"regular" marking point. Maintaining this lookup table is not so hard,
because these "regular" marking points should be enough stable.

> However, Peter and you are about to convince me that an hybrid between
> the solution you propose here and the marker scheme could be used.
> 
> Your scheme could be used to declare the markers and probes
> (DEFINE_TRACE()) in header files. It would declare a static inline
> function called at the instrumentation site and a probe prototype
> that could then be used in the probe module to declare the probe that
> will have to be connected to the marker. This part would allow
> custom-made probes.
> 
> Within the tracer, we would declare custom-made probes for each of these
> DEFINE_TRACE statements and associate them with format strings. Because
> the probe has to match the prototype, type correctness is ensured. The
> format strings would at that point be the exact same as the current
> trace_mark() statements. The information passed to trace_mark() would be
> send for direct interpretation or serialization with only basic types
> available, similar to printk().

If the tracer including systemtap introduces above the lookup table,
that can translate "name(arguments)" to "format" easily, and can continue
to use its format string parser.

> We sould leave the trace_mark() statements available for people who want
> to add their own debug-style instrumentation to their kernel without
> having to add DEFINE_TRACE() statements and modify the tracer
> accordingly.

I agree, trace_mark() still useful for "non-regular" markers temporarily
inserted to the developing code by individual developers.

> I guess a bit of polishing will come with the implementation, which I
> plan to start soon.
> 
> Thanks!
> 
> Mathieu
> 

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

