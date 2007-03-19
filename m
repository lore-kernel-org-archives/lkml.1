Return-Path: <linux-kernel-owner+w=401wt.eu-S1030657AbXCSVsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030657AbXCSVsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030678AbXCSVsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:48:19 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:55971 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030657AbXCSVsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:48:14 -0400
From: Tony Vroon <chainsaw@gentoo.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: <htejun@gmail.com>, <alan@lxorguk.ukuu.org.uk>,
       <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.22 1/3] Add LED trigger to libata core
Message-Id: <20070319214805.41D0A5B80F1@ganymede.vroon.org>
Date: Mon, 19 Mar 2007 21:48:05 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an optional wrapper around ata_ac_issue_prot that triggers the LED layer.
I plan to use this by allowing PMU LED control on G5 towers. My test platform 
is a PowerMac 7,3 (Dual G5 2.0GHz, June 2004) with a K2 (sata_svw) controller.
Respin of an earlier patch, based on comments by Tejun Heo & Alan Cox.

Signed-off-by: Tony Vroon <chainsaw@gentoo.org>

--- linux-2.6/drivers/ata/libata-core.c.orig	2007-03-19 20:03:07.000000000 +0000
+++ linux-2.6/drivers/ata/libata-core.c	2007-03-19 21:05:50.000000000 +0000
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
+ *	ata_qc_issue_prot_with_ledtrigger - trigger LED core
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
+unsigned int ata_qc_issue_prot_with_ledtrigger(struct ata_queued_cmd *qc)
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
+EXPORT_SYMBOL_GPL(ata_qc_issue_prot_with_ledtrigger);
 EXPORT_SYMBOL_GPL(ata_tf_load);
 EXPORT_SYMBOL_GPL(ata_tf_read);
 EXPORT_SYMBOL_GPL(ata_noop_dev_select);
