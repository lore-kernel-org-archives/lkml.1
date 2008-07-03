Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbYGCHII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbYGCHII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbYGCG5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:52824 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbYGCDZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 23:25:32 -0400
Subject: Re: Multiple MSI
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org, Michael Ellerman <michaele@au1.ibm.com>
In-Reply-To: <20080703024445.GA14894@parisc-linux.org>
References: <20080703024445.GA14894@parisc-linux.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 13:24:29 +1000
Message-Id: <1215055469.21182.70.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 20:44 -0600, Matthew Wilcox wrote:
> At the moment, devices with the MSI-X capability can request multiple
> interrupts, but devices with MSI can only request one.  This isn't an
> inherent limitation of MSI, it's just the way that Linux currently
> implements it.  I intend to lift that restriction, so I'm throwing out
> some idea that I've had while looking into it.

Interesting. I've been thinking about that one for some time but
back then, the feedback I got left and right is that nobody cares :-)

I'm adding Michael Ellerman to the CC list, he's done a good part of the
PowerPC MSI stuff.

> First, architectures need to support MSI, and I'm ccing the people who
> seem to have done the work in the past to keep them in the loop.  I do
> intend to make supporting multiple MSIs optional (the midlayer code will
> fall back to supporting only a single MSI).

Ok.

> Next, MSI requires that you assign a block of interrupts that is a power
> of two in size (between 2^0 and 2^5), and aligned to at least that power
> of two.  I've looked at the x86 code and I think this is doable there
> [1]. I don't know how doable it is on other architectures.  If not, just
> ignore all this and continue to have MSI hardware use a single interrupt.

Well, it requires that for HW number. But I don't think it should
require that at API level (ie. for driver visible irq numbers). Some
architectures can fully remap between HW sources and "linux" visible IRQ
numbers and thus wouldn't have that limitation from an API point of
view.

> In a somewhat related topic, I really don't like the API for
> pci_enable_msix().  The all-or-nothing allocation and returning
> the number of vectors that could have been allocated is a bit kludgy,
> as is the existence of the msix_entry vector.  I'd like some advice on a
> couple of alternative schemes:
> 
> 1. pci_enable_msi_block(pdev, nr_irqs).  If successful, updates pdev->irq
> to be the base irq number; the allocated interrupts are from pdev->irq
> to pdev->irq + nr_irqs - 1.  If it fails, return the number of
> interrupts that could have been allocated.

That would constraint the linux IRQ numbers to be a linear block just
like the HW numbers. Better than having them be a power-of-two aligned
but still a restriction on SW number allocation, though it's probably
not as bad as the underlying HW limitation.

> 2. pci_enable_msi_block(pdev, nr_irqs, min_irqs).  Will allocate at
> least min_irqs or return failure, otherwise same as above.

I prefer 2.

> My design is largely influenced by the AHCI spec where the device can
> potentially cope with any number of MSI interrupts allocated and will
> use them as best it can.  I don't know how common that is.
> 
> One thing I do want to be clear in the API is that the driver can ask
> for any number of irqs, the pci layer will round up to the next power of
> two if necessary.

Well, that's where I'm not happy. The API shouldn't expose the
"power-of-two" thing. The numbers shown to drivers aren't in the same
space as the source numbers as seen by the HW on many architectures and
thus don't need to have the same constraints.


> I don't quite understand how IRQ affinity will work yet.  Is it feasible
> to redirect one interrupt from a block to a different CPU?  I don't even
> understand this on x86-64, let alone the other four architectures.  I'm
> OK with forcing all MSIs in the same block to move with the one that was
> assigned a new affinity if that's the way it has to be done.

It's very implementation specific. IE. On most powerpc implementations,
MSI just route via a decoder to sources of the existing interrupt
controller so we can control per-source affinity at that level. Some x86
seem to require different base addresses which makes it mostly
impossible to spread them I believe (maybe that's why people came up
with MSI-X ?)

> I'll leave it at that for now.  I do have some other thoughts and a
> half-baked implementation, but this should be enough to be going along
> with.
> 
> [1] The current scheme for assigning vectors on x86-64 will tend to
> fragment the space.  However, the number of interrupts actually requested
> on desktop-sized machines remains relatively small in comparison to the
> number of vectors available, and it is to be hoped that more and more
> devices will use MSI anyway.
> 

Cheers,
Ben.


