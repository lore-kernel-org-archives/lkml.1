Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZKIIMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZKIIMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbZKIIMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:12:33 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48244 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbZKIIMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:12:32 -0500
Message-ID: <4AF7CE83.4020004@monstr.eu>
Date: Mon, 09 Nov 2009 09:10:43 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, John Williams <john.williams@petalogix.com>,
       wuzhangjin@gmail.com
Subject: Re: ftrace - graph tracer for Microblaze
References: <4AF40282.9080402@monstr.eu> <1257522851.31359.40.camel@localhost.localdomain>
In-Reply-To: <1257522851.31359.40.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 2009-11-06 at 12:03 +0100, Michal Simek wrote:
>> Hi Steven,
>>

>> I am getting some problem is irqsoff tracing. Is there any special 
>> things which needs to be implemented/changed?
> 
> It is dependent on TRACE_IRQFLAGS_SUPPORT, which is kind of nasty. This
> is what LOCKDEP uses. If you can successfully implement LOCKDEP you get
> irqsoff tracing for free.

That's crucial information. Would it be possible to add this dependency 
to trace/Kconfig?

> 
> The biggest issue with lockdep implementation is that you need to have a
> hook at every irq disable and enable location. This includes assembly.
> That's what all those TRACE_IRQS_OFF and TRACE_IRQS_ON are in x86's
> entry_*.S.

I have there some issues - I am debugging it.

> 
> 
>> I would like to implement ftrace graph support and stack save support.
>>
>> I believe that for stack_trace I need just to implement save_stack_trace.
>> If I understand correctly that feature should look at current process
>> and trace that process back to zero stack size.
>> It is just for current task right?
> 
> Yes, just current task is needed.
> 
>> Then output shows which functions are called and size of stack. I found 
>> your post which is at http://lkml.org/lkml/2009/8/21/319 but you don't 
>> have any zero size stack size. Here is my log which seems to me weird 
>> because of zero size values. Is it correct or not?
>>
>> # echo 1 > /proc/sys/kernel/stack_tracer_enabled
>> # cat /debug/tracing/stack_trace
>>          Depth    Size   Location    (63 entries)
>>          -----    ----   --------
>>    0)     2100       0   stack_trace_call+0x12c/0x1d8
>>    1)     2100       0   stack_trace_call+0x12c/0x1d8
>>    2)     2100       0   _spin_unlock+0x2c/0x3c
>>    3)     2100     180   __rcu_process_callbacks+0x3e0/0x460
>>    4)     1920     568   end_graph_tracer+0x24/0x2c
>>    5)     1352       0   end_graph_tracer+0x24/0x2c
>>    6)     1352       0   microblaze_read+0x14/0x4c
>>    7)     1352     184   microblaze_read+0x0/0x4c
>> ...
>>   63)      156     156   ktime_add_ns+0x88/0x124
>>
>> Here is my function -> it is the same as we use for dump stack.
>> I look at mips implementation and is the same
>>
>> void save_stack_trace(struct stack_trace *trace)
>> {
>> 	unsigned int sp;
>> 	asm("addik %0, r1, 0" : "=r" (sp));
>>
>> 	while (!kstack_end(sp)) {
>> 		addr = *sp++;
>> 		if (__kernel_text_address(addr)) {
> 
> Hmm, this does not look too reliable. That is, anytime there's a text
> address in the code you report it, although it may not be a real return
> address.
> 
> Does Microblaze have any kind of frame pointer? Or a way to detect the
> next frame? If so, that would be really helpful here.
> 
>> 			if (trace->skip > 0)
>> 				trace->skip--;
>> 			else
>> 			   trace->entries[trace->nr_entries++] = addr;
>>
>> 			if (trace->nr_entries >= trace->max_entries)
>> 				break;
>> 		}
>> 	}
>> }
> 
> The stack tracer is very simple. If you look at the check_stack code in
> kernel/trace/trace_stack.c it shows the implementation.
> 
> Basically what it does is to look at the address local variable in the
> function itself (this_size). It masks it with THREAD_SIZE-1 to get the
> top of the stack.
> 
> It then starts up the stack looking at the contents to match the
> contents of the report from save_stack_trace(). If it finds a return
> value, it reports the address off of that. If it does not find that
> return value, you will see zero. This is strange since it should have
> found all those that were reported. But perhaps those values were in the
> stack when calling the save_stack_trace function, but not at the level
> of check_stack's stack.
> 

will look.

...


> 
>>
>>
>> This is third topic - maybe I should send three separate emails :-(
>>
>> I found some incompatibility which IMHO could be synchronize.
>> There is C implementation for ftrace_graph_entry_stub and ftrace_stub
>> is implemented in asm. The purpose of that two functions should be the 
>> same that's I think implementation should be too.
> 
> The two take different arguments. Sure the stubs don't care, but it this
> topic came up in the design. We found issues (I don't remember exactly
> what they were) by having the two the same. That was the original
> design.

ok.

> 
>> Because of my unresolved issue around irqsoff I traced it in code and 
>> there is too many tracing_reset_online_cpus() functions. I found one 
>> calling in __irqsoff_tracer_init and then in tracer_init function. Is 
>> that correct or one calling is enough?
> 
> Hmm, It may be enough to call it just in tracer_init, but it does seem
> that irqsoff tracer wants it reset it again after it zeros out the
> numbers. I'll look into that. But it should not affect anything, since
> this is only at startup of the tracer.

ok

> 
>> Then I think that there is some things in Kconfig which should be 
>> cleared. I found link to /sys/kernel/debug/tracing/profile_branch which 
>> I don't have in tracing folder. Is it correct?
> 
> You enabled TRACE_BRANCH_PROFILING and you don't have that?

maybe it is related with registration.

microblaze_timer_set_mode: oneshot
Warning: could not register all branches stats
Warning: could not register annotated branches stats
msgmni has been set to 488
84000000.serial: ttyUL0 at MMIO 0x84000003 (irq = 8) is a uartlite
console [ttyUL0] enabled
...

uclinux login: root
Password:
login[45]: root login on 'ttyUL0'
# cd ; mkdir /debug; mount -t debugfs none /debug; cat 
/debug/tracing/available_tracers
function_graph function sched_switch nop
# ls /debug/tracing/
README             options            trace              tracing_cpumask
available_events   per_cpu            trace_clock        tracing_enabled
available_tracers  printk_formats     trace_marker       tracing_on
buffer_size_kb     saved_cmdlines     trace_options
current_tracer     set_event          trace_pipe
events             set_ftrace_pid     trace_stat
#
#
# gunzip < /proc/config.gz | grep BRANCH
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
#

Thanks,
Michal


> 
> -- Steve
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
