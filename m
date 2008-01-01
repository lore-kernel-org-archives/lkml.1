Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbYAACG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbYAACG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYAACFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:05:42 -0500
Received: from fmailhost04.isp.att.net ([207.115.11.54]:59464 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYAACFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:05:25 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 10/26] atl1: use csum_start
Date: Mon, 31 Dec 2007 19:59:48 -0600
Message-Id: <1199152804-3889-11-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

Use skb->csum_start for tx checksum offload preparation.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index b0c3273..31aad9f 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -1376,16 +1376,17 @@ static int atl1_tx_csum(struct atl1_adapter *adapter, struct sk_buff *skb,
 	u8 css, cso;
 
 	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
-		cso = skb_transport_offset(skb);
-		css = cso + skb->csum_offset;
-		if (unlikely(cso & 0x1)) {
+		css = (u8) (skb->csum_start - skb_headroom(skb));
+		cso = css + (u8) skb->csum_offset;
+		if (unlikely(css & 0x1)) {
+			/* L1 hardware requires an even number here */
 			dev_printk(KERN_DEBUG, &adapter->pdev->dev,
 				"payload offset not an even number\n");
 			return -1;
 		}
-		ptpd->word3 |= (cso & TPD_PLOADOFFSET_MASK) <<
+		ptpd->word3 |= (css & TPD_PLOADOFFSET_MASK) <<
 			TPD_PLOADOFFSET_SHIFT;
-		ptpd->word3 |= (css & TPD_CCSUMOFFSET_MASK) <<
+		ptpd->word3 |= (cso & TPD_CCSUMOFFSET_MASK) <<
 			TPD_CCSUMOFFSET_SHIFT;
 		ptpd->word3 |= 1 << TPD_CUST_CSUM_EN_SHIFT;
 		return true;
-- 
1.5.3.3

