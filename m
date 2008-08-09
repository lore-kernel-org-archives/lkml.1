Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbYHINBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbYHINBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 09:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYHINBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 09:01:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50250 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYHINBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 09:01:39 -0400
Date: Sat, 9 Aug 2008 09:01:36 -0400 (EDT)
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
In-Reply-To: <863e9df20808090248h3adc2ac3mdb3217fe2876ab3b@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0808090854170.24140@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org> <863e9df20808090248h3adc2ac3mdb3217fe2876ab3b@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 9 Aug 2008, Abhishek Sagar wrote:

> On Thu, Aug 7, 2008 at 11:50 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > You see, the reason for this is that for ftrace to maintain performance
> > when configured in but disabled, it would need to change all the
> > locations that called "mcount" (enabled with the gcc -pg option) into
> > nops.  The "-pg" option in gcc sets up a function profiler to call this
> > function called "mcount". If you simply have "mcount" return, it will
> > still add 15 to 18% overhead in performance. Changing all the calls to
> > nops moved the overhead into noise.
> >
> > To get rid of this, I had the mcount code record the location that called
> > it. Later, the "ftraced" daemon would wake up and look to see if
> > any new functions were recorded. If so, it would call kstop_machine
> > and convert the calls to "nops". We needed kstop_machine because bad
> > things happen on SMP if you modify code that happens to be in the
> > instruction cache of another CPU.
> 
> Is this new framework needed for x86 specific reasons only? From what
> I gathered here, ftraced defers mcount patching simply because there's
> no way to update a 5-byte nop atomically. If so, why can't mcount site
> patching be left to arch specific ftrace code? For !SMP or archs which
> generate word sized mcount branch calls (e.g, ARM) is there really no
> way to patch  mcount sites synchronously from inside ftrace_record_ip
> by disabling interrupts?

There's two topics in this thread.

1) the x86 issue of the 5 byte instruction. The problem with x86 is that on
some CPUs the nop used consists of two nops to fill the 5 bytes. There is 
no way to change that atomically. The workarounds for this is the arch 
specific ftrace_pre_enable() that will make sure no process is about to 
execute the second part of that nop.

2) Getting rid of the daemon. The daemon is used to patch the code 
dynamically later on bootup. Now an arch may or may not be able to modify 
code in SMP, but I've been told that this is dangerous to do even on PPC.

Dynamically modifying text that might be in the pipeline on another CPU 
may or may not be dangerous on all archs.

The fix here is to convert the mcount calls to nops at boot up. This is 
really ideal on all archs. This means we know ever mcount call, and we get 
rid of the requirement that we need to run the code once before we can 
trace it.

The kstop_machine is now only left at the start and stop of tracing.

-- Steve

