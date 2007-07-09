Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbXGINX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbXGINX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbXGINXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:23:20 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:62541 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbXGINXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:23:19 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 02/13] IB/ehca: HW level, HW caps and MTU autodetection
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707091502.22407.fenkes@de.ibm.com>
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1748
Date: Mon, 9 Jul 2007 15:21:45 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091521.46883.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for support of new eHCA2 features, change adapter probing:
 - Hardware level is changed to encode major and minor chip version
 - Hardware capabilities are queried from the firmware
 - The maximum MTU is queried from the firmware instead of assuming a
   fixed value

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_av.c      |    6 ++-
 drivers/infiniband/hw/ehca/ehca_classes.h |    2 +
 drivers/infiniband/hw/ehca/ehca_hca.c     |   27 +++++++++++-
 drivers/infiniband/hw/ehca/ehca_main.c    |   62 ++++++++++++++++++++++++++---
 drivers/infiniband/hw/ehca/hipz_hw.h      |   18 ++++++++
 5 files changed, 104 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_av.c b/drivers/infiniband/hw/ehca/ehca_av.c
index 0d6e2c4..3cd6bf3 100644
--- a/drivers/infiniband/hw/ehca/ehca_av.c
+++ b/drivers/infiniband/hw/ehca/ehca_av.c
@@ -118,7 +118,7 @@ struct ib_ah *ehca_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 		}
 		memcpy(&av->av.grh.word_1, &gid, sizeof(gid));
 	}
-	av->av.pmtu = EHCA_MAX_MTU;
+	av->av.pmtu = shca->max_mtu;
 
 	/* dgid comes in grh.word_3 */
 	memcpy(&av->av.grh.word_3, &ah_attr->grh.dgid,
@@ -137,6 +137,8 @@ int ehca_modify_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr)
 	struct ehca_av *av;
 	struct ehca_ud_av new_ehca_av;
 	struct ehca_pd *my_pd = container_of(ah->pd, struct ehca_pd, ib_pd);
+	struct ehca_shca *shca = container_of(ah->pd->device, struct ehca_shca,
+					      ib_device);
 	u32 cur_pid = current->tgid;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
@@ -192,7 +194,7 @@ int ehca_modify_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr)
 		memcpy(&new_ehca_av.grh.word_1, &gid, sizeof(gid));
 	}
 
-	new_ehca_av.pmtu = EHCA_MAX_MTU;
+	new_ehca_av.pmtu = shca->max_mtu;
 
 	memcpy(&new_ehca_av.grh.word_3, &ah_attr->grh.dgid,
 	       sizeof(ah_attr->grh.dgid));
diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 1d286d3..35d948f 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -107,6 +107,8 @@ struct ehca_shca {
 	struct ehca_pd *pd;
 	struct h_galpas galpas;
 	struct mutex modify_mutex;
+	u64 hca_cap;
+	int max_mtu;
 };
 
 struct ehca_pd {
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 32b55a4..b310de5 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -45,11 +45,25 @@
 
 int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 {
-	int ret = 0;
+	int i, ret = 0;
 	struct ehca_shca *shca = container_of(ibdev, struct ehca_shca,
 					      ib_device);
 	struct hipz_query_hca *rblock;
 
+	static const u32 cap_mapping[] = {
+		IB_DEVICE_RESIZE_MAX_WR,      HCA_CAP_WQE_RESIZE,
+		IB_DEVICE_BAD_PKEY_CNTR,      HCA_CAP_BAD_P_KEY_CTR,
+		IB_DEVICE_BAD_QKEY_CNTR,      HCA_CAP_Q_KEY_VIOL_CTR,
+		IB_DEVICE_RAW_MULTI,          HCA_CAP_RAW_PACKET_MCAST,
+		IB_DEVICE_AUTO_PATH_MIG,      HCA_CAP_AUTO_PATH_MIG,
+		IB_DEVICE_CHANGE_PHY_PORT,    HCA_CAP_SQD_RTS_PORT_CHANGE,
+		IB_DEVICE_UD_AV_PORT_ENFORCE, HCA_CAP_AH_PORT_NR_CHECK,
+		IB_DEVICE_CURR_QP_STATE_MOD,  HCA_CAP_CUR_QP_STATE_MOD,
+		IB_DEVICE_SHUTDOWN_PORT,      HCA_CAP_SHUTDOWN_PORT,
+		IB_DEVICE_INIT_TYPE,          HCA_CAP_INIT_TYPE,
+		IB_DEVICE_PORT_ACTIVE_EVENT,  HCA_CAP_PORT_ACTIVE_EVENT,
+	};
+
 	rblock = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!rblock) {
 		ehca_err(&shca->ib_device, "Can't allocate rblock memory.");
@@ -96,6 +110,13 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 	props->max_total_mcast_qp_attach
 		= min_t(int, rblock->max_total_mcast_qp_attach, INT_MAX);
 
+	/* translate device capabilities */
+	props->device_cap_flags = IB_DEVICE_SYS_IMAGE_GUID |
+		IB_DEVICE_RC_RNR_NAK_GEN | IB_DEVICE_N_NOTIFY_CQ;
+	for (i = 0; i < ARRAY_SIZE(cap_mapping); i += 2)
+		if (rblock->hca_cap_indicators & cap_mapping[i + 1])
+			props->device_cap_flags |= cap_mapping[i];
+
 query_device1:
 	ehca_free_fw_ctrlblock(rblock);
 
@@ -261,7 +282,7 @@ int ehca_modify_port(struct ib_device *ibdev,
 	}
 
 	if (mutex_lock_interruptible(&shca->modify_mutex))
-                return -ERESTARTSYS;
+		return -ERESTARTSYS;
 
 	rblock = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!rblock) {
@@ -290,7 +311,7 @@ modify_port2:
 	ehca_free_fw_ctrlblock(rblock);
 
 modify_port1:
-        mutex_unlock(&shca->modify_mutex);
+	mutex_unlock(&shca->modify_mutex);
 
 	return ret;
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index fea199f..befbb9c 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -205,11 +205,35 @@ static void ehca_destroy_slab_caches(void)
 #define EHCA_HCAAVER  EHCA_BMASK_IBM(32,39)
 #define EHCA_REVID    EHCA_BMASK_IBM(40,63)
 
+static struct cap_descr {
+	u64 mask;
+	char *descr;
+} hca_cap_descr[] = {
+	{ HCA_CAP_AH_PORT_NR_CHECK, "HCA_CAP_AH_PORT_NR_CHECK" },
+	{ HCA_CAP_ATOMIC, "HCA_CAP_ATOMIC" },
+	{ HCA_CAP_AUTO_PATH_MIG, "HCA_CAP_AUTO_PATH_MIG" },
+	{ HCA_CAP_BAD_P_KEY_CTR, "HCA_CAP_BAD_P_KEY_CTR" },
+	{ HCA_CAP_SQD_RTS_PORT_CHANGE, "HCA_CAP_SQD_RTS_PORT_CHANGE" },
+	{ HCA_CAP_CUR_QP_STATE_MOD, "HCA_CAP_CUR_QP_STATE_MOD" },
+	{ HCA_CAP_INIT_TYPE, "HCA_CAP_INIT_TYPE" },
+	{ HCA_CAP_PORT_ACTIVE_EVENT, "HCA_CAP_PORT_ACTIVE_EVENT" },
+	{ HCA_CAP_Q_KEY_VIOL_CTR, "HCA_CAP_Q_KEY_VIOL_CTR" },
+	{ HCA_CAP_WQE_RESIZE, "HCA_CAP_WQE_RESIZE" },
+	{ HCA_CAP_RAW_PACKET_MCAST, "HCA_CAP_RAW_PACKET_MCAST" },
+	{ HCA_CAP_SHUTDOWN_PORT, "HCA_CAP_SHUTDOWN_PORT" },
+	{ HCA_CAP_RC_LL_QP, "HCA_CAP_RC_LL_QP" },
+	{ HCA_CAP_SRQ, "HCA_CAP_SRQ" },
+	{ HCA_CAP_UD_LL_QP, "HCA_CAP_UD_LL_QP" },
+	{ HCA_CAP_RESIZE_MR, "HCA_CAP_RESIZE_MR" },
+	{ HCA_CAP_MINI_QP, "HCA_CAP_MINI_QP" },
+};
+
 int ehca_sense_attributes(struct ehca_shca *shca)
 {
-	int ret = 0;
+	int i, ret = 0;
 	u64 h_ret;
 	struct hipz_query_hca *rblock;
+	struct hipz_query_port *port;
 
 	rblock = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!rblock) {
@@ -222,7 +246,7 @@ int ehca_sense_attributes(struct ehca_shca *shca)
 		ehca_gen_err("Cannot query device properties. h_ret=%lx",
 			     h_ret);
 		ret = -EPERM;
-		goto num_ports1;
+		goto sense_attributes1;
 	}
 
 	if (ehca_nr_ports == 1)
@@ -242,18 +266,44 @@ int ehca_sense_attributes(struct ehca_shca *shca)
 		ehca_gen_dbg(" ... hardware version=%x:%x", hcaaver, revid);
 
 		if ((hcaaver == 1) && (revid == 0))
-			shca->hw_level = 0;
+			shca->hw_level = 0x11;
 		else if ((hcaaver == 1) && (revid == 1))
-			shca->hw_level = 1;
+			shca->hw_level = 0x12;
 		else if ((hcaaver == 1) && (revid == 2))
-			shca->hw_level = 2;
+			shca->hw_level = 0x13;
+		else if ((hcaaver == 2) && (revid == 0))
+			shca->hw_level = 0x21;
+		else if ((hcaaver == 2) && (revid == 0x10))
+			shca->hw_level = 0x22;
+		else {
+			ehca_gen_warn("unknown hardware version"
+				      " - assuming default level");
+			shca->hw_level = 0x22;
+		}
 	}
 	ehca_gen_dbg(" ... hardware level=%x", shca->hw_level);
 
 	shca->sport[0].rate = IB_RATE_30_GBPS;
 	shca->sport[1].rate = IB_RATE_30_GBPS;
 
-num_ports1:
+	shca->hca_cap = rblock->hca_cap_indicators;
+	ehca_gen_dbg(" ... HCA capabilities:");
+	for (i = 0; i < ARRAY_SIZE(hca_cap_descr); i++)
+		if (EHCA_BMASK_GET(hca_cap_descr[i].mask, shca->hca_cap))
+			ehca_gen_dbg("   %s", hca_cap_descr[i].descr);
+
+	port = (struct hipz_query_port*)rblock;
+	h_ret = hipz_h_query_port(shca->ipz_hca_handle, 1, port);
+	if (h_ret != H_SUCCESS) {
+		ehca_gen_err("Cannot query port properties. h_ret=%lx",
+			     h_ret);
+		ret = -EPERM;
+		goto sense_attributes1;
+	}
+
+	shca->max_mtu = port->max_mtu;
+
+sense_attributes1:
 	ehca_free_fw_ctrlblock(rblock);
 	return ret;
 }
diff --git a/drivers/infiniband/hw/ehca/hipz_hw.h b/drivers/infiniband/hw/ehca/hipz_hw.h
index fad9136..9fe8367 100644
--- a/drivers/infiniband/hw/ehca/hipz_hw.h
+++ b/drivers/infiniband/hw/ehca/hipz_hw.h
@@ -360,6 +360,24 @@ struct hipz_query_hca {
 	u32 max_neq;
 } __attribute__ ((packed));
 
+#define HCA_CAP_AH_PORT_NR_CHECK      EHCA_BMASK_IBM(0,0)
+#define HCA_CAP_ATOMIC                EHCA_BMASK_IBM(1,1)
+#define HCA_CAP_AUTO_PATH_MIG         EHCA_BMASK_IBM(2,2)
+#define HCA_CAP_BAD_P_KEY_CTR         EHCA_BMASK_IBM(3,3)
+#define HCA_CAP_SQD_RTS_PORT_CHANGE   EHCA_BMASK_IBM(4,4)
+#define HCA_CAP_CUR_QP_STATE_MOD      EHCA_BMASK_IBM(5,5)
+#define HCA_CAP_INIT_TYPE             EHCA_BMASK_IBM(6,6)
+#define HCA_CAP_PORT_ACTIVE_EVENT     EHCA_BMASK_IBM(7,7)
+#define HCA_CAP_Q_KEY_VIOL_CTR        EHCA_BMASK_IBM(8,8)
+#define HCA_CAP_WQE_RESIZE            EHCA_BMASK_IBM(9,9)
+#define HCA_CAP_RAW_PACKET_MCAST      EHCA_BMASK_IBM(10,10)
+#define HCA_CAP_SHUTDOWN_PORT         EHCA_BMASK_IBM(11,11)
+#define HCA_CAP_RC_LL_QP              EHCA_BMASK_IBM(12,12)
+#define HCA_CAP_SRQ                   EHCA_BMASK_IBM(13,13)
+#define HCA_CAP_UD_LL_QP              EHCA_BMASK_IBM(16,16)
+#define HCA_CAP_RESIZE_MR             EHCA_BMASK_IBM(17,17)
+#define HCA_CAP_MINI_QP               EHCA_BMASK_IBM(18,18)
+
 /* query port response block */
 struct hipz_query_port {
 	u32 state;
-- 
1.5.2


