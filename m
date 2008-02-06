Return-Path: <linux-kernel-owner+w=401wt.eu-S933186AbYBGA0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbYBGA0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932568AbYBFX7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:59:45 -0500
Received: from mail.suse.de ([195.135.220.2]:46535 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932565AbYBFX7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:43 -0500
Date: Wed, 6 Feb 2008 15:54:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Garzik <jeff@garzik.org>, Mikael Pettersson <mikpe@it.uu.se>
Subject: [patch 61/73] sata_promise: ASIC PRD table bug workaround
Message-ID: <20080206235410.GJ13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_promise-asic-prd-table-bug-workaround.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Mikael Pettersson <mikpe@it.uu.se>

patch 03116d67e0973bb493fe9307e28973a24a272bcc in mainline.

Second-generation Promise SATA controllers have an ASIC bug
which can trigger if the last PRD entry is larger than 164 bytes,
resulting in intermittent errors and possible data corruption.

Work around this by replacing calls to ata_qc_prep() with a
private version that fills the PRD, checks the size of the
last entry, and if necessary splits it to avoid the bug.
Also reduce sg_tablesize by 1 to accommodate the new entry.

Tested on the second-generation SATA300 TX4 and SATA300 TX2plus,
and the first-generation PDC20378.

Thanks to Alexander Sabourenkov for verifying the bug by
studying the vendor driver, and for writing the initial patch
upon which this one is based.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_promise.c |   87 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 83 insertions(+), 4 deletions(-)

--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -50,6 +50,7 @@
 enum {
 	PDC_MAX_PORTS		= 4,
 	PDC_MMIO_BAR		= 3,
+	PDC_MAX_PRD		= LIBATA_MAX_PRD - 1, /* -1 for ASIC PRD bug workaround */
 
 	/* register offsets */
 	PDC_FEATURE		= 0x04, /* Feature/Error reg (per port) */
@@ -155,7 +156,7 @@ static struct scsi_host_template pdc_ata
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= PDC_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -527,6 +528,84 @@ static void pdc_atapi_pkt(struct ata_que
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
+			ap->prd[idx - 1].flags_len = cpu_to_le32(len - SG_COUNT_ASIC_BUG);
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
@@ -536,7 +615,7 @@ static void pdc_qc_prep(struct ata_queue
 
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
-		ata_qc_prep(qc);
+		pdc_fill_sg(qc);
 		/* fall through */
 
 	case ATA_PROT_NODATA:
@@ -552,11 +631,11 @@ static void pdc_qc_prep(struct ata_queue
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

-- 
