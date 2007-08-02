Return-Path: <linux-kernel-owner+w=401wt.eu-S1760073AbXHBSxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760073AbXHBSxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 14:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbXHBSw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 14:52:57 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:55920 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759513AbXHBSwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 14:52:53 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Aug 2007 14:52:53 EDT
From: Tony Vroon <chainsaw@gentoo.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <htejun@gmail.com>, <alan@lxorguk.ukuu.org.uk>,
       <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Optional libata LED trigger for PowerMac G5
Message-Id: <20070802184541.6F2335B80A8@ganymede.vroon.org>
Date: Thu,  2 Aug 2007 19:45:41 +0100 (BST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an optional wrapper around ata_ac_issue_prot that triggers the LED layer.
Powermac G5 machines with an Apple K2 controller will now blink the PMU LED to 
harddisk activity if CONFIG_ADB_PMU_LED_IDE is defined (like on a PowerBook/iBook).
This avoids any pollution of the hot path on non-PowerMacs and makes the functionality 
fully optional.

Jeff, hopefully this version addresses your earlier concerns voiced on May 25 this year.

Signed-off-by: Tony Vroon <chainsaw@gentoo.org>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 60e78be..9c687db 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -49,6 +49,7 @@
 #include <linux/workqueue.h>
 #include <linux/jiffies.h>
 #include <linux/scatterlist.h>
+#include <linux/leds.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -5569,6 +5570,25 @@ unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc)
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
@@ -6873,6 +6893,7 @@ EXPORT_SYMBOL_GPL(ata_hsm_move);
 EXPORT_SYMBOL_GPL(ata_qc_complete);
 EXPORT_SYMBOL_GPL(ata_qc_complete_multiple);
 EXPORT_SYMBOL_GPL(ata_qc_issue_prot);
+EXPORT_SYMBOL_GPL(ata_qc_issue_prot_ledtrigger);
 EXPORT_SYMBOL_GPL(ata_tf_load);
 EXPORT_SYMBOL_GPL(ata_tf_read);
 EXPORT_SYMBOL_GPL(ata_noop_dev_select);
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 92e8770..af3e57b 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -341,7 +341,11 @@ static const struct ata_port_operations k2_sata_ops = {
 	.bmdma_stop		= ata_bmdma_stop,
 	.bmdma_status		= ata_bmdma_status,
 	.qc_prep		= ata_qc_prep,
+#ifdef CONFIG_ADB_PMU_LED_IDE
+	.qc_issue		= ata_qc_issue_prot_ledtrigger,
+#else
 	.qc_issue		= ata_qc_issue_prot,
+#endif
 	.data_xfer		= ata_data_xfer,
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 41978a5..ebda8ee 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -790,6 +790,7 @@ extern void ata_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc);
+extern unsigned int ata_qc_issue_prot_ledtrigger(struct ata_queued_cmd *qc);
 extern void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf,
 		unsigned int buflen);
 extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
