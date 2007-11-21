Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbXKUWWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbXKUWWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 17:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbXKUWW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 17:22:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:5882 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbXKUWWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 17:22:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SC66cdwdKW/K+cVXs1rplBuSbvpmhjGUrnuZV+JeATFj/7pfLg1d/umKi7IzUazlLUetgxSeuDcinpY9HitlgnCVdnSbkRoMa2Stb5/9ATMeE5jWkLvo5SvMPg5IOntNv1oCnqzZVmTHA5RhDOS8MANN/3og7loVpQJqCa1Fkkg=
Message-ID: <d9def9db0711211422u3f10d965t10dde5de8f87f24b@mail.gmail.com>
Date: Wed, 21 Nov 2007 23:22:23 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
Subject: Re: [linux-usb-devel] USB deadlock after resume
Cc: linux-usb-devel@lists.sourceforge.net,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Laurent Pinchart" <laurentp@cse-semaphore.com>,
       "Mark Lord" <lkml@rtr.ca>, "Oliver Neukum" <oliver@neukum.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200711212145.31506.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0711210637x6fd5ad09o549b787639690d55@mail.gmail.com>
	 <Pine.LNX.4.44L0.0711211128380.3226-100000@iolanthe.rowland.org>
	 <d9def9db0711210914m47885980gffd789d30a817b88@mail.gmail.com>
	 <200711212145.31506.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/07, Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
> On Wednesday 21 November 2007, Markus Rechberger wrote:
> > On 11/21/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > On Wed, 21 Nov 2007, Markus Rechberger wrote:
> > > > > > it's not just usb_set_interface that hangs actually.
> > > > > > It seems to hang at
> > > > > >
> > > > > > wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
> > > > > >
> > > > > > in drivers/usb/core/urb.c after resuming. I disabled access to the
> > > > > > usb subsystem in the uvc driver, although connecting any other usb
> > > > > > storage fails too, just at the same point.
> > > > >
> > > > > Which URB is usb_kill_urb() called for?
> > > >
> > > > it's the usb_control_message which calls usb_kill_urb if I haven't got
> > > > it wrong. (if you're looking for some other information please let me
> > > > know)
> > > > Although, I got a bit further with it. The error seems to happen
> > > > earlier already.
> > > > If I load the driver, and do not access the device after suspending
> > > > all usb_control commands fail with -71 eproto.
> > >
> > > That's very strange.  Getting -71 errors is understandable; it
> > > indicates that the device can't handle being suspended.  But the
> > > wait_event() line still shouldn't hang.  If it does, it indicates that
> > > there's something wrong with the USB host controller, not just the
> > > device.
> > >
> > > Can you try testing this on a different sort of computer?
> >
> > Not really, suspending doesn't work at all on my other notebook it
> > just freezes..
> > I'm basically trying to get that driver work on my eee PC [1], it's
> > cheap and tiny so I don't expect anything special in there..
> > The system is preloaded with Xandros (it's debian etch with a few
> > custom applications) and linux 2.6.21.4.
>
> If I'm not mistaken, the EeePC ACPI bios plays tricks with the USB ports
> during suspend/resume. You should really test suspend/resume with the same
> camera chipset on a proper computer. If the camera still crashes, we have a
> buggy chipset which needs a reset quirk. If it doesn't, the EeePC ACPI bios
> is probably at fault. Adding quirks and hacks to the Linux kernel (either in
> the USB stack or the uvcvideo driver) is pretty pointless if the bios tries
> to make the system crash. The ACPI code should be fixed in that case.
>

With ACPI it seems to be possible to disconnect the uvc device.
I tested the suspend/resume functions by adding a proc interface to
it, and it worked properly.
Although the eee PC also suspends the underlying bus where the usb
controller is connected to (which is PCI or PCIe)

> > The system still locks up, although only if I leave the video
> > application running during suspending. I don't have to reload the
> > driver anymore after resuming if the video node doesn't get accessed
> > (I'm looking for races in the uvc driver at the moment).
>

The current state I revealed is that after suspend if the video node
isn't used it's not necessary to reconnect the device nor to reload
the driver again if that reset is implemented.
That eee PC comes with 2.6.21.3 which has no such reset quirk feature
in the usbcore (that's what I initially meant actually).
If a videoapplication accesses the nodes during suspend the notebook
won't come back again.
I also think it's faulty hardware in that case but I'm moreover
looking for a solution for it. My other intel notebook doesn't even
awake from suspend to ram, and for some reason suspend to disk just
didn't work as expected either (Acer Travelmate 660).

thanks for the feedback,
Markus
