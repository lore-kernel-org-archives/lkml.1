Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbXKPLHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbXKPLHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 06:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbXKPLHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 06:07:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:37034 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755832AbXKPLHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 06:07:08 -0500
X-Authenticated: #1172751
X-Provags-ID: V01U2FsdGVkX19tPchVl+1tqTqqfwbc5OXCtDPK48l+WiIoe1V+UZ
	seQ/yARrCVTZNY
From: Rainer Koenig <Rainer.Koenig@gmx.de>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: How do I debug PCI resource allocation problems
Date: Fri, 16 Nov 2007 12:07:03 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <fa.JiGBAZR3XiDynnIaclFCUaV7kUk@ifi.uio.no> <4733A109.8070405@shaw.ca>
In-Reply-To: <4733A109.8070405@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711161207.03882.Rainer.Koenig@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 9. November 2007 00:51  Robert Hancock wrote:
> Rainer Koenig wrote:
> >
> > Ok, short description of the problem:
> >
> > I run 64-bit Linux using 2 GB of RAM, no problem at all. Then I turn off
> > the machine, add 2 more GB so that now I have 4 GB of RAM. Turning it on
> > I see the splashscreen of the boot loader, starting the kernel turns the
> > screen black and that's it. The machine comes up, I can even ssh to it
> > over the net. That is how I obtained the following data.

Just for the minutes. Problem solved. It was caused by wrong e820 information 
from the BIOS:

> > <4> BIOS-e820: 00000000df800000 - 00000000e0100000 (reserved)

That one overlaps with e0000000-efffffff which is the resource that 
then leads to this:
> > <3>PCI: Cannot allocate resource region 2 of device 0000:00:02.0

> Looks like the BIOS reserved part of that memory range already. Question
> is why vesafb is trying to reserve that range in the first place though.

Yep. 

> > Question: Memory region 2 at 120000000? That is beyond the 4GB boundary
> > and the BIOS guys I know told me that every PCI IOMEM region should
> > reside within the first 4 GBs! When running the machine with 2 GB only
> > lspci output looks like this for the VGA device:
>
> 64-bit capable PCI devices can indeed have BARs which can be located
> above 4GB. However, I can't see why lspci is detecting that from this
> configuration space: the BAR contents for region 2 are 20000008, which
> means prefetchable memory at 0x20000000 which can be located anywhere
> within 32-bit memory space. That doesn't make any sense though, since
> that's in the middle of RAM! Quite likely this bogus resource setting of
> the graphics controller is a large part of your problem. Question is
> who's doing this..

I compiled a debug kernel with lots of verbosity about PCI. That then 
reported:
<7>  got res [120000000:12fffffff] bus [120000000:12fffffff] flags 1208 for 
BAR 2 of 0000:00:02.0
<7>PCI: moved device 0000:00:02.0 resource 2 (1208) to 20000000

I guess that explains it a bit. Looks like with the "move" also the bytes that 
lspci -xx prints out are affected. 

Anyway, after we had enough information about what range was giving us 
problems the BIOS development was able to find and fix  the bug quite 
quickly. Installed new BIOS and problem was gone. :-)

Thanks anyway for the comments. 

Regards
Rainer
-- 
Rainer Koenig, Diplom-Informatiker (FH), Augsburg, Germany
