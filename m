Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbYDUIFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbYDUIFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYDUIEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:04:48 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:17216 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYDUIEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:04:47 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 1/5] IB/ehca: Prevent posting of SQ WQEs if QP not in RTS
Date: Mon, 21 Apr 2008 09:04:44 +0100
User-Agent: KMail/1.9.1
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200804211003.10695.fenkes@de.ibm.com>
In-Reply-To: <200804211003.10695.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211004.44666.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...as required by IB Spec, C10-29.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    1 +
 drivers/infiniband/hw/ehca/ehca_qp.c      |    3 +++
 drivers/infiniband/hw/ehca/ehca_reqs.c    |    5 +++++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 0d13fe0..3d6d946 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -160,6 +160,7 @@ struct ehca_qp {
 	};
 	u32 qp_type;
 	enum ehca_ext_qp_type ext_type;
+	enum ib_qp_state state;
 	struct ipz_queue ipz_squeue;
 	struct ipz_queue ipz_rqueue;
 	struct h_galpas galpas;
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 3eb14a5..5a653d7 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -550,6 +550,7 @@ static struct ehca_qp *internal_create_qp(
 	spin_lock_init(&my_qp->spinlock_r);
 	my_qp->qp_type = qp_type;
 	my_qp->ext_type = parms.ext_type;
+	my_qp->state = IB_QPS_RESET;
 
 	if (init_attr->recv_cq)
 		my_qp->recv_cq =
@@ -1508,6 +1509,8 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 	if (attr_mask & IB_QP_QKEY)
 		my_qp->qkey = attr->qkey;
 
+	my_qp->state = qp_new_state;
+
 modify_qp_exit2:
 	if (squeue_locked) { /* this means: sqe -> rts */
 		spin_unlock_irqrestore(&my_qp->spinlock_s, flags);
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index a20bbf4..0b2359e 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -421,6 +421,11 @@ int ehca_post_send(struct ib_qp *qp,
 	int ret = 0;
 	unsigned long flags;
 
+	if (unlikely(my_qp->state != IB_QPS_RTS)) {
+		ehca_err(qp->device, "QP not in RTS state  qpn=%x", qp->qp_num);
+		return -EINVAL;
+	}
+
 	/* LOCK the QUEUE */
 	spin_lock_irqsave(&my_qp->spinlock_s, flags);
 
-- 
1.5.5


