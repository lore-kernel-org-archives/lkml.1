Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbXKGTgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbXKGTgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 14:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXKGTg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 14:36:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:57389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbXKGTg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:36:26 -0500
Subject: Re: Re: BUG in: Driver core: convert block from raw kobjects to
	core devices (fwd)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hannes Reinecke <hare@suse.de>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0711071051560.4444-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711071051560.4444-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 20:36:22 +0100
Message-Id: <1194464182.2303.44.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19FszMWhJIzJIe8H0mpDsNh78gwGLv4JGk7hhJ
 to0ES4hCM+dwRP53463IkeNHzfyVFF9o8UmEDU7CZwjHDpNH2+
 sa2GyJ1shKT/VXcYlPd0apb0laefNGL
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-07 at 10:54 -0500, Alan Stern wrote:
> On Wed, 7 Nov 2007, Hannes Reinecke wrote:
> 
> > Alan Stern wrote:
> > > 
> > > Thus we have a cycle:
> > > 
> > > 	1&2: request_queue isn't released before scsi_device;
> > > 
> > > 	3: scsi_device isn't released before gendisk;
> > > 
> > > 	4: gendisk isn't released before request_queue.
> > > 
> > > The dependency in 1&2 is hard-coded into the SCSI core.  If I 
> > > understand correctly, the core really does need the request_queue to 
> > > hang around as long as the scsi_device is still present.  According to 
> > > James Bottomley, any block device driver should be expected to have a 
> > > similar requirement.
> > > 
> > This is actually true, but as other block device drivers create the
> > LUN (or the equivalent thereof), the request queue, and the block device
> > at the same time or under control of the driver itself they don't have
> > this problem.
> > It's only due to the decoupling of the block driver from the underlying
> > device (ie sd driver and scsi_device) when this problem arises.
> 
> I don't understand your reasoning.  If the same parent-child
> relationships exist then it doesn't matter who creates the data
> stuctures.  All that matters is that the block device's reference to
> the request_queue isn't dropped until the device is released.
> 
> > > But the dependencies in 3 and 4 are unnecessary.  They are artifacts,
> > > caused by the fact that a kobject doesn't drop its reference to its
> > > parent until it is released.  If instead the reference to the parent
> > > were dropped when the kobject was removed then 3 and 4 wouldn't apply.
> > > 
> > And should be okay as the device isn't accessible from userland
> > anyway after doing a device_del(). And the implication is that it's
> > going to be remove soon entirely. So we're just moving the timing
> > of the eventual call to the ->release() function; the events will
> > be triggered by device_del() and won't be changed.
> > And if some device actually requires a reference to the parent
> > during ->release() it can as well acquire it manually and shouldn't
> > rely on the core logic to do that automatically.
> 
> My thinking exactly.

It would remove another implicit "magic" from the core, which is good.

Otherwise we will need to introduce a kobject_orphan(), to disassociate
an object from its parent, which would be kind of weird, just to break
out of the default core logic.

I would expect this patch to have an effect only at the pretty complex
refcounting users of the driver core, which are SCSI and USB, and I
expect the people involved are good prepared now, to fix such possible
bugs, should they show up. :)

Kay

