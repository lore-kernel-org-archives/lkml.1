Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbZKRPfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbZKRPfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 10:35:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZKRPfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 10:35:13 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36174 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753876AbZKRPfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 10:35:12 -0500
Date: Wed, 18 Nov 2009 10:35:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Jiri Kosina <jkosina@suse.cz>, Russ Dill <russ.dill@gmail.com>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Use of usb_find_interface in open is racy
In-Reply-To: <200911181527.18791.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0911181034150.3036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009, Oliver Neukum wrote:

> Am Mittwoch, 18. November 2009 11:41:25 schrieb Jiri Kosina:
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
> > 
> 
> Device core code is hard to follow, but I tried.
> How about simply covering all of usb_register_dev() with minor_rwsem?

That won't help.  The window is between the end of usb_register_dev()  
and the end of skel_probe(), during which time the mutex isn't held.

Alan Stern

