Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYLHPST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYLHPST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYLHPRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:17:55 -0500
Received: from ns2.suse.de ([195.135.220.15]:37066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbYLHPRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:17:54 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] PCIe ASPM causes machine (HP Compaq 6735s) to sometimes freeze hard at boot at PCI initialization time
Date: Mon, 8 Dec 2008 16:17:50 +0100
User-Agent: KMail/1.9.9
Cc: Shaohua Li <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Rafael Wysocki <rwysocki@suse.de>,
       "shemminger@linux-foundation.org" <shemminger@linux-foundation.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "Stable@kernel.org" <Stable@kernel.org>
References: <200811281328.55259.trenn@suse.de> <200812081604.09996.trenn@suse.de> <20081208150919.GA1155@srcf.ucam.org>
In-Reply-To: <20081208150919.GA1155@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812081617.52047.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2008 16:09:19 Matthew Garrett wrote:
> On Mon, Dec 08, 2008 at 04:04:09PM +0100, Thomas Renninger wrote:
> > -	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
> > +	parent_reg = pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
>
> I don't think that does what you think it does :)

Hehe, thanks for the quick and detailed review!

This one should be better:

PCIe: ASPM: Break out of endless loop waiting for PCI config bits to switch

Makes a Compaq 6735s boot reliably again which hang in the loop
on some boots.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/pci/pcie/aspm.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

Index: linux-2.6.27/drivers/pci/pcie/aspm.c
===================================================================
--- linux-2.6.27.orig/drivers/pci/pcie/aspm.c
+++ linux-2.6.27/drivers/pci/pcie/aspm.c
@@ -16,6 +16,7 @@
 #include <linux/pm.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/jiffies.h>
 #include <linux/pci-aspm.h>
 #include "../pci.h"
 
@@ -161,11 +162,12 @@ static void pcie_check_clock_pm(struct p
  */
 static void pcie_aspm_configure_common_clock(struct pci_dev *pdev)
 {
-	int pos, child_pos;
+	int pos, child_pos, i = 0;
 	u16 reg16 = 0;
 	struct pci_dev *child_dev;
 	int same_clock = 1;
-
+	unsigned long start_jiffies = jiffies;
+	u16 child_regs[256], parent_reg;
 	/*
 	 * all functions of a slot should have the same Slot Clock
 	 * Configuration, so just check one function
@@ -191,16 +193,19 @@ static void pcie_aspm_configure_common_c
 		child_pos = pci_find_capability(child_dev, PCI_CAP_ID_EXP);
 		pci_read_config_word(child_dev, child_pos + PCI_EXP_LNKCTL,
 			&reg16);
+		child_regs[i] = reg16;
 		if (same_clock)
 			reg16 |= PCI_EXP_LNKCTL_CCC;
 		else
 			reg16 &= ~PCI_EXP_LNKCTL_CCC;
 		pci_write_config_word(child_dev, child_pos + PCI_EXP_LNKCTL,
 			reg16);
+		i++;
 	}
 
 	/* Configure upstream component */
 	pci_read_config_word(pdev, pos + PCI_EXP_LNKCTL, &reg16);
+	parent_reg = reg16;
 	if (same_clock)
 		reg16 |= PCI_EXP_LNKCTL_CCC;
 	else
@@ -212,12 +217,29 @@ static void pcie_aspm_configure_common_c
 	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
 
 	/* Wait for link training end */
-	while (1) {
+	/* break out after waiting for 1 second */
+	while ((jiffies - start_jiffies) < HZ) {
 		pci_read_config_word(pdev, pos + PCI_EXP_LNKSTA, &reg16);
 		if (!(reg16 & PCI_EXP_LNKSTA_LT))
 			break;
 		cpu_relax();
 	}
+	/* training failed -> recover */
+	if ((jiffies - start_jiffies) >= HZ) {
+		dev_printk (KERN_ERR, &pdev->dev, "ASPM: Could not configure"
+			    " common clock\n");
+		i = 0;
+		list_for_each_entry(child_dev, &pdev->subordinate->devices,
+				    bus_list) {
+			child_pos = pci_find_capability(child_dev,
+							PCI_CAP_ID_EXP);
+			pci_write_config_word(child_dev,
+					      child_pos + PCI_EXP_LNKCTL,
+					      child_regs[i]);
+			i++;
+		}
+		pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, parent_reg);
+	}
 }
 
 /*
