Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbZISVlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbZISVlQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZISVlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:41:14 -0400
Received: from kroah.org ([198.145.64.141]:40453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbZISVlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:41:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/79] cyclades: use the full port_close function
Date: Sat, 19 Sep 2009 14:36:39 -0700
Message-Id: <1253396244-7885-34-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Convert cyclades to use the full tty_port_close helper

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/cyclades.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index f518e0b..70bd61b 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1750,24 +1750,15 @@ static void cy_flush_buffer(struct tty_struct *tty)
 }				/* cy_flush_buffer */
 
 
-/*
- * This routine is called when a particular tty device is closed.
- */
-static void cy_close(struct tty_struct *tty, struct file *filp)
+static void cy_do_close(struct tty_port *port)
 {
-	struct cyclades_port *info = tty->driver_data;
+	struct cyclades_port *info = container_of(port, struct cyclades_port,
+								port);
 	struct cyclades_card *card;
 	unsigned long flags;
 	int channel;
 
-	if (!info || serial_paranoia_check(info, tty->name, "cy_close"))
-		return;
-
 	card = info->card;
-
-	if (!tty_port_close_start(&info->port, tty, filp))
-		return;
-
 	channel = info->line - card->first_line;
 	spin_lock_irqsave(&card->card_lock, flags);
 
@@ -1779,7 +1770,7 @@ static void cy_close(struct tty_struct *tty, struct file *filp)
 			/* Waiting for on-board buffers to be empty before
 			   closing the port */
 			spin_unlock_irqrestore(&card->card_lock, flags);
-			cy_wait_until_sent(tty, info->timeout);
+			cy_wait_until_sent(port->tty, info->timeout);
 			spin_lock_irqsave(&card->card_lock, flags);
 		}
 	} else {
@@ -1801,14 +1792,19 @@ static void cy_close(struct tty_struct *tty, struct file *filp)
 		}
 #endif
 	}
-
 	spin_unlock_irqrestore(&card->card_lock, flags);
-	cy_shutdown(info, tty);
-	cy_flush_buffer(tty);
-
-	tty_port_tty_set(&info->port, NULL);
+	cy_shutdown(info, port->tty);
+}
 
-	tty_port_close_end(&info->port, tty);
+/*
+ * This routine is called when a particular tty device is closed.
+ */
+static void cy_close(struct tty_struct *tty, struct file *filp)
+{
+	struct cyclades_port *info = tty->driver_data;
+	if (!info || serial_paranoia_check(info, tty->name, "cy_close"))
+		return;
+	tty_port_close(&info->port, tty, filp);
 }				/* cy_close */
 
 /* This routine gets called when tty_write has put something into
@@ -3113,11 +3109,13 @@ static void cyz_dtr_rts(struct tty_port *port, int raise)
 static const struct tty_port_operations cyy_port_ops = {
 	.carrier_raised = cyy_carrier_raised,
 	.dtr_rts = cyy_dtr_rts,
+	.shutdown = cy_do_close,
 };
 
 static const struct tty_port_operations cyz_port_ops = {
 	.carrier_raised = cyz_carrier_raised,
 	.dtr_rts = cyz_dtr_rts,
+	.shutdown = cy_do_close,
 };
 
 /*
-- 
1.6.4.2

