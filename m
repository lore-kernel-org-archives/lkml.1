Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbZFVQq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbZFVQq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbZFVQpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:45:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53536 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756172AbZFVQpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:45:17 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 15/15] msm: fixups to match current code
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:43:18 +0100
Message-ID: <20090622174316.25341.77853.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
References: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The tty layer is now a bit more fussy about reporting the right baud rate
back. Make the msm driver match the current state of affairs.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/serial/msm_serial.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)


diff --git a/drivers/serial/msm_serial.c b/drivers/serial/msm_serial.c
index 1a7c856..698048f 100644
--- a/drivers/serial/msm_serial.c
+++ b/drivers/serial/msm_serial.c
@@ -229,7 +229,7 @@ static void msm_break_ctl(struct uart_port *port, int break_ctl)
 		msm_write(port, UART_CR_CMD_STOP_BREAK, UART_CR);
 }
 
-static void msm_set_baud_rate(struct uart_port *port, unsigned int baud)
+static int msm_set_baud_rate(struct uart_port *port, unsigned int baud)
 {
 	unsigned int baud_code, rxstale, watermark;
 
@@ -281,6 +281,7 @@ static void msm_set_baud_rate(struct uart_port *port, unsigned int baud)
 	case 115200:
 	default:
 		baud_code = UART_CSR_115200;
+		baud = 115200;
 		rxstale = 31;
 		break;
 	}
@@ -299,6 +300,8 @@ static void msm_set_baud_rate(struct uart_port *port, unsigned int baud)
 
 	/* set TX watermark */
 	msm_write(port, 10, UART_TFWR);
+
+	return baud;
 }
 
 static void msm_reset(struct uart_port *port)
@@ -395,8 +398,10 @@ static void msm_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	/* calculate and set baud rate */
 	baud = uart_get_baud_rate(port, termios, old, 300, 115200);
-	msm_set_baud_rate(port, baud);
-
+	baud = msm_set_baud_rate(port, baud);
+	if (tty_termios_baud_rate(termios))
+		tty_termios_encode_baud_rate(termios, baud, baud);
+	
 	/* calculate parity */
 	mr = msm_read(port, UART_MR2);
 	mr &= ~UART_MR2_PARITY_MODE;

