Return-Path: <linux-kernel-owner+w=401wt.eu-S934710AbXKPBBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934710AbXKPBBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 20:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933197AbXKPBA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 20:00:59 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:65350 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933937AbXKPBA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 20:00:58 -0500
Date: Thu, 15 Nov 2007 20:00:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tim Bird <tim.bird@am.sony.com>
cc: john cooper <john.cooper@third-harmonic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: MIPS RT debug support
In-Reply-To: <473CD6E1.1060607@am.sony.com>
Message-ID: <Pine.LNX.4.58.0711151956430.30058@gandalf.stny.rr.com>
References: <473B8F91.20704@am.sony.com> <alpine.LFD.0.9999.0711150143220.3265@localhost.localdomain>
 <473BADD4.5030400@third-harmonic.com> <473CD6E1.1060607@am.sony.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Nov 2007, Tim Bird wrote:

> john cooper wrote:
> > The more daunting problem stems from limitations in the MIPS
> > ABI which makes the latency trace support problematic.
> > Rather than rehash the issue:
> >
> >     http://lists.linuxcoding.com/kernel/2005-q4/msg10163.html
> >
> > Until we have a usable instrumentation solution in place,
> > characterization, debug, and support of PREEMPT_RT for MIPS
> > is going to be a challenge.
>
> Agreed.  I have been using KFT (Kernel Function Trace)
> on MIPS, and it has decent support for function traceback
> reporting, but it's not currently integrated with latency-trace
> at all.   We should discuss if this could possibly be
> used to debug RT-preempt.  It is much heavier weight than
> the mcount stuff, but uses similar (but not identical)
> gcc profiling instrumentation.  I'm not sure if the
> two can be turned on together, or how hard it would
> be to move latency-trace onto -finstrument_functions.

I'm not familiar with the KFT but I'm sure it would be easy to port
latency_trace to it. Really, all the mcount does is make a wrapper to pass
to the trace calls.

Here's the code for mcount in arch/x86/kernel/entry_64.S:

ENTRY(mcount)
	cmpl $0, mcount_enabled
	jz out

	push %rbp
	mov %rsp,%rbp

	push %r11
	push %r10
	push %r9
	push %r8
	push %rdi
	push %rsi
	push %rdx
	push %rcx
	push %rax

	mov 0x0(%rbp),%rax
	mov 0x8(%rbp),%rdi
	mov 0x8(%rax),%rsi

	call   __trace

	pop %rax
	pop %rcx
	pop %rdx
	pop %rsi
	pop %rdi
	pop %r8
	pop %r9
	pop %r10
	pop %r11

	pop %rbp
out:
	ret


Which simply passes to __trace the rip that jumped here, and (if possible)
the rip of that caller. The parent rip is not necessary.

 >
> But it's probably worth researching a little.  We'll
> need something to give insight into the problem paths.

If the KFT could do the above, it should be trivial to adapt.

Hmm, if someone is willing to send me a free mips box, I may do it myself
;-)

-- Steve

