Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbXK1SBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbXK1SBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:01:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbXK1SAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:00:35 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41978 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbXK1SAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:00:33 -0500
Date: Wed, 28 Nov 2007 17:25:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Remy Bohmer <linux@bohmer.net>
Cc: Daniel Walker <dwalker@mvista.com>, RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will stall forever
Message-ID: <20071128172509.GA30173@flint.arm.linux.org.uk>
References: <3efb10970711260531x5e9f05acgfabdfa885a220192@mail.gmail.com> <3efb10970711260545i419a8352o4ca5248b10d81db5@mail.gmail.com> <1196176294.13982.58.camel@localhost.localdomain> <1196177122.23808.7.camel@imap.mvista.com> <1196178834.23808.11.camel@imap.mvista.com> <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 03:38:11PM +0100, Remy Bohmer wrote:
> Hello Daniel,
> 
> >  *      Note: The caller is expected to handle the ack, clear, mask and
> >  *      unmask issues if necessary.
> > So we shouldn't need any flow control unless there is some other
> > factors..
> 
> This comment can be misinterpreted, I think. Who is assumed to be the
> caller in this context? The 2 other routines in the driver that
> actually do the unmasking stuff besides only calling this routine? Is
> it allowed to call it directly or should it always be done through a
> wrapper that does all these special things?

The whole point of this simple handler is to accomodate interrupts such
as those found on the Neponset board.

There, you have a status register in a CPLD but no enable/disable
registers.  The status register tells you whether the SA1111, ethernet
or 'USAR' chip asserted its interrupt.

However, as there is no way to disable the sources, this situation has
to be handled carefully - the function decoding the interrupt source
needs to mask and unmask the _parent_ interrupt itself, and it's
exactly that which the comment is directed towards.

See neponset_irq_handler().

The simple IRQ handler is not meant for anything other than that really
simple implementation.  If people have been using it with interrupts
which can be individually masked and unmasked, that's where the bug is.
They should be using one of the other handlers.
