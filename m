Return-Path: <linux-kernel-owner+w=401wt.eu-S2992698AbXDROx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992698AbXDROx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992699AbXDROx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:53:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57982 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2992698AbXDROx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:53:57 -0400
Date: Wed, 18 Apr 2007 10:53:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <20070417184110.GJ10619@htj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.0704181032060.12246-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007, Tejun Heo wrote:

> Hello, all.
> 
> Agreed with the problem but I'm not very enthusiastic for adding
> kobj->owner.  How about the following?  exit() routines will have to
> do device_unregister_wait() instead of device_unregister().  On return
> from it, it's guaranteed that all references to it are dropped and
> ->release is finished.  The caller is responsible for avoiding
> deadlock, of course.

There's a problem with this approach.

Many drivers, especially those for hot-pluggable buses, register and
unregister devices dynamically.  These events can occur in time-critical
situations, where the driver cannot afford to wait for all the references
to be dropped when unregistering a device.  It's okay to wait in a module
exit routine, but to make things work the routine would have to wait for
references to _all_ unregistered objects to go away, not just the
references for the objects it unregisters at exit time.

So let's see what changes are needed to make the approach workable.  We
will have to maintain a count of objects whose release methods haven't
been called yet.  The count has to be incremented every time an object is
unregistered (or registered, it doesn't matter which) and decremented
_after_ the release method returns -- meaning somewhere in the driver
core.  When the count goes to zero, the exit routine is then allowed to
terminate.

Hmmm, this is beginning to sound like a module-wide refcount which serves
to block mod->exit().  In fact, it sounds almost identical to what
Cornelia wrote, except that the refcount refers only to devices rather
than arbitrary kobjects (and except that the blockage just before
mod->exit returns instead of just after).  You can see where I'm
leading...

BTW, Cornelia, there's a small problem with your patch set.  You have
kobject_init() try to grab a reference to kobj->owner, but it's quite
possible for kobj->owner to contain uninitialized garbage since the rest
of the kernel is still unaware of its existence.  There's a patch below to
fix things up.  I've got a second patch which makes device_initialize()  
pass an owner to the embedded kobject, but I want to try it out a little
before posting it.  :-)


Incidentally, Tejun, I'm all in favor of a immediate-detach driver model 
approach.  Unfortunately it's impossible to realize fully, although we 
could come much closer than we are now.

Here's an example where immediate-detach cannot be implemented.  A driver 
binds to a device and uses that device is a kernel thread.  The thread 
carries out certain operations which require it to hold the device 
semaphore (because, for example, they need to be mutually exclusive with 
unbind).

The driver's remove() method is called with the semaphore held.  If the
thread tries to lock the semaphore at the same time and blocks, there is
no way at all for the remove() method to force the thread to drop its
reference.

This isn't merely a theoretical example.  The USB hub driver works in
exactly this way.

Alan Stern



Index: usb-2.6/include/linux/kobject.h
===================================================================
--- usb-2.6.orig/include/linux/kobject.h
+++ usb-2.6/include/linux/kobject.h
@@ -71,7 +71,8 @@ static inline const char * kobject_name(
 	return kobj->k_name;
 }
 
-extern void kobject_init(struct kobject *);
+extern void kobject_init_owner(struct kobject *, struct module *owner);
+#define kobject_init(kobj)	kobject_init_owner(kobj, THIS_MODULE)
 extern void kobject_cleanup(struct kobject *);
 
 extern int __must_check kobject_add(struct kobject *);
@@ -84,7 +85,9 @@ extern int __must_check kobject_shadow_r
 						const char *new_name);
 extern int __must_check kobject_move(struct kobject *, struct kobject *);
 
-extern int __must_check kobject_register(struct kobject *);
+extern int __must_check kobject_register_owner(struct kobject *,
+		struct module *owner);
+#define kobject_register(kobj)	kobject_register_owner(kobj, THIS_MODULE)
 extern void kobject_unregister(struct kobject *);
 
 extern struct kobject * kobject_get(struct kobject *);
Index: usb-2.6/lib/kobject.c
===================================================================
--- usb-2.6.orig/lib/kobject.c
+++ usb-2.6/lib/kobject.c
@@ -164,10 +164,11 @@ static void verify_dynamic_kobject_alloc
 #endif
 
 /**
- *	kobject_init - initialize object.
+ *	kobject_init_onwer - initialize object.
  *	@kobj:	object in question.
+ *	@owner: module owning @kobj.
  */
-void kobject_init(struct kobject * kobj)
+void kobject_init_owner(struct kobject * kobj, struct module *owner)
 {
 	if (!kobj)
 		return;
@@ -178,6 +179,7 @@ void kobject_init(struct kobject * kobj)
 	init_waitqueue_head(&kobj->poll);
 	kobj->kset = kset_get(kobj->kset);
 	/* Attempt to grab reference of owning module's kobject. */
+	kobj->owner = owner;
 	mod_kobject_get(kobj->owner);
 }
 
@@ -272,15 +274,16 @@ int kobject_add(struct kobject * kobj)
 
 
 /**
- *	kobject_register - initialize and add an object.
+ *	kobject_register_owner - initialize and add an object.
  *	@kobj:	object in question.
+ *	@owner:	module owning @kobj.
  */
 
-int kobject_register(struct kobject * kobj)
+int kobject_register_owner(struct kobject * kobj, struct module *owner)
 {
 	int error = -EINVAL;
 	if (kobj) {
-		kobject_init(kobj);
+		kobject_init_owner(kobj, owner);
 		error = kobject_add(kobj);
 		if (!error)
 			kobject_uevent(kobj, KOBJ_ADD);
@@ -750,8 +753,8 @@ void subsys_remove_file(struct subsystem
 }
 #endif  /*  0  */
 
-EXPORT_SYMBOL(kobject_init);
-EXPORT_SYMBOL(kobject_register);
+EXPORT_SYMBOL(kobject_init_owner);
+EXPORT_SYMBOL(kobject_register_owner);
 EXPORT_SYMBOL(kobject_unregister);
 EXPORT_SYMBOL(kobject_get);
 EXPORT_SYMBOL(kobject_put);

