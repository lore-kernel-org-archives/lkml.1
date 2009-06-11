Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbZFKSRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbZFKSRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZFKSRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:17:05 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53701 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZFKSRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:17:03 -0400
Date: Thu, 11 Jun 2009 14:17:02 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for 2.6.31
Message-ID: <20090611181702.GA18322@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The only notable commit IMO is Alan/Arjan's patch to ata_piix, to enable
parallel scans.  This _should_ be safe, but given all the weird
PATA/SATA/AHCI combinations working behind the schemes in the chip, it
warrants close attention for related bug reports.

There is a patchset from Jens outstanding, that converts libata to use
block layer tagging.  Currently this is held pending verification that
it does not break PMP configurations, which have a different tag map
from normal non-PMP NCQ cases.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/ahci.c          |   87 ++++++++++++++++++++++------
 drivers/ata/ata_piix.c      |   11 ++--
 drivers/ata/libata-core.c   |   11 ++--
 drivers/ata/libata-sff.c    |   20 ++++--
 drivers/ata/sata_nv.c       |  131 ++++++++++++++++++++++++++----------------
 drivers/ata/sata_sil.c      |    2 +-
 drivers/ata/sata_sx4.c      |   11 ++-
 drivers/firmware/dmi_scan.c |    1 +
 8 files changed, 181 insertions(+), 93 deletions(-)

Alan Cox (2):
      ata_piix: Turn on hotplugging support for older chips
      ata_piix: Remove stale comment

Alexander Beregalov (1):
      sata_sx4: speed up ECC initialization

Arjan van de Ven (1):
      [libata] ata_piix: Enable parallel scan

Jeff Garzik (1):
      [libata] ahci: use less error-prone array initializers

Jens Axboe (1):
      [libata] get rid of ATA_MAX_QUEUE loop in ata_qc_complete_multiple() v2

Robert Hancock (1):
      sata_sil: enable 32-bit PIO

Sergei Shtylyov (1):
      libata-sff: avoid byte swapping in ata_sff_data_xfer()

Shane Huang (1):
      [libata] ahci: Restore SB600 SATA controller 64 bit DMA

Tejun Heo (2):
      ahci: misc cleanups for EM stuff
      sata_nv: use hardreset only for post-boot probing

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6b91c26..15a2303 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -77,8 +77,6 @@ static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
 			      size_t size);
 static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 					ssize_t size);
-#define MAX_SLOTS 8
-#define MAX_RETRY 15
 
 enum {
 	AHCI_PCI_BAR		= 5,
@@ -231,6 +229,10 @@ enum {
 
 	ICH_MAP				= 0x90, /* ICH MAP register */
 
+	/* em constants */
+	EM_MAX_SLOTS			= 8,
+	EM_MAX_RETRY			= 5,
+
 	/* em_ctl bits */
 	EM_CTL_RST			= (1 << 9), /* Reset */
 	EM_CTL_TM			= (1 << 8), /* Transmit Message */
@@ -282,8 +284,8 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
 	u32 			intr_mask;	/* interrupts to enable */
-	struct ahci_em_priv	em_priv[MAX_SLOTS];/* enclosure management info
-					 	 * per PM slot */
+	/* enclosure management info per PM slot */
+	struct ahci_em_priv	em_priv[EM_MAX_SLOTS];
 };
 
 static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
@@ -313,7 +315,6 @@ static void ahci_error_handler(struct ata_port *ap);
 static void ahci_post_internal_cmd(struct ata_queued_cmd *qc);
 static int ahci_port_resume(struct ata_port *ap);
 static void ahci_dev_config(struct ata_device *dev);
-static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl);
 static void ahci_fill_cmd_slot(struct ahci_port_priv *pp, unsigned int tag,
 			       u32 opts);
 #ifdef CONFIG_PM
@@ -404,14 +405,14 @@ static struct ata_port_operations ahci_sb600_ops = {
 #define AHCI_HFLAGS(flags)	.private_data	= (void *)(flags)
 
 static const struct ata_port_info ahci_port_info[] = {
-	/* board_ahci */
+	[board_ahci] =
 	{
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	/* board_ahci_vt8251 */
+	[board_ahci_vt8251] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
@@ -419,7 +420,7 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_vt8251_ops,
 	},
-	/* board_ahci_ign_iferr */
+	[board_ahci_ign_iferr] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_IRQ_IF_ERR),
 		.flags		= AHCI_FLAG_COMMON,
@@ -427,17 +428,16 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	/* board_ahci_sb600 */
+	[board_ahci_sb600] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL |
-				 AHCI_HFLAG_32BIT_ONLY | AHCI_HFLAG_NO_MSI |
-				 AHCI_HFLAG_SECT255),
+				 AHCI_HFLAG_NO_MSI | AHCI_HFLAG_SECT255),
 		.flags		= AHCI_FLAG_COMMON,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_sb600_ops,
 	},
-	/* board_ahci_mv */
+	[board_ahci_mv] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
 				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
@@ -447,7 +447,7 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	/* board_ahci_sb700, for SB700 and SB800 */
+	[board_ahci_sb700] =	/* for SB700 and SB800 */
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_IGN_SERR_INTERNAL),
 		.flags		= AHCI_FLAG_COMMON,
@@ -455,7 +455,7 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_sb600_ops,
 	},
-	/* board_ahci_mcp65 */
+	[board_ahci_mcp65] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_YES_NCQ),
 		.flags		= AHCI_FLAG_COMMON,
@@ -463,7 +463,7 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
 	},
-	/* board_ahci_nopmp */
+	[board_ahci_nopmp] =
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
@@ -1141,12 +1141,12 @@ static void ahci_start_port(struct ata_port *ap)
 			emp = &pp->em_priv[link->pmp];
 
 			/* EM Transmit bit maybe busy during init */
-			for (i = 0; i < MAX_RETRY; i++) {
+			for (i = 0; i < EM_MAX_RETRY; i++) {
 				rc = ahci_transmit_led_message(ap,
 							       emp->led_state,
 							       4);
 				if (rc == -EBUSY)
-					udelay(100);
+					msleep(1);
 				else
 					break;
 			}
@@ -1340,7 +1340,7 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,
 
 	/* get the slot number from the message */
 	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
-	if (pmp < MAX_SLOTS)
+	if (pmp < EM_MAX_SLOTS)
 		emp = &pp->em_priv[pmp];
 	else
 		return -EINVAL;
@@ -1408,7 +1408,7 @@ static ssize_t ahci_led_store(struct ata_port *ap, const char *buf,
 
 	/* get the slot number from the message */
 	pmp = (state & EM_MSG_LED_PMP_SLOT) >> 8;
-	if (pmp < MAX_SLOTS)
+	if (pmp < EM_MAX_SLOTS)
 		emp = &pp->em_priv[pmp];
 	else
 		return -EINVAL;
@@ -2584,6 +2584,51 @@ static void ahci_p5wdh_workaround(struct ata_host *host)
 	}
 }
 
+/*
+ * SB600 ahci controller on ASUS M2A-VM can't do 64bit DMA with older
+ * BIOS.  The oldest version known to be broken is 0901 and working is
+ * 1501 which was released on 2007-10-26.  Force 32bit DMA on anything
+ * older than 1501.  Please read bko#9412 for more info.
+ */
+static bool ahci_asus_m2a_vm_32bit_only(struct pci_dev *pdev)
+{
+	static const struct dmi_system_id sysids[] = {
+		{
+			.ident = "ASUS M2A-VM",
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "ASUSTeK Computer INC."),
+				DMI_MATCH(DMI_BOARD_NAME, "M2A-VM"),
+			},
+		},
+		{ }
+	};
+	const char *cutoff_mmdd = "10/26";
+	const char *date;
+	int year;
+
+	if (pdev->bus->number != 0 || pdev->devfn != PCI_DEVFN(0x12, 0) ||
+	    !dmi_check_system(sysids))
+		return false;
+
+	/*
+	 * Argh.... both version and date are free form strings.
+	 * Let's hope they're using the same date format across
+	 * different versions.
+	 */
+	date = dmi_get_system_info(DMI_BIOS_DATE);
+	year = dmi_get_year(DMI_BIOS_DATE);
+	if (date && strlen(date) >= 10 && date[2] == '/' && date[5] == '/' &&
+	    (year > 2007 ||
+	     (year == 2007 && strncmp(date, cutoff_mmdd, 5) >= 0)))
+		return false;
+
+	dev_printk(KERN_WARNING, &pdev->dev, "ASUS M2A-VM: BIOS too old, "
+		   "forcing 32bit DMA, update BIOS\n");
+
+	return true;
+}
+
 static bool ahci_broken_system_poweroff(struct pci_dev *pdev)
 {
 	static const struct dmi_system_id broken_systems[] = {
@@ -2744,6 +2789,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (board_id == board_ahci_sb700 && pdev->revision >= 0x40)
 		hpriv->flags &= ~AHCI_HFLAG_IGN_SERR_INTERNAL;
 
+	/* apply ASUS M2A_VM quirk */
+	if (ahci_asus_m2a_vm_32bit_only(pdev))
+		hpriv->flags |= AHCI_HFLAG_32BIT_ONLY;
+
 	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI))
 		pci_enable_msi(pdev);
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 1aeb708..d0a14cf 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -223,10 +223,8 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* ICH8 Mobile PATA Controller */
 	{ 0x8086, 0x2850, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich_pata_100 },
 
-	/* NOTE: The following PCI ids must be kept in sync with the
-	 * list in drivers/pci/quirks.c.
-	 */
-
+	/* SATA ports */
+	
 	/* 82801EB (ICH5) */
 	{ 0x8086, 0x24d1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich5_sata },
 	/* 82801EB (ICH5) */
@@ -1509,8 +1507,8 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	/* no hotplugging support (FIXME) */
-	if (!in_module_init)
+	/* no hotplugging support for later devices (FIXME) */
+	if (!in_module_init && ent->driver_data >= ich5_sata)
 		return -ENODEV;
 
 	if (piix_broken_system_poweroff(pdev)) {
@@ -1591,6 +1589,7 @@ static int __devinit piix_init_one(struct pci_dev *pdev,
 		host->ports[1]->mwdma_mask = 0;
 		host->ports[1]->udma_mask = 0;
 	}
+	host->flags |= ATA_HOST_PARALLEL_SCAN;
 
 	pci_set_master(pdev);
 	return ata_pci_sff_activate_host(host, ata_sff_interrupt, &piix_sht);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c924230..ca4d208 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5031,7 +5031,6 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
 {
 	int nr_done = 0;
 	u32 done_mask;
-	int i;
 
 	done_mask = ap->qc_active ^ qc_active;
 
@@ -5041,16 +5040,16 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
 		return -EINVAL;
 	}
 
-	for (i = 0; i < ATA_MAX_QUEUE; i++) {
+	while (done_mask) {
 		struct ata_queued_cmd *qc;
+		unsigned int tag = __ffs(done_mask);
 
-		if (!(done_mask & (1 << i)))
-			continue;
-
-		if ((qc = ata_qc_from_tag(ap, i))) {
+		qc = ata_qc_from_tag(ap, tag);
+		if (qc) {
 			ata_qc_complete(qc);
 			nr_done++;
 		}
+		done_mask &= ~(1 << tag);
 	}
 
 	return nr_done;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index bb18415..bbbb1fa 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -727,17 +727,23 @@ unsigned int ata_sff_data_xfer(struct ata_device *dev, unsigned char *buf,
 	else
 		iowrite16_rep(data_addr, buf, words);
 
-	/* Transfer trailing 1 byte, if any. */
+	/* Transfer trailing byte, if any. */
 	if (unlikely(buflen & 0x01)) {
-		__le16 align_buf[1] = { 0 };
-		unsigned char *trailing_buf = buf + buflen - 1;
+		unsigned char pad[2];
 
+		/* Point buf to the tail of buffer */
+		buf += buflen - 1;
+
+		/*
+		 * Use io*16_rep() accessors here as well to avoid pointlessly
+		 * swapping bytes to and fro on the big endian machines...
+		 */
 		if (rw == READ) {
-			align_buf[0] = cpu_to_le16(ioread16(data_addr));
-			memcpy(trailing_buf, align_buf, 1);
+			ioread16_rep(data_addr, pad, 1);
+			*buf = pad[0];
 		} else {
-			memcpy(align_buf, trailing_buf, 1);
-			iowrite16(le16_to_cpu(align_buf[0]), data_addr);
+			pad[0] = *buf;
+			iowrite16_rep(data_addr, pad, 1);
 		}
 		words++;
 	}
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 6cda12b..b2d11f3 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -305,8 +305,8 @@ static irqreturn_t nv_ck804_interrupt(int irq, void *dev_instance);
 static int nv_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int nv_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 
-static int nv_noclassify_hardreset(struct ata_link *link, unsigned int *class,
-				   unsigned long deadline);
+static int nv_hardreset(struct ata_link *link, unsigned int *class,
+			unsigned long deadline);
 static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
 static void nv_ck804_freeze(struct ata_port *ap);
@@ -406,49 +406,82 @@ static struct scsi_host_template nv_swncq_sht = {
 	.slave_configure	= nv_swncq_slave_config,
 };
 
-static struct ata_port_operations nv_common_ops = {
+/*
+ * NV SATA controllers have various different problems with hardreset
+ * protocol depending on the specific controller and device.
+ *
+ * GENERIC:
+ *
+ *  bko11195 reports that link doesn't come online after hardreset on
+ *  generic nv's and there have been several other similar reports on
+ *  linux-ide.
+ *
+ *  bko12351#c23 reports that warmplug on MCP61 doesn't work with
+ *  softreset.
+ *
+ * NF2/3:
+ *
+ *  bko3352 reports nf2/3 controllers can't determine device signature
+ *  reliably after hardreset.  The following thread reports detection
+ *  failure on cold boot with the standard debouncing timing.
+ *
+ *  http://thread.gmane.org/gmane.linux.ide/34098
+ *
+ *  bko12176 reports that hardreset fails to bring up the link during
+ *  boot on nf2.
+ *
+ * CK804:
+ *
+ *  For initial probing after boot and hot plugging, hardreset mostly
+ *  works fine on CK804 but curiously, reprobing on the initial port
+ *  by rescanning or rmmod/insmod fails to acquire the initial D2H Reg
+ *  FIS in somewhat undeterministic way.
+ *
+ * SWNCQ:
+ *
+ *  bko12351 reports that when SWNCQ is enabled, for hotplug to work,
+ *  hardreset should be used and hardreset can't report proper
+ *  signature, which suggests that mcp5x is closer to nf2 as long as
+ *  reset quirkiness is concerned.
+ *
+ *  bko12703 reports that boot probing fails for intel SSD with
+ *  hardreset.  Link fails to come online.  Softreset works fine.
+ *
+ * The failures are varied but the following patterns seem true for
+ * all flavors.
+ *
+ * - Softreset during boot always works.
+ *
+ * - Hardreset during boot sometimes fails to bring up the link on
+ *   certain comibnations and device signature acquisition is
+ *   unreliable.
+ *
+ * - Hardreset is often necessary after hotplug.
+ *
+ * So, preferring softreset for boot probing and error handling (as
+ * hardreset might bring down the link) but using hardreset for
+ * post-boot probing should work around the above issues in most
+ * cases.  Define nv_hardreset() which only kicks in for post-boot
+ * probing and use it for all variants.
+ */
+static struct ata_port_operations nv_generic_ops = {
 	.inherits		= &ata_bmdma_port_ops,
 	.lost_interrupt		= ATA_OP_NULL,
 	.scr_read		= nv_scr_read,
 	.scr_write		= nv_scr_write,
+	.hardreset		= nv_hardreset,
 };
 
-/* OSDL bz11195 reports that link doesn't come online after hardreset
- * on generic nv's and there have been several other similar reports
- * on linux-ide.  Disable hardreset for generic nv's.
- */
-static struct ata_port_operations nv_generic_ops = {
-	.inherits		= &nv_common_ops,
-	.hardreset		= ATA_OP_NULL,
-};
-
-/* nf2 is ripe with hardreset related problems.
- *
- * kernel bz#3352 reports nf2/3 controllers can't determine device
- * signature reliably.  The following thread reports detection failure
- * on cold boot with the standard debouncing timing.
- *
- * http://thread.gmane.org/gmane.linux.ide/34098
- *
- * And bz#12176 reports that hardreset simply doesn't work on nf2.
- * Give up on it and just don't do hardreset.
- */
 static struct ata_port_operations nv_nf2_ops = {
 	.inherits		= &nv_generic_ops,
 	.freeze			= nv_nf2_freeze,
 	.thaw			= nv_nf2_thaw,
 };
 
-/* For initial probing after boot and hot plugging, hardreset mostly
- * works fine on CK804 but curiously, reprobing on the initial port by
- * rescanning or rmmod/insmod fails to acquire the initial D2H Reg FIS
- * in somewhat undeterministic way.  Use noclassify hardreset.
- */
 static struct ata_port_operations nv_ck804_ops = {
-	.inherits		= &nv_common_ops,
+	.inherits		= &nv_generic_ops,
 	.freeze			= nv_ck804_freeze,
 	.thaw			= nv_ck804_thaw,
-	.hardreset		= nv_noclassify_hardreset,
 	.host_stop		= nv_ck804_host_stop,
 };
 
@@ -476,19 +509,8 @@ static struct ata_port_operations nv_adma_ops = {
 	.host_stop		= nv_adma_host_stop,
 };
 
-/* Kernel bz#12351 reports that when SWNCQ is enabled, for hotplug to
- * work, hardreset should be used and hardreset can't report proper
- * signature, which suggests that mcp5x is closer to nf2 as long as
- * reset quirkiness is concerned.  Define separate ops for mcp5x with
- * nv_noclassify_hardreset().
- */
-static struct ata_port_operations nv_mcp5x_ops = {
-	.inherits		= &nv_common_ops,
-	.hardreset		= nv_noclassify_hardreset,
-};
-
 static struct ata_port_operations nv_swncq_ops = {
-	.inherits		= &nv_mcp5x_ops,
+	.inherits		= &nv_generic_ops,
 
 	.qc_defer		= ata_std_qc_defer,
 	.qc_prep		= nv_swncq_qc_prep,
@@ -557,7 +579,7 @@ static const struct ata_port_info nv_port_info[] = {
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
-		.port_ops	= &nv_mcp5x_ops,
+		.port_ops	= &nv_generic_ops,
 		.private_data	= NV_PI_PRIV(nv_generic_interrupt, &nv_sht),
 	},
 	/* SWNCQ */
@@ -1559,15 +1581,24 @@ static int nv_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val)
 	return 0;
 }
 
-static int nv_noclassify_hardreset(struct ata_link *link, unsigned int *class,
-				   unsigned long deadline)
+static int nv_hardreset(struct ata_link *link, unsigned int *class,
+			unsigned long deadline)
 {
-	bool online;
-	int rc;
+	struct ata_eh_context *ehc = &link->eh_context;
 
-	rc = sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
-				 &online, NULL);
-	return online ? -EAGAIN : rc;
+	/* Do hardreset iff it's post-boot probing, please read the
+	 * comment above port ops for details.
+	 */
+	if (!(link->ap->pflags & ATA_PFLAG_LOADING) &&
+	    !ata_dev_enabled(link->device))
+		sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
+				    NULL, NULL);
+	else if (!(ehc->i.flags & ATA_EHI_QUIET))
+		ata_link_printk(link, KERN_INFO,
+				"nv: skipping hardreset on occupied port\n");
+
+	/* device signature acquisition is unreliable */
+	return -EAGAIN;
 }
 
 static void nv_nf2_freeze(struct ata_port *ap)
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index e67ce8e..030ec07 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -183,7 +183,7 @@ static struct scsi_host_template sil_sht = {
 };
 
 static struct ata_port_operations sil_ops = {
-	.inherits		= &ata_bmdma_port_ops,
+	.inherits		= &ata_bmdma32_port_ops,
 	.dev_config		= sil_dev_config,
 	.set_mode		= sil_set_mode,
 	.bmdma_setup            = sil_bmdma_setup,
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index eb05a3c..bbcf970 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -193,6 +193,7 @@ enum {
 					  PDC_TIMER_MASK_INT,
 };
 
+#define ECC_ERASE_BUF_SZ (128 * 1024)
 
 struct pdc_port_priv {
 	u8			dimm_buf[(ATA_PRD_SZ * ATA_MAX_PRD) + 512];
@@ -1280,7 +1281,6 @@ static unsigned int pdc20621_dimm_init(struct ata_host *host)
 {
 	int speed, size, length;
 	u32 addr, spd0, pci_status;
-	u32 tmp = 0;
 	u32 time_period = 0;
 	u32 tcount = 0;
 	u32 ticks = 0;
@@ -1395,14 +1395,17 @@ static unsigned int pdc20621_dimm_init(struct ata_host *host)
 	pdc20621_i2c_read(host, PDC_DIMM0_SPD_DEV_ADDRESS,
 			  PDC_DIMM_SPD_TYPE, &spd0);
 	if (spd0 == 0x02) {
+		void *buf;
 		VPRINTK("Start ECC initialization\n");
 		addr = 0;
 		length = size * 1024 * 1024;
+		buf = kzalloc(ECC_ERASE_BUF_SZ, GFP_KERNEL);
 		while (addr < length) {
-			pdc20621_put_to_dimm(host, (void *) &tmp, addr,
-					     sizeof(u32));
-			addr += sizeof(u32);
+			pdc20621_put_to_dimm(host, buf, addr,
+					     ECC_ERASE_BUF_SZ);
+			addr += ECC_ERASE_BUF_SZ;
 		}
+		kfree(buf);
 		VPRINTK("Finish ECC initialization\n");
 	}
 	return 0;
diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 5f1b540..24c84ae 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -596,6 +596,7 @@ int dmi_get_year(int field)
 
 	return year;
 }
+EXPORT_SYMBOL(dmi_get_year);
 
 /**
  *	dmi_walk - Walk the DMI table and get called back for every record
