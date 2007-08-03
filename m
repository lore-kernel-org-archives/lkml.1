Return-Path: <linux-kernel-owner+w=401wt.eu-S1761729AbXHCSCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761729AbXHCSCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbXHCSCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:02:24 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:10733 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbXHCSCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:02:22 -0400
Date: Fri, 03 Aug 2007 12:00:57 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH -mm] libata: add human-readable error value decoding v3
To: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
Message-id: <46B36D59.7060803@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds human-readable decoding of the ATA status and error registers
(similar to what drivers/ide does) as well as the SATA Serror register to
libata error handling output.  This prevents the need to pore through
standards documents to figure out the meaning of the bits in these
registers when looking at error reports.  Some bits that drivers/ide
decoded are not decoded here, since the bits are either command-dependent
or obsolete, and properly parsing them would add too much complexity.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

---

Rebased to apply to 2.6.23-rc1-mm2.

--- linux-2.6.23-rc1-mm2/include/linux/ata.h	2007-08-02 16:13:24.000000000 -0600
+++ linux-2.6.23-rc1-mm2edit/include/linux/ata.h	2007-08-02 16:37:23.000000000 -0600
@@ -274,6 +274,15 @@ enum {
 	SERR_PROTOCOL		= (1 << 10), /* protocol violation */
 	SERR_INTERNAL		= (1 << 11), /* host internal error */
 	SERR_PHYRDY_CHG		= (1 << 16), /* PHY RDY changed */
+	SERR_PHY_INT_ERR	= (1 << 17), /* PHY internal error */
+	SERR_COMM_WAKE		= (1 << 18), /* Comm wake */
+	SERR_10B_8B_ERR		= (1 << 19), /* 10b to 8b decode error */
+	SERR_DISPARITY		= (1 << 20), /* Disparity */
+	SERR_CRC		= (1 << 21), /* CRC error */
+	SERR_HANDSHAKE		= (1 << 22), /* Handshake error */
+	SERR_LINK_SEQ_ERR	= (1 << 23), /* Link sequence error */
+	SERR_TRANS_ST_ERROR	= (1 << 24), /* Transport state trans. error */
+	SERR_UNRECOG_FIS	= (1 << 25), /* Unrecognized FIS */
 	SERR_DEV_XCHG		= (1 << 26), /* device exchanged */
 
 	/* struct ata_taskfile flags */
--- linux-2.6.23-rc1-mm2/drivers/ata/libata-eh.c	2007-08-02 16:13:11.000000000 -0600
+++ linux-2.6.23-rc1-mm2edit/drivers/ata/libata-eh.c	2007-08-02 16:35:58.000000000 -0600
@@ -1698,6 +1698,27 @@ static void ata_eh_report(struct ata_por
 			ata_port_printk(ap, KERN_ERR, "%s\n", desc);
 	}
 
+	if (ehc->i.serror)
+		ata_port_printk(ap, KERN_ERR,
+		  "SError: {%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s}\n",
+		  ehc->i.serror & SERR_DATA_RECOVERED ? "RecovData " : "",
+		  ehc->i.serror & SERR_COMM_RECOVERED ? "RecovComm " : "",
+		  ehc->i.serror & SERR_DATA ? "UnrecovData " : "",
+		  ehc->i.serror & SERR_PERSISTENT ? "Persist " : "",
+		  ehc->i.serror & SERR_PROTOCOL ? "Proto " : "",
+		  ehc->i.serror & SERR_INTERNAL ? "HostInt " : "",
+		  ehc->i.serror & SERR_PHYRDY_CHG ? "PHYRdyChg " : "",
+		  ehc->i.serror & SERR_PHY_INT_ERR ? "PHYInt " : "",
+		  ehc->i.serror & SERR_COMM_WAKE ? "CommWake " : "",
+		  ehc->i.serror & SERR_10B_8B_ERR ? "10B8B " : "",
+		  ehc->i.serror & SERR_DISPARITY ? "Dispar " : "",
+		  ehc->i.serror & SERR_CRC ? "BadCRC " : "",
+		  ehc->i.serror & SERR_HANDSHAKE ? "Handshk " : "",
+		  ehc->i.serror & SERR_LINK_SEQ_ERR ? "LinkSeq " : "",
+		  ehc->i.serror & SERR_TRANS_ST_ERROR ? "TrStaTrns " : "",
+		  ehc->i.serror & SERR_UNRECOG_FIS ? "UnrecFIS " : "",
+		  ehc->i.serror & SERR_DEV_XCHG ? "DevExch " : "" );
+
 	for (tag = 0; tag < ATA_MAX_QUEUE; tag++) {
 		static const char *dma_str[] = {
 			[DMA_BIDIRECTIONAL]	= "bidi",
@@ -1728,6 +1749,30 @@ static void ata_eh_report(struct ata_por
 			res->hob_lbal, res->hob_lbam, res->hob_lbah,
 			res->device, qc->err_mask, ata_err_string(qc->err_mask),
 			qc->err_mask & AC_ERR_NCQ ? " <F>" : "");
+
+		if (res->command & (ATA_BUSY | ATA_DRDY | ATA_DF | ATA_DRQ |
+				    ATA_ERR) ) {
+			if (res->command & ATA_BUSY)
+				ata_dev_printk(qc->dev, KERN_ERR,
+				  "status: {Busy}\n" );
+			else
+				ata_dev_printk(qc->dev, KERN_ERR,
+				  "status: {%s%s%s%s}\n",
+				  res->command & ATA_DRDY ? "DRDY " : "",
+				  res->command & ATA_DF ? "DF " : "",
+				  res->command & ATA_DRQ ? "DRQ " : "",
+				  res->command & ATA_ERR ? "ERR " : "" );
+		}
+
+		if (cmd->command != ATA_CMD_PACKET &&
+		    (res->feature & (ATA_ICRC | ATA_UNC | ATA_IDNF |
+				     ATA_ABORTED)))
+			ata_dev_printk(qc->dev, KERN_ERR,
+			  "error: {%s%s%s%s}\n",
+			  res->feature & ATA_ICRC ? "ICRC " : "",
+			  res->feature & ATA_UNC ? "UNC " : "",
+			  res->feature & ATA_IDNF ? "IDNF " : "",
+			  res->feature & ATA_ABORTED ? "ABRT " : "" );
 	}
 }
 

