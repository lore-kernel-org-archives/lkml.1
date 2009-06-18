Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZFRHm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZFRHm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbZFRHmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:42:08 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:47387 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314AbZFRHmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:42:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 09/13] Char: cyclades, merge cy_startup tails
Date: Thu, 18 Jun 2009 09:41:44 +0200
Message-Id: <1245310908-27691-9-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
References: <1245310908-27691-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a duplicated code for Y and Z in cy_startup, merge the paths.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/cyclades.c |   45 ++++++++++++++++-----------------------------
 1 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index bad3010..5dd176d 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1295,7 +1295,7 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 	unsigned long flags;
 	int retval = 0;
 	void __iomem *base_addr;
-	int chip, channel, index;
+	int channel;
 	unsigned long page;
 
 	card = info->card;
@@ -1307,14 +1307,11 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 
 	spin_lock_irqsave(&card->card_lock, flags);
 
-	if (info->port.flags & ASYNC_INITIALIZED) {
-		free_page(page);
+	if (info->port.flags & ASYNC_INITIALIZED)
 		goto errout;
-	}
 
 	if (!info->type) {
 		set_bit(TTY_IO_ERROR, &tty->flags);
-		free_page(page);
 		goto errout;
 	}
 
@@ -1328,9 +1325,9 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 	cy_set_line_char(info, tty);
 
 	if (!cy_is_Z(card)) {
-		chip = channel >> 2;
+		int chip = channel >> 2;
+		int index = card->bus_index;
 		channel &= 0x03;
-		index = card->bus_index;
 		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 #ifdef CY_DEBUG_OPEN
@@ -1353,18 +1350,6 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 
 		cy_writeb(base_addr + (CySRER << index),
 			readb(base_addr + (CySRER << index)) | CyRxData);
-		info->port.flags |= ASYNC_INITIALIZED;
-
-		clear_bit(TTY_IO_ERROR, &tty->flags);
-		info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
-		info->breakon = info->breakoff = 0;
-		memset((char *)&info->idle_stats, 0, sizeof(info->idle_stats));
-		info->idle_stats.in_use =
-		info->idle_stats.recv_idle =
-		info->idle_stats.xmit_idle = jiffies;
-
-		spin_unlock_irqrestore(&card->card_lock, flags);
-
 	} else {
 		struct CH_CTRL __iomem *ch_ctrl = info->u.cyz.ch_ctrl;
 
@@ -1415,18 +1400,19 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 		tty_port_raise_dtr_rts(&info->port);
 
 		/* enable send, recv, modem !!! */
+	}
 
-		info->port.flags |= ASYNC_INITIALIZED;
-		clear_bit(TTY_IO_ERROR, &tty->flags);
-		info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
-		info->breakon = info->breakoff = 0;
-		memset((char *)&info->idle_stats, 0, sizeof(info->idle_stats));
-		info->idle_stats.in_use =
-		info->idle_stats.recv_idle =
-		info->idle_stats.xmit_idle = jiffies;
+	info->port.flags |= ASYNC_INITIALIZED;
 
-		spin_unlock_irqrestore(&card->card_lock, flags);
-	}
+	clear_bit(TTY_IO_ERROR, &tty->flags);
+	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
+	info->breakon = info->breakoff = 0;
+	memset((char *)&info->idle_stats, 0, sizeof(info->idle_stats));
+	info->idle_stats.in_use =
+	info->idle_stats.recv_idle =
+	info->idle_stats.xmit_idle = jiffies;
+
+	spin_unlock_irqrestore(&card->card_lock, flags);
 
 #ifdef CY_DEBUG_OPEN
 	printk(KERN_DEBUG "cyc startup done\n");
@@ -1435,6 +1421,7 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 
 errout:
 	spin_unlock_irqrestore(&card->card_lock, flags);
+	free_page(page);
 	return retval;
 }				/* startup */
 
-- 
1.6.3.2

