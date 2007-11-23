Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbXKWCGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbXKWCGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 21:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXKWCGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 21:06:37 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:41226 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXKWCGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 21:06:36 -0500
Date: Thu, 22 Nov 2007 20:05:52 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] sata_nv: don't use legacy DMA in ADMA mode (v2)
To: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
Message-id: <47463580.8080909@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We need to run any DMA command with result taskfile requested in ADMA mode
when the port is in ADMA mode, otherwise it may try to use the legacy DMA engine
in ADMA mode which is not allowed. Enforce this with BUG_ON() since data
corruption could potentially result if this happened. Also WARN_ON() if we try
and send result taskfile commands while NCQ commands are still active, since the
hardware doesn't allow this.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.24-rc3-git1/drivers/ata/sata_nv.c	2007-11-20 17:40:09.000000000 -0600
+++ linux-2.6.24-rc3-git1edit/drivers/ata/sata_nv.c	2007-11-22 19:40:58.000000000 -0600
@@ -791,11 +791,13 @@
 
 static void nv_adma_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
-	/* Since commands where a result TF is requested are not
-	   executed in ADMA mode, the only time this function will be called
-	   in ADMA mode will be if a command fails. In this case we
-	   don't care about going into register mode with ADMA commands
-	   pending, as the commands will all shortly be aborted anyway. */
+	/* Other than when internal or pass-through commands are executed,
+	   the only time this function will be called in ADMA mode will be
+	   if a command fails. In the failure case we don't care about going
+	   into register mode with ADMA commands pending, as the commands will
+	   all shortly be aborted anyway. We assume that NCQ commands are not
+	   issued via passthrough, which is the only way that switching into
+	   ADMA mode could abort outstanding commands. */
 	nv_adma_register_mode(ap);
 
 	ata_tf_read(ap, tf);
@@ -1359,11 +1361,9 @@
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 
 	/* ADMA engine can only be used for non-ATAPI DMA commands,
-	   or interrupt-driven no-data commands, where a result taskfile
-	   is not required. */
+	   or interrupt-driven no-data commands. */
 	if ((pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
-	   (qc->tf.flags & ATA_TFLAG_POLLING) ||
-	   (qc->flags & ATA_QCFLAG_RESULT_TF))
+	   (qc->tf.flags & ATA_TFLAG_POLLING))
 		return 1;
 
 	if ((qc->flags & ATA_QCFLAG_DMAMAP) ||
@@ -1381,6 +1381,8 @@
 		       NV_CPB_CTL_IEN;
 
 	if (nv_adma_use_reg_mode(qc)) {
+		BUG_ON(!(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) &&
+			(qc->flags & ATA_QCFLAG_DMAMAP));
 		nv_adma_register_mode(qc->ap);
 		ata_qc_prep(qc);
 		return;
@@ -1425,9 +1427,17 @@
 
 	VPRINTK("ENTER\n");
 
+	/* We can't handle result taskfile with NCQ commands active, since
+	   retrieving the taskfile switches us out of ADMA mode and would abort
+	   existing commands. */
+	WARN_ON((qc->flags & ATA_QCFLAG_RESULT_TF) &&
+		(qc->ap->qc_allocated & ~(1 << qc->tag)));
+
 	if (nv_adma_use_reg_mode(qc)) {
 		/* use ATA register mode */
 		VPRINTK("using ATA register mode: 0x%lx\n", qc->flags);
+		BUG_ON(!(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) &&
+			(qc->flags & ATA_QCFLAG_DMAMAP));
 		nv_adma_register_mode(qc->ap);
 		return ata_qc_issue_prot(qc);
 	} else

