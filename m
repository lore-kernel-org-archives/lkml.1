Return-Path: <linux-kernel-owner+w=401wt.eu-S1763009AbZCaP3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763009AbZCaP3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762517AbZCaPYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:24:22 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:12010 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762478AbZCaPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:24:19 -0400
Subject: [PATCH 14/15] PCI Hotplug: cpqphp: don't use pci_find_slot()
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:24:17 -0600
Message-ID: <20090331152417.26622.6063.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert uses of pci_find_slot to modern API.

In the conversion sites, we end up calling pci_dev_put() right away.

This may seem like it misses the entire point of doing something like
pci_get_bus_and_slot(), since we drop the reference so soon, but it turns
out we don't actually do much with the returned pci_dev.

I plan on untangling cpqphp further, but clearly cpqphp never worried too
much about a properly refcounted pci_dev anyway. For now, this conversion
seems reasonable, as it gets rid of the last in-tree caller of pci_find_slot.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/Kconfig      |    2 +-
 drivers/pci/hotplug/cpqphp_pci.c |   16 +++++++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
index 9aa4fe1..ac888cc 100644
--- a/drivers/pci/hotplug/Kconfig
+++ b/drivers/pci/hotplug/Kconfig
@@ -41,7 +41,7 @@ config HOTPLUG_PCI_FAKE
 
 config HOTPLUG_PCI_COMPAQ
 	tristate "Compaq PCI Hotplug driver"
-	depends on X86 && PCI_BIOS && PCI_LEGACY
+	depends on X86 && PCI_BIOS
 	help
 	  Say Y here if you have a motherboard with a Compaq PCI Hotplug
 	  controller.
diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index 3e3acc7..6173b9a 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -88,7 +88,7 @@ int cpqhp_configure_device (struct controller* ctrl, struct pci_func* func)
 	int num;
 
 	if (func->pci_dev == NULL)
-		func->pci_dev = pci_find_slot(func->bus, PCI_DEVFN(func->device, func->function));
+		func->pci_dev = pci_get_bus_and_slot(func->bus,PCI_DEVFN(func->device, func->function));
 
 	/* No pci device, we need to create it then */
 	if (func->pci_dev == NULL) {
@@ -98,7 +98,7 @@ int cpqhp_configure_device (struct controller* ctrl, struct pci_func* func)
 		if (num)
 			pci_bus_add_devices(ctrl->pci_dev->bus);
 
-		func->pci_dev = pci_find_slot(func->bus, PCI_DEVFN(func->device, func->function));
+		func->pci_dev = pci_get_bus_and_slot(func->bus, PCI_DEVFN(func->device, func->function));
 		if (func->pci_dev == NULL) {
 			dbg("ERROR: pci_dev still null\n");
 			return 0;
@@ -111,6 +111,8 @@ int cpqhp_configure_device (struct controller* ctrl, struct pci_func* func)
 		pci_do_scan_bus(child);
 	}
 
+	pci_dev_put(func->pci_dev);
+
 	return 0;
 }
 
@@ -122,9 +124,11 @@ int cpqhp_unconfigure_device(struct pci_func* func)
 	dbg("%s: bus/dev/func = %x/%x/%x\n", __func__, func->bus, func->device, func->function);
 
 	for (j=0; j<8 ; j++) {
-		struct pci_dev* temp = pci_find_slot(func->bus, PCI_DEVFN(func->device, j));
-		if (temp)
+		struct pci_dev* temp = pci_get_bus_and_slot(func->bus, PCI_DEVFN(func->device, j));
+		if (temp) {
+			pci_dev_put(temp);
 			pci_remove_bus_device(temp);
+		}
 	}
 	return 0;
 }
@@ -406,7 +410,7 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 			new_slot->switch_save = 0x10;
 			/* In case of unsupported board */
 			new_slot->status = DevError;
-			new_slot->pci_dev = pci_find_slot(new_slot->bus, (new_slot->device << 3) | new_slot->function);
+			new_slot->pci_dev = pci_get_bus_and_slot(new_slot->bus, (new_slot->device << 3) | new_slot->function);
 
 			for (cloop = 0; cloop < 0x20; cloop++) {
 				rc = pci_bus_read_config_dword(ctrl->pci_bus, PCI_DEVFN(device, function), cloop << 2, (u32 *) & (new_slot-> config_space [cloop]));
@@ -414,6 +418,8 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 					return rc;
 			}
 
+			pci_dev_put(new_slot->pci_dev);
+
 			function++;
 
 			stop_it = 0;

