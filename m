Return-Path: <linux-kernel-owner+w=401wt.eu-S1765299AbXJRDBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765299AbXJRDBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760417AbXJRDA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:00:56 -0400
Received: from rtr.ca ([76.10.145.34]:2766 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbXJRDAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:00:55 -0400
Message-ID: <4716CC66.8040605@rtr.ca>
Date: Wed, 17 Oct 2007 23:00:54 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>, greg@kroah.com,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [PATCH 2/3] pciehp_split_pcie_init
References: <4716CB9D.6080503@rtr.ca>
In-Reply-To: <4716CB9D.6080503@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

02_pciehp_split_pcie_init.patch:

Split out the hotplug hardware initialization code from pcie_init()
into pcie_init_enable_events(), without changing any functionality.

Signed-off-by: Mark Lord <mlord@pobox.com>
---
--- git12/drivers/pci/hotplug/pciehp_hpc.c	2007-10-17 19:06:38.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_hpc.c	2007-10-17 19:29:42.000000000 -0400
@@ -1067,99 +1067,22 @@
 }
 #endif
 
-int pcie_init(struct controller * ctrl, struct pcie_device *dev)
+int pcie_init_hardware(struct controller *ctrl, struct pcie_device *dev)
 {
 	int rc;
 	u16 temp_word;
-	u16 cap_reg;
 	u16 intr_enable = 0;
 	u32 slot_cap;
-	int cap_base;
-	u16 slot_status, slot_ctrl;
+	u16 slot_status;
 	struct pci_dev *pdev;
 
 	pdev = dev->port;
-	ctrl->pci_dev = pdev;	/* save pci_dev in context */
-
-	dbg("%s: hotplug controller vendor id 0x%x device id 0x%x\n",
-			__FUNCTION__, pdev->vendor, pdev->device);
-
-	if ((cap_base = pci_find_capability(pdev, PCI_CAP_ID_EXP)) == 0) {
-		dbg("%s: Can't find PCI_CAP_ID_EXP (0x10)\n", __FUNCTION__);
-		goto abort_free_ctlr;
-	}
-
-	ctrl->cap_base = cap_base;
-
-	dbg("%s: pcie_cap_base %x\n", __FUNCTION__, cap_base);
-
-	rc = pciehp_readw(ctrl, CAPREG, &cap_reg);
-	if (rc) {
-		err("%s: Cannot read CAPREG register\n", __FUNCTION__);
-		goto abort_free_ctlr;
-	}
-	dbg("%s: CAPREG offset %x cap_reg %x\n",
-	    __FUNCTION__, ctrl->cap_base + CAPREG, cap_reg);
-
-	if (((cap_reg & SLOT_IMPL) == 0) ||
-	    (((cap_reg & DEV_PORT_TYPE) != 0x0040)
-		&& ((cap_reg & DEV_PORT_TYPE) != 0x0060))) {
-		dbg("%s : This is not a root port or the port is not "
-		    "connected to a slot\n", __FUNCTION__);
-		goto abort_free_ctlr;
-	}
 
 	rc = pciehp_readl(ctrl, SLOTCAP, &slot_cap);
 	if (rc) {
 		err("%s: Cannot read SLOTCAP register\n", __FUNCTION__);
 		goto abort_free_ctlr;
 	}
-	dbg("%s: SLOTCAP offset %x slot_cap %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCAP, slot_cap);
-
-	if (!(slot_cap & HP_CAP)) {
-		dbg("%s : This slot is not hot-plug capable\n", __FUNCTION__);
-		goto abort_free_ctlr;
-	}
-	/* For debugging purpose */
-	rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
-	if (rc) {
-		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
-		goto abort_free_ctlr;
-	}
-	dbg("%s: SLOTSTATUS offset %x slot_status %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTSTATUS, slot_status);
-
-	rc = pciehp_readw(ctrl, SLOTCTRL, &slot_ctrl);
-	if (rc) {
-		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
-		goto abort_free_ctlr;
-	}
-	dbg("%s: SLOTCTRL offset %x slot_ctrl %x\n",
-	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, slot_ctrl);
-
-	for (rc = 0; rc < DEVICE_COUNT_RESOURCE; rc++)
-		if (pci_resource_len(pdev, rc) > 0)
-			dbg("pci resource[%d] start=0x%llx(len=0x%llx)\n", rc,
-			    (unsigned long long)pci_resource_start(pdev, rc),
-			    (unsigned long long)pci_resource_len(pdev, rc));
-
-	info("HPC vendor_id %x device_id %x ss_vid %x ss_did %x\n",
-	     pdev->vendor, pdev->device,
-	     pdev->subsystem_vendor, pdev->subsystem_device);
-
-	mutex_init(&ctrl->crit_sect);
-	mutex_init(&ctrl->ctrl_lock);
-	spin_lock_init(&ctrl->lock);
-
-	/* setup wait queue */
-	init_waitqueue_head(&ctrl->queue);
-
-	/* return PCI Controller Info */
-	ctrl->slot_device_offset = 0;
-	ctrl->num_slots = 1;
-	ctrl->first_slot = slot_cap >> 19;
-	ctrl->ctrlcap = slot_cap & 0x0000007f;
 
 	/* Mask Hot-plug Interrupt Enable */
 	rc = pciehp_readw(ctrl, SLOTCTRL, &temp_word);
@@ -1280,8 +1203,6 @@
 			goto abort_disable_intr;
 	}
 
-	ctrl->hpc_ops = &pciehp_hpc_ops;
-
 	return 0;
 
 	/* We end up here for the many possible ways to fail this API. */
@@ -1303,3 +1224,105 @@
 abort_free_ctlr:
 	return -1;
 }
+
+int pcie_init(struct controller *ctrl, struct pcie_device *dev)
+{
+	int rc;
+	u16 cap_reg;
+	u32 slot_cap;
+	int cap_base;
+	u16 slot_status, slot_ctrl;
+	struct pci_dev *pdev;
+
+	pdev = dev->port;
+	ctrl->pci_dev = pdev;	/* save pci_dev in context */
+
+	dbg("%s: hotplug controller vendor id 0x%x device id 0x%x\n",
+			__FUNCTION__, pdev->vendor, pdev->device);
+
+	cap_base = pci_find_capability(pdev, PCI_CAP_ID_EXP);
+	if (cap_base == 0) {
+		dbg("%s: Can't find PCI_CAP_ID_EXP (0x10)\n", __FUNCTION__);
+		goto abort;
+	}
+
+	ctrl->cap_base = cap_base;
+
+	dbg("%s: pcie_cap_base %x\n", __FUNCTION__, cap_base);
+
+	rc = pciehp_readw(ctrl, CAPREG, &cap_reg);
+	if (rc) {
+		err("%s: Cannot read CAPREG register\n", __FUNCTION__);
+		goto abort;
+	}
+	dbg("%s: CAPREG offset %x cap_reg %x\n",
+	    __FUNCTION__, ctrl->cap_base + CAPREG, cap_reg);
+
+	if (((cap_reg & SLOT_IMPL) == 0) ||
+	    (((cap_reg & DEV_PORT_TYPE) != 0x0040)
+		&& ((cap_reg & DEV_PORT_TYPE) != 0x0060))) {
+		dbg("%s : This is not a root port or the port is not "
+		    "connected to a slot\n", __FUNCTION__);
+		goto abort;
+	}
+
+	rc = pciehp_readl(ctrl, SLOTCAP, &slot_cap);
+	if (rc) {
+		err("%s: Cannot read SLOTCAP register\n", __FUNCTION__);
+		goto abort;
+	}
+	dbg("%s: SLOTCAP offset %x slot_cap %x\n",
+	    __FUNCTION__, ctrl->cap_base + SLOTCAP, slot_cap);
+
+	if (!(slot_cap & HP_CAP)) {
+		dbg("%s : This slot is not hot-plug capable\n", __FUNCTION__);
+		goto abort;
+	}
+	/* For debugging purpose */
+	rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
+	if (rc) {
+		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
+		goto abort;
+	}
+	dbg("%s: SLOTSTATUS offset %x slot_status %x\n",
+	    __FUNCTION__, ctrl->cap_base + SLOTSTATUS, slot_status);
+
+	rc = pciehp_readw(ctrl, SLOTCTRL, &slot_ctrl);
+	if (rc) {
+		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
+		goto abort;
+	}
+	dbg("%s: SLOTCTRL offset %x slot_ctrl %x\n",
+	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, slot_ctrl);
+
+	for (rc = 0; rc < DEVICE_COUNT_RESOURCE; rc++)
+		if (pci_resource_len(pdev, rc) > 0)
+			dbg("pci resource[%d] start=0x%llx(len=0x%llx)\n", rc,
+			    (unsigned long long)pci_resource_start(pdev, rc),
+			    (unsigned long long)pci_resource_len(pdev, rc));
+
+	info("HPC vendor_id %x device_id %x ss_vid %x ss_did %x\n",
+	     pdev->vendor, pdev->device,
+	     pdev->subsystem_vendor, pdev->subsystem_device);
+
+	mutex_init(&ctrl->crit_sect);
+	mutex_init(&ctrl->ctrl_lock);
+	spin_lock_init(&ctrl->lock);
+
+	/* setup wait queue */
+	init_waitqueue_head(&ctrl->queue);
+
+	/* return PCI Controller Info */
+	ctrl->slot_device_offset = 0;
+	ctrl->num_slots = 1;
+	ctrl->first_slot = slot_cap >> 19;
+	ctrl->ctrlcap = slot_cap & 0x0000007f;
+
+	rc = pcie_init_hardware(ctrl, dev);
+	if (rc == 0) {
+		ctrl->hpc_ops = &pciehp_hpc_ops;
+		return 0;
+	}
+abort:
+	return -1;
+}
