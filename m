Return-Path: <linux-kernel-owner+w=401wt.eu-S932163AbXK2NhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163AbXK2NhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 08:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759352AbXK2Ng4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 08:36:56 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50524 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692AbXK2Ngz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 08:36:55 -0500
Date: Thu, 29 Nov 2007 13:36:05 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Remy Bohmer <linux@bohmer.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, Daniel Walker <dwalker@mvista.com>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will stall forever
Message-ID: <20071129133604.GA23845@flint.arm.linux.org.uk>
References: <1196177122.23808.7.camel@imap.mvista.com> <1196178834.23808.11.camel@imap.mvista.com> <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com> <20071128172509.GA30173@flint.arm.linux.org.uk> <Pine.LNX.4.58.0711281402210.3341@gandalf.stny.rr.com> <20071128200550.GA3494@flint.arm.linux.org.uk> <Pine.LNX.4.58.0711281510580.4247@gandalf.stny.rr.com> <3efb10970711290214v37d85a27k9a84876d9099d7c5@mail.gmail.com> <20071129102506.GB22793@flint.arm.linux.org.uk> <3efb10970711290327s3c60da1ey3b6fae738090ca5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3efb10970711290327s3c60da1ey3b6fae738090ca5@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 12:27:30PM +0100, Remy Bohmer wrote:
> Hello Russell,
> 
> > If 'no' then it's the right handler and the mask/unmask methods associated
> > with the interrupt will be no-ops.
> 
> I completely understand what you keep on saying, but that would imply
> that the following piece of code in chip.c is completely bogus anyway!
> (snip from mainline 2.6.23)

It _is_ bogus.

> handle_simple_irq(unsigned int irq, struct irq_desc *desc)
> ...
> 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
> 		if (desc->chip->mask)
> 			desc->chip->mask(irq);
> ...
> }
> 
> Why trying to mask the interrupt if that is illegal use of the interrupt
> type?

No idea, but that code is wrong.  Take a look at the original code
which patch 3692/1 removed.  You'll notice that it never touches
the mask/unmask handlers.

> This piece of code assumes that there CAN be a handler for masking
> interrupts for the simple_irq type. This is in contradiction what you
> are trying to explain.

Shrug.  I'm explaining how _I_ designed it, and the purpose of it being
there.

If people insist on adding the mask/unmask crap to it, the function
might as well be deleted and be an alias for handle_level_IRQ.  Because
that's _precisely_ what you lot are turning it into.

Ah, and looking at the changes to the file, the addition of the mask
and unmask was done by someone who didn't understand what this was
trying to do.  So that change should be backed out.
