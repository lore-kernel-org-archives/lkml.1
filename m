Return-Path: <linux-kernel-owner+w=401wt.eu-S932309AbYGCHGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbYGCHGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYGCG5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:42 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49256 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYGCCpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 22:45:04 -0400
Date: Wed, 2 Jul 2008 20:44:46 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-pci@vger.kernel.org
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Multiple MSI
Message-ID: <20080703024445.GA14894@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At the moment, devices with the MSI-X capability can request multiple
interrupts, but devices with MSI can only request one.  This isn't an
inherent limitation of MSI, it's just the way that Linux currently
implements it.  I intend to lift that restriction, so I'm throwing out
some idea that I've had while looking into it.

First, architectures need to support MSI, and I'm ccing the people who
seem to have done the work in the past to keep them in the loop.  I do
intend to make supporting multiple MSIs optional (the midlayer code will
fall back to supporting only a single MSI).

Next, MSI requires that you assign a block of interrupts that is a power
of two in size (between 2^0 and 2^5), and aligned to at least that power
of two.  I've looked at the x86 code and I think this is doable there
[1]. I don't know how doable it is on other architectures.  If not, just
ignore all this and continue to have MSI hardware use a single interrupt.

In a somewhat related topic, I really don't like the API for
pci_enable_msix().  The all-or-nothing allocation and returning
the number of vectors that could have been allocated is a bit kludgy,
as is the existence of the msix_entry vector.  I'd like some advice on a
couple of alternative schemes:

1. pci_enable_msi_block(pdev, nr_irqs).  If successful, updates pdev->irq
to be the base irq number; the allocated interrupts are from pdev->irq
to pdev->irq + nr_irqs - 1.  If it fails, return the number of
interrupts that could have been allocated.

2. pci_enable_msi_block(pdev, nr_irqs, min_irqs).  Will allocate at
least min_irqs or return failure, otherwise same as above.

My design is largely influenced by the AHCI spec where the device can
potentially cope with any number of MSI interrupts allocated and will
use them as best it can.  I don't know how common that is.

One thing I do want to be clear in the API is that the driver can ask
for any number of irqs, the pci layer will round up to the next power of
two if necessary.

I don't quite understand how IRQ affinity will work yet.  Is it feasible
to redirect one interrupt from a block to a different CPU?  I don't even
understand this on x86-64, let alone the other four architectures.  I'm
OK with forcing all MSIs in the same block to move with the one that was
assigned a new affinity if that's the way it has to be done.

I'll leave it at that for now.  I do have some other thoughts and a
half-baked implementation, but this should be enough to be going along
with.

[1] The current scheme for assigning vectors on x86-64 will tend to
fragment the space.  However, the number of interrupts actually requested
on desktop-sized machines remains relatively small in comparison to the
number of vectors available, and it is to be hoped that more and more
devices will use MSI anyway.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
