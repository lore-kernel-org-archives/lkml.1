Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbXFKPC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbXFKPC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXFKPAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:00:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38822 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbXFKPAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:00:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH -mm 5/7] PM: Remove prev_state from struct dev_pm_info
Date: Mon, 11 Jun 2007 17:02:55 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
References: <200706111655.50022.rjw@sisk.pl>
In-Reply-To: <200706111655.50022.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706111702.56103.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The prev_state member of struct dev_pm_info (defined in include/linux/pm.h) is
only used during a resume to check if the device's state before the suspend was
'off', in which case the device is not resumed.  However, in such cases the
decision whether or not to resume the device should be made on the driver level
and the resume callbacks from the device's bus and class should be executed
anyway (the may be needed for some things other than just powering on the
device).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/resume.c  |    3 +--
 drivers/base/power/suspend.c |    2 --
 drivers/usb/core/hub.c       |    5 -----
 include/linux/pm.h           |    1 -
 4 files changed, 1 insertion(+), 10 deletions(-)

Index: linux-2.6.22-rc4/drivers/base/power/resume.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/base/power/resume.c	2007-06-10 19:36:52.000000000 +0200
+++ linux-2.6.22-rc4/drivers/base/power/resume.c	2007-06-10 19:53:57.000000000 +0200
@@ -83,8 +83,7 @@ void dpm_resume(void)
 		list_move_tail(entry, &dpm_active);
 
 		mutex_unlock(&dpm_list_mtx);
-		if (!dev->power.prev_state.event)
-			resume_device(dev);
+		resume_device(dev);
 		mutex_lock(&dpm_list_mtx);
 		put_device(dev);
 	}
Index: linux-2.6.22-rc4/drivers/base/power/suspend.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/base/power/suspend.c	2007-06-10 19:36:52.000000000 +0200
+++ linux-2.6.22-rc4/drivers/base/power/suspend.c	2007-06-10 19:53:09.000000000 +0200
@@ -71,8 +71,6 @@ int suspend_device(struct device * dev, 
 			dev->parent->power.power_state.event);
 	}
 
-	dev->power.prev_state = dev->power.power_state;
-
 	if (dev->class && dev->class->suspend && !dev->power.power_state.event) {
 		suspend_device_dbg(dev, state, "class ");
 		error = dev->class->suspend(dev, state);
Index: linux-2.6.22-rc4/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/usb/core/hub.c	2007-06-08 13:09:18.000000000 +0200
+++ linux-2.6.22-rc4/drivers/usb/core/hub.c	2007-06-10 19:54:08.000000000 +0200
@@ -1110,11 +1110,6 @@ void usb_root_hub_lost_power(struct usb_
 
 	dev_warn(&rhdev->dev, "root hub lost power or was reset\n");
 
-	/* Make sure no potential wakeup events get lost,
-	 * by forcing the root hub to be resumed.
-	 */
-	rhdev->dev.power.prev_state.event = PM_EVENT_ON;
-
 	spin_lock_irqsave(&device_state_lock, flags);
 	hub = hdev_to_hub(rhdev);
 	for (port1 = 1; port1 <= rhdev->maxchild; ++port1) {
Index: linux-2.6.22-rc4/include/linux/pm.h
===================================================================
--- linux-2.6.22-rc4.orig/include/linux/pm.h	2007-06-10 19:36:52.000000000 +0200
+++ linux-2.6.22-rc4/include/linux/pm.h	2007-06-10 19:52:56.000000000 +0200
@@ -235,7 +235,6 @@ struct dev_pm_info {
 	unsigned		can_wakeup:1;
 #ifdef	CONFIG_PM
 	unsigned		should_wakeup:1;
-	pm_message_t		prev_state;
 	struct list_head	entry;
 #endif
 };
