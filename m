Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbXIPC5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbXIPC5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 22:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXIPC5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 22:57:11 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:43897 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbXIPC5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 22:57:10 -0400
X-IronPort-AV: i="4.20,259,1186372800"; 
   d="scan'208"; a="51541778:sNHT87563875"
Subject: [PATCH 1/3] Blackfin EMAC driver: add function to change the MAC
	address
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: jeff@garzik.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Sun, 16 Sep 2007 10:57:03 +0800
Message-Id: <1189911423.9901.4.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 16 Sep 2007 02:57:08.0583 (UTC) FILETIME=[45648F70:01C7F80D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 157dfddae50708a716c2a42a314eccb9621d8793 Mon Sep 17 00:00:00 2001
From: Alex Landau <lirsb@yahoo.com>
Date: Sun, 5 Aug 2007 15:58:03 +0800
Subject: [PATCH] Blackfin Ethernet MAC driver: add function to change the MAC address

Alex Landau writes in the forums:
  Previously, changing the MAC address (e.g. via ifconfig) resulted
  in a generic function to be called that only changed a variable in
  memory. This patch also updated the Blackfin MAC address registers
  to filter the correct new MAC.

Signed-off-by: Alex Landau <lirsb@yahoo.com>
Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/net/bfin_mac.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 2bb97d4..8d61ca9 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -468,7 +468,7 @@ void setup_system_regs(struct net_device *dev)
 	bfin_write_DMA1_Y_MODIFY(0);
 }
 
-void setup_mac_addr(u8 * mac_addr)
+static void setup_mac_addr(u8 *mac_addr)
 {
 	u32 addr_low = le32_to_cpu(*(__le32 *) & mac_addr[0]);
 	u16 addr_hi = le16_to_cpu(*(__le16 *) & mac_addr[4]);
@@ -478,6 +478,16 @@ void setup_mac_addr(u8 * mac_addr)
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
@@ -895,6 +905,7 @@ static int __init bf537mac_probe(struct net_device *dev)
 	dev->open = bf537mac_open;
 	dev->stop = bf537mac_close;
 	dev->hard_start_xmit = bf537mac_hard_start_xmit;
+	dev->set_mac_address = bf537mac_set_mac_address;
 	dev->tx_timeout = bf537mac_timeout;
 	dev->get_stats = bf537mac_query_statistics;
 	dev->set_multicast_list = bf537mac_set_multicast_list;
-- 
1.5.2

