Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbXK1TDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbXK1TDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbXK1TDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:03:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52140 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754646AbXK1TDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:03:30 -0500
Date: Wed, 28 Nov 2007 14:03:28 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
In-Reply-To: <20071127230252.GB10038@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711281359440.5566-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Greg KH wrote:

> Part of the difficulty in understanding the driver model - and the kobject
> abstraction upon which it is built - is that there is no obvious starting
> place. Dealing with kobjects requires understanding a few different types,
> all of which make reference to each other. In an attempt to make things
> easier, we'll take a multi-pass approach, starting with vague terms and
> adding detail as we go. To that end, here are some quick definitions of
> some terms we will be working with.
> 
>  - A kobject is an object of type struct kobject.  Kobjects have a name
>    and a reference count.  A kobject also has a parent pointer (allowing
>    objects to be arranged into hierarchies), a specific type, and,
>    usually, a representation in the sysfs virtual filesystem.

As Cornelia said, it would be worthwhile mentioning krefs in this
document as well.  They are simple enough to explain, after all.

> Initialization of kobjects
> 
> Code which creates a kobject must, of course, initialize that object. Some
> of the internal fields are setup with a (mandatory) call to kobject_init():

kobject_init() isn't mandatory if you use kobject_register().  But then 
Kay wants to do away with kobject_register()...

> The other kobject fields which should be set, directly or indirectly, by
> the creator are its ktype, kset, and parent. We will get to those shortly,
> however please note that the ktype and kset must be set before the
> kobject_init() function is called.

In fact kset, ktype, and parent are optional, right?  You might mention
at this point that not all those fields are needed, and explain later
which combinations are legal.

> When a reference is released, the call to kobject_put() will decrement the
> reference count and, possibly, free the object. Note that kobject_init()
> sets the reference count to one, so the code which sets up the kobject will
> need to do a kobject_put() eventually to release that reference.

It's worth mentioning here (and perhaps elsewhere too) that all of the
function calls described here can sleep and hence must be made in
process context, with the exception of the *_get() routines.  It's
possible to call *_put() in atomic context; the SCSI core does this
(with device_put, not kobject_put) and has to jump through hoops to run
the corresponding release routine in a waitqueue task.  In general,
though, it isn't safe.

> Because kobjects are dynamic, they must not be declared statically or on
> the stack, but instead, always from the heap.  Future versions of the
> kernel will contain a run-time check for kobjects that are created
> statically and will warn the developer of this improper usage.

Why not?  What's wrong with static kobjects?  I've never understood this.

> ktypes and release methods
> 
> One important thing still missing from the discussion is what happens to a
> kobject when its reference count reaches zero. The code which created the
> kobject generally does not know when that will happen; if it did, there
> would be little point in using a kobject in the first place. Even
> predicatable object lifecycles become more complicated when sysfs is

predictable

> One important point cannot be overstated: every kobject must have a
> release() method, and the kobject must persist (in a consistent state)
> until that method is called. If these constraints are not met, the code is
> flawed.  Note that the kernel will warn you if you forget to provide a
> release() method.  Do not try to get rid of this warning by providing an
> "empty" release function, you will be mocked merciously by the kobject
> maintainer if you attempt this.

Not to mention that doing this will leak memory.  Unless the kobject
is static...

>     struct kobj_type {
> 	    void (*release)(struct kobject *);
> 	    struct sysfs_ops	*sysfs_ops;
> 	    struct attribute	**default_attrs;
>     };
> 
> This structure is used to describe a particular type of kobject (or, more
> correctly, of containing object). Every kobject needs to have an associated
> kobj_type structure; a pointer to that structure can be placed in the
> kobject's ktype field at initialization time, or (more likely) it can be
> defined by the kobject's containing kset.

Actually the current code doesn't seem to check whether kobj->ktype is
NULL or to use the value of kobj->kset->kobj.ktype.  Is this an oversight?

>  - A kset is also a subdirectory in sysfs, where the associated kobjects
>    with the kset can show up.  Every kset contains a kobject which can be

That's where a kobject shows up if its parent field isn't set when
kobject_add() is called.  But if the parent field _is_ set, does
anything (such as a symbolic link) show up in the kset's directory?

> A kset keeps its children in a standard kernel linked list.  Kobjects point
> back to their containing kset via their kset field. In almost all cases,
> the contained kobjects also have a pointer to the kset (or, strictly, its
> embedded kobject) in their parent field.

"almost all" isn't right.  "In some cases" would be more realistic.

> Kobject initialization again
> 
> Now that we have covered all of that stuff, we can talk in detail about how
> a kobject should be prepared for its existence in the kernel. Here are all
> of the struct kobject fields which must be initialized somehow:
> 
>  - k_name - the name of the object. This fields should always be
>    initialized with kobject_set_name(), or specified in the original call
>    to kobject_create_and_register().
> 
>  - refcount is the kobject's reference count; it is initialized by kobject_init()

There's no need to mention this here.  Not only is it wrong, more
importantly users of kobjects never have to initialize the refcount.

>  - parent is the kobject's parent in whatever hierarchy it belongs to. It
>    can be set explicitly by the creator. If parent is NULL when
>    kobject_add() is called, it will be set to the kobject of the containing
>    kset.

If there is no containing kset, the parent remains NULL.  What happens
then?  Does the kobject show up in the sysfs top-level directory?

>  - kset is a pointer to the kset which will contain this kobject; it should
>    be set prior to calling kobject_init().
> 
>  - ktype is the type of the kobject; it should be set prior to calling
>    kobject_init().

There are no checks for this!  At least, not until the cleanup occurs.

Here's a question for you: The code in kobject.c is full of odd things
like this (from the start of kobject_add):

	if (!(kobj = kobject_get(kobj)))
		return -ENOENT;

What's the point of the assignment?  We know that kobject_get() always
returns its argument.  This sort of thing happens all over the place.

Alan Stern

