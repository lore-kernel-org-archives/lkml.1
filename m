Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbXK2GQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbXK2GQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 01:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXK2GQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 01:16:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58280 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbXK2GQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 01:16:14 -0500
Date: Wed, 28 Nov 2007 22:18:14 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071129061814.GJ26327@kroah.com>
References: <20071127230252.GB10038@kroah.com> <Pine.LNX.4.44L0.0711281359440.5566-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711281359440.5566-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 02:03:28PM -0500, Alan Stern wrote:
> On Tue, 27 Nov 2007, Greg KH wrote:
> 
> > Part of the difficulty in understanding the driver model - and the kobject
> > abstraction upon which it is built - is that there is no obvious starting
> > place. Dealing with kobjects requires understanding a few different types,
> > all of which make reference to each other. In an attempt to make things
> > easier, we'll take a multi-pass approach, starting with vague terms and
> > adding detail as we go. To that end, here are some quick definitions of
> > some terms we will be working with.
> > 
> >  - A kobject is an object of type struct kobject.  Kobjects have a name
> >    and a reference count.  A kobject also has a parent pointer (allowing
> >    objects to be arranged into hierarchies), a specific type, and,
> >    usually, a representation in the sysfs virtual filesystem.
> 
> As Cornelia said, it would be worthwhile mentioning krefs in this
> document as well.  They are simple enough to explain, after all.

Now added, thanks.

> > Initialization of kobjects
> > 
> > Code which creates a kobject must, of course, initialize that object. Some
> > of the internal fields are setup with a (mandatory) call to kobject_init():
> 
> kobject_init() isn't mandatory if you use kobject_register().  But then 
> Kay wants to do away with kobject_register()...
> 
> > The other kobject fields which should be set, directly or indirectly, by
> > the creator are its ktype, kset, and parent. We will get to those shortly,
> > however please note that the ktype and kset must be set before the
> > kobject_init() function is called.
> 
> In fact kset, ktype, and parent are optional, right?  You might mention
> at this point that not all those fields are needed, and explain later
> which combinations are legal.

They are optional, but if you want to do anything, you need to set them :)

> > When a reference is released, the call to kobject_put() will decrement the
> > reference count and, possibly, free the object. Note that kobject_init()
> > sets the reference count to one, so the code which sets up the kobject will
> > need to do a kobject_put() eventually to release that reference.
> 
> It's worth mentioning here (and perhaps elsewhere too) that all of the
> function calls described here can sleep and hence must be made in
> process context, with the exception of the *_get() routines.  It's
> possible to call *_put() in atomic context; the SCSI core does this
> (with device_put, not kobject_put) and has to jump through hoops to run
> the corresponding release routine in a waitqueue task.  In general,
> though, it isn't safe.

Is this really needed?  If anyone calls them from non-process context,
they will get a nasty run-time warning, right?

> > Because kobjects are dynamic, they must not be declared statically or on
> > the stack, but instead, always from the heap.  Future versions of the
> > kernel will contain a run-time check for kobjects that are created
> > statically and will warn the developer of this improper usage.
> 
> Why not?  What's wrong with static kobjects?  I've never understood this.

They are reference counted.  Other portions of the kernel can grab them
and think they are safe to use.  If you do this with a static object,
what happens when the code goes away?

Most of the nasty race conditions that require this are now cleaned up
with Tejun's great sysfs work, so you will probably not see problems if
you do this, but in general, it's not a good thing to do.

> > ktypes and release methods
> > 
> > One important thing still missing from the discussion is what happens to a
> > kobject when its reference count reaches zero. The code which created the
> > kobject generally does not know when that will happen; if it did, there
> > would be little point in using a kobject in the first place. Even
> > predicatable object lifecycles become more complicated when sysfs is
> 
> predictable

thanks.

> > One important point cannot be overstated: every kobject must have a
> > release() method, and the kobject must persist (in a consistent state)
> > until that method is called. If these constraints are not met, the code is
> > flawed.  Note that the kernel will warn you if you forget to provide a
> > release() method.  Do not try to get rid of this warning by providing an
> > "empty" release function, you will be mocked merciously by the kobject
> > maintainer if you attempt this.
> 
> Not to mention that doing this will leak memory.  Unless the kobject
> is static...

heh.

I think your other questions are already answered, right?

thanks,

greg k-h
