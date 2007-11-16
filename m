Return-Path: <linux-kernel-owner+w=401wt.eu-S934302AbXKPAIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302AbXKPAIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765564AbXKPAIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:08:05 -0500
Received: from [12.38.203.54] ([12.38.203.54]:35974 "EHLO
	empbedex1.empirix.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1765554AbXKPAIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:08:04 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: 2.6.23.1 - sata_mv (7042) hang with large file operations
Date: Thu, 15 Nov 2007 19:07:56 -0500
Message-ID: <BD261180E6D35F4D9D32F3E44FD3D901053E853F@EMPBEDEX.empirix.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.23.1 - sata_mv (7042) hang with large file operations
Thread-Index: Acgn1Oi65dK9UaCqQO6yalNntaAc6gADjSsf
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com> <4728A816.8020608@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010AAE852F@EMPBEDEX.empirix.com> <473B36D7.8000205@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE8585@EMPBEDEX.empirix.com> <473B44CB.6010209@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE89CA@EMPBEDEX.empirix.com> <473B76E0.7010500@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE911D@EMPBEDEX.empirix.com> <473C7625.2040300@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AB2CFF0@EMPBEDEX.empirix.com> <473CC4B8.4090607@rtr.ca>
From: "Morrison, Tom" <tmorrison@empirix.com>
To: "Mark Lord" <liml@rtr.ca>
Cc: "Jeff Garzik" <jeff@garzik.org>, <linux-ide@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Nov 2007 00:08:01.0610 (UTC) FILETIME=[C0861AA0:01C827E4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of PCI (am no big expert on this)- I believe the code
allows you to address 32 bits at a time...you can see the the 
effectve address resource address is some where around 
0xea900000 - but, if you have PHYS_64BIT  & PTE_64BIT - 
you get resource_types of 64bits...that you can manipulate accordingly.
 
In the case of the eDMA - its 64bit dma operations - thus, you 
setup the hi portion (by shifting twice by 16 (you get compiler 
warnings if you try to shiftg the size of the offset - a bug IMHO))
and thus, can play the game I mentioned below and use the power 
of the PEX inbound/outbound translation windows to move your data 
correctly to the appropriate 32 bit location...
 
This game works fine very well for 2.6.11 + kernel  - there are a few 
more tests I need to do (like setting mem=<just below the PEX space> 
and see if it works correctly...and then try again just a little bit above 
PEX memory space (> ~0xea900000) - if it works below & doesn't work
above - it points to a problem with sata_mv doing some type of operation
outside the dma engine that is corrupting memory - 
 
Thats another issue how does memory dribble/scribbling (only side affect 
I can think of if something is going wrong with this translation)?
 
I'll try your 'patch' and see if that has any affect as well (and the
associated side-affects...)
 
t
 
 

________________________________

From: Mark Lord [mailto:liml@rtr.ca]
Sent: Thu 11/15/2007 5:14 PM
To: Morrison, Tom
Cc: Jeff Garzik; linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.1 - sata_mv (7042) hang with large file operations



Morrison, Tom wrote:
> The plot thickens - it looks like it might be some type
> of problem interacting with the setup of my 4Gig DDR memory
> and how I setup some translation windows in my MPC8548E
>
> I realized this morning that I have an inbound/ output PEX window
> Translation Setup for mapping all from/to PEX bus to outside
> the physical 4GIG memory space (i.e.: up at 0xC_xxxx_xxxx). Thus,
> all output operations that translation from 0xC_xxxx_xxxx to
> the pci 32 bit address of xxxx_xxxx) - and vice versa for for
> the inbound. Note: we also have a straight 1:1 translation mapping
> as well for the lower 4Gig - so that's why this worked without
> the below mentioned change...
>
> So, I changed the Request & Response Hi Addresses (which were
> Being shifted by 32 bits down anyways) and 'OR' that with my
> 0xC (so the effective 64bit DMA address is 0xC_xxxx_xxxx (where
> Xxxx_xxxx is the effective address). This was what we did to
> solve the problem with the Marvel Linux driver that we got from
> the Marvel site....
>
> This all works just fine with ONLY 2 gig of memory in the system
> (and still have these inbound/output pex translation windows),
> but fails when I put back the 4 Gig (and the 8Gig) DDR memory.
>
> Unfortunately, this still hasn't solved the problem though -
> so there is something else which I am not seeing?
..

I don't know much about how 32-bit PPC deals with memory addresses
that are more than 32-bits..

But does this patch have any effect:


--- old/drivers/ata/sata_mv.c   2007-10-12 12:43:44.000000000 -0400
+++ linux/drivers/ata/sata_mv.c 2007-11-15 17:12:24.000000000 -0500
@@ -685,7 +685,7 @@
 {
        int rc;

-       if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+       if (0 && !pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
                rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
                if (rc) {
                        rc = pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK);


