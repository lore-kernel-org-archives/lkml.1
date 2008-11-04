Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbYKDOdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbYKDOdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYKDOdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:33:38 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:51498 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbYKDOdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:33:38 -0500
Date: Tue, 4 Nov 2008 14:33:32 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Add option to passively listen for PCIE hotplug events
Message-ID: <20081104143332.GA21689@srcf.ucam.org>
References: <bspwK-420-11@gated-at.bofh.it> <bujnh-2fr-5@gated-at.bofh.it> <bujwT-2Ew-5@gated-at.bofh.it> <buml1-6du-3@gated-at.bofh.it> <d51a1b7b-32db-41dd-a36d-911ed62f5cb4@l33g2000pri.googlegroups.com> <20081104124706.GB19401@srcf.ucam.org> <20081104133214.GA20427@srcf.ucam.org> <49105BA6.9090403@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49105BA6.9090403@tuffmail.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ah, one more spot. How about this one?

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index b2801a7..c9f18f9 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -224,6 +224,10 @@ static inline int pciehp_get_hp_hw_control_from_firmware(struct pci_dev *dev)
 {
 	u32 flags = (OSC_PCI_EXPRESS_NATIVE_HP_CONTROL |
 		     OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL);
+	if (pciehp_force) {
+		dev_info(&dev->dev, "Bypassing BIOS check for pciehp\n");
+		return 0;
+	}
 	return acpi_get_hp_hw_control_from_firmware(dev, flags);
 }
 
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 4b23bc3..429e505 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -41,6 +41,7 @@ int pciehp_debug;
 int pciehp_poll_mode;
 int pciehp_poll_time;
 int pciehp_force;
+int pciehp_passive=1;
 struct workqueue_struct *pciehp_wq;
 
 #define DRIVER_VERSION	"0.4"
@@ -50,15 +51,18 @@ struct workqueue_struct *pciehp_wq;
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("acpi*:PNP0A08:*");
 
 module_param(pciehp_debug, bool, 0644);
 module_param(pciehp_poll_mode, bool, 0644);
 module_param(pciehp_poll_time, int, 0644);
 module_param(pciehp_force, bool, 0644);
+module_param(pciehp_passive, bool, 0644);
 MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
 MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
 MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
 MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if _OSC and OSHP are missing");
+MODULE_PARM_DESC(pciehp_passive, "Listen for pciehp events, even if _OSC and OSHP are missing");
 
 #define PCIE_MODULE_NAME "pciehp"
 
@@ -85,6 +89,13 @@ static struct hotplug_slot_ops pciehp_hotplug_slot_ops = {
   	.get_cur_bus_speed =	get_cur_bus_speed,
 };
 
+static struct hotplug_slot_ops pciehp_passive_hotplug_slot_ops = {
+	.owner =		THIS_MODULE,
+	.get_adapter_status =	get_adapter_status,
+  	.get_max_bus_speed =	get_max_bus_speed,
+  	.get_cur_bus_speed =	get_cur_bus_speed,
+};
+
 /*
  * Check the status of the Electro Mechanical Interlock (EMI)
  */
@@ -212,7 +223,11 @@ static int init_slots(struct controller *ctrl)
 		hotplug_slot->info = info;
 		hotplug_slot->private = slot;
 		hotplug_slot->release = &release_slot;
-		hotplug_slot->ops = &pciehp_hotplug_slot_ops;
+		if (pciehp_passive &&
+		    pciehp_get_hp_hw_control_from_firmware(ctrl->pci_dev))
+			hotplug_slot->ops = &pciehp_passive_hotplug_slot_ops;
+		else
+			hotplug_slot->ops = &pciehp_hotplug_slot_ops;
 		slot->hotplug_slot = hotplug_slot;
 		snprintf(name, SLOT_NAME_SIZE, "%u", slot->number);
 
@@ -407,11 +422,7 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
 	u8 value;
 	struct pci_dev *pdev = dev->port;
 
-	if (pciehp_force)
-		dev_info(&dev->device,
-			 "Bypassing BIOS check for pciehp use on %s\n",
-			 pci_name(pdev));
-	else if (pciehp_get_hp_hw_control_from_firmware(pdev))
+	if (!pciehp_passive && pciehp_get_hp_hw_control_from_firmware(pdev))
 		goto err_out_none;
 
 	ctrl = pcie_init(dev);
@@ -435,11 +446,9 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
 	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
 
 	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
-	if (value && pciehp_force) {
-		rc = pciehp_enable_slot(t_slot);
-		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
-			value = 0;
-	}
+	if (value && (pciehp_force || pciehp_passive))
+		pciehp_enable_slot(t_slot);
+
 	if ((POWER_CTRL(ctrl)) && !value) {
 		rc = t_slot->hpc_ops->power_off_slot(t_slot); /* Power off slot if not occupied*/
 		if (rc)
@@ -473,8 +482,11 @@ static int pciehp_suspend (struct pcie_device *dev, pm_message_t state)
 
 static int pciehp_resume (struct pcie_device *dev)
 {
+	struct pci_dev *pdev = dev->port;
 	dev_info(&dev->device, "%s ENTRY\n", __func__);
-	if (pciehp_force) {
+
+	if (pciehp_force || (pciehp_passive &&
+			     pciehp_get_hp_hw_control_from_firmware(pdev))) {
 		struct controller *ctrl = get_service_data(dev);
 		struct slot *t_slot;
 		u8 status;
diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index fead63c..9aee98f 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -185,7 +185,8 @@ static void set_slot_off(struct controller *ctrl, struct slot * pslot)
 	 * before taking any action that relies on power having been
 	 * removed from the slot/adapter.
 	 */
-	msleep(1000);
+	if (PWR_LED(ctrl) || ATTN_LED(ctrl))
+		msleep(1000);
 
 	if (PWR_LED(ctrl))
 		pslot->hpc_ops->green_led_off(pslot);
@@ -288,17 +289,16 @@ static int remove_board(struct slot *p_slot)
 		}
 	}
 
-	/*
-	 * After turning power off, we must wait for at least 1 second
-	 * before taking any action that relies on power having been
-	 * removed from the slot/adapter.
-	 */
-	msleep(1000);
-
-	if (PWR_LED(ctrl))
+	if (PWR_LED(ctrl)) {
+		/*
+		 * After turning power off, we must wait for at least 1 second
+		 * before taking any action that relies on power having been
+		 * removed from the slot/adapter.
+		 */
+		msleep(1000);
 		/* turn off Green LED */
 		p_slot->hpc_ops->green_led_off(p_slot);
-
+	}
 	return 0;
 }
 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
