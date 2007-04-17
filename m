Return-Path: <linux-kernel-owner+w=401wt.eu-S1030780AbXDQSlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030780AbXDQSlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030795AbXDQSlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:41:19 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:48479 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030780AbXDQSlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:41:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mnKk4KoVnioNI6RgMAb2/YsZZU0BTeD8Mf38sW/v+CwxaFx1x5O+BFI5fS+jam6KMAxZTF9iKpsnjvr6MjwiCqnIOnaEo1GXi7TTB9x1kAEMbGMYQ7tMKM1LsFb2Dozxzk+V80jf97er8s4wfoz7oxilm1HgSKGDnx2cEICvZ6k=
Date: Wed, 18 Apr 2007 03:41:10 +0900
From: Tejun Heo <htejun@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>, dmitry.torokhov@gmail.com
Subject: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070417184110.GJ10619@htj.dyndns.org>
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

Agreed with the problem but I'm not very enthusiastic for adding
kobj->owner.  How about the following?  exit() routines will have to
do device_unregister_wait() instead of device_unregister().  On return
from it, it's guaranteed that all references to it are dropped and
->release is finished.  The caller is responsible for avoiding
deadlock, of course.

The code is only compile-tested and is more of proof-of-concept than
working code.

DO NOT APPLY.

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 37930d0..72ccf16 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -741,6 +741,17 @@ void put_device(struct device * dev)
 
 
 /**
+ *	put_device_wait - put and wait for all references to go away
+ *	@dev:	device in question.
+ */
+void put_device_wait(struct device * dev)
+{
+	if (dev)
+		kobject_put_wait(&dev->kobj);
+}
+
+
+/**
  *	device_del - delete device from system.
  *	@dev:	device.
  *
@@ -839,6 +850,20 @@ void device_unregister(struct device * dev)
 }
 
 
+/**
+ *	device_unregister_wait - unregister dev and wait for it to be released
+ *	@dev:	device going away.
+ *
+ *	Delete and put @dev; then, wait for it to be released.
+ */
+void device_unregister_wait(struct device * dev)
+{
+	pr_debug("DEV: Unregistering device. ID = '%s'\n", dev->bus_id);
+	device_del(dev);
+	put_device_wait(dev);
+}
+
+
 static struct device * next_device(struct klist_iter * i)
 {
 	struct klist_node * n = klist_next(i);
@@ -917,8 +942,10 @@ EXPORT_SYMBOL_GPL(device_register);
 
 EXPORT_SYMBOL_GPL(device_del);
 EXPORT_SYMBOL_GPL(device_unregister);
+EXPORT_SYMBOL_GPL(device_unregister_wait);
 EXPORT_SYMBOL_GPL(get_device);
 EXPORT_SYMBOL_GPL(put_device);
+EXPORT_SYMBOL_GPL(put_device_wait);
 
 EXPORT_SYMBOL_GPL(device_create_file);
 EXPORT_SYMBOL_GPL(device_remove_file);
diff --git a/include/linux/device.h b/include/linux/device.h
index 5cf30e9..1a1f1da 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -490,6 +490,7 @@ void driver_init(void);
  */
 extern int __must_check device_register(struct device * dev);
 extern void device_unregister(struct device * dev);
+extern void device_unregister_wait(struct device * dev);
 extern void device_initialize(struct device * dev);
 extern int __must_check device_add(struct device * dev);
 extern void device_del(struct device * dev);
@@ -535,6 +536,7 @@ extern int (*platform_notify_remove)(struct device * dev);
  */
 extern struct device * get_device(struct device * dev);
 extern void put_device(struct device * dev);
+extern void put_device_wait(struct device * dev);
 
 
 /* drivers/base/power/shutdown.c */
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index b850e03..4f0bb2d 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -85,9 +85,11 @@ extern int __must_check kobject_move(struct kobject *, struct kobject *);
 
 extern int __must_check kobject_register(struct kobject *);
 extern void kobject_unregister(struct kobject *);
+extern void kobject_unregister_wait(struct kobject *);
 
 extern struct kobject * kobject_get(struct kobject *);
 extern void kobject_put(struct kobject *);
+extern void kobject_put_wait(struct kobject *);
 
 extern struct kobject *kobject_add_dir(struct kobject *, const char *);
 
diff --git a/lib/kobject.c b/lib/kobject.c
index 057921c..22e5148 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -16,6 +16,15 @@
 #include <linux/stat.h>
 #include <linux/slab.h>
 
+struct kobj_wait {
+	struct list_head	list;
+	struct kobject		*kobj;
+	struct completion	cmpl;
+};
+
+static spinlock_t kobj_wait_lock = SPIN_LOCK_UNLOCKED;
+static LIST_HEAD(kobj_wait_list);
+
 /**
  *	populate_dir - populate directory with attributes.
  *	@kobj:	object we're working on.
@@ -425,6 +434,23 @@ void kobject_unregister(struct kobject * kobj)
 }
 
 /**
+ *	kobject_unregister_wait - unregister, put and wait
+ *	@kobj:	object going away
+ *
+ *	Remove @kobj from hierarchy, decrement refcount and wait for
+ *	it to die.
+ */
+void kobject_unregister_wait(struct kobject * kobj)
+{
+	if (!kobj)
+		return;
+	pr_debug("kobject %s: unregistering\n",kobject_name(kobj));
+	kobject_uevent(kobj, KOBJ_REMOVE);
+	kobject_del(kobj);
+	kobject_put_wait(kobj);
+}
+
+/**
  *	kobject_get - increment refcount for object.
  *	@kobj:	object.
  */
@@ -446,8 +472,22 @@ void kobject_cleanup(struct kobject * kobj)
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
 	struct kobject * parent = kobj->parent;
+	struct kobj_wait *kwait;
+	unsigned long flags;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
+
+	/* is somebody waiting for @kobj to die? */
+	spin_lock_irqsave(&kobj_wait_lock, flags);
+	list_for_each_entry(kwait, &kobj_wait_list, list) {
+		if (kwait->kobj == kobj) {
+			list_del_init(&kwait->list);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&kobj_wait_lock, flags);
+
+	/* clean up */
 	if (kobj->k_name != kobj->name)
 		kfree(kobj->k_name);
 	kobj->k_name = NULL;
@@ -456,6 +496,10 @@ void kobject_cleanup(struct kobject * kobj)
 	if (s)
 		kset_put(s);
 	kobject_put(parent);
+
+	/* notify waiter */
+	if (kwait)
+		complete(&kwait->cmpl);
 }
 
 static void kobject_release(struct kref *kref)
@@ -475,6 +519,42 @@ void kobject_put(struct kobject * kobj)
 		kref_put(&kobj->kref, kobject_release);
 }
 
+/**
+ *	kobject_put_wait - put and wait for all references to go away
+ *	@kobj:	object
+ *
+ *	This function is used by @kobj owner to kill it - it puts a
+ *	reference to @kobj and waits till all the references are gone
+ *	and ->release is finished.  @kobj must have been deleted and
+ *	the caller is responsible for guaranteeing that all references
+ *	will be dropped in foreseeable future.
+ */
+void kobject_put_wait(struct kobject * kobj)
+{
+	struct kobj_wait kwait;
+	unsigned long flags;
+
+	if (!kobj)
+		return;
+
+	BUG_ON(!list_empty(&kobj->entry));
+
+	init_completion(&kwait.cmpl);
+	kwait.kobj = kobj;
+
+	spin_lock_irqsave(&kobj_wait_lock, flags);
+	list_add(&kwait.list, &kobj_wait_list);
+	spin_unlock_irqrestore(&kobj_wait_lock, flags);
+
+	kobject_put(kobj);
+
+	if (!wait_for_completion_timeout(&kwait.cmpl, 30 * HZ)) {
+		printk(KERN_WARNING "kobject_put_wait: kobject %p is still "
+		       "alive after 30s, possible reference count bug\n", kobj);
+		dump_stack();
+		wait_for_completion(&kwait.cmpl);
+	}
+}
 
 static void dir_release(struct kobject *kobj)
 {
@@ -691,8 +771,10 @@ void subsys_remove_file(struct subsystem * s, struct subsys_attribute * a)
 EXPORT_SYMBOL(kobject_init);
 EXPORT_SYMBOL(kobject_register);
 EXPORT_SYMBOL(kobject_unregister);
+EXPORT_SYMBOL(kobject_unregister_wait);
 EXPORT_SYMBOL(kobject_get);
 EXPORT_SYMBOL(kobject_put);
+EXPORT_SYMBOL(kobject_put_wait);
 EXPORT_SYMBOL(kobject_add);
 EXPORT_SYMBOL(kobject_del);
 
