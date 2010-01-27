Return-Path: <linux-kernel-owner+w=401wt.eu-S1752644Ab0A0Izb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab0A0Izb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178Ab0A0Iza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:55:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45200 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab0A0Iz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:55:29 -0500
Date: Wed, 27 Jan 2010 09:54:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tom Tromey <tromey@redhat.com>, Kyle Moffett <kyle@moffetthome.net>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, JimKeniston <jkenisto@us.ibm.com>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100127085442.GA28422@elte.hu>
References: <20100122221348.GA4263@redhat.com>
 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
 <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
 <m33a1tnbd9.fsf@fleche.redhat.com>
 <alpine.LFD.2.00.1001251332370.3574@localhost.localdomain>
 <m3636oh2rt.fsf@fleche.redhat.com>
 <alpine.LFD.2.00.1001261535510.17519@localhost.localdomain>
 <1264575134.4283.1983.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264575134.4283.1983.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2010-01-26 at 15:37 -0800, Linus Torvalds wrote:
> > 
> > On Tue, 26 Jan 2010, Tom Tromey wrote:
> > > 
> > > In non-stop mode (where you can stop one thread but leave the others
> > > running), gdb wants to have the breakpoints always inserted.  So,
> > > something must emulate the displaced instruction.
> > 
> > I'm almost totally uninterested in breakpoints that actually re-write 
> > instructions. It's impossible to do that efficiently and well, especially 
> > in threaded environments.
> > 
> > So if you do instruction rewriting, I can only say "that's your problem".
> 
> Right, so you're going to love uprobes, which does exactly that. The current 
> proposal is overwriting the target instruction with an INT3 and injecting an 
> extra vma into the target process's address space containing the original 
> instruction(s) and possible jumps back to the old code stream.
> 
> I'm all in favor of not doing that extra vma and instead use stack or TLS 
> space, but then people complain about having to make that executable (which 
> is something I don't really mind, x86 had executable everything for very 
> long, and also, its only so when debugging the thing anyway).

I think the best solution for user probes (by far) is to use a simplified 
in-kernel instruction emulator for the few common probes instruction. (Kprobes 
already partially decodes x86 instructions to make it safe to apply 
accelerated probes and there's other decoding logic in the kernel too.)

The design and practical advantages are numerous:

 - People want to probe their function prologues most of the time ...
   a single INT3 there will in most cases just hit the initial stack 
   allocation and that's it. We could get quite good coverage (and very fast 
   emulation) for the common case in not too much code - and much of that code 
   we already have available. No re-trapping, no extra instruction patching 
   and complex maintenance of trampolines.

 - It's as transparent as it gets - no user-space trampoline or other visible
   state that modifies behavior or can be stomped upon by user-space bugs.

 - Lightweight and simple probe insertion: no weird setup sequence needing the 
   stopping of all tasks to install the trampoline. We just add the INT3 and 
   off you go.

 - Emulation is evidently thread-safe, SMP-safe, etc. as it only acts on 
   task local state.

 - The points we can probe are never truly limited as it's all freely
   upscalable: if you cannot probe an instruction you want to probe today,
   extend the emulator. Deny the rest. _All_ versions of uprobes code i've
   seen so far already restricts the probe-compatible instruction set:
   RIP-relative instructions are excluded on 64-bit for example.

 - Emulation has the _least_ semantical side effects as we really execute
   'that' instruction - not some other instruction put elsewhere into a
   special vma or into the process/thread stack, or some special in-kernel
   trampoline, etc.

 - Emulation can be very fast for the common case as well. Nobody will probe
   weird, complex instructions. They will use 'perf probe' to insert probes
   into their functions 90% of the time ...

 - FPU and complex ops and pagefault emulation is not really what i'd expect
   to be necessary for simple probing - but it _can_ be added by people who
   care about it, if they so wish.

Such a scheme would be _far_ more preferable form a maintenance POV as well, 
as the initial code will be small, and we can extend it gradually. All the 
other proposals are complex 'all or nothing' schemes with no flexibility for 
complexity at all.

Thanks,

	Ingo
