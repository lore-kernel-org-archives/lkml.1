Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZJ1UhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZJ1UhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbZJ1UhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:37:23 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:60039 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbZJ1UhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:37:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YNxb7zX0kHKFSEMEgLc5upzAiWIy89MTOGlqL52WaMf1SYSLEu3uY5dhfM8Xfc0b1e
         QvfiVZVavOPx1ZbXx5Dzz2gFxvZAyS2Pc0IHq2pAbpH/DeNVcmi88tEgUBKCImIltwJ/
         87Dlgz5k/mlun/FNT9by4AvvyA4acgVim9jt0=
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Manuel Lauss <manuel.lauss@gmail.com>
Subject: [PATCH] serial 8250: fixes for Alchemy uarts.
Date: Wed, 28 Oct 2009 21:37:28 +0100
Message-Id: <1256762248-4305-1-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the amount of address space claimed for Alchemy serial ports
to 0x1000.  On the Au1300, ports are only 0x1000 apart, and the
registers only extend to 0x110 at most on all supported alchemy models.

On the Au1300 the autodetect logic no longer works and this makes
it necessary to specify the port type through platform data.  Because
of this the MSR quirk needs to be moved outside the autoconfig()
function which will no longer be called when UPF_FIXED_TYPE is
specified.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
 drivers/serial/8250.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index b1ae774..9538e5b 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1214,12 +1214,6 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	}
 #endif
 
-#ifdef CONFIG_SERIAL_8250_AU1X00
-	/* if access method is AU, it is a 16550 with a quirk */
-	if (up->port.type == PORT_16550A && up->port.iotype == UPIO_AU)
-		up->bugs |= UART_BUG_NOMSR;
-#endif
-
 	serial_outp(up, UART_LCR, save_lcr);
 
 	if (up->capabilities != uart_config[up->port.type].flags) {
@@ -2429,7 +2423,7 @@ serial8250_pm(struct uart_port *port, unsigned int state,
 static unsigned int serial8250_port_size(struct uart_8250_port *pt)
 {
 	if (pt->port.iotype == UPIO_AU)
-		return 0x100000;
+		return 0x1000;
 #ifdef CONFIG_ARCH_OMAP
 	if (is_omap_port(pt))
 		return 0x16 << pt->port.regshift;
@@ -2586,6 +2580,13 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 
 	if (flags & UART_CONFIG_TYPE)
 		autoconfig(up, probeflags);
+
+#ifdef CONFIG_SERIAL_8250_AU1X00
+	/* if access method is AU, it is a 16550 with a quirk */
+	if (up->port.type == PORT_16550A && up->port.iotype == UPIO_AU)
+		up->bugs |= UART_BUG_NOMSR;
+#endif
+
 	if (up->port.type != PORT_UNKNOWN && flags & UART_CONFIG_IRQ)
 		autoconfig_irq(up);
 
-- 
1.6.5

