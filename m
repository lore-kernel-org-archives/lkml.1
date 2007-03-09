Return-Path: <linux-kernel-owner+w=401wt.eu-S1767516AbXCITcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767516AbXCITcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767510AbXCITcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:32:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60103 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1767517AbXCITcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:32:08 -0500
Date: Fri, 9 Mar 2007 14:32:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
In-Reply-To: <d120d5000703090934r45c39f74l2a51eda986b1f07b@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703091343590.2611-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Dmitry Torokhov wrote:

> On 3/9/07, Oliver Neukum <oneukum@suse.de> wrote:
> > Am Freitag, 9. März 2007 18:02 schrieb Dmitry Torokhov:
> >
> > > I think we already have all refcounting that is needed. What is
> > > missing is subsystem-provided ->release() hooks for drivers to release
> > > driver-specific resources when a device finally goes away.
> >
> > This is an interesting idea. Is it nice to pass through release()
> > but not open() ?
> >
> 
> Not sure if I follow... Generally speaking open is not a mandatory
> operation; however every object in driver model has a release method.
> What I am saying is that certain drivers need to have their disconnect
> method split in 2 parts - one that shuts down the device and second is
> releases resources that might be accesses through sysfs (and other
> kernel parts). That second part will have to be called from
> subsystem's core ->release() method se we need a release() hook.

Dmitry, you're not viewing this correctly.

Adding a new release() callback would solve the problem by creating 
another.  Drivers need to release their data as soon as possible after
they unbind from a device, not when the device itself goes away.  Think
about what would happen if you tried to rmmod a driver.  The rmmod process 
would block until the device was unregistered.

Oliver, your idea won't work either.  Think about what would happen if 
someone did

	rmmod driver_module </sys/devices/.../attribute_file

The rmmod process would never actually read the attribute, so until it 
exited the private data structure would have a positive refcount.  But 
rmmod can't exit until the driver has been unloaded from memory, and it 
can't be unloaded while its data structure is still allocated.  Thus we 
would end up with deadlock; rmmod would hang forever.

It might be better to keep your earlier patch and fix the deadlock you
mentioned earlier, the one that occurs when unbinding a driver through
sysfs.  How exactly does that deadlock work?

Alan Stern

