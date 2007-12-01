Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbXLAD36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbXLAD36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 22:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbXLAD3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 22:29:43 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4626 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757736AbXLAD3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 22:29:42 -0500
Date: Fri, 30 Nov 2007 22:29:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng, kobject_add_ng, and
 kobject_init_and_add functions
In-Reply-To: <20071201010123.GC4745@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711302211450.4181-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Greg KH wrote:

>  /**
> + * kobject_init_ng - initialize a kobject structure
> + * @kobj: pointer to the kobject to initialize
> + * @ktype: pointer to the ktype for this kobject.
> + * @parent: pointer to the parent of this kobject.
> + * @fmt: the name of the kobject.
> + *
> + * This function will properly initialize a kobject such that it can then
> + * be passed to the kobject_add() call.
> + *
> + * If the function returns an error, the memory allocated by the kobject
> + * can be safely freed, no other functions need to be called.
> + */
> +void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype)

Kerneldoc needs to be updated -- no @parent or @fmt.  Also no error
returns.  But you could say that after this routine runs, the kobject
should be deallocated by kobject_put() and not by calling kfree()
directly.

> +/**
> + * kobject_add_ng - the main kobject add function
> + * @kobj: the kobject to add
> + * @parent: pointer to the parent of the kobject.
> + *
> + * The kobject name is set and added to the kobject hierarchy in this
> + * function.
> + *
> + * If @parent is set, then the parent of the @kobj will be set to it.
> + * If @parent is NULL, then the parent of the @kobj will be set to the
> + * kobject associted with the kset assigned to this kobject.  If no kset
> + * is assigned to the kobject, then the kobject will be located in the
> + * root of the sysfs tree.
> + *
> + * If this function returns an error, kobject_put() must be called to
> + * properly clean up the memory associated with the object.
> + *
> + * If the function is successful, the only way to properly clean up the
> + * memory is with a call to kobject_del().

In which case kobject_put() isn't needed?

> + *
> + * Under no instance should the kobject that is passed to this function
> + * be directly freed with a call to kfree(), that can leak memory.
> + */

Should you say something here about uevents?

> +int kobject_add_ng(struct kobject *kobj, struct kobject *parent,
> +		   const char *fmt, ...)
> +{
> +	va_list args;
> +	int retval;
> +
> +	if (!kobj)
> +		return -EINVAL;
> +
> +	va_start(args, fmt);
> +	retval = kobject_set_name_vargs(kobj, fmt, args);
> +	va_end(args);
> +	if (retval) {
> +		printk(KERN_ERR "kobject: can not set name properly!\n");
> +		return retval;
> +	}
> +	kobj->parent = parent;
> +	return kobject_add(kobj);
> +}
> +EXPORT_SYMBOL(kobject_add_ng);

Looks like this should call kobject_add_varg() instead of duplicating
its code.

> +/**
> + * kobject_init_and_add - initialize a kobject structure and add it to the kobject hierarchy
> + * @kobj: pointer to the kobject to initialize
> + * @ktype: pointer to the ktype for this kobject.
> + * @parent: pointer to the parent of this kobject.
> + * @fmt: the name of the kobject.
> + *
> + * This function will properly initialize a kobject and then call
> + * kobject_add().
> + *
> + * If the function returns an error, the kobject passed to this function
> + * must be cleaned up by calling kobject_put(), and not by directly
> + * trying to call kfree() on the kobject.
> + *
> + * If this function succeeds, the only way to properly clean up the
> + * kobject is to call kobject_destroy(), which will clean up all of the

kobject_destroy()?  Where did that come from?  Or did you mean 
kobject_del()?

> + * needed sysfs objects, and the kobject itself (by calling back to the
> + * ktype->release() function.)
> + *
> + * Note that the kobject_uevent() call should be called after this
> + * function succeeds, so that userspace can properly know that the
> + * kobject was created.
> + */

Could the comments be made shorter by saying merely that this routine 
combines calls to kobject_init() and kobject_add_ng()?

> +int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
> +			 struct kobject *parent, const char *fmt, ...)
> +{
> +	va_list args;
> +	int retval;
> +
> +	kobject_init_ng(kobj, ktype);
> +
> +	va_start(args, fmt);
> +	retval = kobject_add_varg(kobj, parent, fmt, args);
> +	va_end(args);
> +
> +	return retval;
> +}
> +EXPORT_SYMBOL(kobject_init_and_add);

Looks okay.

Did you want to add an extra kobject_put() to the end of kobject_del()?  
Or did you want to define a new kobject_destroy() that combines calls 
to kobject_del() and kobject_put()?

Alan Stern

