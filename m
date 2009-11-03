Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZKCWF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZKCWF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbZKCWF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:05:57 -0500
Received: from brmea-mail-4.Sun.COM ([192.18.98.36]:36674 "EHLO
	brmea-mail-4.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbZKCWF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:05:56 -0500
X-Greylist: delayed 1208 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 17:05:56 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19184.41676.262206.134000@gargle.gargle.HOWL>
Date: Tue, 3 Nov 2009 16:38:20 -0500
From: RDH <rdh@east.sun.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pci/pcie: Avoid unnecessary PCIe link retrains
X-Mailer: VM 7.19 under Emacs 20.3.1
Reply-To: rdh@east.sun.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch avoids unnecessary PCIe link retraining sequences within
the PCIe ASPM common clock setup code by issuing a link retrain
command only if we are actually changing the PCIe clock configuration.

Signed-off-by: Robert D. Houk <rdh@East.Sun.COM>
---
 aspm.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
--- a/drivers/pci/pcie/aspm.c	2009-10-15 20:41:50.000000000 -0400
+++ b/drivers/pci/pcie/aspm.c	2009-11-02 14:29:35.000000000 -0500
@@ -183,6 +183,7 @@ static void pcie_aspm_configure_common_c
 {
 	int ppos, cpos, same_clock = 1;
 	u16 reg16, parent_reg, child_reg[8];
+	u16 lnkctl_ccc_or, lnkctl_ccc_and;
 	unsigned long start_jiffies;
 	struct pci_dev *child, *parent = link->pdev;
 	struct pci_bus *linkbus = parent->subordinate;
@@ -205,6 +206,25 @@ static void pcie_aspm_configure_common_c
 	if (!(reg16 & PCI_EXP_LNKSTA_SLC))
 		same_clock = 0;
 
+	/* Check upstream component for Common Clock Config */
+	pci_read_config_word(parent, ppos + PCI_EXP_LNKCTL, &reg16);
+	lnkctl_ccc_and = lnkctl_ccc_or = (reg16 & PCI_EXP_LNKCTL_CCC);
+
+	/* Scan downstream component for CCC, all functions */
+	list_for_each_entry(child, &linkbus->devices, bus_list) {
+		cpos = pci_find_capability(child, PCI_CAP_ID_EXP);
+		pci_read_config_word(child, cpos + PCI_EXP_LNKCTL, &reg16);
+		lnkctl_ccc_and &= (reg16 & PCI_EXP_LNKCTL_CCC);
+		lnkctl_ccc_or |= (reg16 & PCI_EXP_LNKCTL_CCC);
+	}
+
+	/* If we want Common Clock OFF and no device/function has it on */
+	/* or we want Common Clock ON and every device/function has it on */
+	/* then there is no need to retrain PCIe links */
+	if (((same_clock == 0) && (lnkctl_ccc_or == 0))
+            || ((same_clock == 1) && (lnkctl_ccc_and == PCI_EXP_LNKCTL_CCC)))
+		return;		/* Don't retrain link(s) */
+
 	/* Configure downstream component, all functions */
 	list_for_each_entry(child, &linkbus->devices, bus_list) {
 		cpos = pci_find_capability(child, PCI_CAP_ID_EXP);
