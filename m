Return-Path: <linux-kernel-owner+w=401wt.eu-S936033AbXJPV5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936033AbXJPV5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935082AbXJPV5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:57:10 -0400
Received: from rtr.ca ([76.10.145.34]:3178 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934009AbXJPV5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:57:09 -0400
Message-ID: <471533AF.60100@rtr.ca>
Date: Tue, 16 Oct 2007 17:57:03 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       pcihpd-discuss@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix PCIe hotplug for Dell notebook ExpressCard slots
References: <4714C0A6.1030204@rtr.ca> <4714D700.7060008@rtr.ca> <20071016084634.8a0d695a.kristen.c.accardi@intel.com> <47150565.5090102@rtr.ca> <20071016114328.a96e8bcb.kristen.c.accardi@intel.com> <47150982.6050102@rtr.ca> <471509FE.7080505@rtr.ca> <47151191.40406@rtr.ca> <20071016130757.ed2f2ce4.kristen.c.accardi@intel.com> <4715217D.2000803@rtr.ca> <20071016214143.GC21815@kroah.com>
In-Reply-To: <20071016214143.GC21815@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks
in conjunction with modparam of pciehp_force=1.

The PCIe Hotplug driver has two shortcomings when used on Dell notebooks
which lack ACPI BIOS support for PCIe hotplug:

1. The driver does not recognise cards that were inserted prior
to the driver being modprobe'd.

2. The driver stops functioning after a suspend/resume (RAM) cycle,
and needs to be rmmod'd and modprobe'd to get it working again.

This patch addresses both issues.

Issue 1 is fixed by modifying pciehp_probe() to either enable or disable
the slot based on whether or not a card is detected at module init time.

Issue 2 is fixed by implementing pciehp_resume() to do the same
after having it first reinitialize the slot event registers.

The code to reinitialize those registers has been broken away from
pcie_init() so that it can be shared with pciehp_resume().

I'm not certain that locking contraints are correct in pciehp_resume(),
so it would be quite useful for the PCIe hotplug folks to look this all
over and provide suggestions/fixes as needed.

There are also a few minor cosmetic changes to satisfy checkpatch.pl.

 pciehp.h      |    3
 pciehp_core.c |   31 ++++++--
 pciehp_ctrl.c |    4 -
 pciehp_hpc.c  |  207 +++++++++++++++++++++++++++++++++-------------------------
 4 files changed, 144 insertions(+), 101 deletions(-)

Signed-off-by: Mark Lord <mlord@pobox.com>
---

--- old/drivers/pci/hotplug/pciehp.h	2007-10-12 12:43:44.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp.h	2007-10-16 17:53:48.000000000 -0400
@@ -161,6 +161,9 @@
 extern int pciehp_unconfigure_device(struct slot *p_slot);
 extern void pciehp_queue_pushbutton_work(struct work_struct *work);
 int pcie_init(struct controller *ctrl, struct pcie_device *dev);
+int pciehp_enable_slot(struct slot *p_slot);
+int pciehp_disable_slot(struct slot *p_slot);
+int pcie_init_enable_events(struct controller *ctrl, struct pcie_device *dev);
 
 static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
 {
--- old/drivers/pci/hotplug/pciehp_core.c	2007-10-12 12:43:44.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_core.c	2007-10-16 17:48:24.000000000 -0400
@@ -470,17 +470,14 @@
 
 	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
 
-	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
-	if ((POWER_CTRL(ctrl->ctrlcap)) && !value) {
-		rc = t_slot->hpc_ops->power_off_slot(t_slot); /* Power off slot if not occupied*/
-		if (rc)
-			goto err_out_free_ctrl_slot;
-	}
-
+	/* Check if slot is occupied */
+	t_slot->hpc_ops->get_adapter_status(t_slot, &value);
+	if (value)
+		pciehp_enable_slot(t_slot);
+	else
+		pciehp_disable_slot(t_slot);
 	return 0;
 
-err_out_free_ctrl_slot:
-	cleanup_slots(ctrl);
 err_out_release_ctlr:
 	ctrl->hpc_ops->release_ctlr(ctrl);
 err_out_free_ctrl:
@@ -508,7 +505,23 @@
 
 static int pciehp_resume (struct pcie_device *dev)
 {
+	struct pci_dev *pdev = dev->port;
+	struct controller *ctrl = pci_get_drvdata(pdev);
+	struct slot *t_slot;
+	u8 status;
+
 	printk("%s ENTRY\n", __FUNCTION__);	
+
+	pcie_init_enable_events(ctrl, dev);
+
+	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
+
+	/* Check if slot is occupied */
+	t_slot->hpc_ops->get_adapter_status(t_slot, &status);
+	if (status)
+		pciehp_enable_slot(t_slot);
+	else
+		pciehp_disable_slot(t_slot);
 	return 0;
 }
 #endif
--- old/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-12 12:43:44.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_ctrl.c	2007-10-16 16:53:35.000000000 -0400
@@ -37,8 +37,6 @@
 #include "pciehp.h"
 
 static void interrupt_event_handler(struct work_struct *work);
-static int pciehp_enable_slot(struct slot *p_slot);
-static int pciehp_disable_slot(struct slot *p_slot);
 
 static int queue_interrupt_event(struct slot *p_slot, u32 event_type)
 {
@@ -520,7 +518,7 @@
 	case INT_PRESENCE_OFF:
 		if (!HP_SUPR_RM(ctrl->ctrlcap))
 			break;
-		dbg("Surprise Removal\n");
+		dbg("Surprise Event\n");
 		update_slot_info(p_slot);
 		handle_surprise_event(p_slot);
 		break;
--- old/drivers/pci/hotplug/pciehp_hpc.c	2007-10-12 12:43:44.000000000 -0400
+++ linux/drivers/pci/hotplug/pciehp_hpc.c	2007-10-16 17:53:27.000000000 -0400
@@ -1163,100 +1163,23 @@
 }
 #endif
 
-
-
-int pcie_init(struct controller * ctrl, struct pcie_device *dev)
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
-	
-	pdev = dev->port;
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
-	if (((cap_reg & SLOT_IMPL) == 0) || (((cap_reg & DEV_PORT_TYPE) != 0x0040)
-		&& ((cap_reg & DEV_PORT_TYPE) != 0x0060))) {
-		dbg("%s : This is not a root port or the port is not connected to a slot\n", __FUNCTION__);
-		goto abort_free_ctlr;
-	}
 
+	pdev = dev->port;
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
-	info("HPC vendor_id %x device_id %x ss_vid %x ss_did %x\n", pdev->vendor, pdev->device, 
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
@@ -1267,7 +1190,7 @@
 
 	dbg("%s: SLOTCTRL %x value read %x\n",
 	    __FUNCTION__, ctrl->cap_base + SLOTCTRL, temp_word);
-	temp_word = (temp_word & ~HP_INTR_ENABLE & ~CMD_CMPL_INTR_ENABLE) | 0x00;
+	temp_word = (temp_word & ~HP_INTR_ENABLE & ~CMD_CMPL_INTR_ENABLE)|0x00;
 
 	rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
 	if (rc) {
@@ -1330,14 +1253,14 @@
 
 	if (ATTN_BUTTN(slot_cap))
 		intr_enable = intr_enable | ATTN_BUTTN_ENABLE;
-	
+
 	if (POWER_CTRL(slot_cap))
 		intr_enable = intr_enable | PWR_FAULT_DETECT_ENABLE;
-	
+
 	if (MRL_SENS(slot_cap))
 		intr_enable = intr_enable | MRL_DETECT_ENABLE;
 
-	temp_word = (temp_word & ~intr_enable) | intr_enable; 
+	temp_word = (temp_word & ~intr_enable) | intr_enable;
 
 	if (pciehp_poll_mode) {
 		temp_word = (temp_word & ~HP_INTR_ENABLE) | 0x0;
@@ -1345,7 +1268,7 @@
 		temp_word = (temp_word & ~HP_INTR_ENABLE) | HP_INTR_ENABLE;
 	}
 
-	/* Unmask Hot-plug Interrupt Enable for the interrupt notification mechanism case */
+	/* Unmask hp Interrupt Enable for intr notification mechanism case */
 	rc = pciehp_writew(ctrl, SLOTCTRL, temp_word);
 	if (rc) {
 		err("%s: Cannot write to SLOTCTRL register\n", __FUNCTION__);
@@ -1356,14 +1279,14 @@
 		err("%s: Cannot read SLOTSTATUS register\n", __FUNCTION__);
 		goto abort_disable_intr;
 	}
-	
+
 	temp_word =  0x1F; /* Clear all events */
 	rc = pciehp_writew(ctrl, SLOTSTATUS, temp_word);
 	if (rc) {
 		err("%s: Cannot write to SLOTSTATUS register\n", __FUNCTION__);
 		goto abort_disable_intr;
 	}
-	
+
 	if (pciehp_force) {
 		dbg("Bypassing BIOS check for pciehp use on %s\n",
 				pci_name(ctrl->pci_dev));
@@ -1373,8 +1296,6 @@
 			goto abort_disable_intr;
 	}
 
-	ctrl->hpc_ops = &pciehp_hpc_ops;
-
 	DBG_LEAVE_ROUTINE
 	return 0;
 
@@ -1398,3 +1319,111 @@
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
