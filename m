Return-Path: <linux-kernel-owner+w=401wt.eu-S1761432AbYG3OEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761432AbYG3OEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYG3OEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:04:35 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:56778 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308AbYG3OEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:04:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAOgPkEhMRKxB/2dsb2JhbACBW4lEpxw
Date: Wed, 30 Jul 2008 10:04:30 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/5] ftrace: do not trace NMI handlers
Message-ID: <20080730140430.GB18210@Krystal>
References: <20080730012939.885172468@goodmis.org> <1217402885.6364.14.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1217402885.6364.14.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:50:50 up 55 days, 18:31,  4 users,  load average: 1.23, 1.24,
	1.23
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2008-07-29 at 21:29 -0400, Steven Rostedt wrote:
> > The dynamic ftrace code modifies code text at run time. Arjan informed
> > me that there is no safe way to modify code text on an SMP system when
> > the other CPUs might execute that same code. The reason has to do with
> > pipeline caches and CPUs might do funny things if the code being pushed
> > in the pipeline also happens to be modified at that same time. (Arjan
> > correct me if I'm wrong here).
> 
> How does the immediate value stuff get around this issue?
> 

By inserting a temporary breakpoint in the code about to be replaced and
by issuing an IPI to every CPU, issuing a cpuid instruction to
synchronize the cores, before reverting the breakpoint to the first byte
of the new instruction. Therefore we are sure that any CPU which could
have seen the old instruction will flush its pipeline cache (cpuid
instruction synchronizes the core) before seeing the new instruction.
Meanwhile, the breakpoint handler executes the original instruction,
dealing with non-relocatable instructions if necessary by emulating them
(e.g. by playing with the return IP). We have some constraints to
follow: every instruction being replaced must stay a valid instruction
to the CPU, because there could be preemption in the middle of the
modified area. Immediate values does not change the size of the
instructions, so we don't run in this problem, but changing
{ 0x90, 0x90, 0x90, 0x90, 0x90 } (nops)
into
{ 0xe9, 0xXX, 0xXX, 0xXX, 0xXX } (5-bytes jump)
would be problematic because a preempted IP could point right in the
middle of those nops. As a general rule, never try to combine smaller
instructions into a bigger one, except in the case of adding a
lock-prefix to an instruction : this case insures that the non-lock
prefixed instruction is still valid after the change has been done. We
could however run into a nasty non-synchronized atomic instruction use
in SMP mode if a thread happens to be scheduled out right after the lock
prefix. Hopefully the alternative code uses the refrigerator... (hrm, it
doesn't).

All that is documentented thoroughly in arch/x86/kernel/immediate.c
comments.

Mathieu



> > We use kstop_machine to put the system into a UP like mode. This prevents
> > other CPUs from executing code while we modify it. Under stress testing
> > Ingo discovered that NMIs can cause the system to crash. This was due
> > to NMIs calling code that is being modified. Some boxes are more prone to
> > failure than others.
> > 
> > This series of patches performs two tasks:
> > 
> >  1) Add notrace to functions called by NMI, or simply remove the tracing
> >     completely from files that are primarily used by NMI.
> > 
> >  2) Add a warning when code that will be modified is called by an NMI.
> >     This also disables ftraced when it is detected, to prevent the
> >     race with the NMI and code modification from happneing.
> > 
> > The warning looks something like this:
> > 
> > --------------- cut here ---------------
> > WARNING: ftraced code called from NMI context lapic_wd_event+0xd/0x65
> >          Please report this to the ftrace maintainer.
> >          Disabling ftraced. Boot with ftrace_keep_on_nmi to not disable.
> > Pid: 0, comm: swapper Not tainted 2.6.26-tip #96
> > 
> > Call Trace:
> >  <NMI>  [<ffffffff8021c6d0>] ? lapic_wd_event+0xd/0x65
> >  [<ffffffff8027b9c1>] ftrace_record_ip+0xa3/0x357
> >  [<ffffffff8020c0f4>] mcount_call+0x5/0x31
> >  [<ffffffff8021c6d5>] ? lapic_wd_event+0x12/0x65
> >  [<ffffffff804b90d4>] nmi_watchdog_tick+0x21b/0x230
> >  [<ffffffff804b8487>] default_do_nmi+0x73/0x1e0
> >  [<ffffffff804b8a04>] do_nmi+0x64/0x91
> >  [<ffffffff804b80bf>] nmi+0x7f/0x80
> >  [<ffffffff80212c14>] ? default_idle+0x35/0x4f
> >  <<EOE>>  [<ffffffff8020ae42>] cpu_idle+0x8a/0xc9
> >  [<ffffffff804b15a6>] start_secondary+0x172/0x177
> > 
> > --------------- end cut here ---------------
> > 
> > 
> > This appears once when it is caught. We are hoping that this will not
> > appear often, and are running code to catch it as it does.
> > 
> > -- Steve
> > 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
