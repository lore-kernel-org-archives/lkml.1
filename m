Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbXK1JB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbXK1JB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXK1JBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:01:14 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:17259 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbXK1JBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:01:13 -0500
Date: Wed, 28 Nov 2007 10:01:08 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071128100108.45fcbf15@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071127230252.GB10038@kroah.com>
References: <20071127230252.GB10038@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 15:02:52 -0800,
Greg KH <greg@kroah.com> wrote:

> So, while it is all relativly fresh in my mind, I thought it would be
> good to also document the whole mess, and provide some solid example
> code for others to use in the future.

Cool.


> Embedding kobjects
> 
> It is rare (even unknown) for kernel code to create a standalone kobject;

Unknown? It's the less common case, I'd say.

> with one major exception explained below.  Instead, kobjects are used to
> control access to a larger, domain-specific object.  To this end, kobjects
> will be found embedded in other structures.  If you are used to thinking of
> things in object-oriented terms, kobjects can be seen as a top-level,
> abstract class from which other classes are derived.  A kobject implements
> a set of capabilities which are not particularly useful by themselves, but
> which are nice to have in other objects. 

Hm, hierarchy and representation in sysfs are useful things by
themselves.

> So, for example, UIO code has a structure that defines the memory region
> associated with a uio device:
> 
> struct uio_mem {
> 	struct kobject kobj;
> 	unsigned long addr;
> 	unsigned long size;
> 	int memtype;
> 	void __iomem *internal_addr;
> };
> 
> If you have a struct uio_mem structure, finding its embedded kobject is just a
> matter of using the kobj pointer.  

Pointer may be a confusing term, how about "structure member"?

> Code that works with kobjects will often
> have the opposite problem, however: given a struct kobject pointer, what is
> the pointer to the containing structure?  You must avoid tricks (such as
> assuming that the kobject is at the beginning of the structure) and,
> instead, use the container_of() macro, found in <linux/kernel.h>:
> 
> 	container_of(pointer, type, member)
> 
> where pointer is the pointer to the embedded kobject, type is the type of
> the containing structure, and member is the name of the structure field to
> which pointer points.  The return value from container_of() is a pointer to
> the given type. So, for example, a pointer to a struct kobject embedded
> within a struct cdev called "kp" could be converted to a pointer to the

"struct uio_mem", I guess.

> containing structure with:
> 
>     struct uio_mem *u_mem = container_of(kp, struct uio_mem, kobj);
> 
> Programmers will often define a simple macro for "back-casting" kobject
> pointers to the containing type.
> 
> 
> Initialization of kobjects
> 
> Code which creates a kobject must, of course, initialize that object. Some
> of the internal fields are setup with a (mandatory) call to kobject_init():
> 
>     void kobject_init(struct kobject *kobj);
> 
> Among other things, kobject_init() sets the kobject's reference count to
> one.  Calling kobject_init() is not sufficient, however. Kobject users
> must, at a minimum, set the name of the kobject; this is the name that will
> be used in sysfs entries. 

Unless they don't register their kobject. (But they should always set a
name anyway to avoid funny debug messages, so it is probably a good
idea to call this a "must").

> To set the name of a kobject properly, do not
> attempt to manipulate the internal name field, but instead use:
> 
>     int kobject_set_name(struct kobject *kobj, const char *format, ...);
> 
> This function takes a printk-style variable argument list. Believe it or
> not, it is actually possible for this operation to fail; conscientious code
> should check the return value and react accordingly.
> 
> The other kobject fields which should be set, directly or indirectly, by
> the creator are its ktype, kset, and parent. We will get to those shortly,
> however please note that the ktype and kset must be set before the
> kobject_init() function is called.
> 
> 
> 
> Reference counts
> 
> One of the key functions of a kobject is to serve as a reference counter
> for the object in which it is embedded. 

Hm, I thought that was the purpose of struct kref?

> As long as references to the object
> exist, the object (and the code which supports it) must continue to exist.
> The low-level functions for manipulating a kobject's reference counts are:
> 
>     struct kobject *kobject_get(struct kobject *kobj);
>     void kobject_put(struct kobject *kobj);
> 
> A successful call to kobject_get() will increment the kobject's reference
> counter and return the pointer to the kobject. If, however, the kobject is
> already in the process of being destroyed, the operation will fail and
> kobject_get() will return NULL. 

Eh, no. We'll always return !NULL if the kobject is !NULL to start
with. If the reference count is already 0, the code will moan, but the
caller will still get a pointer.

> This return value must always be tested, or
> no end of unpleasant race conditions could result.
> 
> When a reference is released, the call to kobject_put() will decrement the
> reference count and, possibly, free the object. Note that kobject_init()
> sets the reference count to one, so the code which sets up the kobject will
> need to do a kobject_put() eventually to release that reference.
> 
> Because kobjects are dynamic, they must not be declared statically or on
> the stack, but instead, always from the heap.  Future versions of the
> kernel will contain a run-time check for kobjects that are created
> statically and will warn the developer of this improper usage.
> 
> 
> Hooking into sysfs
> 
> An initialized kobject will perform reference counting without trouble, but
> it will not appear in sysfs. To create sysfs entries, kernel code must pass
> the object to kobject_add():
> 
>     int kobject_add(struct kobject *kobj);
> 
> As always, this operation can fail. The function:
> 
>     void kobject_del(struct kobject *kobj);
> 
> will remove the kobject from sysfs.
> 
> There is a kobject_register() function, which is really just the
> combination of the calls to kobject_init() and kobject_add().

Plus the uevent.

>  Similarly,
> kobject_unregister() will call kobject_del(), then call kobject_put() to
> release the initial reference created with kobject_register() (or really
> kobject_init()).

And also throw a uevent :)

> 
> 
> Creating "simple" kobjects
> 
> Sometimes all that a developer wants is a way to create a simple directory
> in the sysfs heirachy, and not have to mess with the whole complication of

hierarchy

> ksets, show and store functions, and other details.  To create such an
> entry, use the function:
> 
>     struct kobject *kobject_create_and_register(char *name, struct kobject *parent);
> 
> This function will create a kobject and place it in sysfs in the location
> underneath the specified parent kobject.  To create simple attributes
> associated with this kobject, use:
> 
>     int sysfs_create_file(struct kobject *kobj, struct attribute *attr);
> or
>     int sysfs_create_group(struct kobject *kobj, struct attribute_group *grp);
> 
> Both types of attributes used here, with a kobject that has been created
> with the kobject_create_and_register() can be of type kobj_attribute, no
> special custom attribute is needed to be created.
> 
> See the example module, samples/kobject/kobject-example.c for an
> implementation of a simple kobject and attributes.
> 
> 
> 
> ktypes and release methods
> 
> One important thing still missing from the discussion is what happens to a
> kobject when its reference count reaches zero. The code which created the
> kobject generally does not know when that will happen; if it did, there
> would be little point in using a kobject in the first place. Even
> predicatable object lifecycles become more complicated when sysfs is
> brought in; user-space programs can keep a reference to a kobject (by
> keeping one of its associated sysfs files open) for an arbitrary period of
> time.

This is no longer true?

The major problem is that registered kobjects can be looked-up by other
kernel code that can get a reference.

> 
> The end result is that a structure protected by a kobject cannot be freed
> before its reference count goes to zero. The reference count is not under
> the direct control of the code which created the kobject. So that code must
> be notified asynchronously whenever the last reference to one of its
> kobjects goes away.

We should perhaps add a bit fat warning here:

Note that once you registered your kobject via kobject_add(), you must
never use kfree() to free it directly. The only safe way is to use
kobject_put(). It is good practice to always use kobject_put() after
kobject_init() to avoid errors creeping in.

> 
> This notification is done through a kobject's release() method. Usually
> such a method has a form like:
> 
>     void my_object_release(struct kobject *kobj)
>     {
>     	    struct my_object *mine = container_of(kobj, struct my_object, kobj);
> 
> 	    /* Perform any additional cleanup on this object, then... */
> 	    kfree (mine);
>     }
> 
> One important point cannot be overstated: every kobject must have a
> release() method, and the kobject must persist (in a consistent state)
> until that method is called. 

Which is especially hurting if you use kobjects in modules. (Which
reminds me: Must dig up the patchset that fixes the module unload vs.
release problem.)

> If these constraints are not met, the code is
> flawed.  Note that the kernel will warn you if you forget to provide a
> release() method.  Do not try to get rid of this warning by providing an
> "empty" release function, you will be mocked merciously by the kobject

I think you meant "mercilessly" :)

> maintainer if you attempt this.
> 
> Interestingly, the release() method is not stored in the kobject itself;
> instead, it is associated with the ktype. So let us introduce struct
> kobj_type:
> 
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
> 
> The release field in struct kobj_type is, of course, a pointer to the
> release() method for this type of kobject. The other two fields (sysfs_ops
> and default_attrs) control how objects of this type are represented in
> sysfs; they are beyond the scope of this document.

Attention span ran out, will comment on the rest of this document later.
