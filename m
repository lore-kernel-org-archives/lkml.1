Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0CBXvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:51:04 -0500
Received: from kroah.org ([198.145.64.141]:51591 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab0CBXgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:36:55 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/36] serial: isicom.c: use pr_fmt and pr_<level>
Date: Tue,  2 Mar 2010 15:36:20 -0800
Message-Id: <1267573003-782-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Convert printks to pr_<level>
Convert some embedded function names to %s...__func__
Remove a period after exclamation points.
Remove #define pr_dbg which could be used by future kernel.h includes

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/isicom.c |   49 ++++++++++++++++++++++++++-----------------------
 1 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 300d5bd..77d5a29 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -113,6 +113,8 @@
  *		64-bit verification
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/firmware.h>
 #include <linux/kernel.h>
@@ -140,7 +142,6 @@
 #define InterruptTheCard(base) outw(0, (base) + 0xc)
 #define ClearInterrupt(base) inw((base) + 0x0a)
 
-#define pr_dbg(str...) pr_debug("ISICOM: " str)
 #ifdef DEBUG
 #define isicom_paranoia_check(a, b, c) __isicom_paranoia_check((a), (b), (c))
 #else
@@ -249,8 +250,7 @@ static int lock_card(struct isi_board *card)
 		spin_unlock_irqrestore(&card->card_lock, card->flags);
 		msleep(10);
 	}
-	printk(KERN_WARNING "ISICOM: Failed to lock Card (0x%lx)\n",
-		card->base);
+	pr_warning("Failed to lock Card (0x%lx)\n", card->base);
 
 	return 0;	/* Failed to acquire the card! */
 }
@@ -379,13 +379,13 @@ static inline int __isicom_paranoia_check(struct isi_port const *port,
 	char *name, const char *routine)
 {
 	if (!port) {
-		printk(KERN_WARNING "ISICOM: Warning: bad isicom magic for "
-			"dev %s in %s.\n", name, routine);
+		pr_warning("Warning: bad isicom magic for dev %s in %s.\n",
+			   name, routine);
 		return 1;
 	}
 	if (port->magic != ISICOM_MAGIC) {
-		printk(KERN_WARNING "ISICOM: Warning: NULL isicom port for "
-			"dev %s in %s.\n", name, routine);
+		pr_warning("Warning: NULL isicom port for dev %s in %s.\n",
+			   name, routine);
 		return 1;
 	}
 
@@ -450,8 +450,8 @@ static void isicom_tx(unsigned long _data)
 		if (!(inw(base + 0x02) & (1 << port->channel)))
 			continue;
 
-		pr_dbg("txing %d bytes, port%d.\n", txcount,
-			port->channel + 1);
+		pr_debug("txing %d bytes, port%d.\n",
+			 txcount, port->channel + 1);
 		outw((port->channel << isi_card[card].shift_count) | txcount,
 			base);
 		residue = NO;
@@ -547,8 +547,8 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 	byte_count = header & 0xff;
 
 	if (channel + 1 > card->port_count) {
-		printk(KERN_WARNING "ISICOM: isicom_interrupt(0x%lx): "
-			"%d(channel) > port_count.\n", base, channel+1);
+		pr_warning("%s(0x%lx): %d(channel) > port_count.\n",
+			   __func__, base, channel+1);
 		outw(0x0000, base+0x04); /* enable interrupts */
 		spin_unlock(&card->card_lock);
 		return IRQ_HANDLED;
@@ -582,14 +582,15 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 				if (port->status & ISI_DCD) {
 					if (!(header & ISI_DCD)) {
 					/* Carrier has been lost  */
-						pr_dbg("interrupt: DCD->low.\n"
-							);
+						pr_debug("%s: DCD->low.\n",
+							 __func__);
 						port->status &= ~ISI_DCD;
 						tty_hangup(tty);
 					}
 				} else if (header & ISI_DCD) {
 				/* Carrier has been detected */
-					pr_dbg("interrupt: DCD->high.\n");
+					pr_debug("%s: DCD->high.\n",
+						__func__);
 					port->status |= ISI_DCD;
 					wake_up_interruptible(&port->port.open_wait);
 				}
@@ -641,17 +642,19 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 			break;
 
 		case 2:	/* Statistics		 */
-			pr_dbg("isicom_interrupt: stats!!!.\n");
+			pr_debug("%s: stats!!!\n", __func__);
 			break;
 
 		default:
-			pr_dbg("Intr: Unknown code in status packet.\n");
+			pr_debug("%s: Unknown code in status packet.\n",
+				 __func__);
 			break;
 		}
 	} else {				/* Data   Packet */
 
 		count = tty_prepare_flip_string(tty, &rp, byte_count & ~1);
-		pr_dbg("Intr: Can rx %d of %d bytes.\n", count, byte_count);
+		pr_debug("%s: Can rx %d of %d bytes.\n",
+			 __func__, count, byte_count);
 		word_count = count >> 1;
 		insw(base, rp, word_count);
 		byte_count -= (word_count << 1);
@@ -661,8 +664,8 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 			byte_count -= 2;
 		}
 		if (byte_count > 0) {
-			pr_dbg("Intr(0x%lx:%d): Flip buffer overflow! dropping "
-				"bytes...\n", base, channel + 1);
+			pr_debug("%s(0x%lx:%d): Flip buffer overflow! dropping bytes...\n",
+				 __func__, base, channel + 1);
 		/* drain out unread xtra data */
 		while (byte_count > 0) {
 				inw(base);
@@ -888,8 +891,8 @@ static void isicom_shutdown_port(struct isi_port *port)
 	struct isi_board *card = port->card;
 
 	if (--card->count < 0) {
-		pr_dbg("isicom_shutdown_port: bad board(0x%lx) count %d.\n",
-			card->base, card->count);
+		pr_debug("%s: bad board(0x%lx) count %d.\n",
+			 __func__, card->base, card->count);
 		card->count = 0;
 	}
 	/* last port was closed, shutdown that board too */
@@ -1681,13 +1684,13 @@ static int __init isicom_init(void)
 
 	retval = tty_register_driver(isicom_normal);
 	if (retval) {
-		pr_dbg("Couldn't register the dialin driver\n");
+		pr_debug("Couldn't register the dialin driver\n");
 		goto err_puttty;
 	}
 
 	retval = pci_register_driver(&isicom_driver);
 	if (retval < 0) {
-		printk(KERN_ERR "ISICOM: Unable to register pci driver.\n");
+		pr_err("Unable to register pci driver.\n");
 		goto err_unrtty;
 	}
 
-- 
1.7.0.1

