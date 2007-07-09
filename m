Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbXGIN11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbXGIN11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXGIN1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:27:17 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:14545 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbXGIN1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:27:16 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 06/13] IB/ehca: Set SEND_GRH flag for all non-LL UD QPs on eHCA2
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707091502.22407.fenkes@de.ibm.com>
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1748
Date: Mon, 9 Jul 2007 15:27:13 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091527.14272.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Roscher <stefan.roscher@de.ibm.com>

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index ffd1ce9..cbb8b5b 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1054,6 +1054,17 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		 "ehca_qp=%p qp_num=%x <VALID STATE CHANGE> qp_state_xsit=%x",
 		 my_qp, ibqp->qp_num, statetrans);
 
+	/* eHCA2 rev2 and higher require the SEND_GRH_FLAG to be set
+	 * in non-LL UD QPs.
+	 */
+	if ((my_qp->qp_type == IB_QPT_UD) &&
+	    (my_qp->ext_type != EQPT_LLQP) &&
+	    (statetrans == IB_QPST_INIT2RTR) &&
+	    (shca->hw_level >= 0x22)){
+		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_SEND_GRH_FLAG, 1);
+		mqpcb->send_grh_flag = 1;
+	}
+
 	/* sqe -> rts: set purge bit of bad wqe before actual trans */
 	if ((my_qp->qp_type == IB_QPT_UD ||
 	     my_qp->qp_type == IB_QPT_GSI ||
-- 
1.5.2


