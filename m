Return-Path: <linux-kernel-owner+w=401wt.eu-S1759473AbZJGO5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbZJGO5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759453AbZJGO5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:57:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56339 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759192AbZJGO5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:57:48 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 3/4] isicom: sort out the board init logic
To: linux-kernel@vger.kernel.org, strakh@ispras.ru, jirislaby@gmail.com
Date: Wed, 07 Oct 2009 15:46:38 +0100
Message-ID: <20091007144634.14550.20989.stgit@localhost.localdomain>
In-Reply-To: <20091007144455.14550.95003.stgit@localhost.localdomain>
References: <20091007144455.14550.95003.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split this into two flags - INIT meaning the board is set up and ACTIVE
meaning the board has ports open. Remove the broken HUPCL casing and push
the counts somewhere sensible.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/isicom.c  |   41 +++++++++++------------------------------
 include/linux/isicom.h |    1 +
 2 files changed, 12 insertions(+), 30 deletions(-)


diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index e7be3ec..1e91c30 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -793,21 +793,19 @@ static inline void isicom_setup_board(struct isi_board *bp)
 {
 	int channel;
 	struct isi_port *port;
-	unsigned long flags;
 
-	spin_lock_irqsave(&bp->card_lock, flags);
-	if (bp->status & BOARD_ACTIVE) {
-		spin_unlock_irqrestore(&bp->card_lock, flags);
-		return;
-	}
-	port = bp->ports;
-	bp->status |= BOARD_ACTIVE;
-	for (channel = 0; channel < bp->port_count; channel++, port++)
-		drop_dtr_rts(port);
 	bp->count++;
-	spin_unlock_irqrestore(&bp->card_lock, flags);
+	if (!(bp->status & BOARD_INIT)) {
+		port = bp->ports;
+		for (channel = 0; channel < bp->port_count; channel++, port++)
+			drop_dtr_rts(port);
+	}
+	bp->status |= BOARD_ACTIVE | BOARD_INIT;
 }
 
+/* Activate and thus setup board are protected from races against shutdown
+   by the tty_port mutex */
+
 static int isicom_activate(struct tty_port *tport, struct tty_struct *tty)
 {
 	struct isi_port *port = container_of(tport, struct isi_port, port);
@@ -884,19 +882,10 @@ static int isicom_open(struct tty_struct *tty, struct file *filp)
 
 /* close et all */
 
-static inline void isicom_shutdown_board(struct isi_board *bp)
-{
-	if (bp->status & BOARD_ACTIVE)
-		bp->status &= ~BOARD_ACTIVE;
-}
-
 /* card->lock HAS to be held */
 static void isicom_shutdown_port(struct isi_port *port)
 {
 	struct isi_board *card = port->card;
-	struct tty_struct *tty;
-
-	tty = tty_port_tty_get(&port->port);
 
 	tty_port_free_xmit_buf(&port->port);
 	if (--card->count < 0) {
@@ -904,17 +893,9 @@ static void isicom_shutdown_port(struct isi_port *port)
 			card->base, card->count);
 		card->count = 0;
 	}
-
 	/* last port was closed, shutdown that board too */
-	if (tty && C_HUPCL(tty)) {
-		/* FIXME: this logic is bogus - it's the old logic that was
-		   bogus before but it still wants fixing */
-		if (!card->count) {
-			if (card->status & BOARD_ACTIVE)
-				card->status &= ~BOARD_ACTIVE;
-		}
-	}
-	tty_kref_put(tty);
+	if (!card->count)
+		card->status &= BOARD_ACTIVE;
 }
 
 static void isicom_flush_buffer(struct tty_struct *tty)
diff --git a/include/linux/isicom.h b/include/linux/isicom.h
index bbd4219..b92e056 100644
--- a/include/linux/isicom.h
+++ b/include/linux/isicom.h
@@ -67,6 +67,7 @@
 
 #define		FIRMWARE_LOADED		0x0001
 #define		BOARD_ACTIVE		0x0002
+#define		BOARD_INIT		0x0004
 
  	/* isi_port status bitmap  */
 

