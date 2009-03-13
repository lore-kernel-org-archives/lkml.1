Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbZCMR65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbZCMR65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbZCMR6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:58:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41661 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbZCMR6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:58:45 -0400
Date: Fri, 13 Mar 2009 18:58:35 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ivecera@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
       netdev@vger.kernel.org
Subject: [PATCH] 8139too: allow to set mac address on running device
Message-ID: <20090313175834.GE3436@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar patch as for 8139cp posted yesterday, so the same comment:

So far there was not a chance to set a mac address on running 8139too device.
This is for example needed when you want to use this NIC as a bonding slave in
bonding device in mode balance-alb. This simple patch allows it.

Jirka

Signed-off-by: Jiri Pirko <jpirko@redhat.com>

 drivers/net/8139too.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
index a5b2420..0fbd4bc 100644
--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -640,6 +640,7 @@ static int rtl8139_start_xmit (struct sk_buff *skb,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void rtl8139_poll_controller(struct net_device *dev);
 #endif
+static int rtl8139_set_mac_address(struct net_device *dev, void *p);
 static int rtl8139_poll(struct napi_struct *napi, int budget);
 static irqreturn_t rtl8139_interrupt (int irq, void *dev_instance);
 static int rtl8139_close (struct net_device *dev);
@@ -917,7 +918,7 @@ static const struct net_device_ops rtl8139_netdev_ops = {
 	.ndo_stop		= rtl8139_close,
 	.ndo_get_stats		= rtl8139_get_stats,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_set_mac_address 	= rtl8139_set_mac_address,
 	.ndo_start_xmit		= rtl8139_start_xmit,
 	.ndo_set_multicast_list	= rtl8139_set_rx_mode,
 	.ndo_do_ioctl		= netdev_ioctl,
@@ -2215,6 +2216,29 @@ static void rtl8139_poll_controller(struct net_device *dev)
 }
 #endif
 
+static int rtl8139_set_mac_address(struct net_device *dev, void *p)
+{
+	struct rtl8139_private *tp = netdev_priv(dev);
+	void __iomem *ioaddr = tp->mmio_addr;
+	struct sockaddr *addr = p;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+
+	spin_lock_irq(&tp->lock);
+
+	RTL_W8_F(Cfg9346, Cfg9346_Unlock);
+	RTL_W32_F(MAC0 + 0, cpu_to_le32 (*(u32 *) (dev->dev_addr + 0)));
+	RTL_W32_F(MAC0 + 4, cpu_to_le32 (*(u32 *) (dev->dev_addr + 4)));
+	RTL_W8_F(Cfg9346, Cfg9346_Lock);
+
+	spin_unlock_irq(&tp->lock);
+
+	return 0;
+}
+
 static int rtl8139_close (struct net_device *dev)
 {
 	struct rtl8139_private *tp = netdev_priv(dev);
