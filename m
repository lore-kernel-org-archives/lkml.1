Return-Path: <linux-kernel-owner+w=401wt.eu-S932213Ab0A0XL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab0A0XL0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936Ab0A0XLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:11:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34759 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab0A0XLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:11:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/2] PM / Runtime: Clean up pm_runtime_disable()
Date: Thu, 28 Jan 2010 00:11:05 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc5-rjw; KDE/4.3.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <201001280009.44589.rjw@sisk.pl>
In-Reply-To: <201001280009.44589.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001280011.06055.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the second argument of __pm_runtime_disable(), which is not
necessary any more, and rename this funtion to pm_runtime_disable().
Accordingly, drop the static inline definition of
pm_runtime_disable() using __pm_runtime_disable() and export
pm_runtime_disable() as appropriate.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/runtime.c |   31 ++++---------------------------
 include/linux/pm_runtime.h   |    9 ++-------
 2 files changed, 6 insertions(+), 34 deletions(-)

Index: linux-2.6/drivers/base/power/runtime.c
===================================================================
--- linux-2.6.orig/drivers/base/power/runtime.c
+++ linux-2.6/drivers/base/power/runtime.c
@@ -943,20 +943,15 @@ int pm_runtime_barrier(struct device *de
 EXPORT_SYMBOL_GPL(pm_runtime_barrier);
 
 /**
- * __pm_runtime_disable - Disable run-time PM of a device.
+ * pm_runtime_disable - Disable run-time PM of a device.
  * @dev: Device to handle.
- * @check_resume: If set, check if there's a resume request for the device.
  *
  * Increment power.disable_depth for the device and if was zero previously,
  * cancel all pending run-time PM requests for the device and wait for all
  * operations in progress to complete.  The device can be either active or
  * suspended after its run-time PM has been disabled.
- *
- * If @check_resume is set and there's a resume request pending when
- * __pm_runtime_disable() is called and power.disable_depth is zero, the
- * function will wake up the device before disabling its run-time PM.
  */
-void __pm_runtime_disable(struct device *dev, bool check_resume)
+void pm_runtime_disable(struct device *dev)
 {
 	spin_lock_irq(&dev->power.lock);
 
@@ -965,31 +960,13 @@ void __pm_runtime_disable(struct device 
 		goto out;
 	}
 
-	/*
-	 * Wake up the device if there's a resume request pending, because that
-	 * means there probably is some I/O to process and disabling run-time PM
-	 * shouldn't prevent the device from processing the I/O.
-	 */
-	if (check_resume && dev->power.request_pending
-	    && dev->power.request == RPM_REQ_RESUME) {
-		/*
-		 * Prevent suspends and idle notifications from being carried
-		 * out after we have woken up the device.
-		 */
-		pm_runtime_get_noresume(dev);
-
-		__pm_runtime_resume(dev, false);
-
-		pm_runtime_put_noidle(dev);
-	}
-
 	if (!dev->power.disable_depth++)
 		__pm_runtime_barrier(dev);
 
  out:
 	spin_unlock_irq(&dev->power.lock);
 }
-EXPORT_SYMBOL_GPL(__pm_runtime_disable);
+EXPORT_SYMBOL_GPL(pm_runtime_disable);
 
 /**
  * pm_runtime_enable - Enable run-time PM of a device.
@@ -1092,7 +1069,7 @@ void pm_runtime_init(struct device *dev)
  */
 void pm_runtime_remove(struct device *dev)
 {
-	__pm_runtime_disable(dev, false);
+	pm_runtime_disable(dev);
 
 	/* Change the status back to 'suspended' to match the initial status. */
 	if (dev->power.runtime_status == RPM_ACTIVE)
Index: linux-2.6/include/linux/pm_runtime.h
===================================================================
--- linux-2.6.orig/include/linux/pm_runtime.h
+++ linux-2.6/include/linux/pm_runtime.h
@@ -27,7 +27,7 @@ extern int __pm_runtime_put(struct devic
 extern int __pm_runtime_set_status(struct device *dev, unsigned int status);
 extern int pm_runtime_barrier(struct device *dev);
 extern void pm_runtime_enable(struct device *dev);
-extern void __pm_runtime_disable(struct device *dev, bool check_resume);
+extern void pm_runtime_disable(struct device *dev);
 extern void pm_runtime_allow(struct device *dev);
 extern void pm_runtime_forbid(struct device *dev);
 
@@ -79,7 +79,7 @@ static inline int __pm_runtime_set_statu
 					    unsigned int status) { return 0; }
 static inline int pm_runtime_barrier(struct device *dev) { return 0; }
 static inline void pm_runtime_enable(struct device *dev) {}
-static inline void __pm_runtime_disable(struct device *dev, bool c) {}
+static inline void pm_runtime_disable(struct device *dev) {}
 static inline void pm_runtime_allow(struct device *dev) {}
 static inline void pm_runtime_forbid(struct device *dev) {}
 
@@ -122,9 +122,4 @@ static inline void pm_runtime_set_suspen
 	__pm_runtime_set_status(dev, RPM_SUSPENDED);
 }
 
-static inline void pm_runtime_disable(struct device *dev)
-{
-	__pm_runtime_disable(dev, true);
-}
-
 #endif

