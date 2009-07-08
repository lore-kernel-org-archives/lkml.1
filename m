Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbZGHFtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbZGHFtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756434AbZGHFsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:48:42 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:18807 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbZGHFsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:48:40 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 2/8 net-next-2.6] cxgb3: Fix T3C MAC max packet size access
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Tue, 07 Jul 2009 22:48:38 -0700
Message-ID: <20090708054838.11344.97432.stgit@speedy5>
In-Reply-To: <20090708054832.11344.82449.stgit@speedy5>
References: <20090708054832.11344.82449.stgit@speedy5>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Max packet size is not the only field in T3C's High Water Mark register.
Mask the register to access this field.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/xgmac.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)


diff --git a/drivers/net/cxgb3/xgmac.c b/drivers/net/cxgb3/xgmac.c
index f87f943..0109ee4 100644
--- a/drivers/net/cxgb3/xgmac.c
+++ b/drivers/net/cxgb3/xgmac.c
@@ -447,11 +447,12 @@ int t3_mac_set_speed_duplex_fc(struct cmac *mac, int speed, int duplex, int fc)
 
 	val = t3_read_reg(adap, A_XGM_RXFIFO_CFG + oft);
 	val &= ~V_RXFIFOPAUSEHWM(M_RXFIFOPAUSEHWM);
-	if (fc & PAUSE_TX)
-		val |= V_RXFIFOPAUSEHWM(rx_fifo_hwm(
-						t3_read_reg(adap,
-						A_XGM_RX_MAX_PKT_SIZE
-						+ oft)) / 8);
+	if (fc & PAUSE_TX) {
+		u32 rx_max_pkt_size =
+		    G_RXMAXPKTSIZE(t3_read_reg(adap,
+					       A_XGM_RX_MAX_PKT_SIZE + oft));
+		val |= V_RXFIFOPAUSEHWM(rx_fifo_hwm(rx_max_pkt_size) / 8);
+	}
 	t3_write_reg(adap, A_XGM_RXFIFO_CFG + oft, val);
 
 	t3_set_reg_field(adap, A_XGM_TX_CFG + oft, F_TXPAUSEEN,

