Return-Path: <linux-kernel-owner+w=401wt.eu-S1161505AbXDWTrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161505AbXDWTrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 15:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161490AbXDWTrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 15:47:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59336 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161505AbXDWTrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 15:47:55 -0400
Date: Mon, 23 Apr 2007 15:47:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <20070423090810.2fc0e864@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0704231535310.5236-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Cornelia Huck wrote:

> On Sun, 22 Apr 2007 10:40:51 -0700,
> Greg KH <greg@kroah.com> wrote:
> 
> > > Looking some more, kobject_get_path() is used for kobject renaming,
> > > uevent handling, and a little bit in the input core.  None of these things 
> > > should try to access a kobject after it has been del()ed.  After all, it's 
> > > no longer present in the filesystem so it doesn't _have_ a path.
> > 
> > But we _have_ to have a full path at that time to tell userspace what
> > just went away.  That is the main reason we enforce this (there were
> > tons of issues with scsi devices and this in the past which is what
> > caused us to enforce this.)
> 
> What we need to ensure is that the parent device is kept at least until
> all children, grandchildren and so on are done with their uevent needs.
> This would imply it needed to stay as long as those children,
> grandchildren, ... are still registered. Would it be save to suggest
> that a ->remove callback would always need to unregister the children?
> Then putting the parent reference at the end of kobject_del() (which is
> after kobject_uevent() in kobject_unregister()) should be safe.

Yes, this is the weak spot.

For some reason I had assumed that it was illegal to unregister a device
while it had registered children (just as it is illegal to rmdir a
non-empty directory).  If it isn't illegal, then perhaps we should arrange
things so that device_del() will recursively call itself for all the
device's children.

> Question: What now?
> 
> 1. Make it mandatory that all children must be unregistered when
> device_del() returns.
> 
> 2. Don't demand an empty directory in sysfs_drop_dentry().

I'm in favor of (1).  But instead of making it mandatory, simply force it
to be true by having device_del() call itself for all remaining children.

For this to be safe, we also have to allow device_del() to be called 
multiple times (since the device's owner might not be aware that the core 
had already unregistered it).  That's no problem; just add:

	if (!device_is_registered(dev))
		return;

to the start of the routine.

Alan Stern

