Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbXGINcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbXGINcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXGINb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:31:57 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:56892 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbXGINb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:31:56 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 11/13] IB/ehca: return QP pointer in poll_cq(), add two unlikely() statements
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707091502.22407.fenkes@de.ibm.com>
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1748
Date: Mon, 9 Jul 2007 15:31:53 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091531.54219.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_reqs.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 73f0c06..fd3ba22 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -517,6 +517,7 @@ static inline int ehca_poll_cq_one(struct ib_cq *cq, struct ib_wc *wc)
 	int ret = 0;
 	struct ehca_cq *my_cq = container_of(cq, struct ehca_cq, ib_cq);
 	struct ehca_cqe *cqe;
+	struct ehca_qp *my_qp;
 	int cqe_count = 0;
 
 poll_cq_one_read_cqe:
@@ -568,7 +569,7 @@ poll_cq_one_read_cqe:
 	}
 
 	/* tracing cqe */
-	if (ehca_debug_level) {
+	if (unlikely(ehca_debug_level)) {
 		ehca_dbg(cq->device,
 			 "Received COMPLETION ehca_cq=%p cq_num=%x -----",
 			 my_cq, my_cq->cq_number);
@@ -602,7 +603,11 @@ poll_cq_one_read_cqe:
 	} else
 		wc->status = IB_WC_SUCCESS;
 
-	wc->qp = NULL;
+	read_lock(&ehca_qp_idr_lock);
+	my_qp = idr_find(&ehca_qp_idr, cqe->qp_token);
+	wc->qp = &my_qp->ib_qp;
+	read_unlock(&ehca_qp_idr_lock);
+
 	wc->byte_len = cqe->nr_bytes_transferred;
 	wc->pkey_index = cqe->pkey_index;
 	wc->slid = cqe->rlid;
@@ -612,7 +617,7 @@ poll_cq_one_read_cqe:
 	wc->imm_data = cpu_to_be32(cqe->immediate_data);
 	wc->sl = cqe->service_level;
 
-	if (wc->status != IB_WC_SUCCESS)
+	if (unlikely(wc->status != IB_WC_SUCCESS))
 		ehca_dbg(cq->device,
 			 "ehca_cq=%p cq_num=%x WARNING unsuccessful cqe "
 			 "OPType=%x status=%x qp_num=%x src_qp=%x wr_id=%lx "
-- 
1.5.2


