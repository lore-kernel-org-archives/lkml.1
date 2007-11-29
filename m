Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbXK2OaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbXK2OaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 09:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbXK2OaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 09:30:05 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57569 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750AbXK2OaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 09:30:03 -0500
Date: Thu, 29 Nov 2007 14:29:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Remy Bohmer <linux@bohmer.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Daniel Walker <dwalker@mvista.com>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will stall forever
Message-ID: <20071129142920.GB23845@flint.arm.linux.org.uk>
References: <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com> <20071128172509.GA30173@flint.arm.linux.org.uk> <Pine.LNX.4.58.0711281402210.3341@gandalf.stny.rr.com> <20071128200550.GA3494@flint.arm.linux.org.uk> <Pine.LNX.4.58.0711281510580.4247@gandalf.stny.rr.com> <3efb10970711290214v37d85a27k9a84876d9099d7c5@mail.gmail.com> <20071129102506.GB22793@flint.arm.linux.org.uk> <3efb10970711290327s3c60da1ey3b6fae738090ca5@mail.gmail.com> <20071129133604.GA23845@flint.arm.linux.org.uk> <3efb10970711290618v2bd93edfrbc53d9df4b73b33b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3efb10970711290618v2bd93edfrbc53d9df4b73b33b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 03:18:04PM +0100, Remy Bohmer wrote:
> Hello Russell,
> 
> > If people insist on adding the mask/unmask crap to it, the function
> > might as well be deleted and be an alias for handle_level_IRQ.  Because
> > that's _precisely_ what you lot are turning it into.
> 
> First, I want to make clear that I am just debugging a problem on RT
> that does not exist on mainline, and I am trying to find a way to get
> it solved nicely _on RT_, and preferable in a way that it works for
> everybody with the least chance for regression.

While I realise that, I'm telling you that the _problem_ is being
caused by the wrong handler being used.

> I already mentioned that RT is doing masking in this code during
> normal use, where the mainline kernel does not do this, **except** in
> an error situation.

AT91 has edge based GPIO interrupts which need special handling so
edges aren't missed.  That's what the edge handler is there for - to
ensure that edges aren't missed while the interrupt is soft-disabled.

SA1100 and PXA have exactly the same setup.  They use the correct
handler.  Why is AT91 special?

> So, as far as I can tell , the type really used on at91 for the GPIO
> stuff _is_ a simple_irq as you describe, but one that can be
> masked/unmasked **in case of errors**. It should never be masked
> during normal use.
> 
> So, I propose option 1 to solve it on RT, and thus to trigger Steven
> to NACK my first patch. I will try and see if I can make it work
> _without_ masking on RT (except in case of errors, just as in
> mainline).
> ...and probably add some clear description about the purpose of
> simple_irq, especially related to masking...
> 
> Do you agree on this Russell?

Clearly no, I disagree.

> > Ah, and looking at the changes to the file, the addition of the mask
> > and unmask was done by someone who didn't understand what this was
> > trying to do.  So that change should be backed out.
> 
> Maybe he was trying to mask the irq during an error situation?

Who knows.  The patch says nothing about that change.  The change was
never copied to me, so I've never reviewed it (and had it been, I
would've indicated that the change was wrong.)
