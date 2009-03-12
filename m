Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbZCLQ1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbZCLQ1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbZCLQ1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:27:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60170 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989AbZCLQ1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:27:38 -0400
Date: Thu, 12 Mar 2009 17:27:31 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ivecera@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
       netdev@vger.kernel.org
Subject: [PATCH] 8139cp: allow to set mac address on running device
Message-ID: <20090312162730.GA20153@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far there was not a chance to set a mac address on running 8139cp device.
This is for example needed when you want to use this NIC as a bonding slave in
bonding device in mode balance-alb. This simple patch allows it.

Jirka


Signed-off-by: Jiri Pirko <jpirko@redhat.com>

 drivers/net/8139cp.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/net/8139cp.c b/drivers/net/8139cp.c
index 4e19ae3..13b708a 100644
--- a/drivers/net/8139cp.c
+++ b/drivers/net/8139cp.c
@@ -1602,6 +1602,28 @@ static int cp_ioctl (struct net_device *dev, struct ifreq *rq, int cmd)
 	return rc;
 }
 
+static int cp_set_mac_address(struct net_device *dev, void *p)
+{
+	struct cp_private *cp = netdev_priv(dev);
+	struct sockaddr *addr = p;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+
+	spin_lock_irq(&cp->lock);
+
+	cpw8_f(Cfg9346, Cfg9346_Unlock);
+	cpw32_f(MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr + 0)));
+	cpw32_f(MAC0 + 4, le32_to_cpu (*(__le32 *) (dev->dev_addr + 4)));
+	cpw8_f(Cfg9346, Cfg9346_Lock);
+
+	spin_unlock_irq(&cp->lock);
+
+	return 0;
+}
+
 /* Serial EEPROM section. */
 
 /*  EEPROM_Ctrl bits. */
@@ -1821,7 +1843,7 @@ static const struct net_device_ops cp_netdev_ops = {
 	.ndo_open		= cp_open,
 	.ndo_stop		= cp_close,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_set_mac_address 	= cp_set_mac_address,
 	.ndo_set_multicast_list	= cp_set_rx_mode,
 	.ndo_get_stats		= cp_get_stats,
 	.ndo_do_ioctl		= cp_ioctl,
