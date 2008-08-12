Return-Path: <linux-kernel-owner+w=401wt.eu-S1754544AbYHLNq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbYHLNq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYHLNq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:46:28 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:20821 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbYHLNq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:46:27 -0400
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>, "of-ewg" <ewg@lists.openfabrics.org>,
       "of-general" <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "linuxppc-dev" <linuxppc-dev@ozlabs.org>
Subject: [PATCH 1/5 try2] ib/ehca: update qp_state on cached modify_qp()
Date: Tue, 12 Aug 2008 15:46:07 +0200
User-Agent: KMail/1.9.9
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200808121546.07212.alexs@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the introduction of the port auto-detect mode for ehca, calls to
modify_qp() may be cached in the device driver when the ports are not
activated yet. When a modify_qp() call is cached, the qp state remains
untouched until the port is activated, which will leave the qp in the reset
state. In the reset state, however, it is not allowed to post SQ WQEs,
which confuses applications like ib_mad.

The solution for this problem is to immediately set the qp state as requested
by modify_qp(), even when the call is cached.


Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- infiniband.git.orig/drivers/infiniband/hw/ehca/ehca_qp.c
+++ infiniband.git/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1534,8 +1534,6 @@ static int internal_modify_qp(struct ib_
 	if (attr_mask & IB_QP_QKEY)
 		my_qp->qkey = attr->qkey;
 
-	my_qp->state = qp_new_state;
-
 modify_qp_exit2:
 	if (squeue_locked) { /* this means: sqe -> rts */
 		spin_unlock_irqrestore(&my_qp->spinlock_s, flags);
@@ -1551,6 +1549,8 @@ modify_qp_exit1:
 int ehca_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 		   struct ib_udata *udata)
 {
+	int ret = 0;
+
 	struct ehca_shca *shca = container_of(ibqp->device, struct ehca_shca,
 					      ib_device);
 	struct ehca_qp *my_qp = container_of(ibqp, struct ehca_qp, ib_qp);
@@ -1597,12 +1597,18 @@ int ehca_modify_qp(struct ib_qp *ibqp, s
 				 attr->qp_state, my_qp->init_attr.port_num,
 				 ibqp->qp_type);
 			spin_unlock_irqrestore(&sport->mod_sqp_lock, flags);
-			return 0;
+			goto out;
 		}
 		spin_unlock_irqrestore(&sport->mod_sqp_lock, flags);
 	}
 
-	return internal_modify_qp(ibqp, attr, attr_mask, 0);
+	ret = internal_modify_qp(ibqp, attr, attr_mask, 0);
+
+out:
+	if ((ret == 0) && (attr_mask & IB_QP_STATE))
+		my_qp->state = attr->qp_state;
+
+	return ret;
 }
 
 void ehca_recover_sqp(struct ib_qp *sqp)
