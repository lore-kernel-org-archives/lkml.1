Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbXKWUk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbXKWUk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 15:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbXKWUkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 15:40:12 -0500
Received: from rtr.ca ([76.10.145.34]:4988 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbXKWUkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 15:40:10 -0500
Message-ID: <47473AA8.2050908@rtr.ca>
Date: Fri, 23 Nov 2007 15:40:08 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Morrison, Tom" <tmorrison@empirix.com>
Cc: Mark Lord <liml@rtr.ca>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
References: <47463534.9010100@shaw.ca> <4746F02D.2060204@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D901053E8542@EMPBEDEX.empirix.com> <474711FE.8040805@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D901053E8543@EMPBEDEX.empirix.com>
In-Reply-To: <BD261180E6D35F4D9D32F3E44FD3D901053E8543@EMPBEDEX.empirix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark wrote:
> Yeah, I kind of had your reports in mind when I asked that.  :)
> 
> On a related note, I now have lots of Marvell (sata_mv) hardware here,
> and an Intel CPU/chipset box with physical RAM above the 4GB boundary.

Morrison, Tom wrote:
> Yes, I believe that - otherwise, this problem would have
> been a crisis a LONG time ago...:-)
>  
> But I do have some more questions in relationship to how 
> things are mapped in your environment. I have a flat memory 
> map (i.e.: the full 0x0 -- 0x1_0000_0000 is passed to the 32bit 
> Linux kernel without any 'holes' and/or reserved areas).
>  
> Does your Intel memory map have this same type of flat memory 
> model (and thus allow use of the FULL lower 4Gig) - or does it 
> reserve areas of lower 4Gig for devices and such - if not - where 
> are these reserved areas - and how do the relate to the I/O memory
> map for the device?
>  
> In other words, I would be very interested in seeing the memory 
> map & the PCI memory mapping to see if any overlap/correspond 
> to reserve areas of lower 4 Gig (in a linux 32bit mode)...
...

I believe that only 2GB or so of the 4GB RAM appears below the 4GB boundary.
The rest is accessed above 4GB, using Intel's 36-bit PAE functionality.

I think what you want to see is /proc/mtrr, annotated below by me:

reg00: base=0x080000000 (2048MB), size=2048MB: uncachable, count=1  I/O space
reg01: base=0x000000000 (   0MB), size=4096MB: write-back, count=1  first 2GB of RAM + I/O space
reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1  third GB of RAM
reg03: base=0x140000000 (5120MB), size= 512MB: write-back, count=1  portion of 4th GB of RAM
reg04: base=0x160000000 (5632MB), size= 256MB: write-back, count=1  portion of 4th GB of RAM
reg05: base=0x170000000 (5888MB), size= 128MB: write-back, count=1  portion of 4th GB of RAM
reg06: base=0x178000000 (6016MB), size=  64MB: write-back, count=1  portion of 4th GB of RAM
reg07: base=0x0af800000 (2808MB), size=   8MB: uncachable, count=1  (?) dunno

>From that, the visible RAM should be 2048 + 1024 + 512 + 256 + 128 + 64 = 3968MB.
In /proc/meminfo, it reports MemTotal of 4067260kB, which divided by 1024 gives 3971MB.

The BIOS reports 4024MB.

But the MTRR values above do make it rather clear that nearly half the RAM
requires 33-bit physical addressing for access.

Cheers
