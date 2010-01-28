Return-Path: <linux-kernel-owner+w=401wt.eu-S932206Ab0A1Izg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab0A1Izg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 03:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452Ab0A1Izf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 03:55:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40935 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab0A1Izd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 03:55:33 -0500
Date: Thu, 28 Jan 2010 09:55:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tom Tromey <tromey@redhat.com>, Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100128085502.GA7713@elte.hu>
References: <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
 <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
 <m33a1tnbd9.fsf@fleche.redhat.com>
 <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
 <m3636oh2rt.fsf@fleche.redhat.com>
 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
 <1264575134.4283.1983.camel@laptop>
 <20100127085442.GA28422@elte.hu>
 <1264643539.5068.62.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264643539.5068.62.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jim Keniston <jkenisto@us.ibm.com> wrote:

> On Wed, 2010-01-27 at 09:54 +0100, Ingo Molnar wrote:
> ...
> > I think the best solution for user probes (by far) is to use a simplified 
> > in-kernel instruction emulator for the few common probes instruction. (Kprobes 
> > already partially decodes x86 instructions to make it safe to apply 
> > accelerated probes and there's other decoding logic in the kernel too.)
> > 
> > The design and practical advantages are numerous:
> > 
> >  - People want to probe their function prologues most of the time ...
> >    a single INT3 there will in most cases just hit the initial stack 
> >    allocation and that's it.
> 
> Yes, emulating "push %ebp" would buy us a lot of coverage for a lot of apps 
> on x86 (but see below**). [...]

Coverage in practice is all that matters.

Consider the fact that i get 1000 times more bugreports aided by strace, which 
has 1000 times more overhead than even the slowest of uprobes approaches.

This simple fact tell us that while performance matters, it is of little use 
if good utility and a clean design is not there. (in fact sane and clean 
design will almost automatically result in good performance too down the line, 
but i digress.) Faster crap is still crap.

> [...]  Even there, though, we'd have to address the page fault we'd 
> occasionally get when extending the stack vma.

Nope, in the simplest model not even page fault emulation is needed, 
get_user()/put_user() would resolve it automatically. If you either get the 
value with the pagefault resolved, or you get a -EFAULT.

If you concentrate only on the common case then emulation can be _really_ 
simple.

Lets compare the two cases via a drawing. Your current uprobes submission 
does:

 [kernel]      do probe thing     single-step trap
               ^            |     ^              |
               |            v     |              v
 [user]     INT3            XOL-ins              next ins-stream

 ( add the need for serialization to make sure the whole single-step thing 
   does not get out of sync with reality. )

And emulator approach would do:

 [kernel]      emul-demux-fastpath, do probe thing
               ^                                 |
               |                                 v
 [user]     INT3                                 next ins-stream

far simpler conceptually, and faster as well, because it's one kernel entry.

Generally i get nervous if a piece of instrumentation cannot be expressed in 
simple ways. _Especially_ if i consider it to concentrate on all the wrong 
things and doesnt even break even with a far less complex scheme.

What would be the 'right things' to concentrate on? Make sure it's all all 
around end-to-end package that is _useful to people_. As of today i have yet 
to get a _single_ bugreport or kernel improvement requested by an application 
writer who found out about the inefficiencies in his app using uprobes. There 
is a gaping hole of utility here, a whole cathedral of tools written that just 
a handful of ordinary Linux person uses. There's big disconnect and i can say 
one thing for sure: needless complexity in the wrong places can outright 
stiffle tools from becoming good.

> > We could get quite good coverage (and very fast 
> >    emulation) for the common case in not too much code - and much of that code 
> >    we already have available. No re-trapping,
> 
> As previously discussed, boosting would also get rid of the single-step trap 
> for most instructions.

Boosting is not in the uprobes patch-set you submitted. Even with it present 
it wont get rid of the initial INT3. So basically _best-case_ (with boosting) 
XOL-uprobes could roughly break even with a pure emulator approach ...

That's a big and fundamental difference.

> > no extra instruction patching 
> 
> x86_64 rip-relative instructions are the only ones we alter.
> 
> >    and complex maintenance of trampolines.
> > 
> >  - It's as transparent as it gets - no user-space trampoline or other visible
> >    state that modifies behavior or can be stomped upon by user-space bugs.
> 
> The XOL vma isn't writable from user space, so I can't think of how it could 
> be clobbered merely by a stray memory reference. [...]

Well there must be some purpose to the instrumentation, there must be some way 
to save data, right? If yes and it's in user-space, that data is clobberable. 
If it's in kernel-space then we have to enter the kernel anyway (with similar 
cost patterns to an INT3 entry) - so we just delayed the kernel entry.

So IMHO you have designed in considerable complexity for little immediate 
benefit.

> [...]  Yes, it's a vma that the unprobed app would never have; and yes, a 
> malicious app or kernel module could remove it or alter the protection and 
> scribble on it.  We don't try to defend the app against such malicious 
> attacks, but we do our best to ensure that the kernel side handles such 
> attacks gracefully.
> 
> >  - Lightweight and simple probe insertion: no weird setup sequence needing the 
> >    stopping of all tasks to install the trampoline. We just add the INT3 and 
> >    off you go.
> 
> FWIW, we don't stop all threads to set up or extend the XOL vma, which is 
> typically a one-time event.  We just grab a mutex, in case multiple threads 
> hit previously-unhit probepoints simultaneously, and simultaneously decide 
> that the XOL area needs to be created or extended.

Still it's more complex than purely local state. Plus slower than even a naive 
emulator approach would be able to achieve, due to single-stepping.

> >  - Emulation is evidently thread-safe, SMP-safe, etc. as it only acts on
> >    task local state.
> 
> The posted uprobes implementation is, so far as we can tell through code
> inspection and testing, also thread-safe and SMP-safe.
> 
> > 
> >  - The points we can probe are never truly limited as it's all freely
> >    upscalable: if you cannot probe an instruction you want to probe today,
> >    extend the emulator.
> 
> I don't see how ripping out existing support for almost* the entire 
> instruction set, and then putting it back instruction by instruction, patch 
> by patch, is a win.

IMO it's a win because it's more controlled in what we can and cannot do 
safely, and because it's more transparent to the probed context.

But by far the most important aspect is that it should be far less code with 
far less complexity, and hence much more graceful from an upstream POV.

Gradual concepts with easy ways forwards/backwards are good. All-or-nothing 
frameworks are bad.

> Even if we add emulation, it seems sensible to keep the XOL approach as a 
> backup to handle instructions that aren't yet emulated (and architectures 
> that don't yet have emulators).  That way, if you don't probe any unemulated 
> instructions, the XOL vma is never created.

To turn the argument around: an in-kernel emulator is an all-around facility 
to make sure we probe safely and securely, _and_ it is also more portable 
because it's simpler (because more gradual) to implement on a new architecture 
as you dont actually have to copy around instructions (and make sure they work 
in that new place), but have to emulate a limited subset of the instruction 
space, on purely local state.

There are far less things that can go wrong in such a model.

> > Deny the rest. _All_ versions of uprobes code i've
> >    seen so far already restricts the probe-compatible instruction set:
> 
> *Yes, we currently decline to probe some instructions that look troublesome 
> and we haven't taken the time to test.  These include things like privileged 
> instructions, int*, in*/out*, and instructions that fuss with the segment 
> registers.  We've never actually seen such instructions in user apps.
>
> 
> >    RIP-relative instructions are excluded on 64-bit for example.
> 
> No.  As discussed in previous posts, we handle rip-relative
> instructions.
> 
> > 
> >  - Emulation has the _least_ semantical side effects as we really execute
> >    'that' instruction -
> 
> It seems to me that emulation is the only approach that DOESN'T execute the 
> probed instruction.

None of the approaches executes _that_ instruction in _that_ place - the 
instruction is either replaced by an INT3 or by a jump-to-trampoline 
instruction.

They may execute the same instruction but in another place.

With an emulator (assuming the emulator is correct) we can execute the precise 
semantics of that instruction in that place - without any side-effects from 
trampolining/replacement.

> > not some other instruction put elsewhere into a
> >    special vma or into the process/thread stack, or some special in-kernel
> >    trampoline, etc.
> > 
> >  - Emulation can be very fast for the common case as well. Nobody will probe
> >    weird, complex instructions. They will use 'perf probe' to insert probes
> >    into their functions 90% of the time ...
> > 
> >  - FPU and complex ops and pagefault emulation is not really what i'd expect
> >    to be necessary for simple probing - but it _can_ be added by people who
> >    care about it, if they so wish.
> 
> **In practice, we've had to probe all sorts of instructions, including FP 
> instructions -- especially where you want to exploit the debug info to get 
> the names, types, and locations of variables and args.  For some compilers 
> and architectures, the debug info isn't reliable until the end of the 
> function prologue, at which point you could find any old instruction.  Ditto 
> if you want to probe statements within a function.

For those cases, frankly, the right approach is to fix the debug info (or 
introduce a new one) and forget the old crap.

You treat debuginfo as some god-given property, while it's one of the suckiest 
aspects of all of Linux. But we've had that discussion months (and years) ago. 
It has improved in gcc 4.5 so there's some hope.

> > Such a scheme would be _far_ more preferable form a maintenance POV as 
> > well, as the initial code will be small, and we can extend it gradually. 
> > All the other proposals are complex 'all or nothing' schemes with no 
> > flexibility for complexity at all.

I repeat this point. To be able to scale in and out of a design is rather 
important, and i dont see that with the current XOL proposal.

	Ingo
