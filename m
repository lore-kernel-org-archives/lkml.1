Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYFVRLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYFVRLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 13:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYFVRLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 13:11:40 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:48550 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbYFVRLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 13:11:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQEAMUgXkhMQW1O/2dsb2JhbACBW6tu
Date: Sun, 22 Jun 2008 13:11:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>
Subject: [RFC] Tracepoint proposal
Message-ID: <20080622171135.GA19432@Krystal>
References: <485BE2C6.1080901@redhat.com> <20080620174529.GB10943@Krystal> <1213992446.3223.195.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1213992446.3223.195.camel@lappy.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:52:26 up 17 days, 21:33,  3 users,  load average: 0.33, 0.34,
	0.34
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2008-06-20 at 13:45 -0400, Mathieu Desnoyers wrote:
> 
> > All this work look good, thanks Masami! Sorry I did not find time to do
> > it lately, I've been busy on other things. A small question though :
> > since LTTng is configurable both as an external module or as an
> > in-kernel tracer, I wonder if it would really hurt to add the format
> > strings to DEFINE_TRACE, e.g. :
> > 
> > DEFINE_TRACE(name, prototype, format_string, args...)
> > 
> > which would give :
> > 
> > DEFINE_TRACE(irq_entry, (int irq_id, int kernel_mode), "%d %d",
> >     irq_id, kernel_mode);
> > 
> > DEFINE_TRACE(irq_exit, (void), MARK_NOARGS);
> > 
> > and calling this in the kernel code :
> > 
> > trace_irq_entry(irq, (regs)?(!user_mode(regs)):(1));
> > ...
> > trace_irq_exit();
> > 
> > and for quick-and-dirty debug usage, one would add this to kernel code :
> > 
> > trace_mark(subsystem_event, "(int arg, struct task_struct *task)",
> >  "%d %p", arg, current);
> 
> How would this work for:
> 
> DEFINE_TRACE(sched_switch, (struct task_struct *prev, struct task_struct *next), prev, next);
> 
> You'd want a string like: "%d %d", prev->pid, next->pid
> not: "%p %p", prev, next
> 
> perhaps we can do something like:
> 
> DEFINE_TRACER(sched_switch, (struct task_struct *prev, struct task_struct *next), prev, next,
> 		"%d %d", prev->pid, next->pid);
> 
> that defines a default tracer function for the previously defined trace
> point. That way its optional, and allows for generic trace points.
> 
> Of course, all this could be ruined by reality - C really sucks wrt
> forwarding functions.. :-/
> 

Hi Peter,

I've tried to read through the comments recently posted to this thread
(sorry I don't have time to answer them all specifically right now, a
lot of this makes a lot of sense). I've tried to come up with a
proposal, let's name it "tracepoint", which should hopefully address the
full scope of the problem. Please tell me if it makes sense. It should
allow compile-time verification of dynamically linked-in and activated
tracepoints. I'll work on an implementation ASAP.

Mathieu

Tracepoint proposal

- Tracepoint infrastructure
  - In-kernel users
  - Complete typing, verified by the compiler
  - Dynamically linked and activated

- Marker infrastructure
  - Exported API to userland
  - Basic types only

- Dynamic vs static
  - In-kernel probes are dynamically linked, dynamically activated, connected to
    tracepoints. Type verification is done at compile-time. Those in-kernel
    probes can be a probe extracting the information to put in a marker or a
    specific in-kernel tracer such as ftrace.
  - Information sinks (LTTng, SystemTAP) are dynamically connected to the
    markers inserted in the probes and are dynamically activated.

- Near instrumentation site vs in a separate tracer module

A probe module, only if provided with the kernel tree, could connect to internal
tracing sites. This argues for keeping the tracepoing probes near the
instrumentation site code. However, if a tracer is general purpose and exports
typing information to userspace through some mechanism, it should only export
the "basic type" information and could be therefore shipped outside of the
kernel tree.

In-kernel probes should be integrated to the kernel tree. They would be close to
the instrumented kernel code and would translate between the in-kernel
instrumentation and the "basic type" exports. Other in-kernel probes could
provide a different output (statistics available through debugfs for instance).
ftrace falls into this category.

Generic or specialized information "sinks" (LTTng, systemtap) could be connected
to the markers put in tracepoint probes to extract the information to userspace.
They would extract both typing information and the per-tracepoint execution
information to userspace.

Therefore, the code would look like :

kernel/sched.c:

#include "sched-trace.h"

schedule()
{
  ...
  trace_sched_switch(prev, next);
  ...
}


kernel/sched-trace.h:

DEFINE_TRACE(sched_switch, struct task_struct *prev, struct task_struct *next);


kernel/sched-trace.c:

#include "sched-trace.h"

static probe_sched_switch(struct task_struct *prev, struct task_struct
  *next)
{
  trace_mark(kernel_sched_switch, "prev_pid %d next_pid %d prev_state %ld",
    prev->pid, next->pid, prev->state);
}

int __init init(void)
{
  return register_sched_switch(probe_sched_switch);
}

void __exit exit(void)
{
  unregister_sched_switch(probe_sched_switch);
}


Where DEFINE_TRACE internals declare a structure, a trace_* inline function,
a register_trace_* and unregister_trace_* inline functions :

static instrumentation site structure, containing function pointers to
deactivated functions and activation boolean. It also contains the
"sched_switch" string. This structure is placed in a special section to create
an array of these structures.

static inline void trace_sched_switch(struct task_struct *prev,
  struct task_struct *next)
{
 if (sched_switch tracing is activated)
   marshall_probes(&instrumentation_site_structure, prev, next);
}

static inline int register_trace_sched_switch(
  void (*probe)(struct task_struct *prev, struct task_struct *next)
{
  return do_register_probe("sched_switch", (void *)probe);
}

static inline void unregister_trace_sched_switch(
  void (*probe)(struct task_struct *prev, struct task_struct *next)
{
  do_unregister_probe("sched_switch", (void *)probe);
}


We need a a new kernel probe API :

do_register_probe / do_unregister_probe
  - Connects the in-kernel probe to the site
  - Activates the site tracing (probe reference counting)


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
