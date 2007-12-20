Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbXLTVww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbXLTVww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbXLTVwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:52:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58519 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbXLTVwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:52:31 -0500
Date: Thu, 20 Dec 2007 13:27:00 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC] kobject/kset/ktype documentation and example code updated
Message-ID: <20071220212700.GB5808@kroah.com>
References: <20071220003031.GA15129@kroah.com> <20071219223206.ada18362.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071219223206.ada18362.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 10:32:06PM -0800, Randy Dunlap wrote:
> On Wed, 19 Dec 2007 16:30:31 -0800 Greg KH wrote:
> 
> > Everything you never wanted to know about kobjects, ksets, and ktypes
> > 
> > Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > Based on an original article by Jon Corbet for lwn.net written October 1,
> > 2003 and located at http://lwn.net/Articles/51437/
> > 
> > Last updated December 19, 2007
> > 
> > 
> ...
> >  - A ktype is the type of object that embeds a kobject. Every structure
> >    that embeds a kobject needs a corresponding ktype.  The ktype controls
> >    what happens when a kobject is no longer referenced and the kobject's
> >    default representation in sysfs.
> 
> I can't quite parse the last sentence above.  Is it:
> 
> The ktype controls (a) what happens ...
> and (b) the kobject's default representation in sysfs.
> 
> ?

How about:
	- A ktype is the type of object that embeds a kobject.  Every
	  structure that embeds a kobject needs a corresponding ktype.
	  The ktype controls what happens to the kobject when it is
	  created and destroyed.

> > Embedding kobjects
> > 
> > So, for example, the UIO code has a structure that defines the memory
> > region associated with a uio device:
> > 
> > struct uio_mem {
> > 	struct kobject kobj;
> > 	unsigned long addr;
> > 	unsigned long size;
> > 	int memtype;
> > 	void __iomem *internal_addr;
> > };
> > 
> > If you have a struct uio_mem structure, finding its embedded kobject is
> > just a matter of using the kobj structure.  Code that works with kobjects
> > will often have the opposite problem, however: given a struct kobject
> > pointer, what is the pointer to the containing structure?  You must avoid
> > tricks (such as assuming that the kobject is at the beginning of the
> > structure) and, instead, use the container_of() macro, found in
> > <linux/kernel.h>:
> > 
> > 	container_of(pointer, type, member)
> > 
> > where pointer is the pointer to the embedded kobject, type is the type of
> > the containing structure, and member is the name of the structure field to
> > which pointer points.  The return value from container_of() is a pointer to
> > the given type. So, for example, a pointer to a struct kobject embedded
> 
> This is (still) confusing to me.  Is it:
>                                    a pointer "kp" to a ...
> or is struct uio_mem the "kp"?

How about:
	 So, for example, a pointer "kp" to a struct kobject
	 embedded within a struct uio_mem could be converted to a
	 pointer to the containing uio_mem structure with:

> > within a struct uio_mem called "kp" could be converted to a pointer to the
> > containing structure with:
> > 
> >     struct uio_mem *u_mem = container_of(kp, struct uio_mem, kobj);
> > 
> > Programmers will often define a simple macro for "back-casting" kobject
> 
> Drop the "will".

dropped.

> > pointers to the containing type.
> > 
> > 
> > Initialization of kobjects
> > 
> > 
> >     int kobject_add(struct kobject *kobj, struct kobject *parent, const char *fmt, ...);
> > 
> > This sets up the parent of the kobject, and the name for the kobject
> 
> Drop the comma.

dropped.

> > properly.  If the kobject is to be associated with a specific kset, that
> > assignment must be done before calling kobject_add().  If a kset is
> > associated with a kobject, then the parent for the kobject can be set to
> > NULL in the call to kobject_add() and then the kobject will be placed under
> > the kset itself.
> > 
> > As the name of the kobject is set when it is added to the kernel, the name
> > of the kobject should never be manipulated directly.  If you must change
> > the name of the kobject, call kobject_rename():
> > 
> >     int kobject_rename(struct kobject *kobj, const char *new_name);
> > 
> > There is a function called kobject_set_name() but that is legacy cruft and
> > is being removed.  If your code needs to call this function, it is
> > incorrect and needs to be fixed.
> 
> Is kobject_set_name() marked as __deprecated ?

No.  Core code that everyone uses still uses this function, including
the kobject core, so to mark it __deprecated would not make much sense.
Once I clean up the core code, I'll just delete it from the whole kernel
:)

> > Uevents
> > 
> > After a kobject has been registered with the kobject core, it needs to be
> > announced to the world that it has been created.  This can be done with
> > call to kobject_uevent():
> 
>   a call ...

Heh, thanks.

> >     int kobject_uevent(struct kobject *kobj, enum kobject_action action);
> > 
> > Use the KOBJ_ADD action for when the kobject is first added to the kernel.
> > This should be done only after any attributes or children of the kobject
> > have been initialized properly, as userspace will instantly start to look
> 
> 		s/will/may/

No, it's usually a "will", as udev is damm fast these days :)

> > 
> > Because kobjects are dynamic, they must not be declared statically or on
> > the stack, but instead, always allocated from the heap.  Future versions of
> 
> The kernel has heapspace?

Heh, sorry.  Now fixed.

> > the kernel will contain a run-time check for kobjects that are created
> > statically and will warn the developer of this improper usage.
> > 
> > If all that you are wanting to use a kobject for is to provide a reference
> 
>   If all that you want to use a kobject for is to provide a reference

Thanks, fixed.

> > counter for your structure, please use the struct kref instead, a kobject
> > would be overkill.  For more information on how to use struct kref, please
> > see the file, Documentation/kref.txt in the Linux kernel source tree.
> 
> Drop comma.

dropped.

> > Both types of attributes used here, with a kobject that has been created
> > with the kobject_create_and_add() can be of type kobj_attribute, no special
> > custom attribute is needed to be created.
> 
> ^ multi-run-on sentences....

Is this better:
	Both types of attributes used here, with a kobject that has been
	created with the kobject_create_and_add(), can be of type
	kobj_attribute, so no special custom attribute is needed to be
	created.

If not, any suggestions?

> >     void my_object_release(struct kobject *kobj)
> >     {
> >     	    struct my_object *mine = container_of(kobj, struct my_object, kobj);
> > 
> > 	    /* Perform any additional cleanup on this object, then... */
> > 	    kfree (mine);
> 
> No space after "kfree".  :)

Heh, fixed.

> > One important point cannot be overstated: every kobject must have a
> > release() method, and the kobject must persist (in a consistent state)
> > until that method is called. If these constraints are not met, the code is
> > flawed.  Note that the kernel will warn you if you forget to provide a
> > release() method.  Do not try to get rid of this warning by providing an
> > "empty" release function, you will be mocked mercilessly by the kobject
> 
> s/,/;/

fixed.

> > Any initialization of the kobject that has been done will be automatically
> > cleaned up by the kobject core.  If a KOBJ_ADD uevent has been sent for
> > the object, a corrisponding KOBJ_REMOVE uevent will be sent, and any other
> 
>                 corresponding

/me kicks his spell checker for missing this.

thanks for the review, I really appreciate it.

greg k-h
