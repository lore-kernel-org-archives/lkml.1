Return-Path: <linux-kernel-owner+w=401wt.eu-S1764290AbXHCRid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764290AbXHCRid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764104AbXHCRiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:38:07 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:37403 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763675AbXHCRiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:38:05 -0400
Date: Fri, 3 Aug 2007 19:36:39 +0200 (MEST)
Message-Id: <200708031736.TAA00857@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 10/13] dev->priv to netdev_priv(dev), for drivers/net/tulip
Cc: val@nmt.edu, tulip-users@lists.sourceforge.net, akpm@linux-foundation.org,
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
Cc: val@nmt.edu
Cc: tulip-users@lists.sourceforge.net
Cc: akpm@linux-foundation.org
---

 drivers/net/tulip/de2104x.c |   44 ++++++++++++++++++++++----------------------
 drivers/net/tulip/eeprom.c  |    2 +-
 drivers/net/tulip/uli526x.c |    2 +-
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/tulip/de2104x.c b/drivers/net/tulip/de2104x.c
index d380e0b..4ba3a7b 100644
--- a/drivers/net/tulip/de2104x.c
+++ b/drivers/net/tulip/de2104x.c
@@ -486,7 +486,7 @@ rx_next:
 static irqreturn_t de_interrupt (int irq, void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 	u32 status;
 
 	status = dr32(MacStatus);
@@ -592,7 +592,7 @@ next:
 
 static int de_start_xmit (struct sk_buff *skb, struct net_device *dev)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 	unsigned int entry, tx_free;
 	u32 mapping, len, flags = FirstFrag | LastFrag;
 	struct de_desc *txd;
@@ -655,7 +655,7 @@ #define set_bit_le(i,p) do { ((char *)(p
 
 static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 	u16 hash_table[32];
 	struct dev_mc_list *mclist;
 	int i;
@@ -686,7 +686,7 @@ static void build_setup_frame_hash(u16 *
 
 static void build_setup_frame_perfect(u16 *setup_frm, struct net_device *dev)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 	struct dev_mc_list *mclist;
 	int i;
 	u16 *eaddrs;
@@ -714,7 +714,7 @@ static void build_setup_frame_perfect(u1
 
 static void __de_set_rx_mode (struct net_device *dev)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 	u32 macmode;
 	unsigned int entry;
 	u32 mapping;
@@ -799,7 +799,7 @@ out:
 static void de_set_rx_mode (struct net_device *dev)
 {
 	unsigned long flags;
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 
 	spin_lock_irqsave (&de->lock, flags);
 	__de_set_rx_mode(dev);
@@ -823,7 +823,7 @@ static void __de_get_stats(struct de_pri
 
 static struct net_device_stats *de_get_stats(struct net_device *dev)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 
 	/* The chip only need report frame silently dropped. */
 	spin_lock_irq(&de->lock);
@@ -1352,7 +1352,7 @@ static void de_free_rings (struct de_pri
 
 static int de_open (struct net_device *dev)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 	int rc;
 
 	if (netif_msg_ifup(de))
@@ -1397,7 +1397,7 @@ err_out_free:
 
 static int de_close (struct net_device *dev)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 	unsigned long flags;
 
 	if (netif_msg_ifdown(de))
@@ -1421,7 +1421,7 @@ static int de_close (struct net_device *
 
 static void de_tx_timeout (struct net_device *dev)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 
 	printk(KERN_DEBUG "%s: NIC status %08x mode %08x sia %08x desc %u/%u/%u\n",
 	       dev->name, dr32(MacStatus), dr32(MacMode), dr32(SIAStatus),
@@ -1572,7 +1572,7 @@ static int __de_set_settings(struct de_p
 
 static void de_get_drvinfo (struct net_device *dev,struct ethtool_drvinfo *info)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 
 	strcpy (info->driver, DRV_NAME);
 	strcpy (info->version, DRV_VERSION);
@@ -1587,7 +1587,7 @@ static int de_get_regs_len(struct net_de
 
 static int de_get_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 	int rc;
 
 	spin_lock_irq(&de->lock);
@@ -1599,7 +1599,7 @@ static int de_get_settings(struct net_de
 
 static int de_set_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 	int rc;
 
 	spin_lock_irq(&de->lock);
@@ -1611,14 +1611,14 @@ static int de_set_settings(struct net_de
 
 static u32 de_get_msglevel(struct net_device *dev)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 
 	return de->msg_enable;
 }
 
 static void de_set_msglevel(struct net_device *dev, u32 msglvl)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 
 	de->msg_enable = msglvl;
 }
@@ -1626,7 +1626,7 @@ static void de_set_msglevel(struct net_d
 static int de_get_eeprom(struct net_device *dev,
 			 struct ethtool_eeprom *eeprom, u8 *data)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 
 	if (!de->ee_data)
 		return -EOPNOTSUPP;
@@ -1640,7 +1640,7 @@ static int de_get_eeprom(struct net_devi
 
 static int de_nway_reset(struct net_device *dev)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 	u32 status;
 
 	if (de->media_type != DE_MEDIA_TP_AUTO)
@@ -1659,7 +1659,7 @@ static int de_nway_reset(struct net_devi
 static void de_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 			void *data)
 {
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 
 	regs->version = (DE_REGS_VER << 2) | de->de21040;
 
@@ -1955,7 +1955,7 @@ #endif
 	dev->tx_timeout = de_tx_timeout;
 	dev->watchdog_timeo = TX_TIMEOUT;
 
-	de = dev->priv;
+	de = netdev_priv(dev);
 	de->de21040 = ent->driver_data == 0 ? 1 : 0;
 	de->pdev = pdev;
 	de->dev = dev;
@@ -2081,7 +2081,7 @@ err_out_free:
 static void __devexit de_remove_one (struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 
 	BUG_ON(!dev);
 	unregister_netdev(dev);
@@ -2098,7 +2098,7 @@ #ifdef CONFIG_PM
 static int de_suspend (struct pci_dev *pdev, pm_message_t state)
 {
 	struct net_device *dev = pci_get_drvdata (pdev);
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 
 	rtnl_lock();
 	if (netif_running (dev)) {
@@ -2133,7 +2133,7 @@ static int de_suspend (struct pci_dev *p
 static int de_resume (struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata (pdev);
-	struct de_private *de = dev->priv;
+	struct de_private *de = netdev_priv(dev);
 	int retval = 0;
 
 	rtnl_lock();
diff --git a/drivers/net/tulip/eeprom.c b/drivers/net/tulip/eeprom.c
index 206918b..d592965 100644
--- a/drivers/net/tulip/eeprom.c
+++ b/drivers/net/tulip/eeprom.c
@@ -339,7 +339,7 @@ int __devinit tulip_read_eeprom(struct n
 {
 	int i;
 	unsigned retval = 0;
-	struct tulip_private *tp = dev->priv;
+	struct tulip_private *tp = netdev_priv(dev);
 	void __iomem *ee_addr = tp->base_addr + CSR9;
 	int read_cmd = location | (EE_READ_CMD << addr_len);
 
diff --git a/drivers/net/tulip/uli526x.c b/drivers/net/tulip/uli526x.c
index ca2548e..3956b0d 100644
--- a/drivers/net/tulip/uli526x.c
+++ b/drivers/net/tulip/uli526x.c
@@ -875,7 +875,7 @@ static struct net_device_stats * uli526x
 
 static void uli526x_set_filter_mode(struct net_device * dev)
 {
-	struct uli526x_board_info *db = dev->priv;
+	struct uli526x_board_info *db = netdev_priv(dev);
 	unsigned long flags;
 
 	ULI526X_DBUG(0, "uli526x_set_filter_mode()", 0);

