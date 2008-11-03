Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbYKCN0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbYKCN0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbYKCN0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:26:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41204 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbYKCN0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:26:11 -0500
Date: Mon, 3 Nov 2008 13:26:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-pci@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] Add option to passively listen for PCIE hotplug events
Message-ID: <20081103132606.GA30537@srcf.ucam.org>
References: <20081029200903.GA1678@srcf.ucam.org> <20081101175152.GG13302@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081101175152.GG13302@colo.lackof.org>
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

Includes a minor code change suggested by Matthew Wilcox to avoid 
calling pciehp_get_hp_hw_control_from_firmware() twice and documentation 
updates as suggested Grant Grundler.

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1bbcaa8..2503ee0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1711,6 +1711,20 @@ and is between 256 and 4096 characters. It is defined in the file
 		force	Enable ASPM even on devices that claim not to support it.
 			WARNING: Forcing ASPM on may cause system lockups.
 
+	pciehp.pciehp_force= [PCIE] Forcibly enable PCIE hotplug support on a 
+			     slot even if the firmware provides no support for
+			     it.
+
+	pciehp.pciehp_passive= [PCIE] Forcibly enable listening for PCIE 
+			       hotplug events on a slot even if the firmware
+			       provides no support for it. Unlike pciehp.force,
+			       does not provide user interface for triggering
+			       hotplug events.
+
+	pciehp.pciehp_poll_mode= [PCIE] Poll for PCIE hotplug events
+
+	pciehp.pciehp_poll_time= [PCIE] Seconds to wait between polls
+
 	pcmv=		[HW,PCMCIA] BadgePAD 4
 
 	pd.		[PARIDE]
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
index 4b23bc3..2bb2f4b 100644
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
 
@@ -407,11 +421,7 @@ static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_
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
@@ -474,7 +484,7 @@ static int pciehp_suspend (struct pcie_device *dev, pm_message_t state)
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
