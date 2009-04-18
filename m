Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZDRRZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZDRRZJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 13:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZDRRY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 13:24:28 -0400
Received: from mail.it-technology.at ([62.99.145.147]:46446 "EHLO
	mail.it-technology.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbZDRRYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 13:24:23 -0400
Message-ID: <0cc31a2bd4e0a1104a7c53b323c3cab4.squirrel@webmail.it-technology.at>
Date: Sat, 18 Apr 2009 19:24:21 +0200 (CEST)
Subject: [PATCH 2/2] usb driver for intellon int51x1 based PLC like devolo 
     dlan duo
From: "Peter Holik" <peter@holik.at>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Netdev" <netdev@vger.kernel.org>, linux-usb@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb driver for intellon int51x1 based PLC like devolo dlan duo
with improvements suggested by the guys of the mailinglist:
- name and prefix with int51x1 (Florian Fainelli)
- use conversion functions cpu_to_le16 / le16_to_cpu (Oliver Neukum)
- use pskb_may_pull instead of skb->len (Ilpo Järvinen)
- better code in tx_fixup (Ilpo Järvinen)
- use gotos for error handling (Ilpo Järvinen)
- better description (Jon Smirl)

Signed-off-by: Peter Holik <peter@holik.at>
---
 drivers/net/usb/Kconfig   |    8 ++
 drivers/net/usb/Makefile  |    1 +
 drivers/net/usb/int51x1.c |  253 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 262 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/usb/int51x1.c

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 8ee2103..e00b5b1 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -345,4 +345,12 @@ config USB_HSO
 	  To compile this driver as a module, choose M here: the
 	  module will be called hso.

+config USB_NET_INT51X1
+	tristate "Intellon PLC based usb adapter"
+	depends on USB_USBNET
+	help
+	  Choose this option if you're using a 14Mb USB-based PLC
+	  (Powerline Communications) solution with an Intellon
+	  INT51x1/INT5200 chip, like the "devolo dLan duo".
+
 endmenu
diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
index 88a87ee..f4402a0 100644
--- a/drivers/net/usb/Makefile
+++ b/drivers/net/usb/Makefile
@@ -19,4 +19,5 @@ obj-$(CONFIG_USB_NET_CDC_SUBSET)	+= cdc_subset.o
 obj-$(CONFIG_USB_NET_ZAURUS)	+= zaurus.o
 obj-$(CONFIG_USB_NET_MCS7830)	+= mcs7830.o
 obj-$(CONFIG_USB_USBNET)	+= usbnet.o
+obj-$(CONFIG_USB_NET_INT51X1)	+= int51x1.o

diff --git a/drivers/net/usb/int51x1.c b/drivers/net/usb/int51x1.c
new file mode 100644
index 0000000..55cf708
--- /dev/null
+++ b/drivers/net/usb/int51x1.c
@@ -0,0 +1,253 @@
+/*
+ * Copyright (c) 2009 Peter Holik
+ *
+ * Intellon usb PLC (Powerline Communications) usb net driver
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
+#define INT51X1_VENDOR_ID	0x09e1
+#define INT51X1_PRODUCT_ID	0x5121
+
+#define INT51X1_HEADER_SIZE	2	/* 2 byte header */
+
+#define PACKET_TYPE_PROMISCUOUS		(1 << 0)
+#define PACKET_TYPE_ALL_MULTICAST	(1 << 1) /* no filter */
+#define PACKET_TYPE_DIRECTED		(1 << 2)
+#define PACKET_TYPE_BROADCAST		(1 << 3)
+#define PACKET_TYPE_MULTICAST		(1 << 4) /* filtered */
+
+#define SET_ETHERNET_PACKET_FILTER	0x43
+
+static int int51x1_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
+{
+	int len;
+
+	if (!(pskb_may_pull(skb, INT51X1_HEADER_SIZE))) {
+		deverr(dev, "unexpected tiny rx frame");
+		return 0;
+	}
+
+	len = le16_to_cpu(*(__le16 *)&skb->data[skb->len - 2]);
+
+	skb_trim(skb, len);
+
+	return 1;
+}
+
+static struct sk_buff *int51x1_tx_fixup(struct usbnet *dev,
+		struct sk_buff *skb, gfp_t flags)
+{
+	int pack_len = skb->len;
+	int pack_with_header_len = pack_len + INT51X1_HEADER_SIZE;
+	int headroom = skb_headroom(skb);
+	int tailroom = skb_tailroom(skb);
+	int need_tail = 0;
+	__le16 *len;
+
+	/* if packet and our header is smaler than 64 pad to 64 (+ ZLP) */
+	if ((pack_with_header_len) < dev->maxpacket)
+		need_tail = dev->maxpacket - pack_with_header_len + 1;
+	/*
+	 * usbnet would send a ZLP if packetlength mod urbsize == 0 for us,
+	 * but we need to know ourself, because this would add to the length
+	 * we send down to the device...
+	 */
+	else if (!(pack_with_header_len % dev->maxpacket))
+		need_tail = 1;
+
+	if (!skb_cloned(skb) &&
+			(headroom + tailroom >= need_tail + INT51X1_HEADER_SIZE)) {
+		if (headroom < INT51X1_HEADER_SIZE || tailroom < need_tail) {
+			skb->data = memmove(skb->head + INT51X1_HEADER_SIZE,
+					skb->data, skb->len);
+			skb_set_tail_pointer(skb, skb->len);
+		}
+	} else {
+		struct sk_buff *skb2;
+
+		skb2 = skb_copy_expand(skb,
+				INT51X1_HEADER_SIZE,
+				need_tail,
+				flags);
+		dev_kfree_skb_any(skb);
+		if (!skb2)
+			return NULL;
+		skb = skb2;
+	}
+
+	pack_len += need_tail;
+	pack_len &= 0x07ff;
+
+	len = (__le16 *) __skb_push(skb, INT51X1_HEADER_SIZE);
+	*len = cpu_to_le16(pack_len);
+
+	if(need_tail)
+		memset(__skb_put(skb, need_tail), 0, need_tail);
+
+	return skb;
+}
+
+static void int51x1_async_cmd_callback(struct urb *urb)
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
+static void int51x1_set_multicast(struct net_device *netdev)
+{
+	struct usb_ctrlrequest *req;
+	int status;
+	struct urb *urb;
+	struct usbnet *dev = netdev_priv(netdev);
+	u16 filter = PACKET_TYPE_DIRECTED | PACKET_TYPE_BROADCAST;
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
+	req = kmalloc(sizeof(*req), GFP_ATOMIC);
+	if (!req) {
+		devwarn(dev, "Error allocating control msg");
+		goto out;
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
+		int51x1_async_cmd_callback,
+		(void *)req);
+
+	status = usb_submit_urb(urb, GFP_ATOMIC);
+	if (status < 0) {
+		devwarn(dev, "Error submitting control msg, sts=%d", status);
+		goto out1;
+	}
+	return;
+out1:
+	kfree(req);
+out:
+	usb_free_urb(urb);
+}
+
+static const struct net_device_ops int51x1_netdev_ops = {
+	.ndo_open		= usbnet_open,
+	.ndo_stop		= usbnet_stop,
+	.ndo_start_xmit		= usbnet_start_xmit,
+	.ndo_tx_timeout		= usbnet_tx_timeout,
+	.ndo_change_mtu		= usbnet_change_mtu,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_set_multicast_list	= int51x1_set_multicast,
+};
+
+static int int51x1_bind(struct usbnet *dev, struct usb_interface *intf)
+{
+	int status = usbnet_get_ethernet_addr(dev, 3);
+
+	if (status)
+		return status;
+
+	dev->net->hard_header_len += INT51X1_HEADER_SIZE;
+	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
+	dev->net->netdev_ops = &int51x1_netdev_ops;
+
+	return usbnet_get_endpoints(dev, intf);
+}
+
+static const struct driver_info int51x1_info = {
+	.description = "Intellon usb powerline adapter",
+	.bind        = int51x1_bind,
+	.rx_fixup    = int51x1_rx_fixup,
+	.tx_fixup    = int51x1_tx_fixup,
+	.in          = 1,
+	.out         = 2,
+	.flags       = FLAG_ETHER,
+};
+
+static const struct usb_device_id products[] = {
+	{
+	USB_DEVICE(INT51X1_VENDOR_ID, INT51X1_PRODUCT_ID),
+		.driver_info = (unsigned long) &int51x1_info,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(usb, products);
+
+static struct usb_driver int51x1_driver = {
+	.name       = "int51x1",
+	.id_table   = products,
+	.probe      = usbnet_probe,
+	.disconnect = usbnet_disconnect,
+	.suspend    = usbnet_suspend,
+	.resume     = usbnet_resume,
+};
+
+static int __init int51x1_init(void)
+{
+	return usb_register(&int51x1_driver);
+}
+module_init(int51x1_init);
+
+static void __exit int51x1_exit(void)
+{
+	usb_deregister(&int51x1_driver);
+}
+module_exit(int51x1_exit);
+
+MODULE_AUTHOR("Peter Holik");
+MODULE_DESCRIPTION("Intellon usb powerline adapter");
+MODULE_LICENSE("GPL");
-- 
1.6.2.1




