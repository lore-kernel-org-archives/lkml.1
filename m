Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbZCaP1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbZCaP1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762450AbZCaPYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:24:00 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:22256 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762432AbZCaPX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:23:58 -0400
Subject: [PATCH 10/15] PCI Hotplug: cpqphp: refactor cpqhp_save_config
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:23:57 -0600
Message-ID: <20090331152357.26622.48596.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle an empty slot at the top of the loop, and continue early.

This allows us to un-indent the rest of the function by one level.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp_pci.c |  182 +++++++++++++++++++-------------------
 1 files changed, 91 insertions(+), 91 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index bd384e9..2909e3f 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -359,121 +359,121 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 	ctrl->pci_bus->number = busnumber;
 	for (device = FirstSupported; device <= LastSupported; device++) {
 		ID = 0xFFFFFFFF;
-		rc = pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(device, 0), PCI_VENDOR_ID, &ID);
+		rc = pci_bus_read_config_dword(ctrl->pci_bus, PCI_DEVFN(device, 0), PCI_VENDOR_ID, &ID);
 
-		if (ID != 0xFFFFFFFF) {	  /* device in slot */
-			rc = pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(device, 0), 0x0B, &class_code);
-			if (rc)
-				return rc;
-
-			rc = pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(device, 0), PCI_HEADER_TYPE, &header_type);
-			if (rc)
-				return rc;
-
-			/* If multi-function device, set max_functions to 8 */
-			if (header_type & 0x80)
-				max_functions = 8;
-			else
-				max_functions = 1;
+		if (ID == 0xFFFFFFFF) {
+			if (is_hot_plug) {
+				/* Setup slot structure with entry for empty
+				 * slot
+				 */
+				new_slot = cpqhp_slot_create(busnumber);
+				if (new_slot == NULL)
+					return 1;
 
-			function = 0;
+				new_slot->bus = (u8) busnumber;
+				new_slot->device = (u8) device;
+				new_slot->function = 0;
+				new_slot->is_a_board = 0;
+				new_slot->presence_save = 0;
+				new_slot->switch_save = 0;
+			}
+			continue;
+		}
 
-			do {
-				DevError = 0;
-				if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
-					/* Recurse the subordinate bus
-					 * get the subordinate bus number
-					 */
-					rc = pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(device, function), PCI_SECONDARY_BUS, &secondary_bus);
-					if (rc) {
-						return rc;
-					} else {
-						sub_bus = (int) secondary_bus;
+		rc = pci_bus_read_config_byte(ctrl->pci_bus, PCI_DEVFN(device, 0), 0x0B, &class_code);
+		if (rc)
+			return rc;
 
-						/* Save secondary bus cfg spc
-						 * with this recursive call.
-						 */
-						rc = cpqhp_save_config(ctrl, sub_bus, 0);
-						if (rc)
-							return rc;
-						ctrl->pci_bus->number = busnumber;
-					}
-				}
+		rc = pci_bus_read_config_byte(ctrl->pci_bus, PCI_DEVFN(device, 0), PCI_HEADER_TYPE, &header_type);
+		if (rc)
+			return rc;
 
-				index = 0;
-				new_slot = cpqhp_slot_find(busnumber, device, index++);
-				while (new_slot &&
-				       (new_slot->function != (u8) function))
-					new_slot = cpqhp_slot_find(busnumber, device, index++);
+		/* If multi-function device, set max_functions to 8 */
+		if (header_type & 0x80)
+			max_functions = 8;
+		else
+			max_functions = 1;
 
-				if (!new_slot) {
-					/* Setup slot structure. */
-					new_slot = cpqhp_slot_create(busnumber);
+		function = 0;
 
-					if (new_slot == NULL)
-						return(1);
-				}
+		do {
+			DevError = 0;
+			if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
+				/* Recurse the subordinate bus
+				 * get the subordinate bus number
+				 */
+				rc = pci_bus_read_config_byte(ctrl->pci_bus, PCI_DEVFN(device, function), PCI_SECONDARY_BUS, &secondary_bus);
+				if (rc) {
+					return rc;
+				} else {
+					sub_bus = (int) secondary_bus;
 
-				new_slot->bus = (u8) busnumber;
-				new_slot->device = (u8) device;
-				new_slot->function = (u8) function;
-				new_slot->is_a_board = 1;
-				new_slot->switch_save = 0x10;
-				/* In case of unsupported board */
-				new_slot->status = DevError;
-				new_slot->pci_dev = pci_find_slot(new_slot->bus, (new_slot->device << 3) | new_slot->function);
-
-				for (cloop = 0; cloop < 0x20; cloop++) {
-					rc = pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(device, function), cloop << 2, (u32 *) & (new_slot-> config_space [cloop]));
+					/* Save secondary bus cfg spc
+					 * with this recursive call.
+					 */
+					rc = cpqhp_save_config(ctrl, sub_bus, 0);
 					if (rc)
 						return rc;
+					ctrl->pci_bus->number = busnumber;
 				}
+			}
 
-				function++;
+			index = 0;
+			new_slot = cpqhp_slot_find(busnumber, device, index++);
+			while (new_slot &&
+			       (new_slot->function != (u8) function))
+				new_slot = cpqhp_slot_find(busnumber, device, index++);
 
-				stop_it = 0;
+			if (!new_slot) {
+				/* Setup slot structure. */
+				new_slot = cpqhp_slot_create(busnumber);
+				if (new_slot == NULL)
+					return 1;
+			}
 
-				/* this loop skips to the next present function
-				 * reading in Class Code and Header type.
-				 */
+			new_slot->bus = (u8) busnumber;
+			new_slot->device = (u8) device;
+			new_slot->function = (u8) function;
+			new_slot->is_a_board = 1;
+			new_slot->switch_save = 0x10;
+			/* In case of unsupported board */
+			new_slot->status = DevError;
+			new_slot->pci_dev = pci_find_slot(new_slot->bus, (new_slot->device << 3) | new_slot->function);
+
+			for (cloop = 0; cloop < 0x20; cloop++) {
+				rc = pci_bus_read_config_dword(ctrl->pci_bus, PCI_DEVFN(device, function), cloop << 2, (u32 *) & (new_slot-> config_space [cloop]));
+				if (rc)
+					return rc;
+			}
 
-				while ((function < max_functions)&&(!stop_it)) {
-					rc = pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(device, function), PCI_VENDOR_ID, &ID);
-					if (ID == 0xFFFFFFFF) {	 /* nothing there. */
-						function++;
-					} else {  /* Something there */
-						rc = pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(device, function), 0x0B, &class_code);
-						if (rc)
-							return rc;
+			function++;
 
-						rc = pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(device, function), PCI_HEADER_TYPE, &header_type);
-						if (rc)
-							return rc;
+			stop_it = 0;
 
-						stop_it++;
-					}
+			/* this loop skips to the next present function
+			 * reading in Class Code and Header type.
+			 */
+			while ((function < max_functions) && (!stop_it)) {
+				rc = pci_bus_read_config_dword(ctrl->pci_bus, PCI_DEVFN(device, function), PCI_VENDOR_ID, &ID);
+				if (ID == 0xFFFFFFFF) {
+					function++;
+					continue;
 				}
+				rc = pci_bus_read_config_byte(ctrl->pci_bus, PCI_DEVFN(device, function), 0x0B, &class_code);
+				if (rc)
+					return rc;
 
-			} while (function < max_functions);
-		}		/* End of IF (device in slot?) */
-		else if (is_hot_plug) {
-			/* Setup slot structure with entry for empty slot */
-			new_slot = cpqhp_slot_create(busnumber);
+				rc = pci_bus_read_config_byte(ctrl->pci_bus, PCI_DEVFN(device, function), PCI_HEADER_TYPE, &header_type);
+				if (rc)
+					return rc;
 
-			if (new_slot == NULL) {
-				return(1);
+				stop_it++;
 			}
 
-			new_slot->bus = (u8) busnumber;
-			new_slot->device = (u8) device;
-			new_slot->function = 0;
-			new_slot->is_a_board = 0;
-			new_slot->presence_save = 0;
-			new_slot->switch_save = 0;
-		}
+		} while (function < max_functions);
 	}			/* End of FOR loop */
 
-	return(0);
+	return 0;
 }
 
 

