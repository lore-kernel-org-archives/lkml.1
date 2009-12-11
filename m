Return-Path: <linux-kernel-owner+w=401wt.eu-S934576AbZLKX34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934576AbZLKX34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934507AbZLKX3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:41 -0500
Received: from kroah.org ([198.145.64.141]:50524 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934460AbZLKX3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:33 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/58] tty: moxa: Fix modem op locking
Date: Fri, 11 Dec 2009 15:28:35 -0800
Message-Id: <1260574122-10676-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is overkill and mostly not needed

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/moxa.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index d180aa9..ac06d01 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -139,7 +139,7 @@ struct moxa_port {
 	int cflag;
 	unsigned long statusflags;
 
-	u8 DCDState;
+	u8 DCDState;		/* Protected by the port lock */
 	u8 lineCtrl;
 	u8 lowChkFlag;
 };
@@ -1141,9 +1141,9 @@ static int moxa_carrier_raised(struct tty_port *port)
 	struct moxa_port *ch = container_of(port, struct moxa_port, port);
 	int dcd;
 
-	spin_lock_bh(&moxa_lock);
+	spin_lock_irq(&port->lock);
 	dcd = ch->DCDState;
-	spin_unlock_bh(&moxa_lock);
+	spin_unlock_irq(&port->lock);
 	return dcd;
 }
 
@@ -1267,16 +1267,9 @@ static int moxa_chars_in_buffer(struct tty_struct *tty)
 
 static int moxa_tiocmget(struct tty_struct *tty, struct file *file)
 {
-	struct moxa_port *ch;
+	struct moxa_port *ch = tty->driver_data;
 	int flag = 0, dtr, rts;
 
-	mutex_lock(&moxa_openlock);
-	ch = tty->driver_data;
-	if (!ch) {
-		mutex_unlock(&moxa_openlock);
-		return -EINVAL;
-	}
-
 	MoxaPortGetLineOut(ch, &dtr, &rts);
 	if (dtr)
 		flag |= TIOCM_DTR;
@@ -1289,7 +1282,6 @@ static int moxa_tiocmget(struct tty_struct *tty, struct file *file)
 		flag |= TIOCM_DSR;
 	if (dtr & 4)
 		flag |= TIOCM_CD;
-	mutex_unlock(&moxa_openlock);
 	return flag;
 }
 
@@ -1368,15 +1360,20 @@ static void moxa_hangup(struct tty_struct *tty)
 static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
 {
 	struct tty_struct *tty;
+	unsigned long flags;
 	dcd = !!dcd;
 
+	spin_lock_irqsave(&p->port.lock, flags);
 	if (dcd != p->DCDState) {
+        	p->DCDState = dcd;
+        	spin_unlock_irqrestore(&p->port.lock, flags);
 		tty = tty_port_tty_get(&p->port);
 		if (tty && C_CLOCAL(tty) && !dcd)
 			tty_hangup(tty);
 		tty_kref_put(tty);
 	}
-	p->DCDState = dcd;
+	else
+		spin_unlock_irqrestore(&p->port.lock, flags);
 }
 
 static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
@@ -1878,9 +1875,7 @@ static int MoxaPortLineStatus(struct moxa_port *port)
 	val &= 0x0B;
 	if (val & 8)
 		val |= 4;
-	spin_lock_bh(&moxa_lock);
 	moxa_new_dcdstate(port, val & 8);
-	spin_unlock_bh(&moxa_lock);
 	val &= 7;
 	return val;
 }
-- 
1.6.5.5

