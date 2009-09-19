Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbZISVxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbZISVxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZISVxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:53:03 -0400
Received: from kroah.org ([198.145.64.141]:50939 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417AbZISVjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:39:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/79] cyclades: merge cy_startup tails
Date: Sat, 19 Sep 2009 14:36:21 -0700
Message-Id: <1253396244-7885-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

There is a duplicated code for Y and Z in cy_startup, merge the paths.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/cyclades.c |   45 ++++++++++++++++-----------------------------
 1 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 7462795..47cd7b8 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1296,7 +1296,7 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 	unsigned long flags;
 	int retval = 0;
 	void __iomem *base_addr;
-	int chip, channel, index;
+	int channel;
 	unsigned long page;
 
 	card = info->card;
@@ -1308,14 +1308,11 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 
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
 
@@ -1329,9 +1326,9 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 	cy_set_line_char(info, tty);
 
 	if (!cy_is_Z(card)) {
-		chip = channel >> 2;
+		int chip = channel >> 2;
+		int index = card->bus_index;
 		channel &= 0x03;
-		index = card->bus_index;
 		base_addr = card->base_addr + (cy_chip_offset[chip] << index);
 
 #ifdef CY_DEBUG_OPEN
@@ -1354,18 +1351,6 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 
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
 
@@ -1416,18 +1401,19 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
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
@@ -1436,6 +1422,7 @@ static int cy_startup(struct cyclades_port *info, struct tty_struct *tty)
 
 errout:
 	spin_unlock_irqrestore(&card->card_lock, flags);
+	free_page(page);
 	return retval;
 }				/* startup */
 
-- 
1.6.4.2

