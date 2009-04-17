Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbZDQOST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbZDQOST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756294AbZDQOSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:18:08 -0400
Received: from mail.it-technology.at ([62.99.145.147]:33702 "EHLO
	mail.it-technology.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbZDQOSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:18:06 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Apr 2009 10:18:06 EDT
Message-ID: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at>
Date: Fri, 17 Apr 2009 16:10:24 +0200 (CEST)
Subject: [PATCH] usb driver for intellon based PLC like devolo dlan duo
From: "Peter Holik" <peter@holik.at>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Holik <peter@holik.at>
---
 drivers/net/usb/Kconfig    |    7 +
 drivers/net/usb/Makefile   |    2 +-
 drivers/net/usb/intellon.c |  273 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 281 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/usb/intellon.c

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 8ee2103..068faa5 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -345,4 +345,11 @@ config USB_HSO
 	  To compile this driver as a module, choose M here: the
 	  module will be called hso.

+config USB_NET_INTELLON
+	tristate "Intellon PLC based usb adapter"
+	depends on USB_USBNET
+	help
+	  Choose this option if you're using a PLC (Powerline Communications)
+	  solution with an Intellon chip, like the "devolo dLan duo".
+
 endmenu
diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
index 88a87ee..0fccfe9 100644
--- a/drivers/net/usb/Makefile
+++ b/drivers/net/usb/Makefile
@@ -19,4 +19,4 @@ obj-$(CONFIG_USB_NET_CDC_SUBSET)	+= cdc_subset.o
 obj-$(CONFIG_USB_NET_ZAURUS)	+= zaurus.o
 obj-$(CONFIG_USB_NET_MCS7830)	+= mcs7830.o
 obj-$(CONFIG_USB_USBNET)	+= usbnet.o
-
+obj-$(CONFIG_USB_NET_INTELLON)	+= intellon.o
diff --git a/drivers/net/usb/intellon.c b/drivers/net/usb/intellon.c
new file mode 100644
index 0000000..c9fcc38
--- /dev/null
+++ b/drivers/net/usb/intellon.c
@@ -0,0 +1,273 @@
+/*
+ * Copyright (c) 2009 Peter Holik
+ *
+ * Intellon PLC (Powerline Communications) usb net driver
+ *
+ * http://www.tandel.be/downloads/INT51X1_Datasheet.pdf
+ *
+ * Based on the work of Jan 'RedBully' Seiffert
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or.
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Should you need to contact me, the author, you can do so either by
+ * e-mail - mail your message to <vojtech@suse.cz>, or by paper mail:
+ * Vojtech Pavlik, Simunkova 1594, Prague 8, 182 00 Czech Republic
+ */
+
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/mii.h>
+#include <linux/usb.h>
+#include <linux/usb/usbnet.h>
+
+#define INTELLON_VENDOR_ID	0x09e1
+#define INTELLON_PRODUCT_ID	0x5121
+
+#define INTELLON_HEADER_SIZE	2	/* 2 byte header */
+
+#define PACKET_TYPE_PROMISCUOUS		(1 << 0)
+#define PACKET_TYPE_ALL_MULTICAST	(1 << 1) /* no filter */
+#define PACKET_TYPE_DIRECTED		(1 << 2)
+#define PACKET_TYPE_BROADCAST		(1 << 3)
+#define PACKET_TYPE_MULTICAST		(1 << 4) /* filtered */
+
+#define SET_ETHERNET_PACKET_FILTER	0x43
+
+static u8 nibble(unsigned char c)
+{
+	if (likely(isdigit(c)))
+		return c - '0';
+	c = toupper(c);
+	if (likely(isxdigit(c)))
+		return 10 + c - 'A';
+	return 0;
+}
+
+static inline int get_ethernet_addr(struct usbnet *dev)
+{
+	int             tmp, i;
+	unsigned char   buf [13];
+
+	tmp = usb_string(dev->udev, 3, buf, sizeof buf);
+	if (tmp != 12) {
+		devdbg(dev, "bad MAC string fetch, %d\n", tmp);
+		if (tmp >= 0)
+			tmp = -EINVAL;
+		return tmp;
+	}
+	for (i = tmp = 0; i < 6; i++, tmp += 2)
+		dev->net->dev_addr [i] =
+			(nibble(buf [tmp]) << 4) + nibble(buf [tmp + 1]);
+	return 0;
+}
+
+
+static int intellon_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
+{
+	int len;
+
+	if (unlikely(skb->len < INTELLON_HEADER_SIZE)) {
+		deverr(dev, "unexpected tiny rx frame");
+		return 0;
+	}
+
+	len = (skb->data[skb->len - 2] | (skb->data[skb->len - 1] << 8));
+
+	skb_trim(skb, len);
+
+	return 1;
+}
+
+static struct sk_buff *intellon_tx_fixup(struct usbnet *dev,
+		struct sk_buff *skb, gfp_t flags)
+{
+	int pack_len = skb->len;
+	int headroom = skb_headroom(skb);
+	int tailroom = skb_tailroom(skb);
+	int need_tail = 0;
+
+	/*
+	 * usbnet would send a ZLP if packetlength mod urbsize == 0 for us,
+	 * but we need to know ourself, because this would add to the length
+	 * we send down to the device...
+	 */
+	if (!((pack_len + INTELLON_HEADER_SIZE) % dev->maxpacket))
+		need_tail = 1;
+
+	/* if packet and our header is smaler than 64 pad to 64 (+ ZLP) */
+	if ((pack_len + INTELLON_HEADER_SIZE + need_tail) < dev->maxpacket + 1)
+		need_tail = dev->maxpacket + 1 - pack_len - INTELLON_HEADER_SIZE;
+
+	if (!skb_cloned(skb) &&
+			(headroom + tailroom >= need_tail + INTELLON_HEADER_SIZE)) {
+		if (headroom < INTELLON_HEADER_SIZE || tailroom < need_tail) {
+			skb->data = memmove(skb->head + INTELLON_HEADER_SIZE,
+					skb->data, skb->len);
+			skb_set_tail_pointer(skb, skb->len);
+		}
+	} else {
+		struct sk_buff *skb2;
+
+		skb2 = skb_copy_expand(skb,
+				INTELLON_HEADER_SIZE,
+				need_tail,
+				flags);
+		dev_kfree_skb_any(skb);
+		if (!skb2)
+			return skb2;
+		skb = skb2;
+	}
+
+	pack_len += need_tail;
+
+	__skb_push(skb, INTELLON_HEADER_SIZE);
+
+	skb->data[0] = pack_len & 0xFF;
+	skb->data[1] = (pack_len & 0x700) >> 8;
+
+	if(need_tail)
+		memset(__skb_put(skb, need_tail), 0, need_tail);
+
+	return skb;
+}
+
+static void intellon_async_cmd_callback(struct urb *urb)
+{
+	struct usb_ctrlrequest *req = (struct usb_ctrlrequest *)urb->context;
+	int status = urb->status;
+
+	if (status < 0)
+		dev_warn(&urb->dev->dev, "async callback failed with %d\n", status);
+
+	kfree(req);
+	usb_free_urb(urb);
+}
+
+static void intellon_set_multicast(struct net_device *netdev)
+{
+	struct usb_ctrlrequest *req;
+	int status;
+	struct urb *urb;
+	struct usbnet *dev = netdev_priv(netdev);
+	u16 filter = PACKET_TYPE_DIRECTED |
+		     PACKET_TYPE_BROADCAST;
+
+	if (netdev->flags & IFF_PROMISC) {
+		/* do not expect to see traffic of other PLCs */
+		filter |= PACKET_TYPE_PROMISCUOUS;
+		devinfo(dev, "promiscuous mode enabled");
+	} else if (netdev->mc_count ||
+		  (netdev->flags & IFF_ALLMULTI)) {
+		filter |= PACKET_TYPE_ALL_MULTICAST;
+		devdbg(dev, "receive all multicast enabled");
+	} else {
+		/* ~PROMISCUOUS, ~MULTICAST */
+		devdbg(dev, "receive own packets only");
+	}
+
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!urb) {
+		devwarn(dev, "Error allocating URB");
+		return;
+	}
+
+	req = kmalloc(sizeof *req, GFP_ATOMIC);
+	if (!req) {
+		devwarn(dev, "Error allocating control msg");
+		usb_free_urb(urb);
+		return;
+	}
+
+	req->bRequestType = USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE;
+	req->bRequest = SET_ETHERNET_PACKET_FILTER;
+	req->wValue = cpu_to_le16(filter);
+	req->wIndex = 0;
+	req->wLength = 0;
+
+	usb_fill_control_urb(urb, dev->udev, usb_sndctrlpipe(dev->udev, 0),
+		(void *)req, NULL, 0,
+		intellon_async_cmd_callback,
+		(void *)req);
+
+	status = usb_submit_urb(urb, GFP_ATOMIC);
+	if (status < 0) {
+		devwarn(dev, "Error submitting control msg, sts=%d", status);
+		kfree(req);
+		usb_free_urb(urb);
+	}
+}
+
+static int intellon_bind(struct usbnet *dev, struct usb_interface *intf)
+{
+	int status = get_ethernet_addr(dev);
+
+	if (status)
+		return status;
+
+	dev->net->hard_header_len += INTELLON_HEADER_SIZE;
+	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
+	dev->net->set_multicast_list = intellon_set_multicast;
+
+	return usbnet_get_endpoints(dev, intf);
+}
+
+static const struct driver_info intellon_info = {
+	.description = "Intellon powerline adapter",
+	.bind        = intellon_bind,
+	.rx_fixup    = intellon_rx_fixup,
+	.tx_fixup    = intellon_tx_fixup,
+	.in          = 1,
+	.out         = 2,
+	.flags      = FLAG_ETHER,
+};
+
+static const struct usb_device_id products[] = {
+	{
+	USB_DEVICE(INTELLON_VENDOR_ID, INTELLON_PRODUCT_ID),
+		.driver_info = (unsigned long) &intellon_info,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(usb, products);
+
+static struct usb_driver intellon_driver = {
+	.name       = "intellon",
+	.id_table   = products,
+	.probe      = usbnet_probe,
+	.disconnect = usbnet_disconnect,
+	.suspend    = usbnet_suspend,
+	.resume     = usbnet_resume,
+};
+
+static int __init intellon_init(void)
+{
+	return usb_register(&intellon_driver);
+}
+module_init(intellon_init);
+
+static void __exit intellon_exit(void)
+{
+	usb_deregister(&intellon_driver);
+}
+module_exit(intellon_exit);
+
+MODULE_AUTHOR("Peter Holik");
+MODULE_DESCRIPTION("Intellon powerline adapter");
+MODULE_LICENSE("GPL");
-- 
1.6.2.1


