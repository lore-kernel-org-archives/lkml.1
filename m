Return-Path: <linux-kernel-owner+w=401wt.eu-S1757963AbXIERJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbXIERJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbXIERJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:09:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753561AbXIERJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:09:13 -0400
Date: Wed, 5 Sep 2007 10:07:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Tim Teulings" <rael@edge.ping.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: michal.k.k.piotrowski@gmail.com, rbrito@gmail.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       debian-powerpc@lists.debian.org, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org
Subject: Re: Sleep problems with kernels >= 2.6.21 on powerpc
Message-Id: <20070905100754.57ab4e3e.akpm@linux-foundation.org>
In-Reply-To: <46D72BC6.3020809@edge.ping.de>
References: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com>
	<6bffcb0e0708261621q25316becqce7b3ae2176f45a8@mail.gmail.com>
	<20070827065246.GA21220@ime.usp.br>
	<46D279E8.10001@edge.ping.de>
	<46D72BC6.3020809@edge.ping.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 30 Aug 2007 22:42:46 +0200 "Tim Teulings" <rael@edge.ping.de> wrote:
> Hello!
> 
> > I don't have traces at hand and due to lack of time cannot reproduce it 
> > up to tomorrow. However this hint may speed up your analysis!
> 
> Sorry for the delay, but my desktop PC had an urgent hard disk problem I 
> had to fix ASASP.
> 
> So here is the output from dmesg that suggested to me that firewire 
> might be a problem:

Straightforward regression, two reporters, nothing happening.

> > usb_endpoint usbdev2.2_ep81: PM: suspend 0->2, parent 2-1:1.0 already 2
> > usb_device usbdev1.1: PM: suspend 0->2, parent usb1 already 2
> > usb_endpoint usbdev1.1_ep81: PM: suspend 0->2, parent 1-0:1.0 already 2
> > hub 1-0:1.0: PM: suspend 2->2, parent usb1 already 2
> > usb_endpoint usbdev1.1_ep00: PM: suspend 0->2, parent usb1 already 2
> > eth2: Airport entering sleep mode
> > eth0: suspending, WakeOnLan disabled
> > pci_set_power_state(): 0002:20:0e.0: state=3, current state=5
> > firewire_ohci: pci_set_power_state failed with -22<3>pci_device_suspend(): pci_suspend+0x0/0x9c [firewire_ohci]() returns -22
> > suspend_device(): pci_device_suspend+0x0/0x98() returns -22
> > Could not suspend device 0002:20:0e.0: error -22
> > eth0: resuming
> > PHY ID: 4061e4, addr: 0
> > eth2: Airport waking up
> > eth2: New link status: Connected (0001)
> > hda: Enabling Ultra DMA 2
> > eth0: Link is up at 100 Mbps, full-duplex.
> > eth0: Pause is disabled
> > ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> > hdb: Enabling Ultra DMA 2
> > usb_endpoint usbdev1.1_ep00: PM: resume from 0, parent usb1 still 2
> > usb_endpoint usbdev1.1_ep81: PM: resume from 0, parent 1-0:1.0 still 2
> > usb_device usbdev1.1: PM: resume from 0, parent usb1 still 2
> > Driver sleep failed
> > Sleep rejected by devices
> > adb: starting probe task...
> > adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
> > ADB keyboard at 2, handler 1
> > ADB mouse at 3, handler set to 4 (trackpad)
> > adb: finished probe task...
> > usb_device usbdev1.1: PM: suspend 0->2, parent usb1 already 2
> > usb_endpoint usbdev1.1_ep81: PM: suspend 0->2, parent 1-0:1.0 already 2
> > hub 1-0:1.0: PM: suspend 2->2, parent usb1 already 2
> > usb_endpoint usbdev1.1_ep00: PM: suspend 0->2, parent usb1 already 2
> > eth2: Airport entering sleep mode
> > eth0: suspending, WakeOnLan disabled
> > Trying to free already-free IRQ 40
> > pci_set_power_state(): 0002:20:0e.0: state=3, current state=5
> > firewire_ohci: pci_set_power_state failed with -22<3>pci_device_suspend(): pci_suspend+0x0/0x9c [firewire_ohci]() returns -22

I grepped the whole tree for firewire_ohci and came up blank.  What is it?

But yes, a failed pci_set_power_state() will hurt.  Perhaps this is
a result of some recently-added return-value checking fix but as I
cannot find the dang code I cannot tell.

> > suspend_device(): pci_device_suspend+0x0/0x98() returns -22
> > Could not suspend device 0002:20:0e.0: error -22
> > eth0: resuming
> > PHY ID: 4061e4, addr: 0
> > eth2: Airport waking up
> > eth2: New link status: Connected (0001)
> > hda: Enabling Ultra DMA 2
> > hdb: Enabling Ultra DMA 2
> > eth0: Link is up at 100 Mbps, full-duplex.
> > eth0: Pause is disabled
> 
> The problem wa sinitiated by closing the lid. The iBook then seems to 
> permanetly try to go to sleep (I can hear the cd-rom drive get 
> periodically initialized). So above contains more than one iteration.
> 
> The kernel is:
> > Linux kismet 2.6.22-1-powerpc #1 Sun Jul 29 13:58:06 CEST 2007 ppc GNU/Linux
> 
> The relveant debian package:
> > linux-image-2.6.22-1-powerpc_2.6.22-3_powerpc.deb
> 
> I'm running a mixture of debian testing/unstable.
> 
> The firewire and the USB connector were unused, the network connector 
> was used.
> 
> If there are questions regarding other packages, or somebody wants me to 
> test a fix (I would prever a debian package), don't hesitate - I would 
> like to get the bug fixed :-)
> 
