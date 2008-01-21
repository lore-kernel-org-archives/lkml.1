Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbYAUUjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbYAUUjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYAUUjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:39:35 -0500
Received: from 209-198-142-2-host.prismnet.net ([209.198.142.2]:50162 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbYAUUje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 15:39:34 -0500
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 1/3] RDMA/cxgb3: Flush the RQ when closing.
Date: Mon, 21 Jan 2008 14:39:33 -0600
To: rdreier@cisco.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Message-Id: <20080121203932.3143.87972.stgit@dell3.ogc.int>
In-Reply-To: <20080121203829.3143.26181.stgit@dell3.ogc.int>
References: <20080121203829.3143.26181.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


RDMA/cxgb3: Flush the RQ when closing.

- for kernel mode cqs, call event notification handler when flushing
- flush qp when moving from RTS -> CLOSING
- fixed logic to identify a kernel mode qp

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_qp.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index 9bb8112..7681fdc 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -642,6 +642,7 @@ static void __flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 	cxio_flush_rq(&qhp->wq, &rchp->cq, count);
 	spin_unlock(&qhp->lock);
 	spin_unlock_irqrestore(&rchp->lock, *flag);
+	(*rchp->ibcq.comp_handler)(&rchp->ibcq, rchp->ibcq.cq_context);
 
 	/* locking heirarchy: cq lock first, then qp lock. */
 	spin_lock_irqsave(&schp->lock, *flag);
@@ -651,6 +652,7 @@ static void __flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 	cxio_flush_sq(&qhp->wq, &schp->cq, count);
 	spin_unlock(&qhp->lock);
 	spin_unlock_irqrestore(&schp->lock, *flag);
+	(*schp->ibcq.comp_handler)(&schp->ibcq, schp->ibcq.cq_context);
 
 	/* deref */
 	if (atomic_dec_and_test(&qhp->refcnt))
@@ -661,7 +663,7 @@ static void __flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 
 static void flush_qp(struct iwch_qp *qhp, unsigned long *flag)
 {
-	if (t3b_device(qhp->rhp))
+	if (qhp->ibqp.uobject)
 		cxio_set_wq_in_error(&qhp->wq);
 	else
 		__flush_qp(qhp, flag);
@@ -830,10 +832,11 @@ int iwch_modify_qp(struct iwch_dev *rhp, struct iwch_qp *qhp,
 				disconnect = 1;
 				ep = qhp->ep;
 			}
+			flush_qp(qhp, &flag);
 			break;
 		case IWCH_QP_STATE_TERMINATE:
 			qhp->attr.state = IWCH_QP_STATE_TERMINATE;
-			if (t3b_device(qhp->rhp))
+			if (qhp->ibqp.uobject)
 				cxio_set_wq_in_error(&qhp->wq);
 			if (!internal)
 				terminate = 1;
