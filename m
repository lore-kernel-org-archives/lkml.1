Return-Path: <linux-kernel-owner+w=401wt.eu-S1031112AbXDQP7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031112AbXDQP7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031107AbXDQP7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:59:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36843 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1031112AbXDQP7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:59:20 -0400
Date: Tue, 17 Apr 2007 11:59:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <htejun@gmail.com>,
       Markus Rechberger <markus.rechberger@amd.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] How should an exit routine wait for release()
 callbacks?
In-Reply-To: <20070416221247.GA9365@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0704171150270.20368-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Greg KH wrote:

> > > I've got a module which registers a struct device.  (It represents a
> > > virtual device, not a real one, but that doesn't matter.)
> 
> Wait, that's the issue right there.
> 
> Don't do that.
> 
> devices should be created by busses or the platform core, which owns the
> release function for them.  Individual drivers should not create
> devices.
> 
> Hm, but then, how would you ever unload a bus, as the same issue might
> be there too...
> 
> Any specific code in the kernel you can point to that has this issue
> today?

I first noticed it while working with dummy_hcd.  It creates a virtual 
host controller platform device and a virtual device controller platform 
device.  Its exit routine doesn't wait (and has no way to wait) for the 
release methods of those devices to finish executing.

But the same issue tends to pop up anywhere you have a "bridge" device --
one that connects two different kinds of bus.  For instance, a PC-card
essentially bridges a CardBus to whatever you can plug into that card.  
usb-storage essentially bridges a USB bus to a SCSI bus.  uhci-hcd
essentially bridges a PCI bus to a USB bus.

The problem itself isn't very noticeable.  Existing uses of
try_module_get() generally reduce it to an unlikely race, and the
uncoupling of sysfs from devices will make it even rarer.

But the problem still exists potentially.

Alan Stern

