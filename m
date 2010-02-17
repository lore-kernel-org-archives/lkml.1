Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab0BQWpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:45:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46315 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757512Ab0BQWpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:45:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/8] PCI PM: Add function for checking PME status of devices
Date: Wed, 17 Feb 2010 23:36:58 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: "Moore, Robert" <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>
References: <201002172335.47703.rjw@sisk.pl>
In-Reply-To: <201002172335.47703.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002172336.58766.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add function pci_check_pme_status() that will check the PME status
bit of given device and clear it along with the PME enable bit.  It
will be necessary for PCI run-time power management.

Based on a patch from Shaohua Li <shaohua.li@intel.com>

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci.c |   35 +++++++++++++++++++++++++++++++++++
 drivers/pci/pci.h |    1 +
 2 files changed, 36 insertions(+)

Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -49,6 +49,7 @@ struct pci_platform_pm_ops {
 extern int pci_set_platform_pm(struct pci_platform_pm_ops *ops);
 extern void pci_update_current_state(struct pci_dev *dev, pci_power_t state);
 extern void pci_disable_enabled_device(struct pci_dev *dev);
+extern bool pci_check_pme_status(struct pci_dev *dev);
 extern void pci_pm_init(struct pci_dev *dev);
 extern void platform_pci_wakeup_init(struct pci_dev *dev);
 extern void pci_allocate_cap_save_buffers(struct pci_dev *dev);
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1195,6 +1195,41 @@ int pci_set_pcie_reset_state(struct pci_
 }
 
 /**
+ * pci_check_pme_status - Check if given device has generated PME.
+ * @dev: Device to check.
+ *
+ * Check the PME status of the device and if set, clear it and clear PME enable
+ * (if set).  Return 'true' if PME status and PME enable were both set or
+ * 'false' otherwise.
+ */
+bool pci_check_pme_status(struct pci_dev *dev)
+{
+	int pmcsr_pos;
+	u16 pmcsr;
+	bool ret = false;
+
+	if (!dev->pm_cap)
+		return false;
+
+	pmcsr_pos = dev->pm_cap + PCI_PM_CTRL;
+	pci_read_config_word(dev, pmcsr_pos, &pmcsr);
+	if (!(pmcsr & PCI_PM_CTRL_PME_STATUS))
+		return false;
+
+	/* Clear PME status. */
+	pmcsr |= PCI_PM_CTRL_PME_STATUS;
+	if (pmcsr & PCI_PM_CTRL_PME_ENABLE) {
+		/* Disable PME to avoid interrupt flood. */
+		pmcsr &= ~PCI_PM_CTRL_PME_ENABLE;
+		ret = true;
+	}
+
+	pci_write_config_word(dev, pmcsr_pos, pmcsr);
+
+	return ret;
+}
+
+/**
  * pci_pme_capable - check the capability of PCI device to generate PME#
  * @dev: PCI device to handle.
  * @state: PCI state from which device will issue PME#.

