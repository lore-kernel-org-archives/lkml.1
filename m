Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbYHIR0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbYHIR0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 13:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYHIRZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 13:25:57 -0400
Received: from [78.153.208.64] ([78.153.208.64]:39886 "EHLO
	vps-1000455-184.cp.blacknight.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbYHIRZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 13:25:57 -0400
X-Greylist: delayed 1721 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Aug 2008 13:25:57 EDT
Date: Sat, 9 Aug 2008 17:54:02 +0100
From: Robert Fitzsimons <robfitz@273k.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jeff Garzik <jgarzik@redhat.com>, David Miller <davem@davemloft.net>,
       Samuel Chessman <chessman@tux.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] tlan: Fix two regressions introduced by 64bit conversion.
Message-ID: <20080809165402.GA3726@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two regressions were introduced by the recent tlan: 64bit conversion
commit (93e16847c9db0093065c98063cfc639cdfccf19a).  The first in
TLan_GetSKB caused a NULL pointer dereference.  With the second causing
the link to fail to come up.

Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
---
 drivers/net/tlan.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tlan.c b/drivers/net/tlan.c
index 85246ed..ec871f6 100644
--- a/drivers/net/tlan.c
+++ b/drivers/net/tlan.c
@@ -360,8 +360,8 @@ TLan_GetSKB( const struct tlan_list_tag *tag)
 {
 	unsigned long addr;
 
-	addr = tag->buffer[8].address;
-	addr |= (tag->buffer[9].address << 16) << 16;
+	addr = tag->buffer[9].address;
+	addr |= (tag->buffer[8].address << 16) << 16;
 	return (struct sk_buff *) addr;
 }
 
@@ -1984,7 +1984,6 @@ static void TLan_ResetLists( struct net_device *dev )
 	TLanList	*list;
 	dma_addr_t	list_phys;
 	struct sk_buff	*skb;
-	void		*t = NULL;
 
 	priv->txHead = 0;
 	priv->txTail = 0;
@@ -2022,7 +2021,8 @@ static void TLan_ResetLists( struct net_device *dev )
 			}
 
 			skb_reserve( skb, NET_IP_ALIGN );
-			list->buffer[0].address = pci_map_single(priv->pciDev, t,
+			list->buffer[0].address = pci_map_single(priv->pciDev,
+								 skb->data,
 								 TLAN_MAX_FRAME_SIZE,
 								 PCI_DMA_FROMDEVICE);
 			TLan_StoreSKB(list, skb);
-- 
1.5.6.3

