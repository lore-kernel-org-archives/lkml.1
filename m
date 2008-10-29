Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbYJ2UJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbYJ2UJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYJ2UJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:09:12 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58260 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbYJ2UJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:09:10 -0400
Date: Wed, 29 Oct 2008 20:09:03 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-pci@vger.kernel.org
Cc: kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Add option to passively listen for PCIE hotplug events
Message-ID: <20081029200903.GA1678@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various pieces of hardware (such as the Acer Aspire One and Asus EEE) 
use PCIE hotplug to change the state of devices in response to events 
such as the removal of SD cards or disabling the wireless radio. 
However, they do not provide firmware support for this. As a consequence 
pciehp will refuse to load and various things break.

The existing workaround has been to use the pciehp_force option. This is 
undesirable as there is little guarantee that manipulating the power 
file in the slot directory will actually result in anything happening, 
leading to potential user confusion and hardware damage. This patch adds 
a new option, pciehp_passive. In this configuration pciehp will listen 
for events and notify the PCI core appropriately. However, it will not 
provide any user controllable sysfs attributes and so the risk of 
confusion or damage is averted. Any system slots that do have firmware 
support will continue to provide full functionality.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 4b23bc3..b878432 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -41,6 +41,7 @@ int pciehp_debug;
 int pciehp_poll_mode;
 int pciehp_poll_time;
 int pciehp_force;
+int pciehp_passive;
 struct workqueue_struct *pciehp_wq;
 
 #define DRIVER_VERSION	"0.4"
@@ -55,10 +56,12 @@ module_param(pciehp_debug, bool, 0644);
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
 
@@ -85,6 +88,13 @@ static struct hotplug_slot_ops pciehp_hotplug_slot_ops = {
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
@@ -212,7 +222,11 @@ static int init_slots(struct controller *ctrl)
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
 
@@ -407,7 +421,7 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
 	u8 value;
 	struct pci_dev *pdev = dev->port;
 
-	if (pciehp_force)
+	if (pciehp_force || pciehp_passive)
 		dev_info(&dev->device,
 			 "Bypassing BIOS check for pciehp use on %s\n",
 			 pci_name(pdev));
@@ -435,7 +449,7 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
 	t_slot = pciehp_find_slot(ctrl, ctrl->slot_device_offset);
 
 	t_slot->hpc_ops->get_adapter_status(t_slot, &value); /* Check if slot is occupied */
-	if (value && pciehp_force) {
+	if (value && (pciehp_force || pciehp_passive)) {
 		rc = pciehp_enable_slot(t_slot);
 		if (rc)	/* -ENODEV: shouldn't happen, but deal with it */
 			value = 0;
@@ -474,7 +488,7 @@ static int pciehp_suspend (struct pcie_device *dev, pm_message_t state)
 static int pciehp_resume (struct pcie_device *dev)
 {
 	dev_info(&dev->device, "%s ENTRY\n", __func__);
-	if (pciehp_force) {
+	if (pciehp_force || pciehp_passive) {
 		struct controller *ctrl = get_service_data(dev);
 		struct slot *t_slot;
 		u8 status;

-- 
Matthew Garrett | mjg59@srcf.ucam.org
