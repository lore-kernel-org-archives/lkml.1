Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbYIIKDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbYIIKDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbYIIKAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:00:51 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:40291 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbYIIKAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:00:48 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 09/13] PCI: pciehp: remove 'name' parameter
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Tue, 09 Sep 2008 04:00:47 -0600
Message-ID: <20080909100047.29542.91306.stgit@bob.kio>
In-Reply-To: <20080909091813.29542.85613.stgit@bob.kio>
References: <20080909091813.29542.85613.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
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

Remove 'name' from pciehp's version of struct slot, and remove
unused 'task_list' as well.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: kaneshige.kenji@jp.fujitsu.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/pciehp.h      |    9 +++++--
 drivers/pci/hotplug/pciehp_core.c |   25 ++++++++++---------
 drivers/pci/hotplug/pciehp_ctrl.c |   48 +++++++++++++++++++------------------
 3 files changed, 43 insertions(+), 39 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 217427a..3be5dde 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -61,15 +61,13 @@ extern struct workqueue_struct *pciehp_wq;
 struct slot {
 	u8 bus;
 	u8 device;
-	u32 number;
 	u8 state;
-	struct timer_list task_event;
 	u8 hp_slot;
+	u32 number;
 	struct controller *ctrl;
 	struct hpc_ops *hpc_ops;
 	struct hotplug_slot *hotplug_slot;
 	struct list_head	slot_list;
-	char name[SLOT_NAME_SIZE];
 	unsigned long last_emi_toggle;
 	struct delayed_work work;	/* work for button event */
 	struct mutex lock;
@@ -162,6 +160,11 @@ int pciehp_enable_slot(struct slot *p_slot);
 int pciehp_disable_slot(struct slot *p_slot);
 int pcie_enable_notification(struct controller *ctrl);
 
+static inline const char *slot_name(struct slot *slot)
+{
+	return hotplug_slot_name(slot->hotplug_slot);
+}
+
 static inline struct slot *pciehp_find_slot(struct controller *ctrl, u8 device)
 {
 	struct slot *slot;
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index bed77af..0466e64 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -180,7 +180,7 @@ static struct hotplug_slot_attribute hotplug_slot_attr_lock = {
  */
 static void release_slot(struct hotplug_slot *hotplug_slot)
 {
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot_name(hotplug_slot));
 
 	kfree(hotplug_slot->info);
 	kfree(hotplug_slot);
@@ -191,6 +191,7 @@ static int init_slots(struct controller *ctrl)
 	struct slot *slot;
 	struct hotplug_slot *hotplug_slot;
 	struct hotplug_slot_info *info;
+	char name[SLOT_NAME_SIZE];
 	int retval = -ENOMEM;
 
 	list_for_each_entry(slot, &ctrl->slot_list, slot_list) {
@@ -204,7 +205,6 @@ static int init_slots(struct controller *ctrl)
 
 		/* register this slot with the hotplug pci core */
 		hotplug_slot->info = info;
-		hotplug_slot->name = slot->name;
 		hotplug_slot->private = slot;
 		hotplug_slot->release = &release_slot;
 		hotplug_slot->ops = &pciehp_hotplug_slot_ops;
@@ -213,6 +213,7 @@ static int init_slots(struct controller *ctrl)
 		get_latch_status(hotplug_slot, &info->latch_status);
 		get_adapter_status(hotplug_slot, &info->adapter_status);
 		slot->hotplug_slot = hotplug_slot;
+		scnprintf(name, SLOT_NAME_SIZE, "%d", slot->number);
 
 		dbg("Registering bus=%x dev=%x hp_slot=%x sun=%x "
 		    "slot_device_offset=%x\n", slot->bus, slot->device,
@@ -220,7 +221,7 @@ static int init_slots(struct controller *ctrl)
 		retval = pci_hp_register(hotplug_slot,
 					 ctrl->pci_dev->subordinate,
 					 slot->device,
-					 slot->name);
+					 name);
 		if (retval) {
 			err("pci_hp_register failed with error %d\n", retval);
 			goto error_info;
@@ -265,7 +266,7 @@ static int set_attention_status(struct hotplug_slot *hotplug_slot, u8 status)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	hotplug_slot->info->attention_status = status;
 
@@ -280,7 +281,7 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	return pciehp_sysfs_enable_slot(slot);
 }
@@ -290,7 +291,7 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	return pciehp_sysfs_disable_slot(slot);
 }
@@ -300,7 +301,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_power_status(slot, value);
 	if (retval < 0)
@@ -314,7 +315,7 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_attention_status(slot, value);
 	if (retval < 0)
@@ -328,7 +329,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_latch_status(slot, value);
 	if (retval < 0)
@@ -342,7 +343,7 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_adapter_status(slot, value);
 	if (retval < 0)
@@ -357,7 +358,7 @@ static int get_max_bus_speed(struct hotplug_slot *hotplug_slot,
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_max_bus_speed(slot, value);
 	if (retval < 0)
@@ -371,7 +372,7 @@ static int get_cur_bus_speed(struct hotplug_slot *hotplug_slot, enum pci_bus_spe
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_cur_bus_speed(slot, value);
 	if (retval < 0)
diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index 96a5d55..7266fbd 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -65,7 +65,7 @@ u8 pciehp_handle_attention_button(struct slot *p_slot)
 	/*
 	 *  Button pressed - See if need to TAKE ACTION!!!
 	 */
-	info("Button pressed on Slot(%s)\n", p_slot->name);
+	info("Button pressed on Slot(%s)\n", slot_name(p_slot));
 	event_type = INT_BUTTON_PRESS;
 
 	queue_interrupt_event(p_slot, event_type);
@@ -86,13 +86,13 @@ u8 pciehp_handle_switch_change(struct slot *p_slot)
 		/*
 		 * Switch opened
 		 */
-		info("Latch open on Slot(%s)\n", p_slot->name);
+		info("Latch open on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_SWITCH_OPEN;
 	} else {
 		/*
 		 *  Switch closed
 		 */
-		info("Latch close on Slot(%s)\n", p_slot->name);
+		info("Latch close on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_SWITCH_CLOSE;
 	}
 
@@ -117,13 +117,13 @@ u8 pciehp_handle_presence_change(struct slot *p_slot)
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
 
@@ -143,13 +143,13 @@ u8 pciehp_handle_power_fault(struct slot *p_slot)
 		/*
 		 * power fault Cleared
 		 */
-		info("Power fault cleared on Slot(%s)\n", p_slot->name);
+		info("Power fault cleared on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_POWER_FAULT_CLEAR;
 	} else {
 		/*
 		 *   power fault
 		 */
-		info("Power fault on Slot(%s)\n", p_slot->name);
+		info("Power fault on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_POWER_FAULT;
 		info("power fault bit %x set\n", 0);
 	}
@@ -404,11 +404,11 @@ static void handle_button_press_event(struct slot *p_slot)
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
 		if (PWR_LED(ctrl))
@@ -425,7 +425,7 @@ static void handle_button_press_event(struct slot *p_slot)
 		 * press the attention again before the 5 sec. limit
 		 * expires to cancel hot-add or hot-remove
 		 */
-		info("Button cancel on Slot(%s)\n", p_slot->name);
+		info("Button cancel on Slot(%s)\n", slot_name(p_slot));
 		dbg("%s: button cancel\n", __func__);
 		cancel_delayed_work(&p_slot->work);
 		if (p_slot->state == BLINKINGOFF_STATE) {
@@ -438,7 +438,7 @@ static void handle_button_press_event(struct slot *p_slot)
 		if (ATTN_LED(ctrl))
 			p_slot->hpc_ops->set_attention_status(p_slot, 0);
 		info("PCI slot #%s - action canceled due to button press\n",
-		     p_slot->name);
+		     slot_name(p_slot));
 		p_slot->state = STATIC_STATE;
 		break;
 	case POWEROFF_STATE:
@@ -448,7 +448,7 @@ static void handle_button_press_event(struct slot *p_slot)
 		 * this means that the previous attention button action
 		 * to hot-add or hot-remove is undergoing
 		 */
-		info("Button ignore on Slot(%s)\n", p_slot->name);
+		info("Button ignore on Slot(%s)\n", slot_name(p_slot));
 		update_slot_info(p_slot);
 		break;
 	default:
@@ -529,7 +529,7 @@ int pciehp_enable_slot(struct slot *p_slot)
 	rc = p_slot->hpc_ops->get_adapter_status(p_slot, &getstatus);
 	if (rc || !getstatus) {
 		info("%s: no adapter on slot(%s)\n", __func__,
-		     p_slot->name);
+		     slot_name(p_slot));
 		mutex_unlock(&p_slot->ctrl->crit_sect);
 		return -ENODEV;
 	}
@@ -537,7 +537,7 @@ int pciehp_enable_slot(struct slot *p_slot)
 		rc = p_slot->hpc_ops->get_latch_status(p_slot, &getstatus);
 		if (rc || getstatus) {
 			info("%s: latch open on slot(%s)\n", __func__,
-			     p_slot->name);
+			     slot_name(p_slot));
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -ENODEV;
 		}
@@ -547,7 +547,7 @@ int pciehp_enable_slot(struct slot *p_slot)
 		rc = p_slot->hpc_ops->get_power_status(p_slot, &getstatus);
 		if (rc || getstatus) {
 			info("%s: already enabled on slot(%s)\n", __func__,
-			     p_slot->name);
+			     slot_name(p_slot));
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -EINVAL;
 		}
@@ -582,7 +582,7 @@ int pciehp_disable_slot(struct slot *p_slot)
 		ret = p_slot->hpc_ops->get_adapter_status(p_slot, &getstatus);
 		if (ret || !getstatus) {
 			info("%s: no adapter on slot(%s)\n", __func__,
-			     p_slot->name);
+			     slot_name(p_slot));
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -ENODEV;
 		}
@@ -592,7 +592,7 @@ int pciehp_disable_slot(struct slot *p_slot)
 		ret = p_slot->hpc_ops->get_latch_status(p_slot, &getstatus);
 		if (ret || getstatus) {
 			info("%s: latch open on slot(%s)\n", __func__,
-			     p_slot->name);
+			     slot_name(p_slot));
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -ENODEV;
 		}
@@ -602,7 +602,7 @@ int pciehp_disable_slot(struct slot *p_slot)
 		ret = p_slot->hpc_ops->get_power_status(p_slot, &getstatus);
 		if (ret || !getstatus) {
 			info("%s: already disabled slot(%s)\n", __func__,
-			     p_slot->name);
+			     slot_name(p_slot));
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -EINVAL;
 		}
@@ -632,14 +632,14 @@ int pciehp_sysfs_enable_slot(struct slot *p_slot)
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
@@ -664,14 +664,14 @@ int pciehp_sysfs_disable_slot(struct slot *p_slot)
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

