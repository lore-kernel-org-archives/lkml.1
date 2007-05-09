Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbXEILsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbXEILsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXEILsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:48:22 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:2442 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXEILsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:48:20 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 2/6] IB/ehca: correctly set GRH mask bit in ehca_modify_qp()
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 6092
Date: Wed, 9 May 2007 13:48:01 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705091348.02396.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The driver needs to always supply the "GRH present" flag to the hypervisor,
whether it's true or false. Not supplying it (i.e. not setting the
corresponding mask bit) amounts to a "perhaps", which we don't want.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index df0516f..e21d796 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -968,17 +968,21 @@ static int internal_modify_qp(struct ib_
 			((ehca_mult - 1) / ah_mult) : 0;
 		else
 			mqpcb->max_static_rate = 0;
-
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_MAX_STATIC_RATE, 1);
 
 		/*
+		 * Always supply the GRH flag, even if it's zero, to give the
+		 * hypervisor a clear "yes" or "no" instead of a "perhaps"
+		 */
+		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_SEND_GRH_FLAG, 1);
+
+		/*
 		 * only if GRH is TRUE we might consider SOURCE_GID_IDX
 		 * and DEST_GID otherwise phype will return H_ATTR_PARM!!!
 		 */
 		if (attr->ah_attr.ah_flags == IB_AH_GRH) {
-			mqpcb->send_grh_flag = 1 << 31;
-			update_mask |=
-				EHCA_BMASK_SET(MQPCB_MASK_SEND_GRH_FLAG, 1);
+			mqpcb->send_grh_flag = 1;
+
 			mqpcb->source_gid_idx = attr->ah_attr.grh.sgid_index;
 			update_mask |=
 				EHCA_BMASK_SET(MQPCB_MASK_SOURCE_GID_IDX, 1);
-- 
1.4.2.1



