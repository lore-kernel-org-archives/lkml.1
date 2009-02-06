Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZBFCZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZBFCZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 21:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZBFCZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 21:25:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49886 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZBFCZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 21:25:25 -0500
Date: Thu, 5 Feb 2009 21:25:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/2] ring-buffer: add NMI protection for spinlocks
In-Reply-To: <20090205175321.e1455c0e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0902052058470.5262@gandalf.stny.rr.com>
References: <20090206011315.360405659@goodmis.org> <20090206011350.976972261@goodmis.org> <20090205175321.e1455c0e.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added Arjan ]

On Thu, 5 Feb 2009, Andrew Morton wrote:
> > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > index 4d33224..4c68358 100644
> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > @@ -113,7 +113,7 @@ static void ftrace_mod_code(void)
> >  					     MCOUNT_INSN_SIZE);
> >  }
> >  
> > -void ftrace_nmi_enter(void)
> > +void arch_ftrace_nmi_enter(void)
> >  {
> >  	atomic_inc(&in_nmi);
> 
> This in_nmi thing looks a bit awkward.  It's not very clear from the
> code what it does or why it exists, but it looks like I'm going to have
> to get used to that...
> 
> Surely it is buggy?  It's incremented by _any_ cpu, so code which reads
> it (eg, prepare_ftrace_return()) will bale out if some other CPU
> happened to be in the middle of taking an NMI.

And that is exactly what we want it to do ;-)

This is code modification. If you modify code that another cpu is 
executing with, the result is undefined. In my tests to cause this type of 
error, I usually get a general protection fault.

To modify code safely, you must act like a uniprocessor. That is, the code 
you modify must not be executing on another CPU. We use stop_machine to 
help us out here, but under NMI stress tests, we found that we can crash, 
because the NMI will execute code being modified. Stop_machine does not 
disable NMIs on other CPUS.

To solve this, we sync up the modification with the NMI with a couple of 
variables. That's what all those memory barriers are for.

When we go to modify a line of code, we set a variable that we are doing 
so, wait for all NMIs to finish, then modify the code, wait for NMIs
again, and repeat on the next line to modify.

If the NMI goes off on any CPU, it increments the in_nmi counter. If the 
mod code flag is set, the NMI modifies the code.

The trick here is that the crash only occurs if the code is modified as it 
is being executed on. But it will not crash if the code is written to with 
the same data as it was. In other words, it is fine to write the code and 
execute it, if what you are writing is what is already there. No 
modification being done.

All NMIs that go off will modify the same code. Even if the code being 
modified is in a NMI code path, only the first NMI that goes off will 
actually modify it, the rest will just be writting the same data to the 
location. Even the main code will be writing the same data. No races.



> 
> Would it not be better to make in_nmi a per-cpu thing, make it a piece
> of first-class kernel infrastructure, add a nice interface to it, hoist
> it up into generic code, call that code from arch NMI handlers, call
> that interface from ftrace, etc?  Or perhaps it could be implemented in
> task_struct, alongside in_irq(), in_softirq(), etc.  There are three bits
> left in ->preempt_count.

I agree, we should have a per cpu nmi code. I can write that up and use
it for the ring buffer. But the call back for the ftrace code that I 
explained here must still be made. We need a "global" nmi counter for it 
to work.

-- Steve

> 
> This approach would remove the duplication which this patch is
> attempting to add.
> 
> Plus there's already quite a bit of duplication in
> arch/x86/kernel/ftrace.c between the
> CONFIG_DYNAMIC_FTRACE/!CONFIG_DYNAMIC_FTRACE hunks.  Two definitions of
> in_nmi, duplicated inc/dec thereof?
> 
> 
> 
> 
> 
