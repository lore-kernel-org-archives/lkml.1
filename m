Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbZEIQB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbZEIQB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZEIQBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:01:16 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42010 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZEIQBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:01:14 -0400
Date: Sat, 9 May 2009 11:50:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Greg KH <greg@kroah.com>
Cc: Eric Valette <eric.valette@free.fr>,
       Hin-Tak Leung <hintak.leung@gmail.com>, linux-wireless@vger.kernel.org,
       Larry Finger <Larry.Finger@lwfinger.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFT] rtl8187: use DMA-aware buffers with usb_control_msg
Message-ID: <20090509155013.GA21763@tuxdriver.com>
References: <20090506064513.GA7460@kroah.com> <1241632963-25601-1-git-send-email-linville@tuxdriver.com> <3ace41890905081620h10d0250eq1ede9cd73021dc5b@mail.gmail.com> <4A054F18.7020501@free.fr> <20090509135731.GD17349@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509135731.GD17349@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 06:57:31AM -0700, Greg KH wrote:
> On Sat, May 09, 2009 at 11:38:32AM +0200, Eric Valette wrote:
> > The patch fix the DMA warning and the driver seems to work (just
> > associated it) but I must say that the allocation failure handling path
> > and the fact that we use now kmalloc for allocating a few bytes in such
> > a routine makes me worry about possible negative performance impact
> > unless theses routines are used only in a slow configuration path (did
> > no took time to red the code due to many other problems).
> 
> usb_control messages are slow and should not be on the "fast path" of
> any data being sent through the device.  Any overhead of the
> kmalloc/kfree is totally eaten up by the actual transmission turn around
> time of the message itself, so you don't have to worry about the
> performance impact.

Yeah, I don't like the original version either.  Even if the kmalloc's
aren't a big performance hit, the failure path sucks.  I've included a
new version below, but unfortunately I haven't had a chance to test it.
Please give it a try if you get a chance?

> thanks for testing.

Ditto!

---

>From 73f58f111f3ec5009c603bb4abf86e5ef4c5503f Mon Sep 17 00:00:00 2001
From: John W. Linville <linville@tuxdriver.com>
Date: Wed, 6 May 2009 13:57:27 -0400
Subject: [PATCH] rtl8187: use DMA-aware buffers with usb_control_msg

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8187.h         |   57 ++++++++++++++++++------
 drivers/net/wireless/rtl818x/rtl8187_dev.c     |    8 +++
 drivers/net/wireless/rtl818x/rtl8187_rtl8225.c |    8 +++-
 3 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187.h b/drivers/net/wireless/rtl818x/rtl8187.h
index 622196d..c09bfef 100644
--- a/drivers/net/wireless/rtl818x/rtl8187.h
+++ b/drivers/net/wireless/rtl818x/rtl8187.h
@@ -127,6 +127,12 @@ struct rtl8187_priv {
 		__le64 buf;
 		struct sk_buff_head queue;
 	} b_tx_status; /* This queue is used by both -b and non-b devices */
+	struct mutex io_mutex;
+	union {
+		u8 bits8;
+		__le16 bits16;
+		__le32 bits32;
+	} *io_dmabuf;
 };
 
 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
@@ -136,10 +142,14 @@ static inline u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv,
 {
 	u8 val;
 
+	mutex_lock(&priv->io_mutex);
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, idx & 0x03, &val,
-			sizeof(val), HZ / 2);
+			(unsigned long)addr, idx & 0x03,
+			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
+
+	val = priv->io_dmabuf->bits8;
+	mutex_unlock(&priv->io_mutex);
 
 	return val;
 }
@@ -154,10 +164,14 @@ static inline u16 rtl818x_ioread16_idx(struct rtl8187_priv *priv,
 {
 	__le16 val;
 
+	mutex_lock(&priv->io_mutex);
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, idx & 0x03, &val,
-			sizeof(val), HZ / 2);
+			(unsigned long)addr, idx & 0x03,
+			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
+
+	val = priv->io_dmabuf->bits16;
+	mutex_unlock(&priv->io_mutex);
 
 	return le16_to_cpu(val);
 }
@@ -172,10 +186,14 @@ static inline u32 rtl818x_ioread32_idx(struct rtl8187_priv *priv,
 {
 	__le32 val;
 
+	mutex_lock(&priv->io_mutex);
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
-			(unsigned long)addr, idx & 0x03, &val,
-			sizeof(val), HZ / 2);
+			(unsigned long)addr, idx & 0x03,
+			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
+
+	val = priv->io_dmabuf->bits32;
+	mutex_unlock(&priv->io_mutex);
 
 	return le32_to_cpu(val);
 }
@@ -188,10 +206,15 @@ static inline u32 rtl818x_ioread32(struct rtl8187_priv *priv, __le32 *addr)
 static inline void rtl818x_iowrite8_idx(struct rtl8187_priv *priv,
 					u8 *addr, u8 val, u8 idx)
 {
+	mutex_lock(&priv->io_mutex);
+
+	priv->io_dmabuf->bits8 = val;
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, idx & 0x03, &val,
-			sizeof(val), HZ / 2);
+			(unsigned long)addr, idx & 0x03,
+			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
+
+	mutex_unlock(&priv->io_mutex);
 }
 
 static inline void rtl818x_iowrite8(struct rtl8187_priv *priv, u8 *addr, u8 val)
@@ -202,12 +225,15 @@ static inline void rtl818x_iowrite8(struct rtl8187_priv *priv, u8 *addr, u8 val)
 static inline void rtl818x_iowrite16_idx(struct rtl8187_priv *priv,
 					 __le16 *addr, u16 val, u8 idx)
 {
-	__le16 buf = cpu_to_le16(val);
+	mutex_lock(&priv->io_mutex);
 
+	priv->io_dmabuf->bits16 = cpu_to_le16(val);
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, idx & 0x03, &buf, sizeof(buf),
-			HZ / 2);
+			(unsigned long)addr, idx & 0x03,
+			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
+
+	mutex_unlock(&priv->io_mutex);
 }
 
 static inline void rtl818x_iowrite16(struct rtl8187_priv *priv, __le16 *addr,
@@ -219,12 +245,15 @@ static inline void rtl818x_iowrite16(struct rtl8187_priv *priv, __le16 *addr,
 static inline void rtl818x_iowrite32_idx(struct rtl8187_priv *priv,
 					 __le32 *addr, u32 val, u8 idx)
 {
-	__le32 buf = cpu_to_le32(val);
+	mutex_lock(&priv->io_mutex);
 
+	priv->io_dmabuf->bits32 = cpu_to_le32(val);
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			(unsigned long)addr, idx & 0x03, &buf, sizeof(buf),
-			HZ / 2);
+			(unsigned long)addr, idx & 0x03,
+			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
+
+	mutex_unlock(&priv->io_mutex);
 }
 
 static inline void rtl818x_iowrite32(struct rtl8187_priv *priv, __le32 *addr,
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 158827e..a492abd 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1326,6 +1326,14 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	priv = dev->priv;
 	priv->is_rtl8187b = (id->driver_info == DEVICE_RTL8187B);
 
+	/* allocate "DMA aware" buffer for register accesses */
+	priv->io_dmabuf = kmalloc(sizeof(*priv->io_dmabuf), GFP_KERNEL);
+	if (!priv->io_dmabuf) {
+		err = -ENOMEM;
+		goto err_free_dev;
+	}
+	mutex_init(&priv->io_mutex);
+
 	SET_IEEE80211_DEV(dev, &intf->dev);
 	usb_set_intfdata(intf, dev);
 	priv->udev = udev;
diff --git a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c b/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
index 78df281..a098193 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
@@ -88,9 +88,15 @@ static void rtl8225_write_8051(struct ieee80211_hw *dev, u8 addr, __le16 data)
 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80);
 	udelay(10);
 
+	mutex_lock(&priv->io_mutex);
+
+	priv->io_dmabuf->bits16 = data;
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
-			addr, 0x8225, &data, sizeof(data), HZ / 2);
+			addr, 0x8225, &priv->io_dmabuf->bits16, sizeof(data),
+			HZ / 2);
+
+	mutex_unlock(&priv->io_mutex);
 
 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80 | (1 << 2));
 	udelay(10);
-- 
1.6.0.6

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
