Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYCPVHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYCPVHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 17:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbYCPVHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 17:07:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534AbYCPVHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 17:07:01 -0400
Date: Sun, 16 Mar 2008 14:06:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Anders Eriksson <aeriksson@fastmail.fm>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc4
In-Reply-To: <20080316203109.50e8c526@core>
Message-ID: <alpine.LFD.1.00.0803161353010.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080316140118.891732DC044@tippex.mynet.homeunix.org> <alpine.LFD.1.00.0803160924580.3020@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com>
 <alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org> <20080316185602.79064f7c@core> <alpine.LFD.1.00.0803161238190.3020@woody.linux-foundation.org> <20080316203109.50e8c526@core>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Mar 2008, Alan Cox wrote:
>
> > A _lot_ of chips require you to clear the DRQ by taking the data they 
> > have.
> 
> Almost none and mostly very old ones.

Well, I admittedly haven't been involved in IDE in about a decade, so 
yeah, maybe it's simply no longer true. That said, if the second bisection 
was accurate (which is admittedly a rasonably big "if"), it really looks 
like it would be related to the fact that we used to empty the data buffer 
before handling errors for REQ_TYPE_ATA_CMD commands.

> Not in my experience having maintained a lot of ATA drivers for a very
> long time. In fact the changes for draining the DRQ went into libata only
> very recently because it was only when we had a distro sized userbase
> with PATA devices that it became apparent that a few corner case problems
> remained.

.. but as you noticed, it's almost never wrong to drain (the only chipset 
it's marked for is some broken pdc202xx one), and it definitely *is* wrong 
not to drain.

Also, one reason you'd not necessarily even see this is that with DMA, 
this is a non-issue (since the hardware DMA engine will be doing all the 
draining), so in order to ever see this you have to still use PIO _and_ 
you have to see IDE command errors in the first place _and_ you have to 
have a device that actually keeps DRQ enabled even at an error.

All of which are hopefully fairly rare by now (and getting rarer, at last 
for the PIO one).

I also wouldn't be entirely surprised if the DRQ behavior may even be 
command-specific, with the regular data path for read/write quite possibly 
being different from the special commands that go through some internal 
drive firmware logic paths.

So I could well imagine (for example) that when a drive raises an IO error 
due to a read or write fault, the DRQ line will be cleared by the drive, 
but that special commands might have some firmware-directed separate FIFO 
that needs draining.

				Linus
