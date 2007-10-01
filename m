Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbXJADP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbXJADP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 23:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXJADPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 23:15:51 -0400
Received: from [222.122.15.10] ([222.122.15.10]:45369 "HELO geninetworks.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751341AbXJADPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 23:15:50 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sun, 30 Sep 2007 23:15:49 EDT
Subject: [PATCH] PCI hotplug : Switch to pci_get_bus_and_slot instead of
	deprecated pci_find_slot.
From: JoonwooPark <joonwpark81@gmail.com>
Reply-To: joonwpark81@gmail.com
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, kristen.c.accardi@intel.com
Content-Type: text/plain; charset=UTF-8
Organization: GeniNetworks
Date: Mon, 01 Oct 2007 12:09:07 +0900
Message-Id: <1191208147.6123.11.camel@joonwpark-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes these warnings:

drivers/pci/hotplug/cpqphp_pci.c: In function ‘cpqhp_configure_device’:
drivers/pci/hotplug/cpqphp_pci.c:92: warning: ‘pci_find_slot’ is deprecated (declared at include/linux/pci.h:481)
drivers/pci/hotplug/cpqphp_pci.c:102: warning: ‘pci_find_slot’ is deprecated (declared at include/linux/pci.h:481)
drivers/pci/hotplug/cpqphp_pci.c: In function ‘cpqhp_unconfigure_device’:
drivers/pci/hotplug/cpqphp_pci.c:126: warning: ‘pci_find_slot’ is deprecated (declared at include/linux/pci.h:481)
drivers/pci/hotplug/cpqphp_pci.c: In function ‘cpqhp_save_config’:
drivers/pci/hotplug/cpqphp_pci.c:420: warning: ‘pci_find_slot’ is deprecated (declared at include/linux/pci.h:481)

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 drivers/pci/hotplug/cpqphp_pci.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index fc7c74d..c05d34a 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -89,7 +89,7 @@ int cpqhp_configure_device (struct controller* ctrl, struct pci_func* func)
 	int num;
 
 	if (func->pci_dev == NULL)
-		func->pci_dev = pci_find_slot(func->bus, PCI_DEVFN(func->device, func->function));
+		func->pci_dev = pci_get_bus_and_slot(func->bus, PCI_DEVFN(func->device, func->function));
 
 	/* No pci device, we need to create it then */
 	if (func->pci_dev == NULL) {
@@ -99,7 +99,7 @@ int cpqhp_configure_device (struct controller* ctrl, struct pci_func* func)
 		if (num)
 			pci_bus_add_devices(ctrl->pci_dev->bus);
 
-		func->pci_dev = pci_find_slot(func->bus, PCI_DEVFN(func->device, func->function));
+		func->pci_dev = pci_get_bus_and_slot(func->bus, PCI_DEVFN(func->device, func->function));
 		if (func->pci_dev == NULL) {
 			dbg("ERROR: pci_dev still null\n");
 			return 0;
@@ -123,7 +123,7 @@ int cpqhp_unconfigure_device(struct pci_func* func)
 	dbg("%s: bus/dev/func = %x/%x/%x\n", __FUNCTION__, func->bus, func->device, func->function);
 
 	for (j=0; j<8 ; j++) {
-		struct pci_dev* temp = pci_find_slot(func->bus, PCI_DEVFN(func->device, j));
+		struct pci_dev *temp = pci_get_bus_and_slot(func->bus, PCI_DEVFN(func->device, j));
 		if (temp)
 			pci_remove_bus_device(temp);
 	}
@@ -417,7 +417,7 @@ int cpqhp_save_config(struct controller *ctrl, int busnumber, int is_hot_plug)
 				new_slot->switch_save = 0x10;
 				// In case of unsupported board
 				new_slot->status = DevError;
-				new_slot->pci_dev = pci_find_slot(new_slot->bus, (new_slot->device << 3) | new_slot->function);
+				new_slot->pci_dev = pci_get_bus_and_slot(new_slot->bus, (new_slot->device << 3) | new_slot->function);
 
 				for (cloop = 0; cloop < 0x20; cloop++) {
 					rc = pci_bus_read_config_dword (ctrl->pci_bus, PCI_DEVFN(device, function), cloop << 2, (u32 *) & (new_slot-> config_space [cloop]));
---

Thanks.
Joonwoo Park


