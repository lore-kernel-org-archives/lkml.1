Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbXKUUkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbXKUUkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXKUUkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:40:36 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:36044 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbXKUUkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:40:35 -0500
X-Belgacom-Dynamic: yes
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] USB deadlock after resume
Date: Wed, 21 Nov 2007 21:45:31 +0100
User-Agent: KMail/1.9.7
Cc: "Markus Rechberger" <mrechberger@gmail.com>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, Mark Lord <lkml@rtr.ca>,
       Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org
References: <d9def9db0711210637x6fd5ad09o549b787639690d55@mail.gmail.com> <Pine.LNX.4.44L0.0711211128380.3226-100000@iolanthe.rowland.org> <d9def9db0711210914m47885980gffd789d30a817b88@mail.gmail.com>
In-Reply-To: <d9def9db0711210914m47885980gffd789d30a817b88@mail.gmail.com>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711212145.31506.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2007, Markus Rechberger wrote:
> On 11/21/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Wed, 21 Nov 2007, Markus Rechberger wrote:
> > > > > it's not just usb_set_interface that hangs actually.
> > > > > It seems to hang at
> > > > >
> > > > > wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
> > > > >
> > > > > in drivers/usb/core/urb.c after resuming. I disabled access to the
> > > > > usb subsystem in the uvc driver, although connecting any other usb
> > > > > storage fails too, just at the same point.
> > > >
> > > > Which URB is usb_kill_urb() called for?
> > >
> > > it's the usb_control_message which calls usb_kill_urb if I haven't got
> > > it wrong. (if you're looking for some other information please let me
> > > know)
> > > Although, I got a bit further with it. The error seems to happen
> > > earlier already.
> > > If I load the driver, and do not access the device after suspending
> > > all usb_control commands fail with -71 eproto.
> >
> > That's very strange.  Getting -71 errors is understandable; it
> > indicates that the device can't handle being suspended.  But the
> > wait_event() line still shouldn't hang.  If it does, it indicates that
> > there's something wrong with the USB host controller, not just the
> > device.
> >
> > Can you try testing this on a different sort of computer?
>
> Not really, suspending doesn't work at all on my other notebook it
> just freezes..
> I'm basically trying to get that driver work on my eee PC [1], it's
> cheap and tiny so I don't expect anything special in there..
> The system is preloaded with Xandros (it's debian etch with a few
> custom applications) and linux 2.6.21.4.

If I'm not mistaken, the EeePC ACPI bios plays tricks with the USB ports 
during suspend/resume. You should really test suspend/resume with the same 
camera chipset on a proper computer. If the camera still crashes, we have a 
buggy chipset which needs a reset quirk. If it doesn't, the EeePC ACPI bios 
is probably at fault. Adding quirks and hacks to the Linux kernel (either in 
the USB stack or the uvcvideo driver) is pretty pointless if the bios tries 
to make the system crash. The ACPI code should be fixed in that case.

> The system still locks up, although only if I leave the video
> application running during suspending. I don't have to reload the
> driver anymore after resuming if the video node doesn't get accessed
> (I'm looking for races in the uvc driver at the moment).

Best regards,

Laurent Pinchart
