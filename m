Return-Path: <linux-kernel-owner+w=401wt.eu-S966235AbXJQQGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966235AbXJQQGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 12:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966220AbXJQQEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 12:04:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37944 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966200AbXJQQEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 12:04:42 -0400
From: akepner@sgi.com
Date: Wed, 17 Oct 2007 09:03:27 -0700
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] dma: add dma_flags_set/get_*() interfaces
Message-ID: <20071017160327.GP5601@sgi.com>
References: <20071017014128.GJ5601@sgi.com> <20071016202728.81450e25.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016202728.81450e25.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[reply to the series of three mails below]

On Tue, Oct 16, 2007 at 08:27:28PM -0700, Andrew Morton wrote:
> On Tue, 16 Oct 2007 18:41:28 -0700 akepner@sgi.com wrote:
> 
> > +#define DMA_BARRIER_ATTR	0x1
> > +#ifndef ARCH_USES_DMA_ATTRS
> > +static inline int dma_flags_set_attr(u32 attr, enum dma_data_direction dir) 
> > +{
> > +	return dir;
> > +}
> 
> This function takes an `enum dma_data_direction' as its second arg, but your
> ia64 implementation takes an 'int'.
> 

This is because the dma_data_direction enum type isn't available 
at the point the ia64 implementation is defined. 


> > .....
> >  dma_addr_t sn_dma_map_single(struct device *dev, void *cpu_addr, size_t size,
> > -                          int direction)
> > +                          int flags)
> >  {
> >       dma_addr_t dma_addr;
> >       unsigned long phys_addr;
> >       struct pci_dev *pdev = to_pci_dev(dev);
> >       struct sn_pcibus_provider *provider = SN_PCIDEV_BUSPROVIDER(pdev);
> > +     int dmabarrier = dma_flags_get_attr(flags) & DMA_BARRIER_ATTR;
> 
> So we take an `enum data_direction' and then wedge it into a word alongside
> some extra flags?
> 
> Can we do something nicer than that?

Changing the type of the last argument to dma_map_* functions 
to be a bitmask? Or adding an additional argument? (Both of 
which you mention below.)

> > .....

> > +DMA_BARRIER_ATTR would be set when the memory region is mapped for DMA,
> > +e.g.:
> > +
> > +     int count;
> > +     int flags = dma_flags_set_attr(DMA_BARRIER_ATTR, DMA_BIDIRECTIONAL);
> > +     ....
> > +     count = dma_map_sg(dev, sglist, nents, flags);
> > +
> 
> Isn't this rather a kludge?

I prefer the term "hack".

> 
> What would be the cost of doing this cleanly and either redefining
> dma_data_direction to be a field-of-bits or just leave dma_data_direction
> alone (it is quite unrelated to this work, isn't it?) and adding new
> fields/arguments to manage this new functionality?

It'd be significantly more work to do change or add arguments 
to the dma_map_* functions. But if that's what I need to do to 
get this accepted, I'll back up and have another go at it.

-- 
Arthur

