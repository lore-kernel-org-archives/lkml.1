Return-Path: <linux-kernel-owner+w=401wt.eu-S933728AbXIKNfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728AbXIKNfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764110AbXIKNeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:34:11 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:21476 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763981AbXIKNeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:34:08 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 10/12] IB/ehca: Path migration support
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709111518.26276.fenkes@de.ibm.com>
In-Reply-To: <200709111518.26276.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3006
Date: Tue, 11 Sep 2007 15:34:04 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709111534.06200.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rectify some modify_qp() issues related to path migration.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_irq.c |    4 +-
 drivers/infiniband/hw/ehca/ehca_qp.c  |   90 ++++++++++++++++++++++++---------
 2 files changed, 68 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index a925ea5..7093986 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -294,8 +294,8 @@ static void parse_identifier(struct ehca_shca *shca, u64 eqe)
 	case 0x11: /* unaffiliated access error */
 		ehca_err(&shca->ib_device, "Unaffiliated access error.");
 		break;
-	case 0x12: /* path migrating error */
-		ehca_err(&shca->ib_device, "Path migration error.");
+	case 0x12: /* path migrating */
+		ehca_err(&shca->ib_device, "Path migrating.");
 		break;
 	case 0x13: /* interface trace stopped */
 		ehca_err(&shca->ib_device, "Interface trace stopped.");
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 7154f62..6c70dee 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1167,6 +1167,13 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 	}
 
 	if (attr_mask & IB_QP_PKEY_INDEX) {
+		if (attr->pkey_index >= 16) {
+			ret = -EINVAL;
+			ehca_err(ibqp->device, "Invalid pkey_index=%x. "
+				 "ehca_qp=%p qp_num=%x max_pkey_index=f",
+				 attr->pkey_index, my_qp, ibqp->qp_num);
+			goto modify_qp_exit2;
+		}
 		mqpcb->prim_p_key_idx = attr->pkey_index;
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_PRIM_P_KEY_IDX, 1);
 	}
@@ -1275,50 +1282,78 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		int ehca_mult = ib_rate_to_mult(
 			shca->sport[my_qp->init_attr.port_num].rate);
 
+		if (attr->alt_port_num < 1
+		    || attr->alt_port_num > shca->num_ports) {
+			ret = -EINVAL;
+			ehca_err(ibqp->device, "Invalid alt_port=%x. "
+				 "ehca_qp=%p qp_num=%x num_ports=%x",
+				 attr->alt_port_num, my_qp, ibqp->qp_num,
+				 shca->num_ports);
+			goto modify_qp_exit2;
+		}
+		mqpcb->alt_phys_port = attr->alt_port_num;
+
+		if (attr->alt_pkey_index >= 16) {
+			ret = -EINVAL;
+			ehca_err(ibqp->device, "Invalid alt_pkey_index=%x. "
+				 "ehca_qp=%p qp_num=%x max_pkey_index=f",
+				 attr->pkey_index, my_qp, ibqp->qp_num);
+			goto modify_qp_exit2;
+		}
+		mqpcb->alt_p_key_idx = attr->alt_pkey_index;
+
+		mqpcb->timeout_al = attr->alt_timeout;
 		mqpcb->dlid_al = attr->alt_ah_attr.dlid;
-		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_DLID_AL, 1);
 		mqpcb->source_path_bits_al = attr->alt_ah_attr.src_path_bits;
-		update_mask |=
-			EHCA_BMASK_SET(MQPCB_MASK_SOURCE_PATH_BITS_AL, 1);
 		mqpcb->service_level_al = attr->alt_ah_attr.sl;
-		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_SERVICE_LEVEL_AL, 1);
 
-		if (ah_mult < ehca_mult)
-			mqpcb->max_static_rate = (ah_mult > 0) ?
-			((ehca_mult - 1) / ah_mult) : 0;
+		if (ah_mult > 0 && ah_mult < ehca_mult)
+			mqpcb->max_static_rate_al = (ehca_mult - 1) / ah_mult;
 		else
 			mqpcb->max_static_rate_al = 0;
 
-		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_MAX_STATIC_RATE_AL, 1);
+		/* OpenIB doesn't support alternate retry counts - copy them */
+		mqpcb->retry_count_al = mqpcb->retry_count;
+		mqpcb->rnr_retry_count_al = mqpcb->rnr_retry_count;
+
+		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_ALT_PHYS_PORT, 1)
+			| EHCA_BMASK_SET(MQPCB_MASK_ALT_P_KEY_IDX, 1)
+			| EHCA_BMASK_SET(MQPCB_MASK_TIMEOUT_AL, 1)
+			| EHCA_BMASK_SET(MQPCB_MASK_DLID_AL, 1)
+			| EHCA_BMASK_SET(MQPCB_MASK_SOURCE_PATH_BITS_AL, 1)
+			| EHCA_BMASK_SET(MQPCB_MASK_SERVICE_LEVEL_AL, 1)
+			| EHCA_BMASK_SET(MQPCB_MASK_MAX_STATIC_RATE_AL, 1)
+			| EHCA_BMASK_SET(MQPCB_MASK_RETRY_COUNT_AL, 1)
+			| EHCA_BMASK_SET(MQPCB_MASK_RNR_RETRY_COUNT_AL, 1);
+
+		/*
+		 * Always supply the GRH flag, even if it's zero, to give the
+		 * hypervisor a clear "yes" or "no" instead of a "perhaps"
+		 */
+		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_SEND_GRH_FLAG_AL, 1);
 
 		/*
 		 * only if GRH is TRUE we might consider SOURCE_GID_IDX
 		 * and DEST_GID otherwise phype will return H_ATTR_PARM!!!
 		 */
 		if (attr->alt_ah_attr.ah_flags == IB_AH_GRH) {
-			mqpcb->send_grh_flag_al = 1 << 31;
-			update_mask |=
-				EHCA_BMASK_SET(MQPCB_MASK_SEND_GRH_FLAG_AL, 1);
-			mqpcb->source_gid_idx_al =
-				attr->alt_ah_attr.grh.sgid_index;
-			update_mask |=
-				EHCA_BMASK_SET(MQPCB_MASK_SOURCE_GID_IDX_AL, 1);
+			mqpcb->send_grh_flag_al = 1;
 
 			for (cnt = 0; cnt < 16; cnt++)
 				mqpcb->dest_gid_al.byte[cnt] =
 					attr->alt_ah_attr.grh.dgid.raw[cnt];
-
-			update_mask |=
-				EHCA_BMASK_SET(MQPCB_MASK_DEST_GID_AL, 1);
+			mqpcb->source_gid_idx_al =
+				attr->alt_ah_attr.grh.sgid_index;
 			mqpcb->flow_label_al = attr->alt_ah_attr.grh.flow_label;
-			update_mask |=
-				EHCA_BMASK_SET(MQPCB_MASK_FLOW_LABEL_AL, 1);
 			mqpcb->hop_limit_al = attr->alt_ah_attr.grh.hop_limit;
-			update_mask |=
-				EHCA_BMASK_SET(MQPCB_MASK_HOP_LIMIT_AL, 1);
 			mqpcb->traffic_class_al =
 				attr->alt_ah_attr.grh.traffic_class;
+
 			update_mask |=
+				EHCA_BMASK_SET(MQPCB_MASK_SOURCE_GID_IDX_AL, 1)
+				| EHCA_BMASK_SET(MQPCB_MASK_DEST_GID_AL, 1)
+				| EHCA_BMASK_SET(MQPCB_MASK_FLOW_LABEL_AL, 1)
+				| EHCA_BMASK_SET(MQPCB_MASK_HOP_LIMIT_AL, 1) |
 				EHCA_BMASK_SET(MQPCB_MASK_TRAFFIC_CLASS_AL, 1);
 		}
 	}
@@ -1340,7 +1375,14 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 	}
 
 	if (attr_mask & IB_QP_PATH_MIG_STATE) {
-		mqpcb->path_migration_state = attr->path_mig_state;
+		if (attr->path_mig_state != IB_MIG_REARM
+		    && attr->path_mig_state != IB_MIG_MIGRATED) {
+			ret = -EINVAL;
+			ehca_err(ibqp->device, "Invalid mig_state=%x",
+				 attr->path_mig_state);
+			goto modify_qp_exit2;
+		}
+		mqpcb->path_migration_state = attr->path_mig_state + 1;
 		update_mask |=
 			EHCA_BMASK_SET(MQPCB_MASK_PATH_MIGRATION_STATE, 1);
 	}
@@ -1508,7 +1550,7 @@ int ehca_query_qp(struct ib_qp *qp,
 
 	qp_attr->qkey = qpcb->qkey;
 	qp_attr->path_mtu = qpcb->path_mtu;
-	qp_attr->path_mig_state = qpcb->path_migration_state;
+	qp_attr->path_mig_state = qpcb->path_migration_state - 1;
 	qp_attr->rq_psn = qpcb->receive_psn;
 	qp_attr->sq_psn = qpcb->send_psn;
 	qp_attr->min_rnr_timer = qpcb->min_rnr_nak_timer_field;
-- 
1.5.2


