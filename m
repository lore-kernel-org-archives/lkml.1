Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbXGIN3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbXGIN3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXGIN3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:29:09 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:39819 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbXGIN3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:29:07 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 08/13] IB/ehca: Lock renaming, static initializers
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707091502.22407.fenkes@de.ibm.com>
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1748
Date: Mon, 9 Jul 2007 15:29:03 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091529.04073.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Renamed all spinlock flags to "flags", matching the vast majority of kernel
  code.
- Moved hcall_lock into the only module it's used in.
- Replaced spin_lock_init() and friends with static initializers for
  global variables.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    1 -
 drivers/infiniband/hw/ehca/ehca_cq.c      |   12 ++++++------
 drivers/infiniband/hw/ehca/ehca_main.c    |   18 ++++--------------
 drivers/infiniband/hw/ehca/ehca_qp.c      |    6 +++---
 drivers/infiniband/hw/ehca/ehca_reqs.c    |   24 ++++++++++++------------
 drivers/infiniband/hw/ehca/hcp_if.c       |    2 ++
 6 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 9d689ae..3550047 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -295,7 +295,6 @@ void ehca_cleanup_mrmw_cache(void);
 
 extern spinlock_t ehca_qp_idr_lock;
 extern spinlock_t ehca_cq_idr_lock;
-extern spinlock_t hcall_lock;
 extern struct idr ehca_qp_idr;
 extern struct idr ehca_cq_idr;
 
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 67f0670..94bad27 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -56,11 +56,11 @@ int ehca_cq_assign_qp(struct ehca_cq *cq, struct ehca_qp *qp)
 {
 	unsigned int qp_num = qp->real_qp_num;
 	unsigned int key = qp_num & (QP_HASHTAB_LEN-1);
-	unsigned long spl_flags;
+	unsigned long flags;
 
-	spin_lock_irqsave(&cq->spinlock, spl_flags);
+	spin_lock_irqsave(&cq->spinlock, flags);
 	hlist_add_head(&qp->list_entries, &cq->qp_hashtab[key]);
-	spin_unlock_irqrestore(&cq->spinlock, spl_flags);
+	spin_unlock_irqrestore(&cq->spinlock, flags);
 
 	ehca_dbg(cq->ib_cq.device, "cq_num=%x real_qp_num=%x",
 		 cq->cq_number, qp_num);
@@ -74,9 +74,9 @@ int ehca_cq_unassign_qp(struct ehca_cq *cq, unsigned int real_qp_num)
 	unsigned int key = real_qp_num & (QP_HASHTAB_LEN-1);
 	struct hlist_node *iter;
 	struct ehca_qp *qp;
-	unsigned long spl_flags;
+	unsigned long flags;
 
-	spin_lock_irqsave(&cq->spinlock, spl_flags);
+	spin_lock_irqsave(&cq->spinlock, flags);
 	hlist_for_each(iter, &cq->qp_hashtab[key]) {
 		qp = hlist_entry(iter, struct ehca_qp, list_entries);
 		if (qp->real_qp_num == real_qp_num) {
@@ -88,7 +88,7 @@ int ehca_cq_unassign_qp(struct ehca_cq *cq, unsigned int real_qp_num)
 			break;
 		}
 	}
-	spin_unlock_irqrestore(&cq->spinlock, spl_flags);
+	spin_unlock_irqrestore(&cq->spinlock, flags);
 	if (ret)
 		ehca_err(cq->ib_cq.device,
 			 "qp not found cq_num=%x real_qp_num=%x",
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 9bd749c..77db890 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -96,15 +96,13 @@ MODULE_PARM_DESC(static_rate,
 MODULE_PARM_DESC(scaling_code,
 		 "set scaling code (0: disabled/default, 1: enabled)");
 
-spinlock_t ehca_qp_idr_lock;
-spinlock_t ehca_cq_idr_lock;
-spinlock_t hcall_lock;
+DEFINE_SPINLOCK(ehca_qp_idr_lock);
+DEFINE_SPINLOCK(ehca_cq_idr_lock);
 DEFINE_IDR(ehca_qp_idr);
 DEFINE_IDR(ehca_cq_idr);
 
-
-static struct list_head shca_list; /* list of all registered ehcas */
-static spinlock_t shca_list_lock;
+static LIST_HEAD(shca_list); /* list of all registered ehcas */
+static DEFINE_SPINLOCK(shca_list_lock);
 
 static struct timer_list poll_eqs_timer;
 
@@ -864,14 +862,6 @@ int __init ehca_module_init(void)
 
 	printk(KERN_INFO "eHCA Infiniband Device Driver "
 	       "(Rel.: SVNEHCA_0023)\n");
-	idr_init(&ehca_qp_idr);
-	idr_init(&ehca_cq_idr);
-	spin_lock_init(&ehca_qp_idr_lock);
-	spin_lock_init(&ehca_cq_idr_lock);
-	spin_lock_init(&hcall_lock);
-
-	INIT_LIST_HEAD(&shca_list);
-	spin_lock_init(&shca_list_lock);
 
 	if ((ret = ehca_create_comp_pool())) {
 		ehca_gen_err("Cannot create comp pool.");
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 989f75e..ac4ff26 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -933,7 +933,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 	u64 h_ret;
 	int bad_wqe_cnt = 0;
 	int squeue_locked = 0;
-	unsigned long spl_flags = 0;
+	unsigned long flags = 0;
 
 	/* do query_qp to obtain current attr values */
 	mqpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
@@ -1074,7 +1074,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		if (!ibqp->uobject) {
 			struct ehca_wqe *wqe;
 			/* lock send queue */
-			spin_lock_irqsave(&my_qp->spinlock_s, spl_flags);
+			spin_lock_irqsave(&my_qp->spinlock_s, flags);
 			squeue_locked = 1;
 			/* mark next free wqe */
 			wqe = (struct ehca_wqe*)
@@ -1360,7 +1360,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 
 modify_qp_exit2:
 	if (squeue_locked) { /* this means: sqe -> rts */
-		spin_unlock_irqrestore(&my_qp->spinlock_s, spl_flags);
+		spin_unlock_irqrestore(&my_qp->spinlock_s, flags);
 		my_qp->sqerr_purgeflag = 1;
 	}
 
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index b5664fa..73f0c06 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -363,10 +363,10 @@ int ehca_post_send(struct ib_qp *qp,
 	struct ehca_wqe *wqe_p;
 	int wqe_cnt = 0;
 	int ret = 0;
-	unsigned long spl_flags;
+	unsigned long flags;
 
 	/* LOCK the QUEUE */
-	spin_lock_irqsave(&my_qp->spinlock_s, spl_flags);
+	spin_lock_irqsave(&my_qp->spinlock_s, flags);
 
 	/* loop processes list of send reqs */
 	for (cur_send_wr = send_wr; cur_send_wr != NULL;
@@ -408,7 +408,7 @@ int ehca_post_send(struct ib_qp *qp,
 
 post_send_exit0:
 	/* UNLOCK the QUEUE */
-	spin_unlock_irqrestore(&my_qp->spinlock_s, spl_flags);
+	spin_unlock_irqrestore(&my_qp->spinlock_s, flags);
 	iosync(); /* serialize GAL register access */
 	hipz_update_sqa(my_qp, wqe_cnt);
 	return ret;
@@ -423,7 +423,7 @@ static int internal_post_recv(struct ehca_qp *my_qp,
 	struct ehca_wqe *wqe_p;
 	int wqe_cnt = 0;
 	int ret = 0;
-	unsigned long spl_flags;
+	unsigned long flags;
 
 	if (unlikely(!HAS_RQ(my_qp))) {
 		ehca_err(dev, "QP has no RQ  ehca_qp=%p qp_num=%x ext_type=%d",
@@ -432,7 +432,7 @@ static int internal_post_recv(struct ehca_qp *my_qp,
 	}
 
 	/* LOCK the QUEUE */
-	spin_lock_irqsave(&my_qp->spinlock_r, spl_flags);
+	spin_lock_irqsave(&my_qp->spinlock_r, flags);
 
 	/* loop processes list of send reqs */
 	for (cur_recv_wr = recv_wr; cur_recv_wr != NULL;
@@ -473,7 +473,7 @@ static int internal_post_recv(struct ehca_qp *my_qp,
 	} /* eof for cur_recv_wr */
 
 post_recv_exit0:
-	spin_unlock_irqrestore(&my_qp->spinlock_r, spl_flags);
+	spin_unlock_irqrestore(&my_qp->spinlock_r, flags);
 	iosync(); /* serialize GAL register access */
 	hipz_update_rqa(my_qp, wqe_cnt);
 	return ret;
@@ -536,7 +536,7 @@ poll_cq_one_read_cqe:
 	if (unlikely(cqe->status & WC_STATUS_PURGE_BIT)) {
 		struct ehca_qp *qp=ehca_cq_get_qp(my_cq, cqe->local_qp_number);
 		int purgeflag;
-		unsigned long spl_flags;
+		unsigned long flags;
 		if (!qp) {
 			ehca_err(cq->device, "cq_num=%x qp_num=%x "
 				 "could not find qp -> ignore cqe",
@@ -546,9 +546,9 @@ poll_cq_one_read_cqe:
 			/* ignore this purged cqe */
 			goto poll_cq_one_read_cqe;
 		}
-		spin_lock_irqsave(&qp->spinlock_s, spl_flags);
+		spin_lock_irqsave(&qp->spinlock_s, flags);
 		purgeflag = qp->sqerr_purgeflag;
-		spin_unlock_irqrestore(&qp->spinlock_s, spl_flags);
+		spin_unlock_irqrestore(&qp->spinlock_s, flags);
 
 		if (purgeflag) {
 			ehca_dbg(cq->device, "Got CQE with purged bit qp_num=%x "
@@ -633,7 +633,7 @@ int ehca_poll_cq(struct ib_cq *cq, int num_entries, struct ib_wc *wc)
 	int nr;
 	struct ib_wc *current_wc = wc;
 	int ret = 0;
-	unsigned long spl_flags;
+	unsigned long flags;
 
 	if (num_entries < 1) {
 		ehca_err(cq->device, "Invalid num_entries=%d ehca_cq=%p "
@@ -642,14 +642,14 @@ int ehca_poll_cq(struct ib_cq *cq, int num_entries, struct ib_wc *wc)
 		goto poll_cq_exit0;
 	}
 
-	spin_lock_irqsave(&my_cq->spinlock, spl_flags);
+	spin_lock_irqsave(&my_cq->spinlock, flags);
 	for (nr = 0; nr < num_entries; nr++) {
 		ret = ehca_poll_cq_one(cq, current_wc);
 		if (ret)
 			break;
 		current_wc++;
 	} /* eof for nr */
-	spin_unlock_irqrestore(&my_cq->spinlock, spl_flags);
+	spin_unlock_irqrestore(&my_cq->spinlock, flags);
 	if (ret == -EAGAIN  || !ret)
 		ret = nr;
 
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index b078377..5b927a6 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -81,6 +81,8 @@
 #define H_MP_SHUTDOWN                   EHCA_BMASK_IBM(48, 48)
 #define H_MP_RESET_QKEY_CTR             EHCA_BMASK_IBM(49, 49)
 
+DEFINE_SPINLOCK(hcall_lock);
+
 static u32 get_longbusy_msecs(int longbusy_rc)
 {
 	switch (longbusy_rc) {
-- 
1.5.2


