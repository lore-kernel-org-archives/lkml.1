Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbYHQATv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbYHQATv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 20:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbYHQARr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 20:17:47 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:2572 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbYHQARp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 20:17:45 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 12/13] PCI: shcphp: remove 'name' parameter
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Sat, 16 Aug 2008 18:17:45 -0600
Message-ID: <20080817001743.5461.9344.stgit@blender.achiang>
In-Reply-To: <20080816235504.5461.20733.stgit@blender.achiang>
References: <20080816235504.5461.20733.stgit@blender.achiang>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need to manage our own name parameter, especially since
the PCI core can change it on our behalf, in the case of duplicate
slot names.

Remove 'name' from shpchp's version of struct slot.

This change also removes the unused struct task_event from the
slot structure.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: kaneshige.kenji@jp.fujitsu.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/shpchp.h      |    9 +++++--
 drivers/pci/hotplug/shpchp_core.c |   35 ++++++++++++---------------
 drivers/pci/hotplug/shpchp_ctrl.c |   48 +++++++++++++++++++------------------
 3 files changed, 45 insertions(+), 47 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp.h b/drivers/pci/hotplug/shpchp.h
index 8a026f7..4d9fed0 100644
--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -69,15 +69,13 @@ struct slot {
 	u8 state;
 	u8 presence_save;
 	u8 pwr_save;
-	struct timer_list task_event;
-	u8 hp_slot;
 	struct controller *ctrl;
 	struct hpc_ops *hpc_ops;
 	struct hotplug_slot *hotplug_slot;
 	struct list_head	slot_list;
-	char name[SLOT_NAME_SIZE];
 	struct delayed_work work;	/* work for button event */
 	struct mutex lock;
+	u8 hp_slot;
 };
 
 struct event_info {
@@ -169,6 +167,11 @@ extern void cleanup_slots(struct controller *ctrl);
 extern void shpchp_queue_pushbutton_work(struct work_struct *work);
 extern int shpc_init( struct controller *ctrl, struct pci_dev *pdev);
 
+static inline const char *slot_name(struct slot *slot)
+{
+	return hotplug_slot_name(slot->hotplug_slot);
+}
+
 #ifdef CONFIG_ACPI
 #include <linux/pci-acpi.h>
 static inline int get_hp_params_from_firmware(struct pci_dev *dev,
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index 136d9ea..df1e2a0 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -89,23 +89,19 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	kfree(slot->hotplug_slot->info);
 	kfree(slot->hotplug_slot);
 	kfree(slot);
 }
 
-static void make_slot_name(struct slot *slot)
-{
-	snprintf(slot->hotplug_slot->name, SLOT_NAME_SIZE, "%d", slot->number);
-}
-
 static int init_slots(struct controller *ctrl)
 {
 	struct slot *slot;
 	struct hotplug_slot *hotplug_slot;
 	struct hotplug_slot_info *info;
+	char name[SLOT_NAME_SIZE];
 	int retval = -ENOMEM;
 	int i;
 
@@ -124,8 +120,6 @@ static int init_slots(struct controller *ctrl)
 			goto error_hpslot;
 		hotplug_slot->info = info;
 
-		hotplug_slot->name = slot->name;
-
 		slot->hp_slot = i;
 		slot->ctrl = ctrl;
 		slot->bus = ctrl->pci_dev->subordinate->number;
@@ -138,9 +132,11 @@ static int init_slots(struct controller *ctrl)
 		/* register this slot with the hotplug pci core */
 		hotplug_slot->private = slot;
 		hotplug_slot->release = &release_slot;
-		make_slot_name(slot);
 		hotplug_slot->ops = &shpchp_hotplug_slot_ops;
 
+		memset(name, 0, SLOT_NAME_SIZE);
+		snprintf(name, SLOT_NAME_SIZE, "%d", slot->number);
+
 		get_power_status(hotplug_slot, &info->power_status);
 		get_attention_status(hotplug_slot, &info->attention_status);
 		get_latch_status(hotplug_slot, &info->latch_status);
@@ -150,8 +146,7 @@ static int init_slots(struct controller *ctrl)
 		    "slot_device_offset=%x\n", slot->bus, slot->device,
 		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
 		retval = pci_hp_register(slot->hotplug_slot,
-				ctrl->pci_dev->subordinate, slot->device,
-				hotplug_slot->name);
+				ctrl->pci_dev->subordinate, slot->device, name);
 		if (retval) {
 			err("pci_hp_register failed with error %d\n", retval);
 			goto error_info;
@@ -194,7 +189,7 @@ static int set_attention_status (struct hotplug_slot *hotplug_slot, u8 status)
 {
 	struct slot *slot = get_slot(hotplug_slot);
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	hotplug_slot->info->attention_status = status;
 	slot->hpc_ops->set_attention_status(slot, status);
@@ -206,7 +201,7 @@ static int enable_slot (struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = get_slot(hotplug_slot);
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	return shpchp_sysfs_enable_slot(slot);
 }
@@ -215,7 +210,7 @@ static int disable_slot (struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = get_slot(hotplug_slot);
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	return shpchp_sysfs_disable_slot(slot);
 }
@@ -225,7 +220,7 @@ static int get_power_status (struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_power_status(slot, value);
 	if (retval < 0)
@@ -239,7 +234,7 @@ static int get_attention_status (struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_attention_status(slot, value);
 	if (retval < 0)
@@ -253,7 +248,7 @@ static int get_latch_status (struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_latch_status(slot, value);
 	if (retval < 0)
@@ -267,7 +262,7 @@ static int get_adapter_status (struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_adapter_status(slot, value);
 	if (retval < 0)
@@ -282,7 +277,7 @@ static int get_max_bus_speed(struct hotplug_slot *hotplug_slot,
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_max_bus_speed(slot, value);
 	if (retval < 0)
@@ -296,7 +291,7 @@ static int get_cur_bus_speed (struct hotplug_slot *hotplug_slot, enum pci_bus_sp
 	struct slot *slot = get_slot(hotplug_slot);
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_cur_bus_speed(slot, value);
 	if (retval < 0)
diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
index dfb5393..919b1ee 100644
--- a/drivers/pci/hotplug/shpchp_ctrl.c
+++ b/drivers/pci/hotplug/shpchp_ctrl.c
@@ -70,7 +70,7 @@ u8 shpchp_handle_attention_button(u8 hp_slot, struct controller *ctrl)
 	/*
 	 *  Button pressed - See if need to TAKE ACTION!!!
 	 */
-	info("Button pressed on Slot(%s)\n", p_slot->name);
+	info("Button pressed on Slot(%s)\n", slot_name(p_slot));
 	event_type = INT_BUTTON_PRESS;
 
 	queue_interrupt_event(p_slot, event_type);
@@ -98,7 +98,7 @@ u8 shpchp_handle_switch_change(u8 hp_slot, struct controller *ctrl)
 		/*
 		 * Switch opened
 		 */
-		info("Latch open on Slot(%s)\n", p_slot->name);
+		info("Latch open on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_SWITCH_OPEN;
 		if (p_slot->pwr_save && p_slot->presence_save) {
 			event_type = INT_POWER_FAULT;
@@ -108,7 +108,7 @@ u8 shpchp_handle_switch_change(u8 hp_slot, struct controller *ctrl)
 		/*
 		 *  Switch closed
 		 */
-		info("Latch close on Slot(%s)\n", p_slot->name);
+		info("Latch close on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_SWITCH_CLOSE;
 	}
 
@@ -135,13 +135,13 @@ u8 shpchp_handle_presence_change(u8 hp_slot, struct controller *ctrl)
 		/*
 		 * Card Present
 		 */
-		info("Card present on Slot(%s)\n", p_slot->name);
+		info("Card present on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_PRESENCE_ON;
 	} else {
 		/*
 		 * Not Present
 		 */
-		info("Card not present on Slot(%s)\n", p_slot->name);
+		info("Card not present on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_PRESENCE_OFF;
 	}
 
@@ -164,14 +164,14 @@ u8 shpchp_handle_power_fault(u8 hp_slot, struct controller *ctrl)
 		/*
 		 * Power fault Cleared
 		 */
-		info("Power fault cleared on Slot(%s)\n", p_slot->name);
+		info("Power fault cleared on Slot(%s)\n", slot_name(p_slot));
 		p_slot->status = 0x00;
 		event_type = INT_POWER_FAULT_CLEAR;
 	} else {
 		/*
 		 *   Power fault
 		 */
-		info("Power fault on Slot(%s)\n", p_slot->name);
+		info("Power fault on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_POWER_FAULT;
 		/* set power fault status for this board */
 		p_slot->status = 0xFF;
@@ -493,11 +493,11 @@ static void handle_button_press_event(struct slot *p_slot)
 		if (getstatus) {
 			p_slot->state = BLINKINGOFF_STATE;
 			info("PCI slot #%s - powering off due to button "
-			     "press.\n", p_slot->name);
+			     "press.\n", slot_name(p_slot));
 		} else {
 			p_slot->state = BLINKINGON_STATE;
 			info("PCI slot #%s - powering on due to button "
-			     "press.\n", p_slot->name);
+			     "press.\n", slot_name(p_slot));
 		}
 		/* blink green LED and turn off amber */
 		p_slot->hpc_ops->green_led_blink(p_slot);
@@ -512,7 +512,7 @@ static void handle_button_press_event(struct slot *p_slot)
 		 * press the attention again before the 5 sec. limit
 		 * expires to cancel hot-add or hot-remove
 		 */
-		info("Button cancel on Slot(%s)\n", p_slot->name);
+		info("Button cancel on Slot(%s)\n", slot_name(p_slot));
 		dbg("%s: button cancel\n", __func__);
 		cancel_delayed_work(&p_slot->work);
 		if (p_slot->state == BLINKINGOFF_STATE)
@@ -521,7 +521,7 @@ static void handle_button_press_event(struct slot *p_slot)
 			p_slot->hpc_ops->green_led_off(p_slot);
 		p_slot->hpc_ops->set_attention_status(p_slot, 0);
 		info("PCI slot #%s - action canceled due to button press\n",
-		     p_slot->name);
+		     slot_name(p_slot));
 		p_slot->state = STATIC_STATE;
 		break;
 	case POWEROFF_STATE:
@@ -531,7 +531,7 @@ static void handle_button_press_event(struct slot *p_slot)
 		 * this means that the previous attention button action
 		 * to hot-add or hot-remove is undergoing
 		 */
-		info("Button ignore on Slot(%s)\n", p_slot->name);
+		info("Button ignore on Slot(%s)\n", slot_name(p_slot));
 		update_slot_info(p_slot);
 		break;
 	default:
@@ -574,17 +574,17 @@ static int shpchp_enable_slot (struct slot *p_slot)
 	mutex_lock(&p_slot->ctrl->crit_sect);
 	rc = p_slot->hpc_ops->get_adapter_status(p_slot, &getstatus);
 	if (rc || !getstatus) {
-		info("No adapter on slot(%s)\n", p_slot->name);
+		info("No adapter on slot(%s)\n", slot_name(p_slot));
 		goto out;
 	}
 	rc = p_slot->hpc_ops->get_latch_status(p_slot, &getstatus);
 	if (rc || getstatus) {
-		info("Latch open on slot(%s)\n", p_slot->name);
+		info("Latch open on slot(%s)\n", slot_name(p_slot));
 		goto out;
 	}
 	rc = p_slot->hpc_ops->get_power_status(p_slot, &getstatus);
 	if (rc || getstatus) {
-		info("Already enabled on slot(%s)\n", p_slot->name);
+		info("Already enabled on slot(%s)\n", slot_name(p_slot));
 		goto out;
 	}
 
@@ -633,17 +633,17 @@ static int shpchp_disable_slot (struct slot *p_slot)
 
 	rc = p_slot->hpc_ops->get_adapter_status(p_slot, &getstatus);
 	if (rc || !getstatus) {
-		info("No adapter on slot(%s)\n", p_slot->name);
+		info("No adapter on slot(%s)\n", slot_name(p_slot));
 		goto out;
 	}
 	rc = p_slot->hpc_ops->get_latch_status(p_slot, &getstatus);
 	if (rc || getstatus) {
-		info("Latch open on slot(%s)\n", p_slot->name);
+		info("Latch open on slot(%s)\n", slot_name(p_slot));
 		goto out;
 	}
 	rc = p_slot->hpc_ops->get_power_status(p_slot, &getstatus);
 	if (rc || !getstatus) {
-		info("Already disabled slot(%s)\n", p_slot->name);
+		info("Already disabled slot(%s)\n", slot_name(p_slot));
 		goto out;
 	}
 
@@ -671,14 +671,14 @@ int shpchp_sysfs_enable_slot(struct slot *p_slot)
 		break;
 	case POWERON_STATE:
 		info("Slot %s is already in powering on state\n",
-		     p_slot->name);
+		     slot_name(p_slot));
 		break;
 	case BLINKINGOFF_STATE:
 	case POWEROFF_STATE:
-		info("Already enabled on slot %s\n", p_slot->name);
+		info("Already enabled on slot %s\n", slot_name(p_slot));
 		break;
 	default:
-		err("Not a valid state on slot %s\n", p_slot->name);
+		err("Not a valid state on slot %s\n", slot_name(p_slot));
 		break;
 	}
 	mutex_unlock(&p_slot->lock);
@@ -703,14 +703,14 @@ int shpchp_sysfs_disable_slot(struct slot *p_slot)
 		break;
 	case POWEROFF_STATE:
 		info("Slot %s is already in powering off state\n",
-		     p_slot->name);
+		     slot_name(p_slot));
 		break;
 	case BLINKINGON_STATE:
 	case POWERON_STATE:
-		info("Already disabled on slot %s\n", p_slot->name);
+		info("Already disabled on slot %s\n", slot_name(p_slot));
 		break;
 	default:
-		err("Not a valid state on slot %s\n", p_slot->name);
+		err("Not a valid state on slot %s\n", slot_name(p_slot));
 		break;
 	}
 	mutex_unlock(&p_slot->lock);

