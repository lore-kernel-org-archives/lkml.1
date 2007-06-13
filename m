Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbXFMVby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbXFMVby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 17:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbXFMV3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 17:29:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48334 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbXFMV3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 17:29:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 5/7] PM: Remove prev_state from struct dev_pm_info
Date: Wed, 13 Jun 2007 17:16:35 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200706131551.51336.rjw@sisk.pl>
In-Reply-To: <200706131551.51336.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706131716.38595.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
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
 drivers/usb/host/ohci-pci.c  |    2 --
 include/linux/pm.h           |    1 -
 5 files changed, 1 insertion(+), 12 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/base/power/resume.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/base/power/resume.c
+++ linux-2.6.22-rc4-mm2/drivers/base/power/resume.c
@@ -83,8 +83,7 @@ void dpm_resume(void)
 		list_move_tail(entry, &dpm_active);
 
 		mutex_unlock(&dpm_list_mtx);
-		if (!dev->power.prev_state.event)
-			resume_device(dev);
+		resume_device(dev);
 		mutex_lock(&dpm_list_mtx);
 		put_device(dev);
 	}
Index: linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/base/power/suspend.c
+++ linux-2.6.22-rc4-mm2/drivers/base/power/suspend.c
@@ -71,8 +71,6 @@ int suspend_device(struct device * dev, 
 			dev->parent->power.power_state.event);
 	}
 
-	dev->power.prev_state = dev->power.power_state;
-
 	if (dev->class && dev->class->suspend && !dev->power.power_state.event) {
 		suspend_device_dbg(dev, state, "class ");
 		error = dev->class->suspend(dev, state);
Index: linux-2.6.22-rc4-mm2/drivers/usb/core/hub.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/usb/core/hub.c
+++ linux-2.6.22-rc4-mm2/drivers/usb/core/hub.c
@@ -623,7 +623,6 @@ static void mark_children_for_reset_resu
 
 		if (child) {
 			child->reset_resume = 1;
-			child->dev.power.prev_state.event = PM_EVENT_ON;
 			clear_port_feature(hdev, port1,
 					USB_PORT_FEAT_C_CONNECTION);
 		}
@@ -1190,10 +1189,6 @@ void usb_root_hub_lost_power(struct usb_
 	dev_warn(&rhdev->dev, "root hub lost power or was reset\n");
 	rhdev->reset_resume = 1;
 
-	/* Force the root hub to be resumed, even if it was suspended,
-	 * so that no wakeup events will get lost.
-	 */
-	rhdev->dev.power.prev_state.event = PM_EVENT_ON;
 }
 EXPORT_SYMBOL_GPL(usb_root_hub_lost_power);
 
Index: linux-2.6.22-rc4-mm2/include/linux/pm.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/include/linux/pm.h
+++ linux-2.6.22-rc4-mm2/include/linux/pm.h
@@ -235,7 +235,6 @@ struct dev_pm_info {
 	unsigned		can_wakeup:1;
 #ifdef	CONFIG_PM
 	unsigned		should_wakeup:1;
-	pm_message_t		prev_state;
 	struct list_head	entry;
 #endif
 };
Index: linux-2.6.22-rc4-mm2/drivers/usb/host/ohci-pci.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/usb/host/ohci-pci.c
+++ linux-2.6.22-rc4-mm2/drivers/usb/host/ohci-pci.c
@@ -281,8 +281,6 @@ static int ohci_pci_resume (struct usb_h
 	/* FIXME: we should try to detect loss of VBUS power here */
 	prepare_for_handover(hcd);
 
-	/* Force the PM core to resume the root hub */
-	hcd_to_bus(hcd)->root_hub->dev.power.prev_state.event = PM_EVENT_ON;
 	return 0;
 }
 

