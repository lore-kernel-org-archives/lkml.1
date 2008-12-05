Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbYLENHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbYLENHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbYLENHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:07:19 -0500
Received: from mail.suse.de ([195.135.220.2]:37184 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190AbYLENHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:07:18 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: linux-kernel@vger.kernel.org
Subject: [PATCH] PCIe ASPM causes machine (HP Compaq 6735s) to sometimes freeze hard at boot at PCI initialization time
Date: Fri, 5 Dec 2008 14:07:13 +0100
User-Agent: KMail/1.9.9
Cc: jbarnes@virtuousgeek.org, shaohua.li@intel.com,
       Rafael Wysocki <rwysocki@suse.de>, shemminger@linux-foundation.org,
       netdev@vger.kernel.org, Stable@kernel.org
References: <200811281328.55259.trenn@suse.de>
In-Reply-To: <200811281328.55259.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812051407.14419.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is intended for review by someone with more PCI experience, first.

If it is considered as safe as I think it is :), it would be great if
this can be picked up ang go into stable kernels as well if the
feedback is positive (just checked with .25, the patch still
patches there, even without offset).

Thanks,

    Thomas


PCIE: Break out of endless loop waiting for PCI config bits to switch

Makes a Compaq 6735s boot reliably again which hang in the loop
on some boots.

Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/pci/pcie/aspm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6.27/drivers/pci/pcie/aspm.c
===================================================================
--- linux-2.6.27.orig/drivers/pci/pcie/aspm.c
+++ linux-2.6.27/drivers/pci/pcie/aspm.c
@@ -165,6 +165,7 @@ static void pcie_aspm_configure_common_c
 	u16 reg16 = 0;
 	struct pci_dev *child_dev;
 	int same_clock = 1;
+	int loop_count = 0;
 
 	/*
 	 * all functions of a slot should have the same Slot Clock
@@ -212,12 +213,15 @@ static void pcie_aspm_configure_common_c
 	pci_write_config_word(pdev, pos + PCI_EXP_LNKCTL, reg16);
 
 	/* Wait for link training end */
-	while (1) {
+	while (loop_count < 100) {
 		pci_read_config_word(pdev, pos + PCI_EXP_LNKSTA, &reg16);
 		if (!(reg16 & PCI_EXP_LNKSTA_LT))
 			break;
 		cpu_relax();
+		loop_count++;
 	}
+	if (loop_count == 100) 
+		dev_printk (KERN_WARNING, &pdev->dev, "Could not configure ASPM\n");
 }
 
 /*
