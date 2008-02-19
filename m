Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYBSKtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYBSKtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYBSKtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:49:23 -0500
Received: from www.tglx.de ([62.245.132.106]:52704 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYBSKtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:49:23 -0500
Date: Tue, 19 Feb 2008 11:49:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [BUG][RFC][GENERIC IRQ] linux-2.6.24 (delayed) disable IRQ
 feature not functional for handle_simple_irq
In-Reply-To: <600D5CB4DFD93545BF61FF01473D11AC125CCE48@limkexm2.ad.analog.com>
Message-ID: <alpine.LFD.1.00.0802191143050.7583@apollo.tec.linutronix.de>
References: <600D5CB4DFD93545BF61FF01473D11AC125CCE48@limkexm2.ad.analog.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008, Hennerich, Michael wrote:
> Thomas,
> 
> I have reasonable doubt that the delayed disable feature on
> linux-2.6.24 for handle_simple_irq is broken.
>
> In 2.6.22 there was something like this:
> 
> 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
> 		if (desc->chip->mask)
> 			desc->chip->mask(irq);
> ...
> 
> However in 2.6.24 the "DISABLED" IRQ in case it happens is never going to be masked.  
> 
> 	if (unlikely(!action || (desc->status & IRQ_DISABLED)))
> 		goto out_unlock;
> 
> 
> I see a disabled IRQ being invoked in an endless loop.

Simple irq's are special, see the comment above handle_simple_irq:

Simple interrupts are either sent from a demultiplexing interrupt
handler or come from hardware, where no interrupt hardware control
is necessary.

Note: The caller is expected to handle the ack, clear, mask and
unmask issues if necessary.

Simple irqs are used for low level demultiplex handlers, where the full
control of the irqchip is in the low level handler.

See also the commit log of 971e5b35fb02c5088d49e6c024aab73582a35b71

    In commit 76d2160147f43f982dfe881404cfde9fd0a9da21 lazy irq disabling
    was implemented, and the simple irq handler had a masking set to it.
    
    Remy Bohmer discovered that some devices in the ARM architecture
    would trigger the mask, but never unmask it. His patch to do the
    unmasking was questioned by Russell King about masking simple irqs
    to begin with. Looking further, it was discovered that the problems
    Remy was seeing was due to improper use of the simple handler by
    devices, and he later submitted patches to fix those. But the issue
    that was uncovered was that the simple handler should never mask.
    
    This patch reverts the masking in the simple handler.

Thanks,

	tglx
