Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYJGLGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYJGLGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbYJGLG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:06:29 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58771 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYJGLG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:06:28 -0400
Subject: [PATCH][SERIAL] Drop probe_baud() and default to "9600n8"
From: Paul Bolle <pebolle@tiscali.nl>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 07 Oct 2008 13:06:26 +0200
Message-Id: <1223377586.5129.43.camel@test.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 (2.24.0-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The early console kernel parameters (i.e. "console=uart[...]" and
"earlycon=uart[...]" allow to omit the baud/parity/bits option. If that
option is not provided probe_baud() is used to determine the baud rate
to be used by that early console.

I noticed that probe_baud() produced useless and/or unpredictable
results on the few machines I tested the early console parameters (e.g.
1355 or 1200 and 115200 alternating). My guess is that this is because
probe_baud() tries to calculate the baud rate from information retrieved
while that UART is not yet properly initialized. Anyhow, a safe
alternative would be to not probe for a baud rate but simply use
"9600n8" as defaults for baud/parity/bits. See patch below.


Paul Bolle
---
From: Paul Bolle <pebolle@tiscali.nl>
    
If no baud/parity/bits triplet is provided on the commandline for an
early serial console, parse_options() will call probe_baud() to
determine the baud rate used by that early console. probe_baud() seems
to generate useless and/or unpredictable results. Solution is to drop
probe_baud() and simply use "9600n8" as (safe) defaults for
baud/parity/bits.
    
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index f279745..b810430 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -99,21 +99,6 @@ static void __init early_serial8250_write(struct console *console,
 	serial_out(port, UART_IER, ier);
 }
 
-static unsigned int __init probe_baud(struct uart_port *port)
-{
-	unsigned char lcr, dll, dlm;
-	unsigned int quot;
-
-	lcr = serial_in(port, UART_LCR);
-	serial_out(port, UART_LCR, lcr | UART_LCR_DLAB);
-	dll = serial_in(port, UART_DLL);
-	dlm = serial_in(port, UART_DLM);
-	serial_out(port, UART_LCR, lcr);
-
-	quot = (dlm << 8) | dll;
-	return (port->uartclk / 16) / quot;
-}
-
 static void __init init_port(struct early_serial8250_device *device)
 {
 	struct uart_port *port = &device->port;
@@ -176,9 +161,8 @@ static int __init parse_options(struct early_serial8250_device *device,
 		length = min(strcspn(options, " "), sizeof(device->options));
 		strncpy(device->options, options, length);
 	} else {
-		device->baud = probe_baud(port);
-		snprintf(device->options, sizeof(device->options), "%u",
-			device->baud);
+		device->baud = 9600;
+		strcpy(device->options, "9600n8");
 	}
 
 	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",


