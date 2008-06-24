Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbYFXDLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbYFXDLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 23:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYFXDLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 23:11:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbYFXDLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 23:11:08 -0400
Message-ID: <48606553.8070503@redhat.com>
Date: Mon, 23 Jun 2008 23:09:07 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
Subject: Re: [RFC] Tracepoint proposal
References: <485BE2C6.1080901@redhat.com> <20080620174529.GB10943@Krystal> <1213992446.3223.195.camel@lappy.programming.kicks-ass.net> <20080622171135.GA19432@Krystal>
In-Reply-To: <20080622171135.GA19432@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Mathieu Desnoyers wrote:
> 
> Hi Peter,
> 
> I've tried to read through the comments recently posted to this thread
> (sorry I don't have time to answer them all specifically right now, a
> lot of this makes a lot of sense). I've tried to come up with a
> proposal, let's name it "tracepoint", which should hopefully address the
> full scope of the problem. Please tell me if it makes sense. It should
> allow compile-time verification of dynamically linked-in and activated
> tracepoints. I'll work on an implementation ASAP.
> 
> Mathieu
> 
> Tracepoint proposal
> 
> - Tracepoint infrastructure
>   - In-kernel users
>   - Complete typing, verified by the compiler
>   - Dynamically linked and activated
> 
> - Marker infrastructure
>   - Exported API to userland
>   - Basic types only
> 
> - Dynamic vs static
>   - In-kernel probes are dynamically linked, dynamically activated, connected to
>     tracepoints. Type verification is done at compile-time. Those in-kernel
>     probes can be a probe extracting the information to put in a marker or a
>     specific in-kernel tracer such as ftrace.
>   - Information sinks (LTTng, SystemTAP) are dynamically connected to the
>     markers inserted in the probes and are dynamically activated.
> 
> - Near instrumentation site vs in a separate tracer module
> 
> A probe module, only if provided with the kernel tree, could connect to internal
> tracing sites. This argues for keeping the tracepoing probes near the
> instrumentation site code. However, if a tracer is general purpose and exports
> typing information to userspace through some mechanism, it should only export
> the "basic type" information and could be therefore shipped outside of the
> kernel tree.
> 
> In-kernel probes should be integrated to the kernel tree. They would be close to
> the instrumented kernel code and would translate between the in-kernel
> instrumentation and the "basic type" exports. Other in-kernel probes could
> provide a different output (statistics available through debugfs for instance).
> ftrace falls into this category.
> 
> Generic or specialized information "sinks" (LTTng, systemtap) could be connected
> to the markers put in tracepoint probes to extract the information to userspace.
> They would extract both typing information and the per-tracepoint execution
> information to userspace.

Your idea is good to me. I just worry about complexity.
if both tracepoint and marker add information to other sections,
both two functions cover each partially. Anyway, it depends
on implementation.:-)

> Therefore, the code would look like :
> 
> kernel/sched.c:
> 
> #include "sched-trace.h"
> 
> schedule()
> {
>   ...
>   trace_sched_switch(prev, next);
>   ...
> }
> 
> 
> kernel/sched-trace.h:
> 
> DEFINE_TRACE(sched_switch, struct task_struct *prev, struct task_struct *next);
> 
> 
> kernel/sched-trace.c:
> 
> #include "sched-trace.h"
> 
> static probe_sched_switch(struct task_struct *prev, struct task_struct
>   *next)
> {
>   trace_mark(kernel_sched_switch, "prev_pid %d next_pid %d prev_state %ld",
>     prev->pid, next->pid, prev->state);
> }
> 
> int __init init(void)
> {
>   return register_sched_switch(probe_sched_switch);
> }
> 
> void __exit exit(void)
> {
>   unregister_sched_switch(probe_sched_switch);
> }
> 
> 
> Where DEFINE_TRACE internals declare a structure, a trace_* inline function,
> a register_trace_* and unregister_trace_* inline functions :

Hmm, if so, DEFINE_TRACE() still needs next and prev.:-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


