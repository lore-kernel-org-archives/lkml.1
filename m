Return-Path: <linux-kernel-owner+w=401wt.eu-S933449AbXCTJ0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbXCTJ0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933416AbXCTJ0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:26:23 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:42288 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413AbXCTJ0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:26:21 -0400
From: Tony Vroon <chainsaw@gentoo.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <htejun@gmail.com>, <alan@lxorguk.ukuu.org.uk>,
       <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.22 RESEND] Optional LED trigger for libata
Message-Id: <20070320092612.82EF65B80F1@ganymede.vroon.org>
Date: Tue, 20 Mar 2007 09:26:12 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an optional wrapper around ata_ac_issue_prot that triggers the LED layer.
This is used for the PMU LED on G5 towers (IDE trigger). My test platform is a 
PowerMac 7,3 (Dual G5 2.0GHz, June 2004) with a K2 (sata_svw) controller.
Now respun as a single patch, and the function name shortened as requested.

Signed-off-by: Tony Vroon <chainsaw@gentoo.org>

diff -uNr linux-2.6.ORIG/drivers/ata/libata-core.c linux-2.6/drivers/ata/libata-core.c
--- linux-2.6.ORIG/drivers/ata/libata-core.c	2007-03-20 09:10:44.000000000 +0000
+++ linux-2.6/drivers/ata/libata-core.c	2007-03-20 09:17:53.000000000 +0000
@@ -49,6 +49,7 @@
 #include <linux/workqueue.h>
 #include <linux/jiffies.h>
 #include <linux/scatterlist.h>
+#include <linux/leds.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -5050,6 +5051,25 @@
 }
 
 /**
+ *	ata_qc_issue_prot_ledtrigger - trigger LED core
+ *	@qc: command to issue to device
+ *
+ *	This triggers the LED core and then calls the
+ *	regular ata_qc_issue_prot function.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ *
+ *	RETURNS:
+ *	Zero on success, AC_ERR_* mask on failure
+ */
+unsigned int ata_qc_issue_prot_ledtrigger(struct ata_queued_cmd *qc)
+{
+	ledtrig_ide_activity();	
+	return ata_qc_issue_prot(qc);
+}
+
+/**
  *	ata_host_intr - Handle host interrupt for given (port, task)
  *	@ap: Port on which interrupt arrived (possibly...)
  *	@qc: Taskfile currently active in engine
@@ -6316,6 +6336,7 @@
 EXPORT_SYMBOL_GPL(ata_qc_complete);
 EXPORT_SYMBOL_GPL(ata_qc_complete_multiple);
 EXPORT_SYMBOL_GPL(ata_qc_issue_prot);
+EXPORT_SYMBOL_GPL(ata_qc_issue_prot_ledtrigger);
 EXPORT_SYMBOL_GPL(ata_tf_load);
 EXPORT_SYMBOL_GPL(ata_tf_read);
 EXPORT_SYMBOL_GPL(ata_noop_dev_select);
diff -uNr linux-2.6.ORIG/drivers/ata/sata_svw.c linux-2.6/drivers/ata/sata_svw.c
--- linux-2.6.ORIG/drivers/ata/sata_svw.c	2007-03-20 09:10:44.000000000 +0000
+++ linux-2.6/drivers/ata/sata_svw.c	2007-03-20 09:17:17.000000000 +0000
@@ -348,7 +348,7 @@
 	.bmdma_stop		= ata_bmdma_stop,
 	.bmdma_status		= ata_bmdma_status,
 	.qc_prep		= ata_qc_prep,
-	.qc_issue		= ata_qc_issue_prot,
+	.qc_issue		= ata_qc_issue_prot_ledtrigger,
 	.data_xfer		= ata_data_xfer,
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
diff -uNr linux-2.6.ORIG/include/linux/libata.h linux-2.6/include/linux/libata.h
--- linux-2.6.ORIG/include/linux/libata.h	2007-03-20 09:11:46.000000000 +0000
+++ linux-2.6/include/linux/libata.h	2007-03-20 09:17:32.000000000 +0000
@@ -786,6 +786,7 @@
 extern void ata_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc);
+extern unsigned int ata_qc_issue_prot_ledtrigger(struct ata_queued_cmd *qc);
 extern void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf,
 		unsigned int buflen);
 extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
