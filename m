Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbXJ3SpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbXJ3SpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 14:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXJ3SpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 14:45:07 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42842 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbXJ3SpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 14:45:05 -0400
Date: Tue, 30 Oct 2007 14:45:03 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20071030184502.GA27246@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Of particular note is the sata_promise fix, which works around a
nasty hw errata.  I need to push that to stable@

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-eh.c    |   20 ++++++---
 drivers/ata/libata-scsi.c  |    7 ++-
 drivers/ata/sata_promise.c |  104 ++++++++++++++++++++++++++++++++++++++-----
 drivers/ata/sata_sil24.c   |    6 +-
 include/linux/libata.h     |    1 +
 5 files changed, 115 insertions(+), 23 deletions(-)

Mikael Pettersson (2):
      sata_promise: ASIC PRD table bug workaround, take 2
      sata_promise: cleanups

Tejun Heo (3):
      libata: flush is an IO command
      libata: stop being overjealous about non-IO commands
      libata: implement and use ATA_QCFLAG_QUIET

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index fefea74..8d64f8f 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1800,10 +1800,8 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 			qc->err_mask &= ~AC_ERR_OTHER;
 
 		/* SENSE_VALID trumps dev/unknown error and revalidation */
-		if (qc->flags & ATA_QCFLAG_SENSE_VALID) {
+		if (qc->flags & ATA_QCFLAG_SENSE_VALID)
 			qc->err_mask &= ~(AC_ERR_DEV | AC_ERR_OTHER);
-			ehc->i.action &= ~ATA_EH_REVALIDATE;
-		}
 
 		/* accumulate error info */
 		ehc->i.dev = qc->dev;
@@ -1816,7 +1814,8 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 	if (ap->pflags & ATA_PFLAG_FROZEN ||
 	    all_err_mask & (AC_ERR_HSM | AC_ERR_TIMEOUT))
 		ehc->i.action |= ATA_EH_SOFTRESET;
-	else if (all_err_mask)
+	else if ((is_io && all_err_mask) ||
+		 (!is_io && (all_err_mask & ~AC_ERR_DEV)))
 		ehc->i.action |= ATA_EH_REVALIDATE;
 
 	/* if we have offending qcs and the associated failed device */
@@ -1879,7 +1878,9 @@ static void ata_eh_link_report(struct ata_link *link)
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		struct ata_queued_cmd *qc = __ata_qc_from_tag(ap, tag);
 
-		if (!(qc->flags & ATA_QCFLAG_FAILED) || qc->dev->link != link)
+		if (!(qc->flags & ATA_QCFLAG_FAILED) || qc->dev->link != link ||
+		    ((qc->flags & ATA_QCFLAG_QUIET) &&
+		     qc->err_mask == AC_ERR_DEV))
 			continue;
 		if (qc->flags & ATA_QCFLAG_SENSE_VALID && !qc->err_mask)
 			continue;
@@ -2697,8 +2698,15 @@ void ata_eh_finish(struct ata_port *ap)
 			/* FIXME: Once EH migration is complete,
 			 * generate sense data in this function,
 			 * considering both err_mask and tf.
+			 *
+			 * There's no point in retrying invalid
+			 * (detected by libata) and non-IO device
+			 * errors (rejected by device).  Finish them
+			 * immediately.
 			 */
-			if (qc->err_mask & AC_ERR_INVALID)
+			if ((qc->err_mask & AC_ERR_INVALID) ||
+			    (!(qc->flags & ATA_QCFLAG_IO) &&
+			     qc->err_mask == AC_ERR_DEV))
 				ata_eh_qc_complete(qc);
 			else
 				ata_eh_qc_retry(qc);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 93bd36c..fc89590 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1108,6 +1108,9 @@ static unsigned int ata_scsi_flush_xlat(struct ata_queued_cmd *qc)
 	else
 		tf->command = ATA_CMD_FLUSH;
 
+	/* flush is critical for IO integrity, consider it an IO command */
+	qc->flags |= ATA_QCFLAG_IO;
+
 	return 0;
 }
 
@@ -2764,8 +2767,8 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	 */
 	qc->nbytes = scsi_bufflen(scmd);
 
-	/* request result TF */
-	qc->flags |= ATA_QCFLAG_RESULT_TF;
+	/* request result TF and be quiet about device error */
+	qc->flags |= ATA_QCFLAG_RESULT_TF | ATA_QCFLAG_QUIET;
 
 	return 0;
 
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index deb26f0..825e717 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -2,6 +2,7 @@
  *  sata_promise.c - Promise SATA
  *
  *  Maintained by:  Jeff Garzik <jgarzik@pobox.com>
+ *		    Mikael Pettersson <mikpe@it.uu.se>
  *  		    Please ALWAYS copy linux-ide@vger.kernel.org
  *		    on emails.
  *
@@ -45,11 +46,12 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_promise"
-#define DRV_VERSION	"2.10"
+#define DRV_VERSION	"2.11"
 
 enum {
 	PDC_MAX_PORTS		= 4,
 	PDC_MMIO_BAR		= 3,
+	PDC_MAX_PRD		= LIBATA_MAX_PRD - 1, /* -1 for ASIC PRD bug workaround */
 
 	/* register offsets */
 	PDC_FEATURE		= 0x04, /* Feature/Error reg (per port) */
@@ -157,7 +159,7 @@ static struct scsi_host_template pdc_ata_sht = {
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= PDC_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -240,7 +242,7 @@ static const struct ata_port_operations pdc_pata_ops = {
 };
 
 static const struct ata_port_info pdc_port_info[] = {
-	/* board_2037x */
+	[board_2037x] =
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SATA |
 				  PDC_FLAG_SATA_PATA,
@@ -250,7 +252,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.port_ops	= &pdc_old_sata_ops,
 	},
 
-	/* board_2037x_pata */
+	[board_2037x_pata] =
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= 0x1f, /* pio0-4 */
@@ -259,7 +261,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.port_ops	= &pdc_pata_ops,
 	},
 
-	/* board_20319 */
+	[board_20319] =
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SATA |
 				  PDC_FLAG_4_PORTS,
@@ -269,7 +271,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.port_ops	= &pdc_old_sata_ops,
 	},
 
-	/* board_20619 */
+	[board_20619] =
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS |
 				  PDC_FLAG_4_PORTS,
@@ -279,7 +281,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.port_ops	= &pdc_pata_ops,
 	},
 
-	/* board_2057x */
+	[board_2057x] =
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SATA |
 				  PDC_FLAG_GEN_II | PDC_FLAG_SATA_PATA,
@@ -289,7 +291,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.port_ops	= &pdc_sata_ops,
 	},
 
-	/* board_2057x_pata */
+	[board_2057x_pata] =
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS |
 				  PDC_FLAG_GEN_II,
@@ -299,7 +301,7 @@ static const struct ata_port_info pdc_port_info[] = {
 		.port_ops	= &pdc_pata_ops,
 	},
 
-	/* board_40518 */
+	[board_40518] =
 	{
 		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SATA |
 				  PDC_FLAG_GEN_II | PDC_FLAG_4_PORTS,
@@ -523,6 +525,84 @@ static void pdc_atapi_pkt(struct ata_queued_cmd *qc)
 	memcpy(buf+31, cdb, cdb_len);
 }
 
+/**
+ *	pdc_fill_sg - Fill PCI IDE PRD table
+ *	@qc: Metadata associated with taskfile to be transferred
+ *
+ *	Fill PCI IDE PRD (scatter-gather) table with segments
+ *	associated with the current disk command.
+ *	Make sure hardware does not choke on it.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ */
+static void pdc_fill_sg(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct scatterlist *sg;
+	unsigned int idx;
+	const u32 SG_COUNT_ASIC_BUG = 41*4;
+
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	WARN_ON(qc->__sg == NULL);
+	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+
+	idx = 0;
+	ata_for_each_sg(sg, qc) {
+		u32 addr, offset;
+		u32 sg_len, len;
+
+		/* determine if physical DMA addr spans 64K boundary.
+		 * Note h/w doesn't support 64-bit, so we unconditionally
+		 * truncate dma_addr_t to u32.
+		 */
+		addr = (u32) sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		while (sg_len) {
+			offset = addr & 0xffff;
+			len = sg_len;
+			if ((offset + sg_len) > 0x10000)
+				len = 0x10000 - offset;
+
+			ap->prd[idx].addr = cpu_to_le32(addr);
+			ap->prd[idx].flags_len = cpu_to_le32(len & 0xffff);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
+
+			idx++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	if (idx) {
+		u32 len = le32_to_cpu(ap->prd[idx - 1].flags_len);
+
+		if (len > SG_COUNT_ASIC_BUG) {
+			u32 addr;
+
+			VPRINTK("Splitting last PRD.\n");
+
+			addr = le32_to_cpu(ap->prd[idx - 1].addr);
+			ap->prd[idx - 1].flags_len -= cpu_to_le32(SG_COUNT_ASIC_BUG);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx - 1, addr, SG_COUNT_ASIC_BUG);
+
+			addr = addr + len - SG_COUNT_ASIC_BUG;
+			len = SG_COUNT_ASIC_BUG;
+			ap->prd[idx].addr = cpu_to_le32(addr);
+			ap->prd[idx].flags_len = cpu_to_le32(len);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
+
+			idx++;
+		}
+
+		ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+	}
+}
+
 static void pdc_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct pdc_port_priv *pp = qc->ap->private_data;
@@ -532,7 +612,7 @@ static void pdc_qc_prep(struct ata_queued_cmd *qc)
 
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
-		ata_qc_prep(qc);
+		pdc_fill_sg(qc);
 		/* fall through */
 
 	case ATA_PROT_NODATA:
@@ -548,11 +628,11 @@ static void pdc_qc_prep(struct ata_queued_cmd *qc)
 		break;
 
 	case ATA_PROT_ATAPI:
-		ata_qc_prep(qc);
+		pdc_fill_sg(qc);
 		break;
 
 	case ATA_PROT_ATAPI_DMA:
-		ata_qc_prep(qc);
+		pdc_fill_sg(qc);
 		/*FALLTHROUGH*/
 	case ATA_PROT_ATAPI_NODATA:
 		pdc_atapi_pkt(qc);
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 3c481e0..187dcb0 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -265,11 +265,11 @@ static struct sil24_cerr_info {
 	unsigned int err_mask, action;
 	const char *desc;
 } sil24_cerr_db[] = {
-	[0]			= { AC_ERR_DEV, ATA_EH_REVALIDATE,
+	[0]			= { AC_ERR_DEV, 0,
 				    "device error" },
-	[PORT_CERR_DEV]		= { AC_ERR_DEV, ATA_EH_REVALIDATE,
+	[PORT_CERR_DEV]		= { AC_ERR_DEV, 0,
 				    "device error via D2H FIS" },
-	[PORT_CERR_SDB]		= { AC_ERR_DEV, ATA_EH_REVALIDATE,
+	[PORT_CERR_SDB]		= { AC_ERR_DEV, 0,
 				    "device error via SDB FIS" },
 	[PORT_CERR_DATA]	= { AC_ERR_ATA_BUS, ATA_EH_SOFTRESET,
 				    "error in data FIS" },
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 147ccc4..1e27785 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -221,6 +221,7 @@ enum {
 	ATA_QCFLAG_IO		= (1 << 3), /* standard IO command */
 	ATA_QCFLAG_RESULT_TF	= (1 << 4), /* result TF requested */
 	ATA_QCFLAG_CLEAR_EXCL	= (1 << 5), /* clear excl_link on completion */
+	ATA_QCFLAG_QUIET	= (1 << 6), /* don't report device error */
 
 	ATA_QCFLAG_FAILED	= (1 << 16), /* cmd failed and is owned by EH */
 	ATA_QCFLAG_SENSE_VALID	= (1 << 17), /* sense data valid */
