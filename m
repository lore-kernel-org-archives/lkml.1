Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbYCLADT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbYCLADT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 20:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYCLACj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 20:02:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37138 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbYCLACh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 20:02:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: [PATCH 2/3] Driver core: Call device_pm_add() after bus_add_device() in device_add()
Date: Wed, 12 Mar 2008 00:59:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200803120055.25885.rjw@sisk.pl>
In-Reply-To: <200803120055.25885.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803120059.39902.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Include dpm_sysfs_add() into device_pm_add(), in analogy with
device_pm_remove(), and modify device_add() to call the latter after
bus_add_device(), to avoid situations in which the PM core may
attempt to suspend a device the registration of which has not been
successful.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/core.c       |   15 +++++----------
 drivers/base/power/main.c |    4 +++-
 2 files changed, 8 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/base/core.c
===================================================================
--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -812,17 +812,12 @@ int device_add(struct device *dev)
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
@@ -842,9 +837,9 @@ int device_add(struct device *dev)
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
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
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
