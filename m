Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYJNWb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYJNWb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYJNWbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:31:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:40648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYJNWbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:31:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,410,1220252400"; 
   d="scan'208";a="627202158"
Date: Tue, 14 Oct 2008 15:31:09 -0700
Message-Id: <200810142231.m9EMV95O002974@los-vmm.sc.intel.com>
Subject: [PATCH] Enable console on PCI serial devices
To: linux-kernel@vger.kernel.org
From: donald.d.dugger@intel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem with using a PCI serial card for the console is that, until
the PCI serial driver is loaded, output will be lost.  The issue is that
PCI serial devices use a non-standard I/O port address and sometimes use
a non-standard crystal frequency.  This patch gets around those problems
by allowing you to specify both I/O port address and crystal frequency on
the kernel command line.  The serial console specification is enhanced to be:

	BBBBPNF-III/CCC

where BBBB is the baud rate, P is the parity, N is the number of bits,
F is the flow control, III is the I/O port address (prefix with 0x for
hexadecimal) and CCC is the crystal frequency.  -III and /CCC are optional
and can be omitted although -III must be specified if you want to set
/CCC.  For example, the option I use is:

	console=ttyS0,115200-0xe880/921600

Signed-off-by: Don Dugger <donald.d.dugger@intel.com>

 Documentation/serial-console.txt |   12 ++++++++----
 drivers/serial/8250.c            |    2 +-
 drivers/serial/serial_core.c     |   26 ++++++++++++++++++++++----
 include/linux/serial_core.h      |    2 +-
 4 files changed, 32 insertions(+), 10 deletions(-)


----- cut here for patch.d/pci_serial-1014.patch -----
diff --git a/Documentation/serial-console.txt b/Documentation/serial-console.txt
index 9a7bc8b..8cffce6 100644
--- a/Documentation/serial-console.txt
+++ b/Documentation/serial-console.txt
@@ -21,10 +21,14 @@ The format of this option is:
 
 	options:	depend on the driver. For the serial port this
 			defines the baudrate/parity/bits/flow control of
-			the port, in the format BBBBPNF, where BBBB is the
-			speed, P is parity (n/o/e), N is number of bits,
-			and F is flow control ('r' for RTS). Default is
-			9600n8. The maximum baudrate is 115200.
+			the port, in the format BBBBPNF-III/CCC, where BBBB
+			is the speed, P is parity (n/o/e), N is number of bits,
+			F is flow control ('r' for RTS), III is I/O port
+			address (prefix with 0x for hexadecimal) and CCC is
+			the uart crystal frequency. Default is 9600n8. The
+			I/O port defaults to 0x3f8 for ttyS0 and 0x2f8 for
+			ttyS1.  The default crystal frequency is 1843200.
+			The maximum baudrate is 115200.
 
 You can specify multiple console= options on the kernel command line.
 Output will appear on all of them. The last device will be used when
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index d3ca7d3..5d59cf7 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2632,7 +2632,7 @@ static int __init serial8250_console_setup(struct console *co, char *options)
 		return -ENODEV;
 
 	if (options)
-		uart_parse_options(options, &baud, &parity, &bits, &flow);
+		uart_parse_options(options, &baud, &parity, &bits, &flow, &port->iobase, &port->uartclk);
 
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 6bdf336..31b5545 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1864,25 +1864,43 @@ uart_get_console(struct uart_port *ports, int nr, struct console *co)
  *	@parity: pointer to an 'int' variable for the parity.
  *	@bits: pointer to an 'int' variable for the number of data bits.
  *	@flow: pointer to an 'int' variable for the flow control character.
+ *	@ioport: pointer to an 'int' variable for the I/O base for device
+ *	@clk: pointer to an 'int' variable for the clock devisor
  *
  *	uart_parse_options decodes a string containing the serial console
  *	options.  The format of the string is <baud><parity><bits><flow>,
  *	eg: 115200n8r
  */
 void
-uart_parse_options(char *options, int *baud, int *parity, int *bits, int *flow)
+uart_parse_options(char *options, int *baud, int *parity, int *bits, int *flow, int *ioport, int *clk)
 {
 	char *s = options;
 
 	*baud = simple_strtoul(s, NULL, 10);
 	while (*s >= '0' && *s <= '9')
 		s++;
-	if (*s)
+	if (*s && (*s != '-'))
 		*parity = *s++;
-	if (*s)
+	if (*s && (*s != '-'))
 		*bits = *s++ - '0';
-	if (*s)
+	if (*s && (*s != '-'))
 		*flow = *s;
+	if (*s && (*s != '-'))
+		*flow = *s++;
+	if (*s++ == '-') {
+		int b;
+
+		if (*s == '0' && (*(s + 1) == 'x' || *(s + 1) == 'X')) {
+			s += 2;
+			b = 16;
+		} else
+			b = 10;
+		*ioport = simple_strtoul(s, NULL, b);
+		while (*s && (*s != '/'))
+			s++;
+		if (*s == '/')
+			*clk = simple_strtoul(s + 1, NULL, 10) << 4;
+	}
 }
 EXPORT_SYMBOL_GPL(uart_parse_options);
 
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index e27f216..3b4fb3a 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -402,7 +402,7 @@ unsigned int uart_get_divisor(struct uart_port *port, unsigned int baud);
 struct uart_port *uart_get_console(struct uart_port *ports, int nr,
 				   struct console *c);
 void uart_parse_options(char *options, int *baud, int *parity, int *bits,
-			int *flow);
+			int *flow, int *iobase, int *clk);
 int uart_set_options(struct uart_port *port, struct console *co, int baud,
 		     int parity, int bits, int flow);
 struct tty_driver *uart_console_device(struct console *co, int *index);
