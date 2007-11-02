Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbXKBNmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbXKBNmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbXKBNm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:42:28 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:44022 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbXKBNm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:42:26 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 2/2] IB/ehca: Fix static rate calculation
User-Agent: KMail/1.9.1
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200711021432.50203.fenkes@de.ibm.com>
In-Reply-To: <200711021432.50203.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3180
Date: Fri, 2 Nov 2007 15:41:49 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711021441.50158.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The IPD formula was a little off and assumed a fixed physical link rate; fix
the formula and query the actual physical link rate, now that we can get it.
Also, refactor the calculation into a common function ehca_calc_ipd() and
use that instead of duplicating code.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_av.c      |   48 +++++++++++++++++++++++-----
 drivers/infiniband/hw/ehca/ehca_classes.h |    1 -
 drivers/infiniband/hw/ehca/ehca_iverbs.h  |    3 ++
 drivers/infiniband/hw/ehca/ehca_main.c    |    3 --
 drivers/infiniband/hw/ehca/ehca_qp.c      |   29 +++++++----------
 5 files changed, 54 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_av.c b/drivers/infiniband/hw/ehca/ehca_av.c
index 97d1086..453eb99 100644
--- a/drivers/infiniband/hw/ehca/ehca_av.c
+++ b/drivers/infiniband/hw/ehca/ehca_av.c
@@ -50,6 +50,38 @@
 
 static struct kmem_cache *av_cache;
 
+int ehca_calc_ipd(struct ehca_shca *shca, int port,
+		  enum ib_rate path_rate, u32 *ipd)
+{
+	int path = ib_rate_to_mult(path_rate);
+	int link, ret;
+	struct ib_port_attr pa;
+
+	if (path_rate == IB_RATE_PORT_CURRENT) {
+		*ipd = 0;
+		return 0;
+	}
+
+	if (unlikely(path < 0)) {
+		ehca_err(&shca->ib_device, "Invalid static rate! path_rate=%x",
+			 path_rate);
+		return -EINVAL;
+	}
+
+	ret = ehca_query_port(&shca->ib_device, port, &pa);
+	if (unlikely(ret < 0)) {
+		ehca_err(&shca->ib_device, "Failed to query port  ret=%i", ret);
+		return ret;
+	}
+
+	link = ib_width_enum_to_int(pa.active_width) * pa.active_speed;
+
+	/* IPD = round((link / path) - 1) */
+	*ipd = ((link + (path >> 1)) / path) - 1;
+
+	return 0;
+}
+
 struct ib_ah *ehca_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 {
 	int ret;
@@ -69,15 +101,13 @@ struct ib_ah *ehca_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 	av->av.slid_path_bits = ah_attr->src_path_bits;
 
 	if (ehca_static_rate < 0) {
-		int ah_mult = ib_rate_to_mult(ah_attr->static_rate);
-		int ehca_mult =
-			ib_rate_to_mult(shca->sport[ah_attr->port_num].rate );
-
-		if (ah_mult >= ehca_mult)
-			av->av.ipd = 0;
-		else
-			av->av.ipd = (ah_mult > 0) ?
-				((ehca_mult - 1) / ah_mult) : 0;
+		u32 ipd;
+		if (ehca_calc_ipd(shca, ah_attr->port_num,
+				  ah_attr->static_rate, &ipd)) {
+			ret = -EINVAL;
+			goto create_ah_exit1;
+		}
+		av->av.ipd = ipd;
 	} else
 		av->av.ipd = ehca_static_rate;
 
diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 2d660ae..87f12d4 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -95,7 +95,6 @@ struct ehca_sma_attr {
 struct ehca_sport {
 	struct ib_cq *ibcq_aqp1;
 	struct ib_qp *ibqp_aqp1;
-	enum ib_rate  rate;
 	enum ib_port_state port_state;
 	struct ehca_sma_attr saved_attr;
 };
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index dce503b..5485799 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -189,6 +189,9 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 
 void ehca_poll_eqs(unsigned long data);
 
+int ehca_calc_ipd(struct ehca_shca *shca, int port,
+		  enum ib_rate path_rate, u32 *ipd);
+
 #ifdef CONFIG_PPC_64K_PAGES
 void *ehca_alloc_fw_ctrlblock(gfp_t flags);
 void ehca_free_fw_ctrlblock(void *ptr);
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index c6cd38c..90d4334 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -327,9 +327,6 @@ static int ehca_sense_attributes(struct ehca_shca *shca)
 		shca->hw_level = ehca_hw_level;
 	ehca_gen_dbg(" ... hardware level=%x", shca->hw_level);
 
-	shca->sport[0].rate = IB_RATE_30_GBPS;
-	shca->sport[1].rate = IB_RATE_30_GBPS;
-
 	shca->hca_cap = rblock->hca_cap_indicators;
 	ehca_gen_dbg(" ... HCA capabilities:");
 	for (i = 0; i < ARRAY_SIZE(hca_cap_descr); i++)
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index de18264..2e3e654 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1196,10 +1196,6 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_QKEY, 1);
 	}
 	if (attr_mask & IB_QP_AV) {
-		int ah_mult = ib_rate_to_mult(attr->ah_attr.static_rate);
-		int ehca_mult = ib_rate_to_mult(shca->sport[my_qp->
-						init_attr.port_num].rate);
-
 		mqpcb->dlid = attr->ah_attr.dlid;
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_DLID, 1);
 		mqpcb->source_path_bits = attr->ah_attr.src_path_bits;
@@ -1207,11 +1203,12 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		mqpcb->service_level = attr->ah_attr.sl;
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_SERVICE_LEVEL, 1);
 
-		if (ah_mult < ehca_mult)
-			mqpcb->max_static_rate = (ah_mult > 0) ?
-			((ehca_mult - 1) / ah_mult) : 0;
-		else
-			mqpcb->max_static_rate = 0;
+		if (ehca_calc_ipd(shca, my_qp->init_attr.port_num,
+				  attr->ah_attr.static_rate,
+				  &mqpcb->max_static_rate)) {
+			ret = -EINVAL;
+			goto modify_qp_exit2;
+		}
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_MAX_STATIC_RATE, 1);
 
 		/*
@@ -1280,10 +1277,6 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 			(MQPCB_MASK_RDMA_ATOMIC_OUTST_DEST_QP, 1);
 	}
 	if (attr_mask & IB_QP_ALT_PATH) {
-		int ah_mult = ib_rate_to_mult(attr->alt_ah_attr.static_rate);
-		int ehca_mult = ib_rate_to_mult(
-			shca->sport[my_qp->init_attr.port_num].rate);
-
 		if (attr->alt_port_num < 1
 		    || attr->alt_port_num > shca->num_ports) {
 			ret = -EINVAL;
@@ -1309,10 +1302,12 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		mqpcb->source_path_bits_al = attr->alt_ah_attr.src_path_bits;
 		mqpcb->service_level_al = attr->alt_ah_attr.sl;
 
-		if (ah_mult > 0 && ah_mult < ehca_mult)
-			mqpcb->max_static_rate_al = (ehca_mult - 1) / ah_mult;
-		else
-			mqpcb->max_static_rate_al = 0;
+		if (ehca_calc_ipd(shca, my_qp->init_attr.port_num,
+				  attr->alt_ah_attr.static_rate,
+				  &mqpcb->max_static_rate_al)) {
+			ret = -EINVAL;
+			goto modify_qp_exit2;
+		}
 
 		/* OpenIB doesn't support alternate retry counts - copy them */
 		mqpcb->retry_count_al = mqpcb->retry_count;
-- 
1.5.2


