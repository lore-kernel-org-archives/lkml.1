Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185Ab0A2A7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab0A2A7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 19:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143Ab0A2A7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 19:59:37 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46964 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab0A2A7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 19:59:35 -0500
Subject: Re: linux-next: add utrace tree
From: Jim Keniston <jkenisto@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
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
In-Reply-To: <20100128085502.GA7713@elte.hu>
References: <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
	 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	 <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
	 <m33a1tnbd9.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
	 <m3636oh2rt.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
	 <1264575134.4283.1983.camel@laptop> <20100127085442.GA28422@elte.hu>
	 <1264643539.5068.62.camel@localhost.localdomain>
	 <20100128085502.GA7713@elte.hu>
Content-Type: text/plain
Date: Thu, 28 Jan 2010 16:59:28 -0800
Message-Id: <1264726768.4933.50.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-28 at 09:55 +0100, Ingo Molnar wrote:
> * Jim Keniston <jkenisto@us.ibm.com> wrote:
> 
> > On Wed, 2010-01-27 at 09:54 +0100, Ingo Molnar wrote:
> > ...
> > 
> > Yes, emulating "push %ebp" would buy us a lot of coverage for a lot of apps 
> > on x86 (but see below**). [...]
> 
...
> 
> > [...]  Even there, though, we'd have to address the page fault we'd 
> > occasionally get when extending the stack vma.
> 
> Nope, in the simplest model not even page fault emulation is needed, 
> get_user()/put_user() would resolve it automatically. If you either get the 
> value with the pagefault resolved, or you get a -EFAULT.

get_user()/put_user() have to be done in a context where you can sleep,
right?  Uprobes currently operates in such contexts, but there's some
talk of moving it all to a DIE_INT3 notifier context, where it can't
sleep.

...

> 
> > > We could get quite good coverage (and very fast 
> > >    emulation) for the common case in not too much code - and much of that code 
> > >    we already have available. No re-trapping,
> > 
> > As previously discussed, boosting would also get rid of the single-step trap 
> > for most instructions.
> 
> Boosting is not in the uprobes patch-set you submitted. Even with it present 
> it wont get rid of the initial INT3. So basically _best-case_ (with boosting) 
> XOL-uprobes could roughly break even with a pure emulator approach ...
> 
> That's a big and fundamental difference.

To be fair, wrt uprobes, emulation and boosting are both in the same
state: pretty well understood, but not yet implemented.

...
> > > 
> > >  - It's as transparent as it gets - no user-space trampoline or other visible
> > >    state that modifies behavior or can be stomped upon by user-space bugs.
> > 
> > The XOL vma isn't writable from user space, so I can't think of how it could 
> > be clobbered merely by a stray memory reference. [...]
> 
> Well there must be some purpose to the instrumentation, there must be some way 
> to save data, right? If yes and it's in user-space, that data is clobberable.

One or two others have advocated an approach (which eliminates the
breakpoint trap) where trace data is stored in the uprobe vma, but I
haven't.  (In such a case, "XOL vma" would be a misnomer.)  I agree that
in such a scenario, the uprobe vma would of necessity be writable by the
app.

>  
> If it's in kernel-space then we have to enter the kernel anyway (with similar 
> cost patterns to an INT3 entry) - so we just delayed the kernel entry.

This seems to presume that you have to extract trace data from the
kernel every time a probe is hit.  In actual practice, you're often just
checking for unusual arg values, incrementing a counter, or some such.

> 
...
> > Even if we add emulation, it seems sensible to keep the XOL approach as a 
> > backup to handle instructions that aren't yet emulated (and architectures 
> > that don't yet have emulators).  That way, if you don't probe any unemulated 
> > instructions, the XOL vma is never created.
> 
> To turn the argument around: an in-kernel emulator is an all-around facility 
> to make sure we probe safely and securely, _and_ it is also more portable 
> because it's simpler (because more gradual) to implement on a new architecture 
> as you dont actually have to copy around instructions (and make sure they work 
> in that new place), but have to emulate a limited subset of the instruction 
> space, on purely local state.

I understand the desire to start small and simple and grow gradually
from there.  We thought we were doing that.  Single-stepping out of line
has been in use for close to a decade, maybe more; and boosting (in
kprobes) has been around for a few years as well.  To the *probes folks,
it feels pretty solid.

> 
...
> 
> With an emulator (assuming the emulator is correct) we can execute the precise 
> semantics of that instruction in that place - without any side-effects from 
> trampolining/replacement.

And of course, our view has been that the best way to achieve the effect
of the instruction, including all desired side-effects, is to execute
the instruction on the CPU.

...
> > 
> > **In practice, we've had to probe all sorts of instructions, including FP 
> > instructions -- especially where you want to exploit the debug info to get 
> > the names, types, and locations of variables and args.  For some compilers 
> > and architectures, the debug info isn't reliable until the end of the 
> > function prologue, at which point you could find any old instruction.  Ditto 
> > if you want to probe statements within a function.
> 
> For those cases, frankly, the right approach is to fix the debug info (or 
> introduce a new one) and forget the old crap.
> 
> You treat debuginfo as some god-given property, while it's one of the suckiest 
> aspects of all of Linux. But we've had that discussion months (and years) ago. 
> It has improved in gcc 4.5 so there's some hope.

Yes, there seems to be considerable movement toward better debug info --
which could make statement probing (and not just function-boundary
probing) more and more feasible.

> 
...
> 	Ingo

Thanks.
Jim

