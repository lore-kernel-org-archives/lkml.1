Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbZEFSQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbZEFSQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756777AbZEFSQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:16:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34725 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbZEFSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:16:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Eric Valette <eric.valette@free.fr>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [RFT] rtl8187: use DMA-aware buffers with usb_control_msg
Date: Wed,  6 May 2009 14:02:43 -0400
Message-Id: <1241632963-25601-1-git-send-email-linville@tuxdriver.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20090506064513.GA7460@kroah.com>
References: <20090506064513.GA7460@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This definitely needs to fail more gracefully in the event of a
kmalloc failure...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8187.h         |   72 ++++++++++++++++++++----
 drivers/net/wireless/rtl818x/rtl8187_rtl8225.c |   11 +++-
 2 files changed, 71 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187.h b/drivers/net/wireless/rtl818x/rtl8187.h
index 622196d..600ae34 100644
--- a/drivers/net/wireless/rtl818x/rtl8187.h
+++ b/drivers/net/wireless/rtl818x/rtl8187.h
@@ -134,13 +134,21 @@ void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
 static inline u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv,
 				     u8 *addr, u8 idx)
 {
-	u8 val;
+	u8 val, *buf;
+
+	/* Use "DMA-aware" buffer. */
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		BUG(); /* TODO -- handle this more gracefully */
 
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, idx & 0x03, &val,
+			(unsigned long)addr, idx & 0x03, buf,
 			sizeof(val), HZ / 2);
 
+	val = *buf;
+	kfree(buf);
+
 	return val;
 }
 
@@ -152,13 +160,21 @@ static inline u8 rtl818x_ioread8(struct rtl8187_priv *priv, u8 *addr)
 static inline u16 rtl818x_ioread16_idx(struct rtl8187_priv *priv,
 				       __le16 *addr, u8 idx)
 {
-	__le16 val;
+	__le16 val, *buf;
+
+	/* Use "DMA-aware" buffer. */
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		BUG(); /* TODO -- handle this more gracefully */
 
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, idx & 0x03, &val,
+			(unsigned long)addr, idx & 0x03, buf,
 			sizeof(val), HZ / 2);
 
+	val = *buf;
+	kfree(buf);
+
 	return le16_to_cpu(val);
 }
 
@@ -170,13 +186,21 @@ static inline u16 rtl818x_ioread16(struct rtl8187_priv *priv, __le16 *addr)
 static inline u32 rtl818x_ioread32_idx(struct rtl8187_priv *priv,
 				       __le32 *addr, u8 idx)
 {
-	__le32 val;
+	__le32 val, *buf;
+
+	/* Use "DMA-aware" buffer. */
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		BUG(); /* TODO -- handle this more gracefully */
 
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, idx & 0x03, &val,
+			(unsigned long)addr, idx & 0x03, buf,
 			sizeof(val), HZ / 2);
 
+	val = *buf;
+	kfree(buf);
+
 	return le32_to_cpu(val);
 }
 
@@ -188,10 +212,20 @@ static inline u32 rtl818x_ioread32(struct rtl8187_priv *priv, __le32 *addr)
 static inline void rtl818x_iowrite8_idx(struct rtl8187_priv *priv,
 					u8 *addr, u8 val, u8 idx)
 {
+	u8 *buf;
+
+	/* Use "DMA-aware" buffer. */
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		BUG(); /* TODO -- handle this more gracefully */
+	*buf = val;
+
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, idx & 0x03, &val,
+			(unsigned long)addr, idx & 0x03, buf,
 			sizeof(val), HZ / 2);
+
+	kfree(buf);
 }
 
 static inline void rtl818x_iowrite8(struct rtl8187_priv *priv, u8 *addr, u8 val)
@@ -202,12 +236,20 @@ static inline void rtl818x_iowrite8(struct rtl8187_priv *priv, u8 *addr, u8 val)
 static inline void rtl818x_iowrite16_idx(struct rtl8187_priv *priv,
 					 __le16 *addr, u16 val, u8 idx)
 {
-	__le16 buf = cpu_to_le16(val);
+	__le16 *buf;
+
+	/* Use "DMA-aware" buffer. */
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		BUG(); /* TODO -- handle this more gracefully */
+	*buf = cpu_to_le16(val);
 
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, idx & 0x03, &buf, sizeof(buf),
+			(unsigned long)addr, idx & 0x03, buf, sizeof(*buf),
 			HZ / 2);
+
+	kfree(buf);
 }
 
 static inline void rtl818x_iowrite16(struct rtl8187_priv *priv, __le16 *addr,
@@ -219,12 +261,20 @@ static inline void rtl818x_iowrite16(struct rtl8187_priv *priv, __le16 *addr,
 static inline void rtl818x_iowrite32_idx(struct rtl8187_priv *priv,
 					 __le32 *addr, u32 val, u8 idx)
 {
-	__le32 buf = cpu_to_le32(val);
+	__le32 *buf;
+
+	/* Use "DMA-aware" buffer. */
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		BUG(); /* TODO -- handle this more gracefully */
+	*buf = cpu_to_le32(val);
 
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, idx & 0x03, &buf, sizeof(buf),
+			(unsigned long)addr, idx & 0x03, buf, sizeof(*buf),
 			HZ / 2);
+
+	kfree(buf);
 }
 
 static inline void rtl818x_iowrite32(struct rtl8187_priv *priv, __le32 *addr,
diff --git a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c b/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
index 78df281..6c6dba2 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
@@ -70,6 +70,13 @@ static void rtl8225_write_8051(struct ieee80211_hw *dev, u8 addr, __le16 data)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	u16 reg80, reg82, reg84;
+	__le16 *buf;
+
+	/* Use "DMA-aware" buffer. */
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		BUG(); /* TODO -- handle this more gracefully */
+	*buf = data;
 
 	reg80 = rtl818x_ioread16(priv, &priv->map->RFPinsOutput);
 	reg82 = rtl818x_ioread16(priv, &priv->map->RFPinsEnable);
@@ -90,13 +97,15 @@ static void rtl8225_write_8051(struct ieee80211_hw *dev, u8 addr, __le16 data)
 
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			addr, 0x8225, &data, sizeof(data), HZ / 2);
+			addr, 0x8225, buf, sizeof(*buf), HZ / 2);
 
 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80 | (1 << 2));
 	udelay(10);
 
 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80 | (1 << 2));
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, reg84);
+
+	kfree(buf);
 }
 
 static void rtl8225_write(struct ieee80211_hw *dev, u8 addr, u16 data)
-- 
1.6.0.6

