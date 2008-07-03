Return-Path: <linux-kernel-owner+w=401wt.eu-S934033AbYGCHJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033AbYGCHJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYGCG6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:42252 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYGCEoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 00:44:54 -0400
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
In-Reply-To: <20080703035910.GB14894@parisc-linux.org>
References: <20080703024445.GA14894@parisc-linux.org>
	 <1215055469.21182.70.camel@pasglop>
	 <20080703035910.GB14894@parisc-linux.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 14:41:59 +1000
Message-Id: <1215060119.21182.77.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 21:59 -0600, Matthew Wilcox wrote:
> 
> 
> This is true and worth considering carefully.  Are IRQ numbers a scarce
> resource on PowerPC?  They are considerably less scarce than interrupt
> vectors are on x86-64.  How hard is it to make IRQ numbers an abundent
> resource?  Is it simply a question of increasing NR_IRQS?

Yes, indeed, they aren't really scarce... actually less than the
underlying HW vectors in most cases, so it isn't a big issue to add some
kind of constraint to the allocator.

> This cost should be traded off against the cost of allocating something
> like the msix_entry array in each driver that wants to use multiple MSIs,
> passing that array around, using it properly, etc.
> 
> It would make some sense to pass nr_irqs all the way down to arch code
> and let arch code take care of reserving the block of vectors (aligned
> appropriately).  That would conserve IRQ numbers, though not vectors.
> I think we have to consider excess vectors reserved.  If we don't, we
> could get into the situation where a device uses more interrupts than
> the driver thinks it will and problems ensue.

Ok, so I lift my objection there in the sense that allocating a linear
array of virtual numbers shouldn't be a problem (somebody remind me to
make NR_IRQS a config option one of these days on ppc, or help with just
getting rid of irq_desc array alltogether :-)

However, do you want to still keep the fact that they are power-of-2
aligned up to the API or can I just do a linear block allocation for
virtual number sand require drivers to do the appropriate
addition/subtraction to get the N'th one ? I will need to allocate
appropriately aligned HW numbers but that's done via different
mechanisms (and in some case not even under full linux control, ie,
hypervisor/firmware does it on pSeries).

> By the way, would people be interested in changing the MSI-X API to get
> rid of the msix_entry array?  If allocating consecutive IRQs isn't a
> problem, then we could switch the MSI-X code to use consecutive IRQs.

It would make a lot of code simpler...

Ben.


