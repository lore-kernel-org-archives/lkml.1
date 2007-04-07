Return-Path: <linux-kernel-owner+w=401wt.eu-S966027AbXDGPsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966027AbXDGPsY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 11:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966035AbXDGPsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 11:48:24 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3273 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966027AbXDGPsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 11:48:22 -0400
Date: Sat, 7 Apr 2007 11:48:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Greg KH <greg@kroah.com>, <hugh@veritas.com>, <cornelia.huck@de.ibm.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Oliver Neukum <oliver@neukum.name>, <maneesh@in.ibm.com>,
       <rpurdie@rpsys.net>, James Bottomley <James.Bottomley@SteelEye.com>,
       Jeff Garzik <jgarzik@pobox.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Message-ID: <Pine.LNX.4.44L0.0704071145370.31604-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On March 30, 2007, Tejun Heo wrote:

> Hello, all.
> 
> This document tries to describe lifetime problems of the current
> device driver model primarily from the point view of device drivers
> and establish consensus, or at least, start discussion about how to
> solve these problems.  This is primarily based on my experience with
> IDE and SCSI layers and my knowledge on other drivers is limited, so I
> might have generalized too aggressively.  Feel free to point out.

...

> Example 1. sysfs_schedule_callback() not grabbing the owning module
> 
>   This function is recently added to be used by suicidal sysfs nodes
>   such that they don't deadlock when trying to unregister themselves.
> 
>  +#include <linux/delay.h>
>   static void sysfs_schedule_callback_work(struct work_struct *work)
>   {
> 	struct sysfs_schedule_callback_struct *ss = container_of(work,
> 			struct sysfs_schedule_callback_struct, work);
> 
>  +	msleep(100);
> 	(ss->func)(ss->data);
> 	kobject_put(ss->kobj);
> 	kfree(ss);
>   }
> 
>   int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
> 		void *data)
>   {
> 	struct sysfs_schedule_callback_struct *ss;
> 
> 	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
> 	if (!ss)
> 		return -ENOMEM;
> 	kobject_get(kobj);
> 	ss->kobj = kobj;
> 	ss->func = func;
> 	ss->data = data;
> 	INIT_WORK(&ss->work, sysfs_schedule_callback_work);
> 	schedule_work(&ss->work);
> 	return 0;
>   }
> 
>   Two lines starting with '+' are inserted to make the problem
>   reliably reproducible.  With the above changes,
> 
>   # insmod drivers/scsi/scsi_mod.ko; insmod drivers/scsi/sd_mod.ko; insmod drivers/ata/libata.ko;
> insmod drivers/ata/ahci.ko
>   # echo 1 > /sys/block/sda/device/delete; rmmod ahci; rmmod libata; rmmod sd_mod; rmmod scsi_mod
> 
>   It's assumed that ahci detects /dev/sda.  The above command sequence
>   causes the following oops.
> 
>   BUG: unable to handle kernel paging request at virtual address e0984020
>   [--snip--]
>   EIP is at 0xe0984020
>   [--snip--]
>    [<c0127132>] run_workqueue+0x92/0x140
>    [<c01278c7>] worker_thread+0x137/0x160
>    [<c012a513>] kthread+0xa3/0xd0
>    [<c0104457>] kernel_thread_helper+0x7/0x10
> 
>   The problem here is that kobjec_get() in sysfs_schedule_callback()
>   doesn't grab the module backing the kobject it's grabbing.  By the
>   time (ss->func)(ss->kobj) runs, scsi_mod is already gone.

As the author of this routine, I wish you had included my name in your
CC: list.  :-(

The problem here isn't exactly as you described.  scsi_mod needs to be
pinned (1) because it is the owner of the kobject and hence will be
called when the kobject is released, and (2) because it is the owner
of the callback routine.  However this is just a detail; clearly the
bug needs to be fixed.

One possibility would be to have scsi_mod's exit_scsi() routine call
flush_scheduled_work().  Another would be to add such a call in
sys_delete_module().  Neither of these is attractive.  They would add
overhead when it's not needed, and they would deadlock if a workqueue
routine tried to unload a module.

On balance, the patch below seems better.  Do you agree?


With regard to your analysis of lifetime issues, there is a whole
aspect you did not mention.  A basic assumption of the refcounting
approach is that once X has a reference to Y, X can freely access and
use Y as much as it wants until it drops the reference.

However this is not true when X is a device driver and Y is a device
structure.  Drivers can be unbound from devices.  If X has been
unbound from Y then it must not access Y again, no matter how many
references it possesses.  After all, some other driver may have bound
to Y in the meantime; this other driver would not appreciate the
interference.

Just as bad, if Y represents a hot-pluggable device then some other
device may have been plugged in and may be using Y's old address.  We
don't want X sending commands to a new device, thinking that it is Y!

The complications caused by this requirement affect both the subsystem
code and device drivers.  Drivers must synchronize their release()
methods with every action they take -- and refcounts cannot provide
synchronization.

A similar problem afflicts the char-device subsystem, and here even
less care has been taken to address the issues.  The race between
open() and unregister() is resolved in many places by relying on the
BKL!

We should be able to make things better and easier than they are.
Orphaning open sysfs files was a move in this direction.  But I doubt
they will ever become truly simple and clear.

Alan Stern



Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -431,9 +431,10 @@ void device_remove_bin_file(struct devic
 EXPORT_SYMBOL_GPL(device_remove_bin_file);
 
 /**
- * device_schedule_callback - helper to schedule a callback for a device
+ * device_schedule_callback_owner - helper to schedule a callback for a device
  * @dev: device.
  * @func: callback function to invoke later.
+ * @owner: module owning the callback routine
  *
  * Attribute methods must not unregister themselves or their parent device
  * (which would amount to the same thing).  Attempts to do so will deadlock,
@@ -444,20 +445,23 @@ EXPORT_SYMBOL_GPL(device_remove_bin_file
  * argument in the workqueue's process context.  @dev will be pinned until
  * @func returns.
  *
+ * This routine is usually called via the inline device_schedule_callback(),
+ * which automatically sets @owner to THIS_MODULE.
+ *
  * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated.
+ * be allocated, -ENODEV if a reference to @owner isn't available.
  *
  * NOTE: This routine won't work if CONFIG_SYSFS isn't set!  It uses an
  * underlying sysfs routine (since it is intended for use by attribute
  * methods), and if sysfs isn't available you'll get nothing but -ENOSYS.
  */
-int device_schedule_callback(struct device *dev,
-		void (*func)(struct device *))
+int device_schedule_callback_owner(struct device *dev,
+		void (*func)(struct device *), struct module *owner)
 {
 	return sysfs_schedule_callback(&dev->kobj,
-			(void (*)(void *)) func, dev);
+			(void (*)(void *)) func, dev, owner);
 }
-EXPORT_SYMBOL_GPL(device_schedule_callback);
+EXPORT_SYMBOL_GPL(device_schedule_callback_owner);
 
 static void klist_children_get(struct klist_node *n)
 {
Index: usb-2.6/fs/sysfs/file.c
===================================================================
--- usb-2.6.orig/fs/sysfs/file.c
+++ usb-2.6/fs/sysfs/file.c
@@ -647,6 +647,7 @@ struct sysfs_schedule_callback_struct {
 	struct kobject 		*kobj;
 	void			(*func)(void *);
 	void			*data;
+	struct module		*owner;
 	struct work_struct	work;
 };
 
@@ -657,6 +658,7 @@ static void sysfs_schedule_callback_work
 
 	(ss->func)(ss->data);
 	kobject_put(ss->kobj);
+	module_put(ss->owner);
 	kfree(ss);
 }
 
@@ -665,6 +667,7 @@ static void sysfs_schedule_callback_work
  * @kobj: object we're acting for.
  * @func: callback function to invoke later.
  * @data: argument to pass to @func.
+ * @owner: module owning the callback code
  *
  * sysfs attribute methods must not unregister themselves or their parent
  * kobject (which would amount to the same thing).  Attempts to do so will
@@ -677,20 +680,25 @@ static void sysfs_schedule_callback_work
  * until @func returns.
  *
  * Returns 0 if the request was submitted, -ENOMEM if storage could not
- * be allocated.
+ * be allocated, -ENODEV if a reference to @owner isn't available.
  */
 int sysfs_schedule_callback(struct kobject *kobj, void (*func)(void *),
-		void *data)
+		void *data, struct module *owner)
 {
 	struct sysfs_schedule_callback_struct *ss;
 
+	if (!try_module_get(owner))
+		return -ENODEV;
 	ss = kmalloc(sizeof(*ss), GFP_KERNEL);
-	if (!ss)
+	if (!ss) {
+		module_put(owner);
 		return -ENOMEM;
+	}
 	kobject_get(kobj);
 	ss->kobj = kobj;
 	ss->func = func;
 	ss->data = data;
+	ss->owner = owner;
 	INIT_WORK(&ss->work, sysfs_schedule_callback_work);
 	schedule_work(&ss->work);
 	return 0;
Index: usb-2.6/include/linux/device.h
===================================================================
--- usb-2.6.orig/include/linux/device.h
+++ usb-2.6/include/linux/device.h
@@ -369,8 +369,14 @@ extern int __must_check device_create_bi
 					       struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,
 				   struct bin_attribute *attr);
-extern int device_schedule_callback(struct device *dev,
-		void (*func)(struct device *));
+extern int device_schedule_callback_owner(struct device *dev,
+		void (*func)(struct device *), struct module *owner);
+
+static inline int device_schedule_callback(struct device *dev,
+		void (*func)(struct device *))
+{
+	device_schedule_callback_mod(dev, func, THIS_MODULE);
+}
 
 /* device resource management */
 typedef void (*dr_release_t)(struct device *dev, void *res);
Index: usb-2.6/include/linux/sysfs.h
===================================================================
--- usb-2.6.orig/include/linux/sysfs.h
+++ usb-2.6/include/linux/sysfs.h
@@ -80,7 +80,7 @@ struct sysfs_ops {
 #ifdef CONFIG_SYSFS
 
 extern int sysfs_schedule_callback(struct kobject *kobj,
-		void (*func)(void *), void *data);
+		void (*func)(void *), void *data, struct module *owner);
 
 extern int __must_check
 sysfs_create_dir(struct kobject *, struct dentry *);
@@ -138,7 +138,7 @@ extern int __must_check sysfs_init(void)
 #else /* CONFIG_SYSFS */
 
 static inline int sysfs_schedule_callback(struct kobject *kobj,
-		void (*func)(void *), void *data)
+		void (*func)(void *), void *data, struct module *owner)
 {
 	return -ENOSYS;
 }

