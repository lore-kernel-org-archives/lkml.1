Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbXKSPxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbXKSPxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXKSPxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:53:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44978 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754110AbXKSPxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:53:41 -0500
Date: Mon, 19 Nov 2007 10:53:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] Kobjects: drop child->parent ref at unregistration
Message-ID: <Pine.LNX.4.44L0.0711191047230.4806-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as1015) reverts changes that were made to the driver core
about four years ago.  The intent back then was to avoid certain kinds
of invalid memory accesses by leaving kernel objects allocated as long
as any of their children were still allocated.  The original and
correct approach was to wait only as long as any children were still
_registered_; that's what this patch reinstates.

This fixes a problem in the SCSI core made visible by the class_device
to regular device conversion: A reference loop (scsi_device holds
reference to request_queue, which is the child of a gendisk, which is
the child of the scsi_device) prevents the data structures from being
released, even though they are deregistered okay.

It's possible that this change will cause a few bugs to surface,
things that have been hidden for several years.  They can be fixed
easily enough by having the child device take an explicit reference to
the parent whenever needed.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Greg:

I'm formally submitting this so that it can get some testing in your 
development tree and in -mm.  So far everyone who has considered the 
matter thinks that this is a good change.  Any bugs it has papered over 
should be fixable.

Alan Stern


Index: usb-2.6/lib/kobject.c
===================================================================
--- usb-2.6.orig/lib/kobject.c
+++ usb-2.6/lib/kobject.c
@@ -206,12 +206,16 @@ void kobject_init(struct kobject * kobj)
 
 static void unlink(struct kobject * kobj)
 {
+	struct kobject *parent = kobj->parent;
+
 	if (kobj->kset) {
 		spin_lock(&kobj->kset->list_lock);
 		list_del_init(&kobj->entry);
 		spin_unlock(&kobj->kset->list_lock);
 	}
+	kobj->parent = NULL;
 	kobject_put(kobj);
+	kobject_put(parent);
 }
 
 /**
@@ -262,7 +266,6 @@ int kobject_add(struct kobject * kobj)
 	if (error) {
 		/* unlink does the kobject_put() for us */
 		unlink(kobj);
-		kobject_put(parent);
 
 		/* be noisy on error issues */
 		if (error == -EEXIST)
@@ -516,7 +519,6 @@ void kobject_cleanup(struct kobject * ko
 {
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
-	struct kobject * parent = kobj->parent;
 	const char *name = kobj->k_name;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
@@ -533,7 +535,6 @@ void kobject_cleanup(struct kobject * ko
 	}
 	if (s)
 		kset_put(s);
-	kobject_put(parent);
 }
 
 static void kobject_release(struct kref *kref)


