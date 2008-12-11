Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbYLKTo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbYLKTo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbYLKTTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:30 -0500
Received: from kroah.org ([198.145.64.141]:56699 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757138AbYLKTTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:25 -0500
Date: Thu, 11 Dec 2008 11:16:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Thomas Renninger <trenn@suse.de>,
       Shaohua Li <shaohua.li@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 73/83] PCIe: ASPM: Break out of endless loop waiting for
	PCI config bits to switch
Message-ID: <20081211191630.GU5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pcie-aspm-break-out-of-endless-loop-waiting-for-pci-config-bits-to-switch.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Renninger <trenn@suse.de>

commit 2a42d9dba7842422ffb2c02e75288a8bc2fd5065 upstream.

Makes a Compaq 6735s boot reliably again.  It used to hang in the loop
on some boots.  Give the link one second to train, otherwise break out
of the loop and reset the previously set clock bits.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/aspm.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
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
+	unsigned long start_jiffies;
+	u16 child_regs[8], parent_reg;
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
@@ -212,12 +217,30 @@ static void pcie_aspm_configure_common_c
 	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
 
 	/* Wait for link training end */
-	while (1) {
+	/* break out after waiting for 1 second */
+	start_jiffies = jiffies;
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

