Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbZGaHXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbZGaHXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 03:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZGaHXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 03:23:45 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:2942 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbZGaHXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 03:23:40 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 2/2 net-next-2.6] cxgb3: fix Gen2 pci default settings
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Fri, 31 Jul 2009 00:23:39 -0700
Message-ID: <20090731072339.4325.23090.stgit@speedy5>
In-Reply-To: <20090731072334.4325.34323.stgit@speedy5>
References: <20090731072334.4325.34323.stgit@speedy5>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Modify control register settings to accommodate the bridge's max read requset
size.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/t3_hw.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)


diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index e78d341..526e144 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -3465,7 +3465,7 @@ static void config_pcie(struct adapter *adap)
 		{201, 321, 258, 450, 834, 1602}
 	};
 
-	u16 val;
+	u16 val, devid;
 	unsigned int log2_width, pldsize;
 	unsigned int fst_trn_rx, fst_trn_tx, acklat, rpllmt;
 
@@ -3473,6 +3473,17 @@ static void config_pcie(struct adapter *adap)
 			     adap->params.pci.pcie_cap_addr + PCI_EXP_DEVCTL,
 			     &val);
 	pldsize = (val & PCI_EXP_DEVCTL_PAYLOAD) >> 5;
+
+	pci_read_config_word(adap->pdev, 0x2, &devid);
+	if (devid == 0x37) {
+		pci_write_config_word(adap->pdev,
+				      adap->params.pci.pcie_cap_addr +
+				      PCI_EXP_DEVCTL,
+				      val & ~PCI_EXP_DEVCTL_READRQ &
+				      ~PCI_EXP_DEVCTL_PAYLOAD);
+		pldsize = 0;
+	}
+
 	pci_read_config_word(adap->pdev,
 			     adap->params.pci.pcie_cap_addr + PCI_EXP_LNKCTL,
 			     &val);

