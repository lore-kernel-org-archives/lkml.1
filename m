Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZEYHc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZEYHc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZEYHbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:31:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38661 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZEYHbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:11 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 04/13] scsi: get rid of lock in __scsi_put_command()
Date: Mon, 25 May 2009 09:30:50 +0200
Message-Id: <1243236668-3398-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A memory barrier is enough to check for the list being empty
or not, then we only have to grab the lock if we stole the
reserved command (which is very unlikely).

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/scsi.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 6a993af..da33b7a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -293,15 +293,15 @@ EXPORT_SYMBOL(scsi_get_command);
 void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 			struct device *dev)
 {
-	unsigned long flags;
-
-	/* changing locks here, don't need to restore the irq state */
-	spin_lock_irqsave(&shost->free_list_lock, flags);
+	smp_mb();
 	if (unlikely(list_empty(&shost->free_list))) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&shost->free_list_lock, flags);
 		list_add(&cmd->list, &shost->free_list);
+		spin_unlock_irqrestore(&shost->free_list_lock, flags);
 		cmd = NULL;
 	}
-	spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
 	if (likely(cmd != NULL))
 		scsi_pool_free_command(shost->cmd_pool, cmd);
-- 
1.6.3.rc0.1.gf800

