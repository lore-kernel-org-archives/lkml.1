Return-Path: <linux-kernel-owner+w=401wt.eu-S1764961AbXIMFae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764961AbXIMFae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 01:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbXIMFaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 01:30:25 -0400
Received: from havoc.gtf.org ([69.61.125.42]:50743 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbXIMFaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 01:30:23 -0400
Date: Thu, 13 Sep 2007 01:30:22 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] net driver fixes
Message-ID: <20070913053022.GA16891@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git upstream-linus

to receive the following updates:

 drivers/net/atl1/atl1_main.c |   19 +++++++------------
 drivers/net/ehea/ehea.h      |    5 ++++-
 drivers/net/ehea/ehea_main.c |   16 ++++++++++++++--
 drivers/net/phy/phy.c        |    4 ++--
 drivers/net/phy/phy_device.c |    4 ++--
 drivers/net/sky2.c           |    9 ++++++++-
 drivers/net/spider_net.c     |   12 ++++--------
 7 files changed, 41 insertions(+), 28 deletions(-)

Hans-Jürgen Koch (1):
      Fix a lock problem in generic phy code

Ishizaki Kou (1):
      spidernet: fix interrupt reason recognition

Jan-Bernd Themann (2):
      ehea: propagate physical port state
      ehea: fix last_rx update

Luca Tettamanti (1):
      atl1: disable broken 64-bit DMA

Stephen Hemminger (1):
      sky2: restore multicast list on resume and other ops

diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
index 3c1984e..f23e13c 100644
--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -2203,21 +2203,20 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 	struct net_device *netdev;
 	struct atl1_adapter *adapter;
 	static int cards_found = 0;
-	bool pci_using_64 = true;
 	int err;
 
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;
 
-	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
+	/*
+	 * 64-bit DMA currently has data corruption problems, so let's just
+	 * use 32-bit DMA for now.  This is a big hack that is probably wrong.
+	 */
+	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 	if (err) {
-		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
-		if (err) {
-			dev_err(&pdev->dev, "no usable DMA configuration\n");
-			goto err_dma;
-		}
-		pci_using_64 = false;
+		dev_err(&pdev->dev, "no usable DMA configuration\n");
+		goto err_dma;
 	}
 	/* Mark all PCI regions associated with PCI device
 	 * pdev as being reserved by owner atl1_driver_name
@@ -2282,7 +2281,6 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 
 	netdev->ethtool_ops = &atl1_ethtool_ops;
 	adapter->bd_number = cards_found;
-	adapter->pci_using_64 = pci_using_64;
 
 	/* setup the private structure */
 	err = atl1_sw_init(adapter);
@@ -2299,9 +2297,6 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 	 */
 	/* netdev->features |= NETIF_F_TSO; */
 
-	if (pci_using_64)
-		netdev->features |= NETIF_F_HIGHDMA;
-
 	netdev->features |= NETIF_F_LLTX;
 
 	/*
diff --git a/drivers/net/ehea/ehea.h b/drivers/net/ehea/ehea.h
index d67f97b..8d58be5 100644
--- a/drivers/net/ehea/ehea.h
+++ b/drivers/net/ehea/ehea.h
@@ -39,7 +39,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0073"
+#define DRV_VERSION	"EHEA_0074"
 
 /* eHEA capability flags */
 #define DLPAR_PORT_ADD_REM 1
@@ -402,6 +402,8 @@ struct ehea_mc_list {
 
 #define EHEA_PORT_UP 1
 #define EHEA_PORT_DOWN 0
+#define EHEA_PHY_LINK_UP 1
+#define EHEA_PHY_LINK_DOWN 0
 #define EHEA_MAX_PORT_RES 16
 struct ehea_port {
 	struct ehea_adapter *adapter;	 /* adapter that owns this port */
@@ -427,6 +429,7 @@ struct ehea_port {
 	u32 msg_enable;
 	u32 sig_comp_iv;
 	u32 state;
+	u8 phy_link;
 	u8 full_duplex;
 	u8 autoneg;
 	u8 num_def_qps;
diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index db57474..717b129 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -53,17 +53,21 @@ static int rq3_entries = EHEA_DEF_ENTRIES_RQ3;
 static int sq_entries = EHEA_DEF_ENTRIES_SQ;
 static int use_mcs = 0;
 static int num_tx_qps = EHEA_NUM_TX_QP;
+static int prop_carrier_state = 0;
 
 module_param(msg_level, int, 0);
 module_param(rq1_entries, int, 0);
 module_param(rq2_entries, int, 0);
 module_param(rq3_entries, int, 0);
 module_param(sq_entries, int, 0);
+module_param(prop_carrier_state, int, 0);
 module_param(use_mcs, int, 0);
 module_param(num_tx_qps, int, 0);
 
 MODULE_PARM_DESC(num_tx_qps, "Number of TX-QPS");
 MODULE_PARM_DESC(msg_level, "msg_level");
+MODULE_PARM_DESC(prop_carrier_state, "Propagate carrier state of physical "
+		 "port to stack. 1:yes, 0:no.  Default = 0 ");
 MODULE_PARM_DESC(rq3_entries, "Number of entries for Receive Queue 3 "
 		 "[2^x - 1], x = [6..14]. Default = "
 		 __MODULE_STRING(EHEA_DEF_ENTRIES_RQ3) ")");
@@ -467,7 +471,7 @@ static struct ehea_cqe *ehea_proc_rwqes(struct net_device *dev,
 			else
 				netif_receive_skb(skb);
 
-			dev->last_rx = jiffies;
+			port->netdev->last_rx = jiffies;
 		} else {
 			pr->p_stats.poll_receive_errors++;
 			port_reset = ehea_treat_poll_error(pr, rq, cqe,
@@ -814,7 +818,9 @@ int ehea_set_portspeed(struct ehea_port *port, u32 port_speed)
 			ehea_error("Failed setting port speed");
 		}
 	}
-	netif_carrier_on(port->netdev);
+	if (!prop_carrier_state || (port->phy_link == EHEA_PHY_LINK_UP))
+		netif_carrier_on(port->netdev);
+
 	kfree(cb4);
 out:
 	return ret;
@@ -869,13 +875,19 @@ static void ehea_parse_eqe(struct ehea_adapter *adapter, u64 eqe)
 			}
 
 		if (EHEA_BMASK_GET(NEQE_EXTSWITCH_PORT_UP, eqe)) {
+			port->phy_link = EHEA_PHY_LINK_UP;
 			if (netif_msg_link(port))
 				ehea_info("%s: Physical port up",
 					  port->netdev->name);
+			if (prop_carrier_state)
+				netif_carrier_on(port->netdev);
 		} else {
+			port->phy_link = EHEA_PHY_LINK_DOWN;
 			if (netif_msg_link(port))
 				ehea_info("%s: Physical port down",
 					  port->netdev->name);
+			if (prop_carrier_state)
+				netif_carrier_off(port->netdev);
 		}
 
 		if (EHEA_BMASK_GET(NEQE_EXTSWITCH_PRIMARY, eqe))
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e323efd..0cc4369 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -755,7 +755,7 @@ out_unlock:
  */
 void phy_start(struct phy_device *phydev)
 {
-	spin_lock(&phydev->lock);
+	spin_lock_bh(&phydev->lock);
 
 	switch (phydev->state) {
 		case PHY_STARTING:
@@ -769,7 +769,7 @@ void phy_start(struct phy_device *phydev)
 		default:
 			break;
 	}
-	spin_unlock(&phydev->lock);
+	spin_unlock_bh(&phydev->lock);
 }
 EXPORT_SYMBOL(phy_stop);
 EXPORT_SYMBOL(phy_start);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index e275df8..49328e0 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -644,7 +644,7 @@ static int phy_probe(struct device *dev)
 	if (!(phydrv->flags & PHY_HAS_INTERRUPT))
 		phydev->irq = PHY_POLL;
 
-	spin_lock(&phydev->lock);
+	spin_lock_bh(&phydev->lock);
 
 	/* Start out supporting everything. Eventually,
 	 * a controller will attach, and may modify one
@@ -658,7 +658,7 @@ static int phy_probe(struct device *dev)
 	if (phydev->drv->probe)
 		err = phydev->drv->probe(phydev);
 
-	spin_unlock(&phydev->lock);
+	spin_unlock_bh(&phydev->lock);
 
 	return err;
 
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index e6d937e..5d812de 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -149,6 +149,8 @@ static const char *yukon2_name[] = {
 	"FE",		/* 0xb7 */
 };
 
+static void sky2_set_multicast(struct net_device *dev);
+
 /* Access to external PHY */
 static int gm_phy_write(struct sky2_hw *hw, unsigned port, u16 reg, u16 val)
 {
@@ -2900,8 +2902,10 @@ static int sky2_set_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
 	sky2->autoneg = ecmd->autoneg;
 	sky2->advertising = ecmd->advertising;
 
-	if (netif_running(dev))
+	if (netif_running(dev)) {
 		sky2_phy_reinit(sky2);
+		sky2_set_multicast(dev);
+	}
 
 	return 0;
 }
@@ -2994,6 +2998,7 @@ static int sky2_nway_reset(struct net_device *dev)
 		return -EINVAL;
 
 	sky2_phy_reinit(sky2);
+	sky2_set_multicast(dev);
 
 	return 0;
 }
@@ -4171,6 +4176,8 @@ static int sky2_resume(struct pci_dev *pdev)
 				dev_close(dev);
 				goto out;
 			}
+
+			sky2_set_multicast(dev);
 		}
 	}
 
diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index 590b12c..82d837a 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -1441,17 +1441,14 @@ static void
 spider_net_handle_error_irq(struct spider_net_card *card, u32 status_reg)
 {
 	u32 error_reg1, error_reg2;
-	u32 mask_reg1, mask_reg2;
 	u32 i;
 	int show_error = 1;
 
 	error_reg1 = spider_net_read_reg(card, SPIDER_NET_GHIINT1STS);
 	error_reg2 = spider_net_read_reg(card, SPIDER_NET_GHIINT2STS);
-	mask_reg1 = spider_net_read_reg(card, SPIDER_NET_GHIINT1MSK);
-	mask_reg2 = spider_net_read_reg(card,SPIDER_NET_GHIINT2MSK);
 
-	error_reg1 &= mask_reg1;
-	error_reg2 &= mask_reg2;
+	error_reg1 &= SPIDER_NET_INT1_MASK_VALUE;
+	error_reg2 &= SPIDER_NET_INT2_MASK_VALUE;
 
 	/* check GHIINT0STS ************************************/
 	if (status_reg)
@@ -1679,11 +1676,10 @@ spider_net_interrupt(int irq, void *ptr)
 {
 	struct net_device *netdev = ptr;
 	struct spider_net_card *card = netdev_priv(netdev);
-	u32 status_reg, mask_reg;
+	u32 status_reg;
 
 	status_reg = spider_net_read_reg(card, SPIDER_NET_GHIINT0STS);
-	mask_reg = spider_net_read_reg(card, SPIDER_NET_GHIINT0MSK);
-	status_reg &= mask_reg;
+	status_reg &= SPIDER_NET_INT0_MASK_VALUE;
 
 	if (!status_reg)
 		return IRQ_NONE;
