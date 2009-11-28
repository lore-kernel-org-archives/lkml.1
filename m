Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbZK1TWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbZK1TWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 14:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZK1TWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 14:22:15 -0500
Received: from kroah.org ([198.145.64.141]:59143 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZK1TWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 14:22:12 -0500
Date: Sat, 28 Nov 2009 11:19:32 -0800
From: Greg KH <greg@kroah.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Mikhail Malygin <mmalygin@ked.de>, Hans Werner <hwerner4@gmx.de>,
       Tejun Heo <tj@kernel.org>, Thomas Renninger <trenn@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Samsung N130 ATA exception after 5min uptime -- Phoenix
	FailSafe issue?
Message-ID: <20091128191932.GB24048@kroah.com>
References: <20091126164212.GA24421@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091126164212.GA24421@sig21.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 05:42:12PM +0100, Johannes Stezenbach wrote:
> Hi,
> 
> I'm refering to
> http://bugzilla.kernel.org/show_bug.cgi?id=14314
> and I still have this issue on a N130 with latest BIOS (05CM),
> running kernel 2.6.32-rc8 + wireless-testing.
> 
> BIOS Information
>         Vendor: Phoenix Technologies Ltd.
>         Version: 05CM.M011.20091013.JIP
>         Release Date: 10/13/2009
>         Address: 0xE6300
>         Runtime Size: 105728 bytes
>         ROM Size: 2048 kB
>         Characteristics:
>                 ISA is supported
>                 PCI is supported
>                 PNP is supported
>                 BIOS is upgradeable
>                 BIOS shadowing is allowed
>                 ESCD support is available
>                 ACPI is supported
>                 USB legacy is supported
>                 Smart battery is supported
>                 BIOS boot specification is supported
>                 Targeted content distribution is supported
>         BIOS Revision: 5.0
> 
> Around 5min after boot or resume if generates the following error:
> 
> [  302.364174] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [  302.364201] ata1.00: failed command: WRITE DMA
> [  302.364234] ata1.00: cmd ca/00:08:f7:01:1a/00:00:00:00:00/e0 tag 0 dma 4096 out
> [  302.364241]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [  302.364257] ata1.00: status: { DRDY }
> [  307.408107] ata1: link is slow to respond, please be patient (ready=0)
> [  312.392109] ata1: device not ready (errno=-16), forcing hardreset
> [  312.392138] ata1: soft resetting link
> [  312.574482] ata1.00: configured for UDMA/133
> [  312.574506] ata1.00: device reported invalid CHS sector 0
> [  312.574542] ata1: EH complete

This is because after 5 minutes, the BIOS implements C states in the
processor, which causes a "hic-up" in userspace.  Everything should be
fine after this, and most importantly, the power usage drops by a few
watts, which is most important.

> This also happens when booting with rdinit=/bin/sh, i.e. only running busybox sh
> inside initrd.  The error then appears when accessing the disk after the 5min
> period with dd if=/dev/sda of=/dev/null count=10000.

Yup, see above for why.

Samsung does this to make booting their BIOS faster.

> The link in comment #14 is dead but eventually I found
> http://download.opensuse.org/repositories/Moblin:/Base/openSUSE_11.1/src/kernel-source-2.6.31.6-37.1.src.rpm
> which contains the attached patch with a samsung_laptop driver.
> 
> I think it is weird that the Samsung BIOS has a special "SECLINUX" mode,
> but anyway the samsung_laptop driver works (the backlight control via ACPI
> also works with the 05CM BIOS, though).

Yes, but Samsung does not support ACPI at this time, even though it is
in their latest bios versions (experimental stuff, needed for Windows 7
mode or something...)

And yes, a "special" linux mode is weird, but at least they gave us
something that works :)

> However, it does not prevent the ATA exception.

Yup, it's not an issue though.

> (Side note about backlight level 0: I noticed that in Windows when you
> set the backlight to the lowest level, after a minute of inactivity
> the screen would dim one level more. Stupid -- why not allow the user
> to choose that level manually?)

Talk to samsung about this.  There is one more lower level the BIOS can
go to, which is what Windows does here.  Samsung doesn't want Linux to
use that mode at this time.  It only saves a bit less than .1W, so it's
not that big of a deal.

Glad it's all working for you now.

greg k-h
