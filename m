Return-Path: <linux-kernel-owner+w=401wt.eu-S1763927AbXEPIlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763927AbXEPIlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762323AbXEPIe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:34:28 -0400
Received: from brick.kernel.dk ([80.160.20.94]:6629 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761461AbXEPIeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:34:09 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 16/19] scsi: simplify scsi_free_sgtable()
Date: Wed, 16 May 2007 10:32:30 +0200
Message-Id: <11793043544050-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11793043533744-git-send-email-jens.axboe@oracle.com>
References: <11793043533744-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just pass in the command, no point in passing in the scatterlist
and scatterlist pool index seperately.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/scsi_lib.c     |    9 +++++----
 drivers/scsi/scsi_tgt_lib.c |    4 ++--
 include/scsi/scsi_cmnd.h    |    2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f944690..26236b1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -745,13 +745,14 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 
 EXPORT_SYMBOL(scsi_alloc_sgtable);
 
-void scsi_free_sgtable(struct scatterlist *sgl, int index)
+void scsi_free_sgtable(struct scsi_cmnd *cmd)
 {
+	struct scatterlist *sgl = cmd->request_buffer;
 	struct scsi_host_sg_pool *sgp;
 
-	BUG_ON(index >= SG_MEMPOOL_NR);
+	BUG_ON(cmd->sglist_len >= SG_MEMPOOL_NR);
 
-	sgp = scsi_sg_pools + index;
+	sgp = scsi_sg_pools + cmd->sglist_len;
 	mempool_free(sgl, sgp->pool);
 }
 
@@ -777,7 +778,7 @@ EXPORT_SYMBOL(scsi_free_sgtable);
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
 	if (cmd->use_sg)
-		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+		scsi_free_sgtable(cmd);
 
 	/*
 	 * Zero these out.  They now point to freed memory, and it is
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 2570f48..d6e58e5 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -329,7 +329,7 @@ static void scsi_tgt_cmd_done(struct scsi_cmnd *cmd)
 	scsi_tgt_uspace_send_status(cmd, tcmd->tag);
 
 	if (cmd->request_buffer)
-		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+		scsi_free_sgtable(cmd);
 
 	queue_work(scsi_tgtd, &tcmd->work);
 }
@@ -370,7 +370,7 @@ static int scsi_tgt_init_cmd(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 	}
 
 	eprintk("cmd %p cnt %d\n", cmd, cmd->use_sg);
-	scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+	scsi_free_sgtable(cmd);
 	return -EINVAL;
 }
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2e0c10..d7db992 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -133,6 +133,6 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 extern void scsi_kunmap_atomic_sg(void *virt);
 
 extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scatterlist *, int);
+extern void scsi_free_sgtable(struct scsi_cmnd *);
 
 #endif /* _SCSI_SCSI_CMND_H */
-- 
1.5.2.rc1

