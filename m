Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbXGWOvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbXGWOvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbXGWOvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:51:41 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42139 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756639AbXGWOvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:51:40 -0400
Date: Mon, 23 Jul 2007 16:51:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: gregkh@suse.de, kristen.c.accardi@intel.com
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [2.6 patch] cpqphp_ctrl.c: remove dead code
Message-ID: <20070723145105.GK26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If !mem_node we did already return -ENOMEM above in the function.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/pci/hotplug/cpqphp_ctrl.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

--- linux-2.6.22-rc6-mm1/drivers/pci/hotplug/cpqphp_ctrl.c.old	2007-07-23 15:13:27.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/pci/hotplug/cpqphp_ctrl.c	2007-07-23 15:15:22.000000000 +0200
@@ -2558,29 +2558,15 @@ static int configure_new_function(struct
 			hold_IO_node = NULL;
 		}
 
-		/* If we have memory resources copy them and fill in the
-		 * bridge's memory range registers.  Otherwise, fill in the
-		 * range registers with values that disable them. */
-		if (mem_node) {
-			memcpy(hold_mem_node, mem_node, sizeof(struct pci_resource));
-			mem_node->next = NULL;
-
-			/* set Mem base and Limit registers */
-			temp_word = mem_node->base >> 16;
-			rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_BASE, temp_word);
+		memcpy(hold_mem_node, mem_node, sizeof(struct pci_resource));
+		mem_node->next = NULL;
 
-			temp_word = (mem_node->base + mem_node->length - 1) >> 16;
-			rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, temp_word);
-		} else {
-			temp_word = 0xFFFF;
-			rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_BASE, temp_word);
-
-			temp_word = 0x0000;
-			rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, temp_word);
+		/* set Mem base and Limit registers */
+		temp_word = mem_node->base >> 16;
+		rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_BASE, temp_word);
 
-			kfree(hold_mem_node);
-			hold_mem_node = NULL;
-		}
+		temp_word = (mem_node->base + mem_node->length - 1) >> 16;
+		rc = pci_bus_write_config_word(pci_bus, devfn, PCI_MEMORY_LIMIT, temp_word);
 
 		memcpy(hold_p_mem_node, p_mem_node, sizeof(struct pci_resource));
 		p_mem_node->next = NULL;

