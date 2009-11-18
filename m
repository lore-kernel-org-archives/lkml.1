Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZKRPm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZKRPm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 10:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZKRPm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 10:42:58 -0500
Received: from kroah.org ([198.145.64.141]:48997 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbZKRPm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 10:42:57 -0500
Date: Wed, 18 Nov 2009 07:39:47 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, Russ Dill <russ.dill@gmail.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Use of usb_find_interface in open is racy
Message-ID: <20091118153947.GA32440@kroah.com>
References: <alpine.LRH.2.00.0911181141030.31913@twin.jikos.cz>
 <Pine.LNX.4.44L0.0911181029110.3036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0911181029110.3036-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 10:31:47AM -0500, Alan Stern wrote:
> On Wed, 18 Nov 2009, Jiri Kosina wrote:
> 
> > On Tue, 17 Nov 2009, Russ Dill wrote:
> > 
> > > Many usb drivers that create character devices use "struct
> > > usb_class_driver", a set of fops, and a usb_find_interface in their
> > > open call. A prime example is drivers/usb/usb-skeleton.c. A race
> > > occurs when userspace receives a hotplug event for the addition for
> > > the interface and then opens the associated device file before the
> > > device is added to the driver's klist_devices.
> > > 
> > > The usb core senses a new usb device (usb_new_device) and calls
> > > device_add. This eventually gets down to really_probe and the
> > > usb-skeleton probe function, skel_probe. skel_probe calls
> > > usb_register_dev() which registers the associated character device for
> > > skel_class. The hotplug events for the class device get emitted.
> > > 
> > > User space receives the hotplug event for the class device, makes the
> > > device node and notifies another program that opens the device node.
> > > The program opens the device node which calls into usb_open and then
> > > skel_open. skel_open calls usb_find_interface. usb_find_interfaces
> > > searches the klist_devices of skel_driver, finds no device associated
> > > with the minor number and returns NULL. skel_open returns -ENODEV.
> > > 
> > > Control returns to really_probe and really_probe calls driver_bound
> > > which adds the device to the list of devices associated with
> > > skel_driver (klist_devices).
> > > 
> > > I'm not sure what the right way to solve this is. A call to
> > > wait_for_device_probe() in the skel_open call before calling
> > > usb_find_interface fixes the problem, but it is a rather large hammer.
> 
> I think the proper answer is for usb_find_interface() to use 
> bus_for_each_dev() instead of driver_for_each_device().

Yeah, I think so, sorry about that I think this is my fault :(

I'm travelling all today, could someone make up a patch for this before
Thursday if it's an issue?

Russ, have you ever hit this problem, or did you just find it by looking
at the code?

thanks,

greg k-h
