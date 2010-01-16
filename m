Return-Path: <linux-kernel-owner+w=401wt.eu-S1751603Ab0APXZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab0APXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 18:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056Ab0APXZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 18:25:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39300 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab0APXZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 18:25:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [RFT/RFC] PM: Skip kernel VT switch during suspend/resume with i915/KMS drivers
Date: Sun, 17 Jan 2010 00:25:49 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001170025.49758.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been experimenting with the appended patch for some time.  It appears to
speed up suspend and resume a bit if the box uses i915 with KMS.

It doesn't seem to break things, but of course more testing would be
appreciated.  Comments are welcome as well.

Thanks,
Rafael

---
 drivers/gpu/drm/i915/i915_drv.c |    4 ++++
 include/linux/suspend.h         |    9 +++++++++
 kernel/power/suspend.c          |   16 +++++++++++++---
 3 files changed, 26 insertions(+), 3 deletions(-)

Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -116,6 +116,13 @@ struct platform_suspend_ops {
 };
 
 #ifdef CONFIG_SUSPEND
+extern bool vt_switch_enabled;
+
+static inline void disable_suspend_vt_switch(void)
+{
+	vt_switch_enabled = false;
+}
+
 /**
  * suspend_set_ops - set platform dependent suspend operations
  * @ops: The new suspend operations to set.
@@ -143,6 +150,8 @@ extern void arch_suspend_enable_irqs(voi
 
 extern int pm_suspend(suspend_state_t state);
 #else /* !CONFIG_SUSPEND */
+static inline void disable_suspend_vt_switch(void) {}
+
 #define suspend_valid_only_mem	NULL
 
 static inline void suspend_set_ops(struct platform_suspend_ops *ops) {}
Index: linux-2.6/kernel/power/suspend.c
===================================================================
--- linux-2.6.orig/kernel/power/suspend.c
+++ linux-2.6/kernel/power/suspend.c
@@ -18,6 +18,13 @@
 
 #include "power.h"
 
+/*
+ * If set, switch to a new VT before suspend and switch back to the original
+ * one during resume.
+ */
+bool vt_switch_enabled = true;
+EXPORT_SYMBOL_GPL(vt_switch_enabled);
+
 const char *const pm_states[PM_SUSPEND_MAX] = {
 	[PM_SUSPEND_STANDBY]	= "standby",
 	[PM_SUSPEND_MEM]	= "mem",
@@ -82,7 +89,8 @@ static int suspend_prepare(void)
 	if (!suspend_ops || !suspend_ops->enter)
 		return -EPERM;
 
-	pm_prepare_console();
+	if (vt_switch_enabled)
+		pm_prepare_console();
 
 	error = pm_notifier_call_chain(PM_SUSPEND_PREPARE);
 	if (error)
@@ -100,7 +108,8 @@ static int suspend_prepare(void)
 	usermodehelper_enable();
  Finish:
 	pm_notifier_call_chain(PM_POST_SUSPEND);
-	pm_restore_console();
+	if (vt_switch_enabled)
+		pm_restore_console();
 	return error;
 }
 
@@ -238,7 +247,8 @@ static void suspend_finish(void)
 	suspend_thaw_processes();
 	usermodehelper_enable();
 	pm_notifier_call_chain(PM_POST_SUSPEND);
-	pm_restore_console();
+	if (vt_switch_enabled)
+		pm_restore_console();
 }
 
 /**
Index: linux-2.6/drivers/gpu/drm/i915/i915_drv.c
===================================================================
--- linux-2.6.orig/drivers/gpu/drm/i915/i915_drv.c
+++ linux-2.6/drivers/gpu/drm/i915/i915_drv.c
@@ -28,6 +28,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/suspend.h>
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"
@@ -543,6 +544,9 @@ static int __init i915_init(void)
 		driver.driver_features &= ~DRIVER_MODESET;
 #endif
 
+	if (driver.driver_features & DRIVER_MODESET)
+		disable_suspend_vt_switch();
+
 	return drm_init(&driver);
 }
 
