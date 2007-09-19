Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbXISPhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbXISPhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXISPhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:37:19 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:31641 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbXISPhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:37:17 -0400
X-IronPort-AV: i="4.20,273,1186372800"; 
   d="scan'208"; a="39917894:sNHT27146063"
Subject: [PATCH 1/4] Blackfin EMAC driver: add function to change the MAC
	address
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Alex Landau <lirsb@yahoo.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Wed, 19 Sep 2007 23:37:04 +0800
Message-Id: <1190216224.15707.27.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 19 Sep 2007 15:37:16.0352 (UTC) FILETIME=[F4FB1400:01C7FAD2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Landau <lirsb@yahoo.com>
Date: Wed, 19 Sep 2007 23:14:18 +0800
Subject: [PATCH] Blackfin EMAC driver: add function to change the MAC address

Alex Landau writes in the forums:
 Previously, changing the MAC address (e.g. via ifconfig) resulted
 in a generic function to be called that only changed a variable in
 memory. This patch also updated the Blackfin MAC address registers
 to filter the correct new MAC.

Signed-off-by: Alex Landau <lirsb@yahoo.com>
Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Acked-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/net/bfin_mac.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index cebe554..ead7be9 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -463,7 +463,7 @@ void setup_system_regs(struct net_device *dev)
 	bfin_write_DMA1_Y_MODIFY(0);
 }
 
-void setup_mac_addr(u8 * mac_addr)
+static void setup_mac_addr(u8 *mac_addr)
 {
 	u32 addr_low = le32_to_cpu(*(__le32 *) & mac_addr[0]);
 	u16 addr_hi = le16_to_cpu(*(__le16 *) & mac_addr[4]);
@@ -473,6 +473,16 @@ void setup_mac_addr(u8 * mac_addr)
 	bfin_write_EMAC_ADDRHI(addr_hi);
 }
 
+static int bf537mac_set_mac_address(struct net_device *dev, void *p)
+{
+	struct sockaddr *addr = p;
+	if (netif_running(dev))
+		return -EBUSY;
+	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	setup_mac_addr(dev->dev_addr);
+	return 0;
+}
+
 static void adjust_tx_list(void)
 {
 	int timeout_cnt = MAX_TIMEOUT_CNT;
@@ -876,6 +886,7 @@ static int __init bf537mac_probe(struct net_device *dev)
 	dev->open = bf537mac_open;
 	dev->stop = bf537mac_close;
 	dev->hard_start_xmit = bf537mac_hard_start_xmit;
+	dev->set_mac_address = bf537mac_set_mac_address;
 	dev->tx_timeout = bf537mac_timeout;
 	dev->set_multicast_list = bf537mac_set_multicast_list;
 #ifdef CONFIG_NET_POLL_CONTROLLER
-- 
1.5.2

