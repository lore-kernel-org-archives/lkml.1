Return-Path: <linux-kernel-owner+w=401wt.eu-S934439AbXEOMDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934439AbXEOMDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbXEOMDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:03:18 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:20882 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758815AbXEOMDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:03:16 -0400
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
From: "Peter Oruba" <peter.oruba@amd.com>
Organization: AMD
To: gregkh@suse.de
Subject: [PATCH 2/2] PCI-X/PCI-Express read control interfaces
Date: Tue, 15 May 2007 14:03:06 +0200
User-Agent: KMail/1.9.6
cc: cramerj@intel.com, john.ronciak@intel.com, jesse.brandeburg@intel.com,
       jeffrey.t.kirsher@intel.com, auke-jan.h.kok@intel.com,
       rolandd@cisco.com, halr@voltaire.com, linux-driver@qlogic.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
References: <200705151350.28330.peter.oruba@amd.com>
In-Reply-To: <200705151350.28330.peter.oruba@amd.com>
MIME-Version: 1.0
Message-ID: <200705151403.07646.peter.oruba@amd.com>
X-OriginalArrivalTime: 15 May 2007 12:02:31.0239 (UTC)
 FILETIME=[EA649D70:01C796E8]
X-WSS-ID: 6A577EFC1GC2357613-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These driver changes incorporate the proposed PCI-X / PCI-Express read byte 
count interface. Reading and setting those valuse doesn't take 
place "manually", instead wrapping functions are called to allow quirks for 
some PCI bridges.

Signed-off by: Peter Oruba <peter.oruba@amd.com>
Based on work by Stephen Hemminger <shemminger@linux-foundation.org>

---
diff -uprN -X linux-2.6.22-rc1.orig/Documentation/dontdiff 
linux-2.6.22-rc1.orig/drivers/infiniband/hw/mthca/mthca_main.c 
linux-2.6.22-rc1/drivers/infiniband/hw/mthca/mthca_main.c
--- linux-2.6.22-rc1.orig/drivers/infiniband/hw/mthca/mthca_main.c	2007-05-14 
11:29:29.358547000 +0200
+++ linux-2.6.22-rc1/drivers/infiniband/hw/mthca/mthca_main.c	2007-05-15 
10:55:24.954074000 +0200
@@ -137,45 +137,27 @@ static const char mthca_version[] __devi
 
 static int mthca_tune_pci(struct mthca_dev *mdev)
 {
-	int cap;
-	u16 val;
-
 	if (!tune_pci)
 		return 0;
 
 	/* First try to max out Read Byte Count */
-	cap = pci_find_capability(mdev->pdev, PCI_CAP_ID_PCIX);
-	if (cap) {
-		if (pci_read_config_word(mdev->pdev, cap + PCI_X_CMD, &val)) {
-			mthca_err(mdev, "Couldn't read PCI-X command register, "
-				  "aborting.\n");
-			return -ENODEV;
-		}
-		val = (val & ~PCI_X_CMD_MAX_READ) | (3 << 2);
-		if (pci_write_config_word(mdev->pdev, cap + PCI_X_CMD, val)) {
-			mthca_err(mdev, "Couldn't write PCI-X command register, "
-				  "aborting.\n");
+	if (pci_find_capability(mdev->pdev, PCI_CAP_ID_PCIX)) {
+		if (pcix_set_mmrbc(mdev->pdev, pcix_get_max_mmrbc(mdev->pdev))) {
+			mthca_err(mdev, "Couldn't set PCI-X max read count, "
+				"aborting.\n");
 			return -ENODEV;
 		}
 	} else if (!(mdev->mthca_flags & MTHCA_FLAG_PCIE))
 		mthca_info(mdev, "No PCI-X capability, not setting RBC.\n");
 
-	cap = pci_find_capability(mdev->pdev, PCI_CAP_ID_EXP);
-	if (cap) {
-		if (pci_read_config_word(mdev->pdev, cap + PCI_EXP_DEVCTL, &val)) {
-			mthca_err(mdev, "Couldn't read PCI Express device control "
-				  "register, aborting.\n");
-			return -ENODEV;
-		}
-		val = (val & ~PCI_EXP_DEVCTL_READRQ) | (5 << 12);
-		if (pci_write_config_word(mdev->pdev, cap + PCI_EXP_DEVCTL, val)) {
-			mthca_err(mdev, "Couldn't write PCI Express device control "
-				  "register, aborting.\n");
+	if (pci_find_capability(mdev->pdev, PCI_CAP_ID_EXP)) {
+		if (pcie_set_readrq(mdev->pdev, 4096)) {
+			mthca_err(mdev, "Couldn't write PCI Express read request, "
+				"aborting.\n");
 			return -ENODEV;
 		}
-	} else if (mdev->mthca_flags & MTHCA_FLAG_PCIE)
-		mthca_info(mdev, "No PCI Express capability, "
-			   "not setting Max Read Request Size.\n");
+	} else if (!(mdev->mthca_flags & MTHCA_FLAG_PCIE))
+		mthca_info(mdev, "No PCI-X capability, not setting RBC.\n");
 
 	return 0;
 }
diff -uprN -X linux-2.6.22-rc1.orig/Documentation/dontdiff 
linux-2.6.22-rc1.orig/drivers/net/e1000/e1000_hw.c 
linux-2.6.22-rc1/drivers/net/e1000/e1000_hw.c
--- linux-2.6.22-rc1.orig/drivers/net/e1000/e1000_hw.c	2007-04-26 
05:08:32.000000000 +0200
+++ linux-2.6.22-rc1/drivers/net/e1000/e1000_hw.c	2007-05-15 
11:07:24.726991000 +0200
@@ -865,10 +865,6 @@ e1000_init_hw(struct e1000_hw *hw)
     uint32_t ctrl;
     uint32_t i;
     int32_t ret_val;
-    uint16_t pcix_cmd_word;
-    uint16_t pcix_stat_hi_word;
-    uint16_t cmd_mmrbc;
-    uint16_t stat_mmrbc;
     uint32_t mta_size;
     uint32_t reg_data;
     uint32_t ctrl_ext;
@@ -958,24 +954,9 @@ e1000_init_hw(struct e1000_hw *hw)
         break;
     default:
         /* Workaround for PCI-X problem when BIOS sets MMRBC incorrectly. */
-        if (hw->bus_type == e1000_bus_type_pcix) {
-            e1000_read_pci_cfg(hw, PCIX_COMMAND_REGISTER, &pcix_cmd_word);
-            e1000_read_pci_cfg(hw, PCIX_STATUS_REGISTER_HI,
-                &pcix_stat_hi_word);
-            cmd_mmrbc = (pcix_cmd_word & PCIX_COMMAND_MMRBC_MASK) >>
-                PCIX_COMMAND_MMRBC_SHIFT;
-            stat_mmrbc = (pcix_stat_hi_word & PCIX_STATUS_HI_MMRBC_MASK) >>
-                PCIX_STATUS_HI_MMRBC_SHIFT;
-            if (stat_mmrbc == PCIX_STATUS_HI_MMRBC_4K)
-                stat_mmrbc = PCIX_STATUS_HI_MMRBC_2K;
-            if (cmd_mmrbc > stat_mmrbc) {
-                pcix_cmd_word &= ~PCIX_COMMAND_MMRBC_MASK;
-                pcix_cmd_word |= stat_mmrbc << PCIX_COMMAND_MMRBC_SHIFT;
-                e1000_write_pci_cfg(hw, PCIX_COMMAND_REGISTER,
-                    &pcix_cmd_word);
-            }
-        }
-        break;
+	if (hw->bus_type == e1000_bus_type_pcix && e1000_pcix_get_mmrbc(hw) > 2048)
+		e1000_pcix_set_mmrbc(hw, 2048);
+	break;
     }
 
     /* More time needed for PHY to initialize */
diff -uprN -X linux-2.6.22-rc1.orig/Documentation/dontdiff 
linux-2.6.22-rc1.orig/drivers/net/e1000/e1000_hw.h 
linux-2.6.22-rc1/drivers/net/e1000/e1000_hw.h
--- linux-2.6.22-rc1.orig/drivers/net/e1000/e1000_hw.h	2007-04-26 
05:08:32.000000000 +0200
+++ linux-2.6.22-rc1/drivers/net/e1000/e1000_hw.h	2007-05-15 
11:10:17.115782000 +0200
@@ -424,6 +424,8 @@ void e1000_pci_clear_mwi(struct e1000_hw
 void e1000_read_pci_cfg(struct e1000_hw *hw, uint32_t reg, uint16_t * value);
 void e1000_write_pci_cfg(struct e1000_hw *hw, uint32_t reg, uint16_t * 
value);
 int32_t e1000_read_pcie_cap_reg(struct e1000_hw *hw, uint32_t reg, uint16_t 
*value);
+void e1000_pcix_set_mmrbc(struct e1000_hw *hw, int mmrbc);
+int e1000_pcix_get_mmrbc(struct e1000_hw *hw);
 /* Port I/O is only supported on 82544 and newer */
 void e1000_io_write(struct e1000_hw *hw, unsigned long port, uint32_t value);
 int32_t e1000_disable_pciex_master(struct e1000_hw *hw);
diff -uprN -X linux-2.6.22-rc1.orig/Documentation/dontdiff 
linux-2.6.22-rc1.orig/drivers/net/e1000/e1000_main.c 
linux-2.6.22-rc1/drivers/net/e1000/e1000_main.c
--- linux-2.6.22-rc1.orig/drivers/net/e1000/e1000_main.c	2007-05-14 
11:29:35.324875000 +0200
+++ linux-2.6.22-rc1/drivers/net/e1000/e1000_main.c	2007-05-15 
11:10:18.358679000 +0200
@@ -4912,6 +4912,20 @@ e1000_write_pci_cfg(struct e1000_hw *hw,
 	pci_write_config_word(adapter->pdev, reg, *value);
 }
 
+int
+e1000_pcix_get_mmrbc(struct e1000_hw *hw)
+{
+	struct e1000_adapter *adapter = hw->back;
+	return pcix_get_mmrbc(adapter->pdev);
+}
+
+void
+e1000_pcix_set_mmrbc(struct e1000_hw *hw, int mmrbc)
+{
+	struct e1000_adapter *adapter = hw->back;
+	pcix_set_mmrbc(adapter->pdev, mmrbc);
+}
+
 int32_t
 e1000_read_pcie_cap_reg(struct e1000_hw *hw, uint32_t reg, uint16_t *value)
 {
diff -uprN -X linux-2.6.22-rc1.orig/Documentation/dontdiff 
linux-2.6.22-rc1.orig/drivers/net/myri10ge/myri10ge.c 
linux-2.6.22-rc1/drivers/net/myri10ge/myri10ge.c
--- linux-2.6.22-rc1.orig/drivers/net/myri10ge/myri10ge.c	2007-05-14 
11:29:36.235781000 +0200
+++ linux-2.6.22-rc1/drivers/net/myri10ge/myri10ge.c	2007-05-15 
11:10:18.974579000 +0200
@@ -2873,8 +2873,7 @@ static int myri10ge_probe(struct pci_dev
 			status);
 		goto abort_with_netdev;
 	}
-	val = (val & ~PCI_EXP_DEVCTL_READRQ) | (5 << 12);
-	status = pci_write_config_word(pdev, cap + PCI_EXP_DEVCTL, val);
+	status = pcie_set_readrq(pdev, 4096);
 	if (status != 0) {
 		dev_err(&pdev->dev, "Error %d writing PCI_EXP_DEVCTL\n",
 			status);
diff -uprN -X linux-2.6.22-rc1.orig/Documentation/dontdiff 
linux-2.6.22-rc1.orig/drivers/scsi/qla2xxx/qla_init.c 
linux-2.6.22-rc1/drivers/scsi/qla2xxx/qla_init.c
--- linux-2.6.22-rc1.orig/drivers/scsi/qla2xxx/qla_init.c	2007-05-14 
11:29:41.561311000 +0200
+++ linux-2.6.22-rc1/drivers/scsi/qla2xxx/qla_init.c	2007-05-15 
10:39:29.636747000 +0200
@@ -281,15 +281,9 @@ qla24xx_pci_config(scsi_qla_host_t *ha)
 
 	/* PCIe -- adjust Maximum Read Request Size (2048). */
 	pcie_dctl_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
-	if (pcie_dctl_reg) {
-		uint16_t pcie_dctl;
-
-		pcie_dctl_reg += PCI_EXP_DEVCTL;
-		pci_read_config_word(ha->pdev, pcie_dctl_reg, &pcie_dctl);
-		pcie_dctl &= ~PCI_EXP_DEVCTL_READRQ;
-		pcie_dctl |= 0x4000;
-		pci_write_config_word(ha->pdev, pcie_dctl_reg, pcie_dctl);
-	}
+	if (pcie_dctl_reg)
+		if (pcie_set_readrq(ha->pdev, 2048))
+			DEBUG2(printk("Couldn't write PCI Express read request\n"));
 
 	/* Reset expansion ROM address decode enable */
 	pci_read_config_dword(ha->pdev, PCI_ROM_ADDRESS, &d);

---

-- 
AMD Saxony Limited Liability Company & Co. KG
Operating System Research Center
Wilschdorfer Landstr. 101, 01109 Dresden, Germany
Register Court Dresden: HRA 4896
General Partner authorized to represent:
AMD Saxony LLC (Wilmington, Delaware, US)
General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


