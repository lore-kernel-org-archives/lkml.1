Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbXGINeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbXGINeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752998AbXGINd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:33:58 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:4118 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbXGINd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:33:57 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 12/13] IB/ehca: notify consumers of LID/PKEY/SM changes after nondisruptive events
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707091502.22407.fenkes@de.ibm.com>
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1748
Date: Mon, 9 Jul 2007 15:32:22 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707091532.23189.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When firmware reports a nondisruptive port configuration change event,
previous versions of the eHCA driver didn't forward the event to consumers
like IPoIB. Add code that determines the type of configuration change by
comparing old and new port attributes and reports it.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    6 ++
 drivers/infiniband/hw/ehca/ehca_hca.c     |   34 +++++++++++
 drivers/infiniband/hw/ehca/ehca_irq.c     |   89 +++++++++++++++++++----------
 drivers/infiniband/hw/ehca/ehca_iverbs.h  |    3 +
 4 files changed, 101 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index f1e0db2..daf823e 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -87,11 +87,17 @@ struct ehca_eq {
 	struct ehca_eqe_cache_entry eqe_cache[EHCA_EQE_CACHE_SIZE];
 };
 
+struct ehca_sma_attr {
+	u16 lid, lmc, sm_sl, sm_lid;
+	u16 pkey_tbl_len, pkeys[16];
+};
+
 struct ehca_sport {
 	struct ib_cq *ibcq_aqp1;
 	struct ib_qp *ibqp_aqp1;
 	enum ib_rate  rate;
 	enum ib_port_state port_state;
+	struct ehca_sma_attr saved_attr;
 };
 
 struct ehca_shca {
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index b310de5..bbd3c6a 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -193,6 +193,40 @@ query_port1:
 	return ret;
 }
 
+int ehca_query_sma_attr(struct ehca_shca *shca,
+			u8 port, struct ehca_sma_attr *attr)
+{
+	int ret = 0;
+	struct hipz_query_port *rblock;
+
+	rblock = ehca_alloc_fw_ctrlblock(GFP_ATOMIC);
+	if (!rblock) {
+		ehca_err(&shca->ib_device, "Can't allocate rblock memory.");
+		return -ENOMEM;
+	}
+
+	if (hipz_h_query_port(shca->ipz_hca_handle, port, rblock) != H_SUCCESS) {
+		ehca_err(&shca->ib_device, "Can't query port properties");
+		ret = -EINVAL;
+		goto query_sma_attr1;
+	}
+
+	memset(attr, 0, sizeof(struct ehca_sma_attr));
+
+	attr->lid    = rblock->lid;
+	attr->lmc    = rblock->lmc;
+	attr->sm_sl  = rblock->sm_sl;
+	attr->sm_lid = rblock->sm_lid;
+
+	attr->pkey_tbl_len = rblock->pkey_tbl_len;
+	memcpy(attr->pkeys, rblock->pkey_entries, sizeof(attr->pkeys));
+
+query_sma_attr1:
+	ehca_free_fw_ctrlblock(rblock);
+
+	return ret;
+}
+
 int ehca_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
 {
 	int ret = 0;
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 02b73c8..96eba38 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -61,6 +61,7 @@
 #define NEQE_EVENT_CODE        EHCA_BMASK_IBM(2,7)
 #define NEQE_PORT_NUMBER       EHCA_BMASK_IBM(8,15)
 #define NEQE_PORT_AVAILABILITY EHCA_BMASK_IBM(16,16)
+#define NEQE_DISRUPTIVE        EHCA_BMASK_IBM(16,16)
 
 #define ERROR_DATA_LENGTH      EHCA_BMASK_IBM(52,63)
 #define ERROR_DATA_TYPE        EHCA_BMASK_IBM(0,7)
@@ -286,30 +287,61 @@ static void parse_identifier(struct ehca_shca *shca, u64 eqe)
 	return;
 }
 
-static void parse_ec(struct ehca_shca *shca, u64 eqe)
+static void dispatch_port_event(struct ehca_shca *shca, int port_num,
+				enum ib_event_type type, const char *msg)
 {
 	struct ib_event event;
+
+	ehca_info(&shca->ib_device, "port %d %s.", port_num, msg);
+	event.device = &shca->ib_device;
+	event.event = type;
+	event.element.port_num = port_num;
+	ib_dispatch_event(&event);
+}
+
+static void notify_port_conf_change(struct ehca_shca *shca, int port_num)
+{
+	struct ehca_sma_attr  new_attr;
+	struct ehca_sma_attr *old_attr = &shca->sport[port_num - 1].saved_attr;
+
+	ehca_query_sma_attr(shca, port_num, &new_attr);
+
+	if (new_attr.sm_sl  != old_attr->sm_sl ||
+	    new_attr.sm_lid != old_attr->sm_lid)
+		dispatch_port_event(shca, port_num, IB_EVENT_SM_CHANGE,
+				    "SM changed");
+
+	if (new_attr.lid != old_attr->lid ||
+	    new_attr.lmc != old_attr->lmc)
+		dispatch_port_event(shca, port_num, IB_EVENT_LID_CHANGE,
+				    "LID changed");
+
+	if (new_attr.pkey_tbl_len != old_attr->pkey_tbl_len ||
+	    memcmp(new_attr.pkeys, old_attr->pkeys,
+		   sizeof(u16) * new_attr.pkey_tbl_len))
+		dispatch_port_event(shca, port_num, IB_EVENT_PKEY_CHANGE,
+				    "P_Key changed");
+
+	*old_attr = new_attr;
+}
+
+static void parse_ec(struct ehca_shca *shca, u64 eqe)
+{
 	u8 ec   = EHCA_BMASK_GET(NEQE_EVENT_CODE, eqe);
 	u8 port = EHCA_BMASK_GET(NEQE_PORT_NUMBER, eqe);
 
 	switch (ec) {
 	case 0x30: /* port availability change */
 		if (EHCA_BMASK_GET(NEQE_PORT_AVAILABILITY, eqe)) {
-			ehca_info(&shca->ib_device,
-				  "port %x is active.", port);
-			event.device = &shca->ib_device;
-			event.event = IB_EVENT_PORT_ACTIVE;
-			event.element.port_num = port;
 			shca->sport[port - 1].port_state = IB_PORT_ACTIVE;
-			ib_dispatch_event(&event);
+			dispatch_port_event(shca, port, IB_EVENT_PORT_ACTIVE,
+					    "is active");
+			ehca_query_sma_attr(shca, port,
+					    &shca->sport[port - 1].saved_attr);
 		} else {
-			ehca_info(&shca->ib_device,
-				  "port %x is inactive.", port);
-			event.device = &shca->ib_device;
-			event.event = IB_EVENT_PORT_ERR;
-			event.element.port_num = port;
 			shca->sport[port - 1].port_state = IB_PORT_DOWN;
-			ib_dispatch_event(&event);
+			dispatch_port_event(shca, port, IB_EVENT_PORT_ERR,
+					    "is inactive");
 		}
 		break;
 	case 0x31:
@@ -317,24 +349,19 @@ static void parse_ec(struct ehca_shca *shca, u64 eqe)
 		 * disruptive change is caused by
 		 * LID, PKEY or SM change
 		 */
-		ehca_warn(&shca->ib_device,
-			  "disruptive port %x configuration change", port);
-
-		ehca_info(&shca->ib_device,
-			  "port %x is inactive.", port);
-		event.device = &shca->ib_device;
-		event.event = IB_EVENT_PORT_ERR;
-		event.element.port_num = port;
-		shca->sport[port - 1].port_state = IB_PORT_DOWN;
-		ib_dispatch_event(&event);
-
-		ehca_info(&shca->ib_device,
-			  "port %x is active.", port);
-		event.device = &shca->ib_device;
-		event.event = IB_EVENT_PORT_ACTIVE;
-		event.element.port_num = port;
-		shca->sport[port - 1].port_state = IB_PORT_ACTIVE;
-		ib_dispatch_event(&event);
+		if (EHCA_BMASK_GET(NEQE_DISRUPTIVE, eqe)) {
+			ehca_warn(&shca->ib_device, "disruptive port "
+				  "%d configuration change", port);
+
+			shca->sport[port - 1].port_state = IB_PORT_DOWN;
+			dispatch_port_event(shca, port, IB_EVENT_PORT_ERR,
+					    "is inactive");
+
+			shca->sport[port - 1].port_state = IB_PORT_ACTIVE;
+			dispatch_port_event(shca, port, IB_EVENT_PORT_ACTIVE,
+					    "is active");
+		} else
+			notify_port_conf_change(shca, port);
 		break;
 	case 0x32: /* adapter malfunction */
 		ehca_err(&shca->ib_device, "Adapter malfunction.");
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index fd84a80..77aeca6 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -49,6 +49,9 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props);
 int ehca_query_port(struct ib_device *ibdev, u8 port,
 		    struct ib_port_attr *props);
 
+int ehca_query_sma_attr(struct ehca_shca *shca, u8 port,
+			struct ehca_sma_attr *attr);
+
 int ehca_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 * pkey);
 
 int ehca_query_gid(struct ib_device *ibdev, u8 port, int index,
-- 
1.5.2


