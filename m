Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab0BDHNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 02:13:25 -0500
Received: from havoc.gtf.org ([69.61.125.42]:48903 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab0BDHNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 02:13:23 -0500
Date: Thu, 4 Feb 2010 02:13:22 -0500
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, dgilbert@interlog.com, tj@kernel.org,
       hch@infradead.org, catalin.marinas@arm.com
Subject: [git patches] Proposed libata updates for 2.6.33-rc
Message-ID: <20100204071322.GA20387@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Below is the current content of the 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

consisting of the following proposed 2.6.33-rc fixes:

 drivers/ata/ahci.c        |   15 +++++++++++++++
 drivers/ata/libata-scsi.c |    2 +-
 drivers/ata/libata-sff.c  |    3 +++
 include/linux/ata.h       |    4 ++--
 4 files changed, 21 insertions(+), 3 deletions(-)

Catalin Marinas (1):
      [libata] Call flush_dcache_page after PIO data transfers in libata-sff.c

Christoph Hellwig (1):
      libata: fix ata_id_logical_per_physical_sectors

Douglas Gilbert (1):
      libata-scsi passthru: fix bug which truncated LBA48 return values

Tejun Heo (1):
      ahci: add Acer G725 to broken suspend list

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index b8bea10..b343903 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -2868,6 +2868,21 @@ static bool ahci_broken_suspend(struct pci_dev *pdev)
 			},
 			.driver_data = "F.23",	/* cutoff BIOS version */
 		},
+		/*
+		 * Acer eMachines G725 has the same problem.  BIOS
+		 * V1.03 is known to be broken.  V3.04 is known to
+		 * work.  Inbetween, there are V1.06, V2.06 and V3.03
+		 * that we don't have much idea about.  For now,
+		 * blacklist anything older than V3.04.
+		 */
+		{
+			.ident = "G725",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "eMachines"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "eMachines G725"),
+			},
+			.driver_data = "V3.04",	/* cutoff BIOS version */
+		},
 		{ }	/* terminate list */
 	};
 	const struct dmi_system_id *dmi = dmi_first_match(sysids);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index f4ea5a8..d096fbc 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2875,7 +2875,7 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	 * write indication (used for PIO/DMA setup), result TF is
 	 * copied back and we don't whine too much about its failure.
 	 */
-	tf->flags = ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	if (scmd->sc_data_direction == DMA_TO_DEVICE)
 		tf->flags |= ATA_TFLAG_WRITE;
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 741065c..730ef3c 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -893,6 +893,9 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 				       do_write);
 	}
 
+	if (!do_write)
+		flush_dcache_page(page);
+
 	qc->curbytes += qc->sect_size;
 	qc->cursg_ofs += qc->sect_size;
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 38a6948..20f3156 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -647,9 +647,9 @@ static inline int ata_id_has_large_logical_sectors(const u16 *id)
 	return id[ATA_ID_SECTOR_SIZE] & (1 << 13);
 }
 
-static inline u8 ata_id_logical_per_physical_sectors(const u16 *id)
+static inline u16 ata_id_logical_per_physical_sectors(const u16 *id)
 {
-	return id[ATA_ID_SECTOR_SIZE] & 0xf;
+	return 1 << (id[ATA_ID_SECTOR_SIZE] & 0xf);
 }
 
 static inline int ata_id_has_lba48(const u16 *id)
