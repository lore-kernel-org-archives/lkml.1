Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZJ0DZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZJ0DZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 23:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZJ0DZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 23:25:24 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:2576 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZJ0DZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 23:25:23 -0400
Date: Mon, 26 Oct 2009 21:25:27 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] PCI Hotplug: acpiphp: clean up list traversals
Message-ID: <20091027032527.GB30509@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using list_for_each_entry instead of list_for_each allows us to
enhance readability and minorly reduce some stack usage.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
This is 2.6.33 material, thanks.

 acpiphp_glue.c |   58 ++++++++++++++++-----------------------------------------
 1 file changed, 17 insertions(+), 41 deletions(-)

---
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 58d25a1..f2c49b9 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -311,17 +311,13 @@ static void init_bridge_misc(struct acpiphp_bridge *bridge)
 /* find acpiphp_func from acpiphp_bridge */
 static struct acpiphp_func *acpiphp_bridge_handle_to_function(acpi_handle handle)
 {
-	struct list_head *node, *l;
 	struct acpiphp_bridge *bridge;
 	struct acpiphp_slot *slot;
 	struct acpiphp_func *func;
 
-	list_for_each(node, &bridge_list) {
-		bridge = list_entry(node, struct acpiphp_bridge, list);
+	list_for_each_entry(bridge, &bridge_list, list) {
 		for (slot = bridge->slots; slot; slot = slot->next) {
-			list_for_each(l, &slot->funcs) {
-				func = list_entry(l, struct acpiphp_func,
-							sibling);
+			list_for_each_entry(func, &slot->funcs, sibling) {
 				if (func->handle == handle)
 					return func;
 			}
@@ -495,21 +491,19 @@ static int add_bridge(acpi_handle handle)
 
 static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)
 {
-	struct list_head *head;
-	list_for_each(head, &bridge_list) {
-		struct acpiphp_bridge *bridge = list_entry(head,
-						struct acpiphp_bridge, list);
+	struct acpiphp_bridge *bridge;
+
+	list_for_each_entry(bridge, &bridge_list, list)
 		if (bridge->handle == handle)
 			return bridge;
-	}
 
 	return NULL;
 }
 
 static void cleanup_bridge(struct acpiphp_bridge *bridge)
 {
-	struct list_head *list, *tmp;
-	struct acpiphp_slot *slot;
+	struct acpiphp_slot *slot, *next;
+	struct acpiphp_func *func, *tmp;
 	acpi_status status;
 	acpi_handle handle = bridge->handle;
 
@@ -530,10 +524,8 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 
 	slot = bridge->slots;
 	while (slot) {
-		struct acpiphp_slot *next = slot->next;
-		list_for_each_safe (list, tmp, &slot->funcs) {
-			struct acpiphp_func *func;
-			func = list_entry(list, struct acpiphp_func, sibling);
+		next = slot->next;
+		list_for_each_entry_safe(func, tmp, &slot->funcs, sibling) {
 			if (is_dock_device(func->handle)) {
 				unregister_hotplug_dock_device(func->handle);
 				unregister_dock_notifier(&func->nb);
@@ -545,7 +537,7 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 				if (ACPI_FAILURE(status))
 					err("failed to remove notify handler\n");
 			}
-			list_del(list);
+			list_del(&func->sibling);
 			kfree(func);
 		}
 		acpiphp_unregister_hotplug_slot(slot);
@@ -794,16 +786,13 @@ static int power_on_slot(struct acpiphp_slot *slot)
 {
 	acpi_status status;
 	struct acpiphp_func *func;
-	struct list_head *l;
 	int retval = 0;
 
 	/* if already enabled, just skip */
 	if (slot->flags & SLOT_POWEREDON)
 		goto err_exit;
 
-	list_for_each (l, &slot->funcs) {
-		func = list_entry(l, struct acpiphp_func, sibling);
-
+	list_for_each_entry(func, &slot->funcs, sibling) {
 		if (func->flags & FUNC_HAS_PS0) {
 			dbg("%s: executing _PS0\n", __func__);
 			status = acpi_evaluate_object(func->handle, "_PS0", NULL, NULL);
@@ -829,7 +818,6 @@ static int power_off_slot(struct acpiphp_slot *slot)
 {
 	acpi_status status;
 	struct acpiphp_func *func;
-	struct list_head *l;
 
 	int retval = 0;
 
@@ -837,9 +825,7 @@ static int power_off_slot(struct acpiphp_slot *slot)
 	if ((slot->flags & SLOT_POWEREDON) == 0)
 		goto err_exit;
 
-	list_for_each (l, &slot->funcs) {
-		func = list_entry(l, struct acpiphp_func, sibling);
-
+	list_for_each_entry(func, &slot->funcs, sibling) {
 		if (func->flags & FUNC_HAS_PS3) {
 			status = acpi_evaluate_object(func->handle, "_PS3", NULL, NULL);
 			if (ACPI_FAILURE(status)) {
@@ -966,7 +952,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 {
 	struct pci_dev *dev;
 	struct pci_bus *bus = slot->bridge->pci_bus;
-	struct list_head *l;
 	struct acpiphp_func *func;
 	int retval = 0;
 	int num, max, pass;
@@ -1006,10 +991,8 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 		}
 	}
 
-	list_for_each (l, &slot->funcs) {
-		func = list_entry(l, struct acpiphp_func, sibling);
+	list_for_each_entry(func, &slot->funcs, sibling)
 		acpiphp_bus_add(func);
-	}
 
 	pci_bus_assign_resources(bus);
 	acpiphp_sanitize_bus(bus);
@@ -1019,8 +1002,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 	pci_enable_bridges(bus);
 	pci_bus_add_devices(bus);
 
-	list_for_each (l, &slot->funcs) {
-		func = list_entry(l, struct acpiphp_func, sibling);
+	list_for_each_entry(func, &slot->funcs, sibling) {
 		dev = pci_get_slot(bus, PCI_DEVFN(slot->device,
 						  func->function));
 		if (!dev)
@@ -1119,12 +1101,9 @@ static unsigned int get_slot_status(struct acpiphp_slot *slot)
 	acpi_status status;
 	unsigned long long sta = 0;
 	u32 dvid;
-	struct list_head *l;
 	struct acpiphp_func *func;
 
-	list_for_each (l, &slot->funcs) {
-		func = list_entry(l, struct acpiphp_func, sibling);
-
+	list_for_each_entry(func, &slot->funcs, sibling) {
 		if (func->flags & FUNC_HAS_STA) {
 			status = acpi_evaluate_integer(func->handle, "_STA", NULL, &sta);
 			if (ACPI_SUCCESS(status) && sta)
@@ -1152,13 +1131,10 @@ int acpiphp_eject_slot(struct acpiphp_slot *slot)
 {
 	acpi_status status;
 	struct acpiphp_func *func;
-	struct list_head *l;
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
 
-	list_for_each (l, &slot->funcs) {
-		func = list_entry(l, struct acpiphp_func, sibling);
-
+	list_for_each_entry(func, &slot->funcs, sibling) {
 		/* We don't want to call _EJ0 on non-existing functions. */
 		if ((func->flags & FUNC_HAS_EJ0)) {
 			/* _EJ0 method take one argument */
@@ -1542,7 +1518,7 @@ int __init acpiphp_get_num_slots(void)
 	struct acpiphp_bridge *bridge;
 	int num_slots = 0;
 
-	list_for_each_entry (bridge, &bridge_list, list) {
+	list_for_each_entry(bridge, &bridge_list, list) {
 		dbg("Bus %04x:%02x has %d slot%s\n",
 				pci_domain_nr(bridge->pci_bus),
 				bridge->pci_bus->number, bridge->nr_slots,
