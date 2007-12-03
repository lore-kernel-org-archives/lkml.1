Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbXLCMAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbXLCMAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 07:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXLCMAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 07:00:42 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:42032 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbXLCMAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 07:00:41 -0500
Date: Mon, 3 Dec 2007 13:00:03 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng, kobject_add_ng, and
 kobject_init_and_add functions
Message-ID: <20071203130003.06afbf61@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0711302211450.4181-100000@netrider.rowland.org>
References: <20071201010123.GC4745@kroah.com>
	<Pine.LNX.4.44L0.0711302211450.4181-100000@netrider.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 22:29:39 -0500 (EST),
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Fri, 30 Nov 2007, Greg KH wrote:
> 
> >  /**
> > + * kobject_init_ng - initialize a kobject structure
> > + * @kobj: pointer to the kobject to initialize
> > + * @ktype: pointer to the ktype for this kobject.
> > + * @parent: pointer to the parent of this kobject.
> > + * @fmt: the name of the kobject.
> > + *
> > + * This function will properly initialize a kobject such that it can then
> > + * be passed to the kobject_add() call.
> > + *
> > + * If the function returns an error, the memory allocated by the kobject
> > + * can be safely freed, no other functions need to be called.
> > + */
> > +void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype)
> 
> Kerneldoc needs to be updated -- no @parent or @fmt.  Also no error
> returns.  But you could say that after this routine runs, the kobject
> should be deallocated by kobject_put() and not by calling kfree()
> directly.

Hm, after calling kobject_init_ng() is also the earliest point that you
can rely on kobject_put() really cleaning stuff up. Both kobject_put()
and kfree() are fine then, but I think kobject_put() makes for cleaner
code.

> 
> > +/**
> > + * kobject_add_ng - the main kobject add function
> > + * @kobj: the kobject to add
> > + * @parent: pointer to the parent of the kobject.
> > + *
> > + * The kobject name is set and added to the kobject hierarchy in this
> > + * function.
> > + *
> > + * If @parent is set, then the parent of the @kobj will be set to it.
> > + * If @parent is NULL, then the parent of the @kobj will be set to the
> > + * kobject associted with the kset assigned to this kobject.  If no kset
> > + * is assigned to the kobject, then the kobject will be located in the
> > + * root of the sysfs tree.
> > + *
> > + * If this function returns an error, kobject_put() must be called to
> > + * properly clean up the memory associated with the object.
> > + *
> > + * If the function is successful, the only way to properly clean up the
> > + * memory is with a call to kobject_del().
> 
> In which case kobject_put() isn't needed?

kobject_del() should only undo what kobject_add() did. So kobject_put()
will still be needed to clean up the memory. Perhaps the wording should
be:

If the function is successful, the only way to properly clean up the
kobject is to call kobject_del() for removing the kobject from the
hierarchy and to subsequently call kobject_put() to clean up the memory.

> 
> > + *
> > + * Under no instance should the kobject that is passed to this function
> > + * be directly freed with a call to kfree(), that can leak memory.
> > + */
> 
> Should you say something here about uevents?

Probably not. Callers of kobject_add() always had to create the uevent
themselves; it was only with kobject_register() they could rely on the
uevent being created.

> 
> > +int kobject_add_ng(struct kobject *kobj, struct kobject *parent,
> > +		   const char *fmt, ...)
> > +{
> > +	va_list args;
> > +	int retval;
> > +
> > +	if (!kobj)
> > +		return -EINVAL;
> > +
> > +	va_start(args, fmt);
> > +	retval = kobject_set_name_vargs(kobj, fmt, args);
> > +	va_end(args);
> > +	if (retval) {
> > +		printk(KERN_ERR "kobject: can not set name properly!\n");
> > +		return retval;
> > +	}
> > +	kobj->parent = parent;
> > +	return kobject_add(kobj);
> > +}
> > +EXPORT_SYMBOL(kobject_add_ng);
> 
> Looks like this should call kobject_add_varg() instead of duplicating
> its code.

Agreed. And how about "cannot" or "could not" instead of "can not"?

> 
> > +/**
> > + * kobject_init_and_add - initialize a kobject structure and add it to the kobject hierarchy
> > + * @kobj: pointer to the kobject to initialize
> > + * @ktype: pointer to the ktype for this kobject.
> > + * @parent: pointer to the parent of this kobject.
> > + * @fmt: the name of the kobject.
> > + *
> > + * This function will properly initialize a kobject and then call
> > + * kobject_add().
> > + *
> > + * If the function returns an error, the kobject passed to this function
> > + * must be cleaned up by calling kobject_put(), and not by directly
> > + * trying to call kfree() on the kobject.
> > + *
> > + * If this function succeeds, the only way to properly clean up the
> > + * kobject is to call kobject_destroy(), which will clean up all of the
> 
> kobject_destroy()?  Where did that come from?  Or did you mean 
> kobject_del()?

This sentence makes only sense if kobject_destroy() is something like
kobject_unregister_ng().

> 
> > + * needed sysfs objects, and the kobject itself (by calling back to the
> > + * ktype->release() function.)
> > + *
> > + * Note that the kobject_uevent() call should be called after this
> > + * function succeeds, so that userspace can properly know that the
> > + * kobject was created.
> > + */
> 
> Could the comments be made shorter by saying merely that this routine 
> combines calls to kobject_init() and kobject_add_ng()?

I think it should be made explicit which actions are OK after failure
or success of this function since that is what people easily get wrong.

> 
> > +int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
> > +			 struct kobject *parent, const char *fmt, ...)
> > +{
> > +	va_list args;
> > +	int retval;
> > +
> > +	kobject_init_ng(kobj, ktype);
> > +
> > +	va_start(args, fmt);
> > +	retval = kobject_add_varg(kobj, parent, fmt, args);
> > +	va_end(args);
> > +
> > +	return retval;
> > +}
> > +EXPORT_SYMBOL(kobject_init_and_add);
> 
> Looks okay.

Agreed.

> 
> Did you want to add an extra kobject_put() to the end of kobject_del()?  

This would be surprising: I wouldn't expect a kobject to be cleaned up
just because I removed it from the hierarchy.

> Or did you want to define a new kobject_destroy() that combines calls 
> to kobject_del() and kobject_put()?

This looks saner.
