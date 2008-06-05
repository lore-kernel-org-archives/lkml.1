Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbYFEOaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbYFEOaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbYFEOaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:30:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbYFEOae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:30:34 -0400
Message-ID: <4847F811.7060406@redhat.com>
Date: Thu, 05 Jun 2008 10:28:33 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Hideo AOKI <haoki@redhat.com>, mingo@elte.hu, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Kernel marker has no performance impact on ia64.
References: <48447052.3030300@redhat.com>	 <1212445965.6269.22.camel@lappy.programming.kicks-ass.net>	 <20080602232135.GA20173@Krystal>	 <1212618449.19205.35.camel@lappy.programming.kicks-ass.net>	 <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1212653539.19205.47.camel@lappy.programming.kicks-ass.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter and Mathieu,

Peter Zijlstra wrote:
> On Wed, 2008-06-04 at 19:22 -0400, Mathieu Desnoyers wrote:
>> * Peter Zijlstra (peterz@infradead.org) wrote:
> 
>>> So are you proposing something like:
>>>
>>> static inline void 
>>> trace_sched_switch(struct task_struct *prev, struct task_struct *next)
>>> {
>>> 	trace_mark(sched_switch, prev, next);
>>> }
>>>
>> Not exactly. Something more along the lines of
>>
>> static inline void 
>> trace_sched_switch(struct task_struct *prev, struct task_struct *next)
>> {
>>   /* Internal tracers. */
>>   ftrace_sched_switch(prev, next);
>>   othertracer_sched_switch(prev, next);
>>   /*
>>    * System-wide tracing. Useful information is exported here.
>>    * Probes connecting to these markers are expected to only use the
>>    * information provided to them for data collection purpose. Type
>>    * casting pointers is discouraged.
>>    */
>> 	trace_mark(kernel_sched_switch, "prev_pid %d next_pid %d prev_state %ld",
>>     prev->pid, next->pid, prev->state);
>> }
> 
> Advantage of my method would be that ftrace (and othertracer) can use
> the same marker and doesn't need yet another hoook.

If so, I'd like to suggest below changes,

- introduce below macro in marker.h

#define DEFINE_TRACE(name, vargs, args...)	\
static inline void trace_##name vargs		\
{						\
	trace_mark(name, #vargs, ##args);	\
}

- remove __marker_check_format from __trace_mark
- and write a definition in sched_trace.h

DEFINE_TRACE(sched_switch, (struct task_struct *prev, struct task_struct *next),
	     prev, next);

Thus, we can remove fmt string and also ensure the type checking, because;
- Type checking at the trace point is done by the compiler.
- Type checking of probe handler can be done by comparing #vargs strings.

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

