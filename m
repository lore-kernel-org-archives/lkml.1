Return-Path: <linux-kernel-owner+w=401wt.eu-S935875AbYBCBvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935875AbYBCBvZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 20:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932693AbYBCBuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 20:50:20 -0500
Received: from fmailhost01.isp.att.net ([207.115.11.51]:57411 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYBCBuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 20:50:15 -0500
X-Originating-IP: [70.157.3.17]
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 04/10] atl1: add ethtool register dump
Date: Sat,  2 Feb 2008 19:50:06 -0600
Message-Id: <1202003412-4028-4-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202003412-4028-1-git-send-email-jacliburn@bellsouth.net>
References: <1202003412-4028-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ethtool register dump option to the atl1 driver.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Acked-by: Chris Snook <csnook@redhat.com>
---
 drivers/net/atlx/atl1.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/atlx/atl1.h |    1 +
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 8a26dad..1f564f0 100644
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
1.5.3.8

