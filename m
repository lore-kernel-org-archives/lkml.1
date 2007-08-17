Return-Path: <linux-kernel-owner+w=401wt.eu-S1762665AbXHQOYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762665AbXHQOYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 10:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbXHQOXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 10:23:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:51703 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755697AbXHQOXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 10:23:54 -0400
X-Authenticated: #402683
X-Provags-ID: V01U2FsdGVkX189vyFHt1c9i2nyS1V0J9eyZWdemGKV+ulwYcF9uf
	72Cmc0DqcLHaxi
Subject: [PATCH] [SCSI] arcmsr: Fix error handling
From: Maik Hampel <m.hampel@gmx.de>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "erich@areca.com.tw" <erich@areca.com.tw>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 16:23:47 +0200
Message-Id: <1187360627.2665.8.camel@c64>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed error handling in queuecommand(), now all READ_ and WRITE_ commands
are aborted in case of RAID is gone. Before only READ_6 and WRITE_6 commands
were aborted.

Signed-off-by: Maik Hampel <m.hampel@gmx.de>
---
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 0ddfc21..7a001ad 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1133,17 +1133,27 @@ static int arcmsr_queue_command(struct scsi_cmnd *cmd,
 		uint8_t block_cmd;
 
 		block_cmd = cmd->cmnd[0] & 0x0f;
-		if (block_cmd == 0x08 || block_cmd == 0x0a) {
-			printk(KERN_NOTICE
-				"arcmsr%d: block 'read/write'"
-				"command with gone raid volume"
-				" Cmd = %2x, TargetId = %d, Lun = %d \n"
-				, acb->host->host_no
-				, cmd->cmnd[0]
-				, target, lun);
-			cmd->result = (DID_NO_CONNECT << 16);
-			cmd->scsi_done(cmd);
-			return 0;
+		switch (block_cmd) {
+			case READ_6:
+			case READ_10:
+			case READ_12:
+			case READ_16:
+			case WRITE_6:
+			case WRITE_10:
+			case WRITE_12:
+			case WRITE_16:
+				printk(KERN_NOTICE
+					"arcmsr%d: block 'read/write'"
+					"command with gone raid volume"
+					" Cmd = %2x, TargetId = %d, Lun = %d \n"
+					, acb->host->host_no
+					, cmd->cmnd[0]
+					, target, lun);
+				cmd->result = (DID_NO_CONNECT << 16);
+				cmd->scsi_done(cmd);
+				return 0;
+			default:
+				break;
 		}
 	}
 	if (atomic_read(&acb->ccboutstandingcount) >=
-- 
1.4.4.4



