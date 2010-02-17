Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab0BQNi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:38:59 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38160 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932764Ab0BQNi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:38:58 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [RFC 4/4] libata: Make sil680 do its own exec_command posting
To: jeff@garzik.org.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Date: Wed, 17 Feb 2010 13:15:00 +0000
Message-ID: <20100217131321.16338.68370.stgit@localhost.localdomain>
In-Reply-To: <20100217130847.16338.55586.stgit@localhost.localdomain>
References: <20100217130847.16338.55586.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use our own mmio area to avoid PCI posting. This avoids the rather slow
paranoid implementation in the default handler.

(Note - this is pure paranoia, brute force testing says the SIL680 is doing
 the work itself somewhere as does the fact its worked without it for years
 in the old IDE code)

We cannot make this logic generic as
- There are only a couple of potential SFF style users
- The other one can come up in PIO only modes with no bmdma


Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/pata_sil680.c |   30 ++++++++++++++++++++++++++----
 1 files changed, 26 insertions(+), 4 deletions(-)


diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index a2ace48..065339d 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -190,15 +190,37 @@ static void sil680_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	pci_write_config_word(pdev, ua, ultra);
 }
 
+/**
+ *	sil680_sff_exec_command - issue ATA command to host controller
+ *	@ap: port to which command is being issued
+ *	@tf: ATA taskfile register set
+ *
+ *	Issues ATA command, with proper synchronization with interrupt
+ *	handler / other threads. Use our MMIO space for PCI posting to avoid
+ *	a hideously slow cycle all the way to the device.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void sil680_sff_exec_command(struct ata_port *ap,
+					const struct ata_taskfile *tf)
+{
+	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
+	iowrite8(tf->command, ap->ioaddr.command_addr);
+	ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+}
+
 static struct scsi_host_template sil680_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
+
 static struct ata_port_operations sil680_port_ops = {
-	.inherits	= &ata_bmdma32_port_ops,
-	.cable_detect	= sil680_cable_detect,
-	.set_piomode	= sil680_set_piomode,
-	.set_dmamode	= sil680_set_dmamode,
+	.inherits		= &ata_bmdma32_port_ops,
+	.sff_exec_command	= sil680_sff_exec_command,
+	.cable_detect		= sil680_cable_detect,
+	.set_piomode		= sil680_set_piomode,
+	.set_dmamode		= sil680_set_dmamode,
 };
 
 /**

