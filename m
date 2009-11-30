Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbZK3Jzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbZK3Jzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZK3Jzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:55:46 -0500
Received: from www.tglx.de ([62.245.132.106]:52019 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZK3Jzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:55:46 -0500
Date: Mon, 30 Nov 2009 10:54:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jamie Lokier <jamie@shareable.org>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       John Stultz <johnstul@us.ibm.com>, Nicolas Pitre <nico@marvell.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] warn about shared irqs requesting IRQF_DISABLED registered
 with setup_irq
In-Reply-To: <20091129151840.GA30813@shareable.org>
Message-ID: <alpine.LFD.2.00.0911301033340.24119@localhost.localdomain>
References: <20091127195857.GB28193@n2100.arm.linux.org.uk> <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <alpine.LFD.2.00.0911272234460.24119@localhost.localdomain> <20091128200344.GA1272@pengutronix.de> <alpine.LFD.2.00.0911282239430.24119@localhost.localdomain>
 <20091129023118.GA21529@shareable.org> <20091129102635.GA22653@pengutronix.de> <20091129151840.GA30813@shareable.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Nov 2009, Jamie Lokier wrote:
> > > Wouldn't it be quite a lot nicer if generic setup moved the
> > > IRQF_DISABLED handler to be first in the list, if that actually works
> > > in a useful way rather than simply being a quirk that irqs are
> > > disabled for the first one?
> > Hmm, what happens if an ISR runs with irqs disabled even though it
> > doesn't expect it?  I wouldn't bet that nothing breaks.
> 
> Moving the IRQF_DISABLED handler to be first will run an ISR with
> interrupts disabled which *does* expect it, so that's good.
> 
> According to this thread, at the moment when you have multiple
> IRQF_DISABLED|IRQF_SHARED ISRs, only the first one is run with
> interrupts disabled.

Wrong. The flags of the first action are checked to decide whether
interrupts are enabled _before_ calling the action handler.

So for shared interrupts we have the following combinations:

     action1            action2
A    -	                -
B    IRQF_DISABLED      -
C    -                  IRQF_DISABLED
D    IRQF_DISABLED      IRQF_DISABLED

A) Correct behaviour for action1 and action2

B) Correct behaviour for action1, but action2 is called with
   interrupts disabled

C) Correct behaviour for action1, but action2 is called with
   interrupts enabled
 
D) Correct behaviour for action1 and action2 in theory

> In fact I don't see why the kernel cannot put _all_ of the
> IRQ_DISABLED handlers at the beginning of the list, traverse those
> with interrupts disabled, then enable interrupts them for the
> remaining handlers.

That does not work reliable, because IRQF_DISABLED is just describing
the calling convention of the interrupt.

It does not say, that the handler is not allowed to enable
interrupts. So for D) there is no guarantee that the action1 handler
keeps interrupts disabled. If it enables interrupts in the handler
then the assumptions of action2 are already violated.

> > IMHO the best is if a warning is printed or registering fails if shared
> > irq actions don't agree about wanting IRQF_DISABLED.

No, we print a warning when IRQF_SHARED is used with IRQF_DISABLED as
there is no point about agreeing on something which can not be
guaranteed at all.

Thanks,

	tglx
