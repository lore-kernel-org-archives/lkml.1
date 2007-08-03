Return-Path: <linux-kernel-owner+w=401wt.eu-S1764053AbXHCRgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764053AbXHCRgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762068AbXHCRfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:35:12 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:37192 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763513AbXHCRfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:35:09 -0400
Date: Fri, 3 Aug 2007 19:33:42 +0200 (MEST)
Message-Id: <200708031733.TAA00761@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 04/13] dev->priv to netdev_priv(dev), for drivers/net/bonding
Cc: ctindel@users.sourceforge.net, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Replacing accesses to dev->priv to netdev_priv(dev). The replacment
is safe when netdev_priv is used to access a private structure that is
right next to the net_device structure in memory. Cf
http://groups.google.com/group/comp.os.linux.development.system/browse_thread/thread/de19321bcd94dbb8/0d74a4adcd6177bd
This is the case when the net_device structure was allocated with
a call to alloc_netdev or one of its derivative.

Here is an excerpt of the semantic patch that performs the transformation

@ rule1 @
type T;
struct net_device *dev;
@@

 dev = 
(
        alloc_netdev
|         
        alloc_etherdev
|
        alloc_trdev
)
   (sizeof(T), ...)

@ rule1bis @
struct net_device *dev;
expression E;
@@
 dev->priv = E

@ rule2 depends on rule1 && !rule1bis  @
struct net_device *dev;
type rule1.T;
@@

- (T*) dev->priv
+ netdev_priv(dev)

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: ctindel@users.sourceforge.net
Cc: fubar@us.ibm.com
Cc: bonding-devel@lists.sourceforge.net
Cc: akpm@linux-foundation.org
---

 drivers/net/bonding/bond_3ad.c  |    6 +--
 drivers/net/bonding/bond_alb.c  |    6 +--
 drivers/net/bonding/bond_main.c |   62 ++++++++++++++++++++--------------------
 3 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index f829e4a..9ad88d0 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2364,7 +2364,7 @@ int bond_3ad_get_active_agg_info(struct 
 int bond_3ad_xmit_xor(struct sk_buff *skb, struct net_device *dev)
 {
 	struct slave *slave, *start_at;
-	struct bonding *bond = dev->priv;
+	struct bonding *bond = netdev_priv(dev);
 	int slave_agg_no;
 	int slaves_in_agg;
 	int agg_id;
@@ -2444,7 +2444,7 @@ out:
 
 int bond_3ad_lacpdu_recv(struct sk_buff *skb, struct net_device *dev, struct packet_type* ptype, struct net_device *orig_dev)
 {
-	struct bonding *bond = dev->priv;
+	struct bonding *bond = netdev_priv(dev);
 	struct slave *slave = NULL;
 	int ret = NET_RX_DROP;
 
@@ -2452,7 +2452,7 @@ int bond_3ad_lacpdu_recv(struct sk_buff 
 		goto out;
 
 	read_lock(&bond->lock);
-	slave = bond_get_slave_by_dev((struct bonding *)dev->priv, orig_dev);
+	slave = bond_get_slave_by_dev(netdev_priv(dev), orig_dev);
 	if (!slave)
 		goto out_unlock;
 
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 92c3b6f..c90524b 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -341,7 +341,7 @@ static void rlb_update_entry_from_arp(st
 
 static int rlb_arp_recv(struct sk_buff *skb, struct net_device *bond_dev, struct packet_type *ptype, struct net_device *orig_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct arp_pkt *arp = (struct arp_pkt *)skb->data;
 	int res = NET_RX_DROP;
 
@@ -1260,7 +1260,7 @@ void bond_alb_deinitialize(struct bondin
 
 int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct ethhdr *eth_data;
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
 	struct slave *tx_slave = NULL;
@@ -1621,7 +1621,7 @@ void bond_alb_handle_active_change(struc
 
 int bond_alb_set_mac_address(struct net_device *bond_dev, void *addr)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct sockaddr *sa = addr;
 	struct slave *slave, *swap_slave;
 	int res;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 070b78d..08f5fcc 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -425,7 +425,7 @@ int bond_dev_queue_xmit(struct bonding *
  */
 static void bond_vlan_rx_register(struct net_device *bond_dev, struct vlan_group *grp)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
 	int i;
 
@@ -448,7 +448,7 @@ static void bond_vlan_rx_register(struct
  */
 static void bond_vlan_rx_add_vid(struct net_device *bond_dev, uint16_t vid)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
 	int i, res;
 
@@ -476,7 +476,7 @@ static void bond_vlan_rx_add_vid(struct 
  */
 static void bond_vlan_rx_kill_vid(struct net_device *bond_dev, uint16_t vid)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
 	struct net_device *vlan_dev;
 	int i, res;
@@ -900,7 +900,7 @@ static int bond_mc_list_copy(struct dev_
  */
 static void bond_mc_list_flush(struct net_device *bond_dev, struct net_device *slave_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct dev_mc_list *dmi;
 
 	for (dmi = bond_dev->mc_list; dmi; dmi = dmi->next) {
@@ -1248,7 +1248,7 @@ static int bond_compute_features(struct 
 /* enslave device <slave> to bond device <master> */
 int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *new_slave = NULL;
 	struct dev_mc_list *dmi;
 	struct sockaddr addr;
@@ -1607,7 +1607,7 @@ err_undo_flags:
  */
 int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave, *oldcurrent;
 	struct sockaddr addr;
 	int mac_addr_differ;
@@ -1780,7 +1780,7 @@ int bond_release(struct net_device *bond
  */
 static int bond_release_all(struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
 	struct net_device *slave_dev;
 	struct sockaddr addr;
@@ -1907,7 +1907,7 @@ out:
  */
 static int bond_ioctl_change_active(struct net_device *bond_dev, struct net_device *slave_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *old_active = NULL;
 	struct slave *new_active = NULL;
 	int res = 0;
@@ -1951,7 +1951,7 @@ static int bond_ioctl_change_active(stru
 
 static int bond_info_query(struct net_device *bond_dev, struct ifbond *info)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 
 	info->bond_mode = bond->params.mode;
 	info->miimon = bond->params.miimon;
@@ -1965,7 +1965,7 @@ static int bond_info_query(struct net_de
 
 static int bond_slave_info_query(struct net_device *bond_dev, struct ifslave *info)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
 	int i, found = 0;
 
@@ -2001,7 +2001,7 @@ static int bond_slave_info_query(struct 
 /* this function is called regularly to monitor each slave's link. */
 void bond_mii_monitor(struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave, *oldcurrent;
 	int do_failover = 0;
 	int delta_in_ticks;
@@ -2468,7 +2468,7 @@ static int bond_arp_rcv(struct sk_buff *
 	if (!(dev->priv_flags & IFF_BONDING) || !(dev->flags & IFF_MASTER))
 		goto out;
 
-	bond = dev->priv;
+	bond = netdev_priv(dev);
 	read_lock(&bond->lock);
 
 	dprintk("bond_arp_rcv: bond %s skb->dev %s orig_dev %s\n",
@@ -2534,7 +2534,7 @@ out:
  */
 void bond_loadbalance_arp_mon(struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave, *oldcurrent;
 	int do_failover = 0;
 	int delta_in_ticks;
@@ -2665,7 +2665,7 @@ out:
  */
 void bond_activebackup_arp_mon(struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
 	int delta_in_ticks;
 	int i;
@@ -3222,7 +3222,7 @@ #endif
 
 static int bond_master_netdev_event(unsigned long event, struct net_device *bond_dev)
 {
-	struct bonding *event_bond = bond_dev->priv;
+	struct bonding *event_bond = netdev_priv(bond_dev);
 
 	switch (event) {
 	case NETDEV_CHANGENAME:
@@ -3242,7 +3242,7 @@ static int bond_master_netdev_event(unsi
 static int bond_slave_netdev_event(unsigned long event, struct net_device *slave_dev)
 {
 	struct net_device *bond_dev = slave_dev->master;
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 
 	switch (event) {
 	case NETDEV_UNREGISTER:
@@ -3470,7 +3470,7 @@ static int bond_xmit_hash_policy_l2(stru
 
 static int bond_open(struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct timer_list *mii_timer = &bond->mii_timer;
 	struct timer_list *arp_timer = &bond->arp_timer;
 
@@ -3535,7 +3535,7 @@ static int bond_open(struct net_device *
 
 static int bond_close(struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 
 	if (bond->params.mode == BOND_MODE_8023AD) {
 		/* Unregister the receive of LACPDUs */
@@ -3591,7 +3591,7 @@ static int bond_close(struct net_device 
 
 static struct net_device_stats *bond_get_stats(struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct net_device_stats *stats = &(bond->stats), *sstats;
 	struct slave *slave;
 	int i;
@@ -3666,7 +3666,7 @@ static int bond_do_ioctl(struct net_devi
 		}
 
 		if (mii->reg_num == 1) {
-			struct bonding *bond = bond_dev->priv;
+			struct bonding *bond = netdev_priv(bond_dev);
 			mii->val_out = 0;
 			read_lock_bh(&bond->lock);
 			read_lock(&bond->curr_slave_lock);
@@ -3758,7 +3758,7 @@ static int bond_do_ioctl(struct net_devi
 
 static void bond_set_multicast_list(struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct dev_mc_list *dmi;
 
 	write_lock_bh(&bond->lock);
@@ -3811,7 +3811,7 @@ static void bond_set_multicast_list(stru
  */
 static int bond_change_mtu(struct net_device *bond_dev, int new_mtu)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave, *stop_at;
 	int res = 0;
 	int i;
@@ -3883,7 +3883,7 @@ unwind:
  */
 static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct sockaddr *sa = addr, tmp_sa;
 	struct slave *slave, *stop_at;
 	int res = 0;
@@ -3957,7 +3957,7 @@ unwind:
 
 static int bond_xmit_roundrobin(struct sk_buff *skb, struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave, *start_at;
 	int i;
 	int res = 1;
@@ -4007,7 +4007,7 @@ out:
  */
 static int bond_xmit_activebackup(struct sk_buff *skb, struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	int res = 1;
 
 	read_lock(&bond->lock);
@@ -4039,7 +4039,7 @@ out:
  */
 static int bond_xmit_xor(struct sk_buff *skb, struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave, *start_at;
 	int slave_no;
 	int i;
@@ -4085,7 +4085,7 @@ out:
  */
 static int bond_xmit_broadcast(struct sk_buff *skb, struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave, *start_at;
 	struct net_device *tx_dev = NULL;
 	int i;
@@ -4216,7 +4216,7 @@ static const struct ethtool_ops bond_eth
  */
 static int bond_init(struct net_device *bond_dev, struct bond_params *params)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 
 	dprintk("Begin bond_init for %s\n", bond_dev->name);
 
@@ -4291,7 +4291,7 @@ #endif
  */
 void bond_deinit(struct net_device *bond_dev)
 {
-	struct bonding *bond = bond_dev->priv;
+	struct bonding *bond = netdev_priv(bond_dev);
 
 	list_del(&bond->bond_list);
 
@@ -4685,12 +4685,12 @@ int bond_create(char *name, struct bond_
 	lockdep_set_class(&bond_dev->_xmit_lock, &bonding_netdev_xmit_lock_key);
 
 	if (newbond)
-		*newbond = bond_dev->priv;
+		*newbond = netdev_priv(bond_dev);
 
 	netif_carrier_off(bond_dev);
 
 	rtnl_unlock(); /* allows sysfs registration of net device */
-	res = bond_create_sysfs_entry(bond_dev->priv);
+	res = bond_create_sysfs_entry(netdev_priv(bond_dev));
 	if (res < 0) {
 		rtnl_lock();
 		goto out_bond;

