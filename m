Return-Path: <linux-kernel-owner+w=401wt.eu-S1751912AbZH1Ggd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbZH1Ggd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 02:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZH1Ggc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 02:36:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40935 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbZH1Ggb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 02:36:31 -0400
Date: Fri, 28 Aug 2009 08:36:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] lockup with the latest kernel
Message-ID: <20090828063603.GA21420@elte.hu>
References: <alpine.DEB.2.00.0908191134260.12663@gandalf.stny.rr.com> <alpine.DEB.2.00.0908271836140.26718@gandalf.stny.rr.com> <4A9744F4.7010208@kernel.org> <4A97468A.6080502@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A97468A.6080502@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Tejun Heo wrote:
> >>> Always happens where one CPU is sending an IPI and the other has the rq 
> >>> spinlock. Seems to be that the IPI expects the other CPU to not have 
> >>> interrupts disabled or something?
> > 
> > I'm not too familiar with apics but AFAIK sending IPI isn't an
> > interlocked operation (not at least at the software level) so I doubt
> > it has much to do with the other cpu doing or not doing anything.  It
> > looks like the local apic is stuck hardware-wise.  The only thing the
> > commit changes is that cpu1 would be using vector 0xf1 instead of 0xf0
> > together with cpu0.
> > 
> > (reading the doc...) Okay, here's something interesting.  It's from
> > section 9.8.4 of intel doc 253668.pdf - Intel 64 and IA-32
> > Architectures Software Developer's Manual Volume 3A: System
> > Programming Guide, Part 1.
> > 
> >  For the P6 family and Pentium processors, the IRR and ISR registers
> >  can queue no more than two interrupts per priority level, and will
> >  reject other interrupts that are received within the same priority
> >  level.
> > 
> > And from AMD's 24593 - AMD64 Architecture Programmer's Manual Volume
> > 2: System Programming, section 16.6.3.
> > 
> >  No more than two interrupts can be pending for the same interrupt
> >  vector number. Subsequent interrupt requests to the same interrupt
> >  vector number will be rejected. See Figure 16-23 on page 445.
> > 
> 
> Oh... there are differences that I missed.
> 
>  All intels: If more than one interrupt is generated with the same
> 	     vector number, the local APIC can set the bit for the
> 	     vector both in the IRR and the ISR. This means that for
> 	     the Pentium 4 and Intel Xeon processors, the IRR and ISR
> 	     can queue two interrupts for each interrupt vector: one
> 	     in the IRR and one in the ISR. Any additional interrupts
> 	     issued FOR THE SAME INTERRUPT VECTOR are COLLAPSED INTO
> 	     THE SINGLE BIT in the IRR.
> 
>  Ppro: no more than two interrupts PER PRIORITY LEVEL, and will REJECT
>        OTHER interrupts
> 
>  AMD64: Subsequent interrupt requests to THE SAME INTERRUPT VECTOR
>         NUMBER will be REJECTED.
> 
> Eh... don't have earlier AMD doc and gotta go now.  Can somebody 
> please check?  But it looks like we can deadlock by simply sending 
> RESCHEDULE_VECTOR more than two times while holding rq lock on 
> AMD?

We poll ICR in the send-IPI logic before sending it out - so this 
shouldnt happen. The restrictions above should at most cause extra 
polling latency (i.e. it's a performance detail, not a lockup 
source). See all the *wait_icr_idle() methods in the IPI sending 
logic in arch/x86.

Neither TLB flushes nor reschedule IPIs are idempotent, so if this 
was broken and if we lost requested events on remote CPUs we'd 
notice it rather quickly via TLB flush related hangs or scheduling 
latencies or lost wakeups, on a rather large category of CPUs.

I think Linus's suggestion that it's the zero mask quirk on certain 
older CPUs that is causing problems on that system should be 
examined ... does .31-rc8 work fine?

	Ingo
