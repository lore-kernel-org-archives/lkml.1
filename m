Return-Path: <linux-kernel-owner+w=401wt.eu-S1764141AbXFAUBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764141AbXFAUBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762206AbXFAUAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:00:55 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:56901 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763472AbXFAUAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:00:54 -0400
Date: Fri, 1 Jun 2007 13:00:49 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] quiet down swiotlb warnings
Message-ID: <20070601200049.GK12143@andrew-vasquezs-computer.local>
References: <466057B1.9090309@redhat.com> <p73odjzbism.fsf@bingen.suse.de> <20070601181225.GA16460@infradead.org> <20070601193703.GI7217@one.firstfloor.org> <466075D1.8080807@redhat.com> <20070601194734.GJ7217@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601194734.GJ7217@one.firstfloor.org>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 01 Jun 2007 20:00:17.0425 (UTC) FILETIME=[79CB3810:01C7A487]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007, Andi Kleen wrote:

> On Fri, Jun 01, 2007 at 03:38:57PM -0400, Rik van Riel wrote:
> > Andi Kleen wrote:
> > 
> > >An pci_map_sg failing typically leads to an IO error and we've
> > >always printk'ed those. Otherwise people will wonder why they
> > >get EIO.
> > 
> > In some situations.  In this case the qla2xxx driver uses
> > the pci_map_sg() failure as a throttling mechanism and
> 
> First WTF does it need swiotlb anyways? QA hardware should
> be definitely DAC capable, shouldn't it?

yes, the card can support 64bit DMA transfers. but in this case the
'required' DMA mask returned from dma_get_required_mask() states that a
32bit mask would suffice.

Here's a snippet from the bugzilla report
(https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=219216):

        QLogic Fibre Channel HBA Driver
        PCI: Enabling device 0000:1f:00.0 (0140 -> 0143)
        ACPI: PCI Interrupt 0000:1f:00.0[A] -> GSI 16 (level, low) -> IRQ 16
        qla2xxx 0000:1f:00.0: Found an ISP2432, irq 16, iobase 0xffffc20000020000
        *** qla2x00_config_dma_addressing: required_mask set to 000000007fffffff.
        *** qla2x00_config_dma_addressing: required_mask has no high-dword bits set.
        *** qla2x00_config_dma_addressing: set consistent 64bit mask returned 0.
        *** qla2x00_config_dma_addressing: defaulting to 32bit mask/consistent-mask.
        qla2xxx 0000:1f:00.0: Configuring PCI space...

	Which tells me that a 32bit DMA mask is being set for dma_set_mask()
	and pci_set_consistent_dma_mask() since dma_get_required_mask() is
	returning back 7fffffff -- no upper-dword bits set...
	...

> > printing out all the warnings will actually slow down the
> > system.
> 
> Another reason is that there is a lot of code that
> still doesn't check the return values and when that
> happens you might get data corruption too.
> 
> > 
> > Andi, what do you propose as a solution?
> 
> A different interface; like I wrote in my earlier mail.
> 
> Another probabibility would be to have a blocking interface
> to swiotlb that won't fail. That would be the better solution
> long term, but i was told it is hard to fit into some current
> driver interfaces.
