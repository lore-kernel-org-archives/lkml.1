Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbXIUOjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbXIUOjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbXIUOjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:39:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50861 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754788AbXIUOjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:39:09 -0400
Date: Fri, 21 Sep 2007 10:39:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] USB autosuspend and turning of usb pendrive
 leds
In-Reply-To: <Pine.LNX.4.64.0709211615520.22331@twin.jikos.cz>
Message-ID: <Pine.LNX.4.44L0.0709211032200.4167-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Jiri Kosina wrote:

> (linux-usb-devel needs CC)
> 
> On Fri, 21 Sep 2007, Hans de Goede wrote:
> 
> > 1) Would it be possible to funtionality to the kernel to suspend a device in
> >    such a way that it will automatically unsuspend when used again?
> 
> It is possible - USB now supports autosuspend. After a long debate, it was 
> however devcided that it is explicitly turned off, and userspace is free 
> to turn it on via sysfs interface for whatever devices the user likes to 
> do so.
> 
> This is mainly because there is a huge load of USB devices out there that 
> don't support this feature correctly, and we will break them if we perform 
> autosuspend automatically.
> 
> > 2) Would it be possible to still make the polls succeed then with out 
> >    unsuspending the device (or atleast without doing something that 
> >    would make the led light again, what makes the led light exactly is 
> >    unknown), or should hal stop polling then?

The correct answer is that HAL should top polling while the device is 
suspended.

In kernels starting with 2.6.23-rc6, the correct way to enable 
autosuspend for a USB device is basically like this:

	echo D >/sys/bus/usb/devices/.../power/autosuspend
	echo auto >/sys/bus/usb/devices/.../power/level

where D is the time (in seconds) the device should remain idle before 
it is autosuspended.  An autosuspended device will be woken up to 
respond to polls.  (Note however that in this kernel, autosuspend 
support for USB mass-storage devices was removed because it can 
cause problems related to spinning down disk drives.)

If instead you do

	echo suspend >/sys/bus/usb/devices/.../power/level

it will simply suspend the device immediately.  The device will not be 
woken up automatically and attempts to poll it (or do anything else) 
will fail.

Alan Stern

