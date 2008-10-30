Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbYJ3QMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbYJ3QMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYJ3QLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:11:49 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:63968 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbYJ3QLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=w4u5a8UQgEJKWpp0tsCEqnJRZuOb5C2Y71L+KJHEnMkLSDGrgeohKOO3O5M4deYkAt
         s45Pp42jzd39WxUBM94zxJ/eKH2gVY3zvCAi0gxISDSLYery5n7liGm6mxnYPGx+gyGc
         XEbhhT1FtikqzLKnNLF6e7ywcMM4G4vAqFylk=
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH 5/7] w35und: move packet_came() to wb35rx.c
Date: Thu, 30 Oct 2008 18:12:05 +0200
Message-Id: <1225383127-16406-5-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1225383127-16406-4-git-send-email-penberg@cs.helsinki.fi>
References: <>
 <1225383127-16406-1-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-2-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-3-git-send-email-penberg@cs.helsinki.fi>
 <1225383127-16406-4-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function no longer has dependencies to wbusb.c so we can move it to
wb35rx.c and make it static now.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wb35rx.c |   28 +++++++++++++++++++++++++++-
 drivers/staging/winbond/wbusb.c  |   29 -----------------------------
 2 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx.c b/drivers/staging/winbond/wb35rx.c
index cd5a8e1..85b861c 100644
--- a/drivers/staging/winbond/wb35rx.c
+++ b/drivers/staging/winbond/wb35rx.c
@@ -264,8 +264,34 @@ void Wb35Rx_adjust(PDESCRIPTOR pRxDes)
 	pRxDes->buffer_size[0] = BufferSize;
 }
 
-extern void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int PacketSize);
+static void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int PacketSize)
+{
+	struct wbsoft_priv *priv = hw->priv;
+	struct sk_buff *skb;
+	struct ieee80211_rx_status rx_status = {0};
+
+	if (!priv->enabled)
+		return;
+
+	skb = dev_alloc_skb(PacketSize);
+	if (!skb) {
+		printk("Not enough memory for packet, FIXME\n");
+		return;
+	}
+
+	memcpy(skb_put(skb, PacketSize),
+	       pRxBufferAddress,
+	       PacketSize);
 
+/*
+	rx_status.rate = 10;
+	rx_status.channel = 1;
+	rx_status.freq = 12345;
+	rx_status.phymode = MODE_IEEE80211B;
+*/
+
+	ieee80211_rx_irqsafe(hw, skb, &rx_status);
+}
 
 u16 Wb35Rx_indicate(struct ieee80211_hw *hw)
 {
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 246f20b..b981662 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -391,35 +391,6 @@ error:
 	return err;
 }
 
-void packet_came(struct ieee80211_hw *hw, char *pRxBufferAddress, int PacketSize)
-{
-	struct wbsoft_priv *priv = hw->priv;
-	struct sk_buff *skb;
-	struct ieee80211_rx_status rx_status = {0};
-
-	if (!priv->enabled)
-		return;
-
-	skb = dev_alloc_skb(PacketSize);
-	if (!skb) {
-		printk("Not enough memory for packet, FIXME\n");
-		return;
-	}
-
-	memcpy(skb_put(skb, PacketSize),
-	       pRxBufferAddress,
-	       PacketSize);
-
-/*
-	rx_status.rate = 10;
-	rx_status.channel = 1;
-	rx_status.freq = 12345;
-	rx_status.phymode = MODE_IEEE80211B;
-*/
-
-	ieee80211_rx_irqsafe(hw, skb, &rx_status);
-}
-
 static void wb35_hw_halt(struct wbsoft_priv *adapter)
 {
 	Mds_Destroy( adapter );
-- 
1.5.3.7

