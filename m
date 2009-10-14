Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZJNSoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZJNSoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbZJNSox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:44:53 -0400
Received: from kcmailp07.birch.net ([216.212.0.102]:50035 "EHLO mx01.birch.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756566AbZJNSow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:44:52 -0400
Message-ID: <4AD61BFE.2000607@softplc.com>
Date: Wed, 14 Oct 2009 13:44:14 -0500
From: Dick Hollenbeck <dick@softplc.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] 8250 serial transmitter fully empty test
Content-Type: multipart/mixed;
 boundary="------------040501080904040405040505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040501080904040405040505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

When controlling an industrial radio modem it can be necessary to
manipulate the handshake lines in order to control the radio modem's 
transmitter, from userspace.

The transmitter should not be turned off before all characters have been 
transmitted.  serial8250_tx_empty() was reporting that all characters were transmitted 
before they actually were.


Signed-off-by: Dick Hollenbeck <dick@softplc.com>


--------------040501080904040405040505
Content-Type: text/x-patch;
 name="8250.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="8250.diff"

--- drivers/serial/8250.c.orig	2009-09-26 14:06:55.000000000 -0500
+++ drivers/serial/8250.c	2009-09-26 14:12:37.000000000 -0500
@@ -81,6 +81,9 @@ static int serial_index(struct uart_port
 
 #define PASS_LIMIT	256
 
+#define BOTH_EMPTY 	(UART_LSR_TEMT | UART_LSR_THRE)
+
+
 /*
  * We default to IRQ0 for the "no irq" hack.   Some
  * machine types want others as well - they're free
@@ -1792,7 +1795,7 @@ static unsigned int serial8250_tx_empty(
 	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
-	return lsr & UART_LSR_TEMT ? TIOCSER_TEMT : 0;
+	return (lsr & BOTH_EMPTY) == BOTH_EMPTY ? TIOCSER_TEMT : 0;
 }
 
 static unsigned int serial8250_get_mctrl(struct uart_port *port)
@@ -1850,8 +1853,6 @@ static void serial8250_break_ctl(struct 
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
-#define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
-
 /*
  *	Wait for transmitter & holding register to empty
  */

--------------040501080904040405040505--
