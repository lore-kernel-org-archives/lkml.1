Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbXKGPzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbXKGPzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbXKGPzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:55:03 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:49248 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753805AbXKGPzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:55:01 -0500
Date: Wed, 7 Nov 2007 10:54:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Hannes Reinecke <hare@suse.de>
cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
In-Reply-To: <4731ADC8.3040208@suse.de>
Message-ID: <Pine.LNX.4.44L0.0711071051560.4444-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007, Hannes Reinecke wrote:

> Alan Stern wrote:
> > 
> > Thus we have a cycle:
> > 
> > 	1&2: request_queue isn't released before scsi_device;
> > 
> > 	3: scsi_device isn't released before gendisk;
> > 
> > 	4: gendisk isn't released before request_queue.
> > 
> > The dependency in 1&2 is hard-coded into the SCSI core.  If I 
> > understand correctly, the core really does need the request_queue to 
> > hang around as long as the scsi_device is still present.  According to 
> > James Bottomley, any block device driver should be expected to have a 
> > similar requirement.
> > 
> This is actually true, but as other block device drivers create the
> LUN (or the equivalent thereof), the request queue, and the block device
> at the same time or under control of the driver itself they don't have
> this problem.
> It's only due to the decoupling of the block driver from the underlying
> device (ie sd driver and scsi_device) when this problem arises.

I don't understand your reasoning.  If the same parent-child
relationships exist then it doesn't matter who creates the data
stuctures.  All that matters is that the block device's reference to
the request_queue isn't dropped until the device is released.

> > But the dependencies in 3 and 4 are unnecessary.  They are artifacts,
> > caused by the fact that a kobject doesn't drop its reference to its
> > parent until it is released.  If instead the reference to the parent
> > were dropped when the kobject was removed then 3 and 4 wouldn't apply.
> > 
> And should be okay as the device isn't accessible from userland
> anyway after doing a device_del(). And the implication is that it's
> going to be remove soon entirely. So we're just moving the timing
> of the eventual call to the ->release() function; the events will
> be triggered by device_del() and won't be changed.
> And if some device actually requires a reference to the parent
> during ->release() it can as well acquire it manually and shouldn't
> rely on the core logic to do that automatically.

My thinking exactly.

Alan Stern

