Return-Path: <linux-kernel-owner+w=401wt.eu-S933595AbXK2VPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbXK2VPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760151AbXK2VO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:14:58 -0500
Received: from mx1.suse.de ([195.135.220.2]:35662 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760374AbXK2VO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:14:57 -0500
Subject: patch kobject-drop-child-parent-ref-at-unregistration.patch added to gregkh-2.6 tree
To: stern@rowland.harvard.edu, greg@kroah.com, gregkh@suse.de,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 29 Nov 2007 13:14:06 -0800
In-Reply-To: <Pine.LNX.4.44L0.0711191047230.4806-100000@iolanthe.rowland.org>
Message-Id: <20071129211455.774181448C80@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: Kobject: drop child->parent ref at unregistration

to my gregkh-2.6 tree.  Its filename is

     kobject-drop-child-parent-ref-at-unregistration.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From stern@rowland.harvard.edu  Thu Nov 29 13:12:08 2007
From: Alan Stern <stern@rowland.harvard.edu>
Date: Mon, 19 Nov 2007 10:53:40 -0500 (EST)
Subject: Kobject: drop child->parent ref at unregistration
To: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Message-ID: <Pine.LNX.4.44L0.0711191047230.4806-100000@iolanthe.rowland.org>


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
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 lib/kobject.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -149,12 +149,16 @@ void kobject_init(struct kobject * kobj)
 
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
@@ -208,7 +212,6 @@ int kobject_add(struct kobject * kobj)
 	if (error) {
 		/* unlink does the kobject_put() for us */
 		unlink(kobj);
-		kobject_put(parent);
 
 		/* be noisy on error issues */
 		if (error == -EEXIST)
@@ -463,7 +466,6 @@ void kobject_cleanup(struct kobject * ko
 {
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
-	struct kobject * parent = kobj->parent;
 	const char *name = kobj->k_name;
 
 	pr_debug("kobject: '%s' (%p): %s\n",
@@ -477,7 +479,6 @@ void kobject_cleanup(struct kobject * ko
 	}
 	if (s)
 		kset_put(s);
-	kobject_put(parent);
 }
 
 static void kobject_release(struct kref *kref)


Patches currently in gregkh-2.6 which might be from stern@rowland.harvard.edu are

driver/pm-acquire-device-locks-prior-to-suspending.patch
driver/create-sys-...-power-when-config_pm-is-set.patch
driver/driver-core-fix-race-in-__device_release_driver.patch
driver/driver-core-fix-class-glue-dir-cleanup-logic.patch
driver/kobject-drop-child-parent-ref-at-unregistration.patch
usb/usb-add-support-for-an-older-firmware-revision-for-the-nikon-d200.patch
usb/usb-fix-priority-mistakes-in-drivers-usb-core-hub.c.patch
usb/usb-fix-signr-comment-in-usbdevice_fs.h.patch
usb/usb-mailing-lists-have-changed.patch
usb/usb-power-management-documenation-update.patch
usb/usb-hcd-avoid-duplicate-local_irq_disable.patch
usb/usb-usb-mon-mon_bin.c-cleanups.patch
usb/usb-keep-track-of-whether-interface-sysfs-files-exist.patch
usb/usb-uevent-environment-key-fix.patch
usb/usb-autosuspend-for-cdc-acm.patch
usb/usb-fix-up-ehci-startup-synchronization.patch
usb/usb-usb-storage-new-lockable-subclass-0x07.patch
usb/usb-don-t-change-hc-power-state-for-a-freeze.patch
usb/usb-dummy_hcd-don-t-register-drivers-on-the-platform-bus.patch
usb/usb-force-handover-port-to-companion-when-hub_port_connect_change-fails.patch
usb/usb-make-ksuspend_usbd-thread-non-freezable.patch
usb/usb-usb-storage-unusual_devs-entry-for-jetflash-ts1gjf2a.patch
usb/usb-storage-always-set-the-allow_restart-flag.patch
