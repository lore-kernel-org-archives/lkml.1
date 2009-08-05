Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZHEV73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZHEV73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbZHEV71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:59:27 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:25203 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbZHEV7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:59:24 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH net-next-2.6] cxgb3: fix 2 ports 1G regression
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Wed, 05 Aug 2009 14:59:23 -0700
Message-ID: <20090805215923.21467.99484.stgit@speedy5>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

commit 88045b3cf0f8981129cb489c7b6bc36c21dd33a7
	cxgb3: fix mac index mapping

	Override the mac index computation for the gen2 adapter,
	as each port is expected to use index 0.

introduces a regression on 2 port 1G adapter
as its xauicfg vpd value is null.
Add a check on the device id.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/t3_hw.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 526e144..032cfe0 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -3692,8 +3692,12 @@ static void mc7_prep(struct adapter *adapter, struct mc7 *mc7,
 
 void mac_prep(struct cmac *mac, struct adapter *adapter, int index)
 {
+	u16 devid;
+
 	mac->adapter = adapter;
-	if (!adapter->params.vpd.xauicfg[1])
+	pci_read_config_word(adapter->pdev, 0x2, &devid);
+
+	if (devid == 0x37 && !adapter->params.vpd.xauicfg[1])
 		index = 0;
 	mac->offset = (XGMAC0_1_BASE_ADDR - XGMAC0_0_BASE_ADDR) * index;
 	mac->nucast = 1;

