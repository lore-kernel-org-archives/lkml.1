Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYKHPYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYKHPYW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 10:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYKHPYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 10:24:12 -0500
Received: from relais.videotron.ca ([24.201.245.36]:21370 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbYKHPYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 10:24:11 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sat, 08 Nov 2008 10:24:03 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
In-reply-to: <20081108001555.GE18378@flint.arm.linux.org.uk>
Message-id: <alpine.LFD.2.00.0811080939180.13034@xanadu.home>
References: <20081107003816.9b0f947a.akpm@linux-foundation.org>
 <20081107052336.652868737@polymtl.ca> <20081107053349.861709786@polymtl.ca>
 <20081106220530.5b0e3a96.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0811070256450.13034@xanadu.home>
 <25363.1226056819@redhat.com> <20081107164758.GB22134@Krystal>
 <20081107201118.GB28600@flint.arm.linux.org.uk>
 <20081107213610.GC2654@Krystal> <9405.1226101315@redhat.com>
 <20081108001555.GE18378@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Nov 2008, Russell King wrote:

> On Fri, Nov 07, 2008 at 11:41:55PM +0000, David Howells wrote:
> > Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> > 
> > > Well, that's where it was - private to ARM.  Then David Howells came
> > > along and unilaterally - and without reference to anyone as far as I
> > > can see - moved it to include/linux.
> > > 
> > > Neither Nicolas, nor me had any idea that it was going to move into
> > > include/linux - the first we knew of it was when pulling the change
> > > from Linus' tree.
> > > 
> > > Look, if people in the kernel community can't or won't communicate
> > > with others (either through malice, purpose or accident), you can
> > > expect this kind of crap to happen.
> > 
> > Excuse me, Russell, but I sent Nicolas an email prior to doing so asking him
> > if he had any objections:
> > 
> > 	To: Nicolas Pitre <nico@cam.org>
> > 	cc: dhowells@redhat.com
> > 	Subject: Moving asm-arm/cnt32_to_63.h to include/linux/
> > 	Date: Thu, 31 Jul 2008 16:04:04 +0100
> > 
> > 	Hi Nicolas,
> > 
> > 	Mind if I move include/asm-arm/cnt32_to_63.h to include/linux/?
> > 
> > 	I need to use it for MN10300.
> > 
> > 	David
> > 
> > He didn't respond.  Not only that, but I copied Nicolas on the patch to make
> > the move and the patch to make MN10300 use it when I submitted it to Linus on
> > the 24th September, so it's not like he didn't have plenty of time.  He
> > certainly saw that because he joined in the discussion of the second patch.
> > Furthermore, he could've asked Linus to refuse the patch, or to revert it if
> > it had already gone in.

I was OK with the patch moving that code and I think I told you so as 
well. But...

> > I suppose I should've cc'd the ARM list too... but why should it adversely
> > affect ARM?
> 
> I take back the "Neither Nicolas" bit but the rest of my comment stands
> and remains valid.
> 
> In light of akpm's demands to know how this got into the kernel, I decided
> I'd put the story forward, especially as people in this thread are confused
> about what it was designed for, and making random unfounded claiming that
> its existing ARM uses are buggy when they aren't.

... I must agree with Russell that this is apparently creating more 
confusion with people than anything else.

> It sounds to me as if the right answer is for it to move back to being an
> ARM private thing with a MN10300 private copy, rather than it pretending
> to be something everyone can use.

I think this is OK if not everyone can use this.  The main purpose for 
this code was to provide much increased accuracy for shed_clock() on 
processors with only a 32-bit hardware counter.

Given that sched_clock() is already used in contexts where preemption is 
disabled, I don't mind the addition of a precision to the associated 
comment mentioning that it must be called at least once per 
half period of the base counter ***and*** not be preempted 
away for longer than the half period of the counter minus the longest 
period between two calls.  The comment already mention a kernel timer 
which can be used to control the longest period between two calls.  
Implicit disabling of preemption is _NOT_ the goal of this code.

I also don't mind having a real barrier for this code to be useful on 
other platforms.  On the platform this was written for, any kind of 
barrier is defined as a compiler barrier which is perfectly fine and 
achieve the same effect as the current usage of volatile.

I also don't mind making the high part of the counter always be a per 
CPU variable.  Again this won't change anything on the target this was 
intended for and this would make this code useful for more usages, and 
possibly help making the needed barrier on SMP more lightweight.  The 
usage requirement therefore becomes per CPU even if the base counter is 
global.  There are per CPU timers with add_timer_on() so this can be 
ensured pretty easily.

And if after all this the code doesn't suit your needs then just don't 
use it.  Its documentation should be clear enough so if people start 
using it in contexts where it isn't appropriate then it's not the code's 
fault.


Nicolas
