Return-Path: <linux-kernel-owner+w=401wt.eu-S1760729AbZFRHnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729AbZFRHnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbZFRHmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:42:11 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:47386 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196AbZFRHmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:42:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 05/13] Char: cyclades, close cleanup
Date: Thu, 18 Jun 2009 09:41:40 +0200
Message-Id: <1245310908-27691-5-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
References: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new tty helpers for close, which allows much code removal.

The only real change is locking. card_lock for protecting was
used inappropriately (just to have a critical section, no matter
which lock is used), so the change to port->lock is fine.

Remove also useless debug printks while being there.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |   70 +---------------------------------------------
 1 files changed, 2 insertions(+), 68 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 44bd42d..67f1739 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2360,61 +2360,13 @@ static void cy_close(struct tty_struct *tty, struct file *filp)
 	struct cyclades_card *card;
 	unsigned long flags;
 
-#ifdef CY_DEBUG_OTHER
-	printk(KERN_DEBUG "cyc:cy_close ttyC%d\n", info->line);
-#endif
-
 	if (!info || serial_paranoia_check(info, tty->name, "cy_close"))
 		return;
 
 	card = info->card;
 
-	spin_lock_irqsave(&card->card_lock, flags);
-	/* If the TTY is being hung up, nothing to do */
-	if (tty_hung_up_p(filp)) {
-		spin_unlock_irqrestore(&card->card_lock, flags);
+	if (!tty_port_close_start(&info->port, tty, filp))
 		return;
-	}
-#ifdef CY_DEBUG_OPEN
-	printk(KERN_DEBUG "cyc:cy_close ttyC%d, count = %d\n", info->line,
-		info->port.count);
-#endif
-	if ((tty->count == 1) && (info->port.count != 1)) {
-		/*
-		 * Uh, oh.  tty->count is 1, which means that the tty
-		 * structure will be freed.  Info->count should always
-		 * be one in these conditions.  If it's greater than
-		 * one, we've got real problems, since it means the
-		 * serial port won't be shutdown.
-		 */
-		printk(KERN_ERR "cyc:cy_close: bad serial port count; "
-			"tty->count is 1, info->port.count is %d\n", info->port.count);
-		info->port.count = 1;
-	}
-#ifdef CY_DEBUG_COUNT
-	printk(KERN_DEBUG  "cyc:cy_close at (%d): decrementing count to %d\n",
-		current->pid, info->port.count - 1);
-#endif
-	if (--info->port.count < 0) {
-#ifdef CY_DEBUG_COUNT
-		printk(KERN_DEBUG "cyc:cyc_close setting count to 0\n");
-#endif
-		info->port.count = 0;
-	}
-	if (info->port.count) {
-		spin_unlock_irqrestore(&card->card_lock, flags);
-		return;
-	}
-	info->port.flags |= ASYNC_CLOSING;
-
-	/*
-	 * Now we wait for the transmit buffer to clear; and we notify
-	 * the line discipline to only process XON/XOFF characters.
-	 */
-	tty->closing = 1;
-	spin_unlock_irqrestore(&card->card_lock, flags);
-	if (info->port.closing_wait != CY_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, info->port.closing_wait);
 
 	spin_lock_irqsave(&card->card_lock, flags);
 
@@ -2459,28 +2411,10 @@ static void cy_close(struct tty_struct *tty, struct file *filp)
 	spin_unlock_irqrestore(&card->card_lock, flags);
 	cy_shutdown(info, tty);
 	cy_flush_buffer(tty);
-	tty_ldisc_flush(tty);
-	spin_lock_irqsave(&card->card_lock, flags);
 
-	tty->closing = 0;
 	tty_port_tty_set(&info->port, NULL);
-	if (info->port.blocked_open) {
-		spin_unlock_irqrestore(&card->card_lock, flags);
-		if (info->port.close_delay) {
-			msleep_interruptible(jiffies_to_msecs
-						(info->port.close_delay));
-		}
-		wake_up_interruptible(&info->port.open_wait);
-		spin_lock_irqsave(&card->card_lock, flags);
-	}
-	info->port.flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
-	wake_up_interruptible(&info->port.close_wait);
 
-#ifdef CY_DEBUG_OTHER
-	printk(KERN_DEBUG "cyc:cy_close done\n");
-#endif
-
-	spin_unlock_irqrestore(&card->card_lock, flags);
+	tty_port_close_end(&info->port, tty);
 }				/* cy_close */
 
 /* This routine gets called when tty_write has put something into
-- 
1.6.3.2

