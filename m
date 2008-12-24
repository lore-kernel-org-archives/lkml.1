Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbYLXDKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbYLXDKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 22:10:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYLXDJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 22:09:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63627 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYLXDJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 22:09:54 -0500
Date: Tue, 23 Dec 2008 22:09:53 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/ftrace: don't trace on early stage of
 secondary cpu boot
In-Reply-To: <c62985530812231844w7bdc493secbbeaf4372afa52@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812232201110.20511@gandalf.stny.rr.com>
References: <49518535.8080105@gmail.com>  <alpine.DEB.1.10.0812232106080.6972@gandalf.stny.rr.com> <c62985530812231844w7bdc493secbbeaf4372afa52@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Dec 2008, Fr?d?ric Weisbecker wrote:
> >>       /*
> >> @@ -1233,7 +1233,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
> >>       int cpu;
> >>       int pc;
> >>
> >> -     if (!ftrace_trace_task(current))
> >> +     if (!ftrace_trace_task(current) || ftrace_in_early_cpuinit())
> >>               return 0;
> >
> > Actually, didn't you say current is not available either? We are testing
> > current first.
> 
> Oops. Strange, my tests didn't give me any problem.
> I will fix it.

Are you sure 'current' is dangerous? Perhaps we do not need to worry here, 
since we are testing current against something else, and if the CPU
is just coming on line, it will not be the task we want.

> 
> 
> > I still wonder if there's a better way to find out if it is safe to run.
> > Perhaps the arch code can test the %gs register to see if it is actually
> > something valid?
> >
> > -- Steve
> 
> I could test if MSR_GS_BASE references cpu_pda(cpu) but that remains
> as much heavy...

Perhaps just reading the %gs register and see if it faults would be good 
enough?

	long dummy;
	int faulted=0;

	    asm(
		"1:	movq %%gs:0, %0\n"
		"2:
		".section .fixup \"ax\"\n"
		"3:	movl $1, %1\n"
		"	jmp 2b\n"
		".previous"
		_ASM_EXTABLE(1b, 3b)
		: "=r"(dummy), "=r"(faulted)
		: "1"(faulted));


Would this work?  On the good cases, all we do is a read of the %gs 
section, which is the same as doing a smp_process_id(). On the bad case, 
we fault, but we also catch that fact. We are more interested in the good 
case being fast. but I'm not sure how well the start up code could take a 
fault, even when it is expected.

-- Steve

