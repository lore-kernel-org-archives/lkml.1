Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbXKGMVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbXKGMVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 07:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbXKGMVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 07:21:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbXKGMVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 07:21:31 -0500
Message-ID: <4731ADC8.3040208@suse.de>
Date: Wed, 07 Nov 2007 13:21:28 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
References: <Pine.LNX.4.44L0.0711061419090.8694-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711061419090.8694-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Mon, 5 Nov 2007, Greg KH wrote:
> 
>> On Mon, Nov 05, 2007 at 04:49:21PM -0500, Alan Stern wrote:
>>> Greg:
>>>
>>> So what's our status?  Do you think it's worthwhile adding the 
>>> "drop reference to parent kobject at remove time instead of release 
>>> time" patch?
>> No.
>>
>> I still need to take the time and read this thread and find the real
>> problem here.  The fact that the issue does not show up for other,
>> non-scsi block devices, makes me feel this is a scsi-specific problem
>> with how it deals with the driver model, but I need to take the time to
>> sit down and figure it out for sure.
> 
[ .. ]
> 
> Thus we have a cycle:
> 
> 	1&2: request_queue isn't released before scsi_device;
> 
> 	3: scsi_device isn't released before gendisk;
> 
> 	4: gendisk isn't released before request_queue.
> 
> The dependency in 1&2 is hard-coded into the SCSI core.  If I 
> understand correctly, the core really does need the request_queue to 
> hang around as long as the scsi_device is still present.  According to 
> James Bottomley, any block device driver should be expected to have a 
> similar requirement.
> 
This is actually true, but as other block device drivers create the
LUN (or the equivalent thereof), the request queue, and the block device
at the same time or under control of the driver itself they don't have
this problem.
It's only due to the decoupling of the block driver from the underlying
device (ie sd driver and scsi_device) when this problem arises.

> But the dependencies in 3 and 4 are unnecessary.  They are artifacts,
> caused by the fact that a kobject doesn't drop its reference to its
> parent until it is released.  If instead the reference to the parent
> were dropped when the kobject was removed then 3 and 4 wouldn't apply.
> 
And should be okay as the device isn't accessible from userland
anyway after doing a device_del(). And the implication is that it's
going to be remove soon entirely. So we're just moving the timing
of the eventual call to the ->release() function; the events will
be triggered by device_del() and won't be changed.
And if some device actually requires a reference to the parent
during ->release() it can as well acquire it manually and shouldn't
rely on the core logic to do that automatically.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
