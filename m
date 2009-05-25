Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZEYHcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZEYHcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZEYHbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:31:15 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38647 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbZEYHbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:11 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 03/13] scsi: unify allocation of scsi command and sense buffer
Date: Mon, 25 May 2009 09:30:48 +0200
Message-Id: <1243236668-3398-6-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fold the sense buffer into the command, thereby eliminating a slab
allocation and free per command.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/scsi.c      |   44 ++++++++++----------------------------------
 include/scsi/scsi_cmnd.h |   12 ++++++------
 2 files changed, 16 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 166417a..6a993af 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -133,7 +133,6 @@ EXPORT_SYMBOL(scsi_device_type);
 
 struct scsi_host_cmd_pool {
 	struct kmem_cache	*cmd_slab;
-	struct kmem_cache	*sense_slab;
 	unsigned int		users;
 	char			*cmd_name;
 	char			*sense_name;
@@ -167,20 +166,9 @@ static DEFINE_MUTEX(host_cmd_pool_mutex);
 static struct scsi_cmnd *
 scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
 {
-	struct scsi_cmnd *cmd;
-
-	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
-	if (!cmd)
-		return NULL;
+	gfp_t gfp = gfp_mask | pool->gfp_mask;
 
-	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
-					     gfp_mask | pool->gfp_mask);
-	if (!cmd->sense_buffer) {
-		kmem_cache_free(pool->cmd_slab, cmd);
-		return NULL;
-	}
-
-	return cmd;
+	return kmem_cache_zalloc(pool->cmd_slab, gfp);
 }
 
 /**
@@ -198,7 +186,6 @@ scsi_pool_free_command(struct scsi_host_cmd_pool *pool,
 	if (cmd->prot_sdb)
 		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
 
-	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
 	kmem_cache_free(pool->cmd_slab, cmd);
 }
 
@@ -242,7 +229,6 @@ scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 {
 	struct scsi_cmnd *cmd;
-	unsigned char *buf;
 
 	cmd = scsi_host_alloc_command(shost, gfp_mask);
 
@@ -257,11 +243,8 @@ struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost, gfp_t gfp_mask)
 		}
 		spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
-		if (cmd) {
-			buf = cmd->sense_buffer;
+		if (cmd)
 			memset(cmd, 0, sizeof(*cmd));
-			cmd->sense_buffer = buf;
-		}
 	}
 
 	return cmd;
@@ -361,19 +344,13 @@ static struct scsi_host_cmd_pool *scsi_get_host_cmd_pool(gfp_t gfp_mask)
 	pool = (gfp_mask & __GFP_DMA) ? &scsi_cmd_dma_pool :
 		&scsi_cmd_pool;
 	if (!pool->users) {
-		pool->cmd_slab = kmem_cache_create(pool->cmd_name,
-						   sizeof(struct scsi_cmnd), 0,
-						   pool->slab_flags, NULL);
-		if (!pool->cmd_slab)
-			goto fail;
+		unsigned int slab_size;
 
-		pool->sense_slab = kmem_cache_create(pool->sense_name,
-						     SCSI_SENSE_BUFFERSIZE, 0,
-						     pool->slab_flags, NULL);
-		if (!pool->sense_slab) {
-			kmem_cache_destroy(pool->cmd_slab);
+		slab_size = sizeof(struct scsi_cmnd) + SCSI_SENSE_BUFFERSIZE;
+		pool->cmd_slab = kmem_cache_create(pool->cmd_name, slab_size,
+						   0, pool->slab_flags, NULL);
+		if (!pool->cmd_slab)
 			goto fail;
-		}
 	}
 
 	pool->users++;
@@ -397,10 +374,9 @@ static void scsi_put_host_cmd_pool(gfp_t gfp_mask)
 	 */
 	BUG_ON(pool->users == 0);
 
-	if (!--pool->users) {
+	if (!--pool->users)
 		kmem_cache_destroy(pool->cmd_slab);
-		kmem_cache_destroy(pool->sense_slab);
-	}
+
 	mutex_unlock(&host_cmd_pool_mutex);
 }
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 43b50d3..649ad36 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -102,12 +102,6 @@ struct scsi_cmnd {
 	struct request *request;	/* The command we are
 				   	   working on */
 
-#define SCSI_SENSE_BUFFERSIZE 	96
-	unsigned char *sense_buffer;
-				/* obtained by REQUEST SENSE when
-				 * CHECK CONDITION is received on original
-				 * command (auto-sense) */
-
 	/* Low-level done function - can be used by low-level driver to point
 	 *        to completion function.  Not used by mid/upper level code. */
 	void (*scsi_done) (struct scsi_cmnd *);
@@ -129,6 +123,12 @@ struct scsi_cmnd {
 	int result;		/* Status code from lower level driver */
 
 	unsigned char tag;	/* SCSI-II queued command tag */
+
+#define SCSI_SENSE_BUFFERSIZE 	96
+	unsigned char sense_buffer[0];
+				/* obtained by REQUEST SENSE when
+				 * CHECK CONDITION is received on original
+				 * command (auto-sense) */
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
-- 
1.6.3.rc0.1.gf800

