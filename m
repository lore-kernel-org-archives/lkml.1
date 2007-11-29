Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbXK2PmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbXK2PmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbXK2PmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:42:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41951 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756750AbXK2PmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:42:14 -0500
Date: Thu, 29 Nov 2007 10:42:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
In-Reply-To: <20071129061814.GJ26327@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711291029060.4516-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Greg KH wrote:

> > > The other kobject fields which should be set, directly or indirectly, by
> > > the creator are its ktype, kset, and parent. We will get to those shortly,
> > > however please note that the ktype and kset must be set before the
> > > kobject_init() function is called.
> > 
> > In fact kset, ktype, and parent are optional, right?  You might mention
> > at this point that not all those fields are needed, and explain later
> > which combinations are legal.
> 
> They are optional, but if you want to do anything, you need to set them :)

You don't need to set kset, do you?  Or parent -- especially if kset is 
set instead.  Certainly kobjects without one or the other of those are 
useful.


> > It's worth mentioning here (and perhaps elsewhere too) that all of the
> > function calls described here can sleep and hence must be made in
> > process context, with the exception of the *_get() routines.  It's
> > possible to call *_put() in atomic context; the SCSI core does this
> > (with device_put, not kobject_put) and has to jump through hoops to run
> > the corresponding release routine in a waitqueue task.  In general,
> > though, it isn't safe.
> 
> Is this really needed?  If anyone calls them from non-process context,
> they will get a nasty run-time warning, right?

IMO it's better to let people know up front.  Otherwise they might get 
some misconception fixed in their brain, misdesign their drivers, and 
have to change a large hunk of code when they discover it doesn't work 
at runtime.

That's the whole point of documentation in the first place, right?  To
tell people how the code is supposed to be used.


> > Why not?  What's wrong with static kobjects?  I've never understood this.
> 
> They are reference counted.  Other portions of the kernel can grab them
> and think they are safe to use.  If you do this with a static object,
> what happens when the code goes away?

Let's see.  The error scenario you propose is that a loadable module 
contains a static kobject and the kobject's refcount is still positive 
when the module is unloaded.  Then the holder of the remaining 
reference tries to access the kobject and crashes.  Yes, that's bad.

But turn it around: Suppose the kobject were allocated dynamically
instead.  It would remain in memory when the owning module was
unloaded, but its release method would go away along with the rest of
the module.  When the last remaining reference is dropped there would
be a crash anyway.

Evidently the bug here is allowing the module to be unloaded while one 
of its kobjects still has a positive refcount.  It doesn't matter 
whether the kobject was allocated statically or dynamically.

> Most of the nasty race conditions that require this are now cleaned up
> with Tejun's great sysfs work, so you will probably not see problems if
> you do this, but in general, it's not a good thing to do.

What about static kobjects in built-in (non-modular) kernel code?  
Especially if the kobject in question is never released?

Alan Stern

