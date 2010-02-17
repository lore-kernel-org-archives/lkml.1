Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab0BQNk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:40:56 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38170 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752043Ab0BQNkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:40:55 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/5] Subject: [PATCH] pata_efar: add locking for parallel
	scanning
To: jeff@garzik.org.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Date: Wed, 17 Feb 2010 13:16:58 +0000
Message-ID: <20100217131556.16884.47082.stgit@localhost.localdomain>
In-Reply-To: <20100217131532.16884.21696.stgit@localhost.localdomain>
References: <20100217131532.16884.21696.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Add clearing of UDMA enable bit also for PIO modes and then add
an extra locking for parallel scanning.

This is similar change as commit 60c3be3 for ata_piix host driver
and while pata_efar doesn't enable parallel scan yet the race could
probably also be triggered by requesting re-scanning of both ports
at the same time using SCSI sysfs interface.

[Ported to current kernel without other patch dependancies by
 Alan Cox]

Original is
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

This one is
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/pata_efar.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)


diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 9f55541..2a9014c 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -68,6 +68,8 @@ static int efar_cable_detect(struct ata_port *ap)
 	return ATA_CBL_PATA80;
 }
 
+static DEFINE_SPINLOCK(efar_lock);
+
 /**
  *	efar_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
@@ -84,7 +86,9 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
+	unsigned long flags;
 	u16 idetm_data;
+	u8 udma_enable;
 	int control = 0;
 
 	/*
@@ -107,6 +111,8 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE */
 
+	spin_lock_irqsave(&efar_lock, flags);
+
 	pci_read_config_word(dev, idetm_port, &idetm_data);
 
 	/* Set PPE, IE, and TIME as appropriate */
@@ -131,6 +137,11 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 
 	idetm_data |= 0x4000;	/* Ensure SITRE is set */
 	pci_write_config_word(dev, idetm_port, idetm_data);
+
+	pci_read_config_byte(dev, 0x48, &udma_enable);
+	udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
+	pci_write_config_byte(dev, 0x48, udma_enable);
+	spin_unlock_irqrestore(&efar_lock, flags);
 }
 
 /**
@@ -151,6 +162,7 @@ static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	u16 master_data;
 	u8 speed		= adev->dma_mode;
 	int devid		= adev->devno + 2 * ap->port_no;
+	unsigned long flags;
 	u8 udma_enable;
 
 	static const	 /* ISP  RTC */
@@ -160,6 +172,8 @@ static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 			    { 2, 1 },
 			    { 2, 3 }, };
 
+	spin_lock_irqsave(&efar_lock, flags);
+
 	pci_read_config_word(dev, master_port, &master_data);
 	pci_read_config_byte(dev, 0x48, &udma_enable);
 
@@ -217,6 +231,7 @@ static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 		pci_write_config_word(dev, master_port, master_data);
 	}
 	pci_write_config_byte(dev, 0x48, udma_enable);
+	spin_unlock_irqrestore(&efar_lock, flags);
 }
 
 static struct scsi_host_template efar_sht = {

