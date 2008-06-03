Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbYFCRzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbYFCRzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 13:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYFCRzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 13:55:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:58601 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYFCRzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 13:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hoD490nXJYi5leFcpe9pXNSFS/N6mpMJ1Vgx+YsR2IdxJZ4ADB1TZbEUzpCVGG/KeX1oHZrktf8TRrSSlu/V85+klzTmtmkdJ4dHxfgXGdZUl17kbxoVUpREU6YM/c5W0AeFkrXyyrXF9D5JPyBA9K5soJ/ld6kSZVYNGDbDuEw=
Subject: [PATCH] bluetooth: remove private bitrev16 implementation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 10:55:34 -0700
Message-Id: <1212515734.11008.49.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose bitrev16 from lib/bitrev.c and use it.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/bluetooth/hci_bcsp.c |   28 ++++------------------------
 include/linux/bitrev.h       |    1 +
 lib/bitrev.c                 |    3 ++-
 3 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index 696f752..d8cd41b 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -39,6 +39,7 @@
 #include <linux/signal.h>
 #include <linux/ioctl.h>
 #include <linux/skbuff.h>
+#include <linux/bitrev.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -124,27 +125,6 @@ static void bcsp_crc_update(u16 *crc, u8 d)
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
@@ -296,7 +276,7 @@ static struct sk_buff *bcsp_prepare_pkt(struct bcsp_struct *bcsp, u8 *data,
 
 	/* Put CRC */
 	if (bcsp->use_crc) {
-		bcsp_txmsg_crc = bcsp_crc_reverse(bcsp_txmsg_crc);
+		bcsp_txmsg_crc = bitrev16(bcsp_txmsg_crc);
 		bcsp_slip_one_byte(nskb, (u8) ((bcsp_txmsg_crc >> 8) & 0x00ff));
 		bcsp_slip_one_byte(nskb, (u8) (bcsp_txmsg_crc & 0x00ff));
 	}
@@ -624,12 +604,12 @@ static int bcsp_recv(struct hci_uart *hu, void *data, int count)
 			continue;
 
 		case BCSP_W4_CRC:
-			if (bcsp_crc_reverse(bcsp->message_crc) !=
+			if (bitrev16(bcsp->message_crc) !=
 					(bcsp->rx_skb->data[bcsp->rx_skb->len - 2] << 8) +
 					bcsp->rx_skb->data[bcsp->rx_skb->len - 1]) {
 
 				BT_ERR ("Checksum failed: computed %04x received %04x",
-					bcsp_crc_reverse(bcsp->message_crc),
+					bitrev16(bcsp->message_crc),
 					(bcsp->rx_skb-> data[bcsp->rx_skb->len - 2] << 8) +
 					bcsp->rx_skb->data[bcsp->rx_skb->len - 1]);
 
diff --git a/include/linux/bitrev.h b/include/linux/bitrev.h
index 05e540d..7ffe03f 100644
--- a/include/linux/bitrev.h
+++ b/include/linux/bitrev.h
@@ -10,6 +10,7 @@ static inline u8 bitrev8(u8 byte)
 	return byte_rev_table[byte];
 }
 
+extern u16 bitrev16(u16 in);
 extern u32 bitrev32(u32 in);
 
 #endif /* _LINUX_BITREV_H */
diff --git a/lib/bitrev.c b/lib/bitrev.c
index 989aff7..3956203 100644
--- a/lib/bitrev.c
+++ b/lib/bitrev.c
@@ -42,10 +42,11 @@ const u8 byte_rev_table[256] = {
 };
 EXPORT_SYMBOL_GPL(byte_rev_table);
 
-static __always_inline u16 bitrev16(u16 x)
+u16 bitrev16(u16 x)
 {
 	return (bitrev8(x & 0xff) << 8) | bitrev8(x >> 8);
 }
+EXPORT_SYMBOL(bitrev16);
 
 /**
  * bitrev32 - reverse the order of bits in a u32 value
-- 
1.5.6.rc0.336.ge5422



