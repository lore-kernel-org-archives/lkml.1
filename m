Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbYCMUPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbYCMUPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbYCMUPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:15:17 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:33303 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbYCMUPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:15:12 -0400
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 13 Mar 2008 13:15:11 -0700
Message-ID: <adamyp2z8hc.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Mar 2008 20:15:11.0512 (UTC) FILETIME=[F0DA9180:01C88546]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get some more small post-2.6.25-rc5 fixes, mostly to the
ipath driver but some to IP-over-IB also:

Or Gerlitz (1):
      IPoIB: Don't drop multicast sends when they can be queued

Patrick Marchand Latifi (4):
      IB/ipath: Fix potentially wrong RNR retry counter returned in ipath_query_qp()
      IB/ipath: Fix RC QP initialization
      IB/ipath: Fix error completion put on send CQ instead of recv CQ
      IB/ipath: Reset the retry counter for RDMA_READ_RESPONSE_MIDDLE packets

Ralph Campbell (1):
      IB/ipath: Fix IB compliance problems with link state vs physical state

Roland Dreier (2):
      IPoIB/cm: Set tx_wr.num_sge in connected mode post_send()
      IPoIB: Allocate priv->tx_ring with vmalloc()

 drivers/infiniband/hw/ipath/ipath_common.h     |    2 +-
 drivers/infiniband/hw/ipath/ipath_driver.c     |   28 ++++++++++-------------
 drivers/infiniband/hw/ipath/ipath_kernel.h     |    1 +
 drivers/infiniband/hw/ipath/ipath_mad.c        |    7 ++---
 drivers/infiniband/hw/ipath/ipath_qp.c         |   13 ++++++-----
 drivers/infiniband/hw/ipath/ipath_rc.c         |    4 +++
 drivers/infiniband/hw/ipath/ipath_registers.h  |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |    9 +++++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |    9 ++++---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    2 +-
 10 files changed, 41 insertions(+), 36 deletions(-)


diff --git a/drivers/infiniband/hw/ipath/ipath_common.h b/drivers/infiniband/hw/ipath/ipath_common.h
index 4146210..591901a 100644
--- a/drivers/infiniband/hw/ipath/ipath_common.h
+++ b/drivers/infiniband/hw/ipath/ipath_common.h
@@ -75,7 +75,7 @@
 #define IPATH_IB_LINKDOWN		0
 #define IPATH_IB_LINKARM		1
 #define IPATH_IB_LINKACTIVE		2
-#define IPATH_IB_LINKINIT		3
+#define IPATH_IB_LINKDOWN_ONLY		3
 #define IPATH_IB_LINKDOWN_SLEEP		4
 #define IPATH_IB_LINKDOWN_DISABLE	5
 #define IPATH_IB_LINK_LOOPBACK	6 /* enable local loopback */
diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index d5ff6ca..ca4d0ac 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -851,8 +851,7 @@ void ipath_disarm_piobufs(struct ipath_devdata *dd, unsigned first,
  * -ETIMEDOUT state can have multiple states set, for any of several
  * transitions.
  */
-static int ipath_wait_linkstate(struct ipath_devdata *dd, u32 state,
-				int msecs)
+int ipath_wait_linkstate(struct ipath_devdata *dd, u32 state, int msecs)
 {
 	dd->ipath_state_wanted = state;
 	wait_event_interruptible_timeout(ipath_state_wait,
@@ -1656,8 +1655,8 @@ void ipath_cancel_sends(struct ipath_devdata *dd, int restore_sendctrl)
 static void ipath_set_ib_lstate(struct ipath_devdata *dd, int which)
 {
 	static const char *what[4] = {
-		[0] = "DOWN",
-		[INFINIPATH_IBCC_LINKCMD_INIT] = "INIT",
+		[0] = "NOP",
+		[INFINIPATH_IBCC_LINKCMD_DOWN] = "DOWN",
 		[INFINIPATH_IBCC_LINKCMD_ARMED] = "ARMED",
 		[INFINIPATH_IBCC_LINKCMD_ACTIVE] = "ACTIVE"
 	};
@@ -1672,9 +1671,9 @@ static void ipath_set_ib_lstate(struct ipath_devdata *dd, int which)
 			    (dd, dd->ipath_kregs->kr_ibcstatus) >>
 			    INFINIPATH_IBCS_LINKTRAININGSTATE_SHIFT) &
 			   INFINIPATH_IBCS_LINKTRAININGSTATE_MASK]);
-	/* flush all queued sends when going to DOWN or INIT, to be sure that
+	/* flush all queued sends when going to DOWN to be sure that
 	 * they don't block MAD packets */
-	if (!linkcmd || linkcmd == INFINIPATH_IBCC_LINKCMD_INIT)
+	if (linkcmd == INFINIPATH_IBCC_LINKCMD_DOWN)
 		ipath_cancel_sends(dd, 1);
 
 	ipath_write_kreg(dd, dd->ipath_kregs->kr_ibcctrl,
@@ -1687,6 +1686,13 @@ int ipath_set_linkstate(struct ipath_devdata *dd, u8 newstate)
 	int ret;
 
 	switch (newstate) {
+	case IPATH_IB_LINKDOWN_ONLY:
+		ipath_set_ib_lstate(dd, INFINIPATH_IBCC_LINKCMD_DOWN <<
+				    INFINIPATH_IBCC_LINKCMD_SHIFT);
+		/* don't wait */
+		ret = 0;
+		goto bail;
+
 	case IPATH_IB_LINKDOWN:
 		ipath_set_ib_lstate(dd, INFINIPATH_IBCC_LINKINITCMD_POLL <<
 				    INFINIPATH_IBCC_LINKINITCMD_SHIFT);
@@ -1709,16 +1715,6 @@ int ipath_set_linkstate(struct ipath_devdata *dd, u8 newstate)
 		ret = 0;
 		goto bail;
 
-	case IPATH_IB_LINKINIT:
-		if (dd->ipath_flags & IPATH_LINKINIT) {
-			ret = 0;
-			goto bail;
-		}
-		ipath_set_ib_lstate(dd, INFINIPATH_IBCC_LINKCMD_INIT <<
-				    INFINIPATH_IBCC_LINKCMD_SHIFT);
-		lstate = IPATH_LINKINIT;
-		break;
-
 	case IPATH_IB_LINKARM:
 		if (dd->ipath_flags & IPATH_LINKARMED) {
 			ret = 0;
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index 4cc0f95..ecf3f7f 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -767,6 +767,7 @@ void ipath_kreceive(struct ipath_portdata *);
 int ipath_setrcvhdrsize(struct ipath_devdata *, unsigned);
 int ipath_reset_device(int);
 void ipath_get_faststats(unsigned long);
+int ipath_wait_linkstate(struct ipath_devdata *, u32, int);
 int ipath_set_linkstate(struct ipath_devdata *, u8);
 int ipath_set_mtu(struct ipath_devdata *, u16);
 int ipath_set_lid(struct ipath_devdata *, u32, u8);
diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index d98d5f1..b34b91d 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -555,10 +555,7 @@ static int recv_subn_set_portinfo(struct ib_smp *smp,
 		/* FALLTHROUGH */
 	case IB_PORT_DOWN:
 		if (lstate == 0)
-			if (get_linkdowndefaultstate(dd))
-				lstate = IPATH_IB_LINKDOWN_SLEEP;
-			else
-				lstate = IPATH_IB_LINKDOWN;
+			lstate = IPATH_IB_LINKDOWN_ONLY;
 		else if (lstate == 1)
 			lstate = IPATH_IB_LINKDOWN_SLEEP;
 		else if (lstate == 2)
@@ -568,6 +565,8 @@ static int recv_subn_set_portinfo(struct ib_smp *smp,
 		else
 			goto err;
 		ipath_set_linkstate(dd, lstate);
+		ipath_wait_linkstate(dd, IPATH_LINKINIT | IPATH_LINKARMED |
+				IPATH_LINKACTIVE, 1000);
 		break;
 	case IB_PORT_ARMED:
 		ipath_set_linkstate(dd, IPATH_IB_LINKARM);
diff --git a/drivers/infiniband/hw/ipath/ipath_qp.c b/drivers/infiniband/hw/ipath/ipath_qp.c
index 80dc623..087ed31 100644
--- a/drivers/infiniband/hw/ipath/ipath_qp.c
+++ b/drivers/infiniband/hw/ipath/ipath_qp.c
@@ -329,8 +329,9 @@ struct ipath_qp *ipath_lookup_qpn(struct ipath_qp_table *qpt, u32 qpn)
 /**
  * ipath_reset_qp - initialize the QP state to the reset state
  * @qp: the QP to reset
+ * @type: the QP type
  */
-static void ipath_reset_qp(struct ipath_qp *qp)
+static void ipath_reset_qp(struct ipath_qp *qp, enum ib_qp_type type)
 {
 	qp->remote_qpn = 0;
 	qp->qkey = 0;
@@ -342,7 +343,7 @@ static void ipath_reset_qp(struct ipath_qp *qp)
 	qp->s_psn = 0;
 	qp->r_psn = 0;
 	qp->r_msn = 0;
-	if (qp->ibqp.qp_type == IB_QPT_RC) {
+	if (type == IB_QPT_RC) {
 		qp->s_state = IB_OPCODE_RC_SEND_LAST;
 		qp->r_state = IB_OPCODE_RC_SEND_LAST;
 	} else {
@@ -414,7 +415,7 @@ int ipath_error_qp(struct ipath_qp *qp, enum ib_wc_status err)
 		wc.wr_id = qp->r_wr_id;
 		wc.opcode = IB_WC_RECV;
 		wc.status = err;
-		ipath_cq_enter(to_icq(qp->ibqp.send_cq), &wc, 1);
+		ipath_cq_enter(to_icq(qp->ibqp.recv_cq), &wc, 1);
 	}
 	wc.status = IB_WC_WR_FLUSH_ERR;
 
@@ -534,7 +535,7 @@ int ipath_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	switch (new_state) {
 	case IB_QPS_RESET:
-		ipath_reset_qp(qp);
+		ipath_reset_qp(qp, ibqp->qp_type);
 		break;
 
 	case IB_QPS_ERR:
@@ -647,7 +648,7 @@ int ipath_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	attr->port_num = 1;
 	attr->timeout = qp->timeout;
 	attr->retry_cnt = qp->s_retry_cnt;
-	attr->rnr_retry = qp->s_rnr_retry;
+	attr->rnr_retry = qp->s_rnr_retry_cnt;
 	attr->alt_port_num = 0;
 	attr->alt_timeout = 0;
 
@@ -839,7 +840,7 @@ struct ib_qp *ipath_create_qp(struct ib_pd *ibpd,
 			goto bail_qp;
 		}
 		qp->ip = NULL;
-		ipath_reset_qp(qp);
+		ipath_reset_qp(qp, init_attr->qp_type);
 		break;
 
 	default:
diff --git a/drivers/infiniband/hw/ipath/ipath_rc.c b/drivers/infiniband/hw/ipath/ipath_rc.c
index 459e46e..40f3e37 100644
--- a/drivers/infiniband/hw/ipath/ipath_rc.c
+++ b/drivers/infiniband/hw/ipath/ipath_rc.c
@@ -1196,6 +1196,10 @@ static inline void ipath_rc_rcv_resp(struct ipath_ibdev *dev,
 			list_move_tail(&qp->timerwait,
 				       &dev->pending[dev->pending_index]);
 		spin_unlock(&dev->pending_lock);
+
+		if (opcode == OP(RDMA_READ_RESPONSE_MIDDLE))
+			qp->s_retry = qp->s_retry_cnt;
+
 		/*
 		 * Update the RDMA receive state but do the copy w/o
 		 * holding the locks and blocking interrupts.
diff --git a/drivers/infiniband/hw/ipath/ipath_registers.h b/drivers/infiniband/hw/ipath/ipath_registers.h
index 6d2a17f..92ad73a 100644
--- a/drivers/infiniband/hw/ipath/ipath_registers.h
+++ b/drivers/infiniband/hw/ipath/ipath_registers.h
@@ -185,7 +185,7 @@
 #define INFINIPATH_IBCC_LINKINITCMD_SLEEP 3
 #define INFINIPATH_IBCC_LINKINITCMD_SHIFT 16
 #define INFINIPATH_IBCC_LINKCMD_MASK 0x3ULL
-#define INFINIPATH_IBCC_LINKCMD_INIT 1	/* move to 0x11 */
+#define INFINIPATH_IBCC_LINKCMD_DOWN 1	/* move to 0x11 */
 #define INFINIPATH_IBCC_LINKCMD_ARMED 2	/* move to 0x21 */
 #define INFINIPATH_IBCC_LINKCMD_ACTIVE 3	/* move to 0x31 */
 #define INFINIPATH_IBCC_LINKCMD_SHIFT 18
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 52b1beb..2490b2d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -38,6 +38,7 @@
 #include <net/icmp.h>
 #include <linux/icmpv6.h>
 #include <linux/delay.h>
+#include <linux/vmalloc.h>
 
 #include "ipoib.h"
 
@@ -637,6 +638,7 @@ static inline int post_send(struct ipoib_dev_priv *priv,
 	priv->tx_sge[0].addr          = addr;
 	priv->tx_sge[0].length        = len;
 
+	priv->tx_wr.num_sge	= 1;
 	priv->tx_wr.wr_id	= wr_id | IPOIB_OP_CM;
 
 	return ib_post_send(tx->qp, &priv->tx_wr, &bad_wr);
@@ -1030,13 +1032,13 @@ static int ipoib_cm_tx_init(struct ipoib_cm_tx *p, u32 qpn,
 	struct ipoib_dev_priv *priv = netdev_priv(p->dev);
 	int ret;
 
-	p->tx_ring = kzalloc(ipoib_sendq_size * sizeof *p->tx_ring,
-				GFP_KERNEL);
+	p->tx_ring = vmalloc(ipoib_sendq_size * sizeof *p->tx_ring);
 	if (!p->tx_ring) {
 		ipoib_warn(priv, "failed to allocate tx ring\n");
 		ret = -ENOMEM;
 		goto err_tx;
 	}
+	memset(p->tx_ring, 0, ipoib_sendq_size * sizeof *p->tx_ring);
 
 	p->qp = ipoib_cm_create_tx_qp(p->dev, p);
 	if (IS_ERR(p->qp)) {
@@ -1077,6 +1079,7 @@ err_id:
 	ib_destroy_qp(p->qp);
 err_qp:
 	p->qp = NULL;
+	vfree(p->tx_ring);
 err_tx:
 	return ret;
 }
@@ -1127,7 +1130,7 @@ timeout:
 	if (p->qp)
 		ib_destroy_qp(p->qp);
 
-	kfree(p->tx_ring);
+	vfree(p->tx_ring);
 	kfree(p);
 }
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index f96477a..5728204 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -41,6 +41,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
+#include <linux/vmalloc.h>
 
 #include <linux/if_arp.h>	/* For ARPHRD_xxx */
 
@@ -887,13 +888,13 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 		goto out;
 	}
 
-	priv->tx_ring = kzalloc(ipoib_sendq_size * sizeof *priv->tx_ring,
-				GFP_KERNEL);
+	priv->tx_ring = vmalloc(ipoib_sendq_size * sizeof *priv->tx_ring);
 	if (!priv->tx_ring) {
 		printk(KERN_WARNING "%s: failed to allocate TX ring (%d entries)\n",
 		       ca->name, ipoib_sendq_size);
 		goto out_rx_ring_cleanup;
 	}
+	memset(priv->tx_ring, 0, ipoib_sendq_size * sizeof *priv->tx_ring);
 
 	/* priv->tx_head, tx_tail & tx_outstanding are already 0 */
 
@@ -903,7 +904,7 @@ int ipoib_dev_init(struct net_device *dev, struct ib_device *ca, int port)
 	return 0;
 
 out_tx_ring_cleanup:
-	kfree(priv->tx_ring);
+	vfree(priv->tx_ring);
 
 out_rx_ring_cleanup:
 	kfree(priv->rx_ring);
@@ -928,7 +929,7 @@ void ipoib_dev_cleanup(struct net_device *dev)
 	ipoib_ib_dev_cleanup(dev);
 
 	kfree(priv->rx_ring);
-	kfree(priv->tx_ring);
+	vfree(priv->tx_ring);
 
 	priv->rx_ring = NULL;
 	priv->tx_ring = NULL;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 2628339..31a53c5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -650,7 +650,7 @@ void ipoib_mcast_send(struct net_device *dev, void *mgid, struct sk_buff *skb)
 	 */
 	spin_lock(&priv->lock);
 
-	if (!test_bit(IPOIB_MCAST_STARTED, &priv->flags)	||
+	if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)		||
 	    !priv->broadcast					||
 	    !test_bit(IPOIB_MCAST_FLAG_ATTACHED, &priv->broadcast->flags)) {
 		++dev->stats.tx_dropped;
