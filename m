Return-Path: <linux-kernel-owner+w=401wt.eu-S1760915AbXF1ORH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbXF1ORH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 10:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbXF1OQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 10:16:56 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:54432 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbXF1OQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 10:16:56 -0400
Date: Thu, 28 Jun 2007 23:17:39 +0900 (JST)
Message-Id: <20070628.231739.59653057.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ralf@linux-mips.org
Subject: [PATCH 1/2] serial_txx9: Fix modem control line handling
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This chip does not have modem control lines.  Return TIOCM_CAR and
TIOCM_DSR always on get_mctrl() and ajust some bits in termios cflag.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 1deb576..407fca0 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -37,7 +37,7 @@
 
 #include <asm/io.h>
 
-static char *serial_version = "1.09";
+static char *serial_version = "1.10";
 static char *serial_name = "TX39/49 Serial driver";
 
 #define PASS_LIMIT	256
@@ -436,8 +436,10 @@ static unsigned int serial_txx9_get_mctrl(struct uart_port *port)
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
@@ -557,6 +559,12 @@ serial_txx9_set_termios(struct uart_port *port, struct ktermios *termios,
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
