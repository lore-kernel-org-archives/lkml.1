Return-Path: <linux-kernel-owner+w=401wt.eu-S1761063AbXKPRKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063AbXKPRKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXKPRKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:10:47 -0500
Received: from empbedex1.empirix.com ([12.38.203.54]:19368 "EHLO
	empbedex1.empirix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbXKPRKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:10:46 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.23.1 - sata_mv (7042) hang with large file operations
Date: Fri, 16 Nov 2007 12:07:24 -0500
Message-ID: <BD261180E6D35F4D9D32F3E44FD3D9010AB2D7CF@EMPBEDEX.empirix.com>
In-Reply-To: <473CC4B8.4090607@rtr.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.23.1 - sata_mv (7042) hang with large file operations
Thread-Index: Acgn1Oi65dK9UaCqQO6yalNntaAc6gAnRQfQ
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com> <4728A816.8020608@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010AAE852F@EMPBEDEX.empirix.com> <473B36D7.8000205@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE8585@EMPBEDEX.empirix.com> <473B44CB.6010209@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE89CA@EMPBEDEX.empirix.com> <473B76E0.7010500@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE911D@EMPBEDEX.empirix.com> <473C7625.2040300@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AB2CFF0@EMPBEDEX.empirix.com> <473CC4B8.4090607@rtr.ca>
From: "Morrison, Tom" <tmorrison@empirix.com>
To: "Mark Lord" <liml@rtr.ca>
Cc: "Jeff Garzik" <jeff@garzik.org>, <linux-ide@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Nov 2007 17:07:29.0094 (UTC) FILETIME=[2B2F7660:01C82873]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

I've ported the old sataMV driver (version 3.6) to the 2.6.23.1 
kernel - and it works - no problems with a full mem=4000M (4Gig). 

The only problem with this is that it is MUCH slower than the 
sata_mv driver which - by this test - definitely has some 
bug/dependency that gets broken when the physical memory 
overlaps its memory I/O locations (and should be iomapped &
dma mapped to a separate space up in 0xC_xxxx_xxxx)...

Time to dig in and debug this driver! UGH!

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
<snip patch that has no affect>
