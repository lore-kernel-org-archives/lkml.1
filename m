Return-Path: <linux-kernel-owner+w=401wt.eu-S965766AbXCFCWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965766AbXCFCWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965764AbXCFCWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:22:48 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:26827 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965766AbXCFCWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:22:45 -0500
Date: Mon, 05 Mar 2007 20:21:47 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] sata_nv: don't read shadow registers when in ADMA mode
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>
Message-id: <45ECD03B.80306@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reading from the ATA shadow registers while we are in ADMA mode may cause
undefined behavior. Don't read the ATA status register when completing commands
for this reason, it shouldn't be needed as the controller will notify us if
the command failed. Also, don't allow commands with result taskfile requested
to execute in ADMA mode, since that requires accessing the shadow registers.
We also still need to override tf_read since libata will read the result
taskfile on a command failure, and we need to go into port register mode
before allowing this.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.21-rc2-git3/drivers/ata/sata_nv.c	2007-03-04 14:44:05.000000000 -0600
+++ linux-2.6.21-rc2-git3edit/drivers/ata/sata_nv.c	2007-03-05 19:55:14.000000000 -0600
@@ -260,6 +260,7 @@ static int nv_adma_port_resume(struct at
 static void nv_adma_error_handler(struct ata_port *ap);
 static void nv_adma_host_stop(struct ata_host *host);
 static void nv_adma_post_internal_cmd(struct ata_queued_cmd *qc);
+static void nv_adma_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
 
 enum nv_host_type
 {
@@ -435,7 +436,7 @@ static const struct ata_port_operations 
 static const struct ata_port_operations nv_adma_ops = {
 	.port_disable		= ata_port_disable,
 	.tf_load		= ata_tf_load,
-	.tf_read		= ata_tf_read,
+	.tf_read		= nv_adma_tf_read,
 	.check_atapi_dma	= nv_adma_check_atapi_dma,
 	.exec_command		= ata_exec_command,
 	.check_status		= ata_check_status,
@@ -667,6 +668,18 @@ static int nv_adma_check_atapi_dma(struc
 	return !(pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE);
 }
 
+static void nv_adma_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
+{
+	/* Since commands where a result TF is requested are not
+	   executed in ADMA mode, the only time this function will be called
+	   in ADMA mode will be if a command fails. In this case we
+	   don't care about going into register mode with ADMA commands
+	   pending, as the commands will all shortly be aborted anyway. */
+	nv_adma_register_mode(ap);
+
+	ata_tf_read(ap, tf);
+}
+
 static unsigned int nv_adma_tf_to_cpb(struct ata_taskfile *tf, __le16 *cpb)
 {
 	unsigned int idx = 0;
@@ -738,19 +751,11 @@ static int nv_adma_check_cpb(struct ata_
 		return 1;
 	}
 
-	if (flags & NV_CPB_RESP_DONE) {
+	if (likely(flags & NV_CPB_RESP_DONE)) {
 		struct ata_queued_cmd *qc = ata_qc_from_tag(ap, cpb_num);
 		VPRINTK("CPB flags done, flags=0x%x\n", flags);
 		if (likely(qc)) {
-			/* Grab the ATA port status for non-NCQ commands.
-			   For NCQ commands the current status may have nothing to do with
-			   the command just completed. */
-			if (qc->tf.protocol != ATA_PROT_NCQ) {
-				u8 ata_status = readb(pp->ctl_block + (ATA_REG_STATUS * 4));
-				qc->err_mask |= ac_err_mask(ata_status);
-			}
-			DPRINTK("Completing qc from tag %d with err_mask %u\n",cpb_num,
-				qc->err_mask);
+			DPRINTK("Completing qc from tag %d\n",cpb_num);
 			ata_qc_complete(qc);
 		} else {
 			struct ata_eh_info *ehi = &ap->eh_info;
@@ -1161,9 +1166,11 @@ static int nv_adma_use_reg_mode(struct a
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 
 	/* ADMA engine can only be used for non-ATAPI DMA commands,
-	   or interrupt-driven no-data commands. */
+	   or interrupt-driven no-data commands, where a result taskfile
+	   is not required. */
 	if((pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) ||
-	   (qc->tf.flags & ATA_TFLAG_POLLING))
+	   (qc->tf.flags & ATA_TFLAG_POLLING) ||
+	   (qc->flags & ATA_QCFLAG_RESULT_TF))
 		return 1;
 
 	if((qc->flags & ATA_QCFLAG_DMAMAP) ||

