Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbZDWWFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbZDWWFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760585AbZDWWFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:05:25 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:61742 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760520AbZDWWFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:05:23 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Apr 2009 18:05:22 EDT
X-BigFish: VPS-24(zz1432R98dR1805M197bizz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <49F0E284.2080104@am.sony.com>
Date: Thu, 23 Apr 2009 14:49:56 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIO+/vQ==?= <u.kleine-koenig@pengutronix.de>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King <rmk@arm.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Add function graph tracer support for ARM
References: <49F0AEA2.5010309@am.sony.com> <20090423183905.GA8383@pengutronix.de>
In-Reply-To: <20090423183905.GA8383@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 23 Apr 2009 21:49:57.0335 (UTC) FILETIME=[7194CE70:01C9C45D]
X-SEL-encryption-scan: scanned
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe � wrote:
>> Signed-off-by: <tim.bird@am.sony.com>
> According to Documentation/SubmittingPatches you need to provide your
> real name in the S-o-b line.

OK -that's embarrassing - I'll fix this.
scripts/checkpatch.pl didn't catch this.  I may look at adding
something to checkpatch.pl to catch empty names.

> For the lazy of us, can you point me^Uus to some documentation how to
> use the graph tracer?

It looks like Documentation/ftrace.txt is missing anything about
function graph tracing.

Should I add a section?

Here are some quick steps:

$ mount -t debugfs none /debug
$ cd /debug/tracing/
$ cat available_tracers
function_graph function sched_switch nop
$ echo function_graph >current_tracer
$ cat trace
# tracer: function_graph
#
# CPU OVERHEAD/DURATION            FUNCTION CALLS
# |   |        |                   |   |   |   |
 ------------------------------------------
 0)      --1       =>   events/-5
 ------------------------------------------

 0)               |                activate_task() {
 0)               |                  enqueue_task() {
 0)               |                    enqueue_task_fair() {
 0)               |                      update_curr() {
 0)   0.000 us    |                        calc_delta_mine();
 0)   0.000 us    |                        update_min_vruntime();
 0) + 61.035 us   |                      }
 0)   0.000 us    |                      place_entity();
 0)   0.000 us    |                      __enqueue_entity();
 0) + 91.552 us   |                    }
 0) ! 122.070 us  |                  }
 0) ! 152.588 us  |                }
 0)               |                check_preempt_wakeup() {
 0)   0.000 us    |                  update_curr();
 0)   0.000 us    |                  wakeup_preempt_entity();
 0) + 61.035 us   |                }
...

Clearly, my clock stinks, but that's a separate issue.

>>...
>> +extern void return_to_handler(void);
> AFAIK extern doesn't change anything for function declarations.  I
> wouldn't write it myself, and not argue if you considered it
> important/correct/whatever.

It just feels a bit more natural to me. My mind reads it as
'this function is not in this file, go look elsewhere'.
You're right that it doesn't change anything.
If this is preferred, I have no problem removing it.

...
>> --- a/arch/arm/kernel/Makefile
>> +++ b/arch/arm/kernel/Makefile
>> @@ -4,7 +4,7 @@
>>
>>  AFLAGS_head.o := -DTEXT_OFFSET=$(TEXT_OFFSET)
>>
>> -ifdef CONFIG_DYNAMIC_FTRACE
>> +ifdef CONFIG_FUNCTION_TRACER
>>  CFLAGS_REMOVE_ftrace.o = -pg
>>  endif
> Why not simply remove the ifdef?  CFLAGS_REMOVE_ftrace.o shouldn't hurt
> if ftrace.o isn't compiled.

Good point.  I'll check this in the latest code, and remove
the #ifdef if it's still there.  I can't imagine
any circumstances when you'd want to trace any of
the routines in ftrace.c


>> @@ -23,6 +23,7 @@ obj-$(CONFIG_ISA_DMA)		+= dma-isa.o
>>  obj-$(CONFIG_PCI)		+= bios32.o isa.o
>>  obj-$(CONFIG_SMP)		+= smp.o
>>  obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
>> +obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
> I there a reason that CONFIG_DYNAMIC_FTRACE and
> CONFIG_FUNCTION_GRAPH_TRACER share the same source file?
ftrace.c has stuff from both, so you want it "turned on"
if one or the other (or both) are configed on.

I'll look at whether it makes sense to split these two into
separate files.  This issue may be resolved by the code
movement that Frederic Weisbecker mentioned in his e-mail.


>> --- a/arch/arm/kernel/entry-common.S
>> +++ b/arch/arm/kernel/entry-common.S
>> @@ -135,8 +135,16 @@ ENTRY(mcount)
>>  	adr r0, ftrace_stub
>>  	cmp r0, r2
>>  	bne trace
>> +
>> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> +	ldr r1, =ftrace_graph_return
>> +	ldr r2, [r1]
>> +	cmp r0, r2		@ if *ftrace_graph_return != ftrace_stub
>> +	bne ftrace_graph_caller
>> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
>> +
>>  	ldr lr, [fp, #-4]			@ restore lr
>> -	ldmia sp!, {r0-r3, pc}
>> +	ldmia sp!, {r0-r3, pc}			@ return doing nothing
> If ftrace_trace_function != ftrace_stub then ftrace_graph_caller isn't
> called.  Is this correct?
My comment is possibly misleading here.  The sense of the
'!=' includes the 'n' portion of the 'bne' on the following line.
So the logic is:
if *ftrace_graph_return != ftrace stub, branch to ftrace_graph_caller
or in other words
if *ftrace_graph_return == ftrace_stub, return doing nothing

Maybe I should just remove the comment and let the code
speak for itself?  (or maybe move the comment down one line?)

...
>> +/* Add a function return address to the trace stack on thread info.*/
> nitpick: add a space between "." and "*/" please.

OK - nitpicks appreciated as well :-)

>> --- a/arch/arm/kernel/vmlinux.lds.S
>> +++ b/arch/arm/kernel/vmlinux.lds.S
>> @@ -95,6 +95,7 @@ SECTIONS
>>  			SCHED_TEXT
>>  			LOCK_TEXT
>>  			KPROBES_TEXT
>> +			IRQENTRY_TEXT
>>  #ifdef CONFIG_MMU
>>  			*(.fixup)
>>  #endif
> Is this only needed for graph tracer?  If not this should be broken out.

As far as I can tell, yes.
This evaporates into nothing if the graph tracer is not present.

Thanks very much for the feedback!  I'll try to update the patch
based on your and Frederic Weisbecker's feedback shortly.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

