Return-Path: <linux-kernel-owner+w=401wt.eu-S1763288AbXEQG2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763288AbXEQG2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbXEQG14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:27:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57525 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbXEQG1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:27:55 -0400
Subject: [PATCH] NS16550A: Restore HS settings in EXCR2 on resume
From: David Woodhouse <dwmw2@infradead.org>
To: torvalds@osdl.org, akpm@osdl.org
Cc: rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 17 May 2007 14:27:39 +0800
Message-Id: <1179383259.2859.420.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After a suspend/resume cycle, the UART may have been reset into
low-speed mode -- either because it's actually been reset, or because
the firmware pokes at the old-style divisor registers. If we detected it
as a NS16550A SuperIO chip in the first place and set baud_base to
921600, then we should do so again in the resume path.

This patch adds that code to serial8250_resume_port(), and also makes
serial8250_resume() actually call serial8250_resume_port() for each port
instead of just calling uart_resume_port() directly. And thus fixes
serial port operation after suspend/resume.

It also fixes a bogus comment where we write the EXCR2 register with a
comment saying /* EXCR1 */

Signed-off-by: David Woodhouse <dwmw2@infradead.org>

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 48e259a..c84dab0 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -894,7 +894,7 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 			quot = serial_dl_read(up);
 			quot <<= 3;
 
-			status1 = serial_in(up, 0x04); /* EXCR1 */
+			status1 = serial_in(up, 0x04); /* EXCR2 */
 			status1 &= ~0xB0; /* Disable LOCK, mask out PRESL[01] */
 			status1 |= 0x10;  /* 1.625 divisor for baud_base --> 921600 */
 			serial_outp(up, 0x04, status1);
@@ -2617,7 +2617,22 @@ void serial8250_suspend_port(int line)
  */
 void serial8250_resume_port(int line)
 {
-	uart_resume_port(&serial8250_reg, &serial8250_ports[line].port);
+	struct uart_8250_port *up = &serial8250_ports[line];
+
+	if (up->capabilities & UART_NATSEMI) {
+		unsigned char tmp;
+
+		/* Ensure it's still in high speed mode */
+		serial_outp(up, UART_LCR, 0xE0);
+
+		tmp = serial_in(up, 0x04); /* EXCR2 */
+		tmp &= ~0xB0; /* Disable LOCK, mask out PRESL[01] */
+		tmp |= 0x10;  /* 1.625 divisor for baud_base --> 921600 */
+		serial_outp(up, 0x04, tmp);
+
+		serial_outp(up, UART_LCR, 0);
+	}
+	uart_resume_port(&serial8250_reg, &up->port);
 }
 
 /*
@@ -2694,7 +2709,7 @@ static int serial8250_resume(struct platform_device *dev)
 		struct uart_8250_port *up = &serial8250_ports[i];
 
 		if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev)
-			uart_resume_port(&serial8250_reg, &up->port);
+			serial8250_resume_port(i);
 	}
 
 	return 0;

-- 
dwmw2

