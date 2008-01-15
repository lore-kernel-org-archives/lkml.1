Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbYAOCYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbYAOCYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 21:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYAOCX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 21:23:58 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:45193 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024AbYAOCX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 21:23:56 -0500
Subject: Re: PROBLEM REMAINS: [sata_nv ADMA breaks
	ATAPI]	Crash	on	accessing DVD-RAM
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alexander <aledin@mail.ru>,
       linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <478C0F61.7030002@shaw.ca>
References: <fa.krOVfyFmB2aqGjJIoHCLmQxecWc@ifi.uio.no>
	 <478702C7.80401@shaw.ca> <47887982.6050805@mail.ru>
	 <47891426.1020604@shaw.ca> <1200170117.3656.66.camel@localhost.localdomain>
	 <47894785.2050508@shaw.ca> <1200180440.3656.76.camel@localhost.localdomain>
	 <47896BA8.4030609@shaw.ca> <20080113133317.50ad4bda@lxorguk.ukuu.org.uk>
	 <1200238725.3179.16.camel@localhost.localdomain>
	 <20080113162959.01d519db@lxorguk.ukuu.org.uk>
	 <1200243102.3179.27.camel@localhost.localdomain> <478C0F61.7030002@shaw.ca>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 20:23:43 -0600
Message-Id: <1200363823.3159.107.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 19:41 -0600, Robert Hancock wrote:
> James Bottomley wrote:
> > On Sun, 2008-01-13 at 16:29 +0000, Alan Cox wrote:
> >>> Yes, I concur for the short term.  The other two possible courses of
> >>> action either involve long discussions (the different device one) or
> >>> you'll never quite be sure you got all the paths (the GFP_DMA32 one).
> >>> At least with this one, you know everything will work.
> >> The different device one is tricky because the PCI layer is involved in
> >> mapping on some systems so you can't just magic up a platform device for
> >> it. Putting a mask on the block queue might perhaps work as a model
> >> which avoids breaking stuff by suprise, with the device left at 32bit
> >> masking.
> > 
> > Actually, you might be able to ... that's why I'm suggesting it.  There
> > are two pieces of information the arch layer needs to know:  what is the
> > dma_mask and where is the iommu/bridge/whatever.  When we went to the
> > generic dma_map_ API on parisc, we found you simply get the one from
> > struct device and for the other you walk up the device tree until you
> > find what you're looking for.
> > 
> > I'm not suggesting we invent a dummy pci_device ... I'm suggesting we
> > dma_map on the existing scsi_device, which is properly parented to the
> > pci_device.  The problem with this approach will be any architecture
> > which blindly expects dma_map converts to pci_dma_map; however, I'm not
> > sure we have any of those left.
> 
> I've tried the dumb solution of setting the mask on the PCI device (for 
> both ports) whenever an ATAPI device is detected, and ran into problems 
> with that. If we really need to keep the block queue bounce limit and 
> DMA mask the same, then we then have to set the bounce limit on both 
> ports as well. If you blindly do that from slave_config, though, then 
> you blow up since on the first port's initial slave_config the block 
> queue for the second port isn't allocated yet, so you'd have to detect 
> that case somehow. And if it's done via hotplug after the other port is 
> already in use, it'll be changing the limits on a port that's in active 
> use, which seems like it could be a bit racy.
> 
> So, any ideas? Maybe using the separate struct device is the easiest 
> solution, if it'll work..

Right, and the separate struct device exists already in the
scsi_device ... the problem currently is that this isn't the device we
map with, but it could easily become so ... provided the architectures
support it.

This isn't a quick fix solution ... it will involve quite a bit of
device use rethreading through both scsi and ata, so it might be wise to
get linux-arch buy in first.

James


