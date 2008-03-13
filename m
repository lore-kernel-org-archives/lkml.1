Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYCMUz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYCMUz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbYCMUzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:55:13 -0400
Received: from mx1.suse.de ([195.135.220.2]:56102 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbYCMUzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:55:12 -0400
Subject: patch driver-core-call-device_pm_add-after-bus_add_device-in-device_add.patch added to gregkh-2.6 tree
To: rjw@sisk.pl, akpm@linux-foundation.org, david-b@pacbell.net,
       greg@kroah.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       stern@rowland.harvard.edu
From: <gregkh@suse.de>
Date: Thu, 13 Mar 2008 13:54:32 -0700
In-Reply-To: <200803120059.39902.rjw@sisk.pl>
Message-ID: <12054416722157@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: Driver core: Call device_pm_add() after bus_add_device() in device_add()

to my gregkh-2.6 tree.  Its filename is

     driver-core-call-device_pm_add-after-bus_add_device-in-device_add.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From rjw@sisk.pl  Thu Mar 13 13:45:38 2008
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 12 Mar 2008 00:59:38 +0100
Subject: Driver core: Call device_pm_add() after bus_add_device() in device_add()
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@linux-foundation.org>, David Brownell <david-b@pacbell.net>, LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>
Message-ID: <200803120059.39902.rjw@sisk.pl>
Content-Disposition: inline


From: Rafael J. Wysocki <rjw@sisk.pl>

Include dpm_sysfs_add() into device_pm_add(), in analogy with
device_pm_remove(), and modify device_add() to call the latter after
bus_add_device(), to avoid situations in which the PM core may
attempt to suspend a device the registration of which has not been
successful.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c       |   15 +++++----------
 drivers/base/power/main.c |    4 +++-
 2 files changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -818,17 +818,12 @@ int device_add(struct device *dev)
 	error = device_add_attrs(dev);
 	if (error)
 		goto AttrsError;
-	error = dpm_sysfs_add(dev);
-	if (error)
-		goto PMError;
-	error = device_pm_add(dev);
-	if (error) {
-		dpm_sysfs_remove(dev);
-		goto PMError;
-	}
 	error = bus_add_device(dev);
 	if (error)
 		goto BusError;
+	error = device_pm_add(dev);
+	if (error)
+		goto PMError;
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
@@ -848,9 +843,9 @@ int device_add(struct device *dev)
  Done:
 	put_device(dev);
 	return error;
- BusError:
-	device_pm_remove(dev);
  PMError:
+	bus_remove_device(dev);
+ BusError:
 	if (dev->bus)
 		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
 					     BUS_NOTIFY_DEL_DEVICE, dev);
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -81,7 +81,9 @@ int device_pm_add(struct device *dev)
 		WARN_ON(true);
 		error = -EBUSY;
 	} else {
-		list_add_tail(&dev->power.entry, &dpm_active);
+		error = dpm_sysfs_add(dev);
+		if (!error)
+			list_add_tail(&dev->power.entry, &dpm_active);
 	}
 	mutex_unlock(&dpm_list_mtx);
 	return error;


Patches currently in gregkh-2.6 which might be from rjw@sisk.pl are

driver-core/power_state-remove-it-from-driver-core.patch
driver-core/pm-handle-device-registrations-during-suspend-resume.patch
driver-core/pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
driver-core/driver-core-call-device_pm_add-after-bus_add_device-in-device_add.patch
