Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYIWQsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYIWQsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYIWQqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:46:04 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:32343 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbYIWQqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:46:00 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v3 09/14] PCI: pciehp: remove 'name' parameter
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Tue, 23 Sep 2008 10:45:59 -0600
Message-ID: <20080923164559.12628.89909.stgit@bob.kio>
In-Reply-To: <20080923163753.12628.98683.stgit@bob.kio>
References: <20080923163753.12628.98683.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
To: unlisted-recipients:; (no To-header on input)
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

 drivers/pci/hotplug/pciehp.h      |    9 ++++--
 drivers/pci/hotplug/pciehp_core.c |   25 +++++++++--------
 drivers/pci/hotplug/pciehp_ctrl.c |   53 ++++++++++++++++++++-----------------
 drivers/pci/hotplug/pciehp_hpc.c  |    1 -
 4 files changed, 48 insertions(+), 40 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index c367978..394f998 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -74,15 +74,13 @@ extern struct workqueue_struct *pciehp_wq;
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
@@ -175,6 +173,11 @@ int pciehp_enable_slot(struct slot *p_slot);
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
index af89d7b..d39facc 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -185,7 +185,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 
 	ctrl_dbg(slot->ctrl, "%s - physical_slot = %s\n",
-		 __func__, hotplug_slot->name);
+		 __func__, hotplug_slot_name(hotplug_slot));
 
 	kfree(hotplug_slot->info);
 	kfree(hotplug_slot);
@@ -196,6 +196,7 @@ static int init_slots(struct controller *ctrl)
 	struct slot *slot;
 	struct hotplug_slot *hotplug_slot;
 	struct hotplug_slot_info *info;
+	char name[SLOT_NAME_SIZE];
 	int retval = -ENOMEM;
 
 	list_for_each_entry(slot, &ctrl->slot_list, slot_list) {
@@ -209,7 +210,6 @@ static int init_slots(struct controller *ctrl)
 
 		/* register this slot with the hotplug pci core */
 		hotplug_slot->info = info;
-		hotplug_slot->name = slot->name;
 		hotplug_slot->private = slot;
 		hotplug_slot->release = &release_slot;
 		hotplug_slot->ops = &pciehp_hotplug_slot_ops;
@@ -218,6 +218,7 @@ static int init_slots(struct controller *ctrl)
 		get_latch_status(hotplug_slot, &info->latch_status);
 		get_adapter_status(hotplug_slot, &info->adapter_status);
 		slot->hotplug_slot = hotplug_slot;
+		snprintf(name, SLOT_NAME_SIZE, "%u", slot->number);
 
 		ctrl_dbg(ctrl, "Registering bus=%x dev=%x hp_slot=%x sun=%x "
 			 "slot_device_offset=%x\n", slot->bus, slot->device,
@@ -225,7 +226,7 @@ static int init_slots(struct controller *ctrl)
 		retval = pci_hp_register(hotplug_slot,
 					 ctrl->pci_dev->subordinate,
 					 slot->device,
-					 slot->name);
+					 name);
 		if (retval) {
 			ctrl_err(ctrl, "pci_hp_register failed with error %d\n",
 				 retval);
@@ -273,7 +274,7 @@ static int set_attention_status(struct hotplug_slot *hotplug_slot, u8 status)
 	struct slot *slot = hotplug_slot->private;
 
 	ctrl_dbg(slot->ctrl, "%s - physical_slot = %s\n",
-		  __func__, hotplug_slot->name);
+		  __func__, slot_name(slot));
 
 	hotplug_slot->info->attention_status = status;
 
@@ -289,7 +290,7 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 
 	ctrl_dbg(slot->ctrl, "%s - physical_slot = %s\n",
-		 __func__, hotplug_slot->name);
+		 __func__, slot_name(slot));
 
 	return pciehp_sysfs_enable_slot(slot);
 }
@@ -300,7 +301,7 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 
 	ctrl_dbg(slot->ctrl, "%s - physical_slot = %s\n",
-		  __func__, hotplug_slot->name);
+		  __func__, slot_name(slot));
 
 	return pciehp_sysfs_disable_slot(slot);
 }
@@ -311,7 +312,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	int retval;
 
 	ctrl_dbg(slot->ctrl, "%s - physical_slot = %s\n",
-		  __func__, hotplug_slot->name);
+		  __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_power_status(slot, value);
 	if (retval < 0)
@@ -326,7 +327,7 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	int retval;
 
 	ctrl_dbg(slot->ctrl, "%s - physical_slot = %s\n",
-		  __func__, hotplug_slot->name);
+		  __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_attention_status(slot, value);
 	if (retval < 0)
@@ -341,7 +342,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	int retval;
 
 	ctrl_dbg(slot->ctrl, "%s - physical_slot = %s\n",
-		 __func__, hotplug_slot->name);
+		 __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_latch_status(slot, value);
 	if (retval < 0)
@@ -356,7 +357,7 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	int retval;
 
 	ctrl_dbg(slot->ctrl, "%s - physical_slot = %s\n",
-		 __func__, hotplug_slot->name);
+		 __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_adapter_status(slot, value);
 	if (retval < 0)
@@ -372,7 +373,7 @@ static int get_max_bus_speed(struct hotplug_slot *hotplug_slot,
 	int retval;
 
 	ctrl_dbg(slot->ctrl, "%s - physical_slot = %s\n",
-		 __func__, hotplug_slot->name);
+		 __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_max_bus_speed(slot, value);
 	if (retval < 0)
@@ -387,7 +388,7 @@ static int get_cur_bus_speed(struct hotplug_slot *hotplug_slot, enum pci_bus_spe
 	int retval;
 
 	ctrl_dbg(slot->ctrl, "%s - physical_slot = %s\n",
-		 __func__, hotplug_slot->name);
+		 __func__, slot_name(slot));
 
 	retval = slot->hpc_ops->get_cur_bus_speed(slot, value);
 	if (retval < 0)
diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index acb7f9e..cce6e5f 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -66,7 +66,7 @@ u8 pciehp_handle_attention_button(struct slot *p_slot)
 	/*
 	 *  Button pressed - See if need to TAKE ACTION!!!
 	 */
-	ctrl_info(ctrl, "Button pressed on Slot(%s)\n", p_slot->name);
+	ctrl_info(ctrl, "Button pressed on Slot(%s)\n", slot_name(p_slot));
 	event_type = INT_BUTTON_PRESS;
 
 	queue_interrupt_event(p_slot, event_type);
@@ -88,13 +88,13 @@ u8 pciehp_handle_switch_change(struct slot *p_slot)
 		/*
 		 * Switch opened
 		 */
-		ctrl_info(ctrl, "Latch open on Slot(%s)\n", p_slot->name);
+		ctrl_info(ctrl, "Latch open on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_SWITCH_OPEN;
 	} else {
 		/*
 		 *  Switch closed
 		 */
-		ctrl_info(ctrl, "Latch close on Slot(%s)\n", p_slot->name);
+		ctrl_info(ctrl, "Latch close on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_SWITCH_CLOSE;
 	}
 
@@ -120,13 +120,14 @@ u8 pciehp_handle_presence_change(struct slot *p_slot)
 		/*
 		 * Card Present
 		 */
-		ctrl_info(ctrl, "Card present on Slot(%s)\n", p_slot->name);
+		ctrl_info(ctrl, "Card present on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_PRESENCE_ON;
 	} else {
 		/*
 		 * Not Present
 		 */
-		ctrl_info(ctrl, "Card not present on Slot(%s)\n", p_slot->name);
+		ctrl_info(ctrl, "Card not present on Slot(%s)\n",
+			  slot_name(p_slot));
 		event_type = INT_PRESENCE_OFF;
 	}
 
@@ -148,13 +149,13 @@ u8 pciehp_handle_power_fault(struct slot *p_slot)
 		 * power fault Cleared
 		 */
 		ctrl_info(ctrl, "Power fault cleared on Slot(%s)\n",
-			  p_slot->name);
+			  slot_name(p_slot));
 		event_type = INT_POWER_FAULT_CLEAR;
 	} else {
 		/*
 		 *   power fault
 		 */
-		ctrl_info(ctrl, "Power fault on Slot(%s)\n", p_slot->name);
+		ctrl_info(ctrl, "Power fault on Slot(%s)\n", slot_name(p_slot));
 		event_type = INT_POWER_FAULT;
 		ctrl_info(ctrl, "power fault bit %x set\n", 0);
 	}
@@ -412,12 +413,12 @@ static void handle_button_press_event(struct slot *p_slot)
 			p_slot->state = BLINKINGOFF_STATE;
 			ctrl_info(ctrl,
 				  "PCI slot #%s - powering off due to button "
-				  "press.\n", p_slot->name);
+				  "press.\n", slot_name(p_slot));
 		} else {
 			p_slot->state = BLINKINGON_STATE;
 			ctrl_info(ctrl,
 				  "PCI slot #%s - powering on due to button "
-				  "press.\n", p_slot->name);
+				  "press.\n", slot_name(p_slot));
 		}
 		/* blink green LED and turn off amber */
 		if (PWR_LED(ctrl))
@@ -434,7 +435,7 @@ static void handle_button_press_event(struct slot *p_slot)
 		 * press the attention again before the 5 sec. limit
 		 * expires to cancel hot-add or hot-remove
 		 */
-		ctrl_info(ctrl, "Button cancel on Slot(%s)\n", p_slot->name);
+		ctrl_info(ctrl, "Button cancel on Slot(%s)\n", slot_name(p_slot));
 		ctrl_dbg(ctrl, "%s: button cancel\n", __func__);
 		cancel_delayed_work(&p_slot->work);
 		if (p_slot->state == BLINKINGOFF_STATE) {
@@ -447,7 +448,7 @@ static void handle_button_press_event(struct slot *p_slot)
 		if (ATTN_LED(ctrl))
 			p_slot->hpc_ops->set_attention_status(p_slot, 0);
 		ctrl_info(ctrl, "PCI slot #%s - action canceled "
-			  "due to button press\n", p_slot->name);
+			  "due to button press\n", slot_name(p_slot));
 		p_slot->state = STATIC_STATE;
 		break;
 	case POWEROFF_STATE:
@@ -457,7 +458,7 @@ static void handle_button_press_event(struct slot *p_slot)
 		 * this means that the previous attention button action
 		 * to hot-add or hot-remove is undergoing
 		 */
-		ctrl_info(ctrl, "Button ignore on Slot(%s)\n", p_slot->name);
+		ctrl_info(ctrl, "Button ignore on Slot(%s)\n", slot_name(p_slot));
 		update_slot_info(p_slot);
 		break;
 	default:
@@ -540,7 +541,7 @@ int pciehp_enable_slot(struct slot *p_slot)
 	rc = p_slot->hpc_ops->get_adapter_status(p_slot, &getstatus);
 	if (rc || !getstatus) {
 		ctrl_info(ctrl, "%s: no adapter on slot(%s)\n",
-			  __func__, p_slot->name);
+			  __func__, slot_name(p_slot));
 		mutex_unlock(&p_slot->ctrl->crit_sect);
 		return -ENODEV;
 	}
@@ -548,7 +549,7 @@ int pciehp_enable_slot(struct slot *p_slot)
 		rc = p_slot->hpc_ops->get_latch_status(p_slot, &getstatus);
 		if (rc || getstatus) {
 			ctrl_info(ctrl, "%s: latch open on slot(%s)\n",
-				  __func__, p_slot->name);
+				  __func__, slot_name(p_slot));
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -ENODEV;
 		}
@@ -558,7 +559,7 @@ int pciehp_enable_slot(struct slot *p_slot)
 		rc = p_slot->hpc_ops->get_power_status(p_slot, &getstatus);
 		if (rc || getstatus) {
 			ctrl_info(ctrl, "%s: already enabled on slot(%s)\n",
-				  __func__, p_slot->name);
+				  __func__, slot_name(p_slot));
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -EINVAL;
 		}
@@ -594,7 +595,7 @@ int pciehp_disable_slot(struct slot *p_slot)
 		ret = p_slot->hpc_ops->get_adapter_status(p_slot, &getstatus);
 		if (ret || !getstatus) {
 			ctrl_info(ctrl, "%s: no adapter on slot(%s)\n",
-				  __func__, p_slot->name);
+				  __func__, slot_name(p_slot));
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -ENODEV;
 		}
@@ -604,7 +605,7 @@ int pciehp_disable_slot(struct slot *p_slot)
 		ret = p_slot->hpc_ops->get_latch_status(p_slot, &getstatus);
 		if (ret || getstatus) {
 			ctrl_info(ctrl, "%s: latch open on slot(%s)\n",
-				  __func__, p_slot->name);
+				  __func__, slot_name(p_slot));
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -ENODEV;
 		}
@@ -614,7 +615,7 @@ int pciehp_disable_slot(struct slot *p_slot)
 		ret = p_slot->hpc_ops->get_power_status(p_slot, &getstatus);
 		if (ret || !getstatus) {
 			ctrl_info(ctrl, "%s: already disabled slot(%s)\n",
-				  __func__, p_slot->name);
+				  __func__, slot_name(p_slot));
 			mutex_unlock(&p_slot->ctrl->crit_sect);
 			return -EINVAL;
 		}
@@ -645,14 +646,16 @@ int pciehp_sysfs_enable_slot(struct slot *p_slot)
 		break;
 	case POWERON_STATE:
 		ctrl_info(ctrl, "Slot %s is already in powering on state\n",
-			  p_slot->name);
+			  slot_name(p_slot));
 		break;
 	case BLINKINGOFF_STATE:
 	case POWEROFF_STATE:
-		ctrl_info(ctrl, "Already enabled on slot %s\n", p_slot->name);
+		ctrl_info(ctrl, "Already enabled on slot %s\n",
+			  slot_name(p_slot));
 		break;
 	default:
-		ctrl_err(ctrl, "Not a valid state on slot %s\n", p_slot->name);
+		ctrl_err(ctrl, "Not a valid state on slot %s\n",
+			 slot_name(p_slot));
 		break;
 	}
 	mutex_unlock(&p_slot->lock);
@@ -678,14 +681,16 @@ int pciehp_sysfs_disable_slot(struct slot *p_slot)
 		break;
 	case POWEROFF_STATE:
 		ctrl_info(ctrl, "Slot %s is already in powering off state\n",
-			  p_slot->name);
+			  slot_name(p_slot));
 		break;
 	case BLINKINGON_STATE:
 	case POWERON_STATE:
-		ctrl_info(ctrl, "Already disabled on slot %s\n", p_slot->name);
+		ctrl_info(ctrl, "Already disabled on slot %s\n",
+			  slot_name(p_slot));
 		break;
 	default:
-		ctrl_err(ctrl, "Not a valid state on slot %s\n", p_slot->name);
+		ctrl_err(ctrl, "Not a valid state on slot %s\n",
+			 slot_name(p_slot));
 		break;
 	}
 	mutex_unlock(&p_slot->lock);
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 8e9530c..4c74d53 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -1061,7 +1061,6 @@ static int pcie_init_slot(struct controller *ctrl)
 	slot->device = ctrl->slot_device_offset + slot->hp_slot;
 	slot->hpc_ops = ctrl->hpc_ops;
 	slot->number = ctrl->first_slot;
-	snprintf(slot->name, SLOT_NAME_SIZE, "%d", slot->number);
 	mutex_init(&slot->lock);
 	INIT_DELAYED_WORK(&slot->work, pciehp_queue_pushbutton_work);
 	list_add(&slot->slot_list, &ctrl->slot_list);

