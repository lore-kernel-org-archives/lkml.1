Return-Path: <linux-kernel-owner+w=401wt.eu-S932172Ab0A1Bwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab0A1Bwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984Ab0A1Bwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:52:31 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53672 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab0A1Bw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:52:29 -0500
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
In-Reply-To: <20100127085442.GA28422@elte.hu>
References: <20100122221348.GA4263@redhat.com>
	 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
	 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
	 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	 <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
	 <m33a1tnbd9.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
	 <m3636oh2rt.fsf@fleche.redhat.com>
	 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
	 <1264575134.4283.1983.camel@laptop>  <20100127085442.GA28422@elte.hu>
Content-Type: text/plain
Date: Wed, 27 Jan 2010 17:52:19 -0800
Message-Id: <1264643539.5068.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 09:54 +0100, Ingo Molnar wrote:
...
> I think the best solution for user probes (by far) is to use a simplified 
> in-kernel instruction emulator for the few common probes instruction. (Kprobes 
> already partially decodes x86 instructions to make it safe to apply 
> accelerated probes and there's other decoding logic in the kernel too.)
> 
> The design and practical advantages are numerous:
> 
>  - People want to probe their function prologues most of the time ...
>    a single INT3 there will in most cases just hit the initial stack 
>    allocation and that's it.

Yes, emulating "push %ebp" would buy us a lot of coverage for a lot of
apps on x86 (but see below**).  Even there, though, we'd have to address
the page fault we'd occasionally get when extending the stack vma.

> We could get quite good coverage (and very fast 
>    emulation) for the common case in not too much code - and much of that code 
>    we already have available. No re-trapping,

As previously discussed, boosting would also get rid of the single-step
trap for most instructions.

> no extra instruction patching 

x86_64 rip-relative instructions are the only ones we alter.

>    and complex maintenance of trampolines.
> 
>  - It's as transparent as it gets - no user-space trampoline or other visible
>    state that modifies behavior or can be stomped upon by user-space bugs.

The XOL vma isn't writable from user space, so I can't think of how it
could be clobbered merely by a stray memory reference.  Yes, it's a vma
that the unprobed app would never have; and yes, a malicious app or
kernel module could remove it or alter the protection and scribble on
it.  We don't try to defend the app against such malicious attacks, but
we do our best to ensure that the kernel side handles such attacks
gracefully.

> 
>  - Lightweight and simple probe insertion: no weird setup sequence needing the 
>    stopping of all tasks to install the trampoline. We just add the INT3 and 
>    off you go.

FWIW, we don't stop all threads to set up or extend the XOL vma, which
is typically a one-time event.  We just grab a mutex, in case multiple
threads hit previously-unhit probepoints simultaneously, and
simultaneously decide that the XOL area needs to be created or extended.

> 
>  - Emulation is evidently thread-safe, SMP-safe, etc. as it only acts on 
>    task local state.

The posted uprobes implementation is, so far as we can tell through code
inspection and testing, also thread-safe and SMP-safe.

> 
>  - The points we can probe are never truly limited as it's all freely
>    upscalable: if you cannot probe an instruction you want to probe today,
>    extend the emulator.

I don't see how ripping out existing support for almost* the entire
instruction set, and then putting it back instruction by instruction,
patch by patch, is a win.

Even if we add emulation, it seems sensible to keep the XOL approach as
a backup to handle instructions that aren't yet emulated (and
architectures that don't yet have emulators).  That way, if you don't
probe any unemulated instructions, the XOL vma is never created.

> Deny the rest. _All_ versions of uprobes code i've
>    seen so far already restricts the probe-compatible instruction set:

*Yes, we currently decline to probe some instructions that look
troublesome and we haven't taken the time to test.  These include things
like privileged instructions, int*, in*/out*, and instructions that fuss
with the segment registers.  We've never actually seen such instructions
in user apps.

>    RIP-relative instructions are excluded on 64-bit for example.

No.  As discussed in previous posts, we handle rip-relative
instructions.

> 
>  - Emulation has the _least_ semantical side effects as we really execute
>    'that' instruction -

It seems to me that emulation is the only approach that DOESN'T execute
the probed instruction.

> not some other instruction put elsewhere into a
>    special vma or into the process/thread stack, or some special in-kernel
>    trampoline, etc.
> 
>  - Emulation can be very fast for the common case as well. Nobody will probe
>    weird, complex instructions. They will use 'perf probe' to insert probes
>    into their functions 90% of the time ...
> 
>  - FPU and complex ops and pagefault emulation is not really what i'd expect
>    to be necessary for simple probing - but it _can_ be added by people who
>    care about it, if they so wish.

**In practice, we've had to probe all sorts of instructions, including
FP instructions -- especially where you want to exploit the debug info
to get the names, types, and locations of variables and args.  For some
compilers and architectures, the debug info isn't reliable until the end
of the function prologue, at which point you could find any old
instruction.  Ditto if you want to probe statements within a function.

> 
> Such a scheme would be _far_ more preferable form a maintenance POV as well, 
> as the initial code will be small, and we can extend it gradually. All the 
> other proposals are complex 'all or nothing' schemes with no flexibility for 
> complexity at all.
> 
> Thanks,
> 
> 	Ingo

Thanks.
Jim

