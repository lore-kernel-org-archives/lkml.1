Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbYFILZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbYFILZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759630AbYFILZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:25:00 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:43334 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759616AbYFILZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:25:00 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: Dotan Barak <dotanba@gmail.com>, LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: Reject recv WRs if QP is in RESET state
Date: Mon, 9 Jun 2008 13:24:20 +0200
User-Agent: KMail/1.9.1
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>
References: <200806061835.43802.fenkes@de.ibm.com> <48499C11.7030504@gmail.com>
In-Reply-To: <48499C11.7030504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806091324.20869.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
On Friday 06 June 2008 22:20, Dotan Barak wrote:

> I checked the code in the ehca driver and noticed that
> post RR to a QP is being accepted in any state (including the RESET state).

You're right, this is only consistent -- thanks for pointing it out!

Regards,
  Joachim

 drivers/infiniband/hw/ehca/ehca_reqs.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index f093b00..ad197f4 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -544,8 +544,16 @@ int ehca_post_recv(struct ib_qp *qp,
 		   struct ib_recv_wr *recv_wr,
 		   struct ib_recv_wr **bad_recv_wr)
 {
-	return internal_post_recv(container_of(qp, struct ehca_qp, ib_qp),
-				  qp->device, recv_wr, bad_recv_wr);
+	struct ehca_qp *my_qp = container_of(qp, struct ehca_qp, ib_qp);
+
+	/* Reject WR if QP is in RESET state */
+	if (unlikely(my_qp->state == IB_QPS_RESET)) {
+		ehca_err(qp->device, "Invalid QP state  qp_state=%d qpn=%x",
+			 my_qp->state, qp->qp_num);
+		return -EINVAL;
+	}
+
+	return internal_post_recv(my_qp, qp->device, recv_wr, bad_recv_wr);
 }
 
 int ehca_post_srq_recv(struct ib_srq *srq,
-- 
1.5.5

