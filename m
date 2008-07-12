Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYGLXaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYGLXaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYGLXaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:30:14 -0400
Received: from mail4.aster.pl ([212.76.33.58]:22341 "EHLO mail4.aster.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbYGLXaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:30:13 -0400
Content-Disposition: inline
From: "Jakub W. Jozwicki" <jozwicki@aster.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.25.10 2/2] libata: fix locking for kmap_atomic
Date: Sun, 13 Jul 2008 01:29:58 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200807130129.58371.jozwicki@aster.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change locking surrounding kmap_atomic from local_irqsave to 
local_irqsave_nort. This fixes issues with PREEMPT_RT.
 
Signed-off-by:  Jakub Jozwicki <jozwicki@aster.pl>

--- linux-2.6.25.10/drivers/ata/libata-scsi.c	2008-07-03 05:46:47.000000000 
+0200
+++ linux-2.6.25.10-rt7/drivers/ata/libata-scsi.c	2008-07-13 
00:47:51.128016829 +0200
@@ -1705,14 +1705,14 @@
 	struct scsi_cmnd *cmd = args->cmd;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	local_irq_save_nort(flags);
 
 	buflen = ata_scsi_rbuf_get(cmd, &rbuf);
 	memset(rbuf, 0, buflen);
 	rc = actor(args, rbuf, buflen);
 	ata_scsi_rbuf_put(cmd, rbuf);
 
-	local_irq_restore(flags);
+	local_irq_restore_nort(flags);
 
 	if (rc == 0)
 		cmd->result = SAM_STAT_GOOD;
@@ -2489,7 +2489,7 @@
 			unsigned int buflen;
 			unsigned long flags;
 
-			local_irq_save(flags);
+			local_irq_save_nort(flags);
 
 			buflen = ata_scsi_rbuf_get(cmd, &buf);
 
@@ -2508,7 +2508,7 @@
 
 			ata_scsi_rbuf_put(cmd, buf);
 
-			local_irq_restore(flags);
+			local_irq_restore_nort(flags);
 		}
 
 		cmd->result = SAM_STAT_GOOD;
