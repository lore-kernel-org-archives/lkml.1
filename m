Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZEZJQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZEZJQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZEZJP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:15:57 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37390 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbZEZJP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:15:56 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/7] bfin_mac: fix build error due to net_device_ops convert
Date: Tue, 26 May 2009 05:15:50 -0400
Message-Id: <1243329356-12644-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
References: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous commit "convert to net_device_ops" broke the Blackfin MAC
driver as it declared the new structure before the function it used:
  CC      drivers/net/bfin_mac.o
drivers/net/bfin_mac.c:984: error: ‘bfin_mac_close’ undeclared here (not in a function)
make[1]: *** [drivers/net/bfin_mac.o] Error 1

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Alexander Beregalov <a.beregalov@gmail.com>
CC: David S. Miller <davem@davemloft.net>
---
 drivers/net/bfin_mac.c |   29 ++++++++++++++---------------
 1 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 9f971ed..b4da182 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -979,22 +979,7 @@ static int bfin_mac_open(struct net_device *dev)
 	return 0;
 }
 
-static const struct net_device_ops bfin_mac_netdev_ops = {
-	.ndo_open		= bfin_mac_open,
-	.ndo_stop		= bfin_mac_close,
-	.ndo_start_xmit		= bfin_mac_hard_start_xmit,
-	.ndo_set_mac_address	= bfin_mac_set_mac_address,
-	.ndo_tx_timeout		= bfin_mac_timeout,
-	.ndo_set_multicast_list	= bfin_mac_set_multicast_list,
-	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_change_mtu		= eth_change_mtu,
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller	= bfin_mac_poll,
-#endif
-};
-
 /*
- *
  * this makes the board clean up everything that it can
  * and not talk to the outside world.   Caused by
  * an 'ifconfig ethX down'
@@ -1019,6 +1004,20 @@ static int bfin_mac_close(struct net_device *dev)
 	return 0;
 }
 
+static const struct net_device_ops bfin_mac_netdev_ops = {
+	.ndo_open		= bfin_mac_open,
+	.ndo_stop		= bfin_mac_close,
+	.ndo_start_xmit		= bfin_mac_hard_start_xmit,
+	.ndo_set_mac_address	= bfin_mac_set_mac_address,
+	.ndo_tx_timeout		= bfin_mac_timeout,
+	.ndo_set_multicast_list	= bfin_mac_set_multicast_list,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_change_mtu		= eth_change_mtu,
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	.ndo_poll_controller	= bfin_mac_poll,
+#endif
+};
+
 static int __devinit bfin_mac_probe(struct platform_device *pdev)
 {
 	struct net_device *ndev;
-- 
1.6.3.1

