Return-Path: <linux-kernel-owner+w=401wt.eu-S1758319AbXHJVkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbXHJVkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbXHJVjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:39:02 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58423 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbXHJVjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:39:00 -0400
Message-Id: <200708102138.l7ALchcS010822@imap1.linux-foundation.org>
Subject: [patch 3/6] serial_txx9: Fix modem control line handling
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       anemo@mba.ocn.ne.jp, ralf@linux-mips.org
From: akpm@linux-foundation.org
Date: Fri, 10 Aug 2007 14:38:43 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

This chip does not have modem control lines.  Return TIOCM_CAR and
TIOCM_DSR always on get_mctrl() and ajust some bits in termios cflag.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/serial_txx9.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/serial/serial_txx9.c~serial_txx9-fix-modem-control-line-handling drivers/serial/serial_txx9.c
--- a/drivers/serial/serial_txx9.c~serial_txx9-fix-modem-control-line-handling
+++ a/drivers/serial/serial_txx9.c
@@ -37,7 +37,7 @@
 
 #include <asm/io.h>
 
-static char *serial_version = "1.09";
+static char *serial_version = "1.10";
 static char *serial_name = "TX39/49 Serial driver";
 
 #define PASS_LIMIT	256
@@ -436,8 +436,10 @@ static unsigned int serial_txx9_get_mctr
 	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
 	unsigned int ret;
 
-	ret =  ((sio_in(up, TXX9_SIFLCR) & TXX9_SIFLCR_RTSSC) ? 0 : TIOCM_RTS)
-		| ((sio_in(up, TXX9_SICISR) & TXX9_SICISR_CTSS) ? 0 : TIOCM_CTS);
+	/* no modem control lines */
+	ret = TIOCM_CAR | TIOCM_DSR;
+	ret |= (sio_in(up, TXX9_SIFLCR) & TXX9_SIFLCR_RTSSC) ? 0 : TIOCM_RTS;
+	ret |= (sio_in(up, TXX9_SICISR) & TXX9_SICISR_CTSS) ? 0 : TIOCM_CTS;
 
 	return ret;
 }
@@ -557,6 +559,12 @@ serial_txx9_set_termios(struct uart_port
 	unsigned long flags;
 	unsigned int baud, quot;
 
+	/*
+	 * We don't support modem control lines.
+	 */
+	termios->c_cflag &= ~(HUPCL | CMSPAR);
+	termios->c_cflag |= CLOCAL;
+
 	cval = sio_in(up, TXX9_SILCR);
 	/* byte size and parity */
 	cval &= ~TXX9_SILCR_UMODE_MASK;
_
