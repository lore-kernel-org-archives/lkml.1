Return-Path: <linux-kernel-owner+w=401wt.eu-S1030617AbXAZCYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030617AbXAZCYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 21:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030708AbXAZCYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 21:24:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60149 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030617AbXAZCYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 21:24:14 -0500
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
	controllers
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain>
	 <1169741658.3593.98.camel@shinybook.infradead.org>
	 <20070125172739.0c990a9a@localhost.localdomain>
	 <Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
	 <1169770985.3593.146.camel@shinybook.infradead.org>
	 <Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jan 2007 10:23:58 +0800
Message-Id: <1169778239.3593.195.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 17:28 -0800, Linus Torvalds wrote:
> 
> On Fri, 26 Jan 2007, David Woodhouse wrote:
> > 
> > You're thinking of MMIO, while the case we were discussing was PIO. My
> > laptop is perfectly happy to assign PIO resources from zero.
> 
> I was indeed thinking MMIO, but I really think it should extend to PIO 
> also. It certainly is (again) true on PC's, where the low IO space is 
> special and reserved for motherboard/system devices.

As you wish. 

There's a trade-off to be made. I happen to disagree with your choice --
you seem to want to introduce special cases and new layers of
'translation', and in some (admittedly, non-PC and relatively rare)
cases reduce functionality just to account for the fact that Linux
driver authors are fairly incompetent, and I think that's the wrong
choice.

So although I've mostly given up on interrupts¹, I reserve the right to
object if the "zero is not a real number" fallacy extends itself into
new areas. The thing about PIO addresses is an example of that. The
ide-cs and pata_pcmcia drivers (and indeed most other drivers AFAICT;
certainly all PCMCIA drivers I've used in my laptop) work _fine_ with
their main PIO address being zero. This thread started when I noticed
pata_pcmcia getting it wrong if its _BMDMA_ I/O range is zero.

Certainly, the resource code does not know about this newly-invented
special case for PIO address zero and is happy to assign it.

> > It doesn't need to be per-architecture; it can just be -1.
> 
> Bollocks. People tried that. People tried to force this idiotic notion of 
> "NO_IRQ" down my throat for several years. I even accepted it.
> 
> And then, after several years, when it was clear that it still didn't 
> work, and drivers just weren't getting updated, it was time to just face 
> reality: if the choice is between 0 and -1, 0 is simply much easier for 
> the bulk of the code.

The quality of our drivers is low; I'm fully aware that trying to
improve driver quality is a quixotic task. But where do we draw the
line? Should we abandon the dma-mapping stuff too? Declare that page
zero is a special case and you can't DMA to it? Should we try to make
every PCI write also do a read in order to flush posted writes, because
people can't cope with the real world?

> Live with it, or don't. I really don't care what you do on your hardware. 
> But if you can't face that
> 
> 	if (!dev->irq)
> 		..
> 
> is simpler for people to write, and that it's what we've done for a long 
> time, then that really is YOUR problem.

Even userspace people seem to cope with it in the case of file
descriptors. Kernel people have to cope too, for stuff like DMA
addresses.

> And I bet there are PIO devices out there that consider address zero to be 
> disabled. For EXACTLY the same reason.

> (And yes, hardware actually tends to do the same thing. For PCI irq 
> routing registers, an irq value of 0 pretty much universally means 
> "disabled". In fact, even your lovely Cardbus example actually is an 
> example of exactly this: the very IO limit registers are DEFINED IN 
> HARDWARE to special-case address zero - so that making the base/limit 
> registers be zero actually disables the IO window, rather than making it 
> mean "four IO bytes at address zero").

My example was 16-bit PCMCIA (actually CompactFlash), and it's
_certainly_ not true in that case. Devices often don't bother to decode
address lines higher than the two or three they need to tell which of
their registers is being accessed; they let the socket do the equivalent
of the 'chip select' decode.

-- 
dwmw2

¹ Mostly. I still wonder occasionally if we could use _pointers_ in the
generic code, and let drivers deal with a (struct irq_desc *) instead of
just a number. Since the old system of ISA IRQ numbering is fairly out
of date now and we're starting to recognise the fact that IRQs are a 
_tree_, we might get away with it. And it would let us preserve the special
case for NULL -- but I haven't had time to fully work through the
implications. 

