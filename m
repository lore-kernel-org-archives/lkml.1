Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbYKDGVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbYKDGVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYKDGU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:20:57 -0500
Received: from havoc.gtf.org ([69.61.125.42]:33828 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbYKDGU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:20:56 -0500
Date: Tue, 4 Nov 2008 01:20:54 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20081104062054.GA4239@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


_Hopefully_ nailing down the last of the sata_nv EH problems.
Plus a key sata_promise fix.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c  |    6 +++-
 drivers/ata/libata-scsi.c  |    7 +++--
 drivers/ata/sata_nv.c      |   53 ++++++++++++++++++++-----------------------
 drivers/ata/sata_promise.c |   20 ++++++++++++++++
 drivers/ata/sata_via.c     |    4 ++-
 include/linux/libata.h     |    2 +
 6 files changed, 58 insertions(+), 34 deletions(-)

Elias Oltmanns (1):
      libata: Fix a potential race condition in ata_scsi_park_show()

Marcin Slusarz (1):
      sata_via: restore vt*_prepare_host error handling

Mikael Pettersson (1):
      sata_promise: add ATA engine reset to reset ops

Tejun Heo (3):
      sata_nv: fix generic, nf2/3 detection regression
      libata: implement ATA_HORKAGE_ATAPI_MOD16_DMA and apply it
      libata: mask off DET when restoring SControl for detach

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 82af701..622350d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4024,6 +4024,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 },
+	{ "QUANTUM DAT    DAT72-000", NULL,	ATA_HORKAGE_ATAPI_MOD16_DMA },
 
 	/* Devices we expect to fail diagnostics */
 
@@ -4444,7 +4445,8 @@ int atapi_check_dma(struct ata_queued_cmd *qc)
 	/* Don't allow DMA if it isn't multiple of 16 bytes.  Quite a
 	 * few ATAPI devices choke on such DMA requests.
 	 */
-	if (unlikely(qc->nbytes & 15))
+	if (!(qc->dev->horkage & ATA_HORKAGE_ATAPI_MOD16_DMA) &&
+	    unlikely(qc->nbytes & 15))
 		return 1;
 
 	if (ap->ops->check_atapi_dma)
@@ -5934,7 +5936,7 @@ static void ata_port_detach(struct ata_port *ap)
 	 * to us.  Restore SControl and disable all existing devices.
 	 */
 	__ata_port_for_each_link(link, ap) {
-		sata_scr_write(link, SCR_CONTROL, link->saved_scontrol);
+		sata_scr_write(link, SCR_CONTROL, link->saved_scontrol & 0xff0);
 		ata_link_for_each_dev(dev, link)
 			ata_dev_disable(dev);
 	}
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bbb30d8..3fa75ea 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -190,7 +190,7 @@ static ssize_t ata_scsi_park_show(struct device *device,
 	struct ata_port *ap;
 	struct ata_link *link;
 	struct ata_device *dev;
-	unsigned long flags;
+	unsigned long flags, now;
 	unsigned int uninitialized_var(msecs);
 	int rc = 0;
 
@@ -208,10 +208,11 @@ static ssize_t ata_scsi_park_show(struct device *device,
 	}
 
 	link = dev->link;
+	now = jiffies;
 	if (ap->pflags & ATA_PFLAG_EH_IN_PROGRESS &&
 	    link->eh_context.unloaded_mask & (1 << dev->devno) &&
-	    time_after(dev->unpark_deadline, jiffies))
-		msecs = jiffies_to_msecs(dev->unpark_deadline - jiffies);
+	    time_after(dev->unpark_deadline, now))
+		msecs = jiffies_to_msecs(dev->unpark_deadline - now);
 	else
 		msecs = 0;
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index fae3841..6f14606 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -307,10 +307,10 @@ static int nv_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
 
 static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
+static int nv_nf2_hardreset(struct ata_link *link, unsigned int *class,
+			    unsigned long deadline);
 static void nv_ck804_freeze(struct ata_port *ap);
 static void nv_ck804_thaw(struct ata_port *ap);
-static int nv_hardreset(struct ata_link *link, unsigned int *class,
-			unsigned long deadline);
 static int nv_adma_slave_config(struct scsi_device *sdev);
 static int nv_adma_check_atapi_dma(struct ata_queued_cmd *qc);
 static void nv_adma_qc_prep(struct ata_queued_cmd *qc);
@@ -405,17 +405,8 @@ static struct scsi_host_template nv_swncq_sht = {
 	.slave_configure	= nv_swncq_slave_config,
 };
 
-/* OSDL bz3352 reports that some nv controllers can't determine device
- * signature reliably and nv_hardreset is implemented to work around
- * the problem.  This was reported on nf3 and it's unclear whether any
- * other controllers are affected.  However, the workaround has been
- * applied to all variants and there isn't much to gain by trying to
- * find out exactly which ones are affected at this point especially
- * because NV has moved over to ahci for newer controllers.
- */
 static struct ata_port_operations nv_common_ops = {
 	.inherits		= &ata_bmdma_port_ops,
-	.hardreset		= nv_hardreset,
 	.scr_read		= nv_scr_read,
 	.scr_write		= nv_scr_write,
 };
@@ -429,12 +420,22 @@ static struct ata_port_operations nv_generic_ops = {
 	.hardreset		= ATA_OP_NULL,
 };
 
+/* OSDL bz3352 reports that nf2/3 controllers can't determine device
+ * signature reliably.  Also, the following thread reports detection
+ * failure on cold boot with the standard debouncing timing.
+ *
+ * http://thread.gmane.org/gmane.linux.ide/34098
+ *
+ * Debounce with hotplug timing and request follow-up SRST.
+ */
 static struct ata_port_operations nv_nf2_ops = {
 	.inherits		= &nv_common_ops,
 	.freeze			= nv_nf2_freeze,
 	.thaw			= nv_nf2_thaw,
+	.hardreset		= nv_nf2_hardreset,
 };
 
+/* CK804 finally gets hardreset right */
 static struct ata_port_operations nv_ck804_ops = {
 	.inherits		= &nv_common_ops,
 	.freeze			= nv_ck804_freeze,
@@ -443,7 +444,7 @@ static struct ata_port_operations nv_ck804_ops = {
 };
 
 static struct ata_port_operations nv_adma_ops = {
-	.inherits		= &nv_common_ops,
+	.inherits		= &nv_ck804_ops,
 
 	.check_atapi_dma	= nv_adma_check_atapi_dma,
 	.sff_tf_read		= nv_adma_tf_read,
@@ -467,7 +468,7 @@ static struct ata_port_operations nv_adma_ops = {
 };
 
 static struct ata_port_operations nv_swncq_ops = {
-	.inherits		= &nv_common_ops,
+	.inherits		= &nv_generic_ops,
 
 	.qc_defer		= ata_std_qc_defer,
 	.qc_prep		= nv_swncq_qc_prep,
@@ -1553,6 +1554,17 @@ static void nv_nf2_thaw(struct ata_port *ap)
 	iowrite8(mask, scr_addr + NV_INT_ENABLE);
 }
 
+static int nv_nf2_hardreset(struct ata_link *link, unsigned int *class,
+			    unsigned long deadline)
+{
+	bool online;
+	int rc;
+
+	rc = sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
+				 &online, NULL);
+	return online ? -EAGAIN : rc;
+}
+
 static void nv_ck804_freeze(struct ata_port *ap)
 {
 	void __iomem *mmio_base = ap->host->iomap[NV_MMIO_BAR];
@@ -1605,21 +1617,6 @@ static void nv_mcp55_thaw(struct ata_port *ap)
 	ata_sff_thaw(ap);
 }
 
-static int nv_hardreset(struct ata_link *link, unsigned int *class,
-			unsigned long deadline)
-{
-	int rc;
-
-	/* SATA hardreset fails to retrieve proper device signature on
-	 * some controllers.  Request follow up SRST.  For more info,
-	 * see http://bugzilla.kernel.org/show_bug.cgi?id=3352
-	 */
-	rc = sata_sff_hardreset(link, class, deadline);
-	if (rc)
-		return rc;
-	return -EAGAIN;
-}
-
 static void nv_adma_error_handler(struct ata_port *ap)
 {
 	struct nv_adma_port_priv *pp = ap->private_data;
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 750d8cd..ba9a257 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -153,6 +153,10 @@ static void pdc_freeze(struct ata_port *ap);
 static void pdc_sata_freeze(struct ata_port *ap);
 static void pdc_thaw(struct ata_port *ap);
 static void pdc_sata_thaw(struct ata_port *ap);
+static int pdc_pata_softreset(struct ata_link *link, unsigned int *class,
+			      unsigned long deadline);
+static int pdc_sata_hardreset(struct ata_link *link, unsigned int *class,
+			      unsigned long deadline);
 static void pdc_error_handler(struct ata_port *ap);
 static void pdc_post_internal_cmd(struct ata_queued_cmd *qc);
 static int pdc_pata_cable_detect(struct ata_port *ap);
@@ -186,6 +190,7 @@ static struct ata_port_operations pdc_sata_ops = {
 	.scr_read		= pdc_sata_scr_read,
 	.scr_write		= pdc_sata_scr_write,
 	.port_start		= pdc_sata_port_start,
+	.hardreset		= pdc_sata_hardreset,
 };
 
 /* First-generation chips need a more restrictive ->check_atapi_dma op */
@@ -200,6 +205,7 @@ static struct ata_port_operations pdc_pata_ops = {
 	.freeze			= pdc_freeze,
 	.thaw			= pdc_thaw,
 	.port_start		= pdc_common_port_start,
+	.softreset		= pdc_pata_softreset,
 };
 
 static const struct ata_port_info pdc_port_info[] = {
@@ -693,6 +699,20 @@ static void pdc_sata_thaw(struct ata_port *ap)
 	readl(host_mmio + hotplug_offset); /* flush */
 }
 
+static int pdc_pata_softreset(struct ata_link *link, unsigned int *class,
+			      unsigned long deadline)
+{
+	pdc_reset_port(link->ap);
+	return ata_sff_softreset(link, class, deadline);
+}
+
+static int pdc_sata_hardreset(struct ata_link *link, unsigned int *class,
+			      unsigned long deadline)
+{
+	pdc_reset_port(link->ap);
+	return sata_sff_hardreset(link, class, deadline);
+}
+
 static void pdc_error_handler(struct ata_port *ap)
 {
 	if (!(ap->pflags & ATA_PFLAG_FROZEN))
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 62367fe..c18935f 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -602,8 +602,10 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		rc = vt8251_prepare_host(pdev, &host);
 		break;
 	default:
-		return -EINVAL;
+		rc = -EINVAL;
 	}
+	if (rc)
+		return rc;
 
 	svia_configure(pdev);
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index f5441ed..c7665a4 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -373,6 +373,8 @@ enum {
 	ATA_HORKAGE_IVB		= (1 << 8),	/* cbl det validity bit bugs */
 	ATA_HORKAGE_STUCK_ERR	= (1 << 9),	/* stuck ERR on next PACKET */
 	ATA_HORKAGE_BRIDGE_OK	= (1 << 10),	/* no bridge limits */
+	ATA_HORKAGE_ATAPI_MOD16_DMA = (1 << 11), /* use ATAPI DMA for commands
+						    not multiple of 16 bytes */
 
 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
