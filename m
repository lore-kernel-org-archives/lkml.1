Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbYGYNnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbYGYNnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 09:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYGYNnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 09:43:10 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44022 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYGYNnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:43:09 -0400
Date: Fri, 25 Jul 2008 07:42:52 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Vrabel <david.vrabel@csr.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: PCI: MSI interrupts masked using prohibited method
Message-ID: <20080725134252.GG6701@parisc-linux.org>
References: <4860D09D.4060801@csr.com> <48807166.9010006@csr.com> <20080722155629.1160635e@brian.englab.brq.redhat.com> <200807221052.26879.jbarnes@virtuousgeek.org> <20080725152918.43bf3100@brian.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725152918.43bf3100@brian.englab.brq.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 03:29:18PM +0200, Michal Schmidt wrote:
> The interesting thing is that I can see Destination ID bits of MSI
> Message Address change correctly in lspci output. But the interrupt is
> still delivered load-balanced to all CPUs even though the Destination
> ID identifies the single CPU I asked for. It seems the device only
> takes the new Message Address setting into account when the MSI Enable
> bit in the Message Control register is changed from 0 to 1. I tested
> this by setting the MSI enable bit to 0 and then immediately back to 1
> at the end of io_apic_64.c:set_msi_irq_affinity().
> 
> Is this a permitted behaviour for the device? I couldn't find anything
> in the PCI specification that would mentioned it.

I don't think that's necessary.  However, the thought occurs that we
ought to disable MSI, then write the address, then re-enable MSI.  It
doesn't cause a problem at the moment because we don't change the
top 32 bits of the address (at least on any of my systems ..) but
theoretically if we were to use a 64-bit address, we would experience
MSIs being sent to an address that was a mixture of the top 32 bits of
the old address and the bottom 32 bits of the new address.

We definitely can already get tearing when we've written the lower
address register but not the data register yet (also true for MSIX, by
the way).  So we ought to fix this properly.

We have the problem that we might still get interrupts on the old
pin-based interrupt line (ie David's original problem).  I have a
feeling somebody needs to register a handler for the pin-based interrupt
to handle this.  One possibility would be for the MSI code to register a
handler that calls the driver's MSI handler.  I don't think that's a
good idea though -- the driver's MSI handler is able to make different
assumptions from the pin handler.  Do we want to make drivers register
an interrupt handler for the original interrupt number before they try
to set up MSI?  It's certainly not what the PCI spec people had in mind,
but they seem to have overlooked this problem.

Yuck.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
