Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbYJHHyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbYJHHyx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYJHHym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:54:42 -0400
Received: from ffm.saftware.de ([83.141.3.46]:40905 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbYJHHyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:54:41 -0400
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Oct 2008 03:54:41 EDT
Message-ID: <48EC64E1.5070806@linuxtv.org>
Date: Wed, 08 Oct 2008 09:44:33 +0200
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] 8139too: move wmb before TX DMA start
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Oberritter <obi@linuxtv.org>

The write barrier should be used before starting a DMA transfer. This fixes
a problem, where almost all packets received on another machine had garbled
content. Tested with an RTL8100C on a MIPS machine.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>

diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
index 53bd903..44344af 100644
--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -1716,13 +1716,13 @@ static int rtl8139_start_xmit (struct sk_buff *skb, struct net_device *dev)
 	}
 
 	spin_lock_irqsave(&tp->lock, flags);
+	wmb();
 	RTL_W32_F (TxStatus0 + (entry * sizeof (u32)),
 		   tp->tx_flag | max(len, (unsigned int)ETH_ZLEN));
 
 	dev->trans_start = jiffies;
 
 	tp->cur_tx++;
-	wmb();
 
 	if ((tp->cur_tx - NUM_TX_DESC) == tp->dirty_tx)
 		netif_stop_queue (dev);
