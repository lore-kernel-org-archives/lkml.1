Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab0BDR0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:26:46 -0500
Received: from kroah.org ([198.145.64.141]:34924 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933356Ab0BDRWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:25 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:23 2010
Message-Id: <20100204171523.217298853@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ajit Khaparde <ajitk@serverengines.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [62/74] be2net: Bug fix to support newer generation of BE ASIC
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ajit Khaparde <ajitk@serverengines.com>

commit 7b139c83c590d4965259aad8889cbb08104b2891 upstream.

Bug fix in be2net for newer generation of BladeEngine ASIC.

Signed-off-by: Ajit Khaparde <ajitk@serverengines.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/benet/be.h      |    5 +++++
 drivers/net/benet/be_cmds.h |    3 ++-
 drivers/net/benet/be_main.c |   25 +++++++++++++++++++++++--
 3 files changed, 30 insertions(+), 3 deletions(-)

--- a/drivers/net/benet/be.h
+++ b/drivers/net/benet/be.h
@@ -272,8 +272,13 @@ struct be_adapter {
 	u32 cap;
 	u32 rx_fc;		/* Rx flow control */
 	u32 tx_fc;		/* Tx flow control */
+	u8 generation;		/* BladeEngine ASIC generation */
 };
 
+/* BladeEngine Generation numbers */
+#define BE_GEN2 2
+#define BE_GEN3 3
+
 extern const struct ethtool_ops be_ethtool_ops;
 
 #define drvr_stats(adapter)		(&adapter->stats.drvr_stats)
--- a/drivers/net/benet/be_cmds.h
+++ b/drivers/net/benet/be_cmds.h
@@ -154,7 +154,8 @@ struct be_cmd_req_hdr {
 	u8 domain;		/* dword 0 */
 	u32 timeout;		/* dword 1 */
 	u32 request_length;	/* dword 2 */
-	u32 rsvd;		/* dword 3 */
+	u8 version;		/* dword 3 */
+	u8 rsvd[3];		/* dword 3 */
 };
 
 #define RESP_HDR_INFO_OPCODE_SHIFT	0	/* bits 0 - 7 */
--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@ -1944,6 +1944,7 @@ static void be_unmap_pci_bars(struct be_
 static int be_map_pci_bars(struct be_adapter *adapter)
 {
 	u8 __iomem *addr;
+	int pcicfg_reg;
 
 	addr = ioremap_nocache(pci_resource_start(adapter->pdev, 2),
 			pci_resource_len(adapter->pdev, 2));
@@ -1957,8 +1958,13 @@ static int be_map_pci_bars(struct be_ada
 		goto pci_map_err;
 	adapter->db = addr;
 
-	addr = ioremap_nocache(pci_resource_start(adapter->pdev, 1),
-			pci_resource_len(adapter->pdev, 1));
+	if (adapter->generation == BE_GEN2)
+		pcicfg_reg = 1;
+	else
+		pcicfg_reg = 0;
+
+	addr = ioremap_nocache(pci_resource_start(adapter->pdev, pcicfg_reg),
+			pci_resource_len(adapter->pdev, pcicfg_reg));
 	if (addr == NULL)
 		goto pci_map_err;
 	adapter->pcicfg = addr;
@@ -2028,6 +2034,7 @@ static int be_stats_init(struct be_adapt
 	cmd->va = pci_alloc_consistent(adapter->pdev, cmd->size, &cmd->dma);
 	if (cmd->va == NULL)
 		return -1;
+	memset(cmd->va, cmd->size, 0);
 	return 0;
 }
 
@@ -2101,6 +2108,20 @@ static int __devinit be_probe(struct pci
 		goto rel_reg;
 	}
 	adapter = netdev_priv(netdev);
+
+	switch (pdev->device) {
+	case BE_DEVICE_ID1:
+	case OC_DEVICE_ID1:
+		adapter->generation = BE_GEN2;
+		break;
+	case BE_DEVICE_ID2:
+	case OC_DEVICE_ID2:
+		adapter->generation = BE_GEN3;
+		break;
+	default:
+		adapter->generation = 0;
+	}
+
 	adapter->pdev = pdev;
 	pci_set_drvdata(pdev, adapter);
 	adapter->netdev = netdev;


