Return-Path: <linux-kernel-owner+w=401wt.eu-S1766013AbXKORR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766013AbXKORR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765727AbXKORRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:17:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:43575 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765689AbXKORRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:17:12 -0500
Date: Thu, 15 Nov 2007 18:14:18 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <liml@rtr.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071115181418.GA6603@ucw.cz>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org> <4739ADA2.4060604@rtr.ca> <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473C7495.40805@rtr.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I have been reporting this off and on since 2.6.23 was released.
> This problem was not apparent up to perhaps 2.6.23-rc8,
> but definitely became common in 2.6.23 and 2.6.23.1.
> 
> Most of the time, a resume-from-RAM on my notebook takes about 2.1 seconds
> of kernel time to complete.
> 
> Once in a while, it takes *much* longer, in the 14-20 second range.
> These long events *seem* to be mostly after the notebook has been
> in suspend for a longish time, but there's really nothing consistent here.
> 
> So git-bisect isn't going to work for this one.   I recently rebuilt the 
> kernel
> to include printk timestamps, and then it went 2 days without the issue 
> happening,
> until this morning (after an overnight suspend) finally.
> 
> The machine is a Dell Inspiron 9400, Intel chipset + Core2Duo 2.1GHZ w/3GB 
> DDR2.
> PCIe express chipset, ATI graphics, SATA hard drive.
> 
> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT 
> Express Memory Controller Hub (rev 03)
> 00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT 
> Express PCI Express Root Port (rev 03)
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
> Definition Audio Controller (rev 01)
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 
> 1 (rev 01)
> 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 
> 2 (rev 01)
> 00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 
> 4 (rev 01)
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 
> (rev 01)
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 
> (rev 01)
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 
> (rev 01)
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 
> (rev 01)
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
> Controller (rev 01)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
> 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface 
> Bridge (rev 01)
> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial 
> ATA Storage Controller IDE (rev 01)
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 
> 01)
> 01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility 
> X1400
> 03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX 
> (rev 02)
> 03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832
> 03:01.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 
> SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19)
> 03:01.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 01)
> 03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host 
> Adapter (rev 0a)
> 03:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
> 0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network 
> Connection (rev 02)
> 
> There's also a USB2 hub connected, with the Logitech mouse being the
> only thing plugged into it at present.
> 
> The best clue I have of what is happening, other than that it was first
> seen during the late 2.6.23-rc* series, are the following two sets of
> kernel logs.  The first set is from a "normal" fast wake-up,
> and the second set is from the "slow" wake-up seen this morning.
> 
> Both logs show the same information, in pretty much the same order.
> The BIG difference is a bunch of unexplained pauses of exactly 1-second
> each that occur during the slow wakeup.
> 
> The only other difference is that the SATA disk messages are placed
> differently within the two logs.  I'm thinking on that one but it
> doesn't look significant to me.
> 
> The real question is, why the 1-sec pauses?

Can you try nohz=off highres=off? Strange stuff is happening with
nohz.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
