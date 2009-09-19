Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZISVkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZISVkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZISVkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:40:46 -0400
Received: from kroah.org ([198.145.64.141]:40447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911AbZISVkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:40:45 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 32/79] isicom: Split the close hardware bits out
Date: Sat, 19 Sep 2009 14:36:37 -0700
Message-Id: <1253396244-7885-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Start to extract and build a model for a common tty_port_close()

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/char/isicom.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 4f1f4cd..08f5743 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -952,19 +952,12 @@ static void isicom_flush_buffer(struct tty_struct *tty)
 	tty_wakeup(tty);
 }
 
-static void isicom_close(struct tty_struct *tty, struct file *filp)
+static void isicom_close_port(struct tty_port *port)
 {
-	struct isi_port *ip = tty->driver_data;
-	struct tty_port *port = &ip->port;
-	struct isi_board *card;
+	struct isi_port *ip = container_of(port, struct isi_port, port);
+	struct isi_board *card = ip->card;
 	unsigned long flags;
 
-	BUG_ON(!ip);
-
-	card = ip->card;
-	if (isicom_paranoia_check(ip, tty->name, "isicom_close"))
-		return;
-
 	/* indicate to the card that no more data can be received
 	   on this port */
 	spin_lock_irqsave(&card->card_lock, flags);
@@ -974,9 +967,19 @@ static void isicom_close(struct tty_struct *tty, struct file *filp)
 	}
 	isicom_shutdown_port(ip);
 	spin_unlock_irqrestore(&card->card_lock, flags);
+}
 
+static void isicom_close(struct tty_struct *tty, struct file *filp)
+{
+	struct isi_port *ip = tty->driver_data;
+	struct tty_port *port = &ip->port;
+	if (isicom_paranoia_check(ip, tty->name, "isicom_close"))
+		return;
+
+	if (tty_port_close_start(port, tty, filp) == 0)
+		return;
+	isicom_close_port(port);
 	isicom_flush_buffer(tty);
-	
 	tty_port_close_end(port, tty);
 }
 
-- 
1.6.4.2

