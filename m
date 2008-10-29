Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYJ2Wut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYJ2Wut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbYJ2Wod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:44:33 -0400
Received: from kroah.org ([198.145.64.141]:43785 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756048AbYJ2Wo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:44:29 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/49] Staging: w35und: plug memory leak in wbsoft_tx()
Date: Wed, 29 Oct 2008 15:39:47 -0700
Message-Id: <1225320016-21803-20-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

There's no reason to duplicate the skb in wbsoft_tx() and leak GFP_ATOMIC
memory as the contents are copied to ->TxBuffer in MdxTx() anyway before
MLMESendFrame() returns.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/linux/wbusb.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index d9c3a16..75213b5 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -107,11 +107,8 @@ static void wbsoft_configure_filter(struct ieee80211_hw *dev,
 
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
1.6.0.2

