Return-Path: <linux-kernel-owner+w=401wt.eu-S1751440AbXBRQoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbXBRQoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 11:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXBRQoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 11:44:30 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:11251 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751440AbXBRQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 11:44:30 -0500
Date: Sun, 18 Feb 2007 11:44:28 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Douglas Gilbert <dougg@torque.net>
cc: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Block layer: separate out queue-oriented ioctls
In-Reply-To: <45D7CB46.6060807@torque.net>
Message-ID: <Pine.LNX.4.44L0.0702181124450.6341-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Feb 2007, Douglas Gilbert wrote:

> Jens Axboe wrote:
> > On Fri, Feb 16 2007, Alan Stern wrote:
> >> From: James Bottomley <James.Bottomley@SteelEye.com>
> >>
> >> This patch (as854) separates out the two queue-oriented ioctls from
> >> the rest of the block-layer ioctls.  The idea is that they should
> >> apply to any driver using a request_queue, even if the driver doesn't
> >> implement a block-device interface.  The prototypical example is the
> >> sg driver, to which the patch adds the new interface.
> >>
> >> This will make it possible for cdrecord and related programs to
> >> retrieve reliably the max_sectors value, regardless of whether the
> >> user points it to an sr or an sg device.  In particular, this will
> >> resolve Bugzilla entry #7026.
> > 
> > The block bits are fine with me, the sg calling point is a bit of a sore
> > thumb (a char driver calling into block layer ioctls) though. So the
> > block layer bits are certainly ok with me, if Doug acks the sg bit I'll
> > merge everything up.
> > 
> > (patch left below)
> 
> Does this need to be in the sg driver?

Something like it does.  Otherwise cdrecord (or any other sg user) has no
way to retrieve the max_sectors value for sg devices.

> What is the hardware sector size of a SES or OSD device?

I have no idea, and I don't see why it is relevant.  (I don't even know 
what "SES" and "OSD" refer to.)

> As for the max_sector variable, wouldn't it be better
> to generate a new ioctl that yielded the limit in bytes?

Maybe.  I wouldn't mind doing it that way.  But we would have to leave in 
the old ioctl, and we probably would still want it to be usable for sg 
devices.  Not to mention that it would be silly to have two ioctls which 
always return exactly the same values except for a factor of 512.

> Making a driver variable that implicitly assumes sectors
> are 512 bytes in length more visible to the user space
> seems like a step in the wrong direction.
> 
> Alternatively the SG_GET_RESERVED_SIZE ioctl could be
> modified to yield no more than max_sectors*512 .

There should be one single ioctl which can be applied uniformly to all
CD-type devices (in fact, to all devices using a request_queue) to learn
max_sectors.  This rules out using SG_GET_RESERVED_SIZE.

Furthermore, if you changed SG_GET_RESERVED_SIZE in this way you would 
only increase the confusion.  The reserved size isn't directly related to 
the maximum allowed DMA length, and there's no point pretending it is.  
What if it turns out that the reserved size is smaller than max_sectors?  
Then you'd force user programs to do I/O in chunks that were smaller than 
necessary.

> >> +	/* block ioctls first */
> 
> Why first??

I don't know -- James will have to answer.  I don't see that it makes any 
real difference; the new code can easily be moved to the end.

> That would allow the block layer to overtake any currently
> defined and working sg ioctl.
> Surely, if it was put in, it should be in the default case.

Would the patch be okay with you if I rework it to put the new ioctls 
under the default case in sg?

Alan Stern

