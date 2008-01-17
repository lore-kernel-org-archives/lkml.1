Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbYAQOGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbYAQOGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 09:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYAQOFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 09:05:53 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:20087 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbYAQOFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 09:05:51 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 3/4] IB/ehca: Add "port connection autodetect mode"
User-Agent: KMail/1.9.1
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200801171502.34287.fenkes@de.ibm.com>
In-Reply-To: <200801171502.34287.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1884
Date: Thu, 17 Jan 2008 15:05:45 +0100
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801171505.45612.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

This patch enhances ehca with a capability to "autodetect" the ports being
connected physically. In order to utilize that function the module option
nr_ports must be set to -1 (default is 2 - two ports). This feature is
experimental and will made the default later.

More detail:

If the user connects only one port to the switch, current code requires
  1) port one to be connected and
  2) module option nr_ports=1 to be given.

If autodetect is enabled, ehca will not wait at creation of the GSI QP for
the respective port to become active. Since firmware does not accept
modify_qp() while the port is down at initialization, we need to cache all
calls to modify_qp() for the SMI/GSI QP and just return a good return code.

When a port is activated and we get a PORT_ACTIVE event, we replay the
cached modify-qp() parms and re-trigger any posted recv WRs. Only then do we
forward the PORT_ACTIVE event to registered clients.

The result of this autodetect patch is that all ports will be accessible by
the users. Depending on their respective cabling only those ports that are
connected properly will become operable. If a user tries to modify a regular
QP of a non-connected port, modify_qp() will fail. Furthermore, ibv_devinfo
should show the port state accordingly.

Note that this patch primarily improves the loading behaviour of ehca. If
the cable is removed while the driver is operating and plugged in again,
firmware will handle that properly by sending an appropriate async event.

Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |   16 +++
 drivers/infiniband/hw/ehca/ehca_irq.c     |   26 ++++-
 drivers/infiniband/hw/ehca/ehca_iverbs.h  |    2 +
 drivers/infiniband/hw/ehca/ehca_main.c    |    7 +-
 drivers/infiniband/hw/ehca/ehca_qp.c      |  162 ++++++++++++++++++++++++++++-
 drivers/infiniband/hw/ehca/ehca_sqp.c     |    6 +-
 6 files changed, 204 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 936580d..2502366 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -95,6 +95,10 @@ struct ehca_sma_attr {
 struct ehca_sport {
 	struct ib_cq *ibcq_aqp1;
 	struct ib_qp *ibqp_sqp[2];
+	/* lock to serialze modify_qp() calls for sqp in normal
+	 * and irq path (when event PORT_ACTIVE is received first time)
+	 */
+	spinlock_t mod_sqp_lock;
 	enum ib_port_state port_state;
 	struct ehca_sma_attr saved_attr;
 };
@@ -141,6 +145,14 @@ enum ehca_ext_qp_type {
 	EQPT_SRQ       = 3,
 };
 
+/* struct to cache modify_qp()'s parms for GSI/SMI qp */
+struct ehca_mod_qp_parm {
+	int mask;
+	struct ib_qp_attr attr;
+};
+
+#define EHCA_MOD_QP_PARM_MAX 4
+
 struct ehca_qp {
 	union {
 		struct ib_qp ib_qp;
@@ -164,6 +176,9 @@ struct ehca_qp {
 	struct ehca_cq *recv_cq;
 	unsigned int sqerr_purgeflag;
 	struct hlist_node list_entries;
+	/* array to cache modify_qp()'s parms for GSI/SMI qp */
+	struct ehca_mod_qp_parm *mod_qp_parm;
+	int mod_qp_parm_idx;
 	/* mmap counter for resources mapped into user space */
 	u32 mm_count_squeue;
 	u32 mm_count_rqueue;
@@ -323,6 +338,7 @@ extern int ehca_port_act_time;
 extern int ehca_use_hp_mr;
 extern int ehca_scaling_code;
 extern int ehca_lock_hcalls;
+extern int ehca_nr_ports;
 
 struct ipzu_queue_resp {
 	u32 qe_size;      /* queue entry size */
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 4c734ec..863b34f 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -356,17 +356,33 @@ static void parse_ec(struct ehca_shca *shca, u64 eqe)
 	u8 ec   = EHCA_BMASK_GET(NEQE_EVENT_CODE, eqe);
 	u8 port = EHCA_BMASK_GET(NEQE_PORT_NUMBER, eqe);
 	u8 spec_event;
+	struct ehca_sport *sport = &shca->sport[port - 1];
+	unsigned long flags;
 
 	switch (ec) {
 	case 0x30: /* port availability change */
 		if (EHCA_BMASK_GET(NEQE_PORT_AVAILABILITY, eqe)) {
-			shca->sport[port - 1].port_state = IB_PORT_ACTIVE;
+			int suppress_event;
+			/* replay modify_qp for sqps */
+			spin_lock_irqsave(&sport->mod_sqp_lock, flags);
+			suppress_event = !sport->ibqp_sqp[IB_QPT_GSI];
+			if (sport->ibqp_sqp[IB_QPT_SMI])
+				ehca_recover_sqp(sport->ibqp_sqp[IB_QPT_SMI]);
+			if (!suppress_event)
+				ehca_recover_sqp(sport->ibqp_sqp[IB_QPT_GSI]);
+			spin_unlock_irqrestore(&sport->mod_sqp_lock, flags);
+
+			/* AQP1 was destroyed, ignore this event */
+			if (suppress_event)
+				break;
+
+			sport->port_state = IB_PORT_ACTIVE;
 			dispatch_port_event(shca, port, IB_EVENT_PORT_ACTIVE,
 					    "is active");
 			ehca_query_sma_attr(shca, port,
-					    &shca->sport[port - 1].saved_attr);
+					    &sport->saved_attr);
 		} else {
-			shca->sport[port - 1].port_state = IB_PORT_DOWN;
+			sport->port_state = IB_PORT_DOWN;
 			dispatch_port_event(shca, port, IB_EVENT_PORT_ERR,
 					    "is inactive");
 		}
@@ -380,11 +396,11 @@ static void parse_ec(struct ehca_shca *shca, u64 eqe)
 			ehca_warn(&shca->ib_device, "disruptive port "
 				  "%d configuration change", port);
 
-			shca->sport[port - 1].port_state = IB_PORT_DOWN;
+			sport->port_state = IB_PORT_DOWN;
 			dispatch_port_event(shca, port, IB_EVENT_PORT_ERR,
 					    "is inactive");
 
-			shca->sport[port - 1].port_state = IB_PORT_ACTIVE;
+			sport->port_state = IB_PORT_ACTIVE;
 			dispatch_port_event(shca, port, IB_EVENT_PORT_ACTIVE,
 					    "is active");
 		} else
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index 5485799..c469bfd 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -200,4 +200,6 @@ void ehca_free_fw_ctrlblock(void *ptr);
 #define ehca_free_fw_ctrlblock(ptr) free_page((unsigned long)(ptr))
 #endif
 
+void ehca_recover_sqp(struct ib_qp *sqp);
+
 #endif
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index cde486c..74a4592 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -90,7 +90,8 @@ MODULE_PARM_DESC(hw_level,
 		 "hardware level"
 		 " (0: autosensing (default), 1: v. 0.20, 2: v. 0.21)");
 MODULE_PARM_DESC(nr_ports,
-		 "number of connected ports (default: 2)");
+		 "number of connected ports (-1: autodetect, 1: port one only, "
+		 "2: two ports (default)");
 MODULE_PARM_DESC(use_hp_mr,
 		 "high performance MRs (0: no (default), 1: yes)");
 MODULE_PARM_DESC(port_act_time,
@@ -688,7 +689,7 @@ static int __devinit ehca_probe(struct of_device *dev,
 	struct ehca_shca *shca;
 	const u64 *handle;
 	struct ib_pd *ibpd;
-	int ret;
+	int ret, i;
 
 	handle = of_get_property(dev->node, "ibm,hca-handle", NULL);
 	if (!handle) {
@@ -709,6 +710,8 @@ static int __devinit ehca_probe(struct of_device *dev,
 		return -ENOMEM;
 	}
 	mutex_init(&shca->modify_mutex);
+	for (i = 0; i < ARRAY_SIZE(shca->sport); i++)
+		spin_lock_init(&shca->sport[i].mod_sqp_lock);
 
 	shca->ofdev = dev;
 	shca->ipz_hca_handle.handle = *handle;
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 26c6a94..bb7ccef 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -729,12 +729,31 @@ static struct ehca_qp *internal_create_qp(
 	init_attr->cap.max_send_wr = parms.squeue.act_nr_wqes;
 	my_qp->init_attr = *init_attr;
 
+	if (qp_type == IB_QPT_SMI || qp_type == IB_QPT_GSI) {
+		shca->sport[init_attr->port_num - 1].ibqp_sqp[qp_type] =
+			&my_qp->ib_qp;
+		if (ehca_nr_ports < 0) {
+			/* alloc array to cache subsequent modify qp parms
+			 * for autodetect mode
+			 */
+			my_qp->mod_qp_parm =
+				kzalloc(EHCA_MOD_QP_PARM_MAX *
+					sizeof(*my_qp->mod_qp_parm),
+					GFP_KERNEL);
+			if (!my_qp->mod_qp_parm) {
+				ehca_err(pd->device,
+					 "Could not alloc mod_qp_parm");
+				goto create_qp_exit4;
+			}
+		}
+	}
+
 	/* NOTE: define_apq0() not supported yet */
 	if (qp_type == IB_QPT_GSI) {
 		h_ret = ehca_define_sqp(shca, my_qp, init_attr);
 		if (h_ret != H_SUCCESS) {
 			ret = ehca2ib_return_code(h_ret);
-			goto create_qp_exit4;
+			goto create_qp_exit5;
 		}
 	}
 
@@ -743,7 +762,7 @@ static struct ehca_qp *internal_create_qp(
 		if (ret) {
 			ehca_err(pd->device,
 				 "Couldn't assign qp to send_cq ret=%i", ret);
-			goto create_qp_exit4;
+			goto create_qp_exit5;
 		}
 	}
 
@@ -769,15 +788,19 @@ static struct ehca_qp *internal_create_qp(
 		if (ib_copy_to_udata(udata, &resp, sizeof resp)) {
 			ehca_err(pd->device, "Copy to udata failed");
 			ret = -EINVAL;
-			goto create_qp_exit5;
+			goto create_qp_exit6;
 		}
 	}
 
 	return my_qp;
 
-create_qp_exit5:
+create_qp_exit6:
 	ehca_cq_unassign_qp(my_qp->send_cq, my_qp->real_qp_num);
 
+create_qp_exit5:
+	if (my_qp->mod_qp_parm)
+		kfree(my_qp->mod_qp_parm);
+
 create_qp_exit4:
 	if (HAS_RQ(my_qp))
 		ipz_queue_dtor(my_pd, &my_qp->ipz_rqueue);
@@ -995,7 +1018,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 	unsigned long flags = 0;
 
 	/* do query_qp to obtain current attr values */
-	mqpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
+	mqpcb = ehca_alloc_fw_ctrlblock(GFP_ATOMIC);
 	if (!mqpcb) {
 		ehca_err(ibqp->device, "Could not get zeroed page for mqpcb "
 			 "ehca_qp=%p qp_num=%x ", my_qp, ibqp->qp_num);
@@ -1183,6 +1206,8 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_PRIM_P_KEY_IDX, 1);
 	}
 	if (attr_mask & IB_QP_PORT) {
+		struct ehca_sport *sport;
+		struct ehca_qp *aqp1;
 		if (attr->port_num < 1 || attr->port_num > shca->num_ports) {
 			ret = -EINVAL;
 			ehca_err(ibqp->device, "Invalid port=%x. "
@@ -1191,6 +1216,29 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 				 shca->num_ports);
 			goto modify_qp_exit2;
 		}
+		sport = &shca->sport[attr->port_num - 1];
+		if (!sport->ibqp_sqp[IB_QPT_GSI]) {
+			/* should not occur */
+			ret = -EFAULT;
+			ehca_err(ibqp->device, "AQP1 was not created for "
+				 "port=%x", attr->port_num);
+			goto modify_qp_exit2;
+		}
+		aqp1 = container_of(sport->ibqp_sqp[IB_QPT_GSI],
+				    struct ehca_qp, ib_qp);
+		if (ibqp->qp_type != IB_QPT_GSI &&
+		    ibqp->qp_type != IB_QPT_SMI &&
+		    aqp1->mod_qp_parm) {
+			/*
+			 * firmware will reject this modify_qp() because
+			 * port is not activated/initialized fully
+			 */
+			ret = -EFAULT;
+			ehca_warn(ibqp->device, "Couldn't modify qp port=%x: "
+				  "either port is being activated (try again) "
+				  "or cabling issue", attr->port_num);
+			goto modify_qp_exit2;
+		}
 		mqpcb->prim_phys_port = attr->port_num;
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_PRIM_PHYS_PORT, 1);
 	}
@@ -1470,6 +1518,8 @@ modify_qp_exit1:
 int ehca_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 		   struct ib_udata *udata)
 {
+	struct ehca_shca *shca = container_of(ibqp->device, struct ehca_shca,
+					      ib_device);
 	struct ehca_qp *my_qp = container_of(ibqp, struct ehca_qp, ib_qp);
 	struct ehca_pd *my_pd = container_of(my_qp->ib_qp.pd, struct ehca_pd,
 					     ib_pd);
@@ -1482,9 +1532,100 @@ int ehca_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr, int attr_mask,
 		return -EINVAL;
 	}
 
+	/* The if-block below caches qp_attr to be modified for GSI and SMI
+	 * qps during the initialization by ib_mad. When the respective port
+	 * is activated, ie we got an event PORT_ACTIVE, we'll replay the
+	 * cached modify calls sequence, see ehca_recover_sqs() below.
+	 * Why that is required:
+	 * 1) If one port is connected, older code requires that port one
+	 *    to be connected and module option nr_ports=1 to be given by
+	 *    user, which is very inconvenient for end user.
+	 * 2) Firmware accepts modify_qp() only if respective port has become
+	 *    active. Older code had a wait loop of 30sec create_qp()/
+	 *    define_aqp1(), which is not appropriate in practice. This
+	 *    code now removes that wait loop, see define_aqp1(), and always
+	 *    reports all ports to ib_mad resp. users. Only activated ports
+	 *    will then usable for the users.
+	 */
+	if (ibqp->qp_type == IB_QPT_GSI || ibqp->qp_type == IB_QPT_SMI) {
+		int port = my_qp->init_attr.port_num;
+		struct ehca_sport *sport = &shca->sport[port - 1];
+		unsigned long flags;
+		spin_lock_irqsave(&sport->mod_sqp_lock, flags);
+		/* cache qp_attr only during init */
+		if (my_qp->mod_qp_parm) {
+			struct ehca_mod_qp_parm *p;
+			if (my_qp->mod_qp_parm_idx >= EHCA_MOD_QP_PARM_MAX) {
+				ehca_err(&shca->ib_device,
+					 "mod_qp_parm overflow state=%x port=%x"
+					 " type=%x", attr->qp_state,
+					 my_qp->init_attr.port_num,
+					 ibqp->qp_type);
+				spin_unlock_irqrestore(&sport->mod_sqp_lock,
+						       flags);
+				return -EINVAL;
+			}
+			p = &my_qp->mod_qp_parm[my_qp->mod_qp_parm_idx];
+			p->mask = attr_mask;
+			p->attr = *attr;
+			my_qp->mod_qp_parm_idx++;
+			ehca_dbg(&shca->ib_device,
+				 "Saved qp_attr for state=%x port=%x type=%x",
+				 attr->qp_state, my_qp->init_attr.port_num,
+				 ibqp->qp_type);
+			spin_unlock_irqrestore(&sport->mod_sqp_lock, flags);
+			return 0;
+		}
+		spin_unlock_irqrestore(&sport->mod_sqp_lock, flags);
+	}
+
 	return internal_modify_qp(ibqp, attr, attr_mask, 0);
 }
 
+void ehca_recover_sqp(struct ib_qp *sqp)
+{
+	struct ehca_qp *my_sqp = container_of(sqp, struct ehca_qp, ib_qp);
+	int port = my_sqp->init_attr.port_num;
+	struct ib_qp_attr attr;
+	struct ehca_mod_qp_parm *qp_parm;
+	int i, qp_parm_idx, ret;
+	unsigned long flags, wr_cnt;
+
+	if (!my_sqp->mod_qp_parm)
+		return;
+	ehca_dbg(sqp->device, "SQP port=%x qp_num=%x", port, sqp->qp_num);
+
+	qp_parm = my_sqp->mod_qp_parm;
+	qp_parm_idx = my_sqp->mod_qp_parm_idx;
+	for (i = 0; i < qp_parm_idx; i++) {
+		attr = qp_parm[i].attr;
+		ret = internal_modify_qp(sqp, &attr, qp_parm[i].mask, 0);
+		if (ret) {
+			ehca_err(sqp->device, "Could not modify SQP port=%x "
+				 "qp_num=%x ret=%x", port, sqp->qp_num, ret);
+			goto free_qp_parm;
+		}
+		ehca_dbg(sqp->device, "SQP port=%x qp_num=%x in state=%x",
+			 port, sqp->qp_num, attr.qp_state);
+	}
+
+	/* re-trigger posted recv wrs */
+	wr_cnt =  my_sqp->ipz_rqueue.current_q_offset /
+		my_sqp->ipz_rqueue.qe_size;
+	if (wr_cnt) {
+		spin_lock_irqsave(&my_sqp->spinlock_r, flags);
+		hipz_update_rqa(my_sqp, wr_cnt);
+		spin_unlock_irqrestore(&my_sqp->spinlock_r, flags);
+		ehca_dbg(sqp->device, "doorbell port=%x qp_num=%x wr_cnt=%lx",
+			 port, sqp->qp_num, wr_cnt);
+	}
+
+free_qp_parm:
+	kfree(qp_parm);
+	/* this prevents subsequent calls to modify_qp() to cache qp_attr */
+	my_sqp->mod_qp_parm = NULL;
+}
+
 int ehca_query_qp(struct ib_qp *qp,
 		  struct ib_qp_attr *qp_attr,
 		  int qp_attr_mask, struct ib_qp_init_attr *qp_init_attr)
@@ -1772,6 +1913,7 @@ static int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
 	struct ehca_shca *shca = container_of(dev, struct ehca_shca, ib_device);
 	struct ehca_pd *my_pd = container_of(my_qp->ib_qp.pd, struct ehca_pd,
 					     ib_pd);
+	struct ehca_sport *sport = &shca->sport[my_qp->init_attr.port_num - 1];
 	u32 cur_pid = current->tgid;
 	u32 qp_num = my_qp->real_qp_num;
 	int ret;
@@ -1818,6 +1960,16 @@ static int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
 	port_num = my_qp->init_attr.port_num;
 	qp_type  = my_qp->init_attr.qp_type;
 
+	if (qp_type == IB_QPT_SMI || qp_type == IB_QPT_GSI) {
+		spin_lock_irqsave(&sport->mod_sqp_lock, flags);
+		if (my_qp->mod_qp_parm) {
+			kfree(my_qp->mod_qp_parm);
+			my_qp->mod_qp_parm = NULL;
+		}
+		shca->sport[port_num - 1].ibqp_sqp[qp_type] = NULL;
+		spin_unlock_irqrestore(&sport->mod_sqp_lock, flags);
+	}
+
 	/* no support for IB_QPT_SMI yet */
 	if (qp_type == IB_QPT_GSI) {
 		struct ib_event event;
diff --git a/drivers/infiniband/hw/ehca/ehca_sqp.c b/drivers/infiniband/hw/ehca/ehca_sqp.c
index f0792e5..79e72b2 100644
--- a/drivers/infiniband/hw/ehca/ehca_sqp.c
+++ b/drivers/infiniband/hw/ehca/ehca_sqp.c
@@ -40,11 +40,8 @@
  */
 
 
-#include <linux/module.h>
-#include <linux/err.h>
 #include "ehca_classes.h"
 #include "ehca_tools.h"
-#include "ehca_qes.h"
 #include "ehca_iverbs.h"
 #include "hcp_if.h"
 
@@ -93,6 +90,9 @@ u64 ehca_define_sqp(struct ehca_shca *shca,
 		return H_PARAMETER;
 	}
 
+	if (ehca_nr_ports < 0) /* autodetect mode */
+		return H_SUCCESS;
+
 	for (counter = 0;
 	     shca->sport[port - 1].port_state != IB_PORT_ACTIVE &&
 		     counter < ehca_port_act_time;
-- 
1.5.2



