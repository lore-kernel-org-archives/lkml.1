Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbXKBVV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbXKBVV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 17:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbXKBVVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 17:21:10 -0400
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:45042 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1754495AbXKBVVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 17:21:08 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2007 17:21:08 EDT
Date: Fri, 2 Nov 2007 17:14:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Steven King <sfking@fdwdc.com>, Oliver Neukum <oliver@neukum.name>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] ti_usb_3410_5052 breakage in 2.6.24-rc1
In-Reply-To: <200711011634.32360.sfking@fdwdc.com>
Message-ID: <Pine.LNX.4.44L0.0711021710280.5073-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Steven King wrote:

> > But you didn't post the log messages, so I haven't seen them.
> > In addition, that "wrong number of endpoints" message occurs long after
> > the underlying problem; it's probably not connected.
> 
> Okay, attached is full .config, dmesg, /proc/bus/usb/devices and lsusb for 
> 2.6.23.1 (aka working dongle), 2.6.24-rc1 (aka non-working dongle), 
> 2.6.24-rc1-r (2.6.24-rc1 with commit 063a2da8f01806906f7d7b1a1424b9afddebc443 
> backed out, aka working dongle 2) and finally 2.6.24-rc1-X (2.6.24-rc1 with 
> my patch to ti_usb_3410_5052, aka working dongle 3).  Normally I have a udev 
> rule to automagically select configuration 2, for these tests I disabled 
> that.  The {dmesg, proc.bus.usb.devices, lsusb}-2.6.xxx-1 is after I 
> did 'echo 2 > /sys/.../bConfigurationValue'.
> 
> Clean fresh build for each of the kernels, the dongle was plugged after the 
> system was fully up and X had started.

Okay, this explains everything.  In 2.6.23 (or 2.6.24-rc1 with the 
commit backed out), usb-serial binds to the "wrong" interface and 
performs a firmware download.  Up to that point the device has just the 
one configuration, but with the new firmware it has two.  Then you 
install the second config and the driver can bind successfully.

With 2.6.24-rc1, the driver never gets a chance to update the firmware 
because the invalid endpoint matching prevents it.

Oliver, what do you think should be done to solve this?

Alan Stern

