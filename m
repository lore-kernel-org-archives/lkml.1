Return-Path: <linux-kernel-owner+w=401wt.eu-S1763614AbXH3Wmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763614AbXH3Wmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763053AbXH3WmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:42:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:54999 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762891AbXH3WmW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:42:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,327,1183359600"; 
   d="scan'208";a="286228985"
From: Jason Gaston <jason.d.gaston@intel.com>
To: jgarzik@pobox.com, jason.d.gaston@intel.com
Subject: [PATCH 2.6.23-rc4] ata_piix: IDE mode SATA patch for Intel Tolapai
Date: Thu, 30 Aug 2007 15:44:32 -0700
User-Agent: KMail/1.9.1
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708301544.32864.jason.d.gaston@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This updated patch adds the Intel Tolapai IDE mode SATA controller DID.

Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>

--- linux-2.6.23-rc4/drivers/ata/ata_piix.c.orig	2007-08-27 18:32:35.000000000 
-0700
+++ linux-2.6.23-rc4/drivers/ata/ata_piix.c	2007-08-29 17:13:13.000000000 
-0700
@@ -130,6 +130,7 @@
 	ich6m_sata_ahci		= 8,
 	ich8_sata_ahci		= 9,
 	piix_pata_mwdma		= 10,	/* PIIX3 MWDMA only */
+	tolapai_sata_ahci	= 11,
 
 	/* constants for mapping table */
 	P0			= 0,  /* port 0 */
@@ -253,6 +254,8 @@
 	{ 0x8086, 0x292d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
 	/* SATA Controller IDE (ICH9M) */
 	{ 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
+	/* SATA Controller IDE (Tolapai) */
+	{ 0x8086, 0x5028, PCI_ANY_ID, PCI_ANY_ID, 0, 0, tolapai_sata_ahci },
 
 	{ }	/* terminate list */
 };
@@ -441,12 +444,25 @@
 	},
 };
 
+static const struct piix_map_db tolapai_map_db = {
+        .mask = 0x3,
+        .port_enable = 0x3,
+        .map = {
+                /* PM   PS   SM   SS       MAP */
+                {  P0,  NA,  P1,  NA }, /* 00b */
+                {  RV,  RV,  RV,  RV }, /* 01b */
+                {  RV,  RV,  RV,  RV }, /* 10b */
+                {  RV,  RV,  RV,  RV },
+        },
+};
+
 static const struct piix_map_db *piix_map_db_table[] = {
 	[ich5_sata]		= &ich5_map_db,
 	[ich6_sata]		= &ich6_map_db,
 	[ich6_sata_ahci]	= &ich6_map_db,
 	[ich6m_sata_ahci]	= &ich6m_map_db,
 	[ich8_sata_ahci]	= &ich8_map_db,
+	[tolapai_sata_ahci]	= &tolapai_map_db,
 };
 
 static struct ata_port_info piix_port_info[] = {
@@ -560,6 +576,17 @@
 		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
 		.port_ops	= &piix_pata_ops,
 	},
+
+	/* tolapai_sata_ahci: 11: */
+	{
+		.sht		= &piix_sht,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
+				  PIIX_FLAG_AHCI,
+		.pio_mask	= 0x1f,	/* pio0-4 */
+		.mwdma_mask	= 0x07, /* mwdma0-2 */
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &piix_sata_ops,
+	},
 };
 
 static struct pci_bits piix_enable_bits[] = {
