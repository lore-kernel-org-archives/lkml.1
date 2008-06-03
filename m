Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYFCSKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYFCSKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 14:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYFCSK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 14:10:28 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:22553 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbYFCSK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 14:10:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Eyf6iETrMdxoVDF6P3hq3uWP/iSSYxajZTAIINuybCk8bbZUbSOT840pQ/3Qk6p+jg3gqjNy7rcAAyrc1dyoX8OMF35n232o8Y2KF7KnDNXy2fVdA+BWo5w2fxsfdjkUnEf1QvNSWx/eI+6ogJfSIlRw2Jzm280wykyGY5ir2HU=
Subject: [PATCH] bluetooth: hci_bcsp.c small cleanups
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 11:10:24 -0700
Message-Id: <1212516624.11008.52.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the get_unaligned_be16 to get the crc from the packet, create a
small helper function for this.

Fix a shadowed variable sparse warning:
drivers/bluetooth/hci_bcsp.c:218:26: warning: symbol 'hdr' shadows an earlier one
drivers/bluetooth/hci_bcsp.c:187:5: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/bluetooth/hci_bcsp.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index d8cd41b..4d37bb3 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -40,6 +40,7 @@
 #include <linux/ioctl.h>
 #include <linux/skbuff.h>
 #include <linux/bitrev.h>
+#include <asm/unaligned.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -215,10 +216,10 @@ static struct sk_buff *bcsp_prepare_pkt(struct bcsp_struct *bcsp, u8 *data,
 	}
 
 	if (hciextn && chan == 5) {
-		struct hci_command_hdr *hdr = (struct hci_command_hdr *) data;
+		__le16 opcode = ((struct hci_command_hdr *)data)->opcode;
 
 		/* Vendor specific commands */
-		if (hci_opcode_ogf(__le16_to_cpu(hdr->opcode)) == 0x3f) {
+		if (hci_opcode_ogf(__le16_to_cpu(opcode)) == 0x3f) {
 			u8 desc = *(data + HCI_COMMAND_HDR_SIZE);
 			if ((desc & 0xf0) == 0xc0) {
 				data += HCI_COMMAND_HDR_SIZE + 1;
@@ -546,6 +547,11 @@ static void bcsp_complete_rx_pkt(struct hci_uart *hu)
 	bcsp->rx_skb = NULL;
 }
 
+static u16 bscp_get_crc(struct bcsp_struct *bcsp)
+{
+	return get_unaligned_be16(&bcsp->rx_skb->data[bcsp->rx_skb->len - 2]);
+}
+
 /* Recv data */
 static int bcsp_recv(struct hci_uart *hu, void *data, int count)
 {
@@ -604,14 +610,10 @@ static int bcsp_recv(struct hci_uart *hu, void *data, int count)
 			continue;
 
 		case BCSP_W4_CRC:
-			if (bitrev16(bcsp->message_crc) !=
-					(bcsp->rx_skb->data[bcsp->rx_skb->len - 2] << 8) +
-					bcsp->rx_skb->data[bcsp->rx_skb->len - 1]) {
-
+			if (bitrev16(bcsp->message_crc) != bscp_get_crc(bcsp)) {
 				BT_ERR ("Checksum failed: computed %04x received %04x",
 					bitrev16(bcsp->message_crc),
-					(bcsp->rx_skb-> data[bcsp->rx_skb->len - 2] << 8) +
-					bcsp->rx_skb->data[bcsp->rx_skb->len - 1]);
+					bscp_get_crc(bcsp));
 
 				kfree_skb(bcsp->rx_skb);
 				bcsp->rx_state = BCSP_W4_PKT_DELIMITER;
-- 
1.5.6.rc0.336.ge5422



