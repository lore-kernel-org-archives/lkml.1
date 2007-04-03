Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbXDCFIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbXDCFIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 01:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXDCFIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 01:08:43 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:9189 "EHLO
	asav06.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbXDCFIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 01:08:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAJR9EUZKhRO4UGdsb2JhbACHPIhEAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH] Driver core: add suspend() and resume() to struct device_type
Date: Tue, 3 Apr 2007 01:08:40 -0400
User-Agent: KMail/1.9.3
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704030108.40947.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Here is another patch extending struct device_type. I need it to
implement generic suspend/resume routines for input devices.
As you may remember input core devices and interface devices are
mixed in the same class and because suspend/resume only applies
to core devices so I can't define these methods on class level. 

-- 
Dmitry

Driver core: add suspend() and resume() to struct device_type

In cases when there are devices of different types in the same class
we can't use class's implementation of suspend and resume methods and
we need to add them to struct device_type instead.

Also fix error handling in resume code (we should not try to call
class's resume method iof bus's resume method for the device failed.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/base/power/resume.c  |   13 ++++++++++++-
 drivers/base/power/suspend.c |   12 ++++++++++++
 include/linux/device.h       |    2 ++
 3 files changed, 26 insertions(+), 1 deletion(-)

Index: work/drivers/base/power/resume.c
===================================================================
--- work.orig/drivers/base/power/resume.c
+++ work/drivers/base/power/resume.c
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
Index: work/drivers/base/power/suspend.c
===================================================================
--- work.orig/drivers/base/power/suspend.c
+++ work/drivers/base/power/suspend.c
@@ -78,6 +78,18 @@ int suspend_device(struct device * dev, 
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
Index: work/include/linux/device.h
===================================================================
--- work.orig/include/linux/device.h
+++ work/include/linux/device.h
@@ -332,6 +332,8 @@ struct device_type {
 	int (*uevent)(struct device *dev, char **envp, int num_envp,
 		      char *buffer, int buffer_size);
 	void (*release)(struct device *dev);
+	int (*suspend)(struct device * dev, pm_message_t state);
+	int (*resume)(struct device * dev);
 };
 
 /* interface for exporting device attributes */
