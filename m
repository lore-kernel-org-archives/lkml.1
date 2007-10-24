Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbXJXXuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbXJXXuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 19:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758840AbXJXXsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 19:48:39 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53280 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758293AbXJXXsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 19:48:33 -0400
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org
Subject: [PATCH 4/4] [SCSI] ips: handle scsi_add_host() failure, and other err cleanups
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org>
Message-Id: <20071024234832.58C3B1F81AB@havoc.gtf.org>
Date: Wed, 24 Oct 2007 19:48:32 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/scsi/ips.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index fb90b6c..b8e2f5a 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -6836,13 +6836,10 @@ ips_register_scsi(int index)
 	if (request_irq(ha->pcidev->irq, do_ipsintr, IRQF_SHARED, ips_name, ha)) {
 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
 			   "Unable to install interrupt handler\n");
-		scsi_host_put(sh);
-		return -1;
+		goto err_out_sh;
 	}
 
 	kfree(oldha);
-	ips_sh[index] = sh;
-	ips_ha[index] = ha;
 
 	/* Store away needed values for later use */
 	sh->unique_id = (ha->io_addr) ? ha->io_addr : ha->mem_addr;
@@ -6858,10 +6855,21 @@ ips_register_scsi(int index)
 	sh->max_channel = ha->nbus - 1;
 	sh->can_queue = ha->max_cmds - 1;
 
-	scsi_add_host(sh, NULL);
+	if (scsi_add_host(sh, &ha->pcidev->dev))
+		goto err_out;
+
+	ips_sh[index] = sh;
+	ips_ha[index] = ha;
+
 	scsi_scan_host(sh);
 
 	return 0;
+
+err_out:
+	free_irq(ha->pcidev->irq, ha);
+err_out_sh:
+	scsi_host_put(sh);
+	return -1;
 }
 
 /*---------------------------------------------------------------------------*/
-- 
1.5.2.4

