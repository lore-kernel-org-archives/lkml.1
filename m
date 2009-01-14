Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbZANWtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbZANWtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZANWto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:49:44 -0500
Received: from mail.impinj.com ([206.169.229.170]:54779 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754153AbZANWtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:49:43 -0500
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Subject: Re: amd5536udc interrupts bug
Date: Wed, 14 Jan 2009 14:49:37 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <49661E83.2070703@arcor.de> <200901131119.54994.vlobanov@speakeasy.net> <496DDDFC.7030301@arcor.de>
In-Reply-To: <496DDDFC.7030301@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141449.37246.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 14 Jan 2009 22:49:37.0649 (UTC) FILETIME=[60B81E10:01C9769A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009 04:43:40 Thomas Dahlmann wrote:
> Vadim Lobanov schrieb:
> > cap=0x000083EA
> > 	The host power control bits affect USB_PWR_EN1 for ports 1-3.
> > 	The host power control bits affect USB_PWR_EN2 for port 4.
> > 	Port power enabled with output of 1 on USB_PWR_EN1 and USB_PWR_EN2.
> > 	No overcurrent reporting.
> > 	Automatic pull-up (APU) is enabled.
> >
> > mux=0x00000003
> > 	The muxed port is assigned to the device controller.
> >
> > ctl=0x00000083
> > 	The muxed port is assigned to the device controller.
> > 	The comparator circuitry for VBUS detection (PADEN) is enabled.
>
> The UOC registers look good to me too except for bit VBUSVLD
> (bit 8 in UOCMUX). This bit should get set when cable is
> connected. Maybe VBUS pin is not connected. In this case the
> internal pull up will not get connected. For testing the pull up can
> be connected manually by clearing APU in UOCCAP and
> setting PUEN in UOCMUX.

I modprobed the driver before plugging in the cable, so that would explain the 
VBUSVLD bit not being set.

> But if SD bit is cleared (and UOC bits seem OK as you showed)
> then only hardware can be the root cause of the issue. If host
> detects a USB connection it will automatically send a
> GET_DESCRIPTOR message to UDC. You would see kernel
> messages on host side, at least messages indicating that device
> is not responding.

It seems that the ultimate cause for all this strangeness was a mis-wired 
board: the vendor at long last admitted that the VBUS signal is not connected 
in the hardware. Why they didn't simply document this fact, and thereby save 
me a lot of wasted effort, remains a mystery.

As a workaround, they suggested setting bit 0x00000010 in the ctl register, 
which is strangely enough inside the "reserved" space according to the AMD 
data book. Worth a shot, I thought. After hacking up the amd5536udc driver 
even more to do this operation at load time, the register states change to:

cap=0x000083EA
mux=0x00000007
ctl=0x00000193

Seems that a few other "reserved" bits also raised in response. (I still do 
not understand exactly how they wired up the CS5536 IO chip to be different 
from the data book, but oh well.) In this mode, the USB link is finally 
detected, and the board is finally able to enumerate itself as a g_zero 
device.

Please accept my sincere thank-you for your help. I'm hoping that everything 
will work from now on, and that I won't send any more questions your way. :) 
I'll also await an update to the irq stuff in the amd5536udc driver that we 
talked about earlier, if you get around to making the fix for it first.

> I found a Hurricane LX800 manual at
>
> http://www.lippert-at.de/fileadmin/lippert-at/products/EPIC/Hurricane-LX800
>/TME-EPIC-HURLX-R1V4.pdf
>
> saying that there is no type B device port and device port is port 3.
> Do you have a different one?

Yep, that's the one. We're using a USB A-to-B adapter to turn port 3 from an A 
port to a B-port. The standard USB cable uses this adapter.

> Chapter 3.8, page 19:
> 4 standard USB 2.0 host ports are provided at the I/O panel
> of the Hurricane LX800. . . Port 3 can be used as USB device
> port. This feature must be enabled in BIOS
> under Motherboard Device Configuration -> PCI Configuration.
> UDC must be enabled; Port 3 assignment should be set to device.

See how they conveniently forgot to mention UOC in their description, much 
less some magical bit in the ctl register? Tricky, tricky! :)

-- Vadim Lobanov

