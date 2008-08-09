Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbYHIPhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbYHIPhb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 11:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYHIPhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 11:37:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62905 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYHIPhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 11:37:23 -0400
Date: Sat, 9 Aug 2008 11:37:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <863e9df20808090801p7f9e11bar84d0e661440d591e@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0808091129460.25265@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org>  <863e9df20808090248h3adc2ac3mdb3217fe2876ab3b@mail.gmail.com>  <alpine.DEB.1.10.0808090854170.24140@gandalf.stny.rr.com> <863e9df20808090801p7f9e11bar84d0e661440d591e@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 9 Aug 2008, Abhishek Sagar wrote:

> On Sat, Aug 9, 2008 at 6:31 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Dynamically modifying text that might be in the pipeline on another CPU
> > may or may not be dangerous on all archs.
> 
> Kprobes leaves this mess for individual archs to handle (see
> arch_arm_kprobe). What would be nice to have is an explanation as to
> which archs are safe from this and under what conditions. Also, for
> !SMP, this boot-time patching approach and the associated build time
> paraphernalia would simply be a bloat. There we can simply have a
> daemonless ftrace which patches mcount sites synchronously. Why not
> let each arch have this hinge on CONFIG_SMP?

One of the things I tried to do was to make ftrace port easily to all 
archs. David Miller ported it to Sparc64 in 20 minutes and that was mostly 
compiling.  Doing a kprobe fix would require much more knowledge to each 
arch and more prone to errors.

> 
> > The fix here is to convert the mcount calls to nops at boot up. This is
> > really ideal on all archs. This means we know ever mcount call, and we get
> > rid of the requirement that we need to run the code once before we can
> > trace it.
> 
> This solution indeed would fit all archs well but for some it may be
> an overkill (or is it?...I'd like to know that :-\ ).

It is not an issue at all. The mcount list is discarded with the init 
section, and the change to nops is relatively fast. We do make a list of 
all entries anyway, so that we can pick and choose which functions we want 
to enable tracing on.

This recording at boot up should be fine on all archs, SMP or UP and will 
get rid of that daemon.

> 
> Oh and as you pointed out, it would mean that we have to no longer run
> the code before starting to trace it. But why don't we do that now?
> How about calling the tracer from ftrace_record_ip? All we need to do
> is pass along the parent_ip from mcount.

I want ftrace_record_ip to be as fast as possible, and also having it call
the registered function means we need to test if it was set in the filter 
too. This is too much for what record_ip does. And as I said, doing it all 
on boot up would be best.

> 
> > The kstop_machine is now only left at the start and stop of tracing.
> 
> This a nice fix. I'm just looking to find out what the self modifying
> code problem here translates to on different archs for my own
> understanding :-)


Now, what I can do, is remove the kstop machine from UP. Hmm, I need to 
check if kstop_machine code itself is smart enough to simply do a 
local_irq_save; run function; local_irq_restore, if it was on UP and not 
SMP.

-- Steve

