Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYHSPDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYHSPDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYHSPDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:03:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42297 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752612AbYHSPDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:03:20 -0400
Date: Tue, 19 Aug 2008 11:03:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aivils Stoss <aivils@latnet.lv>
cc: Randy Dunlap <rdunlap@xenotime.net>, lud <linux-usb@vger.kernel.org>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       <linux-input@vger.kernel.org>, <jkosina@suse.cz>,
       <linux-kernel@vger.kernel.org>,
       <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
In-Reply-To: <200808191527.06945.aivils@latnet.lv>
Message-ID: <Pine.LNX.4.44L0.0808191049490.2669-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, Aivils Stoss wrote:

> No problem is same. Older kernels have another troubles.
> 2.6.22-1-mepis-smp
> Quite stable. Have oops sometime inside evdev. Support up to 16 
> USB keyboards, where 4 hubs are plugged into PC and 4 keyboards on
> each hub. Any hub cascade support only 4 keyboards, where 5th or more
> is registered but don't send input events. Oops inside evdev , when
> USB keyboard unplugged. No slow down even all USB keyboards does
> not work properly. My be this one support more than 16 keyboards, but
> i don't have PC USB ports enough.
> 
> 2.6.24-7
> 4 keyboards per port. If plug in 5th tend to total slow down with this one:
> usb 2-1.1.1: reset low speed USB device using 
> uhci_hcd and address 17
> 5th - means 5th keyboard in USB hub's cascade, which is plugged into
> single PC USB port.
> 
> 2.6.26
> 4 keyboards per port. If plug in 5th tend to total slow down.
> 
> 2.6.27-rc3
> Sorry Randy i cannot repeat Your achievement. This worse of all tested
> kernels. I got working 3 USB keyboards, when i plug in 4th, all keyboards,
> include PS/2 stop working. Kernel does not hung up. I can reach box
> via net. dmesg , /proc/bus/input/devices attached. lsusb hung up.

Have you tried looking in your system log for error messages indicating 
the source of the problem?

uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
input: USB HID v1.10 Device [CHESEN USB Keyboard] on usb-0000:00:1d.1-2.2.4
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us
uhci_hcd 0000:00:1d.1: bandwidth allocation failed: period 8, phase 4, 826 + 118 us

Those messages seem pretty clear.  Each keyboard requires two interrupt 
transfers occupying 118 us of bandwidth apiece.  That's 236 us per 
keyboard.

Since there is only 900 us total available for interrupt transfers in
any frame, and since uhci-hcd isn't smart enough to allocate different
interrupt endpoints to different frames, you run out of bandwidth after
four keyboards.

Now if you plugged some of these keyboards into different UHCI 
controllers on the computer, then the problem wouldn't arise.  Each of 
your four UHCI controllers has two ports.  So without using any hubs at 
all, you can plug 8 keyboards into the computer and they will all work.

If you use some extra hubs as well then you can plug four keyboards 
into each controller, allowing you to use 16 keyboards total.

Alan Stern

