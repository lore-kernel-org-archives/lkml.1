Return-Path: <linux-kernel-owner+w=401wt.eu-S966016AbXBOQGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966016AbXBOQGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966019AbXBOQGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:06:15 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:43396 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966016AbXBOQGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:06:15 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org, hch@infradead.org,
       raisch@de.ibm.com, bos@patchscale.com
Subject: [PATCH 2.6.21-rc1 4/5] ehca: replace yield() by wait_for_completion()
Date: Thu, 15 Feb 2007 17:09:44 +0100
User-Agent: KMail/1.8.2
Cc: heiko.carstens@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702151709.45323.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

remove yield() and use wait_for_completion() in order to wait for running
completion handlers finished before destroying associated completion queue


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---


 ehca_classes.h |    3 +++
 ehca_cq.c      |    5 +++--
 ehca_irq.c     |    6 +++++-
 3 files changed, 11 insertions(+), 3 deletions(-)


diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 40404c9..d8ce0c8 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -52,6 +52,8 @@ struct ehca_mw;
 struct ehca_pd;
 struct ehca_av;
 
+#include <linux/completion.h>
+
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
 
@@ -154,6 +156,7 @@ struct ehca_cq {
 	struct hlist_head qp_hashtab[QP_HASHTAB_LEN];
 	struct list_head entry;
 	u32 nr_callbacks;
+	struct completion zero_callbacks;
 	spinlock_t task_lock;
 	u32 ownpid;
 	/* mmap counter for resources mapped into user space */
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 9291a86..906bd5b 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -147,6 +147,7 @@ struct ib_cq *ehca_create_cq(struct ib_d
 	spin_lock_init(&my_cq->spinlock);
 	spin_lock_init(&my_cq->cb_lock);
 	spin_lock_init(&my_cq->task_lock);
+	init_completion(&my_cq->zero_callbacks);
 	my_cq->ownpid = current->tgid;
 
 	cq = &my_cq->ib_cq;
@@ -330,9 +331,9 @@ int ehca_destroy_cq(struct ib_cq *cq)
 	}
 
 	spin_lock_irqsave(&ehca_cq_idr_lock, flags);
-	while (my_cq->nr_callbacks) {
+	if (my_cq->nr_callbacks) {
 		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
-		yield();
+		wait_for_completion(&my_cq->zero_callbacks);
 		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
 	}
 
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 3ec53c6..7db39b7 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -605,6 +605,7 @@ static void run_comp_task(struct ehca_cp
 	spin_lock_irqsave(&cct->task_lock, flags);
 
 	while (!list_empty(&cct->cq_list)) {
+		int is_complete = 0;
 		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
 		spin_unlock_irqrestore(&cct->task_lock, flags);
 		comp_event_callback(cq);
@@ -612,11 +613,14 @@ static void run_comp_task(struct ehca_cp
 
 		spin_lock(&cq->task_lock);
 		cq->nr_callbacks--;
-		if (cq->nr_callbacks == 0) {
+		is_complete = (cq->nr_callbacks == 0);
+		if (is_complete) {
 			list_del_init(cct->cq_list.next);
 			cct->cq_jobs--;
 		}
 		spin_unlock(&cq->task_lock);
+		if (is_complete) /* wake up waiting destroy_cq() */
+			complete(&cq->zero_callbacks);
 	}
 
 	spin_unlock_irqrestore(&cct->task_lock, flags);

