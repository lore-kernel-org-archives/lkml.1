Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbZEKNqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbZEKNqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZEKNqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:46:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38473 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZEKNqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:46:16 -0400
Date: Mon, 11 May 2009 09:20:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Greg KH <greg@kroah.com>, Eric Valette <eric.valette@free.fr>,
       Hin-Tak Leung <hintak.leung@gmail.com>, linux-wireless@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFT] rtl8187: use DMA-aware buffers with usb_control_msg
Message-ID: <20090511131822.GC2721@tuxdriver.com>
References: <20090506064513.GA7460@kroah.com> <1241632963-25601-1-git-send-email-linville@tuxdriver.com> <3ace41890905081620h10d0250eq1ede9cd73021dc5b@mail.gmail.com> <4A054F18.7020501@free.fr> <20090509135731.GD17349@kroah.com> <20090509155013.GA21763@tuxdriver.com> <4A05F485.4080303@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A05F485.4080303@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 04:24:21PM -0500, Larry Finger wrote:
> John W. Linville wrote:
> > 
> > Yeah, I don't like the original version either.  Even if the kmalloc's
> > aren't a big performance hit, the failure path sucks.  I've included a
> > new version below, but unfortunately I haven't had a chance to test it.
> > Please give it a try if you get a chance?
> 
> This one tests just fine here running on the latest pull of wireless testing
> (v2.6.30-rc4-22732-gd879ac6). I think there is a leak of priv->io_dmabuf when
> the driver is unloaded, and kfree(priv->io_dmabuf) should be added to
> rtl8187_disconnect(). Otherwise ACK.

Doh!

---

>From dbc8e19329b52c53832cbb03eea76646e44aab07 Mon Sep 17 00:00:00 2001
From: John W. Linville <linville@tuxdriver.com>
Date: Wed, 6 May 2009 13:57:27 -0400
Subject: [PATCH] rtl8187: use DMA-aware buffers with usb_control_msg

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8187.h         |   57 ++++++++++++++++++------
 drivers/net/wireless/rtl818x/rtl8187_dev.c     |   13 +++++-
 drivers/net/wireless/rtl818x/rtl8187_rtl8225.c |    8 +++-
 3 files changed, 62 insertions(+), 16 deletions(-)

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
index 158827e..6499ccc 100644
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
@@ -1489,7 +1497,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	err = ieee80211_register_hw(dev);
 	if (err) {
 		printk(KERN_ERR "rtl8187: Cannot register device\n");
-		goto err_free_dev;
+		goto err_free_dmabuf;
 	}
 	mutex_init(&priv->conf_mutex);
 	skb_queue_head_init(&priv->b_tx_status.queue);
@@ -1506,6 +1514,8 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 
 	return 0;
 
+ err_free_dmabuf:
+	kfree(priv->io_dmabuf);
  err_free_dev:
 	ieee80211_free_hw(dev);
 	usb_set_intfdata(intf, NULL);
@@ -1529,6 +1539,7 @@ static void __devexit rtl8187_disconnect(struct usb_interface *intf)
 	priv = dev->priv;
 	usb_reset_device(priv->udev);
 	usb_put_dev(interface_to_usbdev(intf));
+	kfree(priv->io_dmabuf);
 	ieee80211_free_hw(dev);
 }
 
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
