Return-Path: <linux-kernel-owner+w=401wt.eu-S932449AbXKPNA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbXKPNA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 08:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbXKPNAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 08:00:50 -0500
Received: from empbedex1.empirix.com ([12.38.203.54]:5183 "EHLO
	empbedex1.empirix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbXKPNAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 08:00:48 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.23.1 - sata_mv (7042) hang with large file operations
Date: Fri, 16 Nov 2007 08:00:30 -0500
Message-ID: <BD261180E6D35F4D9D32F3E44FD3D9010AB2D234@EMPBEDEX.empirix.com>
In-Reply-To: <473CC4B8.4090607@rtr.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.23.1 - sata_mv (7042) hang with large file operations
Thread-Index: Acgn1Oi65dK9UaCqQO6yalNntaAc6gAeiV9Q
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com> <4728A816.8020608@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010AAE852F@EMPBEDEX.empirix.com> <473B36D7.8000205@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE8585@EMPBEDEX.empirix.com> <473B44CB.6010209@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE89CA@EMPBEDEX.empirix.com> <473B76E0.7010500@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE911D@EMPBEDEX.empirix.com> <473C7625.2040300@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AB2CFF0@EMPBEDEX.empirix.com> <473CC4B8.4090607@rtr.ca>
From: "Morrison, Tom" <tmorrison@empirix.com>
To: "Mark Lord" <liml@rtr.ca>
Cc: "Jeff Garzik" <jeff@garzik.org>, <linux-ide@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Nov 2007 13:00:34.0923 (UTC) FILETIME=[AD405BB0:01C82850]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This 'patch' did not work.

I tried setting the physical mem to just below the va addresses the
PEX is being assigned (0xea900000 (3753M) and everything works...

I set it to just above - and it gets miscellaneous boot problems....
like binfmt problems when attempting to insmod a module at boot time
("runaway loop modprobe binfmt_????" (?=I forgot to write down #) - this
was mem=3850M) or downright hanging after kernel has initialized and 
it says "freeing kernel memory" (i.e.: where it attempts to run init
on the root harddrive).

IMHO, this tells me that perhaps there is somewhere else in the sata_mv
code that is either modifying / accessing edma registers or something
like this - that just doesn't seem right!

I am going to try to port forward the driver that I know works and see
if there are still any problems...stay tuned!

Tom

-----Original Message-----
From: Mark Lord [mailto:liml@rtr.ca] 
Sent: Thursday, November 15, 2007 5:14 PM
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


--- old/drivers/ata/sata_mv.c	2007-10-12 12:43:44.000000000 -0400
+++ linux/drivers/ata/sata_mv.c	2007-11-15 17:12:24.000000000 -0500
@@ -685,7 +685,7 @@
 {
 	int rc;
 
-	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
+	if (0 && !pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
 		rc = pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK);
 		if (rc) {
 			rc = pci_set_consistent_dma_mask(pdev,
DMA_32BIT_MASK);
