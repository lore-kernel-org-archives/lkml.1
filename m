Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbXK2F5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbXK2F5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 00:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbXK2F47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 00:56:59 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54684 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbXK2F46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 00:56:58 -0500
Date: Wed, 28 Nov 2007 21:59:02 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071129055902.GC26327@kroah.com>
References: <20071127230252.GB10038@kroah.com> <20071128100108.45fcbf15@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128100108.45fcbf15@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 10:01:08AM +0100, Cornelia Huck wrote:
> On Tue, 27 Nov 2007 15:02:52 -0800,
> Greg KH <greg@kroah.com> wrote:
> > So, for example, UIO code has a structure that defines the memory region
> > associated with a uio device:
> > 
> > struct uio_mem {
> > 	struct kobject kobj;
> > 	unsigned long addr;
> > 	unsigned long size;
> > 	int memtype;
> > 	void __iomem *internal_addr;
> > };
> > 
> > If you have a struct uio_mem structure, finding its embedded kobject is just a
> > matter of using the kobj pointer.  
> 
> Pointer may be a confusing term, how about "structure member"?

thanks, now fixed.

> > Code that works with kobjects will often
> > have the opposite problem, however: given a struct kobject pointer, what is
> > the pointer to the containing structure?  You must avoid tricks (such as
> > assuming that the kobject is at the beginning of the structure) and,
> > instead, use the container_of() macro, found in <linux/kernel.h>:
> > 
> > 	container_of(pointer, type, member)
> > 
> > where pointer is the pointer to the embedded kobject, type is the type of
> > the containing structure, and member is the name of the structure field to
> > which pointer points.  The return value from container_of() is a pointer to
> > the given type. So, for example, a pointer to a struct kobject embedded
> > within a struct cdev called "kp" could be converted to a pointer to the
> 
> "struct uio_mem", I guess.

yes, now fixed.

> > containing structure with:
> > 
> >     struct uio_mem *u_mem = container_of(kp, struct uio_mem, kobj);
> > 
> > Programmers will often define a simple macro for "back-casting" kobject
> > pointers to the containing type.
> > 
> > 
> > Initialization of kobjects
> > 
> > Code which creates a kobject must, of course, initialize that object. Some
> > of the internal fields are setup with a (mandatory) call to kobject_init():
> > 
> >     void kobject_init(struct kobject *kobj);
> > 
> > Among other things, kobject_init() sets the kobject's reference count to
> > one.  Calling kobject_init() is not sufficient, however. Kobject users
> > must, at a minimum, set the name of the kobject; this is the name that will
> > be used in sysfs entries. 
> 
> Unless they don't register their kobject. (But they should always set a
> name anyway to avoid funny debug messages, so it is probably a good
> idea to call this a "must").

Yeah, I'll leave this in.

> > To set the name of a kobject properly, do not
> > attempt to manipulate the internal name field, but instead use:
> > 
> >     int kobject_set_name(struct kobject *kobj, const char *format, ...);
> > 
> > This function takes a printk-style variable argument list. Believe it or
> > not, it is actually possible for this operation to fail; conscientious code
> > should check the return value and react accordingly.
> > 
> > The other kobject fields which should be set, directly or indirectly, by
> > the creator are its ktype, kset, and parent. We will get to those shortly,
> > however please note that the ktype and kset must be set before the
> > kobject_init() function is called.
> > 
> > 
> > 
> > Reference counts
> > 
> > One of the key functions of a kobject is to serve as a reference counter
> > for the object in which it is embedded. 
> 
> Hm, I thought that was the purpose of struct kref?

Yes, I'll add a reference to kref now.

> > As long as references to the object
> > exist, the object (and the code which supports it) must continue to exist.
> > The low-level functions for manipulating a kobject's reference counts are:
> > 
> >     struct kobject *kobject_get(struct kobject *kobj);
> >     void kobject_put(struct kobject *kobj);
> > 
> > A successful call to kobject_get() will increment the kobject's reference
> > counter and return the pointer to the kobject. If, however, the kobject is
> > already in the process of being destroyed, the operation will fail and
> > kobject_get() will return NULL. 
> 
> Eh, no. We'll always return !NULL if the kobject is !NULL to start
> with. If the reference count is already 0, the code will moan, but the
> caller will still get a pointer.

Good point, this was the way things used to work a long time ago, I'll remove
this.

> > This return value must always be tested, or
> > no end of unpleasant race conditions could result.
> > 
> > When a reference is released, the call to kobject_put() will decrement the
> > reference count and, possibly, free the object. Note that kobject_init()
> > sets the reference count to one, so the code which sets up the kobject will
> > need to do a kobject_put() eventually to release that reference.
> > 
> > Because kobjects are dynamic, they must not be declared statically or on
> > the stack, but instead, always from the heap.  Future versions of the
> > kernel will contain a run-time check for kobjects that are created
> > statically and will warn the developer of this improper usage.
> > 
> > 
> > Hooking into sysfs
> > 
> > An initialized kobject will perform reference counting without trouble, but
> > it will not appear in sysfs. To create sysfs entries, kernel code must pass
> > the object to kobject_add():
> > 
> >     int kobject_add(struct kobject *kobj);
> > 
> > As always, this operation can fail. The function:
> > 
> >     void kobject_del(struct kobject *kobj);
> > 
> > will remove the kobject from sysfs.
> > 
> > There is a kobject_register() function, which is really just the
> > combination of the calls to kobject_init() and kobject_add().
> 
> Plus the uevent.
> 
> >  Similarly,
> > kobject_unregister() will call kobject_del(), then call kobject_put() to
> > release the initial reference created with kobject_register() (or really
> > kobject_init()).
> 
> And also throw a uevent :)

Heh, ok, I've now added this for both :)

> > Creating "simple" kobjects
> > 
> > Sometimes all that a developer wants is a way to create a simple directory
> > in the sysfs heirachy, and not have to mess with the whole complication of
> 
> hierarchy

thanks.

> > ktypes and release methods
> > 
> > One important thing still missing from the discussion is what happens to a
> > kobject when its reference count reaches zero. The code which created the
> > kobject generally does not know when that will happen; if it did, there
> > would be little point in using a kobject in the first place. Even
> > predicatable object lifecycles become more complicated when sysfs is
> > brought in; user-space programs can keep a reference to a kobject (by
> > keeping one of its associated sysfs files open) for an arbitrary period of
> > time.
> 
> This is no longer true?
> 
> The major problem is that registered kobjects can be looked-up by other
> kernel code that can get a reference.

yes, you are right.

> > The end result is that a structure protected by a kobject cannot be freed
> > before its reference count goes to zero. The reference count is not under
> > the direct control of the code which created the kobject. So that code must
> > be notified asynchronously whenever the last reference to one of its
> > kobjects goes away.
> 
> We should perhaps add a bit fat warning here:
> 
> Note that once you registered your kobject via kobject_add(), you must
> never use kfree() to free it directly. The only safe way is to use
> kobject_put(). It is good practice to always use kobject_put() after
> kobject_init() to avoid errors creeping in.

Now added, thanks.

thanks for the review, I really appreciate it.

greg k-h
