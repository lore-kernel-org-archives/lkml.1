Return-Path: <linux-kernel-owner+w=401wt.eu-S1751324AbZHMA3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbZHMA3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 20:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZHMA3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 20:29:33 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43049 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZHMA3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 20:29:31 -0400
Date: Thu, 13 Aug 2009 01:29:25 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [RFC] PCI: Runtime power management
Message-ID: <20090813002925.GA2532@srcf.ucam.org>
References: <200908081625.57333.rjw@sisk.pl> <200908092313.05541.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908092313.05541.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a fixed BIOS from Dell and have been able to get this working now. 
It seems entirely happy with USB, but I'd like some sanity checks on 
whether I'm doing this correctly. There's certainly a couple of quirks 
related to setting the ACPI GPE type that would need a little bit of 
work in the ACPI layer, and it breaks ACPI-mediated PCI hotplug though 
that's easy enough to fix by just calling into the hotplug code from the 
core notifier.

This patch builds on top of Rafael's work on systemwide runtime power
management. It supports suspending and resuming PCI devices at runtime,
enabling platform wakeup events that allow the devices to automatically
resume when appropriate. It currently requires platform support, but PCIe
setups could be supported natively once native PCIe PME code has been added
to the kernel.
---
 drivers/pci/pci-acpi.c   |   55 +++++++++++++++++++++++++
 drivers/pci/pci-driver.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.c        |   87 ++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h        |    3 +
 include/linux/pci.h      |    3 +
 5 files changed, 248 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index ea15b05..a98a777 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <linux/pci-aspm.h>
+#include <linux/pm_runtime.h>
 #include <acpi/acpi.h>
 #include <acpi/acpi_bus.h>
 
@@ -120,14 +121,62 @@ static int acpi_pci_sleep_wake(struct pci_dev *dev, bool enable)
 	return error;
 }
 
+static int acpi_pci_runtime_wake(struct pci_dev *dev, bool enable)
+{
+	acpi_status status;
+	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	struct acpi_device *acpi_dev;
+
+	if (!handle)
+		return -ENODEV;
+
+	status = acpi_bus_get_device(handle, &acpi_dev);
+	if (ACPI_FAILURE(status))
+		return -ENODEV;
+
+	if (enable) {
+		acpi_set_gpe_type(acpi_dev->wakeup.gpe_device,
+				  acpi_dev->wakeup.gpe_number,
+				  ACPI_GPE_TYPE_WAKE_RUN);
+		acpi_enable_gpe(acpi_dev->wakeup.gpe_device,
+				acpi_dev->wakeup.gpe_number);
+	} else {
+		acpi_set_gpe_type(acpi_dev->wakeup.gpe_device,
+				  acpi_dev->wakeup.gpe_number,
+				  ACPI_GPE_TYPE_WAKE);
+		acpi_disable_gpe(acpi_dev->wakeup.gpe_device,
+				 acpi_dev->wakeup.gpe_number);
+	}
+	return 0;
+}
+
+
 static struct pci_platform_pm_ops acpi_pci_platform_pm = {
 	.is_manageable = acpi_pci_power_manageable,
 	.set_state = acpi_pci_set_power_state,
 	.choose_state = acpi_pci_choose_state,
 	.can_wakeup = acpi_pci_can_wakeup,
 	.sleep_wake = acpi_pci_sleep_wake,
+	.runtime_wake = acpi_pci_runtime_wake,
 };
 
+static void pci_device_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct device *dev = data;
+
+	if (event == ACPI_NOTIFY_DEVICE_WAKE)
+		pm_runtime_resume(dev);
+}
+
+static void pci_root_bridge_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct device *dev = data;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+
+	if (event == ACPI_NOTIFY_DEVICE_WAKE)
+		pci_bus_pme_event(pci_dev);
+}
+
 /* ACPI bus type */
 static int acpi_pci_find_device(struct device *dev, acpi_handle *handle)
 {
@@ -140,6 +189,9 @@ static int acpi_pci_find_device(struct device *dev, acpi_handle *handle)
 	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(dev->parent), addr);
 	if (!*handle)
 		return -ENODEV;
+
+	acpi_install_notify_handler(*handle, ACPI_SYSTEM_NOTIFY,
+				    pci_device_notify, dev);
 	return 0;
 }
 
@@ -158,6 +210,9 @@ static int acpi_pci_find_root_bridge(struct device *dev, acpi_handle *handle)
 	*handle = acpi_get_pci_rootbridge_handle(seg, bus);
 	if (!*handle)
 		return -ENODEV;
+
+	acpi_install_notify_handler(*handle, ACPI_SYSTEM_NOTIFY,
+				    pci_root_bridge_notify, dev);
 	return 0;
 }
 
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index d76c4c8..1f605d8 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -11,12 +11,14 @@
 #include <linux/pci.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/mempolicy.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/cpu.h>
+#include <linux/pm_runtime.h>
 #include "pci.h"
 
 /*
@@ -910,6 +912,101 @@ static int pci_pm_restore(struct device *dev)
 
 #endif /* !CONFIG_HIBERNATION */
 
+#ifdef CONFIG_PM_RUNTIME
+
+static int pci_pm_runtime_suspend(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	int error;
+
+	device_set_wakeup_enable(dev, 1);
+	error = pci_enable_runtime_wake(pci_dev, true);
+
+	if (error)
+		return -EBUSY;
+
+	if (pm && pm->runtime_suspend)
+		error = pm->runtime_suspend(dev);
+
+	if (error)
+		goto out;
+
+	error = pci_pm_suspend(dev);
+
+	if (error)
+		goto resume;
+
+	disable_irq(pci_dev->irq);
+	error = pci_pm_suspend_noirq(dev);
+	enable_irq(pci_dev->irq);
+
+	if (error)
+		goto resume_noirq;
+
+	return 0;
+
+resume_noirq:
+	disable_irq(pci_dev->irq);
+	pci_pm_resume_noirq(dev);
+	enable_irq(pci_dev->irq);
+resume:
+	pci_pm_resume(dev);
+out:
+	pci_enable_runtime_wake(pci_dev, false);
+	return error;
+}
+
+static int pci_pm_runtime_resume(struct device *dev)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	int error = 0;
+
+	disable_irq(pci_dev->irq);
+	error = pci_pm_resume_noirq(dev);
+	enable_irq(pci_dev->irq);
+
+	if (error)
+		return error;
+
+	error = pci_pm_resume(dev);
+
+	if (error)
+		return error;
+
+	if (pm->runtime_resume)
+		error = pm->runtime_resume(dev);
+
+	if (error)
+		return error;
+
+	error = pci_enable_runtime_wake(pci_dev, false);
+
+	if (error)
+		return error;
+
+	return 0;
+}
+
+static void pci_pm_runtime_idle(struct device *dev)
+{
+	struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (pm && pm->runtime_idle)
+		pm->runtime_idle(dev);
+
+	pm_schedule_suspend(dev, 0);
+}
+
+#else /* !CONFIG_PM_RUNTIME */
+
+#define pci_pm_runtime_suspend	NULL
+#define pci_pm_runtime_resume	NULL
+#define pci_pm_runtime_idle	NULL
+
+#endif
+
 struct dev_pm_ops pci_dev_pm_ops = {
 	.prepare = pci_pm_prepare,
 	.complete = pci_pm_complete,
@@ -925,6 +1022,9 @@ struct dev_pm_ops pci_dev_pm_ops = {
 	.thaw_noirq = pci_pm_thaw_noirq,
 	.poweroff_noirq = pci_pm_poweroff_noirq,
 	.restore_noirq = pci_pm_restore_noirq,
+	.runtime_suspend = pci_pm_runtime_suspend,
+	.runtime_resume = pci_pm_runtime_resume,
+	.runtime_idle = pci_pm_runtime_idle,
 };
 
 #define PCI_PM_OPS_PTR	(&pci_dev_pm_ops)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index dbd0f94..ab3a116 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -18,6 +18,7 @@
 #include <linux/log2.h>
 #include <linux/pci-aspm.h>
 #include <linux/pm_wakeup.h>
+#include <linux/pm_runtime.h>
 #include <linux/interrupt.h>
 #include <asm/dma.h>	/* isa_dma_bridge_buggy */
 #include <linux/device.h>
@@ -428,6 +429,12 @@ static inline int platform_pci_sleep_wake(struct pci_dev *dev, bool enable)
 			pci_platform_pm->sleep_wake(dev, enable) : -ENODEV;
 }
 
+static inline int platform_pci_runtime_wake(struct pci_dev *dev, bool enable)
+{
+	return pci_platform_pm ?
+			pci_platform_pm->runtime_wake(dev, enable) : -ENODEV;
+}
+
 /**
  * pci_raw_set_power_state - Use PCI PM registers to set the power state of
  *                           given PCI device
@@ -1239,6 +1246,38 @@ int pci_enable_wake(struct pci_dev *dev, pci_power_t state, bool enable)
 }
 
 /**
+ * pci_enable_runtime_wake - enable PCI device as runtime wakeup event source
+ * @dev: PCI device affected
+ * @enable: True to enable event generation; false to disable
+ *
+ * This enables the device as a runtime wakeup event source, or disables it.
+ * This typically requires platform support.
+ *
+ * RETURN VALUE:
+ * 0 is returned on success
+ * -EINVAL is returned if device is not supposed to wake up the system
+ * -ENODEV is returned if platform cannot support runtime PM on the device
+ */
+int pci_enable_runtime_wake(struct pci_dev *dev, bool enable)
+{
+	int error = 0;
+	bool pme_done = false;
+
+	if (!enable && platform_pci_can_wakeup(dev))
+		error = platform_pci_runtime_wake(dev, false);
+
+	if (!enable || pci_pme_capable(dev, PCI_D3hot)) {
+		pci_pme_active(dev, enable);
+		pme_done = true;
+	}
+
+	if (enable && platform_pci_can_wakeup(dev))
+		error = platform_pci_runtime_wake(dev, true);
+
+	return pme_done ? 0 : error;
+}
+
+/**
  * pci_wake_from_d3 - enable/disable device to wake up from D3_hot or D3_cold
  * @dev: PCI device to prepare
  * @enable: True to enable wake-up event generation; false to disable
@@ -1346,6 +1385,54 @@ int pci_back_from_sleep(struct pci_dev *dev)
 }
 
 /**
+ * pci_dev_pme_event - check if a device has a pending pme
+ *
+ * @dev: Device to handle.
+ */
+
+int pci_dev_pme_event(struct pci_dev *dev)
+{
+	u16 pmcsr;
+
+	if (!dev->pm_cap)
+		return -ENODEV;
+
+	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
+
+	if (pmcsr & PCI_PM_CTRL_PME_STATUS) {
+		pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, pmcsr);
+		pm_runtime_get(&dev->dev);
+		return 0;
+	}
+
+	return -ENODEV;
+}
+
+/**
+ * pci_bus_pme_event - search for subordinate devices with a pending
+ *		   pme and handle them
+ *
+ * @dev: Parent device to handle
+ */
+int pci_bus_pme_event(struct pci_dev *dev)
+{
+	struct pci_bus *bus;
+	struct pci_dev *pdev;
+
+	if (pci_is_root_bus(dev->bus))
+		bus = dev->bus;
+	else if (dev->subordinate)
+		bus = dev->subordinate;
+	else
+		return -ENODEV;
+
+	list_for_each_entry(pdev, &bus->devices, bus_list)
+		pci_dev_pme_event(pdev);
+
+	return 0;
+}
+
+/**
  * pci_pm_init - Initialize PM functions of given PCI device
  * @dev: PCI device to handle.
  */
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index f73bcbe..a81aff2 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -34,6 +34,8 @@ extern int pci_mmap_fits(struct pci_dev *pdev, int resno,
  *
  * @sleep_wake: enables/disables the system wake up capability of given device
  *
+ * @runtime_wake: enables/disables the runtime wakeup capability of given device
+ *
  * If given platform is generally capable of power managing PCI devices, all of
  * these callbacks are mandatory.
  */
@@ -43,6 +45,7 @@ struct pci_platform_pm_ops {
 	pci_power_t (*choose_state)(struct pci_dev *dev);
 	bool (*can_wakeup)(struct pci_dev *dev);
 	int (*sleep_wake)(struct pci_dev *dev, bool enable);
+	int (*runtime_wake)(struct pci_dev *dev, bool enable);
 };
 
 extern int pci_set_platform_pm(struct pci_platform_pm_ops *ops);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 115fb7b..8a3fea0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -734,10 +734,13 @@ pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state);
 bool pci_pme_capable(struct pci_dev *dev, pci_power_t state);
 void pci_pme_active(struct pci_dev *dev, bool enable);
 int pci_enable_wake(struct pci_dev *dev, pci_power_t state, bool enable);
+int pci_enable_runtime_wake(struct pci_dev *dev, bool enable);
 int pci_wake_from_d3(struct pci_dev *dev, bool enable);
 pci_power_t pci_target_state(struct pci_dev *dev);
 int pci_prepare_to_sleep(struct pci_dev *dev);
 int pci_back_from_sleep(struct pci_dev *dev);
+int pci_dev_pme_event(struct pci_dev *dev);
+int pci_bus_pme_event(struct pci_dev *dev);
 
 /* Functions for PCI Hotplug drivers to use */
 int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap);

-- 
Matthew Garrett | mjg59@srcf.ucam.org
