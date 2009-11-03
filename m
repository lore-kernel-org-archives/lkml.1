Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbZKCSNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbZKCSNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZKCSNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:13:24 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52728 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbZKCSNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:13:23 -0500
Message-ID: <4AF0725C.1050106@monstr.eu>
Date: Tue, 03 Nov 2009 19:11:40 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Steven Rostedt <srostedt@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>
Subject: Re: Ftrace for Microblaze - notrace
References: <4AF030EE.7050609@monstr.eu>	 <1257266154.31359.14.camel@localhost.localdomain>	 <4AF05E0C.5090305@monstr.eu> <1257269575.26028.3355.camel@gandalf.stny.rr.com>
In-Reply-To: <1257269575.26028.3355.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 2009-11-03 at 17:45 +0100, Michal Simek wrote:
>> Steven Rostedt wrote:
> 
>>>> The next thing is about annotation notrace. I look at all arch. Is there 
>>>> any algorithm which function should use it? I think that this could be a 
>>>>   reason why I my kernel freeze when enable function tracer.
>>>>
>>>> I tested to add -pg flag for process.c file and after it kernel freeze 
>>>> too. Is it mean that problem could be there?
>>> Probably.
>> Is there any manual or instruction which functions are dangerous and 
>> especially why?
> 
> No there's no manual. It varies from arch to arch. Hmm, maybe I'll
> update the current doc to have some of the issues that come with it.
> (more info farther down)

yes, will be helpful - anyway I found missing references to 
ftrace-implementation.txt

kernel/trace/Kconfig:15:          See 
Documentation/trace/ftrace-implementation.txt
kernel/trace/Kconfig:20:          See 
Documentation/trace/ftrace-implementation.txt
kernel/trace/Kconfig:25:          See 
Documentation/trace/ftrace-implementation.txt
kernel/trace/Kconfig:37:          See 
Documentation/trace/ftrace-implementation.txt
kernel/trace/Kconfig:42:          See 
Documentation/trace/ftrace-implementation.txt
kernel/trace/Kconfig:47:          See 
Documentation/trace/ftrace-implementation.txt
kernel/trace/Kconfig:55:          See 
Documentation/trace/ftrace-implementation.txt

> 
>>> And that will keep the process.c from being compiled with it. There may
>>> be other files in the arch that should not have it. There's several in
>>> x86 and in PowerPC.
>> Do you know why they exclude it?
> 
> I did the ports for x86 and PowerPC so I guess I'm the best to answer
> this ;-)

I hope so.

> 
> In arch/x86 we have these removing -pg:
> 
> tsc.o, rtc.o - Do not trace clock output. The tracer itself uses it.
> Even though it protects against recursion, it is a big overhead to trace
> something within the tracer.
> 
> paravirt-spinlocks.o - paravirt does crazy things with locks and such,
> but overwriting text. Don't add mcount to them and overwrite the text
> with the ftrace facility.
> 
> ftrace.o - well duh ;-)
> 
> early_printk.o - This is mostly used for debugging, don't trace it.
> 
> cpu/common.o - This is used in early stages of boot up of secordary
> CPUs. As well as used in hot plug. Simply using something like
> smp_processor_id() can crash the kernel here. The tracer code uses that,
> so don't trace it.
> 
> Xen has a bunch that they added, and I think that's also because they do
> funny things too.
> 
> 
> For powerpc, we have:
> 
> cputable.o, prom_init.o, btext.o and prom.o that are all very sensitive
> with boot up code. Simply calling mcount here can crash the system. But
> this prevents boot up. It does not lock up the kernel when we enable
> function tracing.
> 
> ftrace.o - again, this should be obvious.
> 
> time.o - this is the same reason we don't trace tsc and rtc in x86.

ok In general - all timing functions and function which are related with 
startup code - called only once before turning on irqs - there are a lot 
of functions. I understand that make no sense to trace that files. And 
plus all debugging functions.  And function which uses locks.
Anything else?


> 
>> Can I use any special debug features? I mean I look at kernel.h and 
>> there are some trace_printk function - but they don't work for me. Is it 
>> possible to use them or not?
> 
> Should work. That's not arch dependent. But you need to have some ftrace
> enabled. Enable CONFIG_CONTEXT_SWITCH_TRACER, and trace_printk should
> work. That writes to the ring buffer and you can see the output
> in /debug/tracing/trace.

It could be nice features but in case that you have command line and you 
can read that trace debug output. I mean any printk messages - which not 
contain any trace facility - just pure printk to console. Are that 
messages written to any place which could be read from debuger? Like log 
buffer? Is there any place for them?

The second things is that I haven't implemented save_stack_trace 
function - it is just while(1) loop. My kernel not jumps to this 
function that's why I am not interested to implement it. Am I right that 
  ftrace code don't use it? Or the standard behavior is that ftrace code 
use this function and really care about. Does your kernel use that function?

 From my test I don't understand MCOUNT_INSN_SIZE - and which function 
doesn't care about. There is this line of pseudocode in your doc
(unsigned long selfpc = <return address> - MCOUNT_INSN_SIZE;) but what 
the reason is to do that. If I understand correct selfpc and frompc just 
give addresses which functions called that mcount and has impact to log.
I mean that if that address is not proper begin of function is found 
(not sure if the code do it or not) function name (and function) which 
contain that address. Or is there any special reason why to substract 
that MCOUNT_INSN_SIZE - for timing or anything like that?

I simple just not find any reason for it. And I believe that don't have 
connection with my problem.

Thanks,
Michal


> 
> -- Steve
> 
> 

