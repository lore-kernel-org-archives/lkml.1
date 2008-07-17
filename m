Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbYGQQLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbYGQQLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757078AbYGQQL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:11:26 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55010 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbYGQQLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:11:25 -0400
Date: Thu, 17 Jul 2008 10:11:09 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Vrabel <david.vrabel@csr.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080717161108.GS25255@parisc-linux.org>
References: <4860D09D.4060801@csr.com> <4864DA54.6000205@csr.com> <200806271007.26248.jbarnes@virtuousgeek.org> <200807161243.03360.jbarnes@virtuousgeek.org> <20080716195853.GL25255@parisc-linux.org> <487F45C0.2080201@csr.com> <20080717153917.GR25255@parisc-linux.org> <alpine.LFD.1.10.0807171745270.4316@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807171745270.4316@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 05:58:26PM +0200, Thomas Gleixner wrote:
> > This is a good thought, let's follow it through.  What if we simply make
> > ->mask a no-op for devices which don't support mask bits?
> 
> Yep. You can also use fasteoi_handler, which just calls ->eoi() after
> the handler.

I think that exposes us to a race.

CPU takes the first interrupt, calls handle_fasteoi_irq().  That
calls handle_IRQ_event() which calls the device's interrupt handler.
Interrupt handler reads status register to determine what to do next.
Device generates second interrupt and changes status register.  Second
interrupt is never delivered because the ->eoi hasn't been called yet.

I plan to keep using the edge handler which solves this race by
calling mask_ack().  For MSIs without mask bits, it will do nothing.
Then when it calls unmask (before handling the second interrupt), we
call the chip->ack() for that IRQ.  We'll never miss a pending interrupt.
The machine has booted ... let's see if it'll work under stress.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
