Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZDPBGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZDPBGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZDPBGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:06:11 -0400
Received: from gw.goop.org ([64.81.55.164]:42591 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbZDPBGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:06:10 -0400
Message-ID: <49E6847B.9000003@goop.org>
Date: Wed, 15 Apr 2009 18:06:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with CREATE_TRACE_POINTS and recursion safety
References: <49E67D1D.8020704@goop.org> <alpine.DEB.2.00.0904152042350.4459@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904152042350.4459@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, 15 Apr 2009, Jeremy Fitzhardinge wrote:
>
>   
>> I'm having a problem with CREATE_TRACE_POINTS being too indiscriminate.  The
>> trouble is that it not only creates tracepoint definitions for the intended
>> tracepoints, but any other tracepoint definitions which get included
>> incidentally.
>>
>> For example, I'm seeing my paravirt tracepoints being instantiated in both
>> kernel/sched.o and kernel/irq/manage.o as side-effects of the scheduler and
>> irq tracepoints being instantiated.
>>
>> I'm experimenting with a different scheme, wherein a subsystem defines
>> CREATE_FOO_TRACE_POINTS in the .c file where it wants to instantiate the
>> tracepoints - rather than CREATE_TRACE_POINTS - and its trace/events/foo.h
>> does:
>>
>>    #ifdef CREATE_FOO_TRACE_POINTS
>>    #undef CREATE_FOO_TRACE_POINTS	/* avoid infinite recursion */
>>    #include <trace/instantiate_trace.h>
>>    #else
>>    #include <trace/define_trace.h>
>>    #endif
>>
>> where instantiate_trace.h is:
>>
>>    #define CREATE_TRACE_POINTS
>>    #include <trace/define_trace.h>
>>    #undef CREATE_TRACE_POINTS
>>
>> (Just to prevent a bit more repeated boilerplate in each events definition
>> file.)
>>
>> This seems to work.  (Update: no it doesn't.  WTF has paravirt-trace.o got
>> duplicate kmem tracepoints?!)
>>     
>
> kmem was a PITA.  Looks like we might need to do a:
>
> #ifdef CREATE_FOO_TRACE_POINTS
> #include <trace/define_trace.h>
> #endif
>   

The sched and irq tracepoints have the same general problem.

> type of thing, and have each user define their own CREATE_FOO_TRACE_POINTS 
> that they want to instantiate. This should be a requirement on any 
> trace point header that is used in other headers.
>
> Does just adding the above to the kmem.h header and your header fix it for 
> you?
>   

No, I have a complete patch to do what I'm proposing here, and kmem went 
ahead and failed anyway.  I'll post a cleaned up set of RFC patches and 
try to track down what's happening later.

And there seems to be a secondary problem with kmem tracepoints being 
called without an explicit #include of <trace/events/kmem.h>, so I'm 
seeing compiler errors relating to that too:

  CC      arch/x86/kernel/paravirt-trace.o
In file included from /home/jeremy/git/linux/include/linux/slab.h:165,
                 from /home/jeremy/git/linux/include/linux/percpu.h:6,
                 from /home/jeremy/git/linux/include/linux/vmstat.h:6,
                 from /home/jeremy/git/linux/include/linux/mm.h:596,
                 from /home/jeremy/git/linux/include/linux/ring_buffer.h:6,
                 from /home/jeremy/git/linux/include/linux/ftrace_event.h:6,
                 from /home/jeremy/git/linux/include/trace/ftrace.h:20,
                 from /home/jeremy/git/linux/include/trace/define_trace.h:64,
                 from /home/jeremy/git/linux/include/trace/instantiate_trace.h:7,
                 from /home/jeremy/git/linux/include/trace/events/pvops.h:1186,
                 from /home/jeremy/git/linux/arch/x86/kernel/paravirt-trace.c:5:
/home/jeremy/git/linux/include/linux/slab_def.h: In function 'kmalloc':
/home/jeremy/git/linux/include/linux/slab_def.h:157: error: implicit declaration of function 'trace_kmalloc'


Also, the pvops trace stuff adds quite a lot of overhead to the kernel 
size - and probably runtime - so I think we'll need to have Kconfig 
switches for each set of trace events rather than a single fat 
CONFIG_TRACEPOINTS switch.

    J
