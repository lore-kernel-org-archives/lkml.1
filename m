Return-Path: <linux-kernel-owner+w=401wt.eu-S1762790AbZCaP0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762790AbZCaP0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762327AbZCaPXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:23:52 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:34455 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762260AbZCaPXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:23:50 -0400
Subject: [PATCH 08/15] PCI Hotplug: cpqphp: refactor cpqphp_save_slot_config
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:23:46 -0600
Message-ID: <20090331152346.26622.59422.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for an empty slot, and return early if so.

This allows us to un-indent the rest of the function by one level.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp_pci.c |   85 +++++++++++++++++---------------------
 1 files changed, 39 insertions(+), 46 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index 2e96bae..1f1c90d 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -494,7 +494,7 @@ int cpqhp_save_slot_config (struct controller *ctrl, struct pci_func * new_slot)
 	u8 secondary_bus;
 	int sub_bus;
 	int max_functions;
-	int function;
+	int function = 0;
 	int cloop = 0;
 	int stop_it;
 
@@ -503,65 +503,58 @@ int cpqhp_save_slot_config (struct controller *ctrl, struct pci_func * new_slot)
 	ctrl->pci_bus->number = new_slot->bus;
 	pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(new_slot->device, 0), PCI_VENDOR_ID, &ID);
 
-	if (ID != 0xFFFFFFFF) {	  /*  device in slot */
-		pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(new_slot->device, 0), 0x0B, &class_code);
-		pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(new_slot->device, 0), PCI_HEADER_TYPE, &header_type);
-
-		if (header_type & 0x80)	/* Multi-function device */
-			max_functions = 8;
-		else
-			max_functions = 1;
-
-		function = 0;
+	if (ID == 0xFFFFFFFF)
+		return 2;
 
-		do {
-			if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
-				/*  Recurse the subordinate bus */
-				pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), PCI_SECONDARY_BUS, &secondary_bus);
+	pci_bus_read_config_byte(ctrl->pci_bus, PCI_DEVFN(new_slot->device, 0), 0x0B, &class_code);
+	pci_bus_read_config_byte(ctrl->pci_bus, PCI_DEVFN(new_slot->device, 0), PCI_HEADER_TYPE, &header_type);
 
-				sub_bus = (int) secondary_bus;
+	if (header_type & 0x80)	/* Multi-function device */
+		max_functions = 8;
+	else
+		max_functions = 1;
 
-				/* Save the config headers for the secondary
-				 * bus.
-				 */
-				rc = cpqhp_save_config(ctrl, sub_bus, 0);
-				if (rc)
-					return(rc);
-				ctrl->pci_bus->number = new_slot->bus;
+	while (function < max_functions) {
+		if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
+			/*  Recurse the subordinate bus */
+			pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), PCI_SECONDARY_BUS, &secondary_bus);
 
-			}	/* End of IF */
+			sub_bus = (int) secondary_bus;
 
-			new_slot->status = 0;
+			/* Save the config headers for the secondary
+			 * bus.
+			 */
+			rc = cpqhp_save_config(ctrl, sub_bus, 0);
+			if (rc)
+				return(rc);
+			ctrl->pci_bus->number = new_slot->bus;
 
-			for (cloop = 0; cloop < 0x20; cloop++) {
-				pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), cloop << 2, (u32 *) & (new_slot-> config_space [cloop]));
-			}
+		}
 
-			function++;
+		new_slot->status = 0;
 
-			stop_it = 0;
+		for (cloop = 0; cloop < 0x20; cloop++)
+			pci_bus_read_config_dword(ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), cloop << 2, (u32 *) & (new_slot-> config_space [cloop]));
 
-			/* this loop skips to the next present function
-			 * reading in the Class Code and the Header type.
-			 */
-			while ((function < max_functions) && (!stop_it)) {
-				pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), PCI_VENDOR_ID, &ID);
+		function++;
 
-				if (ID == 0xFFFFFFFF) {	 /* nothing there. */
-					function++;
-				} else {  /* Something there */
-					pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), 0x0B, &class_code);
+		stop_it = 0;
 
-					pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), PCI_HEADER_TYPE, &header_type);
+		/* this loop skips to the next present function
+		 * reading in the Class Code and the Header type.
+		 */
+		while ((function < max_functions) && (!stop_it)) {
+			pci_bus_read_config_dword(ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), PCI_VENDOR_ID, &ID);
 
-					stop_it++;
-				}
+			if (ID == 0xFFFFFFFF)
+				function++;
+			else {
+				pci_bus_read_config_byte(ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), 0x0B, &class_code);
+				pci_bus_read_config_byte(ctrl->pci_bus, PCI_DEVFN(new_slot->device, function), PCI_HEADER_TYPE, &header_type);
+				stop_it++;
 			}
+		}
 
-		} while (function < max_functions);
-	}			/* End of IF (device in slot?) */
-	else {
-		return 2;
 	}
 
 	return 0;

