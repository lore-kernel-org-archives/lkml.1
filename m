Return-Path: <linux-kernel-owner+w=401wt.eu-S935499AbXGKXjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935499AbXGKXjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934985AbXGKXd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:33:59 -0400
Received: from ns1.suse.de ([195.135.220.2]:33735 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934988AbXGKXdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:33:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 14/61] PM: Remove prev_state from struct dev_pm_info
Date: Wed, 11 Jul 2007 16:31:33 -0700
Message-Id: <11841968111201-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968071826-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/resume.c  |    3 +--
 drivers/base/power/suspend.c |    2 --
 drivers/usb/core/hub.c       |    5 -----
 include/linux/pm.h           |    1 -
 4 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/base/power/resume.c b/drivers/base/power/resume.c
index 99679e7..0c96106 100644
--- a/drivers/base/power/resume.c
+++ b/drivers/base/power/resume.c
@@ -88,8 +88,7 @@ void dpm_resume(void)
 		list_move_tail(entry, &dpm_active);
 
 		mutex_unlock(&dpm_list_mtx);
-		if (!dev->power.prev_state.event)
-			resume_device(dev);
+		resume_device(dev);
 		mutex_lock(&dpm_list_mtx);
 		put_device(dev);
 	}
diff --git a/drivers/base/power/suspend.c b/drivers/base/power/suspend.c
index af2cedf..5178b0f 100644
--- a/drivers/base/power/suspend.c
+++ b/drivers/base/power/suspend.c
@@ -71,8 +71,6 @@ int suspend_device(struct device * dev, pm_message_t state)
 			dev->parent->power.power_state.event);
 	}
 
-	dev->power.prev_state = dev->power.power_state;
-
 	if (dev->class && dev->class->suspend && !dev->power.power_state.event) {
 		suspend_device_dbg(dev, state, "class ");
 		error = dev->class->suspend(dev, state);
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 24f10a1..a9cf8b3 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1109,11 +1109,6 @@ void usb_root_hub_lost_power(struct usb_device *rhdev)
 
 	dev_warn(&rhdev->dev, "root hub lost power or was reset\n");
 
-	/* Make sure no potential wakeup events get lost,
-	 * by forcing the root hub to be resumed.
-	 */
-	rhdev->dev.power.prev_state.event = PM_EVENT_ON;
-
 	spin_lock_irqsave(&device_state_lock, flags);
 	hub = hdev_to_hub(rhdev);
 	for (port1 = 1; port1 <= rhdev->maxchild; ++port1) {
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 6e7f066..273781c 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -267,7 +267,6 @@ struct dev_pm_info {
 	unsigned		can_wakeup:1;
 #ifdef	CONFIG_PM
 	unsigned		should_wakeup:1;
-	pm_message_t		prev_state;
 	struct list_head	entry;
 #endif
 };
-- 
1.5.2.2

