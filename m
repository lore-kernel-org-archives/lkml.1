Return-Path: <linux-kernel-owner+w=401wt.eu-S1764841AbXGPXD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764841AbXGPXD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXGPXDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:03:17 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:41450 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266AbXGPXDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:03:16 -0400
Date: Mon, 16 Jul 2007 19:03:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux@bohmer.net, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: LTTng for 2.6.22.1-rt4
Message-ID: <20070716230313.GA8358@Krystal>
References: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <3efb10970707161246se06ab22i32872cfe6fa4f2f6@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:40:55 up 9 days, 12:46,  2 users,  load average: 0.50, 0.65, 0.53
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Remy Bohmer (l.pinguin@gmail.com) wrote:
> Hello,
> 
> I am looking for some tool/kernel machanism that enables me to track
> every schedule change on the CFS scheduler of the RT-kernel for some
> period of time.
> Thus a tool that gives me an overview after some time which task got
> "scheduled in/out" at "which timestamp" and at "which CPU". ( I need
> the raw data)
> 
> In a far past (on Montavista kernels) I used LTT for this to log for
> some time with only the SCHED_CHANGE filter and text output. But, I
> cannot find any LTT(ng) support for any RT-kernel, and support for the
> new CFS (like in 2.6.22.1-rt4) is even harder.
> 
> So I was wondering if anybody knows some tool/kernel mechanism which
> can do this?
> If not, I will build a kernel extension for it myself (new extension
> to 'latency_trace' ?)
> In that case can anybody with in depth CFS scheduler knowledge please
> point me which hooks are safe to use for this?

Hi Remy,

Due to popular demand, I just ported LTTng 0.9.10 to 2.6.22.1-rt4. It
may deserve some more testing, but it runs fine on my x86_32. Please
note that I ported my last stable LTTng version, so some code is not as
shiny as the new one (work in progress), but it works. Please refer to
http://ltt.polymtl.ca, mostly the QUICKSTART GUIDE and the compatibility
list.

On X86, everything should work fine. Just make sure that your
architecture has a stable and coherent TSC across CPUs. See
ltt/ltt-test-tsc.c (it printk a message at boot time) to see if yours is
ok. See my documentation on my website on how to tweak different
Intel/AMD if needed.

For your ARM needs, you may have to tweak include/asm-arm/ltt.h so it
reads a time base register (or the equivalent). Right now, it defaults
to use a logical clock, which is clearly not what you need.

I guess you'll want to disable the "userspace tracing", since I did not
port ltt-usertrace, so it's not very userful then, and also disable the
"locking instrumentation", which generates a _lot_ of output.

I know Thomas and Steven were also interested in this port.

Direct link to the patches:
http://ltt.polymtl.ca/lttng/patch-2.6.22.1-rt4-lttng-0.9.10.tar.gz

Mathieu

P.S. : To give you an idea of the output: (you know the CPU id with
processes_1 or processes_0)

./lttv -m textDump -e "event.name=sched_schedule" -t /tmp/trace2
(System at 250HZ with PREEMPT_RT)

A little legend:

group.event          : time since boot, in s.ns (tracefile name, ending
with cpu ID), Thread ID ("pid"), Thread group ID (posix pid), process
name, thread name (need userspace instrumentation), Parent PID,
Userspace function (need userspace instrumentation), execution mode
(SYSCALL/USERMODE/TRAP/IRQ...) { event specific data }

The event specific (raw) data for sched_schedule is:
PID out
PID in
previous state : State of the process we are scheduling out : -1
                 unrunnable, 0 runnable, >0 stopped

-----------------------------------------------------------------------------------------------------------------------------------------------
kernel.sched_schedule: 228.034115347 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.034152186 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 } 
kernel.sched_schedule: 228.034158271 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 } 
kernel.sched_schedule: 228.034195970 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.034286860 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.034323741 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.034329641 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.034431602 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.034522657 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.034560416 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.034566830 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.034603585 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.034694824 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.034732186 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.034738403 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.034844221 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.034934946 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.034971955 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.034978030 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.035015261 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.035106149 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.035143190 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.035149302 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.035257005 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.035347665 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.035384087 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.035390224 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.035427396 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.035517226 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.035554700 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }
kernel.sched_schedule: 228.035560842 (/tmp/trace2/control/processes_1), 0, 0, swapper, UNBRANDED, 0, 0x0, SYSCALL { 3517, 0, 2 }
kernel.sched_schedule: 228.035669682 (/tmp/trace2/control/processes_1), 3517, 3517, openbox, UNBRANDED, 3506, 0x0, SYSCALL { 0, 3517, 0 }


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
