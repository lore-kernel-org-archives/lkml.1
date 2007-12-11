Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbXLKR6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbXLKR6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXLKR6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:58:10 -0500
Received: from rtr.ca ([76.10.145.34]:3601 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbXLKR6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:58:08 -0500
Message-ID: <475ECFAD.2030901@rtr.ca>
Date: Tue, 11 Dec 2007 12:58:05 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
       hp@syntomax.com, Alan Cox <alan@redhat.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] sata_mv: improve warnings about Highpoint RocketRAID 23xx
 cards
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the existing boot/load time warnings from sata_mv
for Highpoint RocketRAID 23xx cards, based on new knowledge
about where the BIOS likes to overwrite sectors with metadata.

Harmless to us, but very useful for end users.

Signed-off-by: Mark Lord <mlord@pobox.com>
---
This should ideally go upstream for 2.6.24.

--- old/drivers/ata/sata_mv.c	2007-12-10 18:14:09.000000000 -0500
+++ linux/drivers/ata/sata_mv.c	2007-12-11 12:51:51.000000000 -0500
@@ -2506,11 +2506,31 @@
 		if (pdev->vendor == PCI_VENDOR_ID_TTI &&
 		    (pdev->device == 0x2300 || pdev->device == 0x2310))
 		{
-			printk(KERN_WARNING "sata_mv: Highpoint RocketRAID BIOS"
-				" will CORRUPT DATA on attached drives when"
-				" configured as \"Legacy\".  BEWARE!\n");
-			printk(KERN_WARNING "sata_mv: Use BIOS \"JBOD\" volumes"
-				" instead for safety.\n");
+			/*
+			 * Highpoint RocketRAID PCIe 23xx series cards:
+			 *
+			 * Unconfigured drives are treated as "Legacy"
+			 * by the BIOS, and it overwrites sector 8 with
+			 * a "Lgcy" metadata block prior to Linux boot.
+			 *
+			 * Configured drives (RAID or JBOD) leave sector 8
+			 * alone, but instead overwrite a high numbered
+			 * sector for the RAID metadata.  This sector can
+			 * be determined exactly, by truncating the physical
+			 * drive capacity to a nice even GB value.
+			 *
+			 * RAID metadata is at: (dev->n_sectors & ~0xfffff)
+			 *
+			 * Warn the user, lest they think we're just buggy.
+			 */
+			printk(KERN_WARNING DRV_NAME ": Highpoint RocketRAID"
+				" BIOS CORRUPTS DATA on all attached drives,"
+				" regardless of if/how they are configured."
+				" BEWARE!\n");
+			printk(KERN_WARNING DRV_NAME ": For data safety, do not"
+				" use sectors 8-9 on \"Legacy\" drives,"
+				" and avoid the final two gigabytes on"
+				" all RocketRAID BIOS initialized drives.\n");
 		}
 	case chip_6042:
 		hpriv->ops = &mv6xxx_ops;
