Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZIWOQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZIWOQL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbZIWOP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:15:26 -0400
Received: from server1.wserver.cz ([82.113.45.157]:58698 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbZIWOPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:15:25 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 5/5] SCSI: scsi_lib, fix potential NULL dereference
Date: Wed, 23 Sep 2009 16:15:35 +0200
Message-Id: <1253715335-6723-5-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1253715335-6723-1-git-send-email-jirislaby@gmail.com>
References: <1253715335-6723-1-git-send-email-jirislaby@gmail.com>
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
index 5987da8..98f601a 100644
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

