Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZJAUZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZJAUZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 16:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbZJAUZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 16:25:40 -0400
Received: from mail.perches.com ([173.55.12.10]:1596 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbZJAUZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 16:25:36 -0400
Subject: [PATCH] isicom.c: Use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Oct 2009 13:25:38 -0700
Message-Id: <1254428738.1799.95.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Converted printks to pr_<level>
Converted some embedded function names to %s...__func__
Removed a period after exclamation points.
Removed #define pr_dbg which could be used by future kernel.h includes

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 426bfdd..65c71ae 100644
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
@@ -939,8 +942,8 @@ static void isicom_shutdown_port(struct isi_port *port)
 		set_bit(TTY_IO_ERROR, &tty->flags);
 
 	if (--card->count < 0) {
-		pr_dbg("isicom_shutdown_port: bad board(0x%lx) count %d.\n",
-			card->base, card->count);
+		pr_debug("%s: bad board(0x%lx) count %d.\n",
+			 __func__, card->base, card->count);
 		card->count = 0;
 	}
 
@@ -1746,13 +1749,13 @@ static int __init isicom_init(void)
 
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
 


