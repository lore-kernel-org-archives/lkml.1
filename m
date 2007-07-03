Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbXGCO7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbXGCO7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbXGCO67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:58:59 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36369 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754922AbXGCO67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:58:59 -0400
Date: Tue, 3 Jul 2007 16:05:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: [PATCH] libata: Support chips with 64K PRD quirk
Message-ID: <20070703160502.685fede6@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add ata_dumb_qc_prep and supporting logic so that a driver can just
specify it needs to be helped in this area. 64K entries are split
as with drivers/ide.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/libata-core.c linux-2.6.22-rc6-mm1/drivers/ata/libata-core.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/libata-core.c	2007-07-02 20:50:11.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/libata-core.c	2007-07-02 21:36:20.000000000 +0100
@@ -4111,6 +4165,68 @@
 	if (idx)
 		ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
 }
+ 
+/**
+ *	ata_fill_sg_dumb - Fill PCI IDE PRD table
+ *	@qc: Metadata associated with taskfile to be transferred
+ *
+ *	Fill PCI IDE PRD (scatter-gather) table with segments
+ *	associated with the current disk command. Perform the fill
+ *	so that we avoid writing any length 64K records for 
+ *	controllers that don't follow the spec.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ */
+static void ata_fill_sg_dumb(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct scatterlist *sg;
+	unsigned int idx;
+
+	WARN_ON(qc->__sg == NULL);
+	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+
+	idx = 0;
+	ata_for_each_sg(sg, qc) {
+		u32 addr, offset;
+		u32 sg_len, len, blen;
+
+ 		/* determine if physical DMA addr spans 64K boundary.
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
+			blen = len & 0xffff;
+			ap->prd[idx].addr = cpu_to_le32(addr);
+			if (blen == 0) {
+				/* Some PATA chipsets like the CS5530 can't
+				   cope with 0x0000 meaning 64K as the spec says */
+				ap->prd[idx].flags_len = cpu_to_le32(0x8000);
+				blen = 0x8000;
+				ap->prd[++idx].addr = cpu_to_le32(addr + 0x8000);
+			}
+			ap->prd[idx].flags_len = cpu_to_le32(blen);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
+
+			idx++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	if (idx)
+		ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+}
 
 /**
  *	ata_check_atapi_dma - Check whether ATAPI DMA can be supported
@@ -4159,6 +4275,23 @@
 	ata_fill_sg(qc);
 }
 
+/**
+ *	ata_dumb_qc_prep - Prepare taskfile for submission
+ *	@qc: Metadata associated with taskfile to be prepared
+ *
+ *	Prepare ATA taskfile for submission.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+void ata_dumb_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	ata_fill_sg_dumb(qc);
+}
+
 void ata_noop_qc_prep(struct ata_queued_cmd *qc) { }
 
 /**
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/include/linux/libata.h linux-2.6.22-rc6-mm1/include/linux/libata.h
--- linux.vanilla-2.6.22-rc6-mm1/include/linux/libata.h	2007-07-02 20:50:14.000000000 +0100
+++ linux-2.6.22-rc6-mm1/include/linux/libata.h	2007-07-02 21:29:18.000000000 +0100
@@ -116,6 +116,7 @@
 enum {
 	/* various global constants */
 	LIBATA_MAX_PRD		= ATA_MAX_PRD / 2,
+	LIBATA_DUMB_MAX_PRD	= ATA_MAX_PRD / 4,	/* Worst case */
 	ATA_MAX_PORTS		= 8,
 	ATA_DEF_QUEUE		= 1,
 	/* tag ATA_MAX_QUEUE - 1 is reserved for internal commands */
@@ -785,6 +789,7 @@
 			  unsigned int buflen, int write_data);
 extern void ata_data_xfer_noirq(struct ata_device *adev, unsigned char *buf,
 				unsigned int buflen, int write_data);
+extern void ata_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc);
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_cs5520.c linux-2.6.22-rc6-mm1/drivers/ata/pata_cs5520.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_cs5520.c	2007-07-02 20:48:49.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/pata_cs5520.c	2007-07-02 21:03:00.000000000 +0100
@@ -146,7 +146,7 @@
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -178,7 +178,7 @@
 	.bmdma_start		= ata_bmdma_start,
 	.bmdma_stop		= ata_bmdma_stop,
 	.bmdma_status		= ata_bmdma_status,
-	.qc_prep		= ata_qc_prep,
+	.qc_prep		= ata_dumb_qc_prep,
 	.qc_issue		= ata_qc_issue_prot,
 	.data_xfer		= ata_data_xfer,
 
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_cs5530.c linux-2.6.22-rc6-mm1/drivers/ata/pata_cs5530.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_cs5530.c	2007-07-02 20:50:11.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/pata_cs5530.c	2007-07-02 21:03:00.000000000 +0100
@@ -167,7 +167,7 @@
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -201,7 +201,7 @@
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 	.cable_detect	= ata_cable_40wire,
 
-	.qc_prep 	= ata_qc_prep,
+	.qc_prep 	= ata_dumb_qc_prep,
 	.qc_issue	= cs5530_qc_issue_prot,
 
 	.data_xfer	= ata_data_xfer,
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_sc1200.c linux-2.6.22-rc6-mm1/drivers/ata/pata_sc1200.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_sc1200.c	2007-07-02 20:50:11.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/pata_sc1200.c	2007-07-02 21:04:59.000000000 +0100
@@ -185,7 +185,7 @@
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= LIBATA_DUMB_MAX_PRD,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,
@@ -219,7 +219,7 @@
 	.bmdma_stop	= ata_bmdma_stop,
 	.bmdma_status 	= ata_bmdma_status,
 
-	.qc_prep 	= ata_qc_prep,
+	.qc_prep 	= ata_dumb_qc_prep,
 	.qc_issue	= sc1200_qc_issue_prot,
 
 	.data_xfer	= ata_data_xfer,
