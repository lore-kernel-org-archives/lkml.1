Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbZJIXmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbZJIXmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761655AbZJIXmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:42:51 -0400
Received: from kroah.org ([198.145.64.141]:51487 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761602AbZJIXmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:42:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:34:40 2009
Message-Id: <20091009233440.157774034@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:34:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Steve Glendinning <steve.glendinning@smsc.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 32/37] smsc95xx: fix transmission where ZLP is expected
References: <20091009233411.852013234@mini.kroah.org>
Content-Disposition: inline; filename=smsc95xx-fix-transmission-where-zlp-is-expected.patch
In-Reply-To: <20091009233812.GA15982@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steve Glendinning <steve.glendinning@smsc.com>

[ Upstream commit ec4756238239f1a331d9fb95bad8b281dad56855 ]

Usbnet framework assumes USB hardware doesn't handle zero length
packets, but SMSC LAN95xx requires these to be sent for correct
operation.

This patch fixes an easily reproducible tx lockup when sending a frame
that results in exactly 512 bytes in a USB transmission (e.g. a UDP
frame with 458 data bytes, due to IP headers and our USB headers).  It
adds an extra flag to usbnet for the hardware driver to indicate that
it can handle and requires the zero length packets.

This patch should not affect other usbnet users, please also consider
for -stable.

Signed-off-by: Steve Glendinning <steve.glendinning@smsc.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/usb/smsc95xx.c |    2 +-
 drivers/net/usb/usbnet.c   |    2 +-
 include/linux/usb/usbnet.h |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1232,7 +1232,7 @@ static const struct driver_info smsc95xx
 	.rx_fixup	= smsc95xx_rx_fixup,
 	.tx_fixup	= smsc95xx_tx_fixup,
 	.status		= smsc95xx_status,
-	.flags		= FLAG_ETHER,
+	.flags		= FLAG_ETHER | FLAG_SEND_ZLP,
 };
 
 static const struct usb_device_id products[] = {
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -988,7 +988,7 @@ int usbnet_start_xmit (struct sk_buff *s
 	 * NOTE:  strictly conforming cdc-ether devices should expect
 	 * the ZLP here, but ignore the one-byte packet.
 	 */
-	if ((length % dev->maxpacket) == 0) {
+	if (!(info->flags & FLAG_SEND_ZLP) && (length % dev->maxpacket) == 0) {
 		urb->transfer_buffer_length++;
 		if (skb_tailroom(skb)) {
 			skb->data[skb->len] = 0;
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -86,6 +86,7 @@ struct driver_info {
 
 #define FLAG_FRAMING_AX 0x0040		/* AX88772/178 packets */
 #define FLAG_WLAN	0x0080		/* use "wlan%d" names */
+#define FLAG_SEND_ZLP	0x0200		/* hw requires ZLPs are sent */
 
 
 	/* init device ... can sleep, or cause probe() failure */


