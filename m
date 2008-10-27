Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYJ0WOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYJ0WOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYJ0WOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:14:40 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50003 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYJ0WOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:14:39 -0400
Date: Tue, 28 Oct 2008 00:14:38 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
cc: pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] w35und: plug memory leak in wbsoft_tx()
Message-ID: <Pine.LNX.4.64.0810280014140.9821@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

There's no reason to duplicate the skb in wbsoft_tx() and leak GFP_ATOMIC
memory as the contents are copied to ->TxBuffer in MdxTx() anyway before
MLMESendFrame() returns.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/linux/wbusb.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index 128b70a..8957634 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -114,11 +114,8 @@ static void wbsoft_configure_filter(struct ieee80211_hw *dev,
 
 static int wbsoft_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 {
-	char *buffer = kmalloc(skb->len, GFP_ATOMIC);
-	printk("Sending frame %d bytes\n", skb->len);
-	memcpy(buffer, skb->data, skb->len);
-	if (1 == MLMESendFrame(my_adapter, buffer, skb->len, FRAME_TYPE_802_11_MANAGEMENT))
-		printk("frame sent ok (%d bytes)?\n", skb->len);
+	MLMESendFrame(my_adapter, skb->data, skb->len, FRAME_TYPE_802_11_MANAGEMENT);
+
 	return NETDEV_TX_OK;
 }
 
-- 
1.5.3.7

