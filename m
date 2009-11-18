Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZKROdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZKROdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbZKROdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:33:13 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40619 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757273AbZKROdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:33:10 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 10/12] moxa: Fix modem op locking
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:16:46 +0000
Message-ID: <20091118141639.3346.67675.stgit@localhost.localdomain>
In-Reply-To: <20091118141354.3346.16910.stgit@localhost.localdomain>
References: <20091118141354.3346.16910.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is overkill and mostly not needed

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/moxa.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)


diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index b640409..f9816e6 100644
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

