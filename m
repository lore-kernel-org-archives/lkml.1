Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbXD0S63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbXD0S63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757060AbXD0S54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:57:56 -0400
Received: from ns.suse.de ([195.135.220.2]:50609 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020AbXD0S5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:19 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dtor@insightbb.com>, Dmitry Torokhov <dtor@mail.ru>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/46] Driver core: add suspend() and resume() to struct device_type
Date: Fri, 27 Apr 2007 11:53:31 -0700
Message-Id: <11777001002860-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777000963332-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@insightbb.com>

Driver core: add suspend() and resume() to struct device_type

In cases when there are devices of different types in the same class
we can't use class's implementation of suspend and resume methods and
we need to add them to struct device_type instead.

Also fix error handling in resume code (we should not try to call
class's resume method iof bus's resume method for the device failed.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/resume.c  |   13 ++++++++++++-
 drivers/base/power/suspend.c |   12 ++++++++++++
 include/linux/device.h       |    2 ++
 3 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/resume.c b/drivers/base/power/resume.c
index 020be36..a2c6418 100644
--- a/drivers/base/power/resume.c
+++ b/drivers/base/power/resume.c
@@ -26,7 +26,9 @@ int resume_device(struct device * dev)
 
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
+
 	down(&dev->sem);
+
 	if (dev->power.pm_parent
 			&& dev->power.pm_parent->power.power_state.event) {
 		dev_err(dev, "PM: resume from %d, parent %s still %d\n",
@@ -34,15 +36,24 @@ int resume_device(struct device * dev)
 			dev->power.pm_parent->bus_id,
 			dev->power.pm_parent->power.power_state.event);
 	}
+
 	if (dev->bus && dev->bus->resume) {
 		dev_dbg(dev,"resuming\n");
 		error = dev->bus->resume(dev);
 	}
-	if (dev->class && dev->class->resume) {
+
+	if (!error && dev->type && dev->type->resume) {
+		dev_dbg(dev,"resuming\n");
+		error = dev->type->resume(dev);
+	}
+
+	if (!error && dev->class && dev->class->resume) {
 		dev_dbg(dev,"class resume\n");
 		error = dev->class->resume(dev);
 	}
+
 	up(&dev->sem);
+
 	TRACE_RESUME(error);
 	return error;
 }
diff --git a/drivers/base/power/suspend.c b/drivers/base/power/suspend.c
index ece136b..42d2b86 100644
--- a/drivers/base/power/suspend.c
+++ b/drivers/base/power/suspend.c
@@ -78,6 +78,18 @@ int suspend_device(struct device * dev, pm_message_t state)
 		suspend_report_result(dev->class->suspend, error);
 	}
 
+	if (!error && dev->type && dev->type->suspend && !dev->power.power_state.event) {
+		dev_dbg(dev, "%s%s\n",
+			suspend_verb(state.event),
+			((state.event == PM_EVENT_SUSPEND)
+					&& device_may_wakeup(dev))
+				? ", may wakeup"
+				: ""
+			);
+		error = dev->type->suspend(dev, state);
+		suspend_report_result(dev->type->suspend, error);
+	}
+
 	if (!error && dev->bus && dev->bus->suspend && !dev->power.power_state.event) {
 		dev_dbg(dev, "%s%s\n",
 			suspend_verb(state.event),
diff --git a/include/linux/device.h b/include/linux/device.h
index c9dc458..af603a1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -344,6 +344,8 @@ struct device_type {
 	int (*uevent)(struct device *dev, char **envp, int num_envp,
 		      char *buffer, int buffer_size);
 	void (*release)(struct device *dev);
+	int (*suspend)(struct device * dev, pm_message_t state);
+	int (*resume)(struct device * dev);
 };
 
 /* interface for exporting device attributes */
-- 
1.5.1.2

