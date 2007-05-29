Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXE2Vu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXE2Vu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbXE2Vuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:50:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51085 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750717AbXE2Vuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:50:50 -0400
Date: Tue, 29 May 2007 17:50:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dan Aloni <da-x@monatomic.org>
cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] Dealing with flaky USB storage devices and
 rootfs
In-Reply-To: <20070529205927.GA24808@localdomain>
Message-ID: <Pine.LNX.4.44L0.0705291734390.2974-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007, Dan Aloni wrote:

> Hello,
> 
> We have a system where the rootfs is a partition on a USB device,
> and I've noticed upon a few rare cases where the USB controller 
> loses the connection to the USB device after some uptime (days,
> weeks...), and the USB device reappears a very short time later.

That failure mode is pretty uncommon.  More often what happens is the
connection remains intact but communication/protocol/firmware/???  
errors cause the device to stop working.  It never disappears but it
can't be used again without unplugging or power-cycling.

> It doesn't really matter why, I guess that USB controllers and
> storage devices aren't always of the best quality - let's assume
> that. The issue is that Linux currently makes it problematic
> to recover the rootfs for several reasons.
> 
> If /dev/sda1 is mounted as root and the SCSI device goes into 
> offline mode, it is quite impossible to get out of this situation.
> At first, I had to disable the usermode helper that sends events 
> to udev since it blocks on the dysfunction /dev/sda1. Afterwards, 
> I noticed that the reappearing device is being assigned with 
> /dev/sdb along with a new SCSI host. I guess the the VFS and 
> block layer still keep a reference to the old scsi_disk and as 
> a result sd doesn't free it.

Yes.

> So, I gave some thoughts about this, I and came up with two 
> main solutions:
> 
> 1) Improve the USB storage error handling - bind the already 
> existing SCSI host to the USB port that has the device, e.g., 
> if host2 got created for usb 5-3 then keep it that way for the 
> sake of EH. /dev/sda1 should come to life when the USB device 
> recovers, unless a few seconds have passed or some attributes 
> (such as manufactor id or serial) have changed.

The difficulty here is that this "error" is indistinguishable from
normal activity -- someone simply unplugs the device and then later on
another connection is made.  It might be the same device as before or
it might be a different one.  In other words, it isn't really an error.  
You would solve this by relying on "a few seconds" timeout.

> 2) Block layer hack - Write a special layering block device 
> driver that acts as a proxy to the currently functioning 
> /dev/sd* which gets auto-detected by this block layer driver. 
> md multipath for the 'poor', you might say..
> 
> I chose '2' for the time being. It was much easier than hacking
> around the USB subsystem... Yes, I know rootfs on USB is an
> uncommon use-case at the moment but I do like to know if there 
> are some improvements planned in this area.

Interesting.  I've been working on something very much like your 1) for
some time.  A version of it is now in the USB development tree.  It's
not meant for situations like the one you describe; instead it is
intended for suspend-to-RAM or hibernation.  Generally these processes
involve loss of power on the USB bus, causing it to appear as though
all the devices have been unplugged.

In theory the same approach could be used to recover connections even 
in the absence of an intervening suspend.  It would be clumsy in some 
respects, though.  For instance, when a device actually was 
disconnected, the USB core wouldn't be able to notify the device's 
driver for a few seconds.  In that time lots of unwanted activity and 
errors could mount up.

It also goes against the USB specification.  And it is potentially 
unsafe, in that it is possible for users to change media or make other 
alterations that the kernel cannot detect.  The same would be true of 
your proposal, assuming that somebody was quick enough to unplug one 
device and plug in another (or swap memory cards) in the span of a few 
seconds.

Alan Stern

