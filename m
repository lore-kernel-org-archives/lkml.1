Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYBRUfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYBRUfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYBRUfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:35:33 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:40887 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbYBRUfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:35:31 -0500
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 18 Feb 2008 12:35:16 -0800
Message-ID: <adar6fahukb.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Feb 2008 20:35:17.0266 (UTC) FILETIME=[C5A00720:01C8726D]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This will get a few post-2.6.25-rc2 fixes, mostly for the new nes driver:

Chien Tung (1):
      RDMA/nes: Fix VLAN support

Glenn Streiff (1):
      RDMA/nes: Fix MAC interrupt erroneously masked on ifdown

Li Zefan (1):
      IB: Fix return value in ib_device_register_sysfs()

Roland Dreier (1):
      RDMA/nes: Fix possible array overrun

 drivers/infiniband/core/sysfs.c       |    4 ++-
 drivers/infiniband/hw/nes/nes_nic.c   |   62 +++++++++++++++++++++++---------
 drivers/infiniband/hw/nes/nes_verbs.c |    2 +-
 3 files changed, 48 insertions(+), 20 deletions(-)


diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c864ef7..5a4b2e6 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -686,8 +686,10 @@ int ib_device_register_sysfs(struct ib_device *device)
 
 	device->ports_parent = kobject_create_and_add("ports",
 					kobject_get(&class_dev->kobj));
-	if (!device->ports_parent)
+	if (!device->ports_parent) {
+		ret = -ENOMEM;
 		goto err_put;
+	}
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH) {
 		ret = add_port(device, 0);
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index b6cc265..eee77da 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -148,14 +148,15 @@ static int nes_netdev_open(struct net_device *netdev)
 	struct nes_device *nesdev = nesvnic->nesdev;
 	int ret;
 	int i;
-	struct nes_vnic *first_nesvnic;
+	struct nes_vnic *first_nesvnic = NULL;
 	u32 nic_active_bit;
 	u32 nic_active;
+	struct list_head *list_pos, *list_temp;
 
 	assert(nesdev != NULL);
 
-	first_nesvnic = list_entry(nesdev->nesadapter->nesvnic_list[nesdev->mac_index].next,
-			struct nes_vnic, list);
+	if (nesvnic->netdev_open == 1)
+		return 0;
 
 	if (netif_msg_ifup(nesvnic))
 		printk(KERN_INFO PFX "%s: enabling interface\n", netdev->name);
@@ -225,7 +226,18 @@ static int nes_netdev_open(struct net_device *netdev)
 	nes_write32(nesdev->regs+NES_CQE_ALLOC, NES_CQE_ALLOC_NOTIFY_NEXT |
 			nesvnic->nic_cq.cq_number);
 	nes_read32(nesdev->regs+NES_CQE_ALLOC);
-
+	list_for_each_safe(list_pos, list_temp, &nesdev->nesadapter->nesvnic_list[nesdev->mac_index]) {
+		first_nesvnic = container_of(list_pos, struct nes_vnic, list);
+		if (first_nesvnic->netdev_open == 1)
+			break;
+	}
+	if (first_nesvnic->netdev_open == 0) {
+		nes_debug(NES_DBG_INIT, "Setting up MAC interrupt mask.\n");
+		nes_write_indexed(nesdev, NES_IDX_MAC_INT_MASK + (0x200 * nesdev->mac_index),
+				~(NES_MAC_INT_LINK_STAT_CHG | NES_MAC_INT_XGMII_EXT |
+				NES_MAC_INT_TX_UNDERFLOW | NES_MAC_INT_TX_ERROR));
+		first_nesvnic = nesvnic;
+	}
 	if (first_nesvnic->linkup) {
 		/* Enable network packets */
 		nesvnic->linkup = 1;
@@ -248,6 +260,8 @@ static int nes_netdev_stop(struct net_device *netdev)
 	struct nes_device *nesdev = nesvnic->nesdev;
 	u32 nic_active_mask;
 	u32 nic_active;
+	struct nes_vnic *first_nesvnic = NULL;
+	struct list_head *list_pos, *list_temp;
 
 	nes_debug(NES_DBG_SHUTDOWN, "nesvnic=%p, nesdev=%p, netdev=%p %s\n",
 			nesvnic, nesdev, netdev, netdev->name);
@@ -260,9 +274,20 @@ static int nes_netdev_stop(struct net_device *netdev)
 	/* Disable network packets */
 	napi_disable(&nesvnic->napi);
 	netif_stop_queue(netdev);
-	if ((nesdev->netdev[0] == netdev) & (nesvnic->logical_port == nesdev->mac_index)) {
-		nes_write_indexed(nesdev,
-				NES_IDX_MAC_INT_MASK+(0x200*nesdev->mac_index), 0xffffffff);
+	list_for_each_safe(list_pos, list_temp, &nesdev->nesadapter->nesvnic_list[nesdev->mac_index]) {
+		first_nesvnic = container_of(list_pos, struct nes_vnic, list);
+		if ((first_nesvnic->netdev_open == 1) && (first_nesvnic != nesvnic))
+			break;
+	}
+
+	if (first_nesvnic->netdev_open == 0)
+		nes_write_indexed(nesdev, NES_IDX_MAC_INT_MASK+(0x200*nesdev->mac_index), 0xffffffff);
+	else if ((first_nesvnic != nesvnic) &&
+		 (PCI_FUNC(first_nesvnic->nesdev->pcidev->devfn) != PCI_FUNC(nesvnic->nesdev->pcidev->devfn))) {
+		nes_write_indexed(nesdev, NES_IDX_MAC_INT_MASK + (0x200 * nesdev->mac_index), 0xffffffff);
+		nes_write_indexed(first_nesvnic->nesdev, NES_IDX_MAC_INT_MASK + (0x200 * first_nesvnic->nesdev->mac_index),
+				~(NES_MAC_INT_LINK_STAT_CHG | NES_MAC_INT_XGMII_EXT |
+				NES_MAC_INT_TX_UNDERFLOW | NES_MAC_INT_TX_ERROR));
 	}
 
 	nic_active_mask = ~((u32)(1 << nesvnic->nic_index));
@@ -859,7 +884,6 @@ void nes_netdev_set_multicast_list(struct net_device *netdev)
 		for (mc_index=0; mc_index < NES_MULTICAST_PF_MAX; mc_index++) {
 			while (multicast_addr && nesvnic->mcrq_mcast_filter && ((mc_nic_index = nesvnic->mcrq_mcast_filter(nesvnic, multicast_addr->dmi_addr)) == 0))
 				multicast_addr = multicast_addr->next;
-
 			if (mc_nic_index < 0)
 				mc_nic_index = nesvnic->nic_index;
 			if (multicast_addr) {
@@ -908,7 +932,7 @@ static int nes_netdev_change_mtu(struct	net_device *netdev,	int	new_mtu)
 		return -EINVAL;
 
 	netdev->mtu	= new_mtu;
-	nesvnic->max_frame_size	= new_mtu+ETH_HLEN;
+	nesvnic->max_frame_size	= new_mtu + VLAN_ETH_HLEN;
 
 	if (netdev->mtu	> 1500)	{
 		jumbomode=1;
@@ -1470,10 +1494,15 @@ static void nes_netdev_vlan_rx_register(struct net_device *netdev, struct vlan_g
 {
 	struct nes_vnic *nesvnic = netdev_priv(netdev);
 	struct nes_device *nesdev = nesvnic->nesdev;
+	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	u32 u32temp;
+	unsigned long flags;
 
+	spin_lock_irqsave(&nesadapter->phy_lock, flags);
 	nesvnic->vlan_grp = grp;
 
+	nes_debug(NES_DBG_NETDEV, "%s: %s\n", __func__, netdev->name);
+
 	/* Enable/Disable VLAN Stripping */
 	u32temp = nes_read_indexed(nesdev, NES_IDX_PCIX_DIAG);
 	if (grp)
@@ -1482,6 +1511,7 @@ static void nes_netdev_vlan_rx_register(struct net_device *netdev, struct vlan_g
 		u32temp	|= 0x02000000;
 
 	nes_write_indexed(nesdev, NES_IDX_PCIX_DIAG, u32temp);
+	spin_unlock_irqrestore(&nesadapter->phy_lock, flags);
 }
 
 
@@ -1540,7 +1570,7 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
 	nesvnic->msg_enable = netif_msg_init(debug, default_msg);
 	nesvnic->netdev_index = nesdev->netdev_count;
 	nesvnic->perfect_filter_index = nesdev->nesadapter->netdev_count;
-	nesvnic->max_frame_size = netdev->mtu+netdev->hard_header_len;
+	nesvnic->max_frame_size = netdev->mtu + netdev->hard_header_len + VLAN_HLEN;
 
 	curr_qp_map = nic_qp_mapping_per_function[PCI_FUNC(nesdev->pcidev->devfn)];
 	nesvnic->nic.qp_id = curr_qp_map[nesdev->netdev_count].qpid;
@@ -1610,7 +1640,7 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
 	list_add_tail(&nesvnic->list, &nesdev->nesadapter->nesvnic_list[nesdev->mac_index]);
 
 	if ((nesdev->netdev_count == 0) &&
-			(PCI_FUNC(nesdev->pcidev->devfn) == nesdev->mac_index)) {
+	    (PCI_FUNC(nesdev->pcidev->devfn) == nesdev->mac_index)) {
 		nes_debug(NES_DBG_INIT, "Setting up PHY interrupt mask. Using register index 0x%04X\n",
 				NES_IDX_PHY_PCS_CONTROL_STATUS0+(0x200*(nesvnic->logical_port&1)));
 		u32temp = nes_read_indexed(nesdev, NES_IDX_PHY_PCS_CONTROL_STATUS0 +
@@ -1648,18 +1678,14 @@ struct net_device *nes_netdev_init(struct nes_device *nesdev,
 				nesvnic->linkup = 1;
 			}
 		}
-		nes_debug(NES_DBG_INIT, "Setting up MAC interrupt mask.\n");
 		/* clear the MAC interrupt status, assumes direct logical to physical mapping */
-		u32temp = nes_read_indexed(nesdev, NES_IDX_MAC_INT_STATUS+(0x200*nesvnic->logical_port));
+		u32temp = nes_read_indexed(nesdev, NES_IDX_MAC_INT_STATUS + (0x200 * nesdev->mac_index));
 		nes_debug(NES_DBG_INIT, "Phy interrupt status = 0x%X.\n", u32temp);
-		nes_write_indexed(nesdev, NES_IDX_MAC_INT_STATUS+(0x200*nesvnic->logical_port), u32temp);
+		nes_write_indexed(nesdev, NES_IDX_MAC_INT_STATUS + (0x200 * nesdev->mac_index), u32temp);
 
-		if (nesdev->nesadapter->phy_type[nesvnic->logical_port] != NES_PHY_TYPE_IRIS)
+		if (nesdev->nesadapter->phy_type[nesdev->mac_index] != NES_PHY_TYPE_IRIS)
 			nes_init_phy(nesdev);
 
-		nes_write_indexed(nesdev, NES_IDX_MAC_INT_MASK+(0x200*nesvnic->logical_port),
-				~(NES_MAC_INT_LINK_STAT_CHG | NES_MAC_INT_XGMII_EXT |
-				NES_MAC_INT_TX_UNDERFLOW | NES_MAC_INT_TX_ERROR));
 	}
 
 	return netdev;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index ffd4b42..4dafbe1 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1337,7 +1337,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 								   NES_MAX_USER_WQ_REGIONS, nes_ucontext->first_free_wq);
 					/* nes_debug(NES_DBG_QP, "find_first_zero_biton wqs returned %u\n",
 							nespd->mmap_db_index); */
-					if (nesqp->mmap_sq_db_index > NES_MAX_USER_WQ_REGIONS) {
+					if (nesqp->mmap_sq_db_index >= NES_MAX_USER_WQ_REGIONS) {
 						nes_debug(NES_DBG_QP,
 							  "db index > max user regions, failing create QP\n");
 						nes_free_resource(nesadapter, nesadapter->allocated_qps, qp_num);
