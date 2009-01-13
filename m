Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbZAMDkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbZAMDkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 22:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbZAMDkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 22:40:05 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:54466 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZAMDkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 22:40:03 -0500
X-IronPort-AV: E=Sophos;i="4.37,256,1231113600"; 
   d="scan'208";a="59273363"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull infiniband.git
X-Message-Flag: Warning: May contain useful information
Date: Mon, 12 Jan 2009 19:40:00 -0800
Message-ID: <adaiqojlvqn.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jan 2009 03:40:00.0802 (UTC) FILETIME=[9CE6C820:01C97530]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus

Some fixes for 2.6.29-rc2:

Harvey Harrison (1):
      RDMA/nes: Fix for NIPQUAD removal

Randy Dunlap (1):
      IB/iser: Add dependency on INFINIBAND_ADDR_TRANS

Roland Dreier (3):
      mlx4_core: Fix warning from min()
      IB/mlx4: Don't register IB device for adapters with no IB ports
      Merge branches 'ehca', 'ipoib', 'iser', 'mlx4' and 'nes' into for-next

Stephen Rothwell (1):
      IB/ehca: spin_lock_irqsave() takes an unsigned long

Yossi Etigin (2):
      IPoIB: Fix loss of connectivity after bonding failover on both sides
      IPoIB: Do not join broadcast group if interface is brought down

 drivers/infiniband/hw/ehca/ehca_main.c         |    2 +-
 drivers/infiniband/hw/mlx4/main.c              |   13 +++++--
 drivers/infiniband/hw/nes/nes_cm.c             |   12 +++++--
 drivers/infiniband/hw/nes/nes_utils.c          |    4 ++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |   38 ++++++++++++------------
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |    3 ++
 drivers/infiniband/ulp/iser/Kconfig            |    2 +-
 drivers/net/mlx4/main.c                        |    4 +-
 8 files changed, 47 insertions(+), 31 deletions(-)


diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 3b77b67..c7b8a50 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -955,7 +955,7 @@ void ehca_poll_eqs(unsigned long data)
 			struct ehca_eq *eq = &shca->eq;
 			int max = 3;
 			volatile u64 q_ofs, q_ofs2;
-			u64 flags;
+			unsigned long flags;
 			spin_lock_irqsave(&eq->spinlock, flags);
 			q_ofs = eq->ipz_queue.current_q_offset;
 			spin_unlock_irqrestore(&eq->spinlock, flags);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index dcefe1f..61588bd 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -543,14 +543,21 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 {
 	static int mlx4_ib_version_printed;
 	struct mlx4_ib_dev *ibdev;
+	int num_ports = 0;
 	int i;
 
-
 	if (!mlx4_ib_version_printed) {
 		printk(KERN_INFO "%s", mlx4_ib_version);
 		++mlx4_ib_version_printed;
 	}
 
+	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
+		num_ports++;
+
+	/* No point in registering a device with no ports... */
+	if (num_ports == 0)
+		return NULL;
+
 	ibdev = (struct mlx4_ib_dev *) ib_alloc_device(sizeof *ibdev);
 	if (!ibdev) {
 		dev_err(&dev->pdev->dev, "Device struct alloc failed\n");
@@ -574,9 +581,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.owner		= THIS_MODULE;
 	ibdev->ib_dev.node_type		= RDMA_NODE_IB_CA;
 	ibdev->ib_dev.local_dma_lkey	= dev->caps.reserved_lkey;
-	ibdev->num_ports = 0;
-	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
-		ibdev->num_ports++;
+	ibdev->num_ports		= num_ports;
 	ibdev->ib_dev.phys_port_cnt     = ibdev->num_ports;
 	ibdev->ib_dev.num_comp_vectors	= dev->caps.num_comp_vectors;
 	ibdev->ib_dev.dma_device	= &dev->pdev->dev;
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index a812db2..ca9ef3f 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -778,12 +778,13 @@ static struct nes_cm_node *find_node(struct nes_cm_core *cm_core,
 	unsigned long flags;
 	struct list_head *hte;
 	struct nes_cm_node *cm_node;
+	__be32 tmp_addr = cpu_to_be32(loc_addr);
 
 	/* get a handle on the hte */
 	hte = &cm_core->connected_nodes;
 
 	nes_debug(NES_DBG_CM, "Searching for an owner node: %pI4:%x from core %p->%p\n",
-		  &loc_addr, loc_port, cm_core, hte);
+		  &tmp_addr, loc_port, cm_core, hte);
 
 	/* walk list and find cm_node associated with this session ID */
 	spin_lock_irqsave(&cm_core->ht_lock, flags);
@@ -816,6 +817,7 @@ static struct nes_cm_listener *find_listener(struct nes_cm_core *cm_core,
 {
 	unsigned long flags;
 	struct nes_cm_listener *listen_node;
+	__be32 tmp_addr = cpu_to_be32(dst_addr);
 
 	/* walk list and find cm_node associated with this session ID */
 	spin_lock_irqsave(&cm_core->listen_list_lock, flags);
@@ -833,7 +835,7 @@ static struct nes_cm_listener *find_listener(struct nes_cm_core *cm_core,
 	spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
 
 	nes_debug(NES_DBG_CM, "Unable to find listener for %pI4:%x\n",
-		  &dst_addr, dst_port);
+		  &tmp_addr, dst_port);
 
 	/* no listener */
 	return NULL;
@@ -2059,6 +2061,7 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 	struct tcphdr *tcph;
 	struct nes_cm_info nfo;
 	int skb_handled = 1;
+	__be32 tmp_daddr, tmp_saddr;
 
 	if (!skb)
 		return 0;
@@ -2074,8 +2077,11 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 	nfo.rem_addr = ntohl(iph->saddr);
 	nfo.rem_port = ntohs(tcph->source);
 
+	tmp_daddr = cpu_to_be32(iph->daddr);
+	tmp_saddr = cpu_to_be32(iph->saddr);
+
 	nes_debug(NES_DBG_CM, "Received packet: dest=%pI4:0x%04X src=%pI4:0x%04X\n",
-		  &iph->daddr, tcph->dest, &iph->saddr, tcph->source);
+		  &tmp_daddr, tcph->dest, &tmp_saddr, tcph->source);
 
 	do {
 		cm_node = find_node(cm_core,
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index aa9b734..6f3bc1b 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -655,6 +655,7 @@ int nes_arp_table(struct nes_device *nesdev, u32 ip_addr, u8 *mac_addr, u32 acti
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	int arp_index;
 	int err = 0;
+	__be32 tmp_addr;
 
 	for (arp_index = 0; (u32) arp_index < nesadapter->arp_table_size; arp_index++) {
 		if (nesadapter->arp_table[arp_index].ip_addr == ip_addr)
@@ -682,8 +683,9 @@ int nes_arp_table(struct nes_device *nesdev, u32 ip_addr, u8 *mac_addr, u32 acti
 
 	/* DELETE or RESOLVE */
 	if (arp_index == nesadapter->arp_table_size) {
+		tmp_addr = cpu_to_be32(ip_addr);
 		nes_debug(NES_DBG_NETDEV, "MAC for %pI4 not in ARP table - cannot %s\n",
-			  &ip_addr, action == NES_ARP_RESOLVE ? "resolve" : "delete");
+			  &tmp_addr, action == NES_ARP_RESOLVE ? "resolve" : "delete");
 		return -1;
 	}
 
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 19e06bc..dce0443 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -711,26 +711,26 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		neigh = *to_ipoib_neigh(skb->dst->neighbour);
 
-		if (neigh->ah)
-			if (unlikely((memcmp(&neigh->dgid.raw,
-					    skb->dst->neighbour->ha + 4,
-					    sizeof(union ib_gid))) ||
-					 (neigh->dev != dev))) {
-				spin_lock_irqsave(&priv->lock, flags);
-				/*
-				 * It's safe to call ipoib_put_ah() inside
-				 * priv->lock here, because we know that
-				 * path->ah will always hold one more reference,
-				 * so ipoib_put_ah() will never do more than
-				 * decrement the ref count.
-				 */
+		if (unlikely((memcmp(&neigh->dgid.raw,
+				     skb->dst->neighbour->ha + 4,
+				     sizeof(union ib_gid))) ||
+			     (neigh->dev != dev))) {
+			spin_lock_irqsave(&priv->lock, flags);
+			/*
+			 * It's safe to call ipoib_put_ah() inside
+			 * priv->lock here, because we know that
+			 * path->ah will always hold one more reference,
+			 * so ipoib_put_ah() will never do more than
+			 * decrement the ref count.
+			 */
+			if (neigh->ah)
 				ipoib_put_ah(neigh->ah);
-				list_del(&neigh->list);
-				ipoib_neigh_free(dev, neigh);
-				spin_unlock_irqrestore(&priv->lock, flags);
-				ipoib_path_lookup(skb, dev);
-				return NETDEV_TX_OK;
-			}
+			list_del(&neigh->list);
+			ipoib_neigh_free(dev, neigh);
+			spin_unlock_irqrestore(&priv->lock, flags);
+			ipoib_path_lookup(skb, dev);
+			return NETDEV_TX_OK;
+		}
 
 		if (ipoib_cm_get(neigh)) {
 			if (ipoib_cm_up(neigh)) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index a2eb3b9..59d02e0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -529,6 +529,9 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	if (!priv->broadcast) {
 		struct ipoib_mcast *broadcast;
 
+		if (!test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
+			return;
+
 		broadcast = ipoib_mcast_alloc(dev, 1);
 		if (!broadcast) {
 			ipoib_warn(priv, "failed to allocate broadcast group\n");
diff --git a/drivers/infiniband/ulp/iser/Kconfig b/drivers/infiniband/ulp/iser/Kconfig
index 77dedba..b411c51 100644
--- a/drivers/infiniband/ulp/iser/Kconfig
+++ b/drivers/infiniband/ulp/iser/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_ISER
 	tristate "iSCSI Extensions for RDMA (iSER)"
-	depends on SCSI && INET
+	depends on SCSI && INET && INFINIBAND_ADDR_TRANS
 	select SCSI_ISCSI_ATTRS
 	---help---
 	  Support for the iSCSI Extensions for RDMA (iSER) Protocol
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 710c79e..6ef2490 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -912,8 +912,8 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
 	int i;
 
 	if (msi_x) {
-		nreq = min(dev->caps.num_eqs - dev->caps.reserved_eqs,
-			   num_possible_cpus() + 1);
+		nreq = min_t(int, dev->caps.num_eqs - dev->caps.reserved_eqs,
+			     num_possible_cpus() + 1);
 		entries = kcalloc(nreq, sizeof *entries, GFP_KERNEL);
 		if (!entries)
 			goto no_msi;
