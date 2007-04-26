Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbXDZWnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbXDZWnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbXDZWnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:43:32 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:4616 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbXDZWn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:43:29 -0400
X-IronPort-AV: i="4.14,458,1170662400"; 
   d="scan'208"; a="481808165:sNHT79512980"
To: linux-kernel@vger.kernel.org
Cc: general@lists.openfabrics.org
Subject: [PATCH][RFC] IB: Return "maybe missed event" hint from ib_req_notify_cq()
X-Message-Flag: Warning: May contain useful information
References: <adaps5rro8v.fsf@cisco.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 26 Apr 2007 15:43:19 -0700
In-Reply-To: <adaps5rro8v.fsf@cisco.com> (Roland Dreier's message of "Thu, 26 Apr 2007 11:20:48 -0700")
Message-ID: <adaejm6pxiw.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Apr 2007 22:43:20.0150 (UTC) FILETIME=[49E19760:01C78854]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >   - "IB: Return "maybe missed event" hint from ib_req_notify_cq()"
 >     This extends the API in a way that lets us implement NAPI, but may
 >     be useful for other things too.  It touches all the drivers, and I
 >     still need to finish updating cxgb3 to work correctly.  I haven't
 >     heard anything negative about this, so I'll fix it up, post it one
 >     more time for review, and plan on merging it.

As promised, here is that patch for review, with a cxgb3
implementation included.

---

The semantics defined by the InfiniBand specification say that
completion events are only generated when a completions is added to a
completion queue (CQ) after completion notification is requested.  In
other words, this means that the following race is possible:

	while (CQ is not empty)
		ib_poll_cq(CQ);
	// new completion is added after while loop is exited
	ib_req_notify_cq(CQ);
	// no event is generated for the existing completion

To close this race, the IB spec recommends doing another poll of the
CQ after requesting notification.

However, it is not always possible to arrange code this way (for
example, we have found that NAPI for IPoIB cannot poll after
requesting notification).  Also, some hardware (eg Mellanox HCAs)
actually will generate an event for completions added before the call
to ib_req_notify_cq() -- which is allowed by the spec, since there's
no way for any upper-layer consumer to know exactly when a completion
was really added -- so the extra poll of the CQ is just a waste.

Motivated by this, we add a new flag "IB_CQ_REPORT_MISSED_EVENTS" for
ib_req_notify_cq() so that it can return a hint about whether the a
completion may have been added before the request for notification.
The return value of ib_req_notify_cq() is extended so:

	 < 0	means an error occurred while requesting notification
	== 0	means notification was requested successfully, and if
		IB_CQ_REPORT_MISSED_EVENTS was passed in, then no
		events were missed and it is safe to wait for another
		event.
	 > 0	is only returned if IB_CQ_REPORT_MISSED_EVENTS was
		passed in.  It means that the consumer must poll the
		CQ again to make sure it is empty to avoid the race
		described above.

We add a flag to enable this behavior rather than turning it on
unconditionally, because checking for missed events may incur
significant overhead for some low-level drivers, and consumers that
don't care about the results of this test shouldn't be forced to pay
for the test.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/infiniband/hw/amso1100/c2.h         |    2 +-
 drivers/infiniband/hw/amso1100/c2_cq.c      |   16 ++++++++---
 drivers/infiniband/hw/cxgb3/cxio_hal.c      |    3 ++
 drivers/infiniband/hw/cxgb3/iwch_provider.c |    8 +++--
 drivers/infiniband/hw/ehca/ehca_iverbs.h    |    2 +-
 drivers/infiniband/hw/ehca/ehca_reqs.c      |   14 +++++++--
 drivers/infiniband/hw/ehca/ipz_pt_fn.h      |    8 +++++
 drivers/infiniband/hw/ipath/ipath_cq.c      |   15 +++++++---
 drivers/infiniband/hw/ipath/ipath_verbs.h   |    2 +-
 drivers/infiniband/hw/mthca/mthca_cq.c      |   12 +++++---
 drivers/infiniband/hw/mthca/mthca_dev.h     |    4 +-
 include/rdma/ib_verbs.h                     |   40 +++++++++++++++++++++------
 12 files changed, 93 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2.h b/drivers/infiniband/hw/amso1100/c2.h
index 04a9db5..fa58200 100644
--- a/drivers/infiniband/hw/amso1100/c2.h
+++ b/drivers/infiniband/hw/amso1100/c2.h
@@ -519,7 +519,7 @@ extern void c2_free_cq(struct c2_dev *c2dev, struct c2_cq *cq);
 extern void c2_cq_event(struct c2_dev *c2dev, u32 mq_index);
 extern void c2_cq_clean(struct c2_dev *c2dev, struct c2_qp *qp, u32 mq_index);
 extern int c2_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry);
-extern int c2_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify notify);
+extern int c2_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
 
 /* CM */
 extern int c2_llp_connect(struct iw_cm_id *cm_id,
diff --git a/drivers/infiniband/hw/amso1100/c2_cq.c b/drivers/infiniband/hw/amso1100/c2_cq.c
index 5175c99..d2b3366 100644
--- a/drivers/infiniband/hw/amso1100/c2_cq.c
+++ b/drivers/infiniband/hw/amso1100/c2_cq.c
@@ -217,17 +217,19 @@ int c2_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 	return npolled;
 }
 
-int c2_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify notify)
+int c2_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
 {
 	struct c2_mq_shared __iomem *shared;
 	struct c2_cq *cq;
+	unsigned long flags;
+	int ret = 0;
 
 	cq = to_c2cq(ibcq);
 	shared = cq->mq.peer;
 
-	if (notify == IB_CQ_NEXT_COMP)
+	if ((notify_flags & IB_CQ_SOLICITED_MASK) == IB_CQ_NEXT_COMP)
 		writeb(C2_CQ_NOTIFICATION_TYPE_NEXT, &shared->notification_type);
-	else if (notify == IB_CQ_SOLICITED)
+	else if ((notify_flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED)
 		writeb(C2_CQ_NOTIFICATION_TYPE_NEXT_SE, &shared->notification_type);
 	else
 		return -EINVAL;
@@ -241,7 +243,13 @@ int c2_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify notify)
 	 */
 	readb(&shared->armed);
 
-	return 0;
+	if (notify_flags & IB_CQ_REPORT_MISSED_EVENTS) {
+		spin_lock_irqsave(&cq->lock, flags);
+		ret = !c2_mq_empty(&cq->mq);
+		spin_unlock_irqrestore(&cq->lock, flags);
+	}
+
+	return ret;
 }
 
 static void c2_free_cq_buf(struct c2_dev *c2dev, struct c2_mq *mq)
diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index f5e9aee..76049af 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -114,7 +114,10 @@ int cxio_hal_cq_op(struct cxio_rdev *rdev_p, struct t3_cq *cq,
 				return -EIO;
 			}
 		}
+
+		return 1;
 	}
+
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 24e0df0..e89957f 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -292,7 +292,7 @@ static int iwch_resize_cq(struct ib_cq *cq, int cqe, struct ib_udata *udata)
 #endif
 }
 
-static int iwch_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify notify)
+static int iwch_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 {
 	struct iwch_dev *rhp;
 	struct iwch_cq *chp;
@@ -303,7 +303,7 @@ static int iwch_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify notify)
 
 	chp = to_iwch_cq(ibcq);
 	rhp = chp->rhp;
-	if (notify == IB_CQ_SOLICITED)
+	if ((flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED)
 		cq_op = CQ_ARM_SE;
 	else
 		cq_op = CQ_ARM_AN;
@@ -317,9 +317,11 @@ static int iwch_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify notify)
 	PDBG("%s rptr 0x%x\n", __FUNCTION__, chp->cq.rptr);
 	err = cxio_hal_cq_op(&rhp->rdev, &chp->cq, cq_op, 0);
 	spin_unlock_irqrestore(&chp->lock, flag);
-	if (err)
+	if (err < 0)
 		printk(KERN_ERR MOD "Error %d rearming CQID 0x%x\n", err,
 		       chp->cq.cqid);
+	if (err > 0 && !(flags & IB_CQ_REPORT_MISSED_EVENTS))
+		err = 0;
 	return err;
 }
 
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index 95fd59f..9e5460d 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -135,7 +135,7 @@ int ehca_poll_cq(struct ib_cq *cq, int num_entries, struct ib_wc *wc);
 
 int ehca_peek_cq(struct ib_cq *cq, int wc_cnt);
 
-int ehca_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify cq_notify);
+int ehca_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify_flags notify_flags);
 
 struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 			     struct ib_qp_init_attr *init_attr,
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 08d3f89..caec9de 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -634,11 +634,13 @@ poll_cq_exit0:
 	return ret;
 }
 
-int ehca_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify cq_notify)
+int ehca_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify_flags notify_flags)
 {
 	struct ehca_cq *my_cq = container_of(cq, struct ehca_cq, ib_cq);
+	unsigned long spl_flags;
+	int ret = 0;
 
-	switch (cq_notify) {
+	switch (notify_flags & IB_CQ_SOLICITED_MASK) {
 	case IB_CQ_SOLICITED:
 		hipz_set_cqx_n0(my_cq, 1);
 		break;
@@ -649,5 +651,11 @@ int ehca_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify cq_notify)
 		return -EINVAL;
 	}
 
-	return 0;
+	if (notify_flags & IB_CQ_REPORT_MISSED_EVENTS) {
+		spin_lock_irqsave(&my_cq->spinlock, spl_flags);
+		ret = ipz_qeit_is_valid(&my_cq->ipz_queue);
+		spin_unlock_irqrestore(&my_cq->spinlock, spl_flags);
+	}
+
+	return ret;
 }
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.h b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
index 8199c45..57f141a 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.h
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
@@ -140,6 +140,14 @@ static inline void *ipz_qeit_get_inc_valid(struct ipz_queue *queue)
 	return cqe;
 }
 
+static inline int ipz_qeit_is_valid(struct ipz_queue *queue)
+{
+	struct ehca_cqe *cqe = ipz_qeit_get(queue);
+	u32 cqe_flags = cqe->cqe_flags;
+
+	return cqe_flags >> 7 == (queue->toggle_state & 1);
+}
+
 /*
  * returns and resets Queue Entry iterator
  * returns address (kv) of first Queue Entry
diff --git a/drivers/infiniband/hw/ipath/ipath_cq.c b/drivers/infiniband/hw/ipath/ipath_cq.c
index 87462e0..9582145 100644
--- a/drivers/infiniband/hw/ipath/ipath_cq.c
+++ b/drivers/infiniband/hw/ipath/ipath_cq.c
@@ -306,17 +306,18 @@ int ipath_destroy_cq(struct ib_cq *ibcq)
 /**
  * ipath_req_notify_cq - change the notification type for a completion queue
  * @ibcq: the completion queue
- * @notify: the type of notification to request
+ * @notify_flags: the type of notification to request
  *
  * Returns 0 for success.
  *
  * This may be called from interrupt context.  Also called by
  * ib_req_notify_cq() in the generic verbs code.
  */
-int ipath_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify notify)
+int ipath_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
 {
 	struct ipath_cq *cq = to_icq(ibcq);
 	unsigned long flags;
+	int ret = 0;
 
 	spin_lock_irqsave(&cq->lock, flags);
 	/*
@@ -324,9 +325,15 @@ int ipath_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify notify)
 	 * any other transitions (see C11-31 and C11-32 in ch. 11.4.2.2).
 	 */
 	if (cq->notify != IB_CQ_NEXT_COMP)
-		cq->notify = notify;
+		cq->notify = notify_flags & IB_CQ_SOLICITED_MASK;
+
+	if ((notify_flags & IB_CQ_REPORT_MISSED_EVENTS) &&
+	    cq->queue->head != cq->queue->tail)
+		ret = 1;
+
 	spin_unlock_irqrestore(&cq->lock, flags);
-	return 0;
+
+	return ret;
 }
 
 /**
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.h b/drivers/infiniband/hw/ipath/ipath_verbs.h
index c0c8d5b..6b3b770 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.h
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.h
@@ -716,7 +716,7 @@ struct ib_cq *ipath_create_cq(struct ib_device *ibdev, int entries,
 
 int ipath_destroy_cq(struct ib_cq *ibcq);
 
-int ipath_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify notify);
+int ipath_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags);
 
 int ipath_resize_cq(struct ib_cq *ibcq, int cqe, struct ib_udata *udata);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_cq.c b/drivers/infiniband/hw/mthca/mthca_cq.c
index efd79ef..cf0868f 100644
--- a/drivers/infiniband/hw/mthca/mthca_cq.c
+++ b/drivers/infiniband/hw/mthca/mthca_cq.c
@@ -726,11 +726,12 @@ repoll:
 	return err == 0 || err == -EAGAIN ? npolled : err;
 }
 
-int mthca_tavor_arm_cq(struct ib_cq *cq, enum ib_cq_notify notify)
+int mthca_tavor_arm_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags)
 {
 	__be32 doorbell[2];
 
-	doorbell[0] = cpu_to_be32((notify == IB_CQ_SOLICITED ?
+	doorbell[0] = cpu_to_be32(((flags & IB_CQ_SOLICITED_MASK) ==
+				   IB_CQ_SOLICITED ?
 				   MTHCA_TAVOR_CQ_DB_REQ_NOT_SOL :
 				   MTHCA_TAVOR_CQ_DB_REQ_NOT)      |
 				  to_mcq(cq)->cqn);
@@ -743,7 +744,7 @@ int mthca_tavor_arm_cq(struct ib_cq *cq, enum ib_cq_notify notify)
 	return 0;
 }
 
-int mthca_arbel_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify notify)
+int mthca_arbel_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
 {
 	struct mthca_cq *cq = to_mcq(ibcq);
 	__be32 doorbell[2];
@@ -755,7 +756,8 @@ int mthca_arbel_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify notify)
 
 	doorbell[0] = ci;
 	doorbell[1] = cpu_to_be32((cq->cqn << 8) | (2 << 5) | (sn << 3) |
-				  (notify == IB_CQ_SOLICITED ? 1 : 2));
+				  ((flags & IB_CQ_SOLICITED_MASK) ==
+				   IB_CQ_SOLICITED ? 1 : 2));
 
 	mthca_write_db_rec(doorbell, cq->arm_db);
 
@@ -766,7 +768,7 @@ int mthca_arbel_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify notify)
 	wmb();
 
 	doorbell[0] = cpu_to_be32((sn << 28)                       |
-				  (notify == IB_CQ_SOLICITED ?
+				  ((flags & IB_CQ_SOLICITED_MASK) == IB_CQ_SOLICITED ?
 				   MTHCA_ARBEL_CQ_DB_REQ_NOT_SOL :
 				   MTHCA_ARBEL_CQ_DB_REQ_NOT)      |
 				  cq->cqn);
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index b7e42ef..9bae3cc 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -495,8 +495,8 @@ void mthca_unmap_eq_icm(struct mthca_dev *dev);
 
 int mthca_poll_cq(struct ib_cq *ibcq, int num_entries,
 		  struct ib_wc *entry);
-int mthca_tavor_arm_cq(struct ib_cq *cq, enum ib_cq_notify notify);
-int mthca_arbel_arm_cq(struct ib_cq *cq, enum ib_cq_notify notify);
+int mthca_tavor_arm_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
+int mthca_arbel_arm_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
 int mthca_init_cq(struct mthca_dev *dev, int nent,
 		  struct mthca_ucontext *ctx, u32 pdn,
 		  struct mthca_cq *cq);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 765589f..529a69d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -431,9 +431,11 @@ struct ib_wc {
 	u8			port_num;	/* valid only for DR SMPs on switches */
 };
 
-enum ib_cq_notify {
-	IB_CQ_SOLICITED,
-	IB_CQ_NEXT_COMP
+enum ib_cq_notify_flags {
+	IB_CQ_SOLICITED			= 1 << 0,
+	IB_CQ_NEXT_COMP			= 1 << 1,
+	IB_CQ_SOLICITED_MASK		= IB_CQ_SOLICITED | IB_CQ_NEXT_COMP,
+	IB_CQ_REPORT_MISSED_EVENTS	= 1 << 2,
 };
 
 enum ib_srq_attr_mask {
@@ -987,7 +989,7 @@ struct ib_device {
 					      struct ib_wc *wc);
 	int                        (*peek_cq)(struct ib_cq *cq, int wc_cnt);
 	int                        (*req_notify_cq)(struct ib_cq *cq,
-						    enum ib_cq_notify cq_notify);
+						    enum ib_cq_notify_flags flags);
 	int                        (*req_ncomp_notif)(struct ib_cq *cq,
 						      int wc_cnt);
 	struct ib_mr *             (*get_dma_mr)(struct ib_pd *pd,
@@ -1414,14 +1416,34 @@ int ib_peek_cq(struct ib_cq *cq, int wc_cnt);
 /**
  * ib_req_notify_cq - Request completion notification on a CQ.
  * @cq: The CQ to generate an event for.
- * @cq_notify: If set to %IB_CQ_SOLICITED, completion notification will
- *   occur on the next solicited event. If set to %IB_CQ_NEXT_COMP,
- *   notification will occur on the next completion.
+ * @flags:
+ *   Must contain exactly one of %IB_CQ_SOLICITED or %IB_CQ_NEXT_COMP
+ *   to request an event on the next solicited event or next work
+ *   completion at any type, respectively. %IB_CQ_REPORT_MISSED_EVENTS
+ *   may also be |ed in to request a hint about missed events, as
+ *   described below.
+ *
+ * Return Value:
+ *    < 0 means an error occurred while requesting notification
+ *   == 0 means notification was requested successfully, and if
+ *        IB_CQ_REPORT_MISSED_EVENTS was passed in, then no events
+ *        were missed and it is safe to wait for another event.  In
+ *        this case is it guaranteed that any work completions added
+ *        to the CQ since the last CQ poll will trigger a completion
+ *        notification event.
+ *    > 0 is only returned if IB_CQ_REPORT_MISSED_EVENTS was passed
+ *        in.  It means that the consumer must poll the CQ again to
+ *        make sure it is empty to avoid missing an event because of a
+ *        race between requesting notification and an entry being
+ *        added to the CQ.  This return value means it is possible
+ *        (but not guaranteed) that a work completion has been added
+ *        to the CQ since the last poll without triggering a
+ *        completion notification event.
  */
 static inline int ib_req_notify_cq(struct ib_cq *cq,
-				   enum ib_cq_notify cq_notify)
+				   enum ib_cq_notify_flags flags)
 {
-	return cq->device->req_notify_cq(cq, cq_notify);
+	return cq->device->req_notify_cq(cq, flags);
 }
 
 /**
-- 
1.5.1.2
