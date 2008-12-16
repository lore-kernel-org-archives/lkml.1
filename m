Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYLPVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYLPVXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 16:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbYLPVXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:23:12 -0500
Received: from kroah.org ([198.145.64.141]:50222 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753273AbYLPVXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:23:11 -0500
Date: Tue, 16 Dec 2008 13:21:50 -0800
From: Greg KH <greg@kroah.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, v4l <video4linux-list@redhat.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: [BUG] cdev_put() race condition
Message-ID: <20081216212150.GA20721@kroah.com>
References: <200812082156.26522.hverkuil@xs4all.nl> <20081216202248.GA3653@kroah.com> <200812162200.52260.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812162200.52260.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 10:00:51PM +0100, Hans Verkuil wrote:
> On Tuesday 16 December 2008 21:22:48 Greg KH wrote:
> > On Mon, Dec 08, 2008 at 09:56:26PM +0100, Hans Verkuil wrote:
> > > Hi Greg,
> > > 
> > > Laurent found a race condition in the uvc driver that we traced to the 
> > > way chrdev_open and cdev_put/get work.
> > > 
> > > You need the following ingredients to reproduce it:
> > > 
> > > 1) a hot-pluggable char device like an USB webcam.
> > > 2) a manually created device node for such a webcam instead of relying 
> > > on udev.
> > > 
> > > In order to easily force this situation you would also need to add a  
> > > delay to the char device's release() function. For webcams that would 
> > > be at the top of v4l2_chardev_release() in 
> > > drivers/media/video/v4l2-dev.c. But adding a delay to e.g. cdev_purge 
> > > would have the same effect.
> > > 
> > > The sequence of events in the case of a webcam is as follows:
> > > 
> > > 1) The USB device is removed, causing a disconnect.
> > > 
> > > 2) The webcam driver unregisters the video device which in turn calls 
> > > cdev_del().
> > > 
> > > 3) When the last application using the device is closed, the cdev is 
> > > released when the kref of the cdev's kobject goes to 0.
> > > 
> > > 4) If the kref's release() call takes a while due to e.g. extra cleanup 
> > > in the case of a webcam, then another application can try to open the 
> > > video device. Note that this requires a device node created with mknod, 
> > > otherwise the device nodes would already have been removed by udev.
> > > 
> > > 5) chrdev_open checks inode->i_cdev. If this is NULL (i.e. this device 
> > > node was never accessed before), then all is fine since kobj_lookup 
> > > will fail because cdev_del() has been called earlier. However, if this 
> > > device node was used earlier, then the else part is called: 
> > > cdev_get(p). This 'p' is the cdev that is being released. Since the 
> > > kref count is 0 you will get a WARN message from kref_get, but the code 
> > > continues on, the f_op->open will (hopefully) return more-or-less 
> > > gracefully with an error and the cdev_put at the end will cause the 
> > > refcount to go to 0 again, which results in a SECOND call to the kref's 
> > > release function!
> > > 
> > > See this link for the original discussion on the v4l list containing 
> > > stack traces an a patch that you need if you want to (and can) test 
> > > this with the uvc driver:
> > > 
> > > http://www.spinics.net/lists/vfl/msg39967.html
> > 
> > The second sentence in that message shows your problem here:
> > 	To avoid the need of a reference count in every v4l2 driver,
> > 	v4l2 moved to cdev which includes its own reference counting
> > 	infrastructure based on kobject.
> > 
> > cdev is not ment to handle the reference counting of any object outside
> > of itself, and should never be embedded within anything.  I've been
> > thinking of taking the real "kobject" out of that structure for a long
> > time now, incase someone did something foolish like this.
> > 
> > Seems I was too late :(
> > 
> > So, to solve this, just remove the reliance on struct cdev in your own
> > structures, you don't want to do this for the very reason you have now
> > found (and for others, like the fact that this isn't a "real" struct
> > kobject in play here, just a fake one.)
> > 
> > Ick, what a mess.
> 
> Sorry, but this makes no sense. First of all the race condition exists
> regardless of how v4l uses it. Other drivers using cdev with a
> hot-pluggable device in combination with a manually created device
> node should show the same problem.

I don't see how this would be, unless this problem has always existed in
the cdev code, it was created back before dynamic device nodes with udev
existed :)

> It's just that we found it with v4l because the release callback takes
> longer than usual, thus increasing the chances of hitting the race.

The release callback for the cdev itself?

> The core problem is simply that it is possible to call cdev_get while
> in cdev_put! That should never happen.

True, and cdev_put is only called from __fput() which has the proper
locking to handle the call to cdev_get() if a char device is opened,
right?

> Secondly, why shouldn't struct cdev be embedded in anything? It's used
> in lots of drivers that way. I really don't see what's unusual or
> messy about v4l in that respect.

I don't see it embedded in any other structures at the moment, and used
to reference count the structure, do you have pointers to where it is?

thanks,

greg k-h
