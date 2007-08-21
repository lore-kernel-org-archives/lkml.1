Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbXHUIkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbXHUIkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 04:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbXHUIkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 04:40:15 -0400
Received: from mx1.ciphirelabs.net ([217.72.114.64]:56026 "EHLO
	mx.dmz.ciphirelabs.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbXHUIkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 04:40:13 -0400
From: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [linux-usb-devel] why was MODALIAS removed from usb kernel events? [u]
Date: Tue, 21 Aug 2007 10:39:58 +0200
User-Agent: KMail/1.9.6
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
References: <200708171622.05115.aj@ciphirelabs.com> <20070821073656.GA6691@kroah.com>
In-Reply-To: <20070821073656.GA6691@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211039.59241.aj@ciphirelabs.com>
X-Ciphire-Security: plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 21. August 2007 schrieb Greg KH:
> On Fri, Aug 17, 2007 at 04:22:04PM +0200, Andreas Jellinghaus [c] wrote:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
> >diff;h=9f8b17e643fe6aa505629658445849397bda4e4f
> >
> > removes MODALIAS from one of the events,
>
> Which event?

here is the event with kernel 2.6.21:
UEVENT[1187683991.583384] 
add      /devices/pci0000:00/0000:00:1d.1/usb2/2-1/2-1.7/2-1.7:1.0 (usb)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.1/usb2/2-1/2-1.7/2-1.7:1.0
SUBSYSTEM=usb
SEQNUM=3070
PHYSDEVBUS=usb
DEVICE=/proc/bus/usb/002/006
PRODUCT=8e6/3438/100
TYPE=0/0/0
INTERFACE=11/0/0
MODALIAS=usb:v08E6p3438d0100dc00dsc00dp00ic0Bisc00ip00

note: it has both - MODALIAS and DEVICE.

here is the event with kernel 2.6.22 (with CONFIG_USB_DEVICE_CLASS):
UEVENT[1187684539.588975] 
add      /devices/pci0000:00/0000:00:1d.1/usb2/2-1/2-1.7/2-1.7:1.0 (usb)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.1/usb2/2-1/2-1.7/2-1.7:1.0
SUBSYSTEM=usb
SEQNUM=3029
DEVTYPE=usb_interface
PHYSDEVBUS=usb
INTERFACE=11/0/0
MODALIAS=usb:v08E6p3438d0100dc00dsc00dp00ic0Bisc00ip00

you see, it is missing DEVICE and PRODUCT and TYPE

and here is the event with kernel 2.6.22 with alans patch and 
CONFIG_USB_DEVICE_CLASS:

UEVENT[1187684125.860105] 
add      /devices/pci0000:00/0000:00:1d.1/usb2/2-1/2-1.7/2-1.7:1.0 (usb)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.1/usb2/2-1/2-1.7/2-1.7:1.0
SUBSYSTEM=usb
SEQNUM=3029
DEVTYPE=usb_interface
PHYSDEVBUS=usb
DEVICE=/proc/bus/usb/002/006
BUSNUM=002
DEVNUM=006
INTERFACE=11/0/0
MODALIAS=usb:v08E6p3438d0100dc00dsc00dp00ic0Bisc00ip00

it still misses PRODUCT and TYPE, for real compatibility those should be added 
too. (I can work around that, as the PRODUCT information is part of MODALIAS 
and I don't use TYPE.)

> If you enable CONFIG_USB_DEVICE_CLASS, does everything work the same
> again?

both with CONFIG_USB_DEVICE_CLASS. would it change anything here?

> What specific udev rule are you matching against here that is now
> broken?

still trying to get it to work, so far I try:

SUBSYSTEM!="usb", GOTO="openct_usb_rules_end"
ACTION!="add", GOTO="openct_usb_rules_end"
ENV{MODALIAS}=="usb:v0973p0001*", RUN+="/lib/udev/openct_usb"
ENV{MODALIAS}=="usb:*ic0Bisc00*", RUN+="/lib/udev/openct_usb"
LABEL="openct_usb_rules_end"

this should work?

> > The text does not mention MODALIAS nor the reason for it's removal.
>
> The reason is we don't need the usb_device class anymore, but we still
> provide for the compatibility if you have an old distro with old udev
> rules that is expecting it (only rule we ran into was the one for the
> usbfs /dev nodes, but there might be more.)

I'm no udev expert, but old kernels provide an event with all three 
informations I care about: MODALIAS, DEVICE and PRODUCT. this is changed,
and I don't understand what it has to do with usb_device class.

but I can say that without any event that has all three (or at least the first 
two - I can create PRODUCT from MODALIAS i think), I would need to redesign
how openct finds out if new devices are plugged in. long term I might need
to do so anyway, but right now people complain "it doesn't work" to me, and 
the culprit seems to be the kernel to me - 2.6.21 works, 2.6.22 does not.

Now I'm working on getting openct udev rules and handling script fixed so
they work at least with alans patch and work around missing PRODUCT.

Regards, Andreas
