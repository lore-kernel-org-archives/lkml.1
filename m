Return-Path: <linux-kernel-owner+w=401wt.eu-S933272AbYGCHIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272AbYGCHIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYGCG5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53075 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbYGCD71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 23:59:27 -0400
Date: Wed, 2 Jul 2008 21:59:10 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org, Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: Multiple MSI
Message-ID: <20080703035910.GB14894@parisc-linux.org>
References: <20080703024445.GA14894@parisc-linux.org> <1215055469.21182.70.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215055469.21182.70.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 01:24:29PM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2008-07-02 at 20:44 -0600, Matthew Wilcox wrote:
> > At the moment, devices with the MSI-X capability can request multiple
> > interrupts, but devices with MSI can only request one.  This isn't an
> > inherent limitation of MSI, it's just the way that Linux currently
> > implements it.  I intend to lift that restriction, so I'm throwing out
> > some idea that I've had while looking into it.
> 
> Interesting. I've been thinking about that one for some time but
> back then, the feedback I got left and right is that nobody cares :-)

The AHCI spec only includes MSI.  So I have a reason to care.

> I'm adding Michael Ellerman to the CC list, he's done a good part of the
> PowerPC MSI stuff.

Doh!  I was sure I added him to the CC list.  Sorry.

> > Next, MSI requires that you assign a block of interrupts that is a power
> > of two in size (between 2^0 and 2^5), and aligned to at least that power
> > of two.  I've looked at the x86 code and I think this is doable there
> > [1]. I don't know how doable it is on other architectures.  If not, just
> > ignore all this and continue to have MSI hardware use a single interrupt.
> 
> Well, it requires that for HW number. But I don't think it should
> require that at API level (ie. for driver visible irq numbers). Some
> architectures can fully remap between HW sources and "linux" visible IRQ
> numbers and thus wouldn't have that limitation from an API point of
> view.

This is true and worth considering carefully.  Are IRQ numbers a scarce
resource on PowerPC?  They are considerably less scarce than interrupt
vectors are on x86-64.  How hard is it to make IRQ numbers an abundent
resource?  Is it simply a question of increasing NR_IRQS?

This cost should be traded off against the cost of allocating something
like the msix_entry array in each driver that wants to use multiple MSIs,
passing that array around, using it properly, etc.

It would make some sense to pass nr_irqs all the way down to arch code
and let arch code take care of reserving the block of vectors (aligned
appropriately).  That would conserve IRQ numbers, though not vectors.
I think we have to consider excess vectors reserved.  If we don't, we
could get into the situation where a device uses more interrupts than
the driver thinks it will and problems ensue.


By the way, would people be interested in changing the MSI-X API to get
rid of the msix_entry array?  If allocating consecutive IRQs isn't a
problem, then we could switch the MSI-X code to use consecutive IRQs.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
