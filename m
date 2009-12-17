Return-Path: <linux-kernel-owner+w=401wt.eu-S936597AbZLQEd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936597AbZLQEd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936560AbZLQEdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:33:01 -0500
Received: from kroah.org ([198.145.64.141]:55601 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935645AbZLQEEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:32 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:51 2009
Message-Id: <20091217035651.824658024@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [069/151] rtl8187: Fix wrong rfkill switch mask for some models
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 70d57139f932b9ca21026253d02af71cf53d764a upstream.

There are different bits used to convey the setting of the rfkill
switch to the driver. The current driver only supports one of these
possibilities. These changes were derived from the latest version
of the vendor driver.

This patch fixes the regression noted in kernel Bugzilla #14743.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-tested-by: Antti Kaijanmäki <antti@kaijanmaki.net>
Tested-by: Hin-Tak Leung <hintak.leung@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtl818x/rtl8187.h        |    5 +++++
 drivers/net/wireless/rtl818x/rtl8187_dev.c    |   12 ++++++++++--
 drivers/net/wireless/rtl818x/rtl8187_rfkill.c |    4 ++--
 3 files changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1329,6 +1329,7 @@ static int __devinit rtl8187_probe(struc
 	struct ieee80211_channel *channel;
 	const char *chip_name;
 	u16 txpwr, reg;
+	u16 product_id = le16_to_cpu(udev->descriptor.idProduct);
 	int err, i;
 
 	dev = ieee80211_alloc_hw(sizeof(*priv), &rtl8187_ops);
@@ -1488,6 +1489,13 @@ static int __devinit rtl8187_probe(struc
 		(*channel++).hw_value = txpwr & 0xFF;
 		(*channel++).hw_value = txpwr >> 8;
 	}
+	/* Handle the differing rfkill GPIO bit in different models */
+	priv->rfkill_mask = RFKILL_MASK_8187_89_97;
+	if (product_id == 0x8197 || product_id == 0x8198) {
+		eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_SELECT_GPIO, &reg);
+		if (reg & 0xFF00)
+			priv->rfkill_mask = RFKILL_MASK_8198;
+	}
 
 	/*
 	 * XXX: Once this driver supports anything that requires
@@ -1516,9 +1524,9 @@ static int __devinit rtl8187_probe(struc
 	mutex_init(&priv->conf_mutex);
 	skb_queue_head_init(&priv->b_tx_status.queue);
 
-	printk(KERN_INFO "%s: hwaddr %pM, %s V%d + %s\n",
+	printk(KERN_INFO "%s: hwaddr %pM, %s V%d + %s, rfkill mask %d\n",
 	       wiphy_name(dev->wiphy), dev->wiphy->perm_addr,
-	       chip_name, priv->asic_rev, priv->rf->name);
+	       chip_name, priv->asic_rev, priv->rf->name, priv->rfkill_mask);
 
 #ifdef CONFIG_RTL8187_LEDS
 	eeprom_93cx6_read(&eeprom, 0x3F, &reg);
--- a/drivers/net/wireless/rtl818x/rtl8187.h
+++ b/drivers/net/wireless/rtl818x/rtl8187.h
@@ -23,6 +23,7 @@
 #define RTL8187_EEPROM_TXPWR_CHAN_1	0x16	/* 3 channels */
 #define RTL8187_EEPROM_TXPWR_CHAN_6	0x1B	/* 2 channels */
 #define RTL8187_EEPROM_TXPWR_CHAN_4	0x3D	/* 2 channels */
+#define RTL8187_EEPROM_SELECT_GPIO	0x3B
 
 #define RTL8187_REQT_READ	0xC0
 #define RTL8187_REQT_WRITE	0x40
@@ -31,6 +32,9 @@
 
 #define RTL8187_MAX_RX		0x9C4
 
+#define RFKILL_MASK_8187_89_97	0x2
+#define RFKILL_MASK_8198	0x4
+
 struct rtl8187_rx_info {
 	struct urb *urb;
 	struct ieee80211_hw *dev;
@@ -123,6 +127,7 @@ struct rtl8187_priv {
 	u8 noise;
 	u8 slot_time;
 	u8 aifsn[4];
+	u8 rfkill_mask;
 	struct {
 		__le64 buf;
 		struct sk_buff_head queue;
--- a/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
@@ -25,10 +25,10 @@ static bool rtl8187_is_radio_enabled(str
 	u8 gpio;
 
 	gpio = rtl818x_ioread8(priv, &priv->map->GPIO0);
-	rtl818x_iowrite8(priv, &priv->map->GPIO0, gpio & ~0x02);
+	rtl818x_iowrite8(priv, &priv->map->GPIO0, gpio & ~priv->rfkill_mask);
 	gpio = rtl818x_ioread8(priv, &priv->map->GPIO1);
 
-	return gpio & 0x02;
+	return gpio & priv->rfkill_mask;
 }
 
 void rtl8187_rfkill_init(struct ieee80211_hw *hw)


