Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbZK3PiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbZK3PiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbZK3PiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:38:21 -0500
Received: from relais.videotron.ca ([24.201.245.36]:8704 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbZK3PiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:38:20 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 30 Nov 2009 10:38:16 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.y.miao@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       John Stultz <johnstul@us.ibm.com>, Jamie Lokier <jamie@shareable.org>,
       LKML <linux-kernel@vger.kernel.org>, Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Get rid of IRQF_DISABLED - (was [PATCH] genirq: warn about
 IRQF_SHARED|IRQF_DISABLED)
In-reply-to: <20091130143703.GA7028@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.00.0911301006220.5820@xanadu.home>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <alpine.LFD.2.00.0911301225110.24119@localhost.localdomain>
 <20091130143703.GA7028@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Russell King - ARM Linux wrote:

> However, I think we still have a number of corner cases.  The SMC91x
> driver comes to mind, with its stupidly small FIFOs, where the majority
> of implementations have to have the packets loaded via PIO - and this
> seems to generally happen from IRQ context.

That is indeed the case for the RX path in order to avoid packet drop as 
much as possible.  The TX path is always run outside IRQ context though.

> The upshot of that is switching the SMC91x interrupt handler to run with
> IRQs disabled will mean that serial can suffer with overruns, especially
> if the serial port FIFO is also small.

That can happen now already anyway, regardless of whether IRQ handlers 
are run with IRQs enabled or not.  Suffice to have serial and smc91x 
interrupts asserted more or less at the same time, i.e. before the 
pending interrupt sources are actually determined and interrupts enabled 
again, in which case the IRQ handlers are serialized usually according 
to their IRQ number (most target don't use sophisticated IRQ 
priorities).

And then, the serial interrupt isn't currently registered with 
IRQF_DISABLED, meaning that its handler can be interrupted by any other 
interrupt coming along, including the heavier smc91x RX code.  That 
isn't much different from having all interrupt handlers run with IRQs 
disabled and the serial interrupt having to wait after the smc91x one.

In other words, I don't think having all IRQ handlers run with IRQs 
disabled would change much wrt average IRQ latency in practice.  
Without real hardware based IRQ priority management (or thread based IRQ 
handlers with software managed priorities), The smc91x handler could 
adversely affect the serial handler in either cases.


Nicolas
