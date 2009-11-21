Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbZKUNk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbZKUNk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbZKUNkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:40:24 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41031 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbZKUNkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:40:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=psxDD3qfiqFdH/Q7KWe9/BPXHQ4Tl4vpGg3wC276qA/ZutQS7e8MtE++rstMaZqQvs
         OTlJfRTxjUeQzcgwtY316YkXJGL72agoBwMiCCSQnd3P6DDIth438s1Ge93kDdVrbvbg
         AqnWUVMRrcqCX5TFz91Y77uLusL8f1Uj0hEOc=
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [RFC PATCH 8/9] Serial: sc26xx - add support for SC2892 chips
To: tsbogend@alpha.franken.de, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 21 Nov 2009 14:40:23 +0100
Message-ID: <20091121134023.16090.61750.stgit@srv002.fuzzey.net>
In-Reply-To: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
References: <20091121133951.16090.74411.stgit@srv002.fuzzey.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

---

 drivers/serial/sc26xx.c |  238 ++++++++++++++++++++++++++++++++++++++---------
 1 files changed, 193 insertions(+), 45 deletions(-)

diff --git a/drivers/serial/sc26xx.c b/drivers/serial/sc26xx.c
index 69b7ae7..6764082 100644
--- a/drivers/serial/sc26xx.c
+++ b/drivers/serial/sc26xx.c
@@ -1,7 +1,8 @@
 /*
- * SC268xx.c: Serial driver for Philiphs SC2681/SC2692 devices.
+ * SC26xx.c: Serial driver for Philips SC2681/SC2692/SC2892 devices.
  *
  * Copyright (C) 2006,2007 Thomas Bogendörfer (tsbogend@alpha.franken.de)
+ * SC2892 support by Martin Fuzzey (mfuzzey@gmail.com)
  */
 
 #include <linux/module.h>
@@ -32,15 +33,29 @@
 #define SC26XX_MINOR_START   205
 #define SC26XX_NR            2
 
+struct chip_def {
+	u8	has_mr0;
+	u8	init_mr0;
+	u8	init_mr1;
+	u8	max_baud_mode;
+	u8	default_baud_mode;
+	u8	default_baud_group;
+	const char *name;
+};
+
 struct uart_sc26xx_port {
 	struct uart_port      port[2];
-	u8     dsr_mask[2];
-	u8     cts_mask[2];
-	u8     dcd_mask[2];
-	u8     ri_mask[2];
-	u8     dtr_mask[2];
-	u8     rts_mask[2];
-	u8     imr;
+	u8	dsr_mask[2];
+	u8	cts_mask[2];
+	u8	dcd_mask[2];
+	u8	ri_mask[2];
+	u8	dtr_mask[2];
+	u8	rts_mask[2];
+	u8	imr;
+	u8	acr;
+	u8	mr0_baud;
+	const unsigned int *baud_rates;
+	const struct chip_def *chip;
 };
 
 /* register common to both ports */
@@ -80,6 +95,7 @@ struct uart_sc26xx_port {
 #define CR_RES_TX   (3 << 4)
 #define CR_STRT_BRK (6 << 4)
 #define CR_STOP_BRK (7 << 4)
+#define CR_SEL_MR0  (11 << 4)
 #define CR_DIS_TX   (1 << 3)
 #define CR_ENA_TX   (1 << 2)
 #define CR_DIS_RX   (1 << 1)
@@ -95,6 +111,66 @@ struct uart_sc26xx_port {
 #define IMR_RXRDY   (1 << 1)
 #define IMR_TXRDY   (1 << 0)
 
+/* MR0 bits (>= 28L92 only */
+#define MR0_WATCHDOG	(1 << 7)
+#define MR0_RXINT2	(1 << 6)
+#define MR0_TXINT(x)	((x) << 4)
+#define MR0_FIFO_SIZE	(1 << 3)
+#define MR0_BAUD_MODE	((1 << 2) + (1 << 0))
+
+
+#define NR_BAUD_GROUPS 2
+#define NR_BAUD_MODES 3
+#define NR_BAUDS 13
+#define DEFAULT_BAUD_INDEX 11
+static const unsigned baud_rates[NR_BAUD_MODES][NR_BAUD_GROUPS][NR_BAUDS] = {
+	{
+		/* Normal mode ACR[7] = 0 */
+		{50, 110, 134, 200, 300, 600, 1200, 1050,
+			2400, 4800, 7200, 9600, 38400},
+
+		/* Normal mode ACR[7] = 1 */
+		{75, 110, 134, 150, 300, 600, 1200, 2000,
+			2400, 4800, 1800, 9600, 19200},
+	}, {
+		/* Extended mode 1 ACR[7] = 0 */
+		{300, 110, 134, 1200, 1800, 3600, 7200, 1050,
+			14400, 28800, 7200, 57600, 230400},
+
+		/* Extended mode 1 ACR[7] = 1 */
+		{450, 110, 134, 900, 1800, 3600, 72000, 2000,
+			14400, 28800, 1800, 57600, 115200},
+	}, {
+		/* Extended mode 2 ACR[7] = 0 */
+		{4800, 880, 1076, 19200, 28800, 57600, 115200, 1050,
+			57600, 4800, 57600, 9600, 38400},
+
+		/* Extended mode 2 ACR[7] = 1 */
+		{7200, 880, 1076, 14400, 28800, 57600, 115200, 2000,
+			57600, 4800, 14400, 9600, 19200},
+	}
+};
+
+static struct chip_def chip_26xx = {
+	.name = "SC26XX",
+	.max_baud_mode = 0,
+	.default_baud_mode = 0,
+	.default_baud_group = 1,
+	.has_mr0 = 0,
+	.init_mr1 = 0,
+};
+
+static struct chip_def chip_2892 = {
+	.name = "SC2892",
+	.max_baud_mode = 2,
+	.default_baud_mode = 2,
+	.default_baud_group = 0,
+	.has_mr0 = 1,
+	.init_mr0 =  MR0_WATCHDOG | MR0_FIFO_SIZE | MR0_TXINT(1),
+	.init_mr1 = (1 << 6),
+};
+
+
 static struct uart_sc26xx_port *driver_info(struct uart_port *port)
 {
 	port -= port->line;
@@ -141,6 +217,19 @@ static inline void write_cmd_port(struct uart_port *port, u8 cmd)
 	write_cmd_line(port, port->line, cmd);
 }
 
+
+static u8 read_mr0(struct uart_port *port, int line)
+{
+	write_cmd_line(port, line, CR_SEL_MR0);
+	return read_sc_line(port, line, RD_PORT_MRx);
+}
+
+static void write_mr0(struct uart_port *port, int line, u8 val)
+{
+	write_cmd_line(port, line, CR_SEL_MR0);
+	write_sc_line(port, line, WR_PORT_MRx, val);
+}
+
 static void sc26xx_enable_irq(struct uart_port *port, int mask)
 {
 	struct uart_sc26xx_port *up = driver_info(port);
@@ -371,6 +460,8 @@ static void sc26xx_break_ctl(struct uart_port *port, int break_state)
 /* port->lock is not held.  */
 static int sc26xx_startup(struct uart_port *port)
 {
+	struct uart_sc26xx_port *up = driver_info(port);
+
 	sc26xx_disable_irq(port, IMR_TXRDY | IMR_RXRDY);
 	WRITE_SC(port, OPCR, 0);
 
@@ -378,6 +469,9 @@ static int sc26xx_startup(struct uart_port *port)
 	write_cmd_port(port, CR_RES_RX);
 	write_cmd_port(port, CR_RES_TX);
 
+	if (up->chip->has_mr0)
+		write_mr0(port, port->line, up->chip->init_mr0);
+
 	/* start rx/tx */
 	WRITE_SC_PORT(port, CR, CR_ENA_TX | CR_ENA_RX);
 
@@ -396,10 +490,32 @@ static void sc26xx_shutdown(struct uart_port *port)
 	WRITE_SC_PORT(port, CR, CR_DIS_TX | CR_DIS_RX);
 }
 
+static u8 find_csr(struct uart_sc26xx_port *up, unsigned int baud)
+{
+	int i, found = -1;
+
+	for (i = 0; i < NR_BAUDS; i++) {
+		if (up->baud_rates[i] == baud) {
+			found = i;
+			break;
+		}
+	}
+
+	if (found == -1) {
+		found = DEFAULT_BAUD_INDEX;
+		dev_warn(up->port[0].dev,
+			"%d baud not available using %d\n",
+			baud, up->baud_rates[found]);
+	}
+
+	return (u8)found | ((u8)found << 4);
+}
+
 /* port->lock is not held.  */
 static void sc26xx_set_termios(struct uart_port *port, struct ktermios *termios,
 			      struct ktermios *old)
 {
+	struct uart_sc26xx_port *up = driver_info(port);
 	unsigned int baud = uart_get_baud_rate(port, termios, old, 0, 4000000);
 	unsigned int iflag, cflag;
 	unsigned long flags;
@@ -452,48 +568,21 @@ static void sc26xx_set_termios(struct uart_port *port, struct ktermios *termios,
 	} else
 		mr1 |= (2 << 3);
 
-	switch (baud) {
-	case 50:
-		csr = 0x00;
-		break;
-	case 110:
-		csr = 0x11;
-		break;
-	case 134:
-		csr = 0x22;
-		break;
-	case 200:
-		csr = 0x33;
-		break;
-	case 300:
-		csr = 0x44;
-		break;
-	case 600:
-		csr = 0x55;
-		break;
-	case 1200:
-		csr = 0x66;
-		break;
-	case 2400:
-		csr = 0x88;
-		break;
-	case 4800:
-		csr = 0x99;
-		break;
-	default:
-	case 9600:
-		csr = 0xbb;
-		break;
-	case 19200:
-		csr = 0xcc;
-		break;
+	mr1 |= up->chip->init_mr1;
+	csr = find_csr(up, baud);
+
+	if (up->chip->has_mr0) {
+		u8 mr0a = read_mr0(port, 0);
+		mr0a &= ~MR0_BAUD_MODE;
+		mr0a |= up->mr0_baud;
+		write_mr0(port, 0, mr0a);
 	}
 
 	write_cmd_port(port, CR_RES_MR);
 	WRITE_SC_PORT(port, MRx, mr1);
 	WRITE_SC_PORT(port, MRx, mr2);
 
-	WRITE_SC(port, ACR, 0x80);
+	WRITE_SC(port, ACR, up->acr);
 	WRITE_SC_PORT(port, CSR, csr);
 
 	/* reset tx and rx */
@@ -511,7 +600,7 @@ static void sc26xx_set_termios(struct uart_port *port, struct ktermios *termios,
 
 static const char *sc26xx_type(struct uart_port *port)
 {
-	return "SC26XX";
+	return driver_info(port)->chip->name;
 }
 
 static void sc26xx_release_port(struct uart_port *port)
@@ -645,6 +734,60 @@ static void __devinit sc26xx_init_masks(struct uart_sc26xx_port *up,
 	up->ri_mask[line]  = sc26xx_flags2mask(data, 20);
 }
 
+static int __devinit init_baudgroup(struct uart_sc26xx_port *up)
+{
+	u8 baud_mode = up->chip->default_baud_mode;
+	u8 baud_group = up->chip->default_baud_group;
+
+	if (baud_mode > up->chip->max_baud_mode) {
+		printk(KERN_ERR "Baud mode %d not supported for %s\n",
+			baud_mode, up->chip->name);
+		return -EINVAL;
+	}
+
+	up->acr = baud_group ? 0x80 : 0;
+	up->baud_rates = baud_rates[baud_mode][baud_group];
+
+	switch (baud_mode) {
+	case 0:
+		up->mr0_baud = 0;
+		break;
+	case 1:
+		up->mr0_baud = 1;
+		break;
+	case 2:
+		up->mr0_baud = 4;
+		break;
+	}
+	return 0;
+}
+
+static const struct chip_def * __devinit detect_chip_type(
+	struct uart_sc26xx_port *up)
+{
+	struct uart_port *port = &up->port[0];
+	struct chip_def *chip;
+	int i;
+	u8 mrx[3];
+
+	/* Code below needs to be tested on 26xx hardware
+	 * Idea is that 26xx will ignore SEL_MR0 so 2nd and 3rd reads
+	 * will return same data.*/
+	write_cmd_port(port, CR_RES_MR); /* MR1 */
+	write_cmd_port(port, CR_SEL_MR0); /* Ignored on 26xx */
+
+	for (i = 0; i < 3; i++)
+		mrx[i] = READ_SC_PORT(port, MRx);
+
+	if (mrx[1] == mrx[2])
+		chip = &chip_26xx;
+	else
+		chip = &chip_2892;
+
+	dev_info(port->dev, "Autodetected %s\n", chip->name);
+	return chip;
+}
+
 static int __devinit sc26xx_probe(struct platform_device *dev)
 {
 	struct resource *res, *irq_res;
@@ -685,6 +828,11 @@ static int __devinit sc26xx_probe(struct platform_device *dev)
 
 	sc26xx_init_masks(up, 1, sc26xx_data[1]);
 
+	up->chip = detect_chip_type(up);
+	err = init_baudgroup(up);
+	if (err)
+		goto out_free_port;
+
 	err = uart_register_driver(&sc26xx_reg);
 	if (err)
 		goto out_free_port;

