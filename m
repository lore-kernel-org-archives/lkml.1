Return-Path: <linux-kernel-owner+w=401wt.eu-S932088AbYGQREs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbYGQREs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbYGQREk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:04:40 -0400
Received: from www.tglx.de ([62.245.132.106]:53917 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756400AbYGQREk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:04:40 -0400
Date: Thu, 17 Jul 2008 19:04:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Wilcox <matthew@wil.cx>
cc: David Vrabel <david.vrabel@csr.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: PCI: MSI interrupts masked using prohibited method
In-Reply-To: <20080717161108.GS25255@parisc-linux.org>
Message-ID: <alpine.LFD.1.10.0807171900200.4316@apollo.tec.linutronix.de>
References: <4860D09D.4060801@csr.com> <4864DA54.6000205@csr.com> <200806271007.26248.jbarnes@virtuousgeek.org> <200807161243.03360.jbarnes@virtuousgeek.org> <20080716195853.GL25255@parisc-linux.org> <487F45C0.2080201@csr.com> <20080717153917.GR25255@parisc-linux.org>
 <alpine.LFD.1.10.0807171745270.4316@apollo.tec.linutronix.de> <20080717161108.GS25255@parisc-linux.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008, Matthew Wilcox wrote:

> On Thu, Jul 17, 2008 at 05:58:26PM +0200, Thomas Gleixner wrote:
> > > This is a good thought, let's follow it through.  What if we simply make
> > > ->mask a no-op for devices which don't support mask bits?
> > 
> > Yep. You can also use fasteoi_handler, which just calls ->eoi() after
> > the handler.
> 
> I think that exposes us to a race.
> 
> CPU takes the first interrupt, calls handle_fasteoi_irq().  That
> calls handle_IRQ_event() which calls the device's interrupt handler.
> Interrupt handler reads status register to determine what to do next.
> Device generates second interrupt and changes status register.  Second
> interrupt is never delivered because the ->eoi hasn't been called yet.

Yeah, I know. The question is how the hardware works; there is fasteoi
capable hardware around (not on x86) which works with edge type
interrupts.
 
> I plan to keep using the edge handler which solves this race by
> calling mask_ack().  For MSIs without mask bits, it will do nothing.

Ah, there are ones w/o a mask bit. That detail slipped through.

Thanks,

	tglx
