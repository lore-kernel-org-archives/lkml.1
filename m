Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbZDAJc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbZDAJc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbZDAJcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:32:14 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:59365 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761403AbZDAJcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:32:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18899.13455.965983.674389@cargo.ozlabs.ibm.com>
Date: Wed, 1 Apr 2009 20:31:59 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: allow and require one-page mmap on
 counting counters
In-Reply-To: <1238573622.8530.2582.camel@twins>
References: <18889.59409.260586.87939@cargo.ozlabs.ibm.com>
	<20090325082844.GA11217@elte.hu>
	<18889.61903.636761.471281@cargo.ozlabs.ibm.com>
	<20090325090336.GC2341@elte.hu>
	<18889.64659.917207.685779@cargo.ozlabs.ibm.com>
	<1238526907.3898.93.camel@laptop>
	<18898.53849.913178.781844@drongo.ozlabs.ibm.com>
	<1238573622.8530.2582.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> >   There will still be some issues on powerpc because of our
> > lazy interrupt disabling scheme, so some work might have to get
> > deferred until we soft-enable interrupts, but we have a way to manage
> > that.
> 
> Hmm, you're saying ppc always uses NMIs, even when !hw_event.nmi?

The PMU interrupts are always handled the same way at the moment,
which is to say they're handled when they come in whether or not
interrupts are soft-enabled.  The way things work is that
local_irq_disable etc. only soft-disable interrupts (clear a per-cpu
interrupts enabled flag in memory).  Interrupts don't get
hard-disabled (i.e. we don't clear the CPU's hardware interrupt enable
flag) until we actually get an interrupt.  A PMU interrupt can't be
taken while interrupts are hard-disabled but it can be taken while
interrupts are soft-disabled, so from that point of view it's an NMI.

The way that interrupts get hard-disabled is that the interrupt entry
code for regular interrupts and timer interrupts (but not PMU
interrupts) first checks the soft-enable flag.  If that flag is clear,
i.e. interrupts are soft-disabled, it clears the copy of the CPU
interrupt enable in the saved state from the interrupt and returns,
meaning that the code that was interrupted gets resumed with its
hardware interrupt enable bit clear.  That works because the CPU
doesn't automatically ack the interrupt with the interrupt controller
when it takes the interrupt, so the interrupt request will persist and
the CPU will take the interrupt again once the hardware interrupt
enable bit is set.

So in the period between soft-disabling and hard-disabling interrupts
it's possible to get a PMU interrupt.  If there are things we want to
do that we can't if interrupts were soft-disabled, we will have to
defer them to the point where interrupts get soft-enabled again.

> BTW, how's progress with the lazy switching?

Umm, I've been focussing more on things that affect the ABI at this
stage, I'm afraid, plus I was waiting for the dust to settle a bit on
the changes you're making.

Paul.
