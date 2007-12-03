Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbXLCTDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbXLCTDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 14:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXLCTDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 14:03:36 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34227 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbXLCTDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 14:03:35 -0500
Date: Mon, 3 Dec 2007 11:05:23 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng, kobject_add_ng, and
	kobject_init_and_add functions
Message-ID: <20071203190523.GA21776@kroah.com>
References: <20071201010123.GC4745@kroah.com> <Pine.LNX.4.44L0.0711302211450.4181-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711302211450.4181-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 10:29:39PM -0500, Alan Stern wrote:
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

Thanks, have now updated the comments.

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

Yes, now documented.

> > + *
> > + * Under no instance should the kobject that is passed to this function
> > + * be directly freed with a call to kfree(), that can leak memory.
> > + */
> 
> Should you say something here about uevents?

Can't hurt, I added a sentance to it.

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

Oops, yes, I ment to do that, thanks for pointing out I missed it.  Now
fixed.

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

Yes, stupid me...

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

Good idea, now done.

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
> 
> Did you want to add an extra kobject_put() to the end of kobject_del()?  
> Or did you want to define a new kobject_destroy() that combines calls 
> to kobject_del() and kobject_put()?

No, let's keep what we have there on the cleanup path for now.  I have
enough work to clean up the initializion part of the api for now :)


Here's the updated patch, thanks for the review comments.

thanks,

greg k-h

---------------

Date: Thu, 29 Nov 2007 22:38:12 -0800
To: Greg KH <greg@kroah.com>
From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: kobject: add kobject_init_ng, kobject_add_ng, and kobject_init_and_add functions

This is what the kobject_init and kobject_add functions are going to
become.  Add them to the kernel and then we can convert over the current
kobject_init and kobject_add users before renaming it.

Also add a kobject_init_and_add function which bundles up what a lot of
the current callers want to do all at once, and it properly handles the
memory usages, unlike kobject_register();

And we mark kobject_cleanup() as static, as no one outside of the
kobject core uses it, nor should they ever.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/kobject.h |   11 +++
 lib/kobject.c           |  144 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 148 insertions(+), 7 deletions(-)

--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -79,9 +79,16 @@ static inline const char * kobject_name(
 }
 
 extern void kobject_init(struct kobject *);
-extern void kobject_cleanup(struct kobject *);
-
+extern void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype);
 extern int __must_check kobject_add(struct kobject *);
+extern int __must_check kobject_add_ng(struct kobject *kobj,
+				       struct kobject *parent,
+				       const char *fmt, ...);
+extern int __must_check kobject_init_and_add(struct kobject *kobj,
+					     struct kobj_type *ktype,
+					     struct kobject *parent,
+					     const char *fmt, ...);
+
 extern void kobject_del(struct kobject *);
 
 extern struct kobject * __must_check kobject_create(const char *name,
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -290,6 +290,141 @@ int kobject_set_name(struct kobject *kob
 EXPORT_SYMBOL(kobject_set_name);
 
 /**
+ * kobject_init_ng - initialize a kobject structure
+ * @kobj: pointer to the kobject to initialize
+ * @ktype: pointer to the ktype for this kobject.
+ *
+ * This function will properly initialize a kobject such that it can then
+ * be passed to the kobject_add() call.
+ *
+ * After this function is called, the kobject MUST be cleaned up by a call
+ * to kobject_put(), not by a call to kfree directly to ensure that all of
+ * the memory is cleaned up properly.
+ */
+void kobject_init_ng(struct kobject *kobj, struct kobj_type *ktype)
+{
+	char *err_str;
+
+	if (!kobj) {
+		err_str = "invalid kobject pointer!";
+		goto error;
+	}
+	if (!ktype) {
+		err_str = "must have a ktype to be initialized properly!\n";
+		goto error;
+	}
+	if (atomic_read(&kobj->kref.refcount)) {
+		/* do not error out as sometimes we can recover */
+		printk(KERN_ERR "kobject: reference count is already set, "
+		       "something is seriously wrong.\n");
+		dump_stack();
+	}
+
+	kref_init(&kobj->kref);
+	INIT_LIST_HEAD(&kobj->entry);
+	kobj->ktype = ktype;
+	return;
+
+error:
+	printk(KERN_ERR "kobject: %s\n", err_str);
+	dump_stack();
+}
+EXPORT_SYMBOL(kobject_init_ng);
+
+static int kobject_add_varg(struct kobject *kobj, struct kobject *parent,
+			    const char *fmt, va_list vargs)
+{
+	va_list aq;
+	int retval;
+
+	va_copy(aq, vargs);
+	retval = kobject_set_name_vargs(kobj, fmt, aq);
+	va_end(aq);
+	if (retval) {
+		printk(KERN_ERR "kobject: can not set name properly!\n");
+		return retval;
+	}
+	kobj->parent = parent;
+	return kobject_add(kobj);
+}
+
+/**
+ * kobject_add_ng - the main kobject add function
+ * @kobj: the kobject to add
+ * @parent: pointer to the parent of the kobject.
+ * @fmt: format to name the kobject with.
+ *
+ * The kobject name is set and added to the kobject hierarchy in this
+ * function.
+ *
+ * If @parent is set, then the parent of the @kobj will be set to it.
+ * If @parent is NULL, then the parent of the @kobj will be set to the
+ * kobject associted with the kset assigned to this kobject.  If no kset
+ * is assigned to the kobject, then the kobject will be located in the
+ * root of the sysfs tree.
+ *
+ * If this function returns an error, kobject_put() must be called to
+ * properly clean up the memory associated with the object.
+ *
+ * If the function is successful, the only way to properly clean up the
+ * memory is with a call to kobject_del(), in which case, a call to
+ * kobject_put() is not necessary (kobject_del() does the final
+ * kobject_put() to call the release function in the ktype's release
+ * pointer.)
+ *
+ * Under no instance should the kobject that is passed to this function
+ * be directly freed with a call to kfree(), that can leak memory.
+ *
+ * Note, no uevent will be created with this call, the caller should set
+ * up all of the necessary sysfs files for the object and then call
+ * kobject_uevent() with the UEVENT_ADD parameter to ensure that
+ * userspace is properly notified of this kobject's creation.
+ */
+int kobject_add_ng(struct kobject *kobj, struct kobject *parent,
+		   const char *fmt, ...)
+{
+	va_list args;
+	int retval;
+
+	if (!kobj)
+		return -EINVAL;
+
+	va_start(args, fmt);
+	retval = kobject_add_varg(kobj, parent, fmt, args);
+	va_end(args);
+
+	return retval;
+}
+EXPORT_SYMBOL(kobject_add_ng);
+
+/**
+ * kobject_init_and_add - initialize a kobject structure and add it to the kobject hierarchy
+ * @kobj: pointer to the kobject to initialize
+ * @ktype: pointer to the ktype for this kobject.
+ * @parent: pointer to the parent of this kobject.
+ * @fmt: the name of the kobject.
+ *
+ * This function combines the call to kobject_init_ng() and
+ * kobject_add_ng().  The same type of error handling after a call to
+ * kobject_add_ng() and kobject lifetime rules are the same here.
+ */
+int kobject_init_and_add(struct kobject *kobj, struct kobj_type *ktype,
+			 struct kobject *parent, const char *fmt, ...)
+{
+	va_list args;
+	int retval;
+
+	kobject_init_ng(kobj, ktype);
+
+	va_start(args, fmt);
+	retval = kobject_add_varg(kobj, parent, fmt, args);
+	va_end(args);
+
+	return retval;
+}
+EXPORT_SYMBOL_GPL(kobject_init_and_add);
+
+/**
  *	kobject_rename - change the name of an object
  *	@kobj:	object in question.
  *	@new_name: object's new name
@@ -444,12 +579,11 @@ struct kobject * kobject_get(struct kobj
 	return kobj;
 }
 
-/**
- *	kobject_cleanup - free kobject resources. 
- *	@kobj:	object.
+/*
+ * kobject_cleanup - free kobject resources.
+ * @kobj: object.
  */
-
-void kobject_cleanup(struct kobject * kobj)
+static void kobject_cleanup(struct kobject *kobj)
 {
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
