Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbXEPOjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbXEPOjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 10:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXEPOjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 10:39:49 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:20456 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753981AbXEPOjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 10:39:48 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
From: "Peter Oruba" <peter.oruba@amd.com>
Organization: AMD
To: "Andrew Vasquez" <andrew.vasquez@qlogic.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] PCI-X/PCI-Express read control interfaces -
 Patch correction
Date: Wed, 16 May 2007 16:39:59 +0200
User-Agent: KMail/1.9.6
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
References: <200705151350.28330.peter.oruba@amd.com>
 <20070515123721.1bfb02a3.akpm@linux-foundation.org>
 <20070515213531.GG29996@n7651av69tz181.qlogic.org>
In-Reply-To: <20070515213531.GG29996@n7651av69tz181.qlogic.org>
MIME-Version: 1.0
Message-ID: <200705161639.59591.peter.oruba@amd.com>
X-OriginalArrivalTime: 16 May 2007 14:39:16.0696 (UTC)
 FILETIME=[FAE53580:01C797C7]
X-WSS-ID: 6A55C82E20G2451110-02-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 15. Mai 2007 23:35:31 schrieb Andrew Vasquez:

> In general, if PCI-[Xe] capability structure exists do set-
> mmrbc()/readrq(), yet each of those pre-condition checks are already
> present in the pcix_set_mmrbc() and pcie_set_readrq().
> 
> At least for the qla2xxx case, the patch could easily distill down from:
> 
> 	...
> 	/* PCIe -- adjust Maximum Read Request Size (2048). */
> 	pcie_dctl_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
> 	if (pcie_dctl_reg)
> 		if (pcie_set_readrq(ha->pdev, 2048))
> 			DEBUG2(printk("Couldn't write PCI Express read request\n"));
> 
> to:
> 
> 	...
> 	pcie_set_readrq(ha->pdev, 2048);
> 
> 
> Whatever the decision, I can fold this into my next patchset for
> qla2xxx and submit.
> 
> 
> 

Sorry, I missed out an essential part in the qla2xxx driver, namely the MMRBC configuration for PCI-X. The submitted patch only did that for PCIe. This is the corrected version

The pre-condition check is there to not blindly call the mmrbc-functions, but to check for the bus type first. Indeed, the first patch version made this check look unnecessary.

Signed-off by: Peter Oruba <peter.oruba@amd.com>
Based on patch set by Stephen Hemminger <shemminger@linux-foundation.org>

---
--- linux-2.6.22-rc1.orig/drivers/scsi/qla2xxx/qla_init.c       2007-05-14 11:29:41.561311000 +0200
+++ linux-2.6.22-rc1/drivers/scsi/qla2xxx/qla_init.c    2007-05-16 16:08:47.811810000 +0200
@@ -269,27 +269,15 @@ qla24xx_pci_config(scsi_qla_host_t *ha)

        /* PCI-X -- adjust Maximum Memory Read Byte Count (2048). */
        pcix_cmd_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_PCIX);
-       if (pcix_cmd_reg) {
-               uint16_t pcix_cmd;
-
-               pcix_cmd_reg += PCI_X_CMD;
-               pci_read_config_word(ha->pdev, pcix_cmd_reg, &pcix_cmd);
-               pcix_cmd &= ~PCI_X_CMD_MAX_READ;
-               pcix_cmd |= 0x0008;
-               pci_write_config_word(ha->pdev, pcix_cmd_reg, pcix_cmd);
-       }
+       if (pcix_cmd_reg)
+               if (pcix_set_mmrbc(ha->pdev, 2048))
+                       DEBUG2(printk("Couldn't write PCI-X read request\n"));

        /* PCIe -- adjust Maximum Read Request Size (2048). */
        pcie_dctl_reg = pci_find_capability(ha->pdev, PCI_CAP_ID_EXP);
-       if (pcie_dctl_reg) {
-               uint16_t pcie_dctl;
-
-               pcie_dctl_reg += PCI_EXP_DEVCTL;
-               pci_read_config_word(ha->pdev, pcie_dctl_reg, &pcie_dctl);
-               pcie_dctl &= ~PCI_EXP_DEVCTL_READRQ;
-               pcie_dctl |= 0x4000;
-               pci_write_config_word(ha->pdev, pcie_dctl_reg, pcie_dctl);
-       }
+       if (pcie_dctl_reg)
+               if (pcie_set_readrq(ha->pdev, 2048))
+                       DEBUG2(printk("Couldn't write PCI Express read request\n"));

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


