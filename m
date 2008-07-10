Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbYGJOnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbYGJOnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYGJOnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:43:24 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38478 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659AbYGJOnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:43:23 -0400
Subject: Re: [RFC] simple dprobe like markers for the kernel
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
In-Reply-To: <20080710142208.GC1213@redhat.com>
References: <1215638551.3444.39.camel__22002.9595810503$1215638656$gmane$org@localhost.localdomain>
	 <y0m1w22qxoj.fsf@ton.toronto.redhat.com>
	 <1215697794.3353.5.camel@localhost.localdomain>
	 <20080710142208.GC1213@redhat.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 09:43:16 -0500
Message-Id: <1215700996.3353.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 10:22 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Thu, Jul 10, 2008 at 08:49:54AM -0500, James Bottomley wrote:
> > [...]
> > > Another disadvantage is one that came up earlier when markers were
> > > initially thought up: that something so invisible to the compiler (no
> > > code being generated in the instruction stream, after optimization,
> > > may be impossible to locate: not just the statement but also the
> > > putative parameters.
> > 
> > Actually, I listed that one as an advantage.  But, in order to be
> > completely zero impact, the probe cannot interfere with optimisation,
> > and so you run the risk of having the probe point do strange things
> > (like it's in the middle of a loop that gets unrolled) or that the
> > variables you want to advertise get optimised away.
> > 
> > All of this is mitigated by correct selection of the probe points and
> > the variables.
> 
> Well, you can test your theory: replace some "tracepoints" or markers
> or printk's with this, and see if systemtap (or gdb) can get at the
> same data.

That's what I'm actually already doing ... so far it works nicely.

> When "correct selection" is a function of any particular compiler's
> optimization algorithms, it will be difficult for a human programmer
> to get it right.

Not necessarily.  A tracepoint by a barrier will always be pretty much
OK, as will variables that are either passed in or passed to functions
(since they have to be instantiated to pass as arguments).

Plus screw ups are easily detectable by a tool that parses the dwarf.

The essential point is that we need zero impact trace points and that
makes them difficult to place in this fashion.  However, the burden of
placing and verifying them rests with the people in the actual subsystem
(who are also the ones who hopefully get the most use out of them).

> > > Long ago, someone proposed inserting an asm("nop") mini-markers into
> > > the instruction stream, which could then be used as an anchor to tie a
> > > kprobe to, so that would solve the statement-location problem.
> > 
> > But you don't need a nop ... you just need a line number.
> 
> That's *if* the line number ends up being resolvable back to a PC.  In
> fact, since there is no code emitted for it, that particular line
> number will not actually appear in DWARF line records.

Erm, no ... dwarf is designed to emit an entry for every line in the
file (whether it contains a statment or not).  The empty lines get
elided in the line number program (because you can attach them to the
first statement following) but a correct parser will recover them (by
design in the dwarf).

> > > But it doesn't help assure that the parameters will be available in
> > > dwarf, so someone else proposed adding another asm that just asks the
> > > parameters to be evaluated and placed *somewhere*.  Each asm input
> > > constraint was to be the loosest possible, so as to not force the
> > > compiler to put the values into registers (and evict their normal
> > > tracing-ignorant tenants).
> > 
> > Actually, it does.  Assuming the probe is placed in the code by someone
> > who knows what they're doing and is using it, you can ensure that what
> > you're advertising actually exists.  [...]
> 
> You misunderstood - I am not talking about whether the variables exist
> in the context of the source code.  The question is which of those
> variables still exist, live & addressable, in the machine code and
> execution state.  You may be surprised to what extent compiler
> optimizations disrupt a simple source-level reading of the situation.

No ... I'm used to optimisation strangeness.  Again, I'm not trying to
eliminate it because that would defeat the zero impact purpose.  I'm
trying to build a system that can be useful without any impact.  The
consequence is going to be that certain trace points can't be used
because of the optimiser, but that's the tradeoff.  As long as the
people placing the trace points are subject matter experts in the
subsystem (and actually using them) everything should be OK.

> > > So that's roughly how we arrived at recent markers.  They expose to
> > > the compiler the parameters, but arrange not to evaluate them unless
> > > necessary.  The most recent markers code patches nops over most or all
> > > the hot path instructions, so there is no tangible performance impact.
> > 
> > Yes there are.  There are actually two performance impacts:
> > 
> >      1. The nops themselves take cycles to execute ... small, granted,
> >         but it adds up with lots of probe points
> >      2. The probes interfere with optimisation since to replace them
> >         with a function call, they must be barriers. [...]
> 
> That's why I qualified it with "tangible".  Please confirm your
> intuition about these costs.

1 is pretty obvious ... the nops have a defined cycle time in every
instruction architecture.  The optimisation costs are very difficult to
quantify since they vary so much from compiler to compiler and function
to function.

James


