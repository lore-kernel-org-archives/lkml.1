Return-Path: <linux-kernel-owner+w=401wt.eu-S1762486AbYBBGBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762486AbYBBGBG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 01:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbYBBGAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 01:00:55 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:14006 "EHLO
	outbound5-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752303AbYBBGAy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 01:00:54 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0JVLKK6-01-94Z-01
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: [PATCH] PCI subsystem: AMD SATA IDE mode quirk
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Sat, 2 Feb 2008 13:56:56 +0800
Message-ID: <206C6845C72CAE439DC3D9D413C571A487B327@ssuzexmb3.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] PCI subsystem: AMD SATA IDE mode quirk
thread-index: AchlYGrDh0sSuMQiRs2i0v5dLF9Pyw==
From: "Cai, Crane" <Crane.Cai@amd.com>
To: gregkh@suse.de
cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
X-OriginalArrivalTime: 02 Feb 2008 05:56:57.0386 (UTC)
 FILETIME=[6B7080A0:01C86560]
X-WSS-ID: 6BBAD9DF24S10068933-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Crane Cai <crane.cai@amd.com>

PCI: modify SATA IDE mode quirk
When initialize and resume, SB600/700/800 need to set SATA mode
correctly.

Signed-off-by: Crane Cai <crane.cai@amd.com>
--------------------------------------------
--- a/drivers/pci/quirks.c	2007-09-24 14:16:32.000000000 -0400
+++ b/drivers/pci/quirks.c	2008-02-02 11:23:47.000000000 -0500
@@ -859,12 +859,13 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,
PCI_DEVICE_ID_INTEL_82454NX,	quirk_disable_pxb );
 
 
-static void __devinit quirk_sb600_sata(struct pci_dev *pdev)
+static void __devinit quirk_amd_ide_mode(struct pci_dev *pdev)
 {
-	/* set sb600 sata to ahci mode */
-	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
-		u8 tmp;
+	/* set sb600/sb700/sb800 sata to ahci mode */
+	u8 tmp;
 
+	pci_read_config_byte(pdev, PCI_CLASS_DEVICE, &tmp);
+	if (tmp == 0x01) {
 		pci_read_config_byte(pdev, 0x40, &tmp);
 		pci_write_config_byte(pdev, 0x40, tmp|1);
 		pci_write_config_byte(pdev, 0x9, 1);
@@ -872,10 +873,13 @@ static void __devinit quirk_sb600_sata(s
 		pci_write_config_byte(pdev, 0x40, tmp);
 
 		pdev->class = PCI_CLASS_STORAGE_SATA_AHCI;
+		printk(KERN_INFO "PCI: set SATA to AHCI mode\n");
 	}
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_sb600_sata);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_sb600_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_amd_ide_mode);
 
 /*
  *	Serverworks CSB5 IDE does not fully support native mode


