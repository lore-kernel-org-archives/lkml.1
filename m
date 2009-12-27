Return-Path: <linux-kernel-owner+w=401wt.eu-S1751407AbZL0UMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407AbZL0UMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 15:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZL0UL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 15:11:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60504 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZL0ULz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 15:11:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 11/12] PCI PM: Run-time callbacks for PCI bus type (rev. 2)
Date: Sun, 27 Dec 2009 21:08:24 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Francois Romieu <romieu@fr.zoreil.com>
References: <200912272057.10443.rjw@sisk.pl>
In-Reply-To: <200912272057.10443.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912272108.25145.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce run-time PM callbacks for the PCI bus type.  Make the new
callbacks work in analogy with the existing system sleep PM
callbacks, so that the drivers already converted to struct dev_pm_ops
can use their suspend and resume routines for run-time PM without
modifications.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |  105 ++++++++++++++++++++++++++++++++++++++++++++---
 drivers/pci/pci.c        |   43 ++++++++++++++++---
 drivers/pci/pci.h        |    1 
 include/linux/pci.h      |    9 +++-
 kernel/power/Kconfig     |    5 ++
 5 files changed, 151 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -241,3 +241,8 @@ config PM_WAKEUP
 	bool
 	depends on SUSPEND || HIBERNATION || PM_RUNTIME
 	default y
+
+config PM_OPS
+	bool
+	depends on PM_SLEEP || PM_RUNTIME
+	default y
Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/cpu.h>
+#include <linux/pm_runtime.h>
 #include "pci.h"
 
 struct pci_dynid {
@@ -537,7 +538,7 @@ static int pci_restore_standard_config(s
 	return pci_restore_state(pci_dev);
 }
 
-static void pci_pm_default_resume_noirq(struct pci_dev *pci_dev)
+static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
 {
 	pci_restore_standard_config(pci_dev);
 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
@@ -581,6 +582,17 @@ static int pci_pm_prepare(struct device 
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
+	/*
+	 * PCI devices suspended at run time need to be resumed at this
+	 * point, because in general it is necessary to reconfigure them for
+	 * system suspend.  Namely, if the device is supposed to wake up the
+	 * system from the sleep state, we may need to reconfigure it for this
+	 * purpose.  In turn, if the device is not supposed to wake up the
+	 * system from the sleep state, we'll have to prevent it from signaling
+	 * wake-up.
+	 */
+	pm_runtime_resume(dev);
+
 	if (drv && drv->pm && drv->pm->prepare)
 		error = drv->pm->prepare(dev);
 
@@ -681,7 +693,7 @@ static int pci_pm_resume_noirq(struct de
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
-	pci_pm_default_resume_noirq(pci_dev);
+	pci_pm_default_resume_early(pci_dev);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
@@ -879,7 +891,7 @@ static int pci_pm_restore_noirq(struct d
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
-	pci_pm_default_resume_noirq(pci_dev);
+	pci_pm_default_resume_early(pci_dev);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
@@ -931,6 +943,86 @@ static int pci_pm_restore(struct device 
 
 #endif /* !CONFIG_HIBERNATION */
 
+#endif /* !CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM_RUNTIME
+
+static int pci_pm_runtime_suspend(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	pci_power_t prev = pci_dev->current_state;
+	int error;
+
+	if (!pm || !pm->runtime_suspend)
+		return -ENOSYS;
+
+	error = pm->runtime_suspend(dev);
+	suspend_report_result(pm->runtime_suspend, error);
+	if (error)
+		return error;
+
+	pci_fixup_device(pci_fixup_suspend, pci_dev);
+
+	if (!pci_dev->state_saved && pci_dev->current_state != PCI_D0
+	    && pci_dev->current_state != PCI_UNKNOWN) {
+		WARN_ONCE(pci_dev->current_state != prev,
+			"PCI PM: State of device not saved by %pF\n",
+			pm->runtime_suspend);
+		return 0;
+	}
+
+	if (!pci_dev->state_saved)
+		pci_save_state(pci_dev);
+
+	pci_finish_runtime_suspend(pci_dev);
+
+	return 0;
+}
+
+static int pci_pm_runtime_resume(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (!pm || !pm->runtime_resume)
+		return -ENOSYS;
+
+	pci_pm_default_resume_early(pci_dev);
+	__pci_enable_wake(pci_dev, PCI_D0, true, false);
+	pci_fixup_device(pci_fixup_resume, pci_dev);
+
+	return pm->runtime_resume(dev);
+}
+
+static int pci_pm_runtime_idle(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (!pm)
+		return -ENOSYS;
+
+	if (pm->runtime_idle) {
+		int ret = pm->runtime_idle(dev);
+		if (ret)
+			return ret;
+	}
+
+	pm_runtime_suspend(dev);
+
+	return 0;
+}
+
+#else /* !CONFIG_PM_RUNTIME */
+
+#define pci_pm_runtime_suspend	NULL
+#define pci_pm_runtime_resume	NULL
+#define pci_pm_runtime_idle	NULL
+
+#endif /* !CONFIG_PM_RUNTIME */
+
+#ifdef CONFIG_PM_OPS
+
 const struct dev_pm_ops pci_dev_pm_ops = {
 	.prepare = pci_pm_prepare,
 	.complete = pci_pm_complete,
@@ -946,15 +1038,18 @@ const struct dev_pm_ops pci_dev_pm_ops =
 	.thaw_noirq = pci_pm_thaw_noirq,
 	.poweroff_noirq = pci_pm_poweroff_noirq,
 	.restore_noirq = pci_pm_restore_noirq,
+	.runtime_suspend = pci_pm_runtime_suspend,
+	.runtime_resume = pci_pm_runtime_resume,
+	.runtime_idle = pci_pm_runtime_idle,
 };
 
 #define PCI_PM_OPS_PTR	(&pci_dev_pm_ops)
 
-#else /* !CONFIG_PM_SLEEP */
+#else /* !COMFIG_PM_OPS */
 
 #define PCI_PM_OPS_PTR	NULL
 
-#endif /* !CONFIG_PM_SLEEP */
+#endif /* !COMFIG_PM_OPS */
 
 /**
  * __pci_register_driver - register a new pci driver
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1287,9 +1287,10 @@ void pci_pme_active(struct pci_dev *dev,
 }
 
 /**
- * pci_enable_wake - enable PCI device as wakeup event source
+ * __pci_enable_wake - enable PCI device as wakeup event source
  * @dev: PCI device affected
  * @state: PCI state from which device will issue wakeup events
+ * @runtime: True if the events are to be generated at run time
  * @enable: True to enable event generation; false to disable
  *
  * This enables the device as a wakeup event source, or disables it.
@@ -1305,11 +1306,12 @@ void pci_pme_active(struct pci_dev *dev,
  * Error code depending on the platform is returned if both the platform and
  * the native mechanism fail to enable the generation of wake-up events
  */
-int pci_enable_wake(struct pci_dev *dev, pci_power_t state, bool enable)
+int __pci_enable_wake(struct pci_dev *dev, pci_power_t state,
+		      bool runtime, bool enable)
 {
 	int ret = 0;
 
-	if (enable && !device_may_wakeup(&dev->dev))
+	if (enable && !runtime && !device_may_wakeup(&dev->dev))
 		return -EINVAL;
 
 	/* Don't do the same thing twice in a row for one device. */
@@ -1329,19 +1331,24 @@ int pci_enable_wake(struct pci_dev *dev,
 			pci_pme_active(dev, true);
 		else
 			ret = 1;
-		error = platform_pci_sleep_wake(dev, true);
+		error = runtime ? platform_pci_run_wake(dev, true) :
+					platform_pci_sleep_wake(dev, true);
 		if (ret)
 			ret = error;
 		if (!ret)
 			dev->wakeup_prepared = true;
 	} else {
-		platform_pci_sleep_wake(dev, false);
+		if (runtime)
+			platform_pci_run_wake(dev, false);
+		else
+			platform_pci_sleep_wake(dev, false);
 		pci_pme_active(dev, false);
 		dev->wakeup_prepared = false;
 	}
 
 	return ret;
 }
+EXPORT_SYMBOL(__pci_enable_wake);
 
 /**
  * pci_wake_from_d3 - enable/disable device to wake up from D3_hot or D3_cold
@@ -1451,6 +1458,31 @@ int pci_back_from_sleep(struct pci_dev *
 }
 
 /**
+ * pci_finish_runtime_suspend - Carry out PCI-specific part of runtime suspend.
+ * @dev: PCI device being suspended.
+ *
+ * Prepare @dev to generate wake-up events at run time and put it into a low
+ * power state.
+ */
+int pci_finish_runtime_suspend(struct pci_dev *dev)
+{
+	pci_power_t target_state = pci_target_state(dev);
+	int error;
+
+	if (target_state == PCI_POWER_ERROR)
+		return -EIO;
+
+	__pci_enable_wake(dev, target_state, true, pci_dev_run_wake(dev));
+
+	error = pci_set_power_state(dev, target_state);
+
+	if (error)
+		__pci_enable_wake(dev, target_state, true, false);
+
+	return error;
+}
+
+/**
  * pci_dev_run_wake - Check if device can generate run-time wake-up events.
  * @dev: Device to check.
  *
@@ -2954,7 +2986,6 @@ EXPORT_SYMBOL(pci_save_state);
 EXPORT_SYMBOL(pci_restore_state);
 EXPORT_SYMBOL(pci_pme_capable);
 EXPORT_SYMBOL(pci_pme_active);
-EXPORT_SYMBOL(pci_enable_wake);
 EXPORT_SYMBOL(pci_wake_from_d3);
 EXPORT_SYMBOL(pci_target_state);
 EXPORT_SYMBOL(pci_prepare_to_sleep);
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -747,13 +747,20 @@ int pci_set_power_state(struct pci_dev *
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state);
 bool pci_pme_capable(struct pci_dev *dev, pci_power_t state);
 void pci_pme_active(struct pci_dev *dev, bool enable);
-int pci_enable_wake(struct pci_dev *dev, pci_power_t state, bool enable);
+int __pci_enable_wake(struct pci_dev *dev, pci_power_t state,
+		      bool runtime, bool enable);
 int pci_wake_from_d3(struct pci_dev *dev, bool enable);
 pci_power_t pci_target_state(struct pci_dev *dev);
 int pci_prepare_to_sleep(struct pci_dev *dev);
 int pci_back_from_sleep(struct pci_dev *dev);
 bool pci_dev_run_wake(struct pci_dev *dev);
 
+static inline int pci_enable_wake(struct pci_dev *dev, pci_power_t state,
+				  bool enable)
+{
+	return __pci_enable_wake(dev, state, false, enable);
+}
+
 /* Functions for PCI Hotplug drivers to use */
 int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap);
 #ifdef CONFIG_HOTPLUG
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -55,6 +55,7 @@ extern int pci_set_platform_pm(struct pc
 extern void pci_update_current_state(struct pci_dev *dev, pci_power_t state);
 extern void pci_disable_enabled_device(struct pci_dev *dev);
 extern bool pci_check_pme_status(struct pci_dev *dev);
+extern int pci_finish_runtime_suspend(struct pci_dev *dev);
 extern int __pci_pme_wakeup(struct pci_dev *dev, void *ign);
 extern void pci_pme_wakeup_bus(struct pci_bus *bus);
 extern void pci_pm_init(struct pci_dev *dev);

