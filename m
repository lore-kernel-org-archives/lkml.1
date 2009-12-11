Return-Path: <linux-kernel-owner+w=401wt.eu-S935077AbZLKXhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935077AbZLKXhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934892AbZLKXgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:36:42 -0500
Received: from kroah.org ([198.145.64.141]:50451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933686AbZLKX3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/58] tty_port: Move hupcl handling
Date: Fri, 11 Dec 2009 15:28:09 -0800
Message-Id: <1260574122-10676-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Move the HUCPL handling from the end of close_port_start to the beginning
of close_port_end. What this actually does is change the ordering from

	port shutdown
	port->dtr_rts

to

	port->dtr_rts
	port shutdown

Some hardware drops the physical connection on shutdown so we must perform
the port operations before the shutdown.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_port.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 41b314c..dd471d6 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -339,6 +339,14 @@ int tty_port_close_start(struct tty_port *port,
 			timeout = 2 * HZ;
 		schedule_timeout_interruptible(timeout);
 	}
+	/* Flush the ldisc buffering */
+	tty_ldisc_flush(tty);
+
+	/* Drop DTR/RTS if HUPCL is set. This causes any attached modem to
+	   hang up the line */
+	if (tty->termios->c_cflag & HUPCL)
+		tty_port_lower_dtr_rts(port);
+
 	/* Don't call port->drop for the last reference. Callers will want
 	   to drop the last active reference in ->shutdown() or the tty
 	   shutdown path */
@@ -350,11 +358,6 @@ void tty_port_close_end(struct tty_port *port, struct tty_struct *tty)
 {
 	unsigned long flags;
 
-	tty_ldisc_flush(tty);
-
-	if (tty->termios->c_cflag & HUPCL)
-		tty_port_lower_dtr_rts(port);
-
 	spin_lock_irqsave(&port->lock, flags);
 	tty->closing = 0;
 
-- 
1.6.5.5

