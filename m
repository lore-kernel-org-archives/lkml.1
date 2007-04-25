Return-Path: <linux-kernel-owner+w=401wt.eu-S2992949AbXDYUNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992949AbXDYUNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993062AbXDYUNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:13:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47578 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2992949AbXDYUNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:13:14 -0400
Date: Wed, 25 Apr 2007 16:13:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
In-Reply-To: <20070425110005.304d3087@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0704251516480.2650-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Apr 2007, Cornelia Huck wrote:

> On Tue, 24 Apr 2007 15:38:12 -0400 (EDT),
> Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > We ought to make it explicitly clear that _all_ subsystems should behave
> > this way.  Maybe it isn't necessary to go as far as having device_del()
> > call itself recursively; doing that would open up lots of possible races.  
> > But I think it would be a good idea to add a WARN_ON in device_del, right
> > after the call to bus_remove_device(), that would be triggered if the
> > device still had any children.
> 
> If we decide that this should be policy, WARN_ON may be the least
> invasive option.

Yes.  I have changed my mind regarding your earlier proposal; I now think
it's best to make it "mandatory" for remove() to unregister all children.  
"Mandatory" in the sense that not doing so will provoke a big fat WARN_ON
complaint.

Having device_del() call itself recursively is not a good idea.  It would
destroy that guarantee that no one but the creator of a device will
unregister it.

> Should it be a possible option to move children to a different parent,
> so that the requirement wouldn't be "unregister all children", but "no
> children remain after remove() returns"?

That might confuse udev, but otherwise it could be okay.

> > It would also be good to document (but where?) some lifetime rules for 
> > device drivers.
> 
> Documentation/driver-model/lifetime-rules.txt?

When (if) such a file is added, it should contain more than just these few 
paragraphs.

> > Something like this:
> > 
> > 	When a driver's remove() method returns, the driver must no
> > 	longer try to use the device it was just unbound from.  The
> > 	device may be physically gone, or a different driver may be
> > 	bound to it.  Most importantly, remove() should unregister
> > 	all child devices created by the driver.
> 
> s/should/must/, if we agree on the policy above.

Yes.

> The remove() method must also unset driver_data.

It doesn't really have to.  The driver core could do it.

> > 	To accomplish all this safely, the driver should allocate a
> > 	private data structure containing at least a "gone" flag and 
> > 	a mutex or spinlock for synchronization.  Each time the driver
> > 	needs to use the device, it should first lock the mutex or 
> > 	spinlock and check the "gone" flag.
> 
> How should a driver make the device -> private data transition if it
> may no longer have private data attached to the device?

It should never need to make that transition.  The only routines in the
driver which get passed a pointer to the device (as opposed to a pointer
to the private data) should be the methods called by the driver core or
sysfs.  Neither will make any calls to the driver after remove() has
returned, unless the driver does something wrong.

> > 	Ideally remove() should release all of the driver's references
> > 	to the device, in accord with the "Immediate Detach" principle.
> > 	However it is acceptable for the driver to retain a reference,
> > 	provided it meets the following conditions:
> > 
> > 		The reference must be dropped in a timely manner,
> > 		such as when the release() methods for all child
> > 		devices have run.
> > 
> > 		The driver must also retain a module reference to
> > 		the owner of the device.  In practice this means the
> > 		driver must contain static code references to the
> > 		subsystem which created the device, since struct
> > 		device doesn't have an "owner" field.
> 
> Uhm. This would imply that a driver may never create a device itself.

A trivial omission on my part -- "The driver must also retain a module 
reference to the owner of the device (unless the driver is itself the 
device's owner)."

> However, the kobject->owner and module refcounting stuff should remove
> this restriction.

If every driver follows this rule, we may not need the kobject->owner 
stuff.  Although it wouldn't hurt to keep it for safety's sake.

> > 		The driver must restrict itself to reading (not
> > 		writing!) the fields in the device structure.  The
> > 		only exception is that the driver may lock/unlock
> > 		dev->sem.
> 
> And it may decrease the reference count, of course :)

:-)  Actually this should be a little more general, since the device will 
generally be embedded in a larger structure created by the subsystem.  The 
driver should also be able to acquire and release locks in that larger 
structure.


On a related topic, I complained before about the problem with char device
unregistration.  Below is an example patch showing how the USB mechanism
can be made safe.  It should be easy to understand, even for people who
aren't familiar with how the USB core works.  Basically it amounts to
replacing a spinlock with an rwsem, which can then be held throughout an
entire call to an f_op->open() method.

Without something like this, we face a potential race:

	Driver				User
	------				----
					usb_open(inode);
					Look up iminor(inode) in the table
						of minors
	remove():
	call usb_deregister_chrdev():
	Entry is removed from the
		table of minors
					Call f_op->open():
					Private data matching the minor
						number is located
	Minor info is removed from
		the private data
	Private data is deallocated
	remove() returns
					Try to use the private data

It's true that there are other ways of preventing this scenario, but they 
put the burden on the device driver instead of on the subsystem.  They 
also tend to be somewhat fragile and often involve the BKL.  This way is 
simple and general.  Is there any reason it shouldn't be used by every 
subsystem that maintains a table of minors?

Alan Stern


Index: usb-2.6/drivers/usb/core/file.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/file.c
+++ usb-2.6/drivers/usb/core/file.c
@@ -16,15 +16,15 @@
  */
 
 #include <linux/module.h>
-#include <linux/spinlock.h>
 #include <linux/errno.h>
+#include <linux/rwsem.h>
 #include <linux/usb.h>
 
 #include "usb.h"
 
 #define MAX_USB_MINORS	256
 static const struct file_operations *usb_minors[MAX_USB_MINORS];
-static DEFINE_SPINLOCK(minor_lock);
+static DECLARE_RWSEM(minor_rwsem);
 
 static int usb_open(struct inode * inode, struct file * file)
 {
@@ -33,14 +33,11 @@ static int usb_open(struct inode * inode
 	int err = -ENODEV;
 	const struct file_operations *old_fops, *new_fops = NULL;
 
-	spin_lock (&minor_lock);
+	down_read(&minor_rwsem);
 	c = usb_minors[minor];
 
-	if (!c || !(new_fops = fops_get(c))) {
-		spin_unlock(&minor_lock);
-		return err;
-	}
-	spin_unlock(&minor_lock);
+	if (!c || !(new_fops = fops_get(c)))
+		goto done;
 
 	old_fops = file->f_op;
 	file->f_op = new_fops;
@@ -52,6 +49,8 @@ static int usb_open(struct inode * inode
 		file->f_op = fops_get(old_fops);
 	}
 	fops_put(old_fops);
+ done:
+	up_read(&minor_rwsem);
 	return err;
 }
 
@@ -124,7 +123,7 @@ int usb_register_dev(struct usb_interfac
 	if (class_driver->fops == NULL)
 		goto exit;
 
-	spin_lock (&minor_lock);
+	down_write(&minor_rwsem);
 	for (minor = minor_base; minor < MAX_USB_MINORS; ++minor) {
 		if (usb_minors[minor])
 			continue;
@@ -134,7 +133,7 @@ int usb_register_dev(struct usb_interfac
 		retval = 0;
 		break;
 	}
-	spin_unlock (&minor_lock);
+	up_write(&minor_rwsem);
 
 	if (retval)
 		goto exit;
@@ -150,9 +149,9 @@ int usb_register_dev(struct usb_interfac
 	intf->usb_dev = device_create(&usb_class, &intf->dev,
 				      MKDEV(USB_MAJOR, minor), "%s", temp);
 	if (IS_ERR(intf->usb_dev)) {
-		spin_lock (&minor_lock);
+		down_write(&minor_rwsem);
 		usb_minors[intf->minor] = NULL;
-		spin_unlock (&minor_lock);
+		up_write(&minor_rwsem);
 		retval = PTR_ERR(intf->usb_dev);
 	}
 exit:
@@ -189,9 +188,9 @@ void usb_deregister_dev(struct usb_inter
 
 	dbg ("removing %d minor", intf->minor);
 
-	spin_lock (&minor_lock);
+	down_write(&minor_rwsem);
 	usb_minors[intf->minor] = NULL;
-	spin_unlock (&minor_lock);
+	up_write(&minor_rwsem);
 
 	snprintf(name, BUS_ID_SIZE, class_driver->name, intf->minor - minor_base);
 	device_destroy(&usb_class, MKDEV(USB_MAJOR, intf->minor));

