Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZKPB4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZKPB4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 20:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZKPB4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 20:56:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:32982 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZKPB4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 20:56:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,748,1249282800"; 
   d="scan'208";a="569789426"
Date: Mon, 16 Nov 2009 09:56:05 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jgarzik@redhat.com, sean.hefty@intel.com
Subject: [PATCH]AHCI: disable sntf cap for ich8
Message-ID: <20091116015605.GA21717@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I obseved there is a sata_async_notification() for every ahci interrupt. But the
async notification does nothing (this is hard disk drive and no pmp). This cause
cpu wastes some time on sntf register access.

It appears ICH AHCI doesn't support SNotification register, but the controller
reports it does. After quirking it, the async notification disappears.

PS. it appears all ICH don't support SNotification register from ICH manual, don't
know if we need quirk all ICH. I don't have machines with all kinds of ICH.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/ata/ahci.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

Index: linux/drivers/ata/ahci.c
===================================================================
--- linux.orig/drivers/ata/ahci.c	2009-11-16 09:36:40.000000000 +0800
+++ linux/drivers/ata/ahci.c	2009-11-16 09:53:44.000000000 +0800
@@ -113,6 +113,7 @@ enum {
 	board_ahci_mcp65	= 6,
 	board_ahci_nopmp	= 7,
 	board_ahci_yesncq	= 8,
+	board_ahci_nosntf	= 9,
 
 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -235,6 +236,7 @@ enum {
 	AHCI_HFLAG_NO_SUSPEND		= (1 << 10), /* don't suspend */
 	AHCI_HFLAG_SRST_TOUT_IS_OFFLINE	= (1 << 11), /* treat SRST timeout as
 							link offline */
+	AHCI_HFLAG_NO_SNTF		= (1 << 12), /* no sntf */
 
 	/* ap->flags bits */
 
@@ -508,7 +510,7 @@ static const struct ata_port_info ahci_p
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	/* board_ahci_yesncq */
+	[board_ahci_yesncq] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
 		.flags		= AHCI_FLAG_COMMON,
@@ -516,6 +518,14 @@ static const struct ata_port_info ahci_p
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
+	[board_ahci_nosntf] =
+	{
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_SNTF),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 };
 
 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -531,7 +541,7 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x2683), board_ahci }, /* ESB2 */
 	{ PCI_VDEVICE(INTEL, 0x27c6), board_ahci }, /* ICH7-M DH */
 	{ PCI_VDEVICE(INTEL, 0x2821), board_ahci }, /* ICH8 */
-	{ PCI_VDEVICE(INTEL, 0x2822), board_ahci }, /* ICH8 */
+	{ PCI_VDEVICE(INTEL, 0x2822), board_ahci_nosntf }, /* ICH8 */
 	{ PCI_VDEVICE(INTEL, 0x2824), board_ahci }, /* ICH8 */
 	{ PCI_VDEVICE(INTEL, 0x2829), board_ahci }, /* ICH8M */
 	{ PCI_VDEVICE(INTEL, 0x282a), board_ahci }, /* ICH8M */
@@ -849,6 +859,12 @@ static void ahci_save_initial_config(str
 		cap &= ~HOST_CAP_PMP;
 	}
 
+	if ((cap & HOST_CAP_SNTF) && (hpriv->flags & AHCI_HFLAG_NO_SNTF)) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "controller can't do SNTF, turning off CAP_SNTF\n");
+		cap &= ~HOST_CAP_SNTF;
+	}
+
 	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361 &&
 	    port_map != 1) {
 		dev_printk(KERN_INFO, &pdev->dev,
