Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbZKROf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbZKROf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbZKROf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:35:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35717 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757275AbZKROfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:35:25 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 01/11] tty_port: Move hupcl handling
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:19:00 +0000
Message-ID: <20091118141851.3582.692.stgit@localhost.localdomain>
In-Reply-To: <20091118141802.3582.47363.stgit@localhost.localdomain>
References: <20091118141802.3582.47363.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

 drivers/char/tty_port.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)


diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 5e2ac57..93a5bf5 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -360,6 +360,14 @@ int tty_port_close_start(struct tty_port *port,
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
@@ -371,11 +379,6 @@ void tty_port_close_end(struct tty_port *port, struct tty_struct *tty)
 {
 	unsigned long flags;
 
-	tty_ldisc_flush(tty);
-
-	if (tty->termios->c_cflag & HUPCL)
-		tty_port_lower_dtr_rts(port);
-
 	spin_lock_irqsave(&port->lock, flags);
 	tty->closing = 0;
 

