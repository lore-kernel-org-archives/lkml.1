Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbZJIN6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbZJIN6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932672AbZJIN6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:58:49 -0400
Received: from server1.wserver.cz ([82.113.45.157]:37649 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760864AbZJIN6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:58:46 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH -repost 4/4] SCSI: scsi_lib, fix potential NULL dereference
Date: Fri,  9 Oct 2009 15:58:08 +0200
Message-Id: <1255096688-23399-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255096688-23399-1-git-send-email-jirislaby@gmail.com>
References: <1255096688-23399-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a potential NULL dereference in scsi_kill_request.

Instead of triggering BUG() in 'if (unlikely(cmd == NULL))' branch,
the kernel will Oops earlier on cmd dereference.

Move the dereferences after the if.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/scsi_lib.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 39b5858..53bdd25 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1359,9 +1359,9 @@ static int scsi_lld_busy(struct request_queue *q)
 static void scsi_kill_request(struct request *req, struct request_queue *q)
 {
 	struct scsi_cmnd *cmd = req->special;
-	struct scsi_device *sdev = cmd->device;
-	struct scsi_target *starget = scsi_target(sdev);
-	struct Scsi_Host *shost = sdev->host;
+	struct scsi_device *sdev;
+	struct scsi_target *starget;
+	struct Scsi_Host *shost;
 
 	blk_start_request(req);
 
@@ -1371,6 +1371,9 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 		BUG();
 	}
 
+	sdev = cmd->device;
+	starget = scsi_target(sdev);
+	shost = sdev->host;
 	scsi_init_cmd_errh(cmd);
 	cmd->result = DID_NO_CONNECT << 16;
 	atomic_inc(&cmd->device->iorequest_cnt);
-- 
1.6.4.2

