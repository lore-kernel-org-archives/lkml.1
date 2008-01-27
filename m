Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYA0SPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYA0SPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755904AbYA0SPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:15:22 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:55196 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbYA0SPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:15:20 -0500
Date: Sun, 27 Jan 2008 12:17:17 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
 sound card
In-reply-to: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no>
To: Avuton Olrich <avuton@gmail.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>, Li Shaohua <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Renninger <trenn@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Linux-Kernel," <linux-kernel@vger.kernel.org>,
       Alsa-Devel <alsa-devel@alsa-project.org>
Message-id: <479CCAAD.4080706@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avuton Olrich wrote:
> With v2.6.24 my second ALSA sound device stopped working.
> 
> After bisection it says this was the offending commit.
> 
> a7839e960675b549f06209d18283d5cee2ce9261 is first bad commit
> commit a7839e960675b549f06209d18283d5cee2ce9261
> Author: Zhao Yakui <yakui.zhao@intel.com>
> Date:   Wed Nov 28 16:21:21 2007 -0800
> 
>     PNP: increase the maximum number of resources
> 
>     On some systems the number of resources(IO,MEM) returnedy by PNP device is
>     greater than the PNP constant, for example motherboard devices.  It brings
>     that some resources can't be reserved and resource confilicts.  This will
>     cause PCI resources are assigned wrongly in some systems, and cause hang.
>     This is a regression since we deleted ACPI motherboard driver and use PNP
>     system driver.
> 
>     [akpm@linux-foundation.org: fix text and coding-style a bit]
>     Signed-off-by: Li Shaohua <shaohua.li@intel.com>
>     Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
>     Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
>     Cc: Thomas Renninger <trenn@suse.de>
>     Cc: <stable@kernel.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> The audio device is 00:1b.0 (see my lspci -vvv output), the other
> audio device works fine.
> 
> http://avuton.googlepages.com/v2.6-before (dmesg revision before)
> http://avuton.googlepages.com/v2.6-after (dmesg broken revision)
> http://avuton.googlepages.com/lspci-vvv
> http://avuton.googlepages.com/config (from the broken revision)
> http://avuton.googlepages.com/iomem
> http://avuton.googlepages.com/ioports

Here's why the driver fails to load:

[   31.133060] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, 
low) -> IRQ 22
[   31.133141] PCI: Unable to reserve mem region #1:4000@febf8000 for 
device 0000:00:1b.0
[   31.133197] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[   31.133244] HDA Intel: probe of 0000:00:1b.0 failed with error -16

The iomem location of the HDA controller conflicts with this reservation 
by the BIOS:

[   22.906654] system 00:08: iomem range 0xfebfa000-0xfebfac00 has been 
reserved

There was a patch floating around to ignore PnPACPI reservations which 
conflict with PCI BARs, which appears to be what's happening in this 
case. That patch originally worked for any board, but was later made 
specific to a certain Supermicro motherboard which had the sata_nv 
controller MMIO regions marked as reserved, preventing the driver from 
loading. We may need a more general solution. See:

https://bugzilla.redhat.com/show_bug.cgi?id=313491
