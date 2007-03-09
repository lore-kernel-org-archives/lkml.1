Return-Path: <linux-kernel-owner+w=401wt.eu-S1767472AbXCIUFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767472AbXCIUFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767471AbXCIUFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:05:30 -0500
Received: from ns.suse.de ([195.135.220.2]:41616 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767472AbXCIUF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:05:28 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Date: Fri, 9 Mar 2007 21:05:20 +0100
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0703091343590.2611-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703091343590.2611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703092105.21525.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 9. März 2007 20:32 schrieb Alan Stern:
> On Fri, 9 Mar 2007, Dmitry Torokhov wrote:
> 
> > On 3/9/07, Oliver Neukum <oneukum@suse.de> wrote:
> > > Am Freitag, 9. März 2007 18:02 schrieb Dmitry Torokhov:
> > >
> > > > I think we already have all refcounting that is needed. What is
> > > > missing is subsystem-provided ->release() hooks for drivers to release
> > > > driver-specific resources when a device finally goes away.
> > >
> > > This is an interesting idea. Is it nice to pass through release()
> > > but not open() ?
> > >
> > 
> > Not sure if I follow... Generally speaking open is not a mandatory
> > operation; however every object in driver model has a release method.
> > What I am saying is that certain drivers need to have their disconnect
> > method split in 2 parts - one that shuts down the device and second is
> > releases resources that might be accesses through sysfs (and other
> > kernel parts). That second part will have to be called from
> > subsystem's core ->release() method se we need a release() hook.
> 
> Dmitry, you're not viewing this correctly.
> 
> Adding a new release() callback would solve the problem by creating 
> another.  Drivers need to release their data as soon as possible after
> they unbind from a device, not when the device itself goes away.  Think

Wait, the callback from closing the file in sysfs is the earliest we can safely
free the data structure. How do you want to free earlier?

> about what would happen if you tried to rmmod a driver.  The rmmod process 
> would block until the device was unregistered.
> 
> Oliver, your idea won't work either.  Think about what would happen if 
> someone did
> 
> 	rmmod driver_module </sys/devices/.../attribute_file

-EBUSY, as currently.
 
> The rmmod process would never actually read the attribute, so until it 
> exited the private data structure would have a positive refcount.  But 
> rmmod can't exit until the driver has been unloaded from memory, and it 
> can't be unloaded while its data structure is still allocated.  Thus we 
> would end up with deadlock; rmmod would hang forever.
> 
> It might be better to keep your earlier patch and fix the deadlock you
> mentioned earlier, the one that occurs when unbinding a driver through
> sysfs.  How exactly does that deadlock work?

http://lkml.org/lkml/2007/3/6/364
http://lkml.org/lkml/2007/3/6/528

	Regards
		Oliver
