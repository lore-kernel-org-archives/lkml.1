Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYFCSTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYFCSTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 14:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbYFCST1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 14:19:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:47940 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbYFCSTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 14:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qwXW6TdHwoY4homGMjRdfbCgFJh4NxH/kOcXSkH7qV4tM1XfG5kopJnYDECF8aVBN+42JrYNvcXSVeFHnoyLTQFOT32WY2wzUVD49dNbbv8xH6V53KCXTvzGmoUfaCsaJ43czRy8R7qvgtdPnZr8VIM1wtbp7a/fXZruM1pqfas=
Subject: [PATCH 2/2] bluetooth: hci_bcsp.c small cleanups/api users
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 11:19:21 -0700
Message-Id: <1212517161.11008.60.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use bitrev16 from lib/bitrev.c.

Use the get_unaligned_be16 to get the crc from the packet, create a
small helper function for this.

Fix a shadowed variable sparse warning:
drivers/bluetooth/hci_bcsp.c:218:26: warning: symbol 'hdr' shadows an earlier one
drivers/bluetooth/hci_bcsp.c:187:5: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Actually, the cleanups weren't worth splitting.  I combined them in this one patch.

 drivers/bluetooth/hci_bcsp.c |   44 ++++++++++++-----------------------------
 1 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index 696f752..4d37bb3 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -39,6 +39,8 @@
 #include <linux/signal.h>
 #include <linux/ioctl.h>
 #include <linux/skbuff.h>
+#include <linux/bitrev.h>
+#include <asm/unaligned.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -124,27 +126,6 @@ static void bcsp_crc_update(u16 *crc, u8 d)
 	*crc = reg;
 }
 
-/*
-   Get reverse of generated crc
-
-   Implementation note
-        The crc generator (bcsp_crc_init() and bcsp_crc_update())
-        creates a reversed crc, so it needs to be swapped back before
-        being passed on.
-*/
-static u16 bcsp_crc_reverse(u16 crc)
-{
-	u16 b, rev;
-
-	for (b = 0, rev = 0; b < 16; b++) {
-		rev = rev << 1;
-		rev |= (crc & 1);
-		crc = crc >> 1;
-	}
-
-	return (rev);
-}
-
 /* ---- BCSP core ---- */
 
 static void bcsp_slip_msgdelim(struct sk_buff *skb)
@@ -235,10 +216,10 @@ static struct sk_buff *bcsp_prepare_pkt(struct bcsp_struct *bcsp, u8 *data,
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
@@ -296,7 +277,7 @@ static struct sk_buff *bcsp_prepare_pkt(struct bcsp_struct *bcsp, u8 *data,
 
 	/* Put CRC */
 	if (bcsp->use_crc) {
-		bcsp_txmsg_crc = bcsp_crc_reverse(bcsp_txmsg_crc);
+		bcsp_txmsg_crc = bitrev16(bcsp_txmsg_crc);
 		bcsp_slip_one_byte(nskb, (u8) ((bcsp_txmsg_crc >> 8) & 0x00ff));
 		bcsp_slip_one_byte(nskb, (u8) (bcsp_txmsg_crc & 0x00ff));
 	}
@@ -566,6 +547,11 @@ static void bcsp_complete_rx_pkt(struct hci_uart *hu)
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
@@ -624,14 +610,10 @@ static int bcsp_recv(struct hci_uart *hu, void *data, int count)
 			continue;
 
 		case BCSP_W4_CRC:
-			if (bcsp_crc_reverse(bcsp->message_crc) !=
-					(bcsp->rx_skb->data[bcsp->rx_skb->len - 2] << 8) +
-					bcsp->rx_skb->data[bcsp->rx_skb->len - 1]) {
-
+			if (bitrev16(bcsp->message_crc) != bscp_get_crc(bcsp)) {
 				BT_ERR ("Checksum failed: computed %04x received %04x",
-					bcsp_crc_reverse(bcsp->message_crc),
-					(bcsp->rx_skb-> data[bcsp->rx_skb->len - 2] << 8) +
-					bcsp->rx_skb->data[bcsp->rx_skb->len - 1]);
+					bitrev16(bcsp->message_crc),
+					bscp_get_crc(bcsp));
 
 				kfree_skb(bcsp->rx_skb);
 				bcsp->rx_state = BCSP_W4_PKT_DELIMITER;
-- 
1.5.6.rc0.336.ge5422

