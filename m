Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYAACHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYAACHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYAACFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:05:43 -0500
Received: from fmailhost06.isp.att.net ([204.127.217.106]:42370 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbYAACF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:05:29 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 04/26] atl1: add ethtool register dump
Date: Mon, 31 Dec 2007 19:59:42 -0600
Message-Id: <1199152804-3889-5-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

Add the ethtool register dump option to the atl1 driver.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/atlx/atl1.h |    1 +
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 4e98c16..239641f 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2513,6 +2513,57 @@ static int atl1_set_wol(struct net_device *netdev,
 	return 0;
 }
 
+static int atl1_get_regs_len(struct net_device *netdev)
+{
+	return ATL1_REG_COUNT * sizeof(u32);
+}
+
+static void atl1_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
+	void *p)
+{
+	struct atl1_adapter *adapter = netdev_priv(netdev);
+	struct atl1_hw *hw = &adapter->hw;
+	unsigned int i;
+	u32 *regbuf = p;
+
+	for (i = 0; i < ATL1_REG_COUNT; i++) {
+		/*
+		 * This switch statement avoids reserved regions
+		 * of register space.
+		 */
+		switch (i) {
+		case 6 ... 9:
+		case 14:
+		case 29 ... 31:
+		case 34 ... 63:
+		case 75 ... 127:
+		case 136 ... 1023:
+		case 1027 ... 1087:
+		case 1091 ... 1151:
+		case 1194 ... 1195:
+		case 1200 ... 1201:
+		case 1206 ... 1213:
+		case 1216 ... 1279:
+		case 1290 ... 1311:
+		case 1323 ... 1343:
+		case 1358 ... 1359:
+		case 1368 ... 1375:
+		case 1378 ... 1383:
+		case 1388 ... 1391:
+		case 1393 ... 1395:
+		case 1402 ... 1403:
+		case 1410 ... 1471:
+		case 1522 ... 1535:
+			/* reserved region; don't read it */
+			regbuf[i] = 0;
+			break;
+		default:
+			/* unreserved region */
+			regbuf[i] = ioread32(hw->hw_addr + (i * sizeof(u32)));
+		}
+	}
+}
+
 static void atl1_get_ringparam(struct net_device *netdev,
 	struct ethtool_ringparam *ring)
 {
@@ -2703,6 +2754,8 @@ const struct ethtool_ops atl1_ethtool_ops = {
 	.get_drvinfo		= atl1_get_drvinfo,
 	.get_wol		= atl1_get_wol,
 	.set_wol		= atl1_set_wol,
+	.get_regs_len		= atl1_get_regs_len,
+	.get_regs		= atl1_get_regs,
 	.get_ringparam		= atl1_get_ringparam,
 	.set_ringparam		= atl1_set_ringparam,
 	.get_pauseparam		= atl1_get_pauseparam,
diff --git a/drivers/net/atlx/atl1.h b/drivers/net/atlx/atl1.h
index 538948d..30c5a8d 100644
--- a/drivers/net/atlx/atl1.h
+++ b/drivers/net/atlx/atl1.h
@@ -584,6 +584,7 @@ enum atl1_dma_req_block {
 #define ATL1_DEFAULT_RFD	512
 #define ATL1_MIN_RFD		128
 #define ATL1_MAX_RFD		2048
+#define ATL1_REG_COUNT		1538
 
 #define ATL1_GET_DESC(R, i, type)	(&(((type *)((R)->desc))[i]))
 #define ATL1_RFD_DESC(R, i)	ATL1_GET_DESC(R, i, struct rx_free_desc)
-- 
1.5.3.3

