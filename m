Return-Path: <linux-kernel-owner+w=401wt.eu-S2993198AbXDSIK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993198AbXDSIK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993196AbXDSIKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:10:44 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33935 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993198AbXDSIKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:10:13 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] sas_scsi_host: Convert to use the kthread API
Date: Thu, 19 Apr 2007 01:58:38 -0600
Message-Id: <11769695611073-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This patch modifies the sas scsi host thread startup
to use kthread_run not kernel_thread and deamonize.
kthread_run is slightly simpler and more maintainable.

Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 46ba3a7..7a38ac5 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -40,6 +40,7 @@
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 
 /* ---------- SCSI Host glue ---------- */
 
@@ -870,7 +871,6 @@ static int sas_queue_thread(void *_sas_ha)
 	struct sas_ha_struct *sas_ha = _sas_ha;
 	struct scsi_core *core = &sas_ha->core;
 
-	daemonize("sas_queue_%d", core->shost->host_no);
 	current->flags |= PF_NOFREEZE;
 
 	complete(&queue_th_comp);
@@ -891,19 +891,20 @@ static int sas_queue_thread(void *_sas_ha)
 
 int sas_init_queue(struct sas_ha_struct *sas_ha)
 {
-	int res;
 	struct scsi_core *core = &sas_ha->core;
+	struct task_struct *task;
 
 	spin_lock_init(&core->task_queue_lock);
 	core->task_queue_size = 0;
 	INIT_LIST_HEAD(&core->task_queue);
 	init_MUTEX_LOCKED(&core->queue_thread_sema);
 
-	res = kernel_thread(sas_queue_thread, sas_ha, 0);
-	if (res >= 0)
+	task = kthread_run(sas_queue_thread, sas_ha,
+			   "sas_queue_%d", core->shost->host_no);
+	if (!IS_ERR(task))
 		wait_for_completion(&queue_th_comp);
 
-	return res < 0 ? res : 0;
+	return IS_ERR(task) ? PTR_ERR(task) : 0;
 }
 
 void sas_shutdown_queue(struct sas_ha_struct *sas_ha)
-- 
1.5.0.g53756

