Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbXE3POP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbXE3POP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbXE3PN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:13:57 -0400
Received: from havoc.gtf.org ([69.61.125.42]:40717 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbXE3PNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:13:55 -0400
Date: Wed, 30 May 2007 11:13:54 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] net driver fixes
Message-ID: <20070530151354.GA13299@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git upstream-linus

to receive the following updates:

 drivers/net/defxx.c                             |    1 +
 drivers/net/e1000/e1000_main.c                  |    9 +++++++-
 drivers/net/ehea/ehea.h                         |    2 +-
 drivers/net/ehea/ehea_main.c                    |    2 +-
 drivers/net/sky2.c                              |    6 ++--
 drivers/net/sky2.h                              |   24 +----------------------
 drivers/net/wireless/hostap/hostap_80211_tx.c   |   13 +++++++----
 drivers/net/wireless/prism54/islpci_eth.c       |    5 ++-
 net/ieee80211/ieee80211_module.c                |    2 +-
 net/ieee80211/softmac/ieee80211softmac_module.c |    5 +++-
 10 files changed, 31 insertions(+), 38 deletions(-)

Akinobu Mita (2):
      ieee80211: fix incomplete error message
      softmac: alloc_ieee80211() NULL check

Björn Steinbrink (1):
      prism54: fix monitor mode oops

Brandon Craig Rhodes (1):
      hostap: Allocate enough tailroom for TKIP

Herbert Xu (1):
      e1000: restore netif_poll_enable call but make sure IRQs are off

Maciej W. Rozycki (1):
      defxx: Fix the handling of ioremap() failures

Stephen Hemminger (4):
      sky2: dont set bogus bit in PHY register
      sky2: checksum offload plus vlan bug
      sky2: program proper register for fiber PHY
      sky2: enable IRQ on duplex renegotiation

Thomas Klein (1):
      ehea: Fixed multi queue RX bug

diff --git a/drivers/net/defxx.c b/drivers/net/defxx.c
index 571d82f..7df23dc 100644
--- a/drivers/net/defxx.c
+++ b/drivers/net/defxx.c
@@ -566,6 +566,7 @@ static int __devinit dfx_register(struct device *bdev)
 		bp->base.mem = ioremap_nocache(bar_start, bar_len);
 		if (!bp->base.mem) {
 			printk(KERN_ERR "%s: Cannot map MMIO\n", print_name);
+			err = -ENOMEM;
 			goto err_out_region;
 		}
 	} else {
diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
index cbc7feb..9ec35b7 100644
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -1325,7 +1325,10 @@ e1000_sw_init(struct e1000_adapter *adapter)
 	spin_lock_init(&adapter->tx_queue_lock);
 #endif
 
-	atomic_set(&adapter->irq_sem, 1);
+	/* Explicitly disable IRQ since the NIC can be in any state. */
+	atomic_set(&adapter->irq_sem, 0);
+	e1000_irq_disable(adapter);
+
 	spin_lock_init(&adapter->stats_lock);
 
 	set_bit(__E1000_DOWN, &adapter->flags);
@@ -1431,6 +1434,10 @@ e1000_open(struct net_device *netdev)
 	/* From here on the code is the same as e1000_up() */
 	clear_bit(__E1000_DOWN, &adapter->flags);
 
+#ifdef CONFIG_E1000_NAPI
+	netif_poll_enable(netdev);
+#endif
+
 	e1000_irq_enable(adapter);
 
 	/* fire a link status change interrupt to start the watchdog */
diff --git a/drivers/net/ehea/ehea.h b/drivers/net/ehea/ehea.h
index 602872d..e85a933 100644
--- a/drivers/net/ehea/ehea.h
+++ b/drivers/net/ehea/ehea.h
@@ -39,7 +39,7 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"ehea"
-#define DRV_VERSION	"EHEA_0058"
+#define DRV_VERSION	"EHEA_0061"
 
 #define EHEA_MSG_DEFAULT (NETIF_MSG_LINK | NETIF_MSG_TIMER \
 	| NETIF_MSG_RX_ERR | NETIF_MSG_TX_ERR)
diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index f6e0cb1..152bb20 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -428,7 +428,7 @@ static struct ehea_cqe *ehea_proc_rwqes(struct net_device *dev,
 				}
 				skb_copy_to_linear_data(skb, ((char*)cqe) + 64,
 					       cqe->num_bytes_transfered - 4);
-				ehea_fill_skb(dev, skb, cqe);
+				ehea_fill_skb(port->netdev, skb, cqe);
 			} else if (rq == 2) {  /* RQ2 */
 				skb = get_skb_by_index(skb_arr_rq2,
 						       skb_arr_rq2_len, cqe);
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 832fd69..adfbe81 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -364,7 +364,7 @@ static void sky2_phy_init(struct sky2_hw *hw, unsigned port)
 			/* for SFP-module set SIGDET polarity to low */
 			ctrl = gm_phy_read(hw, port, PHY_MARV_PHY_CTRL);
 			ctrl |= PHY_M_FIB_SIGD_POL;
-			gm_phy_write(hw, port, PHY_MARV_CTRL, ctrl);
+			gm_phy_write(hw, port, PHY_MARV_PHY_CTRL, ctrl);
 		}
 
 		gm_phy_write(hw, port, PHY_MARV_EXT_ADR, pg);
@@ -658,7 +658,7 @@ static void sky2_mac_init(struct sky2_hw *hw, unsigned port)
 	const u8 *addr = hw->dev[port]->dev_addr;
 
 	sky2_write32(hw, SK_REG(port, GPHY_CTRL), GPC_RST_SET);
-	sky2_write32(hw, SK_REG(port, GPHY_CTRL), GPC_RST_CLR|GPC_ENA_PAUSE);
+	sky2_write32(hw, SK_REG(port, GPHY_CTRL), GPC_RST_CLR);
 
 	sky2_write8(hw, SK_REG(port, GMAC_CTRL), GMC_RST_CLR);
 
@@ -1432,7 +1432,7 @@ static int sky2_xmit_frame(struct sk_buff *skb, struct net_device *dev)
 		tcpsum = offset << 16;		/* sum start */
 		tcpsum |= offset + skb->csum_offset;	/* sum write */
 
-		ctrl = CALSUM | WR_SUM | INIT_SUM | LOCK_SUM;
+		ctrl |= CALSUM | WR_SUM | INIT_SUM | LOCK_SUM;
 		if (ip_hdr(skb)->protocol == IPPROTO_UDP)
 			ctrl |= UDPTCP;
 
diff --git a/drivers/net/sky2.h b/drivers/net/sky2.h
index 5efb5af..b8c4a3b 100644
--- a/drivers/net/sky2.h
+++ b/drivers/net/sky2.h
@@ -1149,7 +1149,7 @@ enum {
 	PHY_M_IS_JABBER		= 1<<0, /* Jabber */
 
 	PHY_M_DEF_MSK		= PHY_M_IS_LSP_CHANGE | PHY_M_IS_LST_CHANGE
-				 | PHY_M_IS_FIFO_ERROR,
+				 | PHY_M_IS_DUP_CHANGE,
 	PHY_M_AN_MSK	       = PHY_M_IS_AN_ERROR | PHY_M_IS_AN_COMPL,
 };
 
@@ -1732,28 +1732,6 @@ enum {
 
 /*	GPHY_CTRL		32 bit	GPHY Control Reg (YUKON only) */
 enum {
-	GPC_SEL_BDT	= 1<<28, /* Select Bi-Dir. Transfer for MDC/MDIO */
-	GPC_INT_POL_HI	= 1<<27, /* IRQ Polarity is Active HIGH */
-	GPC_75_OHM	= 1<<26, /* Use 75 Ohm Termination instead of 50 */
-	GPC_DIS_FC	= 1<<25, /* Disable Automatic Fiber/Copper Detection */
-	GPC_DIS_SLEEP	= 1<<24, /* Disable Energy Detect */
-	GPC_HWCFG_M_3	= 1<<23, /* HWCFG_MODE[3] */
-	GPC_HWCFG_M_2	= 1<<22, /* HWCFG_MODE[2] */
-	GPC_HWCFG_M_1	= 1<<21, /* HWCFG_MODE[1] */
-	GPC_HWCFG_M_0	= 1<<20, /* HWCFG_MODE[0] */
-	GPC_ANEG_0	= 1<<19, /* ANEG[0] */
-	GPC_ENA_XC	= 1<<18, /* Enable MDI crossover */
-	GPC_DIS_125	= 1<<17, /* Disable 125 MHz clock */
-	GPC_ANEG_3	= 1<<16, /* ANEG[3] */
-	GPC_ANEG_2	= 1<<15, /* ANEG[2] */
-	GPC_ANEG_1	= 1<<14, /* ANEG[1] */
-	GPC_ENA_PAUSE	= 1<<13, /* Enable Pause (SYM_OR_REM) */
-	GPC_PHYADDR_4	= 1<<12, /* Bit 4 of Phy Addr */
-	GPC_PHYADDR_3	= 1<<11, /* Bit 3 of Phy Addr */
-	GPC_PHYADDR_2	= 1<<10, /* Bit 2 of Phy Addr */
-	GPC_PHYADDR_1	= 1<<9,	 /* Bit 1 of Phy Addr */
-	GPC_PHYADDR_0	= 1<<8,	 /* Bit 0 of Phy Addr */
-						/* Bits  7..2:	reserved */
 	GPC_RST_CLR	= 1<<1,	/* Clear GPHY Reset */
 	GPC_RST_SET	= 1<<0,	/* Set   GPHY Reset */
 };
diff --git a/drivers/net/wireless/hostap/hostap_80211_tx.c b/drivers/net/wireless/hostap/hostap_80211_tx.c
index 246fac0..3df3c60 100644
--- a/drivers/net/wireless/hostap/hostap_80211_tx.c
+++ b/drivers/net/wireless/hostap/hostap_80211_tx.c
@@ -311,7 +311,7 @@ static struct sk_buff * hostap_tx_encrypt(struct sk_buff *skb,
 	local_info_t *local;
 	struct ieee80211_hdr_4addr *hdr;
 	u16 fc;
-	int hdr_len, res;
+	int prefix_len, postfix_len, hdr_len, res;
 
 	iface = netdev_priv(skb->dev);
 	local = iface->local;
@@ -337,10 +337,13 @@ static struct sk_buff * hostap_tx_encrypt(struct sk_buff *skb,
 	if (skb == NULL)
 		return NULL;
 
-	if ((skb_headroom(skb) < crypt->ops->extra_mpdu_prefix_len ||
-	     skb_tailroom(skb) < crypt->ops->extra_mpdu_postfix_len) &&
-	    pskb_expand_head(skb, crypt->ops->extra_mpdu_prefix_len,
-			     crypt->ops->extra_mpdu_postfix_len, GFP_ATOMIC)) {
+	prefix_len = crypt->ops->extra_mpdu_prefix_len +
+		crypt->ops->extra_msdu_prefix_len;
+	postfix_len = crypt->ops->extra_mpdu_postfix_len +
+		crypt->ops->extra_msdu_postfix_len;
+	if ((skb_headroom(skb) < prefix_len ||
+	     skb_tailroom(skb) < postfix_len) &&
+	    pskb_expand_head(skb, prefix_len, postfix_len, GFP_ATOMIC)) {
 		kfree_skb(skb);
 		return NULL;
 	}
diff --git a/drivers/net/wireless/prism54/islpci_eth.c b/drivers/net/wireless/prism54/islpci_eth.c
index dd070cc..f49eb06 100644
--- a/drivers/net/wireless/prism54/islpci_eth.c
+++ b/drivers/net/wireless/prism54/islpci_eth.c
@@ -378,9 +378,10 @@ islpci_eth_receive(islpci_private *priv)
 	display_buffer((char *) skb->data, skb->len);
 #endif
 	/* take care of monitor mode and spy monitoring. */
-	if (unlikely(priv->iw_mode == IW_MODE_MONITOR))
+	if (unlikely(priv->iw_mode == IW_MODE_MONITOR)) {
+		skb->dev = ndev;
 		discard = islpci_monitor_rx(priv, &skb);
-	else {
+	} else {
 		if (unlikely(skb->data[2 * ETH_ALEN] == 0)) {
 			/* The packet has a rx_annex. Read it for spy monitoring, Then
 			 * remove it, while keeping the 2 leading MAC addr.
diff --git a/net/ieee80211/ieee80211_module.c b/net/ieee80211/ieee80211_module.c
index 7ec6610..17ad278 100644
--- a/net/ieee80211/ieee80211_module.c
+++ b/net/ieee80211/ieee80211_module.c
@@ -140,7 +140,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 
 	dev = alloc_etherdev(sizeof(struct ieee80211_device) + sizeof_priv);
 	if (!dev) {
-		IEEE80211_ERROR("Unable to network device.\n");
+		IEEE80211_ERROR("Unable to allocate network device.\n");
 		goto failed;
 	}
 	ieee = netdev_priv(dev);
diff --git a/net/ieee80211/softmac/ieee80211softmac_module.c b/net/ieee80211/softmac/ieee80211softmac_module.c
index e9cdc66..c308756 100644
--- a/net/ieee80211/softmac/ieee80211softmac_module.c
+++ b/net/ieee80211/softmac/ieee80211softmac_module.c
@@ -33,7 +33,10 @@ struct net_device *alloc_ieee80211softmac(int sizeof_priv)
 	struct ieee80211softmac_device *softmac;
 	struct net_device *dev;
 
-	dev = alloc_ieee80211(sizeof(struct ieee80211softmac_device) + sizeof_priv);
+	dev = alloc_ieee80211(sizeof(*softmac) + sizeof_priv);
+	if (!dev)
+		return NULL;
+
 	softmac = ieee80211_priv(dev);
 	softmac->dev = dev;
 	softmac->ieee = netdev_priv(dev);
