Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZAIKTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZAIKTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbZAIKTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:19:43 -0500
Received: from hera.kernel.org ([140.211.167.34]:45090 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbZAIKTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:19:42 -0500
Message-ID: <496724A2.5030400@kernel.org>
Date: Fri, 09 Jan 2009 19:19:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: [PATCH] libata: use WARN_ON_ONCE on hot paths
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com> <20090108221753.78648cd6@daedalus.pq.iki.fi> <20090108125317.648397d2@infradead.org> <49667C36.4080300@gmail.com> <20090108143127.437c15de@infradead.org> <4966974B.3090700@gmail.com> <alpine.LFD.2.00.0901081619330.3322@localhost.localdomain> <49672166.4050606@gmail.com>
In-Reply-To: <49672166.4050606@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 09 Jan 2009 10:19:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert WARN_ON() on command issue/completion paths to WARN_ON_ONCE()
so that libata doesn't spam the machine even when one of those
conditions triggers repeatedly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-core.c |   16 ++++++++--------
 drivers/ata/libata-sff.c  |   24 ++++++++++++------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 175df54..c507a9a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4556,7 +4556,7 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
 	struct scatterlist *sg = qc->sg;
 	int dir = qc->dma_dir;
 
-	WARN_ON(sg == NULL);
+	WARN_ON_ONCE(sg == NULL);
 
 	VPRINTK("unmapping %u sg elements\n", qc->n_elem);
 
@@ -4776,7 +4776,7 @@ void ata_qc_free(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	unsigned int tag;
 
-	WARN_ON(qc == NULL);	/* ata_qc_from_tag _might_ return NULL */
+	WARN_ON_ONCE(qc == NULL); /* ata_qc_from_tag _might_ return NULL */
 
 	qc->flags = 0;
 	tag = qc->tag;
@@ -4791,8 +4791,8 @@ void __ata_qc_complete(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	struct ata_link *link = qc->dev->link;
 
-	WARN_ON(qc == NULL);	/* ata_qc_from_tag _might_ return NULL */
-	WARN_ON(!(qc->flags & ATA_QCFLAG_ACTIVE));
+	WARN_ON_ONCE(qc == NULL); /* ata_qc_from_tag _might_ return NULL */
+	WARN_ON_ONCE(!(qc->flags & ATA_QCFLAG_ACTIVE));
 
 	if (likely(qc->flags & ATA_QCFLAG_DMAMAP))
 		ata_sg_clean(qc);
@@ -4878,7 +4878,7 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 		struct ata_device *dev = qc->dev;
 		struct ata_eh_info *ehi = &dev->link->eh_info;
 
-		WARN_ON(ap->pflags & ATA_PFLAG_FROZEN);
+		WARN_ON_ONCE(ap->pflags & ATA_PFLAG_FROZEN);
 
 		if (unlikely(qc->err_mask))
 			qc->flags |= ATA_QCFLAG_FAILED;
@@ -5000,16 +5000,16 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 	 * check is skipped for old EH because it reuses active qc to
 	 * request ATAPI sense.
 	 */
-	WARN_ON(ap->ops->error_handler && ata_tag_valid(link->active_tag));
+	WARN_ON_ONCE(ap->ops->error_handler && ata_tag_valid(link->active_tag));
 
 	if (ata_is_ncq(prot)) {
-		WARN_ON(link->sactive & (1 << qc->tag));
+		WARN_ON_ONCE(link->sactive & (1 << qc->tag));
 
 		if (!link->sactive)
 			ap->nr_active_links++;
 		link->sactive |= 1 << qc->tag;
 	} else {
-		WARN_ON(link->sactive);
+		WARN_ON_ONCE(link->sactive);
 
 		ap->nr_active_links++;
 		link->active_tag = qc->tag;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index c59ad76..0eae9b4 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -578,7 +578,7 @@ void ata_sff_tf_load(struct ata_port *ap, const struct ata_taskfile *tf)
 	}
 
 	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
-		WARN_ON(!ioaddr->ctl_addr);
+		WARN_ON_ONCE(!ioaddr->ctl_addr);
 		iowrite8(tf->hob_feature, ioaddr->feature_addr);
 		iowrite8(tf->hob_nsect, ioaddr->nsect_addr);
 		iowrite8(tf->hob_lbal, ioaddr->lbal_addr);
@@ -651,7 +651,7 @@ void ata_sff_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 			iowrite8(tf->ctl, ioaddr->ctl_addr);
 			ap->last_ctl = tf->ctl;
 		} else
-			WARN_ON(1);
+			WARN_ON_ONCE(1);
 	}
 }
 EXPORT_SYMBOL_GPL(ata_sff_tf_read);
@@ -891,7 +891,7 @@ static void ata_pio_sectors(struct ata_queued_cmd *qc)
 		/* READ/WRITE MULTIPLE */
 		unsigned int nsect;
 
-		WARN_ON(qc->dev->multi_count == 0);
+		WARN_ON_ONCE(qc->dev->multi_count == 0);
 
 		nsect = min((qc->nbytes - qc->curbytes) / qc->sect_size,
 			    qc->dev->multi_count);
@@ -918,7 +918,7 @@ static void atapi_send_cdb(struct ata_port *ap, struct ata_queued_cmd *qc)
 {
 	/* send SCSI cdb */
 	DPRINTK("send cdb\n");
-	WARN_ON(qc->dev->cdb_len < 12);
+	WARN_ON_ONCE(qc->dev->cdb_len < 12);
 
 	ap->ops->sff_data_xfer(qc->dev, qc->cdb, qc->dev->cdb_len, 1);
 	ata_sff_sync(ap);
@@ -1014,7 +1014,7 @@ next_sg:
 	}
 
 	/* consumed can be larger than count only for the last transfer */
-	WARN_ON(qc->cursg && count != consumed);
+	WARN_ON_ONCE(qc->cursg && count != consumed);
 
 	if (bytes)
 		goto next_sg;
@@ -1172,13 +1172,13 @@ int ata_sff_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 	unsigned long flags = 0;
 	int poll_next;
 
-	WARN_ON((qc->flags & ATA_QCFLAG_ACTIVE) == 0);
+	WARN_ON_ONCE((qc->flags & ATA_QCFLAG_ACTIVE) == 0);
 
 	/* Make sure ata_sff_qc_issue() does not throw things
 	 * like DMA polling into the workqueue. Notice that
 	 * in_wq is not equivalent to (qc->tf.flags & ATA_TFLAG_POLLING).
 	 */
-	WARN_ON(in_wq != ata_hsm_ok_in_wq(ap, qc));
+	WARN_ON_ONCE(in_wq != ata_hsm_ok_in_wq(ap, qc));
 
 fsm_start:
 	DPRINTK("ata%u: protocol %d task_state %d (dev_stat 0x%X)\n",
@@ -1387,7 +1387,7 @@ fsm_start:
 		DPRINTK("ata%u: dev %u command complete, drv_stat 0x%x\n",
 			ap->print_id, qc->dev->devno, status);
 
-		WARN_ON(qc->err_mask & (AC_ERR_DEV | AC_ERR_HSM));
+		WARN_ON_ONCE(qc->err_mask & (AC_ERR_DEV | AC_ERR_HSM));
 
 		ap->hsm_task_state = HSM_ST_IDLE;
 
@@ -1423,7 +1423,7 @@ void ata_pio_task(struct work_struct *work)
 	int poll_next;
 
 fsm_start:
-	WARN_ON(ap->hsm_task_state == HSM_ST_IDLE);
+	WARN_ON_ONCE(ap->hsm_task_state == HSM_ST_IDLE);
 
 	/*
 	 * This is purely heuristic.  This is a fast path.
@@ -1512,7 +1512,7 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 		break;
 
 	case ATA_PROT_DMA:
-		WARN_ON(qc->tf.flags & ATA_TFLAG_POLLING);
+		WARN_ON_ONCE(qc->tf.flags & ATA_TFLAG_POLLING);
 
 		ap->ops->sff_tf_load(ap, &qc->tf);  /* load tf registers */
 		ap->ops->bmdma_setup(qc);	    /* set up bmdma */
@@ -1564,7 +1564,7 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 		break;
 
 	case ATAPI_PROT_DMA:
-		WARN_ON(qc->tf.flags & ATA_TFLAG_POLLING);
+		WARN_ON_ONCE(qc->tf.flags & ATA_TFLAG_POLLING);
 
 		ap->ops->sff_tf_load(ap, &qc->tf);  /* load tf registers */
 		ap->ops->bmdma_setup(qc);	    /* set up bmdma */
@@ -1576,7 +1576,7 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
 		break;
 
 	default:
-		WARN_ON(1);
+		WARN_ON_ONCE(1);
 		return AC_ERR_SYSTEM;
 	}
 
