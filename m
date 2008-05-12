Return-Path: <linux-kernel-owner+w=401wt.eu-S1761007AbYELKU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007AbYELKU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbYELKUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:20:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:33881 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759057AbYELKUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:20:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=w6IRoiAoMPNWsVIo1EAkqbxQxYdZrjWCdk1Cu2Vuratg+XeFKkTG/DthuDBLbj8GiwqO320CYs3Hfd38wQB9RjgpL1l1n93TCPGkjgSyF2G0T99uKFFWN4wqTO2LrQoz7gP3nvuvmy9ZBwpj0PAvJJqfPJMRRnRY5u2yKcqZGOs=
From: Bryan Wu <cooloney@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Oleksiy Kebkal <kebkal@gmail.com>, Oleksiy Kebkal <lesha@evologics.de>,
       Russell King <rmk@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] [serial/core]: This patch leaves RTS alone when CRTSCTS is not set.
Date: Mon, 12 May 2008 18:20:14 +0800
Message-Id: <1210587614-10016-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleksiy Kebkal <kebkal@gmail.com>

Current behaviour doesn't give any possibility to

1.  preconfigure port setting, because open operation implies RTS
   assertion and initial serial port setting may be wrong.

2.  realize peculiar serial flow control required by some hardware
   especially in embedded devices.

Signed-off-by: Oleksiy Kebkal <lesha@evologics.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/serial_core.c |   42 ++++++++++++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index eab0327..903360b 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -179,11 +179,15 @@ static int uart_startup(struct uart_state *state, int init_hw)
 			uart_change_speed(state, NULL);
 
 			/*
-			 * Setup the RTS and DTR signals once the
-			 * port is open and ready to respond.
+			 * Setup the RTS (in the case of hardware flow control)
+			 * and DTR signals once the port is open and ready to
+			 * respond.
 			 */
-			if (info->tty->termios->c_cflag & CBAUD)
-				uart_set_mctrl(port, TIOCM_RTS | TIOCM_DTR);
+			if (info->tty->termios->c_cflag & CBAUD) {
+				uart_set_mctrl(port, TIOCM_DTR);
+				if (info->flags & UIF_CTS_FLOW)
+					uart_set_mctrl(port, TIOCM_RTS);
+			}
 		}
 
 		if (info->flags & UIF_CTS_FLOW) {
@@ -224,10 +228,14 @@ static void uart_shutdown(struct uart_state *state)
 		info->flags &= ~UIF_INITIALIZED;
 
 		/*
-		 * Turn off DTR and RTS early.
+		 * Turn off DTR and RTS (in the case of hardware flow control)
+		 * early.
 		 */
-		if (!info->tty || (info->tty->termios->c_cflag & HUPCL))
-			uart_clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
+		if (!info->tty || (info->tty->termios->c_cflag & HUPCL)) {
+			uart_clear_mctrl(port, TIOCM_DTR);
+			if (info->flags & UIF_CTS_FLOW)
+				uart_clear_mctrl(port, TIOCM_RTS);
+               }
 
 		/*
 		 * clear delta_msr_wait queue to avoid mem leaks: we may free
@@ -1190,14 +1198,16 @@ static void uart_set_termios(struct tty_struct *tty,
 	uart_change_speed(state, old_termios);
 
 	/* Handle transition to B0 status */
-	if ((old_termios->c_cflag & CBAUD) && !(cflag & CBAUD))
-		uart_clear_mctrl(state->port, TIOCM_RTS | TIOCM_DTR);
+	if ((old_termios->c_cflag & CBAUD) && !(cflag & CBAUD)) {
+		uart_clear_mctrl(state->port, TIOCM_DTR);
+		if (state->info->flags & UIF_CTS_FLOW)
+			uart_clear_mctrl(state->port, TIOCM_RTS);
+       }
 
 	/* Handle transition away from B0 status */
 	if (!(old_termios->c_cflag & CBAUD) && (cflag & CBAUD)) {
 		unsigned int mask = TIOCM_DTR;
-		if (!(cflag & CRTSCTS) ||
-		    !test_bit(TTY_THROTTLED, &tty->flags))
+		if (!test_bit(TTY_THROTTLED, &tty->flags))
 			mask |= TIOCM_RTS;
 		uart_set_mctrl(state->port, mask);
 	}
@@ -1441,10 +1451,14 @@ static void uart_update_termios(struct uart_state *state)
 		uart_change_speed(state, NULL);
 
 		/*
-		 * And finally enable the RTS and DTR signals.
+		 * And finally enable the RTS (in the of case hardware flow
+		 * control) and DTR signals.
 		 */
-		if (tty->termios->c_cflag & CBAUD)
-			uart_set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
+		if (tty->termios->c_cflag & CBAUD) {
+			uart_set_mctrl(port, TIOCM_DTR);
+			if (state->info->flags & UIF_CTS_FLOW)
+				uart_set_mctrl(port, TIOCM_RTS);
+		}
 	}
 }
 
-- 
1.5.5

