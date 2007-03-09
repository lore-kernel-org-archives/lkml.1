Return-Path: <linux-kernel-owner+w=401wt.eu-S1767486AbXCIU1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767486AbXCIU1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767490AbXCIU1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:27:04 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33228 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1767486AbXCIU1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:27:01 -0500
Date: Fri, 9 Mar 2007 15:27:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
In-Reply-To: <200703092105.21525.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0703091509560.5094-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Oliver Neukum wrote:

> > Adding a new release() callback would solve the problem by creating 
> > another.  Drivers need to release their data as soon as possible after
> > they unbind from a device, not when the device itself goes away.  Think
> 
> Wait, the callback from closing the file in sysfs is the earliest we can safely
> free the data structure. How do you want to free earlier?

It is _not_ the earliest we can safely free the data structure.

Dmitry's callback occurs when _all_ the sysfs attributes have been
released -- including ones that don't have anything to do with the
driver's private data structure.  Think of the bInterfaceClass attribute,
for example.

But even aside from that, Dmitry's suggestion is wrong.  He wants to add a
second release() method to the driver, which can be called from the
subsystem's release() method -- which doesn't run until the device is
unregistered, possibly long after the driver has been unbound from it.  
Then how could the subsystem even know which drivers need their second
release method called?


> > Oliver, your idea won't work either.  Think about what would happen if 
> > someone did
> > 
> > 	rmmod driver_module </sys/devices/.../attribute_file
> 
> -EBUSY, as currently.

Yeah, I was wrong about that.


> > It might be better to keep your earlier patch and fix the deadlock you
> > mentioned earlier, the one that occurs when unbinding a driver through
> > sysfs.  How exactly does that deadlock work?
> 
> http://lkml.org/lkml/2007/3/6/364
> http://lkml.org/lkml/2007/3/6/528

I get the picture, thanks.

Alan Stern


