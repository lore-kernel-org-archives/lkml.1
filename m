Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbZKFQta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbZKFQta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 11:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759472AbZKFQt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 11:49:29 -0500
Received: from cpe-74-67-89-75.stny.res.rr.com ([74.67.89.75]:38805 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759471AbZKFQt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 11:49:29 -0500
X-Greylist: delayed 3192 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Nov 2009 11:49:28 EST
Subject: Re: ftrace - graph tracer for Microblaze
From: Steven Rostedt <rostedt@goodmis.org>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, John Williams <john.williams@petalogix.com>
In-Reply-To: <4AF40282.9080402@monstr.eu>
References: <4AF40282.9080402@monstr.eu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 06 Nov 2009 10:54:11 -0500
Message-Id: <1257522851.31359.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 12:03 +0100, Michal Simek wrote:
> Hi Steven,
> 
> I found the problem in my mcount function. I was Microblaze dependent 
> fault - I had to save all registers which are not saved across function 
> calls.

Yep, that could be an issue.

> 
> I am getting some problem is irqsoff tracing. Is there any special 
> things which needs to be implemented/changed?

It is dependent on TRACE_IRQFLAGS_SUPPORT, which is kind of nasty. This
is what LOCKDEP uses. If you can successfully implement LOCKDEP you get
irqsoff tracing for free.

The biggest issue with lockdep implementation is that you need to have a
hook at every irq disable and enable location. This includes assembly.
That's what all those TRACE_IRQS_OFF and TRACE_IRQS_ON are in x86's
entry_*.S.


> 
> I would like to implement ftrace graph support and stack save support.
> 
> I believe that for stack_trace I need just to implement save_stack_trace.
> If I understand correctly that feature should look at current process
> and trace that process back to zero stack size.
> It is just for current task right?

Yes, just current task is needed.

> 
> Then output shows which functions are called and size of stack. I found 
> your post which is at http://lkml.org/lkml/2009/8/21/319 but you don't 
> have any zero size stack size. Here is my log which seems to me weird 
> because of zero size values. Is it correct or not?
> 
> # echo 1 > /proc/sys/kernel/stack_tracer_enabled
> # cat /debug/tracing/stack_trace
>          Depth    Size   Location    (63 entries)
>          -----    ----   --------
>    0)     2100       0   stack_trace_call+0x12c/0x1d8
>    1)     2100       0   stack_trace_call+0x12c/0x1d8
>    2)     2100       0   _spin_unlock+0x2c/0x3c
>    3)     2100     180   __rcu_process_callbacks+0x3e0/0x460
>    4)     1920     568   end_graph_tracer+0x24/0x2c
>    5)     1352       0   end_graph_tracer+0x24/0x2c
>    6)     1352       0   microblaze_read+0x14/0x4c
>    7)     1352     184   microblaze_read+0x0/0x4c
> ...
>   63)      156     156   ktime_add_ns+0x88/0x124
> 
> Here is my function -> it is the same as we use for dump stack.
> I look at mips implementation and is the same
> 
> void save_stack_trace(struct stack_trace *trace)
> {
> 	unsigned int sp;
> 	asm("addik %0, r1, 0" : "=r" (sp));
> 
> 	while (!kstack_end(sp)) {
> 		addr = *sp++;
> 		if (__kernel_text_address(addr)) {

Hmm, this does not look too reliable. That is, anytime there's a text
address in the code you report it, although it may not be a real return
address.

Does Microblaze have any kind of frame pointer? Or a way to detect the
next frame? If so, that would be really helpful here.

> 			if (trace->skip > 0)
> 				trace->skip--;
> 			else
> 			   trace->entries[trace->nr_entries++] = addr;
> 
> 			if (trace->nr_entries >= trace->max_entries)
> 				break;
> 		}
> 	}
> }

The stack tracer is very simple. If you look at the check_stack code in
kernel/trace/trace_stack.c it shows the implementation.

Basically what it does is to look at the address local variable in the
function itself (this_size). It masks it with THREAD_SIZE-1 to get the
top of the stack.

It then starts up the stack looking at the contents to match the
contents of the report from save_stack_trace(). If it finds a return
value, it reports the address off of that. If it does not find that
return value, you will see zero. This is strange since it should have
found all those that were reported. But perhaps those values were in the
stack when calling the save_stack_trace function, but not at the level
of check_stack's stack.

> 
> 
> 
> The second more important is graph part
> 
> I read it in ftrace design.txt and I don't understand how this really works.
> 
> 
> For function trace without grapth support is calling
>   foo()
> (ret2foo) -> bar()
>     (ret2bar) -> mcount() - I have to save full cpu content
>                    -> ftrace_trace_function (ret2bar, ret2foo)
> 			(do some stuff)
>                    <-
>                    restore_whole_content and jump back to bar
>                    after mcount call (mb do jump +8 - mb convention)
>               bar ends -> jump back to foo
> 
> 
> For graph is flow a little bit different
>   foo()
> (ret2foo) -> bar()
>     (ret2bar) -> mcount() - I have to save full cpu content
>                      ->prepare_ftrace_return(ret2bar, ret2foo)
> 
> and here I have to change return address -> Is it mean that from 
> prepare_ftrace_return I have to return back to bar and then at the end 
> of bar jump to return_to_handler which will call 
> ftrace_return_to_handler and then jump back to foo. Is it correct?

Yes that is correct.

> What is the correct calling?

What you just stated ;-)

> 
> 
> 
> This is third topic - maybe I should send three separate emails :-(
> 
> I found some incompatibility which IMHO could be synchronize.
> There is C implementation for ftrace_graph_entry_stub and ftrace_stub
> is implemented in asm. The purpose of that two functions should be the 
> same that's I think implementation should be too.

The two take different arguments. Sure the stubs don't care, but it this
topic came up in the design. We found issues (I don't remember exactly
what they were) by having the two the same. That was the original
design.

> 
> Because of my unresolved issue around irqsoff I traced it in code and 
> there is too many tracing_reset_online_cpus() functions. I found one 
> calling in __irqsoff_tracer_init and then in tracer_init function. Is 
> that correct or one calling is enough?

Hmm, It may be enough to call it just in tracer_init, but it does seem
that irqsoff tracer wants it reset it again after it zeros out the
numbers. I'll look into that. But it should not affect anything, since
this is only at startup of the tracer.

> 
> Then I think that there is some things in Kconfig which should be 
> cleared. I found link to /sys/kernel/debug/tracing/profile_branch which 
> I don't have in tracing folder. Is it correct?

You enabled TRACE_BRANCH_PROFILING and you don't have that?

-- Steve

