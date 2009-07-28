Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbZG1XEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbZG1XEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932079AbZG1XEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:04:12 -0400
Received: from kroah.org ([198.145.64.141]:43076 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbZG1XEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:04:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:45 2009
Message-Id: <20090728225945.550576241@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Buesch <mb@bu3sch.de>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 31/37] pegasus usb-net: Fix endianness bugs
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=pegasus-usb-net-fix-endianness-bugs.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Buesch <mb@bu3sch.de>

[ Upstream commit e3453f6342110d60edb37be92c4a4f668ca8b0c4 ]

This fixes various endianness bugs. Some harmless and some real ones.
This is tested on a PowerPC-64 machine.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/usb/pegasus.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -295,7 +295,7 @@ static int update_eth_regs_async(pegasus
 
 	pegasus->dr.bRequestType = PEGASUS_REQT_WRITE;
 	pegasus->dr.bRequest = PEGASUS_REQ_SET_REGS;
-	pegasus->dr.wValue = 0;
+	pegasus->dr.wValue = cpu_to_le16(0);
 	pegasus->dr.wIndex = cpu_to_le16(EthCtrl0);
 	pegasus->dr.wLength = cpu_to_le16(3);
 	pegasus->ctrl_urb->transfer_buffer_length = 3;
@@ -444,11 +444,12 @@ static int write_eprom_word(pegasus_t * 
 	int i;
 	__u8 tmp, d[4] = { 0x3f, 0, 0, EPROM_WRITE };
 	int ret;
+	__le16 le_data = cpu_to_le16(data);
 
 	set_registers(pegasus, EpromOffset, 4, d);
 	enable_eprom_write(pegasus);
 	set_register(pegasus, EpromOffset, index);
-	set_registers(pegasus, EpromData, 2, &data);
+	set_registers(pegasus, EpromData, 2, &le_data);
 	set_register(pegasus, EpromCtrl, EPROM_WRITE);
 
 	for (i = 0; i < REG_TIMEOUT; i++) {
@@ -918,29 +919,32 @@ static struct net_device_stats *pegasus_
 
 static inline void disable_net_traffic(pegasus_t * pegasus)
 {
-	int tmp = 0;
+	__le16 tmp = cpu_to_le16(0);
 
-	set_registers(pegasus, EthCtrl0, 2, &tmp);
+	set_registers(pegasus, EthCtrl0, sizeof(tmp), &tmp);
 }
 
 static inline void get_interrupt_interval(pegasus_t * pegasus)
 {
-	__u8 data[2];
+	u16 data;
+	u8 interval;
 
-	read_eprom_word(pegasus, 4, (__u16 *) data);
+	read_eprom_word(pegasus, 4, &data);
+	interval = data >> 8;
 	if (pegasus->usb->speed != USB_SPEED_HIGH) {
-		if (data[1] < 0x80) {
+		if (interval < 0x80) {
 			if (netif_msg_timer(pegasus))
 				dev_info(&pegasus->intf->dev, "intr interval "
 					"changed from %ums to %ums\n",
-					data[1], 0x80);
-			data[1] = 0x80;
+					interval, 0x80);
+			interval = 0x80;
+			data = (data & 0x00FF) | ((u16)interval << 8);
 #ifdef PEGASUS_WRITE_EEPROM
-			write_eprom_word(pegasus, 4, *(__u16 *) data);
+			write_eprom_word(pegasus, 4, data);
 #endif
 		}
 	}
-	pegasus->intr_interval = data[1];
+	pegasus->intr_interval = interval;
 }
 
 static void set_carrier(struct net_device *net)
@@ -1293,7 +1297,8 @@ static int pegasus_blacklisted(struct us
 	/* Special quirk to keep the driver from handling the Belkin Bluetooth
 	 * dongle which happens to have the same ID.
 	 */
-	if ((udd->idVendor == VENDOR_BELKIN && udd->idProduct == 0x0121) &&
+	if ((udd->idVendor == cpu_to_le16(VENDOR_BELKIN)) &&
+	    (udd->idProduct == cpu_to_le16(0x0121)) &&
 	    (udd->bDeviceClass == USB_CLASS_WIRELESS_CONTROLLER) &&
 	    (udd->bDeviceProtocol == 1))
 		return 1;


