Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbZA2Sum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbZA2Sum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZA2Su1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:50:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33597 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbZA2SuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:50:25 -0500
Date: Thu, 29 Jan 2009 19:49:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
Message-ID: <20090129184953.GA14810@elte.hu>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <200901290955.38940.rusty@rustcorp.com.au> <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com> <20090128173039.cbc29e81.akpm@linux-foundation.org> <1233218954.7835.11.camel@twins> <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain> <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And are you really sure it cannot be called from within interrupts? I'm 
> finding a lot of callers of smp_call_function_single(), and while I 
> couldn't find any that look like interrupts, I also couldn't find any 
> indication that it never happens.

smp_call_function_single() must not be called from irqs-off code - and 
that implicitly includes most IRQ handlers as well. (most of which run 
with hardirqs off)

We check for that via:

        /* Can deadlock when called with interrupts disabled */
        WARN_ON(irqs_disabled());

[ although it should probably be extended to '&& !in_interrupt()' as well, 
  to cover the subset of IRQ handlers running with irqs enabled - which is 
  small but nonzero. It would also cover softirqs. ]

There are 3 reasons why sending IPIs from an irqs off critical section is 
a bad idea currently:

1) the implementation is deadlockable as you noted. That is self-inflicted
   stupidity and fixable.

2) the _concept_ of two CPUs sending IPIs to each other at once and
   expecting them to be handled and then waiting for them is a deadlock.
   We could allow async IPIs from irqs-off sections, but isnt that a too
   narrow special-case?

3) the third reason is nasty: the act of sending an IPI on x86 hardware
   needs to happen with interrupts enabled. In the lowlevel IPI sending
   code we first poll the hardware whether it's ready to accept new IPIs:
   via apic_wait_icr_idle().

   There've been incidents in the past where the ICR-ready (Interrupt 
   Command Register - ready) bit would deadlock the box in certain 
   situations (usually with wackier APIC implementations and if there's 
   too many IPIs 'in flight' and the only way to make progress is to allow 
   IPIs to happen locally - i.e. to have irqs on), if the IPI was sent 
   from an irqs-off section.

So i'm not sure we could relax things here without expecting too much of 
the hardware.

What i like least about kernel/smp.c is the kmalloc(GFP_ATOMIC) - and we 
had to add that in a late -rc for an essential bugfix.

IMO that kmalloc() has "layering violation" written all over it. It turns 
the pure act of 'sending messages' into a conceptually heavy and wide 
facility. Is the buffering of async messages really such a big deal in 
practice? Does anyone have any numbers?

Btw., there _is_ a relatively atomic, safe and instantaneous way of 
sending IPIs on x86: sending NMIs. But that has its own host of issues 
both on the hardware and on the software side ...

	Ingo
