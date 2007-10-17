Return-Path: <linux-kernel-owner+w=401wt.eu-S965827AbXJQBza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965827AbXJQBza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 21:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762854AbXJQBzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 21:55:11 -0400
Received: from rtr.ca ([76.10.145.34]:3457 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762197AbXJQBzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 21:55:08 -0400
Message-ID: <47156B7B.8010800@rtr.ca>
Date: Tue, 16 Oct 2007 21:55:07 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>, pcihpd-discuss@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3/4] Fix PCIe hotplug for non-ACPI ExpressCard slots (version
 2)
References: <4714C0A6.1030204@rtr.ca> <4714D700.7060008@rtr.ca> <20071016084634.8a0d695a.kristen.c.accardi@intel.com> <47150565.5090102@rtr.ca> <20071016114328.a96e8bcb.kristen.c.accardi@intel.com> <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016214143.GC21815@kroah.com> <471533AF.60100@rtr.ca> <47156B14.2080608@rtr.ca> <47156B40.4060006@rtr.ca> <47156B62.3070807@rtr.ca>
In-Reply-To: <47156B62.3070807@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the hotplug hardware initialization code from pcie_init()
into pcie_init_enable_events(), without changing any functionality.

Signed-off-by: Mark Lord <mlord@pobox.com>
---
--- old/drivers/pci/hotplug/pciehp_hpc.c	2007-10-16 21:14:44.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_hpc.c	2007-10-16 21:21:11.000000000 -0400
@@ -1163,101 +1163,23 @@
 }
 #endif
 
-int pcie_init(struct controller *ctrl, struct pcie_device *dev)
+int pcie_init_enable_events(struct controller *ctrl, struct pcie_device *dev)
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
 
 	DBG_ENTER_ROUTINE
 
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
-	if (((cap_reg & SLOT_IMPL) == 0)
-		|| (((cap_reg & DEV_PORT_TYPE) != 0x0040)
-		&& ((cap_reg & DEV_PORT_TYPE) != 0x0060))) {
-		dbg("%s : This is not a root port"
-		" or the port is not connected to a slot\n", __FUNCTION__);
-		goto abort_free_ctlr;
-	}
-
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
-	for ( rc = 0; rc < DEVICE_COUNT_RESOURCE; rc++)
-		if (pci_resource_len(pdev, rc) > 0)
-			dbg("pci resource[%d] start=0x%llx(len=0x%llx)\n", rc,
-			    (unsigned long long)pci_resource_start(pdev, rc),
-			    (unsigned long long)pci_resource_len(pdev, rc));
-
-	info("HPC vendor_id %x device_id %x ss_vid %x"
-		" ss_did %x\n", pdev->vendor, pdev->device,
-		pdev->subsystem_vendor, pdev->subsystem_device);
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
@@ -1346,7 +1268,7 @@
 		temp_word = (temp_word & ~HP_INTR_ENABLE) | HP_INTR_ENABLE;
 	}
 
-	/* Unmask Hotplug Intr Enable for intr notification mechanism case */
+	/* Unmask hp Interrupt Enable for intr notification mechanism case */
 	rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
 	if (rc) {
 		err("%s: Cannot write to SLOTCTRL register\n", __FUNCTION__);
@@ -1374,8 +1296,6 @@
 			goto abort_disable_intr;
 	}
 
-	ctrl->hpc_ops = &pciehp_hpc_ops;
-
 	DBG_LEAVE_ROUTINE
 	return 0;
 
@@ -1399,3 +1319,111 @@
 	DBG_LEAVE_ROUTINE
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
+	DBG_ENTER_ROUTINE
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
+		goto abort_free_ctlr;
+	}
+
+	ctrl->cap_base = cap_base;
+
+	dbg("%s: pcie_cap_base %x\n", __FUNCTION__, cap_base);
+
+	rc = pciehp_readw(ctrl, CAPREG, &cap_reg);
+	if (rc) {
+		err("%s: Cannot read CAPREG register\n", __FUNCTION__);
+		goto abort_free_ctlr;
+	}
+	dbg("%s: CAPREG offset %x cap_reg %x\n",
+	    __FUNCTION__, ctrl->cap_base + CAPREG, cap_reg);
+
+	if (((cap_reg & SLOT_IMPL) == 0)
+		|| (((cap_reg & DEV_PORT_TYPE) != 0x0040)
+		&& ((cap_reg & DEV_PORT_TYPE) != 0x0060))) {
+		dbg("%s : This is not a root port"
+		    " or the port is not connected to a slot\n", __FUNCTION__);
+		goto abort_free_ctlr;
+	}
+
+	rc = pciehp_readl(ctrl, SLOTCAP, &slot_cap);
+	if (rc) {
+		err("%s: Cannot read SLOTCAP register\n", __FUNCTION__);
+		goto abort_free_ctlr;
+	}
+	dbg("%s: SLOTCAP offset %x slot_cap %x\n",
+	    __FUNCTION__, ctrl->cap_base + SLOTCAP, slot_cap);
+
+	if (!(slot_cap & HP_CAP)) {
+		dbg("%s : This slot is not hot-plug capable\n", __FUNCTION__);
+		goto abort_free_ctlr;
+	}
+	/* For debugging purpose */
+	rc = pciehp_readw(ctrl, SLOTSTATUS, &slot_status);
+	if (rc) {
+		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
+		goto abort_free_ctlr;
+	}
+	dbg("%s: SLOTSTATUS offset %x slot_status %x\n",
+	    __FUNCTION__, ctrl->cap_base + SLOTSTATUS, slot_status);
+
+	rc = pciehp_readw(ctrl, SLOTCTRL, &slot_ctrl);
+	if (rc) {
+		err("%s: Cannot read SLOTCTRL register\n", __FUNCTION__);
+		goto abort_free_ctlr;
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
+	info("HPC vendor_id %x device_id %x ss_vid %x"
+		" ss_did %x\n", pdev->vendor, pdev->device,
+		pdev->subsystem_vendor, pdev->subsystem_device);
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
+	rc = pcie_init_enable_events(ctrl, dev);
+	if (rc)
+		goto abort_free_ctlr;;
+
+	ctrl->hpc_ops = &pciehp_hpc_ops;
+
+	DBG_LEAVE_ROUTINE
+	return 0;
+abort_free_ctlr:
+	DBG_LEAVE_ROUTINE
+	return -1;
+}
