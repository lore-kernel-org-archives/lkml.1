Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZIMVZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZIMVZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 17:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbZIMVZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 17:25:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50582 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175AbZIMVYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 17:24:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 4/4] PCI PM: Run-time callbacks for PCI bus type
Date: Sun, 13 Sep 2009 23:25:03 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Shaohua Li <shaohua.li@intel.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <200909132320.05077.rjw@sisk.pl>
In-Reply-To: <200909132320.05077.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909132325.03698.rjw@sisk.pl>
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
 drivers/pci/pci-driver.c |   97 ++++++++++++++++++++++++++++++++++++++++++++---
 kernel/power/Kconfig     |    5 ++
 2 files changed, 97 insertions(+), 5 deletions(-)

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
 
 /*
@@ -509,7 +510,7 @@ static int pci_restore_standard_config(s
 	return pci_restore_state(pci_dev);
 }
 
-static void pci_pm_default_resume_noirq(struct pci_dev *pci_dev)
+static void pci_pm_default_resume_early(struct pci_dev *pci_dev)
 {
 	pci_restore_standard_config(pci_dev);
 	pci_fixup_device(pci_fixup_resume_early, pci_dev);
@@ -653,7 +654,7 @@ static int pci_pm_resume_noirq(struct de
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
-	pci_pm_default_resume_noirq(pci_dev);
+	pci_pm_default_resume_early(pci_dev);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
@@ -851,7 +852,7 @@ static int pci_pm_restore_noirq(struct d
 	struct device_driver *drv = dev->driver;
 	int error = 0;
 
-	pci_pm_default_resume_noirq(pci_dev);
+	pci_pm_default_resume_early(pci_dev);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_resume_early(dev);
@@ -903,6 +904,89 @@ static int pci_pm_restore(struct device 
 
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
+	if (!pci_dev->state_saved) {
+		pci_save_state(pci_dev);
+		if (!pci_is_bridge(pci_dev))
+			pci_prepare_to_sleep(pci_dev);
+	}
+
+	pci_platform_run_wake(pci_dev, true);
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
+	pci_platform_run_wake(pci_dev, false);
+	pci_pm_default_resume_early(pci_dev);
+	pci_pm_default_resume(pci_dev);
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
@@ -918,15 +1002,18 @@ const struct dev_pm_ops pci_dev_pm_ops =
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
