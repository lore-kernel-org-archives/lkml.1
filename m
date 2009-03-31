Return-Path: <linux-kernel-owner+w=401wt.eu-S1762572AbZCaPYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762572AbZCaPYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762225AbZCaPXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:23:30 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:42674 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762110AbZCaPX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:23:28 -0400
Subject: [PATCH 04/15] PCI Hotplug: cpqphp: remove useless prototypes in
	cpqphp_core.c
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:23:26 -0600
Message-ID: <20090331152326.26622.32020.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: refactor

Refactor code to follow convention more closely and eliminate the need
for some useless prototypes.

No functional change.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp_core.c |  461 ++++++++++++++++++-------------------
 1 files changed, 224 insertions(+), 237 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index 91dc958..f05ea7a 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -77,33 +77,6 @@ MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
 
 #define CPQHPC_MODULE_MINOR 208
 
-static int one_time_init	(void);
-static int set_attention_status	(struct hotplug_slot *slot, u8 value);
-static int process_SI		(struct hotplug_slot *slot);
-static int process_SS		(struct hotplug_slot *slot);
-static int hardware_test	(struct hotplug_slot *slot, u32 value);
-static int get_power_status	(struct hotplug_slot *slot, u8 *value);
-static int get_attention_status	(struct hotplug_slot *slot, u8 *value);
-static int get_latch_status	(struct hotplug_slot *slot, u8 *value);
-static int get_adapter_status	(struct hotplug_slot *slot, u8 *value);
-static int get_max_bus_speed	(struct hotplug_slot *slot, enum pci_bus_speed *value);
-static int get_cur_bus_speed	(struct hotplug_slot *slot, enum pci_bus_speed *value);
-
-static struct hotplug_slot_ops cpqphp_hotplug_slot_ops = {
-	.owner =		THIS_MODULE,
-	.set_attention_status =	set_attention_status,
-	.enable_slot =		process_SI,
-	.disable_slot =		process_SS,
-	.hardware_test =	hardware_test,
-	.get_power_status =	get_power_status,
-	.get_attention_status =	get_attention_status,
-	.get_latch_status =	get_latch_status,
-	.get_adapter_status =	get_adapter_status,
-	.get_max_bus_speed =	get_max_bus_speed,
-	.get_cur_bus_speed =	get_cur_bus_speed,
-};
-
-
 static inline int is_slot64bit(struct slot *slot)
 {
 	return (readb(slot->p_sm_slot + SMBIOS_SLOT_WIDTH) == 0x06) ? 1 : 0;
@@ -322,145 +295,6 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 	kfree(slot);
 }
 
-#define SLOT_NAME_SIZE 10
-
-static int ctrl_slot_setup(struct controller *ctrl,
-			void __iomem *smbios_start,
-			void __iomem *smbios_table)
-{
-	struct slot *slot;
-	struct hotplug_slot *hotplug_slot;
-	struct hotplug_slot_info *hotplug_slot_info;
-	u8 number_of_slots;
-	u8 slot_device;
-	u8 slot_number;
-	u8 ctrl_slot;
-	u32 tempdword;
-	char name[SLOT_NAME_SIZE];
-	void __iomem *slot_entry= NULL;
-	int result = -ENOMEM;
-
-	dbg("%s\n", __func__);
-
-	tempdword = readl(ctrl->hpc_reg + INT_INPUT_CLEAR);
-
-	number_of_slots = readb(ctrl->hpc_reg + SLOT_MASK) & 0x0F;
-	slot_device = readb(ctrl->hpc_reg + SLOT_MASK) >> 4;
-	slot_number = ctrl->first_slot;
-
-	while (number_of_slots) {
-		slot = kzalloc(sizeof(*slot), GFP_KERNEL);
-		if (!slot)
-			goto error;
-
-		slot->hotplug_slot = kzalloc(sizeof(*(slot->hotplug_slot)),
-						GFP_KERNEL);
-		if (!slot->hotplug_slot)
-			goto error_slot;
-		hotplug_slot = slot->hotplug_slot;
-
-		hotplug_slot->info =
-				kzalloc(sizeof(*(hotplug_slot->info)),
-							GFP_KERNEL);
-		if (!hotplug_slot->info)
-			goto error_hpslot;
-		hotplug_slot_info = hotplug_slot->info;
-
-		slot->ctrl = ctrl;
-		slot->bus = ctrl->bus;
-		slot->device = slot_device;
-		slot->number = slot_number;
-		dbg("slot->number = %u\n", slot->number);
-
-		slot_entry = get_SMBIOS_entry(smbios_start, smbios_table, 9,
-					slot_entry);
-
-		while (slot_entry && (readw(slot_entry + SMBIOS_SLOT_NUMBER) !=
-				slot->number)) {
-			slot_entry = get_SMBIOS_entry(smbios_start,
-						smbios_table, 9, slot_entry);
-		}
-
-		slot->p_sm_slot = slot_entry;
-
-		init_timer(&slot->task_event);
-		slot->task_event.expires = jiffies + 5 * HZ;
-		slot->task_event.function = cpqhp_pushbutton_thread;
-
-		/*FIXME: these capabilities aren't used but if they are
-		 *	 they need to be correctly implemented
-		 */
-		slot->capabilities |= PCISLOT_REPLACE_SUPPORTED;
-		slot->capabilities |= PCISLOT_INTERLOCK_SUPPORTED;
-
-		if (is_slot64bit(slot))
-			slot->capabilities |= PCISLOT_64_BIT_SUPPORTED;
-		if (is_slot66mhz(slot))
-			slot->capabilities |= PCISLOT_66_MHZ_SUPPORTED;
-		if (ctrl->speed == PCI_SPEED_66MHz)
-			slot->capabilities |= PCISLOT_66_MHZ_OPERATION;
-
-		ctrl_slot =
-			slot_device - (readb(ctrl->hpc_reg + SLOT_MASK) >> 4);
-
-		/* Check presence */
-		slot->capabilities |=
-			((((~tempdword) >> 23) |
-			 ((~tempdword) >> 15)) >> ctrl_slot) & 0x02;
-		/* Check the switch state */
-		slot->capabilities |=
-			((~tempdword & 0xFF) >> ctrl_slot) & 0x01;
-		/* Check the slot enable */
-		slot->capabilities |=
-			((read_slot_enable(ctrl) << 2) >> ctrl_slot) & 0x04;
-
-		/* register this slot with the hotplug pci core */
-		hotplug_slot->release = &release_slot;
-		hotplug_slot->private = slot;
-		snprintf(name, SLOT_NAME_SIZE, "%u", slot->number);
-		hotplug_slot->ops = &cpqphp_hotplug_slot_ops;
-
-		hotplug_slot_info->power_status = get_slot_enabled(ctrl, slot);
-		hotplug_slot_info->attention_status =
-			cpq_get_attention_status(ctrl, slot);
-		hotplug_slot_info->latch_status =
-			cpq_get_latch_status(ctrl, slot);
-		hotplug_slot_info->adapter_status =
-			get_presence_status(ctrl, slot);
-
-		dbg("registering bus %d, dev %d, number %d, "
-				"ctrl->slot_device_offset %d, slot %d\n",
-				slot->bus, slot->device,
-				slot->number, ctrl->slot_device_offset,
-				slot_number);
-		result = pci_hp_register(hotplug_slot,
-					 ctrl->pci_dev->bus,
-					 slot->device,
-					 name);
-		if (result) {
-			err("pci_hp_register failed with error %d\n", result);
-			goto error_info;
-		}
-
-		slot->next = ctrl->slot;
-		ctrl->slot = slot;
-
-		number_of_slots--;
-		slot_device++;
-		slot_number++;
-	}
-
-	return 0;
-error_info:
-	kfree(hotplug_slot_info);
-error_hpslot:
-	kfree(hotplug_slot);
-error_slot:
-	kfree(slot);
-error:
-	return result;
-}
-
 static int ctrl_slot_cleanup (struct controller * ctrl)
 {
 	struct slot *old_slot, *next_slot;
@@ -793,6 +627,230 @@ static int get_cur_bus_speed (struct hotplug_slot *hotplug_slot, enum pci_bus_sp
 	return 0;
 }
 
+static struct hotplug_slot_ops cpqphp_hotplug_slot_ops = {
+	.owner =		THIS_MODULE,
+	.set_attention_status =	set_attention_status,
+	.enable_slot =		process_SI,
+	.disable_slot =		process_SS,
+	.hardware_test =	hardware_test,
+	.get_power_status =	get_power_status,
+	.get_attention_status =	get_attention_status,
+	.get_latch_status =	get_latch_status,
+	.get_adapter_status =	get_adapter_status,
+	.get_max_bus_speed =	get_max_bus_speed,
+	.get_cur_bus_speed =	get_cur_bus_speed,
+};
+
+#define SLOT_NAME_SIZE 10
+
+static int ctrl_slot_setup(struct controller *ctrl,
+			void __iomem *smbios_start,
+			void __iomem *smbios_table)
+{
+	struct slot *slot;
+	struct hotplug_slot *hotplug_slot;
+	struct hotplug_slot_info *hotplug_slot_info;
+	u8 number_of_slots;
+	u8 slot_device;
+	u8 slot_number;
+	u8 ctrl_slot;
+	u32 tempdword;
+	char name[SLOT_NAME_SIZE];
+	void __iomem *slot_entry= NULL;
+	int result = -ENOMEM;
+
+	dbg("%s\n", __func__);
+
+	tempdword = readl(ctrl->hpc_reg + INT_INPUT_CLEAR);
+
+	number_of_slots = readb(ctrl->hpc_reg + SLOT_MASK) & 0x0F;
+	slot_device = readb(ctrl->hpc_reg + SLOT_MASK) >> 4;
+	slot_number = ctrl->first_slot;
+
+	while (number_of_slots) {
+		slot = kzalloc(sizeof(*slot), GFP_KERNEL);
+		if (!slot)
+			goto error;
+
+		slot->hotplug_slot = kzalloc(sizeof(*(slot->hotplug_slot)),
+						GFP_KERNEL);
+		if (!slot->hotplug_slot)
+			goto error_slot;
+		hotplug_slot = slot->hotplug_slot;
+
+		hotplug_slot->info =
+				kzalloc(sizeof(*(hotplug_slot->info)),
+							GFP_KERNEL);
+		if (!hotplug_slot->info)
+			goto error_hpslot;
+		hotplug_slot_info = hotplug_slot->info;
+
+		slot->ctrl = ctrl;
+		slot->bus = ctrl->bus;
+		slot->device = slot_device;
+		slot->number = slot_number;
+		dbg("slot->number = %u\n", slot->number);
+
+		slot_entry = get_SMBIOS_entry(smbios_start, smbios_table, 9,
+					slot_entry);
+
+		while (slot_entry && (readw(slot_entry + SMBIOS_SLOT_NUMBER) !=
+				slot->number)) {
+			slot_entry = get_SMBIOS_entry(smbios_start,
+						smbios_table, 9, slot_entry);
+		}
+
+		slot->p_sm_slot = slot_entry;
+
+		init_timer(&slot->task_event);
+		slot->task_event.expires = jiffies + 5 * HZ;
+		slot->task_event.function = cpqhp_pushbutton_thread;
+
+		/*FIXME: these capabilities aren't used but if they are
+		 *	 they need to be correctly implemented
+		 */
+		slot->capabilities |= PCISLOT_REPLACE_SUPPORTED;
+		slot->capabilities |= PCISLOT_INTERLOCK_SUPPORTED;
+
+		if (is_slot64bit(slot))
+			slot->capabilities |= PCISLOT_64_BIT_SUPPORTED;
+		if (is_slot66mhz(slot))
+			slot->capabilities |= PCISLOT_66_MHZ_SUPPORTED;
+		if (ctrl->speed == PCI_SPEED_66MHz)
+			slot->capabilities |= PCISLOT_66_MHZ_OPERATION;
+
+		ctrl_slot =
+			slot_device - (readb(ctrl->hpc_reg + SLOT_MASK) >> 4);
+
+		/* Check presence */
+		slot->capabilities |=
+			((((~tempdword) >> 23) |
+			 ((~tempdword) >> 15)) >> ctrl_slot) & 0x02;
+		/* Check the switch state */
+		slot->capabilities |=
+			((~tempdword & 0xFF) >> ctrl_slot) & 0x01;
+		/* Check the slot enable */
+		slot->capabilities |=
+			((read_slot_enable(ctrl) << 2) >> ctrl_slot) & 0x04;
+
+		/* register this slot with the hotplug pci core */
+		hotplug_slot->release = &release_slot;
+		hotplug_slot->private = slot;
+		snprintf(name, SLOT_NAME_SIZE, "%u", slot->number);
+		hotplug_slot->ops = &cpqphp_hotplug_slot_ops;
+
+		hotplug_slot_info->power_status = get_slot_enabled(ctrl, slot);
+		hotplug_slot_info->attention_status =
+			cpq_get_attention_status(ctrl, slot);
+		hotplug_slot_info->latch_status =
+			cpq_get_latch_status(ctrl, slot);
+		hotplug_slot_info->adapter_status =
+			get_presence_status(ctrl, slot);
+
+		dbg("registering bus %d, dev %d, number %d, "
+				"ctrl->slot_device_offset %d, slot %d\n",
+				slot->bus, slot->device,
+				slot->number, ctrl->slot_device_offset,
+				slot_number);
+		result = pci_hp_register(hotplug_slot,
+					 ctrl->pci_dev->bus,
+					 slot->device,
+					 name);
+		if (result) {
+			err("pci_hp_register failed with error %d\n", result);
+			goto error_info;
+		}
+
+		slot->next = ctrl->slot;
+		ctrl->slot = slot;
+
+		number_of_slots--;
+		slot_device++;
+		slot_number++;
+	}
+
+	return 0;
+error_info:
+	kfree(hotplug_slot_info);
+error_hpslot:
+	kfree(hotplug_slot);
+error_slot:
+	kfree(slot);
+error:
+	return result;
+}
+
+static int one_time_init(void)
+{
+	int loop;
+	int retval = 0;
+
+	if (initialized)
+		return 0;
+
+	power_mode = 0;
+
+	retval = pci_print_IRQ_route();
+	if (retval)
+		goto error;
+
+	dbg("Initialize + Start the notification mechanism \n");
+
+	retval = cpqhp_event_start_thread();
+	if (retval)
+		goto error;
+
+	dbg("Initialize slot lists\n");
+	for (loop = 0; loop < 256; loop++) {
+		cpqhp_slot_list[loop] = NULL;
+	}
+
+	/* FIXME: We also need to hook the NMI handler eventually.
+	 * this also needs to be worked with Christoph
+	 * register_NMI_handler();
+	 */
+	/* Map rom address */
+	cpqhp_rom_start = ioremap(ROM_PHY_ADDR, ROM_PHY_LEN);
+	if (!cpqhp_rom_start) {
+		err ("Could not ioremap memory region for ROM\n");
+		retval = -EIO;
+		goto error;
+	}
+
+	/* Now, map the int15 entry point if we are on compaq specific
+	 * hardware
+	 */
+	compaq_nvram_init(cpqhp_rom_start);
+
+	/* Map smbios table entry point structure */
+	smbios_table = detect_SMBIOS_pointer(cpqhp_rom_start,
+					cpqhp_rom_start + ROM_PHY_LEN);
+	if (!smbios_table) {
+		err ("Could not find the SMBIOS pointer in memory\n");
+		retval = -EIO;
+		goto error_rom_start;
+	}
+
+	smbios_start = ioremap(readl(smbios_table + ST_ADDRESS),
+					readw(smbios_table + ST_LENGTH));
+	if (!smbios_start) {
+		err ("Could not ioremap memory region taken from SMBIOS values\n");
+		retval = -EIO;
+		goto error_smbios_start;
+	}
+
+	initialized = 1;
+
+	return retval;
+
+error_smbios_start:
+	iounmap(smbios_start);
+error_rom_start:
+	iounmap(cpqhp_rom_start);
+error:
+	return retval;
+}
+
 static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	u8 num_of_slots = 0;
@@ -1300,77 +1358,6 @@ err_disable_device:
 	return rc;
 }
 
-static int one_time_init(void)
-{
-	int loop;
-	int retval = 0;
-
-	if (initialized)
-		return 0;
-
-	power_mode = 0;
-
-	retval = pci_print_IRQ_route();
-	if (retval)
-		goto error;
-
-	dbg("Initialize + Start the notification mechanism \n");
-
-	retval = cpqhp_event_start_thread();
-	if (retval)
-		goto error;
-
-	dbg("Initialize slot lists\n");
-	for (loop = 0; loop < 256; loop++) {
-		cpqhp_slot_list[loop] = NULL;
-	}
-
-	/* FIXME: We also need to hook the NMI handler eventually.
-	 * this also needs to be worked with Christoph
-	 * register_NMI_handler();
-	 */
-	/* Map rom address */
-	cpqhp_rom_start = ioremap(ROM_PHY_ADDR, ROM_PHY_LEN);
-	if (!cpqhp_rom_start) {
-		err ("Could not ioremap memory region for ROM\n");
-		retval = -EIO;
-		goto error;
-	}
-
-	/* Now, map the int15 entry point if we are on compaq specific
-	 * hardware
-	 */
-	compaq_nvram_init(cpqhp_rom_start);
-
-	/* Map smbios table entry point structure */
-	smbios_table = detect_SMBIOS_pointer(cpqhp_rom_start,
-					cpqhp_rom_start + ROM_PHY_LEN);
-	if (!smbios_table) {
-		err ("Could not find the SMBIOS pointer in memory\n");
-		retval = -EIO;
-		goto error_rom_start;
-	}
-
-	smbios_start = ioremap(readl(smbios_table + ST_ADDRESS),
-					readw(smbios_table + ST_LENGTH));
-	if (!smbios_start) {
-		err ("Could not ioremap memory region taken from SMBIOS values\n");
-		retval = -EIO;
-		goto error_smbios_start;
-	}
-
-	initialized = 1;
-
-	return retval;
-
-error_smbios_start:
-	iounmap(smbios_start);
-error_rom_start:
-	iounmap(cpqhp_rom_start);
-error:
-	return retval;
-}
-
 static void __exit unload_cpqphpd(void)
 {
 	struct pci_func *next;

