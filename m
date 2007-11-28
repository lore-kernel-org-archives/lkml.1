Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbXK1T3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbXK1T3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbXK1T2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:28:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:50064 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbXK1T2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:28:54 -0500
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0711281359440.5566-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711281359440.5566-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 20:28:40 +0100
Message-Id: <1196278120.3242.115.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19C+JlZ0l+pL4xBvkiha6ydt4USrolFtdpGkRT
 NxkYYwGp/zog8gDTi3fDcocEmmKtT8T3Ei6rD6jgKZsnPOFQdU
 XevGSWKXeqtM1Kt5oEgkaGathiGgPEK
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-28 at 14:03 -0500, Alan Stern wrote:
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
> 
> > Initialization of kobjects
> > 
> > Code which creates a kobject must, of course, initialize that object. Some
> > of the internal fields are setup with a (mandatory) call to kobject_init():
> 
> kobject_init() isn't mandatory if you use kobject_register().  But then 
> Kay wants to do away with kobject_register()...

Yeah, it's a kind of convenience that causes far more problems than is
solves. Kobjects are low-level and we depend entirely on proper events
today, so I vote for removal of all the *register* crap.

> > The other kobject fields which should be set, directly or indirectly, by
> > the creator are its ktype, kset, and parent. We will get to those shortly,
> > however please note that the ktype and kset must be set before the
> > kobject_init() function is called.
> 
> In fact kset, ktype, and parent are optional, right?  You might mention
> at this point that not all those fields are needed, and explain later
> which combinations are legal.

Ksets are optional, yes. Ktypes are required for releasing the object,
so we should say they are mandatory.

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

Yes, it's an important point.

> Actually the current code doesn't seem to check whether kobj->ktype is
> NULL or to use the value of kobj->kset->kobj.ktype.  Is this an oversight?

We just require the ktype.

> >  - A kset is also a subdirectory in sysfs, where the associated kobjects
> >    with the kset can show up.  Every kset contains a kobject which can be
> 
> That's where a kobject shows up if its parent field isn't set when
> kobject_add() is called.  But if the parent field _is_ set, does
> anything (such as a symbolic link) show up in the kset's directory?
> 
> > A kset keeps its children in a standard kernel linked list.  Kobjects point
> > back to their containing kset via their kset field. In almost all cases,
> > the contained kobjects also have a pointer to the kset (or, strictly, its
> > embedded kobject) in their parent field.
> 
> "almost all" isn't right.  "In some cases" would be more realistic.

It all depends on the parent pointer, and I think we have far more kobjects
no showing up at the kset like all devices belong to the devices_kset but
only one or two show up directly in the kset directory, all the other are
just childs.

> If there is no containing kset, the parent remains NULL.  What happens
> then?  Does the kobject show up in the sysfs top-level directory?

"If the kobject belonging to a kset has no parent kobject set, it will
be added to the kset's directory. Not all members of a kset do
necessarily live in the kset directory. If an explicit parent kobject is
assigned before the kobject is added, the kobject is registered with the
kset, but added below the parent kobject."

> >  - kset is a pointer to the kset which will contain this kobject; it should
> >    be set prior to calling kobject_init().
> > 
> >  - ktype is the type of the kobject; it should be set prior to calling
> >    kobject_init().
> 
> There are no checks for this!  At least, not until the cleanup occurs.

It does not matter anymore to assign the values before kobject_init(),
but we should mention, that we require a ktype before we add the object.

> Here's a question for you: The code in kobject.c is full of odd things
> like this (from the start of kobject_add):
> 
> 	if (!(kobj = kobject_get(kobj)))
> 		return -ENOENT;
> 
> What's the point of the assignment?  We know that kobject_get() always
> returns its argument.  This sort of thing happens all over the place.

Right, that looks not too useful.

Kay

