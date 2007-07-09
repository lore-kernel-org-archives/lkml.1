Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbXGINba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbXGINba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbXGINbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:31:15 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:14725 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444AbXGINbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:31:13 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 10/13] IB/ehca: Change idr spinlocks into rwlocks
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707091502.22407.fenkes@de.ibm.com>
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1748
Date: Mon, 9 Jul 2007 15:31:10 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091531.11544.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This eliminates lock contention among IRQs as well as the need to disable
IRQs around idr_find, because there are no IRQ writers.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    4 ++--
 drivers/infiniband/hw/ehca/ehca_cq.c      |   12 ++++++------
 drivers/infiniband/hw/ehca/ehca_irq.c     |   19 ++++++++-----------
 drivers/infiniband/hw/ehca/ehca_main.c    |    4 ++--
 drivers/infiniband/hw/ehca/ehca_qp.c      |   12 ++++++------
 drivers/infiniband/hw/ehca/ehca_uverbs.c  |    9 ++++-----
 6 files changed, 28 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 8580f2a..f1e0db2 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -293,8 +293,8 @@ void ehca_cleanup_av_cache(void);
 int ehca_init_mrmw_cache(void);
 void ehca_cleanup_mrmw_cache(void);
 
-extern spinlock_t ehca_qp_idr_lock;
-extern spinlock_t ehca_cq_idr_lock;
+extern rwlock_t ehca_qp_idr_lock;
+extern rwlock_t ehca_cq_idr_lock;
 extern struct idr ehca_qp_idr;
 extern struct idr ehca_cq_idr;
 
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 3729997..01d4a14 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -163,9 +163,9 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 			goto create_cq_exit1;
 		}
 
-		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+		write_lock_irqsave(&ehca_cq_idr_lock, flags);
 		ret = idr_get_new(&ehca_cq_idr, my_cq, &my_cq->token);
-		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+		write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 
 	} while (ret == -EAGAIN);
 
@@ -294,9 +294,9 @@ create_cq_exit3:
 			 "cq_num=%x h_ret=%lx", my_cq, my_cq->cq_number, h_ret);
 
 create_cq_exit2:
-	spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+	write_lock_irqsave(&ehca_cq_idr_lock, flags);
 	idr_remove(&ehca_cq_idr, my_cq->token);
-	spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+	write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 
 create_cq_exit1:
 	kmem_cache_free(cq_cache, my_cq);
@@ -334,9 +334,9 @@ int ehca_destroy_cq(struct ib_cq *cq)
 	 * remove the CQ from the idr first to make sure
 	 * no more interrupt tasklets will touch this CQ
 	 */
-	spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+	write_lock_irqsave(&ehca_cq_idr_lock, flags);
 	idr_remove(&ehca_cq_idr, my_cq->token);
-	spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+	write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
 
 	/* now wait until all pending events have completed */
 	wait_event(my_cq->wait_completion, !atomic_read(&my_cq->nr_events));
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 3e790a3..02b73c8 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -180,12 +180,11 @@ static void qp_event_callback(struct ehca_shca *shca,
 {
 	struct ib_event event;
 	struct ehca_qp *qp;
-	unsigned long flags;
 	u32 token = EHCA_BMASK_GET(EQE_QP_TOKEN, eqe);
 
-	spin_lock_irqsave(&ehca_qp_idr_lock, flags);
+	read_lock(&ehca_qp_idr_lock);
 	qp = idr_find(&ehca_qp_idr, token);
-	spin_unlock_irqrestore(&ehca_qp_idr_lock, flags);
+	read_unlock(&ehca_qp_idr_lock);
 
 
 	if (!qp)
@@ -209,14 +208,13 @@ static void cq_event_callback(struct ehca_shca *shca,
 			      u64 eqe)
 {
 	struct ehca_cq *cq;
-	unsigned long flags;
 	u32 token = EHCA_BMASK_GET(EQE_CQ_TOKEN, eqe);
 
-	spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+	read_lock(&ehca_cq_idr_lock);
 	cq = idr_find(&ehca_cq_idr, token);
 	if (cq)
 		atomic_inc(&cq->nr_events);
-	spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+	read_unlock(&ehca_cq_idr_lock);
 
 	if (!cq)
 		return;
@@ -411,7 +409,6 @@ static inline void process_eqe(struct ehca_shca *shca, struct ehca_eqe *eqe)
 {
 	u64 eqe_value;
 	u32 token;
-	unsigned long flags;
 	struct ehca_cq *cq;
 
 	eqe_value = eqe->entry;
@@ -419,11 +416,11 @@ static inline void process_eqe(struct ehca_shca *shca, struct ehca_eqe *eqe)
 	if (EHCA_BMASK_GET(EQE_COMPLETION_EVENT, eqe_value)) {
 		ehca_dbg(&shca->ib_device, "Got completion event");
 		token = EHCA_BMASK_GET(EQE_CQ_TOKEN, eqe_value);
-		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+		read_lock(&ehca_cq_idr_lock);
 		cq = idr_find(&ehca_cq_idr, token);
 		if (cq)
 			atomic_inc(&cq->nr_events);
-		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+		read_unlock(&ehca_cq_idr_lock);
 		if (cq == NULL) {
 			ehca_err(&shca->ib_device,
 				 "Invalid eqe for non-existing cq token=%x",
@@ -480,11 +477,11 @@ void ehca_process_eq(struct ehca_shca *shca, int is_irq)
 		eqe_value = eqe_cache[eqe_cnt].eqe->entry;
 		if (EHCA_BMASK_GET(EQE_COMPLETION_EVENT, eqe_value)) {
 			token = EHCA_BMASK_GET(EQE_CQ_TOKEN, eqe_value);
-			spin_lock(&ehca_cq_idr_lock);
+			read_lock(&ehca_cq_idr_lock);
 			eqe_cache[eqe_cnt].cq = idr_find(&ehca_cq_idr, token);
 			if (eqe_cache[eqe_cnt].cq)
 				atomic_inc(&eqe_cache[eqe_cnt].cq->nr_events);
-			spin_unlock(&ehca_cq_idr_lock);
+			read_unlock(&ehca_cq_idr_lock);
 			if (!eqe_cache[eqe_cnt].cq) {
 				ehca_err(&shca->ib_device,
 					 "Invalid eqe for non-existing cq "
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 77db890..e58e821 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -96,8 +96,8 @@ MODULE_PARM_DESC(static_rate,
 MODULE_PARM_DESC(scaling_code,
 		 "set scaling code (0: disabled/default, 1: enabled)");
 
-DEFINE_SPINLOCK(ehca_qp_idr_lock);
-DEFINE_SPINLOCK(ehca_cq_idr_lock);
+DEFINE_RWLOCK(ehca_qp_idr_lock);
+DEFINE_RWLOCK(ehca_cq_idr_lock);
 DEFINE_IDR(ehca_qp_idr);
 DEFINE_IDR(ehca_cq_idr);
 
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index ac4ff26..7452ef4 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -512,9 +512,9 @@ struct ehca_qp *internal_create_qp(struct ib_pd *pd,
 			goto create_qp_exit0;
 		}
 
-		spin_lock_irqsave(&ehca_qp_idr_lock, flags);
+		write_lock_irqsave(&ehca_qp_idr_lock, flags);
 		ret = idr_get_new(&ehca_qp_idr, my_qp, &my_qp->token);
-		spin_unlock_irqrestore(&ehca_qp_idr_lock, flags);
+		write_unlock_irqrestore(&ehca_qp_idr_lock, flags);
 
 	} while (ret == -EAGAIN);
 
@@ -733,9 +733,9 @@ create_qp_exit2:
 	hipz_h_destroy_qp(shca->ipz_hca_handle, my_qp);
 
 create_qp_exit1:
-	spin_lock_irqsave(&ehca_qp_idr_lock, flags);
+	write_lock_irqsave(&ehca_qp_idr_lock, flags);
 	idr_remove(&ehca_qp_idr, my_qp->token);
-	spin_unlock_irqrestore(&ehca_qp_idr_lock, flags);
+	write_unlock_irqrestore(&ehca_qp_idr_lock, flags);
 
 create_qp_exit0:
 	kmem_cache_free(qp_cache, my_qp);
@@ -1706,9 +1706,9 @@ int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
 		}
 	}
 
-	spin_lock_irqsave(&ehca_qp_idr_lock, flags);
+	write_lock_irqsave(&ehca_qp_idr_lock, flags);
 	idr_remove(&ehca_qp_idr, my_qp->token);
-	spin_unlock_irqrestore(&ehca_qp_idr_lock, flags);
+	write_unlock_irqrestore(&ehca_qp_idr_lock, flags);
 
 	h_ret = hipz_h_destroy_qp(shca->ipz_hca_handle, my_qp);
 	if (h_ret != H_SUCCESS) {
diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/infiniband/hw/ehca/ehca_uverbs.c
index d8fe37d..3031b3b 100644
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c
+++ b/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -253,7 +253,6 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	u32 rsrc_type = (fileoffset >> 24) & 0xF; /* sq,rq,cmnd_window */
 	u32 cur_pid = current->tgid;
 	u32 ret;
-	unsigned long flags;
 	struct ehca_cq *cq;
 	struct ehca_qp *qp;
 	struct ehca_pd *pd;
@@ -261,9 +260,9 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 
 	switch (q_type) {
 	case  1: /* CQ */
-		spin_lock_irqsave(&ehca_cq_idr_lock, flags);
+		read_lock(&ehca_cq_idr_lock);
 		cq = idr_find(&ehca_cq_idr, idr_handle);
-		spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+		read_unlock(&ehca_cq_idr_lock);
 
 		/* make sure this mmap really belongs to the authorized user */
 		if (!cq)
@@ -289,9 +288,9 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		break;
 
 	case 2: /* QP */
-		spin_lock_irqsave(&ehca_qp_idr_lock, flags);
+		read_lock(&ehca_qp_idr_lock);
 		qp = idr_find(&ehca_qp_idr, idr_handle);
-		spin_unlock_irqrestore(&ehca_qp_idr_lock, flags);
+		read_unlock(&ehca_qp_idr_lock);
 
 		/* make sure this mmap really belongs to the authorized user */
 		if (!qp)
-- 
1.5.2


