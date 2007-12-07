Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbXLGUeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbXLGUeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbXLGUeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:34:05 -0500
Received: from havoc.gtf.org ([69.61.125.42]:51636 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbXLGUeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:34:03 -0500
Date: Fri, 7 Dec 2007 15:34:01 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20071207203401.GA29005@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Notable:  kill spurious NCQ completion detection

libata disabling command queueing (aka NCQ) based on some hueristics for
detection device brokenness.... that ultimately turned out to be broken.

Remove the broken hueristic and turn NCQ back on for all the wrongfully
maligned hard drives.


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c        |   96 +++++++++++----------------------------------
 drivers/ata/ata_piix.c    |    7 +++
 drivers/ata/libata-core.c |   18 +--------
 3 files changed, 31 insertions(+), 90 deletions(-)

Peter Schwenke (1):
      ata_piix: add Toshiba Tecra M4 to broken suspend list

Tejun Heo (3):
      ahci: fix engine reset failed message
      ahci: don't attach if ICH6 is in combined mode
      libata: kill spurious NCQ completion detection

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 4688dbf..54f38c2 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -193,6 +193,8 @@ enum {
 					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
 					  ATA_FLAG_IPM,
 	AHCI_LFLAG_COMMON		= ATA_LFLAG_SKIP_D2H_BSY,
+
+	ICH_MAP				= 0x90, /* ICH MAP register */
 };
 
 struct ahci_cmd_hdr {
@@ -1271,9 +1273,9 @@ static int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 
 	/* prepare for SRST (AHCI-1.1 10.4.1) */
 	rc = ahci_kick_engine(ap, 1);
-	if (rc)
+	if (rc && rc != -EOPNOTSUPP)
 		ata_link_printk(link, KERN_WARNING,
-				"failed to reset engine (errno=%d)", rc);
+				"failed to reset engine (errno=%d)\n", rc);
 
 	ata_tf_init(link->device, &tf);
 
@@ -1638,7 +1640,7 @@ static void ahci_port_intr(struct ata_port *ap)
 	struct ahci_host_priv *hpriv = ap->host->private_data;
 	int resetting = !!(ap->pflags & ATA_PFLAG_RESETTING);
 	u32 status, qc_active;
-	int rc, known_irq = 0;
+	int rc;
 
 	status = readl(port_mmio + PORT_IRQ_STAT);
 	writel(status, port_mmio + PORT_IRQ_STAT);
@@ -1696,80 +1698,12 @@ static void ahci_port_intr(struct ata_port *ap)
 
 	rc = ata_qc_complete_multiple(ap, qc_active, NULL);
 
-	/* If resetting, spurious or invalid completions are expected,
-	 * return unconditionally.
-	 */
-	if (resetting)
-		return;
-
-	if (rc > 0)
-		return;
-	if (rc < 0) {
+	/* while resetting, invalid completions are expected */
+	if (unlikely(rc < 0 && !resetting)) {
 		ehi->err_mask |= AC_ERR_HSM;
 		ehi->action |= ATA_EH_SOFTRESET;
 		ata_port_freeze(ap);
-		return;
 	}
-
-	/* hmmm... a spurious interrupt */
-
-	/* if !NCQ, ignore.  No modern ATA device has broken HSM
-	 * implementation for non-NCQ commands.
-	 */
-	if (!ap->link.sactive)
-		return;
-
-	if (status & PORT_IRQ_D2H_REG_FIS) {
-		if (!pp->ncq_saw_d2h)
-			ata_port_printk(ap, KERN_INFO,
-				"D2H reg with I during NCQ, "
-				"this message won't be printed again\n");
-		pp->ncq_saw_d2h = 1;
-		known_irq = 1;
-	}
-
-	if (status & PORT_IRQ_DMAS_FIS) {
-		if (!pp->ncq_saw_dmas)
-			ata_port_printk(ap, KERN_INFO,
-				"DMAS FIS during NCQ, "
-				"this message won't be printed again\n");
-		pp->ncq_saw_dmas = 1;
-		known_irq = 1;
-	}
-
-	if (status & PORT_IRQ_SDB_FIS) {
-		const __le32 *f = pp->rx_fis + RX_FIS_SDB;
-
-		if (le32_to_cpu(f[1])) {
-			/* SDB FIS containing spurious completions
-			 * might be dangerous, whine and fail commands
-			 * with HSM violation.  EH will turn off NCQ
-			 * after several such failures.
-			 */
-			ata_ehi_push_desc(ehi,
-				"spurious completions during NCQ "
-				"issue=0x%x SAct=0x%x FIS=%08x:%08x",
-				readl(port_mmio + PORT_CMD_ISSUE),
-				readl(port_mmio + PORT_SCR_ACT),
-				le32_to_cpu(f[0]), le32_to_cpu(f[1]));
-			ehi->err_mask |= AC_ERR_HSM;
-			ehi->action |= ATA_EH_SOFTRESET;
-			ata_port_freeze(ap);
-		} else {
-			if (!pp->ncq_saw_sdb)
-				ata_port_printk(ap, KERN_INFO,
-					"spurious SDB FIS %08x:%08x during NCQ, "
-					"this message won't be printed again\n",
-					le32_to_cpu(f[0]), le32_to_cpu(f[1]));
-			pp->ncq_saw_sdb = 1;
-		}
-		known_irq = 1;
-	}
-
-	if (!known_irq)
-		ata_port_printk(ap, KERN_INFO, "spurious interrupt "
-				"(irq_stat 0x%x active_tag 0x%x sactive 0x%x)\n",
-				status, ap->link.active_tag, ap->link.sactive);
 }
 
 static void ahci_irq_clear(struct ata_port *ap)
@@ -2273,6 +2207,22 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    (pdev->device == 0x2652 || pdev->device == 0x2653)) {
+		u8 map;
+
+		/* ICH6s share the same PCI ID for both piix and ahci
+		 * modes.  Enabling ahci mode while MAP indicates
+		 * combined mode is a bad idea.  Yield to ata_piix.
+		 */
+		pci_read_config_byte(pdev, ICH_MAP, &map);
+		if (map & 0x3) {
+			dev_printk(KERN_INFO, &pdev->dev, "controller is in "
+				   "combined mode, can't enable AHCI mode\n");
+			return -ENODEV;
+		}
+	}
+
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv)
 		return -ENOMEM;
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index b538e1d..bb62a58 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -974,6 +974,13 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "TECRA M4",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Tecra M4"),
+			},
+		},
+		{
 			.ident = "TECRA M5",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b514a80..e4dea86 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4140,6 +4140,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Devices where NCQ should be avoided */
 	/* NCQ is slow */
 	{ "WDC WD740ADFD-00",	NULL,		ATA_HORKAGE_NONCQ },
+	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
 	/* http://thread.gmane.org/gmane.linux.ide/14907 */
 	{ "FUJITSU MHT2060BH",	NULL,		ATA_HORKAGE_NONCQ },
 	/* NCQ is broken */
@@ -4154,23 +4155,6 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
 	{ "HTS541080G9SA00",    "MB4OC60D",     ATA_HORKAGE_NONCQ, },
 	{ "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },
-	/* Drives which do spurious command completion */
-	{ "HTS541680J9SA00",	"SB2IC7EP",	ATA_HORKAGE_NONCQ, },
-	{ "HTS541612J9SA00",	"SBDIC7JP",	ATA_HORKAGE_NONCQ, },
-	{ "HDT722516DLA380",	"V43OA96A",	ATA_HORKAGE_NONCQ, },
-	{ "Hitachi HTS541616J9SA00", "SB4OC70P", ATA_HORKAGE_NONCQ, },
-	{ "Hitachi HTS542525K9SA00", "BBFOC31P", ATA_HORKAGE_NONCQ, },
-	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
-	{ "WDC WD3200AAJS-00RYA0", "12.01B01",	ATA_HORKAGE_NONCQ, },
-	{ "FUJITSU MHV2080BH",	"00840028",	ATA_HORKAGE_NONCQ, },
-	{ "ST9120822AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
-	{ "ST9160821AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
-	{ "ST9160821AS",	"3.ALD",	ATA_HORKAGE_NONCQ, },
-	{ "ST9160821AS",	"3.CCD",	ATA_HORKAGE_NONCQ, },
-	{ "ST3160812AS",	"3.ADJ",	ATA_HORKAGE_NONCQ, },
-	{ "ST980813AS",		"3.ADB",	ATA_HORKAGE_NONCQ, },
-	{ "SAMSUNG HD401LJ",	"ZZ100-15",	ATA_HORKAGE_NONCQ, },
-	{ "Maxtor 7V300F0",	"VA111900",	ATA_HORKAGE_NONCQ, },
 
 	/* devices which puke on READ_NATIVE_MAX */
 	{ "HDS724040KLSA80",	"KFAOA20N",	ATA_HORKAGE_BROKEN_HPA, },
