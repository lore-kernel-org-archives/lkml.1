Return-Path: <linux-kernel-owner+w=401wt.eu-S1751513AbZL0UOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbZL0UOb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 15:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZL0ULk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 15:11:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60428 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZL0ULh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 15:11:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/12] PCI PM: Add function for checking PME status of devices
Date: Sun, 27 Dec 2009 20:59:06 +0100
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
Message-Id: <200912272059.06718.rjw@sisk.pl>
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
@@ -1180,6 +1180,41 @@ int pci_set_pcie_reset_state(struct pci_
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

