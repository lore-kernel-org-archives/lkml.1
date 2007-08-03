Return-Path: <linux-kernel-owner+w=401wt.eu-S1763738AbXHCRhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763738AbXHCRhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763676AbXHCRfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:35:47 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:37224 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763655AbXHCRfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:35:45 -0400
Date: Fri, 3 Aug 2007 19:34:19 +0200 (MEST)
Message-Id: <200708031734.TAA00777@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 06/13] dev->priv to netdev_priv(dev), for drivers/net/ibm_emac
Cc: ebs@ebshome.net, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
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
Cc: ebs@ebshome.net
Cc: akpm@linux-foundation.org
---

 drivers/net/ibm_emac/ibm_emac_core.c |   42 +++++++++++++++++------------------
 drivers/net/ibm_emac/ibm_emac_mal.c  |    2 -
 drivers/net/ibm_emac/ibm_emac_phy.c  |    2 -
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ibm_emac/ibm_emac_core.c b/drivers/net/ibm_emac/ibm_emac_core.c
index f752e5f..cefadc1 100644
--- a/drivers/net/ibm_emac/ibm_emac_core.c
+++ b/drivers/net/ibm_emac/ibm_emac_core.c
@@ -531,7 +531,7 @@ static void emac_reinitialize(struct ocp
 /* BHs disabled */
 static void emac_full_tx_reset(struct net_device *ndev)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	struct ocp_func_emac_data *emacdata = dev->def->additions;
 
 	DBG("%d: full_tx_reset" NL, dev->def->index);
@@ -639,7 +639,7 @@ static void __emac_mdio_write(struct ocp
 
 static int emac_mdio_read(struct net_device *ndev, int id, int reg)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	int res;
 
 	local_bh_disable();
@@ -651,7 +651,7 @@ static int emac_mdio_read(struct net_dev
 
 static void emac_mdio_write(struct net_device *ndev, int id, int reg, int val)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 
 	local_bh_disable();
 	__emac_mdio_write(dev->mdio_dev ? dev->mdio_dev : dev, (u8) id,
@@ -662,7 +662,7 @@ static void emac_mdio_write(struct net_d
 /* BHs disabled */
 static void emac_set_multicast_list(struct net_device *ndev)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	struct emac_regs __iomem *p = dev->emacp;
 	u32 rmr = emac_iff2rmr(ndev);
 
@@ -764,7 +764,7 @@ static int emac_resize_rx_ring(struct oc
 /* Process ctx, rtnl_lock semaphore */
 static int emac_change_mtu(struct net_device *ndev, int new_mtu)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	int ret = 0;
 
 	if (new_mtu < EMAC_MIN_MTU || new_mtu > EMAC_MAX_MTU)
@@ -857,7 +857,7 @@ static void emac_print_link_status(struc
 /* Process ctx, rtnl_lock semaphore */
 static int emac_open(struct net_device *ndev)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	struct ocp_func_emac_data *emacdata = dev->def->additions;
 	int err, i;
 
@@ -1005,7 +1005,7 @@ static void emac_force_link_update(struc
 /* Process ctx, rtnl_lock semaphore */
 static int emac_close(struct net_device *ndev)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	struct ocp_func_emac_data *emacdata = dev->def->additions;
 
 	DBG("%d: close" NL, dev->def->index);
@@ -1065,7 +1065,7 @@ static inline int emac_xmit_finish(struc
 /* BHs disabled */
 static int emac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	unsigned int len = skb->len;
 	int slot;
 
@@ -1123,7 +1123,7 @@ static inline int emac_xmit_split(struct
 /* BHs disabled (SG version for TAH equipped EMACs) */
 static int emac_start_xmit_sg(struct sk_buff *skb, struct net_device *ndev)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	int nr_frags = skb_shinfo(skb)->nr_frags;
 	int len = skb->len, chunk;
 	int slot, i;
@@ -1559,7 +1559,7 @@ static irqreturn_t emac_irq(int irq, voi
 
 static struct net_device_stats *emac_stats(struct net_device *ndev)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	struct ibm_emac_stats *st = &dev->stats;
 	struct ibm_emac_error_stats *est = &dev->estats;
 	struct net_device_stats *nst = &dev->nstats;
@@ -1647,7 +1647,7 @@ static struct mal_commac_ops emac_commac
 static int emac_ethtool_get_settings(struct net_device *ndev,
 				     struct ethtool_cmd *cmd)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 
 	cmd->supported = dev->phy.features;
 	cmd->port = PORT_MII;
@@ -1668,7 +1668,7 @@ static int emac_ethtool_get_settings(str
 static int emac_ethtool_set_settings(struct net_device *ndev,
 				     struct ethtool_cmd *cmd)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	u32 f = dev->phy.features;
 
 	DBG("%d: set_settings(%d, %d, %d, 0x%08x)" NL, dev->def->index,
@@ -1745,7 +1745,7 @@ static void emac_ethtool_get_ringparam(s
 static void emac_ethtool_get_pauseparam(struct net_device *ndev,
 					struct ethtool_pauseparam *pp)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 
 	local_bh_disable();
 	if ((dev->phy.features & SUPPORTED_Autoneg) &&
@@ -1763,7 +1763,7 @@ static void emac_ethtool_get_pauseparam(
 
 static u32 emac_ethtool_get_rx_csum(struct net_device *ndev)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	return dev->tah_dev != 0;
 }
 
@@ -1774,7 +1774,7 @@ static int emac_get_regs_len(struct ocp_
 
 static int emac_ethtool_get_regs_len(struct net_device *ndev)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	return sizeof(struct emac_ethtool_regs_hdr) +
 	    emac_get_regs_len(dev) + mal_get_regs_len(dev->mal) +
 	    zmii_get_regs_len(dev->zmii_dev) +
@@ -1795,7 +1795,7 @@ static void *emac_dump_regs(struct ocp_e
 static void emac_ethtool_get_regs(struct net_device *ndev,
 				  struct ethtool_regs *regs, void *buf)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	struct emac_ethtool_regs_hdr *hdr = buf;
 
 	hdr->components = 0;
@@ -1821,7 +1821,7 @@ static void emac_ethtool_get_regs(struct
 
 static int emac_ethtool_nway_reset(struct net_device *ndev)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	int res = 0;
 
 	DBG("%d: nway_reset" NL, dev->def->index);
@@ -1859,7 +1859,7 @@ static void emac_ethtool_get_ethtool_sta
 					   struct ethtool_stats *estats,
 					   u64 * tmp_stats)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	local_irq_disable();
 	memcpy(tmp_stats, &dev->stats, sizeof(dev->stats));
 	tmp_stats += sizeof(dev->stats) / sizeof(u64);
@@ -1870,7 +1870,7 @@ static void emac_ethtool_get_ethtool_sta
 static void emac_ethtool_get_drvinfo(struct net_device *ndev,
 				     struct ethtool_drvinfo *info)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 
 	strcpy(info->driver, "ibm_emac");
 	strcpy(info->version, DRV_VERSION);
@@ -1906,7 +1906,7 @@ static const struct ethtool_ops emac_eth
 
 static int emac_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 {
-	struct ocp_enet_private *dev = ndev->priv;
+	struct ocp_enet_private *dev = netdev_priv(ndev);
 	uint16_t *data = (uint16_t *) & rq->ifr_ifru;
 
 	DBG("%d: ioctl %08x" NL, dev->def->index, cmd);
@@ -1958,7 +1958,7 @@ static int __init emac_probe(struct ocp_
 		       ocpdev->def->index);
 		return -ENOMEM;
 	}
-	dev = ndev->priv;
+	dev = netdev_priv(ndev);
 	dev->ndev = ndev;
 	dev->ldev = &ocpdev->dev;
 	dev->def = ocpdev->def;
diff --git a/drivers/net/ibm_emac/ibm_emac_mal.c b/drivers/net/ibm_emac/ibm_emac_mal.c
index cabd984..861da9a 100644
--- a/drivers/net/ibm_emac/ibm_emac_mal.c
+++ b/drivers/net/ibm_emac/ibm_emac_mal.c
@@ -275,7 +275,7 @@ static irqreturn_t mal_rxde(int irq, voi
 
 static int mal_poll(struct net_device *ndev, int *budget)
 {
-	struct ibm_ocp_mal *mal = ndev->priv;
+	struct ibm_ocp_mal *mal = netdev_priv(ndev);
 	struct list_head *l;
 	int rx_work_limit = min(ndev->quota, *budget), received = 0, done;
 
diff --git a/drivers/net/ibm_emac/ibm_emac_phy.c b/drivers/net/ibm_emac/ibm_emac_phy.c
index e57862b..fa39e6c 100644
--- a/drivers/net/ibm_emac/ibm_emac_phy.c
+++ b/drivers/net/ibm_emac/ibm_emac_phy.c
@@ -59,7 +59,7 @@ static int mii_spin_reset_complete(struc
 
 	if (net_ratelimit())
 		printk(KERN_ERR "emac%d: PHY reset timeout (%d)\n", 
-		       ((struct ocp_enet_private *)phy->dev->priv)->def->index,
+		       ((struct ocp_enet_private *)netdev_priv(phy->dev))->def->index,
 		       val);
 	return val;		    
 }

