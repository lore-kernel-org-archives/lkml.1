Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbXJBRmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbXJBRmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbXJBRl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:41:58 -0400
Received: from havoc.gtf.org ([69.61.125.42]:47888 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbXJBRlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:41:51 -0400
Date: Tue, 2 Oct 2007 13:41:50 -0400
From: Jeff Garzik <jeff@garzik.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] net driver updates
Message-ID: <20071002174150.GA29780@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[note #0: this is the same additional-push text I give to Linus]


Note:  The changes below are in the same linear history as the
previous push (on Sept 29) -- appended onto that history.  As such,
if you have already pulled that, you will only get the changes below.

If you have NOT pulled the Sept 29 changes, you will get both sets of
changes.


Please pull from the 'upstream' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git upstream

to receive the following changes:

Hans-Jürgen Koch (1):
      Fix a compile problem in macb.c

Jan-Bernd Themann (1):
      ehea: DLPAR memory add fix

Komuro (1):
      PCMCIA-NETDEV : add new id (axnet_cs, pcnet_cs)

Markus Brunner (1):
      smc911x irq sense request and MPR2 board support

Nobuhiro Iwamatsu (1):
      smc91x Hitachi Solution Engine (SuperH) Support

Scott Wood (9):
      fs_enet: Whitespace cleanup.
      fs_enet: Fix build breakage.
      fs_enet: Include linux/string.h from linux/fs_enet_pd.h
      fs_enet: mac-fcc: Eliminate __fcc-* macros.
      fs_enet: Align receive buffers.
      fs_enet: Be an of_platform device when CONFIG_PPC_CPM_NEW_BINDING is set.
      Generic bitbanged MDIO library
      fs_enet: Convert mii-bitbang to use the generic bitbang MDIO code.
      fs_enet: sparse fixes

 drivers/net/Kconfig                |    2 
 drivers/net/ehea/ehea.h            |    4 
 drivers/net/ehea/ehea_main.c       |  276 ++++++++++++++++++++--
 drivers/net/ehea/ehea_phyp.h       |    1 
 drivers/net/ehea/ehea_qmr.c        |   20 -
 drivers/net/ehea/ehea_qmr.h        |    4 
 drivers/net/fs_enet/Kconfig        |    1 
 drivers/net/fs_enet/fs_enet-main.c |  386 +++++++++++++++++++++++++------
 drivers/net/fs_enet/fs_enet.h      |   90 +------
 drivers/net/fs_enet/mac-fcc.c      |  180 +++++++++-----
 drivers/net/fs_enet/mac-fec.c      |   53 ++--
 drivers/net/fs_enet/mac-scc.c      |   90 ++++---
 drivers/net/fs_enet/mii-bitbang.c  |  448 +++++++++++++++++--------------------
 drivers/net/fs_enet/mii-fec.c      |  152 ++++++++++++
 drivers/net/macb.c                 |    4 
 drivers/net/pcmcia/axnet_cs.c      |    1 
 drivers/net/pcmcia/pcnet_cs.c      |    1 
 drivers/net/phy/Kconfig            |    9 
 drivers/net/phy/Makefile           |    1 
 drivers/net/phy/mdio-bitbang.c     |  187 +++++++++++++++
 drivers/net/smc911x.c              |    2 
 drivers/net/smc911x.h              |    6 
 drivers/net/smc91x.h               |    1 
 include/linux/fs_enet_pd.h         |    6 
 include/linux/mdio-bitbang.h       |   42 +++
 25 files changed, 1404 insertions(+), 563 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 45f6cf5..0e48b29 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -944,7 +944,7 @@ config SMC911X
 	tristate "SMSC LAN911[5678] support"
 	select CRC32
 	select MII
-	depends on ARCH_PXA
+	depends on ARCH_PXA || SUPERH
 	help
 	  This is a driver for SMSC's LAN911x series of Ethernet chipsets
 	  including the new LAN9115, LAN9116, LAN9117, and LAN9118.
diff --git a/drivers/net/ehea/ehea.h b/drivers/net/ehea/ehea.h
index c0cbd94..3022089 100644
--- a/drivers/net/ehea/ehea.h
+++ b/drivers/net/ehea/ehea.h
@@ -40,13 +40,13 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0074"
+#define DRV_VERSION	"EHEA_0077"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
 #define DLPAR_MEM_ADD      2
 #define DLPAR_MEM_REM      4
-#define EHEA_CAPABILITIES  (DLPAR_PORT_ADD_REM)
+#define EHEA_CAPABILITIES  (DLPAR_PORT_ADD_REM | DLPAR_MEM_ADD)
 
 #define EHEA_MSG_DEFAULT (NETIF_MSG_LINK | NETIF_MSG_TIMER \
 	| NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index 62d6c1e..5bc0a15 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -97,6 +97,7 @@ u64 ehea_driver_flags = 0;
 struct workqueue_struct *ehea_driver_wq;
 struct work_struct ehea_rereg_mr_task;
 
+struct semaphore dlpar_mem_lock;
 
 static int __devinit ehea_probe_adapter(struct ibmebus_dev *dev,
 					const struct of_device_id *id);
@@ -177,16 +178,24 @@ static void ehea_refill_rq1(struct ehea_port_res *pr, int index, int nr_of_wqes)
 	struct sk_buff **skb_arr_rq1 = pr->rq1_skba.arr;
 	struct net_device *dev = pr->port->netdev;
 	int max_index_mask = pr->rq1_skba.len - 1;
+	int fill_wqes = pr->rq1_skba.os_skbs + nr_of_wqes;
+	int adder = 0;
 	int i;
 
-	if (!nr_of_wqes)
+	pr->rq1_skba.os_skbs = 0;
+
+	if (unlikely(test_bit(__EHEA_STOP_XFER, &ehea_driver_flags))) {
+		pr->rq1_skba.index = index;
+		pr->rq1_skba.os_skbs = fill_wqes;
 		return;
+	}
 
-	for (i = 0; i < nr_of_wqes; i++) {
+	for (i = 0; i < fill_wqes; i++) {
 		if (!skb_arr_rq1[index]) {
 			skb_arr_rq1[index] = netdev_alloc_skb(dev,
 							      EHEA_L_PKT_SIZE);
 			if (!skb_arr_rq1[index]) {
+				pr->rq1_skba.os_skbs = fill_wqes - i;
 				ehea_error("%s: no mem for skb/%d wqes filled",
 					   dev->name, i);
 				break;
@@ -194,9 +203,14 @@ static void ehea_refill_rq1(struct ehea_port_res *pr, int index, int nr_of_wqes)
 		}
 		index--;
 		index &= max_index_mask;
+		adder++;
 	}
+
+	if (adder == 0)
+		return;
+
 	/* Ring doorbell */
-	ehea_update_rq1a(pr->qp, i);
+	ehea_update_rq1a(pr->qp, adder);
 }
 
 static int ehea_init_fill_rq1(struct ehea_port_res *pr, int nr_rq1a)
@@ -230,16 +244,21 @@ static int ehea_refill_rq_def(struct ehea_port_res *pr,
 	struct sk_buff **skb_arr = q_skba->arr;
 	struct ehea_rwqe *rwqe;
 	int i, index, max_index_mask, fill_wqes;
+	int adder = 0;
 	int ret = 0;
 
 	fill_wqes = q_skba->os_skbs + num_wqes;
+	q_skba->os_skbs = 0;
 
-	if (!fill_wqes)
+	if (unlikely(test_bit(__EHEA_STOP_XFER, &ehea_driver_flags))) {
+		q_skba->os_skbs = fill_wqes;
 		return ret;
+	}
 
 	index = q_skba->index;
 	max_index_mask = q_skba->len - 1;
 	for (i = 0; i < fill_wqes; i++) {
+		u64 tmp_addr;
 		struct sk_buff *skb = netdev_alloc_skb(dev, packet_size);
 		if (!skb) {
 			ehea_error("%s: no mem for skb/%d wqes filled",
@@ -251,30 +270,37 @@ static int ehea_refill_rq_def(struct ehea_port_res *pr,
 		skb_reserve(skb, NET_IP_ALIGN);
 
 		skb_arr[index] = skb;
+		tmp_addr = ehea_map_vaddr(skb->data);
+		if (tmp_addr == -1) {
+			dev_kfree_skb(skb);
+			q_skba->os_skbs = fill_wqes - i;
+			ret = 0;
+			break;
+		}
 
 		rwqe = ehea_get_next_rwqe(qp, rq_nr);
 		rwqe->wr_id = EHEA_BMASK_SET(EHEA_WR_ID_TYPE, wqe_type)
 			    | EHEA_BMASK_SET(EHEA_WR_ID_INDEX, index);
 		rwqe->sg_list[0].l_key = pr->recv_mr.lkey;
-		rwqe->sg_list[0].vaddr = ehea_map_vaddr(skb->data);
+		rwqe->sg_list[0].vaddr = tmp_addr;
 		rwqe->sg_list[0].len = packet_size;
 		rwqe->data_segments = 1;
 
 		index++;
 		index &= max_index_mask;
-
-		if (unlikely(test_bit(__EHEA_STOP_XFER, &ehea_driver_flags)))
-			goto out;
+		adder++;
 	}
 
 	q_skba->index = index;
+	if (adder == 0)
+		goto out;
 
 	/* Ring doorbell */
 	iosync();
 	if (rq_nr == 2)
-		ehea_update_rq2a(pr->qp, i);
+		ehea_update_rq2a(pr->qp, adder);
 	else
-		ehea_update_rq3a(pr->qp, i);
+		ehea_update_rq3a(pr->qp, adder);
 out:
 	return ret;
 }
@@ -1967,11 +1993,12 @@ static int ehea_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		ehea_dump(swqe, 512, "swqe");
 	}
 
-	if (unlikely(test_bit(__EHEA_STOP_XFER, &ehea_driver_flags)))
-		goto out;
+	if (unlikely(test_bit(__EHEA_STOP_XFER, &ehea_driver_flags))) {
+		netif_stop_queue(dev);
+		swqe->tx_control |= EHEA_SWQE_PURGE;
+	}
 
 	ehea_post_swqe(pr->qp, swqe);
-	pr->tx_packets++;
 
 	if (unlikely(atomic_read(&pr->swqe_avail) <= 1)) {
 		spin_lock_irqsave(&pr->netif_queue, flags);
@@ -1984,7 +2011,7 @@ static int ehea_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 	dev->trans_start = jiffies;
 	spin_unlock(&pr->xmit_lock);
-out:
+
 	return NETDEV_TX_OK;
 }
 
@@ -2376,6 +2403,192 @@ static int ehea_stop(struct net_device *dev)
 	return ret;
 }
 
+void ehea_purge_sq(struct ehea_qp *orig_qp)
+{
+	struct ehea_qp qp = *orig_qp;
+	struct ehea_qp_init_attr *init_attr = &qp.init_attr;
+	struct ehea_swqe *swqe;
+	int wqe_index;
+	int i;
+
+	for (i = 0; i < init_attr->act_nr_send_wqes; i++) {
+		swqe = ehea_get_swqe(&qp, &wqe_index);
+		swqe->tx_control |= EHEA_SWQE_PURGE;
+	}
+}
+
+int ehea_stop_qps(struct net_device *dev)
+{
+	struct ehea_port *port = netdev_priv(dev);
+	struct ehea_adapter *adapter = port->adapter;
+	struct hcp_modify_qp_cb0* cb0;
+	int ret = -EIO;
+	int dret;
+	int i;
+	u64 hret;
+	u64 dummy64 = 0;
+	u16 dummy16 = 0;
+
+	cb0 = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!cb0) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < (port->num_def_qps + port->num_add_tx_qps); i++) {
+		struct ehea_port_res *pr =  &port->port_res[i];
+		struct ehea_qp *qp = pr->qp;
+
+		/* Purge send queue */
+		ehea_purge_sq(qp);
+
+		/* Disable queue pair */
+		hret = ehea_h_query_ehea_qp(adapter->handle, 0, qp->fw_handle,
+					    EHEA_BMASK_SET(H_QPCB0_ALL, 0xFFFF),
+					    cb0);
+		if (hret != H_SUCCESS) {
+			ehea_error("query_ehea_qp failed (1)");
+			goto out;
+		}
+
+		cb0->qp_ctl_reg = (cb0->qp_ctl_reg & H_QP_CR_RES_STATE) << 8;
+		cb0->qp_ctl_reg &= ~H_QP_CR_ENABLED;
+
+		hret = ehea_h_modify_ehea_qp(adapter->handle, 0, qp->fw_handle,
+					     EHEA_BMASK_SET(H_QPCB0_QP_CTL_REG,
+							    1), cb0, &dummy64,
+					     &dummy64, &dummy16, &dummy16);
+		if (hret != H_SUCCESS) {
+			ehea_error("modify_ehea_qp failed (1)");
+			goto out;
+		}
+
+		hret = ehea_h_query_ehea_qp(adapter->handle, 0, qp->fw_handle,
+					    EHEA_BMASK_SET(H_QPCB0_ALL, 0xFFFF),
+					    cb0);
+		if (hret != H_SUCCESS) {
+			ehea_error("query_ehea_qp failed (2)");
+			goto out;
+		}
+
+		/* deregister shared memory regions */
+		dret = ehea_rem_smrs(pr);
+		if (dret) {
+			ehea_error("unreg shared memory region failed");
+			goto out;
+		}
+	}
+
+	ret = 0;
+out:
+	kfree(cb0);
+
+	return ret;
+}
+
+void ehea_update_rqs(struct ehea_qp *orig_qp, struct ehea_port_res * pr)
+{
+	struct ehea_qp qp = *orig_qp;
+	struct ehea_qp_init_attr *init_attr = &qp.init_attr;
+	struct ehea_rwqe *rwqe;
+	struct sk_buff **skba_rq2 = pr->rq2_skba.arr;
+	struct sk_buff **skba_rq3 = pr->rq3_skba.arr;
+	struct sk_buff *skb;
+	u32 lkey = pr->recv_mr.lkey;
+
+
+	int i;
+	int index;
+
+	for (i = 0; i < init_attr->act_nr_rwqes_rq2 + 1; i++) {
+		rwqe = ehea_get_next_rwqe(&qp, 2);
+		rwqe->sg_list[0].l_key = lkey;
+		index = EHEA_BMASK_GET(EHEA_WR_ID_INDEX, rwqe->wr_id);
+		skb = skba_rq2[index];
+		if (skb)
+			rwqe->sg_list[0].vaddr = ehea_map_vaddr(skb->data);
+	}
+
+	for (i = 0; i < init_attr->act_nr_rwqes_rq3 + 1; i++) {
+		rwqe = ehea_get_next_rwqe(&qp, 3);
+		rwqe->sg_list[0].l_key = lkey;
+		index = EHEA_BMASK_GET(EHEA_WR_ID_INDEX, rwqe->wr_id);
+		skb = skba_rq3[index];
+		if (skb)
+			rwqe->sg_list[0].vaddr = ehea_map_vaddr(skb->data);
+	}
+}
+
+int ehea_restart_qps(struct net_device *dev)
+{
+	struct ehea_port *port = netdev_priv(dev);
+	struct ehea_adapter *adapter = port->adapter;
+	int ret = 0;
+	int i;
+
+	struct hcp_modify_qp_cb0* cb0;
+	u64 hret;
+	u64 dummy64 = 0;
+	u16 dummy16 = 0;
+
+	cb0 = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!cb0) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < (port->num_def_qps + port->num_add_tx_qps); i++) {
+		struct ehea_port_res *pr =  &port->port_res[i];
+		struct ehea_qp *qp = pr->qp;
+
+		ret = ehea_gen_smrs(pr);
+		if (ret) {
+			ehea_error("creation of shared memory regions failed");
+			goto out;
+		}
+
+		ehea_update_rqs(qp, pr);
+
+		/* Enable queue pair */
+		hret = ehea_h_query_ehea_qp(adapter->handle, 0, qp->fw_handle,
+					    EHEA_BMASK_SET(H_QPCB0_ALL, 0xFFFF),
+					    cb0);
+		if (hret != H_SUCCESS) {
+			ehea_error("query_ehea_qp failed (1)");
+			goto out;
+		}
+
+		cb0->qp_ctl_reg = (cb0->qp_ctl_reg & H_QP_CR_RES_STATE) << 8;
+		cb0->qp_ctl_reg |= H_QP_CR_ENABLED;
+
+		hret = ehea_h_modify_ehea_qp(adapter->handle, 0, qp->fw_handle,
+					     EHEA_BMASK_SET(H_QPCB0_QP_CTL_REG,
+							    1), cb0, &dummy64,
+					     &dummy64, &dummy16, &dummy16);
+		if (hret != H_SUCCESS) {
+			ehea_error("modify_ehea_qp failed (1)");
+			goto out;
+		}
+
+		hret = ehea_h_query_ehea_qp(adapter->handle, 0, qp->fw_handle,
+					    EHEA_BMASK_SET(H_QPCB0_ALL, 0xFFFF),
+					    cb0);
+		if (hret != H_SUCCESS) {
+			ehea_error("query_ehea_qp failed (2)");
+			goto out;
+		}
+
+		/* refill entire queue */
+		ehea_refill_rq1(pr, pr->rq1_skba.index, 0);
+		ehea_refill_rq2(pr, 0);
+		ehea_refill_rq3(pr, 0);
+	}
+out:
+	kfree(cb0);
+
+	return ret;
+}
+
 static void ehea_reset_port(struct work_struct *work)
 {
 	int ret;
@@ -2395,6 +2608,8 @@ static void ehea_reset_port(struct work_struct *work)
 	if (ret)
 		goto out;
 
+	ehea_set_multicast_list(dev);
+
 	if (netif_msg_timer(port))
 		ehea_info("Device %s resetted successfully", dev->name);
 
@@ -2411,6 +2626,7 @@ static void ehea_rereg_mrs(struct work_struct *work)
 	int ret, i;
 	struct ehea_adapter *adapter;
 
+	down(&dlpar_mem_lock);
 	ehea_info("LPAR memory enlarged - re-initializing driver");
 
 	list_for_each_entry(adapter, &adapter_list, list)
@@ -2423,14 +2639,14 @@ static void ehea_rereg_mrs(struct work_struct *work)
 					struct net_device *dev = port->netdev;
 
 					if (dev->flags & IFF_UP) {
-						ehea_info("stopping %s",
-							  dev->name);
 						down(&port->port_lock);
 						netif_stop_queue(dev);
-
+						ret = ehea_stop_qps(dev);
+						if (ret) {
+							up(&port->port_lock);
+							goto out;
+						}
 						port_napi_disable(port);
-
-						ehea_down(dev);
 						up(&port->port_lock);
 					}
 				}
@@ -2446,10 +2662,11 @@ static void ehea_rereg_mrs(struct work_struct *work)
 		}
 
 	ehea_destroy_busmap();
-
 	ret = ehea_create_busmap();
-	if (ret)
+	if (ret) {
+		ehea_error("creating ehea busmap failed");
 		goto out;
+	}
 
 	clear_bit(__EHEA_STOP_XFER, &ehea_driver_flags);
 
@@ -2471,21 +2688,18 @@ static void ehea_rereg_mrs(struct work_struct *work)
 					struct net_device *dev = port->netdev;
 
 					if (dev->flags & IFF_UP) {
-						ehea_info("restarting %s",
-							  dev->name);
 						down(&port->port_lock);
-
-						ret = ehea_up(dev);
-						if (!ret) {
-							port_napi_enable(port);
+						port_napi_enable(port);
+						ret = ehea_restart_qps(dev);
+						if (!ret)
 							netif_wake_queue(dev);
-						}
-
 						up(&port->port_lock);
 					}
 				}
 			}
 		}
+       up(&dlpar_mem_lock);
+       ehea_info("re-initializing driver complete");
 out:
 	return;
 }
@@ -2494,7 +2708,8 @@ static void ehea_tx_watchdog(struct net_device *dev)
 {
 	struct ehea_port *port = netdev_priv(dev);
 
-	if (netif_carrier_ok(dev))
+	if (netif_carrier_ok(dev) &&
+	    !test_bit(__EHEA_STOP_XFER, &ehea_driver_flags))
 		queue_work(port->adapter->ehea_wq, &port->reset_task);
 }
 
@@ -3139,6 +3354,7 @@ int __init ehea_module_init(void)
 	ehea_driver_wq = create_workqueue("ehea_driver_wq");
 
 	INIT_WORK(&ehea_rereg_mr_task, ehea_rereg_mrs);
+	sema_init(&dlpar_mem_lock, 1);
 
 	ret = check_module_parm();
 	if (ret)
diff --git a/drivers/net/ehea/ehea_phyp.h b/drivers/net/ehea/ehea_phyp.h
index 89b6353..faa191d 100644
--- a/drivers/net/ehea/ehea_phyp.h
+++ b/drivers/net/ehea/ehea_phyp.h
@@ -126,6 +126,7 @@ struct hcp_modify_qp_cb0 {
 #define H_QP_CR_STATE_RDY2RCV	    0x0000030000000000ULL /*  Ready to recv */
 #define H_QP_CR_STATE_RDY2SND	    0x0000050000000000ULL /*  Ready to send */
 #define H_QP_CR_STATE_ERROR	    0x0000800000000000ULL /*  Error */
+#define H_QP_CR_RES_STATE 	    0x0000007F00000000ULL /* Resultant state */
 
 struct hcp_modify_qp_cb1 {
 	u32 qpn;		/* 00 */
diff --git a/drivers/net/ehea/ehea_qmr.c b/drivers/net/ehea/ehea_qmr.c
index c82e245..329a252 100644
--- a/drivers/net/ehea/ehea_qmr.c
+++ b/drivers/net/ehea/ehea_qmr.c
@@ -563,8 +563,7 @@ int ehea_destroy_qp(struct ehea_qp *qp)
 int ehea_create_busmap( void )
 {
 	u64 vaddr = EHEA_BUSMAP_START;
-	unsigned long abs_max_pfn = 0;
-	unsigned long sec_max_pfn;
+	unsigned long high_section_index = 0;
 	int i;
 
 	/*
@@ -574,14 +573,10 @@ int ehea_create_busmap( void )
 	ehea_bmap.valid_sections = 0;
 
 	for (i = 0; i < NR_MEM_SECTIONS; i++)
-		if (valid_section_nr(i)) {
-			sec_max_pfn = section_nr_to_pfn(i);
-			if (sec_max_pfn > abs_max_pfn)
-				abs_max_pfn = sec_max_pfn;
-			ehea_bmap.valid_sections++;
-		}
+		if (valid_section_nr(i))
+			high_section_index = i;
 
-	ehea_bmap.entries = abs_max_pfn / EHEA_PAGES_PER_SECTION + 1;
+	ehea_bmap.entries = high_section_index + 1;
 	ehea_bmap.vaddr = vmalloc(ehea_bmap.entries * sizeof(*ehea_bmap.vaddr));
 
 	if (!ehea_bmap.vaddr)
@@ -593,6 +588,7 @@ int ehea_create_busmap( void )
 		if (pfn_valid(pfn)) {
 			ehea_bmap.vaddr[i] = vaddr;
 			vaddr += EHEA_SECTSIZE;
+			ehea_bmap.valid_sections++;
 		} else
 			ehea_bmap.vaddr[i] = 0;
 	}
@@ -637,7 +633,7 @@ int ehea_reg_kernel_mr(struct ehea_adapter *adapter, struct ehea_mr *mr)
 
 	mr_len = ehea_bmap.valid_sections * EHEA_SECTSIZE;
 
-	pt =  kzalloc(EHEA_MAX_RPAGE * sizeof(u64), GFP_KERNEL);
+	pt =  kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!pt) {
 		ehea_error("no mem");
 		ret = -ENOMEM;
@@ -660,8 +656,8 @@ int ehea_reg_kernel_mr(struct ehea_adapter *adapter, struct ehea_mr *mr)
 			void *sectbase = __va(i << SECTION_SIZE_BITS);
 			unsigned long k = 0;
 
-			for (j = 0; j < (PAGES_PER_SECTION / EHEA_MAX_RPAGE);
-			      j++) {
+			for (j = 0; j < (EHEA_PAGES_PER_SECTION /
+					 EHEA_MAX_RPAGE); j++) {
 
 				for (m = 0; m < EHEA_MAX_RPAGE; m++) {
 					pg = sectbase + ((k++) * EHEA_PAGESIZE);
diff --git a/drivers/net/ehea/ehea_qmr.h b/drivers/net/ehea/ehea_qmr.h
index b71f845..562de0e 100644
--- a/drivers/net/ehea/ehea_qmr.h
+++ b/drivers/net/ehea/ehea_qmr.h
@@ -39,7 +39,7 @@
 #define EHEA_PAGESHIFT         12
 #define EHEA_PAGESIZE          (1UL << EHEA_PAGESHIFT)
 #define EHEA_SECTSIZE          (1UL << 24)
-#define EHEA_PAGES_PER_SECTION (EHEA_SECTSIZE >> PAGE_SHIFT)
+#define EHEA_PAGES_PER_SECTION (EHEA_SECTSIZE >> EHEA_PAGESHIFT)
 
 #if (1UL << SECTION_SIZE_BITS) < EHEA_SECTSIZE
 #error eHEA module can't work if kernel sectionsize < ehea sectionsize
@@ -145,7 +145,7 @@ struct ehea_rwqe {
 #define EHEA_CQE_VLAN_TAG_XTRACT   0x0400
 
 #define EHEA_CQE_TYPE_RQ           0x60
-#define EHEA_CQE_STAT_ERR_MASK     0x721F
+#define EHEA_CQE_STAT_ERR_MASK     0x720F
 #define EHEA_CQE_STAT_FAT_ERR_MASK 0x1F
 #define EHEA_CQE_STAT_ERR_TCP      0x4000
 #define EHEA_CQE_STAT_ERR_IP       0x2000
diff --git a/drivers/net/fs_enet/Kconfig b/drivers/net/fs_enet/Kconfig
index e27ee21..2765e49 100644
--- a/drivers/net/fs_enet/Kconfig
+++ b/drivers/net/fs_enet/Kconfig
@@ -11,6 +11,7 @@ config FS_ENET_HAS_SCC
 config FS_ENET_HAS_FCC
 	bool "Chip has an FCC usable for ethernet"
 	depends on FS_ENET && CPM2
+	select MDIO_BITBANG
 	default y
 
 config FS_ENET_HAS_FEC
diff --git a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
index ebdcf3f..04c6fae 100644
--- a/drivers/net/fs_enet/fs_enet-main.c
+++ b/drivers/net/fs_enet/fs_enet-main.c
@@ -42,19 +42,25 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+#include <asm/of_platform.h>
+#endif
+
 #include "fs_enet.h"
 
 /*************************************************/
 
+#ifndef CONFIG_PPC_CPM_NEW_BINDING
 static char version[] __devinitdata =
     DRV_MODULE_NAME ".c:v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")" "\n";
+#endif
 
 MODULE_AUTHOR("Pantelis Antoniou <panto@intracom.gr>");
 MODULE_DESCRIPTION("Freescale Ethernet Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_MODULE_VERSION);
 
-int fs_enet_debug = -1;		/* -1 == use FS_ENET_DEF_MSG_ENABLE as value */
+static int fs_enet_debug = -1; /* -1 == use FS_ENET_DEF_MSG_ENABLE as value */
 module_param(fs_enet_debug, int, 0);
 MODULE_PARM_DESC(fs_enet_debug,
 		 "Freescale bitmapped debugging message enable value");
@@ -70,13 +76,21 @@ static void fs_set_multicast_list(struct net_device *dev)
 	(*fep->ops->set_multicast_list)(dev);
 }
 
+static void skb_align(struct sk_buff *skb, int align)
+{
+	int off = ((unsigned long)skb->data) & (align - 1);
+
+	if (off)
+		skb_reserve(skb, align - off);
+}
+
 /* NAPI receive function */
 static int fs_enet_rx_napi(struct napi_struct *napi, int budget)
 {
-	struct fs_enet_private *fep = container_of(napi, struct fec_enet_private, napi);
-	struct net_device *dev = fep->dev;
+	struct fs_enet_private *fep = container_of(napi, struct fs_enet_private, napi);
+	struct net_device *dev = to_net_dev(fep->dev);
 	const struct fs_platform_info *fpi = fep->fpi;
-	cbd_t *bdp;
+	cbd_t __iomem *bdp;
 	struct sk_buff *skb, *skbn, *skbt;
 	int received = 0;
 	u16 pkt_len, sc;
@@ -159,9 +173,13 @@ static int fs_enet_rx_napi(struct napi_struct *napi, int budget)
 					skb = skbn;
 					skbn = skbt;
 				}
-			} else
+			} else {
 				skbn = dev_alloc_skb(ENET_RX_FRSIZE);
 
+				if (skbn)
+					skb_align(skbn, ENET_RX_ALIGN);
+			}
+
 			if (skbn != NULL) {
 				skb_put(skb, pkt_len);	/* Make room */
 				skb->protocol = eth_type_trans(skb, dev);
@@ -212,7 +230,7 @@ static int fs_enet_rx_non_napi(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
 	const struct fs_platform_info *fpi = fep->fpi;
-	cbd_t *bdp;
+	cbd_t __iomem *bdp;
 	struct sk_buff *skb, *skbn, *skbt;
 	int received = 0;
 	u16 pkt_len, sc;
@@ -290,9 +308,13 @@ static int fs_enet_rx_non_napi(struct net_device *dev)
 					skb = skbn;
 					skbn = skbt;
 				}
-			} else
+			} else {
 				skbn = dev_alloc_skb(ENET_RX_FRSIZE);
 
+				if (skbn)
+					skb_align(skbn, ENET_RX_ALIGN);
+			}
+
 			if (skbn != NULL) {
 				skb_put(skb, pkt_len);	/* Make room */
 				skb->protocol = eth_type_trans(skb, dev);
@@ -333,7 +355,7 @@ static int fs_enet_rx_non_napi(struct net_device *dev)
 static void fs_enet_tx(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	cbd_t *bdp;
+	cbd_t __iomem *bdp;
 	struct sk_buff *skb;
 	int dirtyidx, do_wake, do_restart;
 	u16 sc;
@@ -343,7 +365,6 @@ static void fs_enet_tx(struct net_device *dev)
 
 	do_wake = do_restart = 0;
 	while (((sc = CBDR_SC(bdp)) & BD_ENET_TX_READY) == 0) {
-
 		dirtyidx = bdp - fep->tx_bd_base;
 
 		if (fep->tx_free == fep->tx_ring)
@@ -444,7 +465,6 @@ fs_enet_interrupt(int irq, void *dev_id)
 
 	nr = 0;
 	while ((int_events = (*fep->ops->get_int_events)(dev)) != 0) {
-
 		nr++;
 
 		int_clr_events = int_events;
@@ -483,7 +503,7 @@ fs_enet_interrupt(int irq, void *dev_id)
 void fs_init_bds(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	cbd_t *bdp;
+	cbd_t __iomem *bdp;
 	struct sk_buff *skb;
 	int i;
 
@@ -504,6 +524,7 @@ void fs_init_bds(struct net_device *dev)
 			       dev->name);
 			break;
 		}
+		skb_align(skb, ENET_RX_ALIGN);
 		fep->rx_skbuff[i] = skb;
 		CBDW_BUFADDR(bdp,
 			dma_map_single(fep->dev, skb->data,
@@ -536,7 +557,7 @@ void fs_cleanup_bds(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
 	struct sk_buff *skb;
-	cbd_t *bdp;
+	cbd_t __iomem *bdp;
 	int i;
 
 	/*
@@ -577,7 +598,7 @@ void fs_cleanup_bds(struct net_device *dev)
 static int fs_enet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	cbd_t *bdp;
+	cbd_t __iomem *bdp;
 	int curidx;
 	u16 sc;
 	unsigned long flags;
@@ -700,45 +721,43 @@ static void fs_timeout(struct net_device *dev)
  *-----------------------------------------------------------------------------*/
 static void generic_adjust_link(struct  net_device *dev)
 {
-       struct fs_enet_private *fep = netdev_priv(dev);
-       struct phy_device *phydev = fep->phydev;
-       int new_state = 0;
-
-       if (phydev->link) {
-
-               /* adjust to duplex mode */
-               if (phydev->duplex != fep->oldduplex){
-                       new_state = 1;
-                       fep->oldduplex = phydev->duplex;
-               }
-
-               if (phydev->speed != fep->oldspeed) {
-                       new_state = 1;
-                       fep->oldspeed = phydev->speed;
-               }
-
-               if (!fep->oldlink) {
-                       new_state = 1;
-                       fep->oldlink = 1;
-                       netif_schedule(dev);
-                       netif_carrier_on(dev);
-                       netif_start_queue(dev);
-               }
-
-               if (new_state)
-                       fep->ops->restart(dev);
-
-       } else if (fep->oldlink) {
-               new_state = 1;
-               fep->oldlink = 0;
-               fep->oldspeed = 0;
-               fep->oldduplex = -1;
-               netif_carrier_off(dev);
-               netif_stop_queue(dev);
-       }
-
-       if (new_state && netif_msg_link(fep))
-               phy_print_status(phydev);
+	struct fs_enet_private *fep = netdev_priv(dev);
+	struct phy_device *phydev = fep->phydev;
+	int new_state = 0;
+
+	if (phydev->link) {
+		/* adjust to duplex mode */
+		if (phydev->duplex != fep->oldduplex) {
+			new_state = 1;
+			fep->oldduplex = phydev->duplex;
+		}
+
+		if (phydev->speed != fep->oldspeed) {
+			new_state = 1;
+			fep->oldspeed = phydev->speed;
+		}
+
+		if (!fep->oldlink) {
+			new_state = 1;
+			fep->oldlink = 1;
+			netif_schedule(dev);
+			netif_carrier_on(dev);
+			netif_start_queue(dev);
+		}
+
+		if (new_state)
+			fep->ops->restart(dev);
+	} else if (fep->oldlink) {
+		new_state = 1;
+		fep->oldlink = 0;
+		fep->oldspeed = 0;
+		fep->oldduplex = -1;
+		netif_carrier_off(dev);
+		netif_stop_queue(dev);
+	}
+
+	if (new_state && netif_msg_link(fep))
+		phy_print_status(phydev);
 }
 
 
@@ -782,7 +801,6 @@ static int fs_init_phy(struct net_device *dev)
 	return 0;
 }
 
-
 static int fs_enet_open(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
@@ -936,6 +954,7 @@ static int fs_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 extern int fs_mii_connect(struct net_device *dev);
 extern void fs_mii_disconnect(struct net_device *dev);
 
+#ifndef CONFIG_PPC_CPM_NEW_BINDING
 static struct net_device *fs_init_instance(struct device *dev,
 		struct fs_platform_info *fpi)
 {
@@ -971,7 +990,7 @@ static struct net_device *fs_init_instance(struct device *dev,
 #endif
 
 #ifdef CONFIG_FS_ENET_HAS_SCC
-	if (fs_get_scc_index(fpi->fs_no) >=0 )
+	if (fs_get_scc_index(fpi->fs_no) >=0)
 		fep->ops = &fs_scc_ops;
 #endif
 
@@ -1066,9 +1085,8 @@ static struct net_device *fs_init_instance(struct device *dev,
 
 	return ndev;
 
-      err:
+err:
 	if (ndev != NULL) {
-
 		if (registered)
 			unregister_netdev(ndev);
 
@@ -1103,7 +1121,7 @@ static int fs_cleanup_instance(struct net_device *ndev)
 	unregister_netdev(ndev);
 
 	dma_free_coherent(fep->dev, (fpi->tx_ring + fpi->rx_ring) * sizeof(cbd_t),
-			  fep->ring_base, fep->ring_mem_addr);
+			  (void __force *)fep->ring_base, fep->ring_mem_addr);
 
 	/* reset it */
 	(*fep->ops->cleanup_data)(ndev);
@@ -1118,43 +1136,259 @@ static int fs_cleanup_instance(struct net_device *ndev)
 
 	return 0;
 }
+#endif
 
 /**************************************************************************************/
 
 /* handy pointer to the immap */
-void *fs_enet_immap = NULL;
+void __iomem *fs_enet_immap = NULL;
 
 static int setup_immap(void)
 {
-	phys_addr_t paddr = 0;
-	unsigned long size = 0;
-
 #ifdef CONFIG_CPM1
-	paddr = IMAP_ADDR;
-	size = 0x10000;	/* map 64K */
-#endif
-
-#ifdef CONFIG_CPM2
-	paddr = CPM_MAP_ADDR;
-	size = 0x40000;	/* map 256 K */
+	fs_enet_immap = ioremap(IMAP_ADDR, 0x4000);
+	WARN_ON(!fs_enet_immap);
+#elif defined(CONFIG_CPM2)
+	fs_enet_immap = cpm2_immr;
 #endif
-	fs_enet_immap = ioremap(paddr, size);
-	if (fs_enet_immap == NULL)
-		return -EBADF;	/* XXX ahem; maybe just BUG_ON? */
 
 	return 0;
 }
 
 static void cleanup_immap(void)
 {
-	if (fs_enet_immap != NULL) {
-		iounmap(fs_enet_immap);
-		fs_enet_immap = NULL;
-	}
+#if defined(CONFIG_CPM1)
+	iounmap(fs_enet_immap);
+#endif
 }
 
 /**************************************************************************************/
 
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+static int __devinit find_phy(struct device_node *np,
+                              struct fs_platform_info *fpi)
+{
+	struct device_node *phynode, *mdionode;
+	struct resource res;
+	int ret = 0, len;
+
+	const u32 *data = of_get_property(np, "phy-handle", &len);
+	if (!data || len != 4)
+		return -EINVAL;
+
+	phynode = of_find_node_by_phandle(*data);
+	if (!phynode)
+		return -EINVAL;
+
+	mdionode = of_get_parent(phynode);
+	if (!mdionode)
+		goto out_put_phy;
+
+	ret = of_address_to_resource(mdionode, 0, &res);
+	if (ret)
+		goto out_put_mdio;
+
+	data = of_get_property(phynode, "reg", &len);
+	if (!data || len != 4)
+		goto out_put_mdio;
+
+	snprintf(fpi->bus_id, 16, PHY_ID_FMT, res.start, *data);
+
+out_put_mdio:
+	of_node_put(mdionode);
+out_put_phy:
+	of_node_put(phynode);
+	return ret;
+}
+
+#ifdef CONFIG_FS_ENET_HAS_FEC
+#define IS_FEC(match) ((match)->data == &fs_fec_ops)
+#else
+#define IS_FEC(match) 0
+#endif
+
+static int __devinit fs_enet_probe(struct of_device *ofdev,
+                                   const struct of_device_id *match)
+{
+	struct net_device *ndev;
+	struct fs_enet_private *fep;
+	struct fs_platform_info *fpi;
+	const u32 *data;
+	const u8 *mac_addr;
+	int privsize, len, ret = -ENODEV;
+
+	fpi = kzalloc(sizeof(*fpi), GFP_KERNEL);
+	if (!fpi)
+		return -ENOMEM;
+
+	if (!IS_FEC(match)) {
+		data = of_get_property(ofdev->node, "fsl,cpm-command", &len);
+		if (!data || len != 4)
+			goto out_free_fpi;
+
+		fpi->cp_command = *data;
+	}
+
+	fpi->rx_ring = 32;
+	fpi->tx_ring = 32;
+	fpi->rx_copybreak = 240;
+	fpi->use_napi = 0;
+	fpi->napi_weight = 17;
+
+	ret = find_phy(ofdev->node, fpi);
+	if (ret)
+		goto out_free_fpi;
+
+	privsize = sizeof(*fep) +
+	           sizeof(struct sk_buff **) *
+	           (fpi->rx_ring + fpi->tx_ring);
+
+	ndev = alloc_etherdev(privsize);
+	if (!ndev) {
+		ret = -ENOMEM;
+		goto out_free_fpi;
+	}
+
+	SET_MODULE_OWNER(ndev);
+	dev_set_drvdata(&ofdev->dev, ndev);
+
+	fep = netdev_priv(ndev);
+	fep->dev = &ofdev->dev;
+	fep->fpi = fpi;
+	fep->ops = match->data;
+
+	ret = fep->ops->setup_data(ndev);
+	if (ret)
+		goto out_free_dev;
+
+	fep->rx_skbuff = (struct sk_buff **)&fep[1];
+	fep->tx_skbuff = fep->rx_skbuff + fpi->rx_ring;
+
+	spin_lock_init(&fep->lock);
+	spin_lock_init(&fep->tx_lock);
+
+	mac_addr = of_get_mac_address(ofdev->node);
+	if (mac_addr)
+		memcpy(ndev->dev_addr, mac_addr, 6);
+
+	ret = fep->ops->allocate_bd(ndev);
+	if (ret)
+		goto out_cleanup_data;
+
+	fep->rx_bd_base = fep->ring_base;
+	fep->tx_bd_base = fep->rx_bd_base + fpi->rx_ring;
+
+	fep->tx_ring = fpi->tx_ring;
+	fep->rx_ring = fpi->rx_ring;
+
+	ndev->open = fs_enet_open;
+	ndev->hard_start_xmit = fs_enet_start_xmit;
+	ndev->tx_timeout = fs_timeout;
+	ndev->watchdog_timeo = 2 * HZ;
+	ndev->stop = fs_enet_close;
+	ndev->get_stats = fs_enet_get_stats;
+	ndev->set_multicast_list = fs_set_multicast_list;
+	if (fpi->use_napi) {
+		ndev->poll = fs_enet_rx_napi;
+		ndev->weight = fpi->napi_weight;
+	}
+	ndev->ethtool_ops = &fs_ethtool_ops;
+	ndev->do_ioctl = fs_ioctl;
+
+	init_timer(&fep->phy_timer_list);
+
+	netif_carrier_off(ndev);
+
+	ret = register_netdev(ndev);
+	if (ret)
+		goto out_free_bd;
+
+	printk(KERN_INFO "%s: fs_enet: %02x:%02x:%02x:%02x:%02x:%02x\n",
+	       ndev->name,
+	       ndev->dev_addr[0], ndev->dev_addr[1], ndev->dev_addr[2],
+	       ndev->dev_addr[3], ndev->dev_addr[4], ndev->dev_addr[5]);
+
+	return 0;
+
+out_free_bd:
+	fep->ops->free_bd(ndev);
+out_cleanup_data:
+	fep->ops->cleanup_data(ndev);
+out_free_dev:
+	free_netdev(ndev);
+	dev_set_drvdata(&ofdev->dev, NULL);
+out_free_fpi:
+	kfree(fpi);
+	return ret;
+}
+
+static int fs_enet_remove(struct of_device *ofdev)
+{
+	struct net_device *ndev = dev_get_drvdata(&ofdev->dev);
+	struct fs_enet_private *fep = netdev_priv(ndev);
+
+	unregister_netdev(ndev);
+
+	fep->ops->free_bd(ndev);
+	fep->ops->cleanup_data(ndev);
+	dev_set_drvdata(fep->dev, NULL);
+
+	free_netdev(ndev);
+	return 0;
+}
+
+static struct of_device_id fs_enet_match[] = {
+#ifdef CONFIG_FS_ENET_HAS_SCC
+	{
+		.compatible = "fsl,cpm1-scc-enet",
+		.data = (void *)&fs_scc_ops,
+	},
+#endif
+#ifdef CONFIG_FS_ENET_HAS_FCC
+	{
+		.compatible = "fsl,cpm2-fcc-enet",
+		.data = (void *)&fs_fcc_ops,
+	},
+#endif
+#ifdef CONFIG_FS_ENET_HAS_FEC
+	{
+		.compatible = "fsl,pq1-fec-enet",
+		.data = (void *)&fs_fec_ops,
+	},
+#endif
+	{}
+};
+
+static struct of_platform_driver fs_enet_driver = {
+	.name	= "fs_enet",
+	.match_table = fs_enet_match,
+	.probe = fs_enet_probe,
+	.remove = fs_enet_remove,
+};
+
+static int __init fs_init(void)
+{
+	int r = setup_immap();
+	if (r != 0)
+		return r;
+
+	r = of_register_platform_driver(&fs_enet_driver);
+	if (r != 0)
+		goto out;
+
+	return 0;
+
+out:
+	cleanup_immap();
+	return r;
+}
+
+static void __exit fs_cleanup(void)
+{
+	of_unregister_platform_driver(&fs_enet_driver);
+	cleanup_immap();
+}
+#else
 static int __devinit fs_enet_probe(struct device *dev)
 {
 	struct net_device *ndev;
@@ -1259,7 +1493,6 @@ static int __init fs_init(void)
 err:
 	cleanup_immap();
 	return r;
-
 }
 
 static void __exit fs_cleanup(void)
@@ -1269,6 +1502,7 @@ static void __exit fs_cleanup(void)
 	driver_unregister(&fs_enet_scc_driver);
 	cleanup_immap();
 }
+#endif
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void fs_enet_netpoll(struct net_device *dev)
diff --git a/drivers/net/fs_enet/fs_enet.h b/drivers/net/fs_enet/fs_enet.h
index 46d0606..baf6477 100644
--- a/drivers/net/fs_enet/fs_enet.h
+++ b/drivers/net/fs_enet/fs_enet.h
@@ -15,8 +15,8 @@
 #include <asm/commproc.h>
 
 struct fec_info {
-        fec_t*  fecp;
-	u32     mii_speed;
+	fec_t __iomem *fecp;
+	u32 mii_speed;
 };
 #endif
 
@@ -24,19 +24,6 @@ struct fec_info {
 #include <asm/cpm2.h>
 #endif
 
-/* This is used to operate with pins.
-  Note that the actual port size may
-    be different; cpm(s) handle it OK  */
-struct bb_info {
-	u8 mdio_dat_msk;
-	u8 mdio_dir_msk;
-	u8 *mdio_dir;
-	u8 *mdio_dat;
-	u8 mdc_msk;
-	u8 *mdc_dat;
-	int delay;
-};
-
 /* hw driver ops */
 struct fs_ops {
 	int (*setup_data)(struct net_device *dev);
@@ -82,61 +69,26 @@ struct phy_info {
 /* Must be a multiple of 32 (to cover both FEC & FCC) */
 #define PKT_MAXBLR_SIZE		((PKT_MAXBUF_SIZE + 31) & ~31)
 /* This is needed so that invalidate_xxx wont invalidate too much */
-#define ENET_RX_FRSIZE		L1_CACHE_ALIGN(PKT_MAXBUF_SIZE)
-
-struct fs_enet_mii_bus {
-	struct list_head list;
-	spinlock_t mii_lock;
-	const struct fs_mii_bus_info *bus_info;
-	int refs;
-	u32 usage_map;
-
-	int (*mii_read)(struct fs_enet_mii_bus *bus,
-			int phy_id, int location);
-
-	void (*mii_write)(struct fs_enet_mii_bus *bus,
-			int phy_id, int location, int value);
-
-	union {
-		struct {
-			unsigned int mii_speed;
-			void *fecp;
-		} fec;
-
-		struct {
-			/* note that the actual port size may */
-			/* be different; cpm(s) handle it OK  */
-			u8 mdio_msk;
-			u8 *mdio_dir;
-			u8 *mdio_dat;
-			u8 mdc_msk;
-			u8 *mdc_dir;
-			u8 *mdc_dat;
-		} bitbang;
-
-		struct {
-			u16 lpa;
-		} fixed;
-	};
-};
+#define ENET_RX_ALIGN  16
+#define ENET_RX_FRSIZE L1_CACHE_ALIGN(PKT_MAXBUF_SIZE + ENET_RX_ALIGN - 1)
 
 struct fs_enet_private {
 	struct napi_struct napi;
 	struct device *dev;	/* pointer back to the device (must be initialized first) */
 	spinlock_t lock;	/* during all ops except TX pckt processing */
 	spinlock_t tx_lock;	/* during fs_start_xmit and fs_tx         */
-	const struct fs_platform_info *fpi;
+	struct fs_platform_info *fpi;
 	const struct fs_ops *ops;
 	int rx_ring, tx_ring;
 	dma_addr_t ring_mem_addr;
-	void *ring_base;
+	void __iomem *ring_base;
 	struct sk_buff **rx_skbuff;
 	struct sk_buff **tx_skbuff;
-	cbd_t *rx_bd_base;	/* Address of Rx and Tx buffers.    */
-	cbd_t *tx_bd_base;
-	cbd_t *dirty_tx;	/* ring entries to be free()ed.     */
-	cbd_t *cur_rx;
-	cbd_t *cur_tx;
+	cbd_t __iomem *rx_bd_base;	/* Address of Rx and Tx buffers.    */
+	cbd_t __iomem *tx_bd_base;
+	cbd_t __iomem *dirty_tx;	/* ring entries to be free()ed.     */
+	cbd_t __iomem *cur_rx;
+	cbd_t __iomem *cur_tx;
 	int tx_free;
 	struct net_device_stats stats;
 	struct timer_list phy_timer_list;
@@ -144,7 +96,6 @@ struct fs_enet_private {
 	u32 msg_enable;
 	struct mii_if_info mii_if;
 	unsigned int last_mii_status;
-	struct fs_enet_mii_bus *mii_bus;
 	int interrupt;
 
 	struct phy_device *phydev;
@@ -162,23 +113,23 @@ struct fs_enet_private {
 	union {
 		struct {
 			int idx;		/* FEC1 = 0, FEC2 = 1  */
-			void *fecp;		/* hw registers        */
+			void __iomem *fecp;	/* hw registers        */
 			u32 hthi, htlo;		/* state for multicast */
 		} fec;
 
 		struct {
 			int idx;		/* FCC1-3 = 0-2	       */
-			void *fccp;		/* hw registers	       */
-			void *ep;		/* parameter ram       */
-			void *fcccp;		/* hw registers cont.  */
-			void *mem;		/* FCC DPRAM */
+			void __iomem *fccp;	/* hw registers	       */
+			void __iomem *ep;	/* parameter ram       */
+			void __iomem *fcccp;	/* hw registers cont.  */
+			void __iomem *mem;	/* FCC DPRAM */
 			u32 gaddrh, gaddrl;	/* group address       */
 		} fcc;
 
 		struct {
 			int idx;		/* FEC1 = 0, FEC2 = 1  */
-			void *sccp;		/* hw registers        */
-			void *ep;		/* parameter ram       */
+			void __iomem *sccp;	/* hw registers        */
+			void __iomem *ep;	/* parameter ram       */
 			u32 hthi, htlo;		/* state for multicast */
 		} scc;
 
@@ -186,9 +137,10 @@ struct fs_enet_private {
 };
 
 /***************************************************************************/
+#ifndef CONFIG_PPC_CPM_NEW_BINDING
 int fs_enet_mdio_bb_init(void);
-int fs_mii_fixed_init(struct fs_enet_mii_bus *bus);
 int fs_enet_mdio_fec_init(void);
+#endif
 
 void fs_init_bds(struct net_device *dev);
 void fs_cleanup_bds(struct net_device *dev);
@@ -248,7 +200,7 @@ extern const struct fs_ops fs_scc_ops;
 /*******************************************************************/
 
 /* handy pointer to the immap */
-extern void *fs_enet_immap;
+extern void __iomem *fs_enet_immap;
 
 /*******************************************************************/
 
diff --git a/drivers/net/fs_enet/mac-fcc.c b/drivers/net/fs_enet/mac-fcc.c
index 6407151..da4efbc 100644
--- a/drivers/net/fs_enet/mac-fcc.c
+++ b/drivers/net/fs_enet/mac-fcc.c
@@ -42,34 +42,29 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+#include <asm/of_device.h>
+#endif
+
 #include "fs_enet.h"
 
 /*************************************************/
 
 /* FCC access macros */
 
-#define __fcc_out32(addr, x)	out_be32((unsigned *)addr, x)
-#define __fcc_out16(addr, x)	out_be16((unsigned short *)addr, x)
-#define __fcc_out8(addr, x)	out_8((unsigned char *)addr, x)
-#define __fcc_in32(addr)	in_be32((unsigned *)addr)
-#define __fcc_in16(addr)	in_be16((unsigned short *)addr)
-#define __fcc_in8(addr)		in_8((unsigned char *)addr)
-
-/* parameter space */
-
 /* write, read, set bits, clear bits */
-#define W32(_p, _m, _v)	__fcc_out32(&(_p)->_m, (_v))
-#define R32(_p, _m)	__fcc_in32(&(_p)->_m)
+#define W32(_p, _m, _v)	out_be32(&(_p)->_m, (_v))
+#define R32(_p, _m)	in_be32(&(_p)->_m)
 #define S32(_p, _m, _v)	W32(_p, _m, R32(_p, _m) | (_v))
 #define C32(_p, _m, _v)	W32(_p, _m, R32(_p, _m) & ~(_v))
 
-#define W16(_p, _m, _v)	__fcc_out16(&(_p)->_m, (_v))
-#define R16(_p, _m)	__fcc_in16(&(_p)->_m)
+#define W16(_p, _m, _v)	out_be16(&(_p)->_m, (_v))
+#define R16(_p, _m)	in_be16(&(_p)->_m)
 #define S16(_p, _m, _v)	W16(_p, _m, R16(_p, _m) | (_v))
 #define C16(_p, _m, _v)	W16(_p, _m, R16(_p, _m) & ~(_v))
 
-#define W8(_p, _m, _v)	__fcc_out8(&(_p)->_m, (_v))
-#define R8(_p, _m)	__fcc_in8(&(_p)->_m)
+#define W8(_p, _m, _v)	out_8(&(_p)->_m, (_v))
+#define R8(_p, _m)	in_8(&(_p)->_m)
 #define S8(_p, _m, _v)	W8(_p, _m, R8(_p, _m) | (_v))
 #define C8(_p, _m, _v)	W8(_p, _m, R8(_p, _m) & ~(_v))
 
@@ -83,34 +78,62 @@
 
 #define MAX_CR_CMD_LOOPS	10000
 
-static inline int fcc_cr_cmd(struct fs_enet_private *fep, u32 mcn, u32 op)
+static inline int fcc_cr_cmd(struct fs_enet_private *fep, u32 op)
 {
 	const struct fs_platform_info *fpi = fep->fpi;
-
-	cpm2_map_t *immap = fs_enet_immap;
-	cpm_cpm2_t *cpmp = &immap->im_cpm;
-	u32 v;
 	int i;
 
-	/* Currently I don't know what feature call will look like. But
-	   I guess there'd be something like do_cpm_cmd() which will require page & sblock */
-	v = mk_cr_cmd(fpi->cp_page, fpi->cp_block, mcn, op);
-	W32(cpmp, cp_cpcr, v | CPM_CR_FLG);
+	W32(cpmp, cp_cpcr, fpi->cp_command | op | CPM_CR_FLG);
 	for (i = 0; i < MAX_CR_CMD_LOOPS; i++)
 		if ((R32(cpmp, cp_cpcr) & CPM_CR_FLG) == 0)
-			break;
+			return 0;
 
-	if (i >= MAX_CR_CMD_LOOPS) {
-		printk(KERN_ERR "%s(): Not able to issue CPM command\n",
-		       __FUNCTION__);
-		return 1;
-	}
-
-	return 0;
+	printk(KERN_ERR "%s(): Not able to issue CPM command\n",
+	       __FUNCTION__);
+	return 1;
 }
 
 static int do_pd_setup(struct fs_enet_private *fep)
 {
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+	struct of_device *ofdev = to_of_device(fep->dev);
+	struct fs_platform_info *fpi = fep->fpi;
+	int ret = -EINVAL;
+
+	fep->interrupt = of_irq_to_resource(ofdev->node, 0, NULL);
+	if (fep->interrupt == NO_IRQ)
+		goto out;
+
+	fep->fcc.fccp = of_iomap(ofdev->node, 0);
+	if (!fep->fcc.fccp)
+		goto out;
+
+	fep->fcc.ep = of_iomap(ofdev->node, 1);
+	if (!fep->fcc.ep)
+		goto out_fccp;
+
+	fep->fcc.fcccp = of_iomap(ofdev->node, 2);
+	if (!fep->fcc.fcccp)
+		goto out_ep;
+
+	fep->fcc.mem = (void __iomem *)cpm2_immr;
+	fpi->dpram_offset = cpm_dpalloc(128, 8);
+	if (IS_ERR_VALUE(fpi->dpram_offset)) {
+		ret = fpi->dpram_offset;
+		goto out_fcccp;
+	}
+
+	return 0;
+
+out_fcccp:
+	iounmap(fep->fcc.fcccp);
+out_ep:
+	iounmap(fep->fcc.ep);
+out_fccp:
+	iounmap(fep->fcc.fccp);
+out:
+	return ret;
+#else
 	struct platform_device *pdev = to_platform_device(fep->dev);
 	struct resource *r;
 
@@ -121,33 +144,33 @@ static int do_pd_setup(struct fs_enet_private *fep)
 
 	/* Attach the memory for the FCC Parameter RAM */
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "fcc_pram");
-	fep->fcc.ep = (void *)ioremap(r->start, r->end - r->start + 1);
+	fep->fcc.ep = ioremap(r->start, r->end - r->start + 1);
 	if (fep->fcc.ep == NULL)
 		return -EINVAL;
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "fcc_regs");
-	fep->fcc.fccp = (void *)ioremap(r->start, r->end - r->start + 1);
+	fep->fcc.fccp = ioremap(r->start, r->end - r->start + 1);
 	if (fep->fcc.fccp == NULL)
 		return -EINVAL;
 
 	if (fep->fpi->fcc_regs_c) {
-
-		fep->fcc.fcccp = (void *)fep->fpi->fcc_regs_c;
+		fep->fcc.fcccp = (void __iomem *)fep->fpi->fcc_regs_c;
 	} else {
 		r = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 				"fcc_regs_c");
-		fep->fcc.fcccp = (void *)ioremap(r->start,
+		fep->fcc.fcccp = ioremap(r->start,
 				r->end - r->start + 1);
 	}
 
 	if (fep->fcc.fcccp == NULL)
 		return -EINVAL;
 
-	fep->fcc.mem = (void *)fep->fpi->mem_offset;
+	fep->fcc.mem = (void __iomem *)fep->fpi->mem_offset;
 	if (fep->fcc.mem == NULL)
 		return -EINVAL;
 
 	return 0;
+#endif
 }
 
 #define FCC_NAPI_RX_EVENT_MSK	(FCC_ENET_RXF | FCC_ENET_RXB)
@@ -158,11 +181,17 @@ static int do_pd_setup(struct fs_enet_private *fep)
 static int setup_data(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	const struct fs_platform_info *fpi = fep->fpi;
+#ifndef CONFIG_PPC_CPM_NEW_BINDING
+	struct fs_platform_info *fpi = fep->fpi;
+
+	fpi->cp_command = (fpi->cp_page << 26) |
+	                  (fpi->cp_block << 21) |
+	                  (12 << 6);
 
 	fep->fcc.idx = fs_get_fcc_index(fpi->fs_no);
 	if ((unsigned int)fep->fcc.idx >= 3)	/* max 3 FCCs */
 		return -EINVAL;
+#endif
 
 	if (do_pd_setup(fep) != 0)
 		return -EINVAL;
@@ -180,7 +209,7 @@ static int allocate_bd(struct net_device *dev)
 	struct fs_enet_private *fep = netdev_priv(dev);
 	const struct fs_platform_info *fpi = fep->fpi;
 
-	fep->ring_base = dma_alloc_coherent(fep->dev,
+	fep->ring_base = (void __iomem __force *)dma_alloc_coherent(fep->dev,
 					    (fpi->tx_ring + fpi->rx_ring) *
 					    sizeof(cbd_t), &fep->ring_mem_addr,
 					    GFP_KERNEL);
@@ -198,7 +227,7 @@ static void free_bd(struct net_device *dev)
 	if (fep->ring_base)
 		dma_free_coherent(fep->dev,
 			(fpi->tx_ring + fpi->rx_ring) * sizeof(cbd_t),
-			fep->ring_base, fep->ring_mem_addr);
+			(void __force *)fep->ring_base, fep->ring_mem_addr);
 }
 
 static void cleanup_data(struct net_device *dev)
@@ -209,7 +238,7 @@ static void cleanup_data(struct net_device *dev)
 static void set_promiscuous_mode(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fcc_t *fccp = fep->fcc.fccp;
+	fcc_t __iomem *fccp = fep->fcc.fccp;
 
 	S32(fccp, fcc_fpsmr, FCC_PSMR_PRO);
 }
@@ -217,7 +246,7 @@ static void set_promiscuous_mode(struct net_device *dev)
 static void set_multicast_start(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fcc_enet_t *ep = fep->fcc.ep;
+	fcc_enet_t __iomem *ep = fep->fcc.ep;
 
 	W32(ep, fen_gaddrh, 0);
 	W32(ep, fen_gaddrl, 0);
@@ -226,7 +255,7 @@ static void set_multicast_start(struct net_device *dev)
 static void set_multicast_one(struct net_device *dev, const u8 *mac)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fcc_enet_t *ep = fep->fcc.ep;
+	fcc_enet_t __iomem *ep = fep->fcc.ep;
 	u16 taddrh, taddrm, taddrl;
 
 	taddrh = ((u16)mac[5] << 8) | mac[4];
@@ -236,14 +265,14 @@ static void set_multicast_one(struct net_device *dev, const u8 *mac)
 	W16(ep, fen_taddrh, taddrh);
 	W16(ep, fen_taddrm, taddrm);
 	W16(ep, fen_taddrl, taddrl);
-	fcc_cr_cmd(fep, 0x0C, CPM_CR_SET_GADDR);
+	fcc_cr_cmd(fep, CPM_CR_SET_GADDR);
 }
 
 static void set_multicast_finish(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fcc_t *fccp = fep->fcc.fccp;
-	fcc_enet_t *ep = fep->fcc.ep;
+	fcc_t __iomem *fccp = fep->fcc.fccp;
+	fcc_enet_t __iomem *ep = fep->fcc.ep;
 
 	/* clear promiscuous always */
 	C32(fccp, fcc_fpsmr, FCC_PSMR_PRO);
@@ -278,12 +307,14 @@ static void restart(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
 	const struct fs_platform_info *fpi = fep->fpi;
-	fcc_t *fccp = fep->fcc.fccp;
-	fcc_c_t *fcccp = fep->fcc.fcccp;
-	fcc_enet_t *ep = fep->fcc.ep;
+	fcc_t __iomem *fccp = fep->fcc.fccp;
+	fcc_c_t __iomem *fcccp = fep->fcc.fcccp;
+	fcc_enet_t __iomem *ep = fep->fcc.ep;
 	dma_addr_t rx_bd_base_phys, tx_bd_base_phys;
 	u16 paddrh, paddrm, paddrl;
+#ifndef CONFIG_PPC_CPM_NEW_BINDING
 	u16 mem_addr;
+#endif
 	const unsigned char *mac;
 	int i;
 
@@ -291,7 +322,7 @@ static void restart(struct net_device *dev)
 
 	/* clear everything (slow & steady does it) */
 	for (i = 0; i < sizeof(*ep); i++)
-		__fcc_out8((char *)ep + i, 0);
+		out_8((u8 __iomem *)ep + i, 0);
 
 	/* get physical address */
 	rx_bd_base_phys = fep->ring_mem_addr;
@@ -315,14 +346,22 @@ static void restart(struct net_device *dev)
 	 * this area.
 	 */
 
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+	W16(ep, fen_genfcc.fcc_riptr, fpi->dpram_offset);
+	W16(ep, fen_genfcc.fcc_tiptr, fpi->dpram_offset + 32);
+
+	W16(ep, fen_padptr, fpi->dpram_offset + 64);
+#else
 	mem_addr = (u32) fep->fcc.mem;	/* de-fixup dpram offset */
 
 	W16(ep, fen_genfcc.fcc_riptr, (mem_addr & 0xffff));
 	W16(ep, fen_genfcc.fcc_tiptr, ((mem_addr + 32) & 0xffff));
+
 	W16(ep, fen_padptr, mem_addr + 64);
+#endif
 
 	/* fill with special symbol...  */
-	memset(fep->fcc.mem + fpi->dpram_offset + 64, 0x88, 32);
+	memset_io(fep->fcc.mem + fpi->dpram_offset + 64, 0x88, 32);
 
 	W32(ep, fen_genfcc.fcc_rbptr, 0);
 	W32(ep, fen_genfcc.fcc_tbptr, 0);
@@ -407,7 +446,7 @@ static void restart(struct net_device *dev)
 			S8(fcccp, fcc_gfemr, 0x20);
 	}
 
-	fcc_cr_cmd(fep, 0x0c, CPM_CR_INIT_TRX);
+	fcc_cr_cmd(fep, CPM_CR_INIT_TRX);
 
 	/* clear events */
 	W16(fccp, fcc_fcce, 0xffff);
@@ -438,7 +477,7 @@ static void restart(struct net_device *dev)
 static void stop(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fcc_t *fccp = fep->fcc.fccp;
+	fcc_t __iomem *fccp = fep->fcc.fccp;
 
 	/* stop ethernet */
 	C32(fccp, fcc_gfmr, FCC_GFMR_ENR | FCC_GFMR_ENT);
@@ -465,7 +504,7 @@ static void post_free_irq(struct net_device *dev, int irq)
 static void napi_clear_rx_event(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fcc_t *fccp = fep->fcc.fccp;
+	fcc_t __iomem *fccp = fep->fcc.fccp;
 
 	W16(fccp, fcc_fcce, FCC_NAPI_RX_EVENT_MSK);
 }
@@ -473,7 +512,7 @@ static void napi_clear_rx_event(struct net_device *dev)
 static void napi_enable_rx(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fcc_t *fccp = fep->fcc.fccp;
+	fcc_t __iomem *fccp = fep->fcc.fccp;
 
 	S16(fccp, fcc_fccm, FCC_NAPI_RX_EVENT_MSK);
 }
@@ -481,7 +520,7 @@ static void napi_enable_rx(struct net_device *dev)
 static void napi_disable_rx(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fcc_t *fccp = fep->fcc.fccp;
+	fcc_t __iomem *fccp = fep->fcc.fccp;
 
 	C16(fccp, fcc_fccm, FCC_NAPI_RX_EVENT_MSK);
 }
@@ -494,15 +533,15 @@ static void rx_bd_done(struct net_device *dev)
 static void tx_kickstart(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fcc_t *fccp = fep->fcc.fccp;
+	fcc_t __iomem *fccp = fep->fcc.fccp;
 
-	S32(fccp, fcc_ftodr, 0x80);
+	S16(fccp, fcc_ftodr, 0x8000);
 }
 
 static u32 get_int_events(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fcc_t *fccp = fep->fcc.fccp;
+	fcc_t __iomem *fccp = fep->fcc.fccp;
 
 	return (u32)R16(fccp, fcc_fcce);
 }
@@ -510,7 +549,7 @@ static u32 get_int_events(struct net_device *dev)
 static void clear_int_events(struct net_device *dev, u32 int_events)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fcc_t *fccp = fep->fcc.fccp;
+	fcc_t __iomem *fccp = fep->fcc.fccp;
 
 	W16(fccp, fcc_fcce, int_events & 0xffff);
 }
@@ -521,27 +560,26 @@ static void ev_error(struct net_device *dev, u32 int_events)
 	       ": %s FS_ENET ERROR(s) 0x%x\n", dev->name, int_events);
 }
 
-int get_regs(struct net_device *dev, void *p, int *sizep)
+static int get_regs(struct net_device *dev, void *p, int *sizep)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
 
-	if (*sizep < sizeof(fcc_t) + sizeof(fcc_c_t) + sizeof(fcc_enet_t))
+	if (*sizep < sizeof(fcc_t) + sizeof(fcc_enet_t) + 1)
 		return -EINVAL;
 
 	memcpy_fromio(p, fep->fcc.fccp, sizeof(fcc_t));
 	p = (char *)p + sizeof(fcc_t);
 
-	memcpy_fromio(p, fep->fcc.fcccp, sizeof(fcc_c_t));
-	p = (char *)p + sizeof(fcc_c_t);
-
 	memcpy_fromio(p, fep->fcc.ep, sizeof(fcc_enet_t));
+	p = (char *)p + sizeof(fcc_enet_t);
 
+	memcpy_fromio(p, fep->fcc.fcccp, 1);
 	return 0;
 }
 
-int get_regs_len(struct net_device *dev)
+static int get_regs_len(struct net_device *dev)
 {
-	return sizeof(fcc_t) + sizeof(fcc_c_t) + sizeof(fcc_enet_t);
+	return sizeof(fcc_t) + sizeof(fcc_enet_t) + 1;
 }
 
 /* Some transmit errors cause the transmitter to shut
@@ -552,16 +590,16 @@ int get_regs_len(struct net_device *dev)
  * CPM37, we must disable and then re-enable the transmitter
  * following a Late Collision, Underrun, or Retry Limit error.
  */
-void tx_restart(struct net_device *dev)
+static void tx_restart(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fcc_t *fccp = fep->fcc.fccp;
+	fcc_t __iomem *fccp = fep->fcc.fccp;
 
 	C32(fccp, fcc_gfmr, FCC_GFMR_ENT);
 	udelay(10);
 	S32(fccp, fcc_gfmr, FCC_GFMR_ENT);
 
-	fcc_cr_cmd(fep, 0x0C, CPM_CR_RESTART_TX);
+	fcc_cr_cmd(fep, CPM_CR_RESTART_TX);
 }
 
 /*************************************************************************/
diff --git a/drivers/net/fs_enet/mac-fec.c b/drivers/net/fs_enet/mac-fec.c
index cbdc17b..c1fee48 100644
--- a/drivers/net/fs_enet/mac-fec.c
+++ b/drivers/net/fs_enet/mac-fec.c
@@ -43,6 +43,10 @@
 #include <asm/commproc.h>
 #endif
 
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+#include <asm/of_device.h>
+#endif
+
 #include "fs_enet.h"
 #include "fec.h"
 
@@ -79,7 +83,7 @@
  */
 #define FEC_RESET_DELAY		50
 
-static int whack_reset(fec_t * fecp)
+static int whack_reset(fec_t __iomem *fecp)
 {
 	int i;
 
@@ -95,6 +99,19 @@ static int whack_reset(fec_t * fecp)
 
 static int do_pd_setup(struct fs_enet_private *fep)
 {
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+	struct of_device *ofdev = to_of_device(fep->dev);
+
+	fep->interrupt = of_irq_to_resource(ofdev->node, 0, NULL);
+	if (fep->interrupt == NO_IRQ)
+		return -EINVAL;
+
+	fep->fec.fecp = of_iomap(ofdev->node, 0);
+	if (!fep->fcc.fccp)
+		return -EINVAL;
+
+	return 0;
+#else
 	struct platform_device *pdev = to_platform_device(fep->dev);
 	struct resource	*r;
 
@@ -110,7 +127,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
 		return -EINVAL;
 
 	return 0;
-
+#endif
 }
 
 #define FEC_NAPI_RX_EVENT_MSK	(FEC_ENET_RXF | FEC_ENET_RXB)
@@ -142,7 +159,7 @@ static int allocate_bd(struct net_device *dev)
 	struct fs_enet_private *fep = netdev_priv(dev);
 	const struct fs_platform_info *fpi = fep->fpi;
 
-	fep->ring_base = dma_alloc_coherent(fep->dev,
+	fep->ring_base = (void __force __iomem *)dma_alloc_coherent(fep->dev,
 					    (fpi->tx_ring + fpi->rx_ring) *
 					    sizeof(cbd_t), &fep->ring_mem_addr,
 					    GFP_KERNEL);
@@ -160,7 +177,7 @@ static void free_bd(struct net_device *dev)
 	if(fep->ring_base)
 		dma_free_coherent(fep->dev, (fpi->tx_ring + fpi->rx_ring)
 					* sizeof(cbd_t),
-					fep->ring_base,
+					(void __force *)fep->ring_base,
 					fep->ring_mem_addr);
 }
 
@@ -172,7 +189,7 @@ static void cleanup_data(struct net_device *dev)
 static void set_promiscuous_mode(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fec_t *fecp = fep->fec.fecp;
+	fec_t __iomem *fecp = fep->fec.fecp;
 
 	FS(fecp, r_cntrl, FEC_RCNTRL_PROM);
 }
@@ -220,7 +237,7 @@ static void set_multicast_one(struct net_device *dev, const u8 *mac)
 static void set_multicast_finish(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fec_t *fecp = fep->fec.fecp;
+	fec_t __iomem *fecp = fep->fec.fecp;
 
 	/* if all multi or too many multicasts; just enable all */
 	if ((dev->flags & IFF_ALLMULTI) != 0 ||
@@ -254,7 +271,7 @@ static void restart(struct net_device *dev)
 	u32 cptr;
 #endif
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fec_t *fecp = fep->fec.fecp;
+	fec_t __iomem *fecp = fep->fec.fecp;
 	const struct fs_platform_info *fpi = fep->fpi;
 	dma_addr_t rx_bd_base_phys, tx_bd_base_phys;
 	int r;
@@ -382,7 +399,7 @@ static void stop(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
 	const struct fs_platform_info *fpi = fep->fpi;
-	fec_t *fecp = fep->fec.fecp;
+	fec_t __iomem *fecp = fep->fec.fecp;
 
 	struct fec_info* feci= fep->phydev->bus->priv;
 
@@ -444,7 +461,7 @@ static void post_free_irq(struct net_device *dev, int irq)
 static void napi_clear_rx_event(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fec_t *fecp = fep->fec.fecp;
+	fec_t __iomem *fecp = fep->fec.fecp;
 
 	FW(fecp, ievent, FEC_NAPI_RX_EVENT_MSK);
 }
@@ -452,7 +469,7 @@ static void napi_clear_rx_event(struct net_device *dev)
 static void napi_enable_rx(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fec_t *fecp = fep->fec.fecp;
+	fec_t __iomem *fecp = fep->fec.fecp;
 
 	FS(fecp, imask, FEC_NAPI_RX_EVENT_MSK);
 }
@@ -460,7 +477,7 @@ static void napi_enable_rx(struct net_device *dev)
 static void napi_disable_rx(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fec_t *fecp = fep->fec.fecp;
+	fec_t __iomem *fecp = fep->fec.fecp;
 
 	FC(fecp, imask, FEC_NAPI_RX_EVENT_MSK);
 }
@@ -468,7 +485,7 @@ static void napi_disable_rx(struct net_device *dev)
 static void rx_bd_done(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fec_t *fecp = fep->fec.fecp;
+	fec_t __iomem *fecp = fep->fec.fecp;
 
 	FW(fecp, r_des_active, 0x01000000);
 }
@@ -476,7 +493,7 @@ static void rx_bd_done(struct net_device *dev)
 static void tx_kickstart(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fec_t *fecp = fep->fec.fecp;
+	fec_t __iomem *fecp = fep->fec.fecp;
 
 	FW(fecp, x_des_active, 0x01000000);
 }
@@ -484,7 +501,7 @@ static void tx_kickstart(struct net_device *dev)
 static u32 get_int_events(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fec_t *fecp = fep->fec.fecp;
+	fec_t __iomem *fecp = fep->fec.fecp;
 
 	return FR(fecp, ievent) & FR(fecp, imask);
 }
@@ -492,7 +509,7 @@ static u32 get_int_events(struct net_device *dev)
 static void clear_int_events(struct net_device *dev, u32 int_events)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	fec_t *fecp = fep->fec.fecp;
+	fec_t __iomem *fecp = fep->fec.fecp;
 
 	FW(fecp, ievent, int_events);
 }
@@ -503,7 +520,7 @@ static void ev_error(struct net_device *dev, u32 int_events)
 	       ": %s FEC ERROR(s) 0x%x\n", dev->name, int_events);
 }
 
-int get_regs(struct net_device *dev, void *p, int *sizep)
+static int get_regs(struct net_device *dev, void *p, int *sizep)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
 
@@ -515,12 +532,12 @@ int get_regs(struct net_device *dev, void *p, int *sizep)
 	return 0;
 }
 
-int get_regs_len(struct net_device *dev)
+static int get_regs_len(struct net_device *dev)
 {
 	return sizeof(fec_t);
 }
 
-void tx_restart(struct net_device *dev)
+static void tx_restart(struct net_device *dev)
 {
 	/* nothing */
 }
diff --git a/drivers/net/fs_enet/mac-scc.c b/drivers/net/fs_enet/mac-scc.c
index 6f32674..03134f4 100644
--- a/drivers/net/fs_enet/mac-scc.c
+++ b/drivers/net/fs_enet/mac-scc.c
@@ -43,6 +43,10 @@
 #include <asm/commproc.h>
 #endif
 
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+#include <asm/of_platform.h>
+#endif
+
 #include "fs_enet.h"
 
 /*************************************************/
@@ -89,27 +93,38 @@
 
 static inline int scc_cr_cmd(struct fs_enet_private *fep, u32 op)
 {
-	cpm8xx_t *cpmp = &((immap_t *)fs_enet_immap)->im_cpm;
-	u32 v, ch;
-	int i = 0;
+	const struct fs_platform_info *fpi = fep->fpi;
+	int i;
 
-	ch = fep->scc.idx << 2;
-	v = mk_cr_cmd(ch, op);
-	W16(cpmp, cp_cpcr, v | CPM_CR_FLG);
+	W16(cpmp, cp_cpcr, fpi->cp_command | CPM_CR_FLG | (op << 8));
 	for (i = 0; i < MAX_CR_CMD_LOOPS; i++)
 		if ((R16(cpmp, cp_cpcr) & CPM_CR_FLG) == 0)
-			break;
+			return 0;
 
-	if (i >= MAX_CR_CMD_LOOPS) {
-		printk(KERN_ERR "%s(): Not able to issue CPM command\n",
-			__FUNCTION__);
-		return 1;
-	}
-	return 0;
+	printk(KERN_ERR "%s(): Not able to issue CPM command\n",
+		__FUNCTION__);
+	return 1;
 }
 
 static int do_pd_setup(struct fs_enet_private *fep)
 {
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+	struct of_device *ofdev = to_of_device(fep->dev);
+
+	fep->interrupt = of_irq_to_resource(ofdev->node, 0, NULL);
+	if (fep->interrupt == NO_IRQ)
+		return -EINVAL;
+
+	fep->scc.sccp = of_iomap(ofdev->node, 0);
+	if (!fep->scc.sccp)
+		return -EINVAL;
+
+	fep->scc.ep = of_iomap(ofdev->node, 1);
+	if (!fep->scc.ep) {
+		iounmap(fep->scc.sccp);
+		return -EINVAL;
+	}
+#else
 	struct platform_device *pdev = to_platform_device(fep->dev);
 	struct resource *r;
 
@@ -129,6 +144,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
 
 	if (fep->scc.ep == NULL)
 		return -EINVAL;
+#endif
 
 	return 0;
 }
@@ -141,12 +157,17 @@ static int do_pd_setup(struct fs_enet_private *fep)
 static int setup_data(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	const struct fs_platform_info *fpi = fep->fpi;
+
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+	struct fs_platform_info *fpi = fep->fpi;
 
 	fep->scc.idx = fs_get_scc_index(fpi->fs_no);
-	if ((unsigned int)fep->fcc.idx > 4)	/* max 4 SCCs */
+	if ((unsigned int)fep->fcc.idx >= 4) /* max 4 SCCs */
 		return -EINVAL;
 
+	fpi->cp_command = fep->fcc.idx << 6;
+#endif
+
 	do_pd_setup(fep);
 
 	fep->scc.hthi = 0;
@@ -154,7 +175,7 @@ static int setup_data(struct net_device *dev)
 
 	fep->ev_napi_rx = SCC_NAPI_RX_EVENT_MSK;
 	fep->ev_rx = SCC_RX_EVENT;
-	fep->ev_tx = SCC_TX_EVENT;
+	fep->ev_tx = SCC_TX_EVENT | SCCE_ENET_TXE;
 	fep->ev_err = SCC_ERR_EVENT_MSK;
 
 	return 0;
@@ -170,7 +191,8 @@ static int allocate_bd(struct net_device *dev)
 	if (IS_ERR_VALUE(fep->ring_mem_addr))
 		return -ENOMEM;
 
-	fep->ring_base = cpm_dpram_addr(fep->ring_mem_addr);
+	fep->ring_base = (void __iomem __force*)
+		cpm_dpram_addr(fep->ring_mem_addr);
 
 	return 0;
 }
@@ -191,7 +213,7 @@ static void cleanup_data(struct net_device *dev)
 static void set_promiscuous_mode(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	scc_t *sccp = fep->scc.sccp;
+	scc_t __iomem *sccp = fep->scc.sccp;
 
 	S16(sccp, scc_psmr, SCC_PSMR_PRO);
 }
@@ -199,7 +221,7 @@ static void set_promiscuous_mode(struct net_device *dev)
 static void set_multicast_start(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	scc_enet_t *ep = fep->scc.ep;
+	scc_enet_t __iomem *ep = fep->scc.ep;
 
 	W16(ep, sen_gaddr1, 0);
 	W16(ep, sen_gaddr2, 0);
@@ -210,7 +232,7 @@ static void set_multicast_start(struct net_device *dev)
 static void set_multicast_one(struct net_device *dev, const u8 * mac)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	scc_enet_t *ep = fep->scc.ep;
+	scc_enet_t __iomem *ep = fep->scc.ep;
 	u16 taddrh, taddrm, taddrl;
 
 	taddrh = ((u16) mac[5] << 8) | mac[4];
@@ -226,8 +248,8 @@ static void set_multicast_one(struct net_device *dev, const u8 * mac)
 static void set_multicast_finish(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	scc_t *sccp = fep->scc.sccp;
-	scc_enet_t *ep = fep->scc.ep;
+	scc_t __iomem *sccp = fep->scc.sccp;
+	scc_enet_t __iomem *ep = fep->scc.ep;
 
 	/* clear promiscuous always */
 	C16(sccp, scc_psmr, SCC_PSMR_PRO);
@@ -264,8 +286,8 @@ static void set_multicast_list(struct net_device *dev)
 static void restart(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	scc_t *sccp = fep->scc.sccp;
-	scc_enet_t *ep = fep->scc.ep;
+	scc_t __iomem *sccp = fep->scc.sccp;
+	scc_enet_t __iomem *ep = fep->scc.ep;
 	const struct fs_platform_info *fpi = fep->fpi;
 	u16 paddrh, paddrm, paddrl;
 	const unsigned char *mac;
@@ -275,7 +297,7 @@ static void restart(struct net_device *dev)
 
 	/* clear everything (slow & steady does it) */
 	for (i = 0; i < sizeof(*ep); i++)
-		__fs_out8((char *)ep + i, 0);
+		__fs_out8((u8 __iomem *)ep + i, 0);
 
 	/* point to bds */
 	W16(ep, sen_genscc.scc_rbase, fep->ring_mem_addr);
@@ -376,7 +398,7 @@ static void restart(struct net_device *dev)
 static void stop(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	scc_t *sccp = fep->scc.sccp;
+	scc_t __iomem *sccp = fep->scc.sccp;
 	int i;
 
 	for (i = 0; (R16(sccp, scc_sccm) == 0) && i < SCC_RESET_DELAY; i++)
@@ -420,7 +442,7 @@ static void post_free_irq(struct net_device *dev, int irq)
 static void napi_clear_rx_event(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	scc_t *sccp = fep->scc.sccp;
+	scc_t __iomem *sccp = fep->scc.sccp;
 
 	W16(sccp, scc_scce, SCC_NAPI_RX_EVENT_MSK);
 }
@@ -428,7 +450,7 @@ static void napi_clear_rx_event(struct net_device *dev)
 static void napi_enable_rx(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	scc_t *sccp = fep->scc.sccp;
+	scc_t __iomem *sccp = fep->scc.sccp;
 
 	S16(sccp, scc_sccm, SCC_NAPI_RX_EVENT_MSK);
 }
@@ -436,7 +458,7 @@ static void napi_enable_rx(struct net_device *dev)
 static void napi_disable_rx(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	scc_t *sccp = fep->scc.sccp;
+	scc_t __iomem *sccp = fep->scc.sccp;
 
 	C16(sccp, scc_sccm, SCC_NAPI_RX_EVENT_MSK);
 }
@@ -454,7 +476,7 @@ static void tx_kickstart(struct net_device *dev)
 static u32 get_int_events(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	scc_t *sccp = fep->scc.sccp;
+	scc_t __iomem *sccp = fep->scc.sccp;
 
 	return (u32) R16(sccp, scc_scce);
 }
@@ -462,7 +484,7 @@ static u32 get_int_events(struct net_device *dev)
 static void clear_int_events(struct net_device *dev, u32 int_events)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
-	scc_t *sccp = fep->scc.sccp;
+	scc_t __iomem *sccp = fep->scc.sccp;
 
 	W16(sccp, scc_scce, int_events & 0xffff);
 }
@@ -477,20 +499,20 @@ static int get_regs(struct net_device *dev, void *p, int *sizep)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
 
-	if (*sizep < sizeof(scc_t) + sizeof(scc_enet_t))
+	if (*sizep < sizeof(scc_t) + sizeof(scc_enet_t __iomem *))
 		return -EINVAL;
 
 	memcpy_fromio(p, fep->scc.sccp, sizeof(scc_t));
 	p = (char *)p + sizeof(scc_t);
 
-	memcpy_fromio(p, fep->scc.ep, sizeof(scc_enet_t));
+	memcpy_fromio(p, fep->scc.ep, sizeof(scc_enet_t __iomem *));
 
 	return 0;
 }
 
 static int get_regs_len(struct net_device *dev)
 {
-	return sizeof(scc_t) + sizeof(scc_enet_t);
+	return sizeof(scc_t) + sizeof(scc_enet_t __iomem *);
 }
 
 static void tx_restart(struct net_device *dev)
diff --git a/drivers/net/fs_enet/mii-bitbang.c b/drivers/net/fs_enet/mii-bitbang.c
index 1a41ea6..b8e4a73 100644
--- a/drivers/net/fs_enet/mii-bitbang.c
+++ b/drivers/net/fs_enet/mii-bitbang.c
@@ -12,303 +12,277 @@
  * kind, whether express or implied.
  */
 
-
 #include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/ptrace.h>
-#include <linux/errno.h>
 #include <linux/ioport.h>
 #include <linux/slab.h>
-#include <linux/interrupt.h>
 #include <linux/init.h>
-#include <linux/delay.h>
+#include <linux/interrupt.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/skbuff.h>
-#include <linux/spinlock.h>
 #include <linux/mii.h>
-#include <linux/ethtool.h>
-#include <linux/bitops.h>
 #include <linux/platform_device.h>
+#include <linux/mdio-bitbang.h>
 
-#include <asm/pgtable.h>
-#include <asm/irq.h>
-#include <asm/uaccess.h>
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+#include <linux/of_platform.h>
+#endif
 
 #include "fs_enet.h"
 
-static int bitbang_prep_bit(u8 **datp, u8 *mskp,
-		struct fs_mii_bit *mii_bit)
-{
-	void *dat;
-	int adv;
-	u8 msk;
-
-	dat = (void*) mii_bit->offset;
-
-	adv = mii_bit->bit >> 3;
-	dat = (char *)dat + adv;
-
-	msk = 1 << (7 - (mii_bit->bit & 7));
-
-	*datp = dat;
-	*mskp = msk;
-
-	return 0;
-}
+struct bb_info {
+	struct mdiobb_ctrl ctrl;
+	__be32 __iomem *dir;
+	__be32 __iomem *dat;
+	u32 mdio_msk;
+	u32 mdc_msk;
+};
 
-static inline void bb_set(u8 *p, u8 m)
+/* FIXME: If any other users of GPIO crop up, then these will have to
+ * have some sort of global synchronization to avoid races with other
+ * pins on the same port.  The ideal solution would probably be to
+ * bind the ports to a GPIO driver, and have this be a client of it.
+ */
+static inline void bb_set(u32 __iomem *p, u32 m)
 {
-	out_8(p, in_8(p) | m);
+	out_be32(p, in_be32(p) | m);
 }
 
-static inline void bb_clr(u8 *p, u8 m)
+static inline void bb_clr(u32 __iomem *p, u32 m)
 {
-	out_8(p, in_8(p) & ~m);
+	out_be32(p, in_be32(p) & ~m);
 }
 
-static inline int bb_read(u8 *p, u8 m)
+static inline int bb_read(u32 __iomem *p, u32 m)
 {
-	return (in_8(p) & m) != 0;
+	return (in_be32(p) & m) != 0;
 }
 
-static inline void mdio_active(struct bb_info *bitbang)
+static inline void mdio_dir(struct mdiobb_ctrl *ctrl, int dir)
 {
-	bb_set(bitbang->mdio_dir, bitbang->mdio_dir_msk);
-}
+	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
 
-static inline void mdio_tristate(struct bb_info *bitbang )
-{
-	bb_clr(bitbang->mdio_dir, bitbang->mdio_dir_msk);
+	if (dir)
+		bb_set(bitbang->dir, bitbang->mdio_msk);
+	else
+		bb_clr(bitbang->dir, bitbang->mdio_msk);
+
+	/* Read back to flush the write. */
+	in_be32(bitbang->dir);
 }
 
-static inline int mdio_read(struct bb_info *bitbang )
+static inline int mdio_read(struct mdiobb_ctrl *ctrl)
 {
-	return bb_read(bitbang->mdio_dat, bitbang->mdio_dat_msk);
+	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
+	return bb_read(bitbang->dat, bitbang->mdio_msk);
 }
 
-static inline void mdio(struct bb_info *bitbang , int what)
+static inline void mdio(struct mdiobb_ctrl *ctrl, int what)
 {
+	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
+
 	if (what)
-		bb_set(bitbang->mdio_dat, bitbang->mdio_dat_msk);
+		bb_set(bitbang->dat, bitbang->mdio_msk);
 	else
-		bb_clr(bitbang->mdio_dat, bitbang->mdio_dat_msk);
+		bb_clr(bitbang->dat, bitbang->mdio_msk);
+
+	/* Read back to flush the write. */
+	in_be32(bitbang->dat);
 }
 
-static inline void mdc(struct bb_info *bitbang , int what)
+static inline void mdc(struct mdiobb_ctrl *ctrl, int what)
 {
+	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
+
 	if (what)
-		bb_set(bitbang->mdc_dat, bitbang->mdc_msk);
+		bb_set(bitbang->dat, bitbang->mdc_msk);
 	else
-		bb_clr(bitbang->mdc_dat, bitbang->mdc_msk);
+		bb_clr(bitbang->dat, bitbang->mdc_msk);
+
+	/* Read back to flush the write. */
+	in_be32(bitbang->dat);
 }
 
-static inline void mii_delay(struct bb_info *bitbang )
+static struct mdiobb_ops bb_ops = {
+	.owner = THIS_MODULE,
+	.set_mdc = mdc,
+	.set_mdio_dir = mdio_dir,
+	.set_mdio_data = mdio,
+	.get_mdio_data = mdio_read,
+};
+
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+static int __devinit fs_mii_bitbang_init(struct mii_bus *bus,
+                                         struct device_node *np)
 {
-	udelay(bitbang->delay);
+	struct resource res;
+	const u32 *data;
+	int mdio_pin, mdc_pin, len;
+	struct bb_info *bitbang = bus->priv;
+
+	int ret = of_address_to_resource(np, 0, &res);
+	if (ret)
+		return ret;
+
+	if (res.end - res.start < 13)
+		return -ENODEV;
+
+	/* This should really encode the pin number as well, but all
+	 * we get is an int, and the odds of multiple bitbang mdio buses
+	 * is low enough that it's not worth going too crazy.
+	 */
+	bus->id = res.start;
+
+	data = of_get_property(np, "fsl,mdio-pin", &len);
+	if (!data || len != 4)
+		return -ENODEV;
+	mdio_pin = *data;
+
+	data = of_get_property(np, "fsl,mdc-pin", &len);
+	if (!data || len != 4)
+		return -ENODEV;
+	mdc_pin = *data;
+
+	bitbang->dir = ioremap(res.start, res.end - res.start + 1);
+	if (!bitbang->dir)
+		return -ENOMEM;
+
+	bitbang->dat = bitbang->dir + 4;
+	bitbang->mdio_msk = 1 << (31 - mdio_pin);
+	bitbang->mdc_msk = 1 << (31 - mdc_pin);
+
+	return 0;
 }
 
-/* Utility to send the preamble, address, and register (common to read and write). */
-static void bitbang_pre(struct bb_info *bitbang , int read, u8 addr, u8 reg)
+static void __devinit add_phy(struct mii_bus *bus, struct device_node *np)
 {
-	int j;
-
-	/*
-	 * Send a 32 bit preamble ('1's) with an extra '1' bit for good measure.
-	 * The IEEE spec says this is a PHY optional requirement.  The AMD
-	 * 79C874 requires one after power up and one after a MII communications
-	 * error.  This means that we are doing more preambles than we need,
-	 * but it is safer and will be much more robust.
-	 */
+	const u32 *data;
+	int len, id, irq;
 
-	mdio_active(bitbang);
-	mdio(bitbang, 1);
-	for (j = 0; j < 32; j++) {
-		mdc(bitbang, 0);
-		mii_delay(bitbang);
-		mdc(bitbang, 1);
-		mii_delay(bitbang);
-	}
+	data = of_get_property(np, "reg", &len);
+	if (!data || len != 4)
+		return;
 
-	/* send the start bit (01) and the read opcode (10) or write (10) */
-	mdc(bitbang, 0);
-	mdio(bitbang, 0);
-	mii_delay(bitbang);
-	mdc(bitbang, 1);
-	mii_delay(bitbang);
-	mdc(bitbang, 0);
-	mdio(bitbang, 1);
-	mii_delay(bitbang);
-	mdc(bitbang, 1);
-	mii_delay(bitbang);
-	mdc(bitbang, 0);
-	mdio(bitbang, read);
-	mii_delay(bitbang);
-	mdc(bitbang, 1);
-	mii_delay(bitbang);
-	mdc(bitbang, 0);
-	mdio(bitbang, !read);
-	mii_delay(bitbang);
-	mdc(bitbang, 1);
-	mii_delay(bitbang);
-
-	/* send the PHY address */
-	for (j = 0; j < 5; j++) {
-		mdc(bitbang, 0);
-		mdio(bitbang, (addr & 0x10) != 0);
-		mii_delay(bitbang);
-		mdc(bitbang, 1);
-		mii_delay(bitbang);
-		addr <<= 1;
-	}
+	id = *data;
+	bus->phy_mask &= ~(1 << id);
 
-	/* send the register address */
-	for (j = 0; j < 5; j++) {
-		mdc(bitbang, 0);
-		mdio(bitbang, (reg & 0x10) != 0);
-		mii_delay(bitbang);
-		mdc(bitbang, 1);
-		mii_delay(bitbang);
-		reg <<= 1;
-	}
+	irq = of_irq_to_resource(np, 0, NULL);
+	if (irq != NO_IRQ)
+		bus->irq[id] = irq;
 }
 
-static int fs_enet_mii_bb_read(struct mii_bus *bus , int phy_id, int location)
+static int __devinit fs_enet_mdio_probe(struct of_device *ofdev,
+                                        const struct of_device_id *match)
 {
-	u16 rdreg;
-	int ret, j;
-	u8 addr = phy_id & 0xff;
-	u8 reg = location & 0xff;
-	struct bb_info* bitbang = bus->priv;
-
-	bitbang_pre(bitbang, 1, addr, reg);
-
-	/* tri-state our MDIO I/O pin so we can read */
-	mdc(bitbang, 0);
-	mdio_tristate(bitbang);
-	mii_delay(bitbang);
-	mdc(bitbang, 1);
-	mii_delay(bitbang);
-
-	/* check the turnaround bit: the PHY should be driving it to zero */
-	if (mdio_read(bitbang) != 0) {
-		/* PHY didn't drive TA low */
-		for (j = 0; j < 32; j++) {
-			mdc(bitbang, 0);
-			mii_delay(bitbang);
-			mdc(bitbang, 1);
-			mii_delay(bitbang);
-		}
-		ret = -1;
+	struct device_node *np = NULL;
+	struct mii_bus *new_bus;
+	struct bb_info *bitbang;
+	int ret = -ENOMEM;
+	int i;
+
+	bitbang = kzalloc(sizeof(struct bb_info), GFP_KERNEL);
+	if (!bitbang)
 		goto out;
-	}
 
-	mdc(bitbang, 0);
-	mii_delay(bitbang);
-
-	/* read 16 bits of register data, MSB first */
-	rdreg = 0;
-	for (j = 0; j < 16; j++) {
-		mdc(bitbang, 1);
-		mii_delay(bitbang);
-		rdreg <<= 1;
-		rdreg |= mdio_read(bitbang);
-		mdc(bitbang, 0);
-		mii_delay(bitbang);
-	}
+	bitbang->ctrl.ops = &bb_ops;
+
+	new_bus = alloc_mdio_bitbang(&bitbang->ctrl);
+	if (!new_bus)
+		goto out_free_priv;
+
+	new_bus->name = "CPM2 Bitbanged MII",
+
+	ret = fs_mii_bitbang_init(new_bus, ofdev->node);
+	if (ret)
+		goto out_free_bus;
+
+	new_bus->phy_mask = ~0;
+	new_bus->irq = kmalloc(sizeof(int) * PHY_MAX_ADDR, GFP_KERNEL);
+	if (!new_bus->irq)
+		goto out_unmap_regs;
+
+	for (i = 0; i < PHY_MAX_ADDR; i++)
+		new_bus->irq[i] = -1;
+
+	while ((np = of_get_next_child(ofdev->node, np)))
+		if (!strcmp(np->type, "ethernet-phy"))
+			add_phy(new_bus, np);
+
+	new_bus->dev = &ofdev->dev;
+	dev_set_drvdata(&ofdev->dev, new_bus);
+
+	ret = mdiobus_register(new_bus);
+	if (ret)
+		goto out_free_irqs;
 
-	mdc(bitbang, 1);
-	mii_delay(bitbang);
-	mdc(bitbang, 0);
-	mii_delay(bitbang);
-	mdc(bitbang, 1);
-	mii_delay(bitbang);
+	return 0;
 
-	ret = rdreg;
+out_free_irqs:
+	dev_set_drvdata(&ofdev->dev, NULL);
+	kfree(new_bus->irq);
+out_unmap_regs:
+	iounmap(bitbang->dir);
+out_free_bus:
+	kfree(new_bus);
+out_free_priv:
+	free_mdio_bitbang(new_bus);
 out:
 	return ret;
 }
 
-static int fs_enet_mii_bb_write(struct mii_bus *bus, int phy_id, int location, u16 val)
+static int fs_enet_mdio_remove(struct of_device *ofdev)
 {
-	int j;
-	struct bb_info* bitbang = bus->priv;
-
-	u8 addr = phy_id & 0xff;
-	u8 reg = location & 0xff;
-	u16 value = val & 0xffff;
-
-	bitbang_pre(bitbang, 0, addr, reg);
-
-	/* send the turnaround (10) */
-	mdc(bitbang, 0);
-	mdio(bitbang, 1);
-	mii_delay(bitbang);
-	mdc(bitbang, 1);
-	mii_delay(bitbang);
-	mdc(bitbang, 0);
-	mdio(bitbang, 0);
-	mii_delay(bitbang);
-	mdc(bitbang, 1);
-	mii_delay(bitbang);
-
-	/* write 16 bits of register data, MSB first */
-	for (j = 0; j < 16; j++) {
-		mdc(bitbang, 0);
-		mdio(bitbang, (value & 0x8000) != 0);
-		mii_delay(bitbang);
-		mdc(bitbang, 1);
-		mii_delay(bitbang);
-		value <<= 1;
-	}
+	struct mii_bus *bus = dev_get_drvdata(&ofdev->dev);
+	struct bb_info *bitbang = bus->priv;
 
-	/*
-	 * Tri-state the MDIO line.
-	 */
-	mdio_tristate(bitbang);
-	mdc(bitbang, 0);
-	mii_delay(bitbang);
-	mdc(bitbang, 1);
-	mii_delay(bitbang);
-	return 0;
-}
+	mdiobus_unregister(bus);
+	free_mdio_bitbang(bus);
+	dev_set_drvdata(&ofdev->dev, NULL);
+	kfree(bus->irq);
+	iounmap(bitbang->dir);
+	kfree(bitbang);
+	kfree(bus);
 
-static int fs_enet_mii_bb_reset(struct mii_bus *bus)
-{
-	/*nothing here - dunno how to reset it*/
 	return 0;
 }
 
-static int fs_mii_bitbang_init(struct bb_info *bitbang, struct fs_mii_bb_platform_info* fmpi)
-{
-	int r;
+static struct of_device_id fs_enet_mdio_bb_match[] = {
+	{
+		.compatible = "fsl,cpm2-mdio-bitbang",
+	},
+	{},
+};
 
-	bitbang->delay = fmpi->delay;
+static struct of_platform_driver fs_enet_bb_mdio_driver = {
+	.name = "fsl-bb-mdio",
+	.match_table = fs_enet_mdio_bb_match,
+	.probe = fs_enet_mdio_probe,
+	.remove = fs_enet_mdio_remove,
+};
 
-	r = bitbang_prep_bit(&bitbang->mdio_dir,
-			 &bitbang->mdio_dir_msk,
-			 &fmpi->mdio_dir);
-	if (r != 0)
-		return r;
+static int fs_enet_mdio_bb_init(void)
+{
+	return of_register_platform_driver(&fs_enet_bb_mdio_driver);
+}
 
-	r = bitbang_prep_bit(&bitbang->mdio_dat,
-			 &bitbang->mdio_dat_msk,
-			 &fmpi->mdio_dat);
-	if (r != 0)
-		return r;
+static void fs_enet_mdio_bb_exit(void)
+{
+	of_unregister_platform_driver(&fs_enet_bb_mdio_driver);
+}
 
-	r = bitbang_prep_bit(&bitbang->mdc_dat,
-			 &bitbang->mdc_msk,
-			 &fmpi->mdc_dat);
-	if (r != 0)
-		return r;
+module_init(fs_enet_mdio_bb_init);
+module_exit(fs_enet_mdio_bb_exit);
+#else
+static int __devinit fs_mii_bitbang_init(struct bb_info *bitbang,
+                                         struct fs_mii_bb_platform_info *fmpi)
+{
+	bitbang->dir = (u32 __iomem *)fmpi->mdio_dir.offset;
+	bitbang->dat = (u32 __iomem *)fmpi->mdio_dat.offset;
+	bitbang->mdio_msk = 1U << (31 - fmpi->mdio_dat.bit);
+	bitbang->mdc_msk = 1U << (31 - fmpi->mdc_dat.bit);
 
 	return 0;
 }
 
-
 static int __devinit fs_enet_mdio_probe(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -320,20 +294,19 @@ static int __devinit fs_enet_mdio_probe(struct device *dev)
 	if (NULL == dev)
 		return -EINVAL;
 
-	new_bus = kzalloc(sizeof(struct mii_bus), GFP_KERNEL);
+	bitbang = kzalloc(sizeof(struct bb_info), GFP_KERNEL);
 
-	if (NULL == new_bus)
+	if (NULL == bitbang)
 		return -ENOMEM;
 
-	bitbang = kzalloc(sizeof(struct bb_info), GFP_KERNEL);
+	bitbang->ctrl.ops = &bb_ops;
 
-	if (NULL == bitbang)
+	new_bus = alloc_mdio_bitbang(&bitbang->ctrl);
+
+	if (NULL == new_bus)
 		return -ENOMEM;
 
 	new_bus->name = "BB MII Bus",
-	new_bus->read = &fs_enet_mii_bb_read,
-	new_bus->write = &fs_enet_mii_bb_write,
-	new_bus->reset = &fs_enet_mii_bb_reset,
 	new_bus->id = pdev->id;
 
 	new_bus->phy_mask = ~0x9;
@@ -365,13 +338,12 @@ static int __devinit fs_enet_mdio_probe(struct device *dev)
 	return 0;
 
 bus_register_fail:
+	free_mdio_bitbang(new_bus);
 	kfree(bitbang);
-	kfree(new_bus);
 
 	return err;
 }
 
-
 static int fs_enet_mdio_remove(struct device *dev)
 {
 	struct mii_bus *bus = dev_get_drvdata(dev);
@@ -380,9 +352,7 @@ static int fs_enet_mdio_remove(struct device *dev)
 
 	dev_set_drvdata(dev, NULL);
 
-	iounmap((void *) (&bus->priv));
-	bus->priv = NULL;
-	kfree(bus);
+	free_mdio_bitbang(bus);
 
 	return 0;
 }
@@ -403,4 +373,4 @@ void fs_enet_mdio_bb_exit(void)
 {
 	driver_unregister(&fs_enet_bb_mdio_driver);
 }
-
+#endif
diff --git a/drivers/net/fs_enet/mii-fec.c b/drivers/net/fs_enet/mii-fec.c
index 0a563a8..a89cf15 100644
--- a/drivers/net/fs_enet/mii-fec.c
+++ b/drivers/net/fs_enet/mii-fec.c
@@ -36,6 +36,10 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+#include <asm/of_platform.h>
+#endif
+
 #include "fs_enet.h"
 #include "fec.h"
 
@@ -47,6 +51,7 @@
 
 #define FEC_MII_LOOPS	10000
 
+#ifndef CONFIG_PPC_CPM_NEW_BINDING
 static int match_has_phy (struct device *dev, void* data)
 {
 	struct platform_device* pdev = container_of(dev, struct platform_device, dev);
@@ -65,7 +70,7 @@ static int match_has_phy (struct device *dev, void* data)
 static int fs_mii_fec_init(struct fec_info* fec, struct fs_mii_fec_platform_info *fmpi)
 {
 	struct resource *r;
-	fec_t *fecp;
+	fec_t __iomem *fecp;
 	char* name = "fsl-cpm-fec";
 
 	/* we need fec in order to be useful */
@@ -80,7 +85,7 @@ static int fs_mii_fec_init(struct fec_info* fec, struct fs_mii_fec_platform_info
 
 	r = platform_get_resource_byname(fec_pdev, IORESOURCE_MEM, "regs");
 
-	fec->fecp = fecp = (fec_t*)ioremap(r->start,sizeof(fec_t));
+	fec->fecp = fecp = ioremap(r->start,sizeof(fec_t));
 	fec->mii_speed = fmpi->mii_speed;
 
 	setbits32(&fecp->fec_r_cntrl, FEC_RCNTRL_MII_MODE);	/* MII enable */
@@ -90,11 +95,12 @@ static int fs_mii_fec_init(struct fec_info* fec, struct fs_mii_fec_platform_info
 
 	return 0;
 }
+#endif
 
 static int fs_enet_fec_mii_read(struct mii_bus *bus , int phy_id, int location)
 {
 	struct fec_info* fec = bus->priv;
-	fec_t *fecp = fec->fecp;
+	fec_t __iomem *fecp = fec->fecp;
 	int i, ret = -1;
 
 	if ((in_be32(&fecp->fec_r_cntrl) & FEC_RCNTRL_MII_MODE) == 0)
@@ -113,13 +119,12 @@ static int fs_enet_fec_mii_read(struct mii_bus *bus , int phy_id, int location)
 	}
 
 	return ret;
-
 }
 
 static int fs_enet_fec_mii_write(struct mii_bus *bus, int phy_id, int location, u16 val)
 {
 	struct fec_info* fec = bus->priv;
-	fec_t *fecp = fec->fecp;
+	fec_t __iomem *fecp = fec->fecp;
 	int i;
 
 	/* this must never happen */
@@ -146,6 +151,141 @@ static int fs_enet_fec_mii_reset(struct mii_bus *bus)
 	return 0;
 }
 
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+static void __devinit add_phy(struct mii_bus *bus, struct device_node *np)
+{
+	const u32 *data;
+	int len, id, irq;
+
+	data = of_get_property(np, "reg", &len);
+	if (!data || len != 4)
+		return;
+
+	id = *data;
+	bus->phy_mask &= ~(1 << id);
+
+	irq = of_irq_to_resource(np, 0, NULL);
+	if (irq != NO_IRQ)
+		bus->irq[id] = irq;
+}
+
+static int __devinit fs_enet_mdio_probe(struct of_device *ofdev,
+                                        const struct of_device_id *match)
+{
+	struct device_node *np = NULL;
+	struct resource res;
+	struct mii_bus *new_bus;
+	struct fec_info *fec;
+	int ret = -ENOMEM, i;
+
+	new_bus = kzalloc(sizeof(struct mii_bus), GFP_KERNEL);
+	if (!new_bus)
+		goto out;
+
+	fec = kzalloc(sizeof(struct fec_info), GFP_KERNEL);
+	if (!fec)
+		goto out_mii;
+
+	new_bus->priv = fec;
+	new_bus->name = "FEC MII Bus";
+	new_bus->read = &fs_enet_fec_mii_read;
+	new_bus->write = &fs_enet_fec_mii_write;
+	new_bus->reset = &fs_enet_fec_mii_reset;
+
+	ret = of_address_to_resource(ofdev->node, 0, &res);
+	if (ret)
+		return ret;
+
+	new_bus->id = res.start;
+
+	fec->fecp = ioremap(res.start, res.end - res.start + 1);
+	if (!fec->fecp)
+		goto out_fec;
+
+	fec->mii_speed = ((ppc_proc_freq + 4999999) / 5000000) << 1;
+
+	setbits32(&fec->fecp->fec_r_cntrl, FEC_RCNTRL_MII_MODE);
+	setbits32(&fec->fecp->fec_ecntrl, FEC_ECNTRL_PINMUX |
+	                                  FEC_ECNTRL_ETHER_EN);
+	out_be32(&fec->fecp->fec_ievent, FEC_ENET_MII);
+	out_be32(&fec->fecp->fec_mii_speed, fec->mii_speed);
+
+	new_bus->phy_mask = ~0;
+	new_bus->irq = kmalloc(sizeof(int) * PHY_MAX_ADDR, GFP_KERNEL);
+	if (!new_bus->irq)
+		goto out_unmap_regs;
+
+	for (i = 0; i < PHY_MAX_ADDR; i++)
+		new_bus->irq[i] = -1;
+
+	while ((np = of_get_next_child(ofdev->node, np)))
+		if (!strcmp(np->type, "ethernet-phy"))
+			add_phy(new_bus, np);
+
+	new_bus->dev = &ofdev->dev;
+	dev_set_drvdata(&ofdev->dev, new_bus);
+
+	ret = mdiobus_register(new_bus);
+	if (ret)
+		goto out_free_irqs;
+
+	return 0;
+
+out_free_irqs:
+	dev_set_drvdata(&ofdev->dev, NULL);
+	kfree(new_bus->irq);
+out_unmap_regs:
+	iounmap(fec->fecp);
+out_fec:
+	kfree(fec);
+out_mii:
+	kfree(new_bus);
+out:
+	return ret;
+}
+
+static int fs_enet_mdio_remove(struct of_device *ofdev)
+{
+	struct mii_bus *bus = dev_get_drvdata(&ofdev->dev);
+	struct fec_info *fec = bus->priv;
+
+	mdiobus_unregister(bus);
+	dev_set_drvdata(&ofdev->dev, NULL);
+	kfree(bus->irq);
+	iounmap(fec->fecp);
+	kfree(fec);
+	kfree(bus);
+
+	return 0;
+}
+
+static struct of_device_id fs_enet_mdio_fec_match[] = {
+	{
+		.compatible = "fsl,pq1-fec-mdio",
+	},
+	{},
+};
+
+static struct of_platform_driver fs_enet_fec_mdio_driver = {
+	.name = "fsl-fec-mdio",
+	.match_table = fs_enet_mdio_fec_match,
+	.probe = fs_enet_mdio_probe,
+	.remove = fs_enet_mdio_remove,
+};
+
+static int fs_enet_mdio_fec_init(void)
+{
+	return of_register_platform_driver(&fs_enet_fec_mdio_driver);
+}
+
+static void fs_enet_mdio_fec_exit(void)
+{
+	of_unregister_platform_driver(&fs_enet_fec_mdio_driver);
+}
+
+module_init(fs_enet_mdio_fec_init);
+module_exit(fs_enet_mdio_fec_exit);
+#else
 static int __devinit fs_enet_fec_mdio_probe(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -236,4 +376,4 @@ void fs_enet_mdio_fec_exit(void)
 {
 	driver_unregister(&fs_enet_fec_mdio_driver);
 }
-
+#endif
diff --git a/drivers/net/macb.c b/drivers/net/macb.c
index c28a0a4..047ea7b 100644
--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -492,7 +492,7 @@ static int macb_poll(struct napi_struct *napi, int budget)
 	}
 
 	dev_dbg(&bp->pdev->dev, "poll: status = %08lx, budget = %d\n",
-		(unsigned long)status, *budget);
+		(unsigned long)status, budget);
 
 	if (!(status & MACB_BIT(REC))) {
 		dev_warn(&bp->pdev->dev,
@@ -503,7 +503,7 @@ static int macb_poll(struct napi_struct *napi, int budget)
 	}
 
 	work_done = macb_rx(bp, budget);
-	if (work_done < orig_budget)
+	if (work_done < budget)
 		netif_rx_complete(dev, napi);
 
 	/*
diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index de59313..4bba884 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -772,6 +772,7 @@ static struct pcmcia_device_id axnet_ids[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0274, 0x1106),
 	PCMCIA_DEVICE_MANF_CARD(0x8a01, 0xc1ab),
 	PCMCIA_DEVICE_MANF_CARD(0x021b, 0x0202), 
+	PCMCIA_DEVICE_MANF_CARD(0xffff, 0x1090), 
 	PCMCIA_DEVICE_PROD_ID12("AmbiCom,Inc.", "Fast Ethernet PC Card(AMB8110)", 0x49b020a7, 0x119cc9fc),
 	PCMCIA_DEVICE_PROD_ID124("Fast Ethernet", "16-bit PC Card", "AX88190", 0xb4be14e3, 0x9a12eb6a, 0xab9be5ef),
 	PCMCIA_DEVICE_PROD_ID12("ASIX", "AX88190", 0x0959823b, 0xab9be5ef),
diff --git a/drivers/net/pcmcia/pcnet_cs.c b/drivers/net/pcmcia/pcnet_cs.c
index 6a64751..9d45e96 100644
--- a/drivers/net/pcmcia/pcnet_cs.c
+++ b/drivers/net/pcmcia/pcnet_cs.c
@@ -1662,6 +1662,7 @@ static struct pcmcia_device_id pcnet_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("Laneed", "LD-CDF", 0x1b7827b2, 0xfec71e40),
 	PCMCIA_DEVICE_PROD_ID12("Laneed", "LD-CDL/T", 0x1b7827b2, 0x79fba4f7),
 	PCMCIA_DEVICE_PROD_ID12("Laneed", "LD-CDS", 0x1b7827b2, 0x931afaab),
+	PCMCIA_DEVICE_PROD_ID12("LEMEL", "LM-N89TX PRO", 0xbbefb52f, 0xd2897a97),
 	PCMCIA_DEVICE_PROD_ID12("Linksys", "Combo PCMCIA EthernetCard (EC2T)", 0x0733cc81, 0x32ee8c78),
 	PCMCIA_DEVICE_PROD_ID12("LINKSYS", "E-CARD", 0xf7cb0b07, 0x6701da11),
 	PCMCIA_DEVICE_PROD_ID12("Linksys", "EtherFast 10/100 Integrated PC Card (PCM100)", 0x0733cc81, 0x453c3f9d),
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 432c210..54b2ba9 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -90,4 +90,13 @@ config FIXED_MII_AMNT
         This control will have specified number allocated for each fixed
         PHY type enabled.
 
+config MDIO_BITBANG
+	tristate "Support for bitbanged MDIO buses"
+	help
+	  This module implements the MDIO bus protocol in software,
+	  for use by low level drivers that export the ability to
+	  drive the relevant pins.
+
+	  If in doubt, say N.
+
 endif # PHYLIB
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 8885650..3d6cc7b 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_VITESSE_PHY)	+= vitesse.o
 obj-$(CONFIG_BROADCOM_PHY)	+= broadcom.o
 obj-$(CONFIG_ICPLUS_PHY)	+= icplus.o
 obj-$(CONFIG_FIXED_PHY)		+= fixed.o
+obj-$(CONFIG_MDIO_BITBANG)	+= mdio-bitbang.o
diff --git a/drivers/net/phy/mdio-bitbang.c b/drivers/net/phy/mdio-bitbang.c
new file mode 100644
index 0000000..8cd243d
--- /dev/null
+++ b/drivers/net/phy/mdio-bitbang.c
@@ -0,0 +1,187 @@
+/*
+ * Bitbanged MDIO support.
+ *
+ * Author: Scott Wood <scottwood@freescale.com>
+ * Copyright (c) 2007 Freescale Semiconductor
+ *
+ * Based on CPM2 MDIO code which is:
+ *
+ * Copyright (c) 2003 Intracom S.A.
+ *  by Pantelis Antoniou <panto@intracom.gr>
+ *
+ * 2005 (c) MontaVista Software, Inc.
+ * Vitaly Bordug <vbordug@ru.mvista.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/mdio-bitbang.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+
+#define MDIO_READ 1
+#define MDIO_WRITE 0
+
+#define MDIO_SETUP_TIME 10
+#define MDIO_HOLD_TIME 10
+
+/* Minimum MDC period is 400 ns, plus some margin for error.  MDIO_DELAY
+ * is done twice per period.
+ */
+#define MDIO_DELAY 250
+
+/* The PHY may take up to 300 ns to produce data, plus some margin
+ * for error.
+ */
+#define MDIO_READ_DELAY 350
+
+/* MDIO must already be configured as output. */
+static void mdiobb_send_bit(struct mdiobb_ctrl *ctrl, int val)
+{
+	const struct mdiobb_ops *ops = ctrl->ops;
+
+	ops->set_mdio_data(ctrl, val);
+	ndelay(MDIO_DELAY);
+	ops->set_mdc(ctrl, 1);
+	ndelay(MDIO_DELAY);
+	ops->set_mdc(ctrl, 0);
+}
+
+/* MDIO must already be configured as input. */
+static int mdiobb_get_bit(struct mdiobb_ctrl *ctrl)
+{
+	const struct mdiobb_ops *ops = ctrl->ops;
+
+	ndelay(MDIO_DELAY);
+	ops->set_mdc(ctrl, 1);
+	ndelay(MDIO_READ_DELAY);
+	ops->set_mdc(ctrl, 0);
+
+	return ops->get_mdio_data(ctrl);
+}
+
+/* MDIO must already be configured as output. */
+static void mdiobb_send_num(struct mdiobb_ctrl *ctrl, u16 val, int bits)
+{
+	int i;
+
+	for (i = bits - 1; i >= 0; i--)
+		mdiobb_send_bit(ctrl, (val >> i) & 1);
+}
+
+/* MDIO must already be configured as input. */
+static u16 mdiobb_get_num(struct mdiobb_ctrl *ctrl, int bits)
+{
+	int i;
+	u16 ret = 0;
+
+	for (i = bits - 1; i >= 0; i--) {
+		ret <<= 1;
+		ret |= mdiobb_get_bit(ctrl);
+	}
+
+	return ret;
+}
+
+/* Utility to send the preamble, address, and
+ * register (common to read and write).
+ */
+static void mdiobb_cmd(struct mdiobb_ctrl *ctrl, int read, u8 phy, u8 reg)
+{
+	const struct mdiobb_ops *ops = ctrl->ops;
+	int i;
+
+	ops->set_mdio_dir(ctrl, 1);
+
+	/*
+	 * Send a 32 bit preamble ('1's) with an extra '1' bit for good
+	 * measure.  The IEEE spec says this is a PHY optional
+	 * requirement.  The AMD 79C874 requires one after power up and
+	 * one after a MII communications error.  This means that we are
+	 * doing more preambles than we need, but it is safer and will be
+	 * much more robust.
+	 */
+
+	for (i = 0; i < 32; i++)
+		mdiobb_send_bit(ctrl, 1);
+
+	/* send the start bit (01) and the read opcode (10) or write (10) */
+	mdiobb_send_bit(ctrl, 0);
+	mdiobb_send_bit(ctrl, 1);
+	mdiobb_send_bit(ctrl, read);
+	mdiobb_send_bit(ctrl, !read);
+
+	mdiobb_send_num(ctrl, phy, 5);
+	mdiobb_send_num(ctrl, reg, 5);
+}
+
+
+static int mdiobb_read(struct mii_bus *bus, int phy, int reg)
+{
+	struct mdiobb_ctrl *ctrl = bus->priv;
+	int ret, i;
+
+	mdiobb_cmd(ctrl, MDIO_READ, phy, reg);
+	ctrl->ops->set_mdio_dir(ctrl, 0);
+
+	/* check the turnaround bit: the PHY should be driving it to zero */
+	if (mdiobb_get_bit(ctrl) != 0) {
+		/* PHY didn't drive TA low -- flush any bits it
+		 * may be trying to send.
+		 */
+		for (i = 0; i < 32; i++)
+			mdiobb_get_bit(ctrl);
+
+		return 0xffff;
+	}
+
+	ret = mdiobb_get_num(ctrl, 16);
+	mdiobb_get_bit(ctrl);
+	return ret;
+}
+
+static int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
+{
+	struct mdiobb_ctrl *ctrl = bus->priv;
+
+	mdiobb_cmd(ctrl, MDIO_WRITE, phy, reg);
+
+	/* send the turnaround (10) */
+	mdiobb_send_bit(ctrl, 1);
+	mdiobb_send_bit(ctrl, 0);
+
+	mdiobb_send_num(ctrl, val, 16);
+
+	ctrl->ops->set_mdio_dir(ctrl, 0);
+	mdiobb_get_bit(ctrl);
+	return 0;
+}
+
+struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl)
+{
+	struct mii_bus *bus;
+
+	bus = kzalloc(sizeof(struct mii_bus), GFP_KERNEL);
+	if (!bus)
+		return NULL;
+
+	__module_get(ctrl->ops->owner);
+
+	bus->read = mdiobb_read;
+	bus->write = mdiobb_write;
+	bus->priv = ctrl;
+
+	return bus;
+}
+
+void free_mdio_bitbang(struct mii_bus *bus)
+{
+	struct mdiobb_ctrl *ctrl = bus->priv;
+
+	module_put(ctrl->ops->owner);
+	kfree(bus);
+}
diff --git a/drivers/net/smc911x.c b/drivers/net/smc911x.c
index c0276c0..7c60df4 100644
--- a/drivers/net/smc911x.c
+++ b/drivers/net/smc911x.c
@@ -2063,7 +2063,7 @@ static int __init smc911x_probe(struct net_device *dev, unsigned long ioaddr)
 
 	/* Grab the IRQ */
 	retval = request_irq(dev->irq, &smc911x_interrupt,
-			IRQF_SHARED | IRQF_TRIGGER_FALLING, dev->name, dev);
+			IRQF_SHARED | SMC_IRQ_SENSE, dev->name, dev);
 	if (retval)
 		goto err_out;
 
diff --git a/drivers/net/smc911x.h b/drivers/net/smc911x.h
index 962a710..16a0edc 100644
--- a/drivers/net/smc911x.h
+++ b/drivers/net/smc911x.h
@@ -36,6 +36,12 @@
   #define SMC_USE_PXA_DMA	1
   #define SMC_USE_16BIT		0
   #define SMC_USE_32BIT		1
+  #define SMC_IRQ_SENSE		IRQF_TRIGGER_FALLING
+#elif CONFIG_SH_MAGIC_PANEL_R2
+  #define SMC_USE_SH_DMA	0
+  #define SMC_USE_16BIT		0
+  #define SMC_USE_32BIT		1
+  #define SMC_IRQ_SENSE		IRQF_TRIGGER_LOW
 #endif
 
 
diff --git a/drivers/net/smc91x.h b/drivers/net/smc91x.h
index 6ff3a16..af9e6bf 100644
--- a/drivers/net/smc91x.h
+++ b/drivers/net/smc91x.h
@@ -284,6 +284,7 @@ SMC_outw(u16 val, void __iomem *ioaddr, int reg)
 #elif   defined(CONFIG_SUPERH)
 
 #ifdef CONFIG_SOLUTION_ENGINE
+#define SMC_IRQ_FLAGS		(0)
 #define SMC_CAN_USE_8BIT       0
 #define SMC_CAN_USE_16BIT      1
 #define SMC_CAN_USE_32BIT      0
diff --git a/include/linux/fs_enet_pd.h b/include/linux/fs_enet_pd.h
index 543cd3c..9bc045b 100644
--- a/include/linux/fs_enet_pd.h
+++ b/include/linux/fs_enet_pd.h
@@ -16,6 +16,7 @@
 #ifndef FS_ENET_PD_H
 #define FS_ENET_PD_H
 
+#include <linux/string.h>
 #include <asm/types.h>
 
 #define FS_ENET_NAME	"fs_enet"
@@ -119,6 +120,7 @@ struct fs_platform_info {
 
 	u32 cp_page;		/* CPM page */
 	u32 cp_block;		/* CPM sblock */
+	u32 cp_command;		/* CPM page/sblock/mcn */
 
 	u32 clk_trx;		/* some stuff for pins & mux configuration*/
 	u32 clk_rx;
@@ -133,7 +135,11 @@ struct fs_platform_info {
 	u32 device_flags;
 
 	int phy_addr;		/* the phy address (-1 no phy) */
+#ifdef CONFIG_PPC_CPM_NEW_BINDING
+	char bus_id[16];
+#else
 	const char*	bus_id;
+#endif
 	int phy_irq;		/* the phy irq (if it exists)  */
 
 	const struct fs_mii_bus_info *bus_info;
diff --git a/include/linux/mdio-bitbang.h b/include/linux/mdio-bitbang.h
new file mode 100644
index 0000000..8ea9a42
--- /dev/null
+++ b/include/linux/mdio-bitbang.h
@@ -0,0 +1,42 @@
+#ifndef __LINUX_MDIO_BITBANG_H
+#define __LINUX_MDIO_BITBANG_H
+
+#include <linux/phy.h>
+#include <linux/module.h>
+
+struct mdiobb_ctrl;
+
+struct mdiobb_ops {
+	struct module *owner;
+
+	/* Set the Management Data Clock high if level is one,
+	 * low if level is zero.
+	 */
+	void (*set_mdc)(struct mdiobb_ctrl *ctrl, int level);
+
+	/* Configure the Management Data I/O pin as an input if
+	 * "output" is zero, or an output if "output" is one.
+	 */
+	void (*set_mdio_dir)(struct mdiobb_ctrl *ctrl, int output);
+
+	/* Set the Management Data I/O pin high if value is one,
+	 * low if "value" is zero.  This may only be called
+	 * when the MDIO pin is configured as an output.
+	 */
+	void (*set_mdio_data)(struct mdiobb_ctrl *ctrl, int value);
+
+	/* Retrieve the state Management Data I/O pin. */
+	int (*get_mdio_data)(struct mdiobb_ctrl *ctrl);
+};
+
+struct mdiobb_ctrl {
+	const struct mdiobb_ops *ops;
+};
+
+/* The returned bus is not yet registered with the phy layer. */
+struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl);
+
+/* The bus must already have been unregistered. */
+void free_mdio_bitbang(struct mii_bus *bus);
+
+#endif
