Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbXEZXCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbXEZXCE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 19:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbXEZXAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 19:00:21 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:8720 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbXEZXAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 19:00:17 -0400
From: divy@chelsio.com
Subject: [PATCH 6/7] cxgb3 - MAC watchdog update
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Sat, 26 May 2007 16:00:15 -0700
Message-ID: <20070526230015.12192.52383.stgit@localhost.localdomain>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Fix variables initialization and usage in the MAC watchdog.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/xgmac.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/cxgb3/xgmac.c b/drivers/net/cxgb3/xgmac.c
index 16cadba..b261be1 100644
--- a/drivers/net/cxgb3/xgmac.c
+++ b/drivers/net/cxgb3/xgmac.c
@@ -501,6 +501,10 @@ int t3b2_mac_watchdog_task(struct cmac *
 	unsigned int rx_xcnt;
 	int status;
 
+	status = 0;
+	tx_xcnt = 1;		/* By default tx_xcnt is making progress */
+	tx_tcnt = mac->tx_tcnt;	/* If tx_mcnt is progressing ignore tx_tcnt */
+	rx_xcnt = 1;		/* By default rx_xcnt is making progress */
 	if (tx_mcnt == mac->tx_mcnt) {
 		tx_xcnt = (G_TXSPI4SOPCNT(t3_read_reg(adap,
 						A_XGM_TX_SPI4_SOP_EOP_CNT +
@@ -511,37 +515,44 @@ int t3b2_mac_watchdog_task(struct cmac *
 			tx_tcnt = (G_TXDROPCNTCH0RCVD(t3_read_reg(adap,
 						      A_TP_PIO_DATA)));
 		} else {
-			mac->toggle_cnt = 0;
-			return 0;
+			goto rxcheck;
 		}
 	} else {
 		mac->toggle_cnt = 0;
-		return 0;
+		goto rxcheck;
 	}
 
 	if (((tx_tcnt != mac->tx_tcnt) &&
 	     (tx_xcnt == 0) && (mac->tx_xcnt == 0)) ||
 	    ((mac->tx_mcnt == tx_mcnt) &&
 	     (tx_xcnt != 0) && (mac->tx_xcnt != 0))) {
-		if (mac->toggle_cnt > 4)
+		if (mac->toggle_cnt > 4) {
 			status = 2;
-		else 
+			goto out;
+		} else {
 			status = 1;
+			goto out;
+		}
 	} else {
 		mac->toggle_cnt = 0;
-		return 0;
+		goto rxcheck;
 	}
 
+rxcheck:
 	if (rx_mcnt != mac->rx_mcnt)
 		rx_xcnt = (G_TXSPI4SOPCNT(t3_read_reg(adap,
 						A_XGM_RX_SPI4_SOP_EOP_CNT +
 						mac->offset)));
-	else 
-		return 0;
+	else
+		goto out;
 
-	if (mac->rx_mcnt != s->rx_frames && rx_xcnt == 0 && mac->rx_xcnt == 0) 
+	if (mac->rx_mcnt != s->rx_frames && rx_xcnt == 0 &&
+	    mac->rx_xcnt == 0) {
 		status = 2;
-	
+		goto out;
+	}
+
+out:
 	mac->tx_tcnt = tx_tcnt;
 	mac->tx_xcnt = tx_xcnt;
 	mac->tx_mcnt = s->tx_frames;
