Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbYGULQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbYGULQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYGULQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:16:07 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:1908 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYGULQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:16:06 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 1/2] IB/ehca: Filter PATH_MIG events if QP was never armed
Date: Mon, 21 Jul 2008 13:15:31 +0200
User-Agent: KMail/1.9.1
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>
References: <200807211313.23648.fenkes@de.ibm.com>
In-Reply-To: <200807211313.23648.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807211315.31761.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain firmware versions sometimes cause spurious PATH_MIG events to occur
during QP creation. Filter these events by making sure PATH_MIG events are
only handed down when they actually make sense (i.e. when the QP has been
armed at least once).

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    1 +
 drivers/infiniband/hw/ehca/ehca_irq.c     |    4 ++++
 drivers/infiniband/hw/ehca/ehca_qp.c      |    2 ++
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 1e9e99a..0b0618e 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -194,6 +194,7 @@ struct ehca_qp {
 	u32 packet_count;
 	atomic_t nr_events; /* events seen */
 	wait_queue_head_t wait_completion;
+	int mig_armed;
 };
 
 #define IS_SRQ(qp) (qp->ext_type == EQPT_SRQ)
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 0792d93..99642a6 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -178,6 +178,10 @@ static void dispatch_qp_event(struct ehca_shca *shca, struct ehca_qp *qp,
 {
 	struct ib_event event;
 
+	/* PATH_MIG without the QP ever having been armed is false alarm */
+	if (event_type == IB_EVENT_PATH_MIG && !qp->mig_armed)
+		return;
+
 	event.device = &shca->ib_device;
 	event.event = event_type;
 
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 3f59587..ea13efd 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1460,6 +1460,8 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 			goto modify_qp_exit2;
 		}
 		mqpcb->path_migration_state = attr->path_mig_state + 1;
+		if (attr->path_mig_state == IB_MIG_REARM)
+			my_qp->mig_armed = 1;
 		update_mask |=
 			EHCA_BMASK_SET(MQPCB_MASK_PATH_MIGRATION_STATE, 1);
 	}
-- 
1.5.5


