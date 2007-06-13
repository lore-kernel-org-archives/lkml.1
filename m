Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbXFMVaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbXFMVaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbXFMV3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:29:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48329 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbXFMV3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:29:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/7] PM: Remove pm_parent from struct dev_pm_info
Date: Wed, 13 Jun 2007 15:53:34 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl>
In-Reply-To: <200706131551.51336.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706131553.37064.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The pm_parent member of struct dev_pm_info (defined in include/linux/pm.h) is
only used to check if the device's parent is in the right state while the
device is being suspended or resumed.  However, this can be done just as well
with the help of the parent pointer in struct device, so pm_parent can be
removed along with some code that handles it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/base/power/main.c    |   30 ++++--------------------------
 drivers/base/power/resume.c  |    7 +++----
 drivers/base/power/suspend.c |    7 +++----
 include/linux/pm.h           |    3 ---
 4 files changed, 10 insertions(+), 37 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/base/power/main.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/base/power/main.c
+++ linux-2.6.22-rc4-mm2/drivers/base/power/main.c
@@ -33,28 +33,7 @@ DEFINE_MUTEX(dpm_list_mtx);
 
 int (*platform_enable_wakeup)(struct device *dev, int is_on);
 
-
-/**
- *	device_pm_set_parent - Specify power dependency.
- *	@dev:		Device who needs power.
- *	@parent:	Device that supplies power.
- *
- *	This function is used to manually describe a power-dependency
- *	relationship. It may be used to specify a transversal relationship
- *	(where the power supplier is not the physical (or electrical)
- *	ancestor of a specific device.
- *	The effect of this is that the supplier will not be powered down
- *	before the power dependent.
- */
-
-void device_pm_set_parent(struct device * dev, struct device * parent)
-{
-	put_device(dev->power.pm_parent);
-	dev->power.pm_parent = get_device(parent);
-}
-EXPORT_SYMBOL_GPL(device_pm_set_parent);
-
-int device_pm_add(struct device * dev)
+int device_pm_add(struct device *dev)
 {
 	int error;
 
@@ -63,21 +42,20 @@ int device_pm_add(struct device * dev)
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
 	list_add_tail(&dev->power.entry, &dpm_active);
-	device_pm_set_parent(dev, dev->parent);
-	if ((error = dpm_sysfs_add(dev)))
+	error = dpm_sysfs_add(dev);
+	if (error)
 		list_del(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
 	return error;
 }
 
-void device_pm_remove(struct device * dev)
+void device_pm_remove(struct device *dev)
 {
 	pr_debug("PM: Removing info for %s:%s\n",
 		 dev->bus ? dev->bus->name : "No Bus",
 		 kobject_name(&dev->kobj));
 	mutex_lock(&dpm_list_mtx);
 	dpm_sysfs_remove(dev);
-	put_device(dev->power.pm_parent);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
 }
Index: linux-2.6.22-rc4-mm2/drivers/base/power/resume.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/base/power/resume.c
+++ linux-2.6.22-rc4-mm2/drivers/base/power/resume.c
@@ -29,12 +29,11 @@ int resume_device(struct device * dev)
 
 	down(&dev->sem);
 
-	if (dev->power.pm_parent
-			&& dev->power.pm_parent->power.power_state.event) {
+	if (dev->parent && dev->parent->power.power_state.event) {
 		dev_err(dev, "PM: resume from %d, parent %s still %d\n",
 			dev->power.power_state.event,
-			dev->power.pm_parent->bus_id,
-			dev->power.pm_parent->power.power_state.event);
+			dev->parent->bus_id,
+			dev->parent->power.power_state.event);
 	}
 
 	if (dev->bus && dev->bus->resume) {
Index: linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/base/power/suspend.c
+++ linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
@@ -55,13 +55,12 @@ int suspend_device(struct device * dev, 
 		dev_dbg(dev, "PM: suspend %d-->%d\n",
 			dev->power.power_state.event, state.event);
 	}
-	if (dev->power.pm_parent
-			&& dev->power.pm_parent->power.power_state.event) {
+	if (dev->parent && dev->parent->power.power_state.event) {
 		dev_err(dev,
 			"PM: suspend %d->%d, parent %s already %d\n",
 			dev->power.power_state.event, state.event,
-			dev->power.pm_parent->bus_id,
-			dev->power.pm_parent->power.power_state.event);
+			dev->parent->bus_id,
+			dev->parent->power.power_state.event);
 	}
 
 	dev->power.prev_state = dev->power.power_state;
Index: linux-2.6.22-rc4-mm2/include/linux/pm.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/linux/pm.h
+++ linux-2.6.22-rc4-mm2/include/linux/pm.h
@@ -237,13 +237,10 @@ struct dev_pm_info {
 	unsigned		should_wakeup:1;
 	pm_message_t		prev_state;
 	void			* saved_state;
-	struct device		* pm_parent;
 	struct list_head	entry;
 #endif
 };
 
-extern void device_pm_set_parent(struct device * dev, struct device * parent);
-
 extern int device_power_down(pm_message_t state);
 extern void device_power_up(void);
 extern void device_resume(void);

