Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbXJEPoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbXJEPoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763160AbXJEPoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:44:34 -0400
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:36249
	"EHLO ghaskins-t60p.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759883AbXJEPo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:44:29 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/2] SERIAL_CONSOLE: Clean up some of the IO routines to
	support locked and unlocked variants
To: mingo@elte.hu, tglx@linutronix.de, rostedt@goodmis.org
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       ghaskins@novell.com
Date: Fri, 05 Oct 2007 11:42:09 -0400
Message-ID: <20071005154209.24349.55451.stgit@ghaskins-t60p.haskins.net>
In-Reply-To: <20071005153517.24349.62653.stgit@ghaskins-t60p.haskins.net>
References: <20071005153517.24349.62653.stgit@ghaskins-t60p.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleanup in preparation for the console-nodelay patch to follow

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 drivers/serial/8250.c |  459 ++++++++++++++++++++++++++-----------------------
 1 files changed, 241 insertions(+), 218 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index bec3cdf..e443098 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -351,7 +351,7 @@ static inline int map_8250_out_reg(struct uart_8250_port *up, int offset)
 
 #endif
 
-static unsigned int serial_in(struct uart_8250_port *up, int offset)
+static unsigned int __serial_in(struct uart_8250_port *up, int offset)
 {
 	unsigned int tmp;
 	offset = map_8250_in_reg(up, offset) << up->port.regshift;
@@ -386,8 +386,20 @@ static unsigned int serial_in(struct uart_8250_port *up, int offset)
 	}
 }
 
+static unsigned int serial_in(struct uart_8250_port *up, int offset)
+{
+	unsigned int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&up->port.lock, flags);
+	ret = __serial_in(up, offset);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+
+	return ret;
+}
+
 static void
-serial_out(struct uart_8250_port *up, int offset, int value)
+__serial_out(struct uart_8250_port *up, int offset, int value)
 {
 	/* Save the offset before it's remapped */
 	int save_offset = offset;
@@ -427,7 +439,7 @@ serial_out(struct uart_8250_port *up, int offset, int value)
 		/* Read the IER to ensure any interrupt is cleared before
 		 * returning from ISR. */
 		if (save_offset == UART_TX || save_offset == UART_IER)
-			value = serial_in(up, UART_IER);
+			value = __serial_in(up, UART_IER);
 		break;
 
 	default:
@@ -435,6 +447,15 @@ serial_out(struct uart_8250_port *up, int offset, int value)
 	}
 }
 
+static unsigned int serial_out(struct uart_8250_port *up, int offset, int value)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&up->port.lock, flags);
+	__serial_out(up, offset, value);
+	spin_unlock_irqrestore(&up->port.lock, flags);
+}
+
 static void
 serial_out_sync(struct uart_8250_port *up, int offset, int value)
 {
@@ -445,11 +466,11 @@ serial_out_sync(struct uart_8250_port *up, int offset, int value)
 	case UPIO_AU:
 #endif
 	case UPIO_DWAPB:
-		serial_out(up, offset, value);
-		serial_in(up, UART_LCR);	/* safe, no side-effects */
+		__serial_out(up, offset, value);
+		__serial_in(up, UART_LCR);	/* safe, no side-effects */
 		break;
 	default:
-		serial_out(up, offset, value);
+		__serial_out(up, offset, value);
 	}
 }
 
@@ -459,20 +480,22 @@ serial_out_sync(struct uart_8250_port *up, int offset, int value)
  * needed for certain old 386 machines, I've left these #define's
  * in....
  */
-#define serial_inp(up, offset)		serial_in(up, offset)
-#define serial_outp(up, offset, value)	serial_out(up, offset, value)
+#define __serial_inp(up, offset)		__serial_in(up, offset)
+#define __serial_outp(up, offset, value)	__serial_out(up, offset, value)
+#define serial_inp(up, offset)		        serial_in(up, offset)
+#define serial_outp(up, offset, value)	        serial_out(up, offset, value)
 
 /* Uart divisor latch read */
 static inline int _serial_dl_read(struct uart_8250_port *up)
 {
-	return serial_inp(up, UART_DLL) | serial_inp(up, UART_DLM) << 8;
+	return __serial_inp(up, UART_DLL) | __serial_inp(up, UART_DLM) << 8;
 }
 
 /* Uart divisor latch write */
 static inline void _serial_dl_write(struct uart_8250_port *up, int value)
 {
-	serial_outp(up, UART_DLL, value & 0xff);
-	serial_outp(up, UART_DLM, value >> 8 & 0xff);
+	__serial_outp(up, UART_DLL, value & 0xff);
+	__serial_outp(up, UART_DLM, value >> 8 & 0xff);
 }
 
 #if defined (CONFIG_SERIAL_8250_AU1X00)
@@ -520,8 +543,8 @@ static void serial_dl_write(struct uart_8250_port *up, int value)
  */
 static void serial_icr_write(struct uart_8250_port *up, int offset, int value)
 {
-	serial_out(up, UART_SCR, offset);
-	serial_out(up, UART_ICR, value);
+	__serial_out(up, UART_SCR, offset);
+	__serial_out(up, UART_ICR, value);
 }
 
 static unsigned int serial_icr_read(struct uart_8250_port *up, int offset)
@@ -529,8 +552,8 @@ static unsigned int serial_icr_read(struct uart_8250_port *up, int offset)
 	unsigned int value;
 
 	serial_icr_write(up, UART_ACR, up->acr | UART_ACR_ICRRD);
-	serial_out(up, UART_SCR, offset);
-	value = serial_in(up, UART_ICR);
+	__serial_out(up, UART_SCR, offset);
+	value = __serial_in(up, UART_ICR);
 	serial_icr_write(up, UART_ACR, up->acr);
 
 	return value;
@@ -542,10 +565,10 @@ static unsigned int serial_icr_read(struct uart_8250_port *up, int offset)
 static inline void serial8250_clear_fifos(struct uart_8250_port *p)
 {
 	if (p->capabilities & UART_CAP_FIFO) {
-		serial_outp(p, UART_FCR, UART_FCR_ENABLE_FIFO);
-		serial_outp(p, UART_FCR, UART_FCR_ENABLE_FIFO |
+		__serial_outp(p, UART_FCR, UART_FCR_ENABLE_FIFO);
+		__serial_outp(p, UART_FCR, UART_FCR_ENABLE_FIFO |
 			       UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
-		serial_outp(p, UART_FCR, 0);
+		__serial_outp(p, UART_FCR, 0);
 	}
 }
 
@@ -558,15 +581,15 @@ static inline void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
 {
 	if (p->capabilities & UART_CAP_SLEEP) {
 		if (p->capabilities & UART_CAP_EFR) {
-			serial_outp(p, UART_LCR, 0xBF);
-			serial_outp(p, UART_EFR, UART_EFR_ECB);
-			serial_outp(p, UART_LCR, 0);
+			__serial_outp(p, UART_LCR, 0xBF);
+			__serial_outp(p, UART_EFR, UART_EFR_ECB);
+			__serial_outp(p, UART_LCR, 0);
 		}
-		serial_outp(p, UART_IER, sleep ? UART_IERX_SLEEP : 0);
+		__serial_outp(p, UART_IER, sleep ? UART_IERX_SLEEP : 0);
 		if (p->capabilities & UART_CAP_EFR) {
-			serial_outp(p, UART_LCR, 0xBF);
-			serial_outp(p, UART_EFR, 0);
-			serial_outp(p, UART_LCR, 0);
+			__serial_outp(p, UART_LCR, 0xBF);
+			__serial_outp(p, UART_EFR, 0);
+			__serial_outp(p, UART_LCR, 0);
 		}
 	}
 }
@@ -581,12 +604,12 @@ static int __enable_rsa(struct uart_8250_port *up)
 	unsigned char mode;
 	int result;
 
-	mode = serial_inp(up, UART_RSA_MSR);
+	mode = __serial_inp(up, UART_RSA_MSR);
 	result = mode & UART_RSA_MSR_FIFO;
 
 	if (!result) {
-		serial_outp(up, UART_RSA_MSR, mode | UART_RSA_MSR_FIFO);
-		mode = serial_inp(up, UART_RSA_MSR);
+		__serial_outp(up, UART_RSA_MSR, mode | UART_RSA_MSR_FIFO);
+		mode = __serial_inp(up, UART_RSA_MSR);
 		result = mode & UART_RSA_MSR_FIFO;
 	}
 
@@ -605,7 +628,7 @@ static void enable_rsa(struct uart_8250_port *up)
 			spin_unlock_irq(&up->port.lock);
 		}
 		if (up->port.uartclk == SERIAL_RSA_BAUD_BASE * 16)
-			serial_outp(up, UART_RSA_FRR, 0);
+			__serial_outp(up, UART_RSA_FRR, 0);
 	}
 }
 
@@ -624,12 +647,12 @@ static void disable_rsa(struct uart_8250_port *up)
 	    up->port.uartclk == SERIAL_RSA_BAUD_BASE * 16) {
 		spin_lock_irq(&up->port.lock);
 
-		mode = serial_inp(up, UART_RSA_MSR);
+		mode = __serial_inp(up, UART_RSA_MSR);
 		result = !(mode & UART_RSA_MSR_FIFO);
 
 		if (!result) {
-			serial_outp(up, UART_RSA_MSR, mode & ~UART_RSA_MSR_FIFO);
-			mode = serial_inp(up, UART_RSA_MSR);
+			__serial_outp(up, UART_RSA_MSR, mode & ~UART_RSA_MSR_FIFO);
+			mode = __serial_inp(up, UART_RSA_MSR);
 			result = !(mode & UART_RSA_MSR_FIFO);
 		}
 
@@ -650,28 +673,28 @@ static int size_fifo(struct uart_8250_port *up)
 	unsigned short old_dl;
 	int count;
 
-	old_lcr = serial_inp(up, UART_LCR);
-	serial_outp(up, UART_LCR, 0);
-	old_fcr = serial_inp(up, UART_FCR);
-	old_mcr = serial_inp(up, UART_MCR);
-	serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO |
+	old_lcr = __serial_inp(up, UART_LCR);
+	__serial_outp(up, UART_LCR, 0);
+	old_fcr = __serial_inp(up, UART_FCR);
+	old_mcr = __serial_inp(up, UART_MCR);
+	__serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO |
 		    UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
-	serial_outp(up, UART_MCR, UART_MCR_LOOP);
-	serial_outp(up, UART_LCR, UART_LCR_DLAB);
+	__serial_outp(up, UART_MCR, UART_MCR_LOOP);
+	__serial_outp(up, UART_LCR, UART_LCR_DLAB);
 	old_dl = serial_dl_read(up);
 	serial_dl_write(up, 0x0001);
-	serial_outp(up, UART_LCR, 0x03);
+	__serial_outp(up, UART_LCR, 0x03);
 	for (count = 0; count < 256; count++)
-		serial_outp(up, UART_TX, count);
+		__serial_outp(up, UART_TX, count);
 	mdelay(20);/* FIXME - schedule_timeout */
-	for (count = 0; (serial_inp(up, UART_LSR) & UART_LSR_DR) &&
+	for (count = 0; (__serial_inp(up, UART_LSR) & UART_LSR_DR) &&
 	     (count < 256); count++)
-		serial_inp(up, UART_RX);
-	serial_outp(up, UART_FCR, old_fcr);
-	serial_outp(up, UART_MCR, old_mcr);
-	serial_outp(up, UART_LCR, UART_LCR_DLAB);
+		__serial_inp(up, UART_RX);
+	__serial_outp(up, UART_FCR, old_fcr);
+	__serial_outp(up, UART_MCR, old_mcr);
+	__serial_outp(up, UART_LCR, UART_LCR_DLAB);
 	serial_dl_write(up, old_dl);
-	serial_outp(up, UART_LCR, old_lcr);
+	__serial_outp(up, UART_LCR, old_lcr);
 
 	return count;
 }
@@ -686,20 +709,20 @@ static unsigned int autoconfig_read_divisor_id(struct uart_8250_port *p)
 	unsigned char old_dll, old_dlm, old_lcr;
 	unsigned int id;
 
-	old_lcr = serial_inp(p, UART_LCR);
-	serial_outp(p, UART_LCR, UART_LCR_DLAB);
+	old_lcr = __serial_inp(p, UART_LCR);
+	__serial_outp(p, UART_LCR, UART_LCR_DLAB);
 
-	old_dll = serial_inp(p, UART_DLL);
-	old_dlm = serial_inp(p, UART_DLM);
+	old_dll = __serial_inp(p, UART_DLL);
+	old_dlm = __serial_inp(p, UART_DLM);
 
-	serial_outp(p, UART_DLL, 0);
-	serial_outp(p, UART_DLM, 0);
+	__serial_outp(p, UART_DLL, 0);
+	__serial_outp(p, UART_DLM, 0);
 
-	id = serial_inp(p, UART_DLL) | serial_inp(p, UART_DLM) << 8;
+	id = __serial_inp(p, UART_DLL) | __serial_inp(p, UART_DLM) << 8;
 
-	serial_outp(p, UART_DLL, old_dll);
-	serial_outp(p, UART_DLM, old_dlm);
-	serial_outp(p, UART_LCR, old_lcr);
+	__serial_outp(p, UART_DLL, old_dll);
+	__serial_outp(p, UART_DLM, old_dlm);
+	__serial_outp(p, UART_LCR, old_lcr);
 
 	return id;
 }
@@ -741,9 +764,9 @@ static void autoconfig_has_efr(struct uart_8250_port *up)
 	 * recommended for new designs).
 	 */
 	up->acr = 0;
-	serial_out(up, UART_LCR, 0xBF);
-	serial_out(up, UART_EFR, UART_EFR_ECB);
-	serial_out(up, UART_LCR, 0x00);
+	__serial_out(up, UART_LCR, 0xBF);
+	__serial_out(up, UART_EFR, UART_EFR_ECB);
+	__serial_out(up, UART_LCR, 0x00);
 	id1 = serial_icr_read(up, UART_ID1);
 	id2 = serial_icr_read(up, UART_ID2);
 	id3 = serial_icr_read(up, UART_ID3);
@@ -808,12 +831,12 @@ static void autoconfig_8250(struct uart_8250_port *up)
 
 	up->port.type = PORT_8250;
 
-	scratch = serial_in(up, UART_SCR);
-	serial_outp(up, UART_SCR, 0xa5);
-	status1 = serial_in(up, UART_SCR);
-	serial_outp(up, UART_SCR, 0x5a);
-	status2 = serial_in(up, UART_SCR);
-	serial_outp(up, UART_SCR, scratch);
+	scratch = __serial_in(up, UART_SCR);
+	__serial_outp(up, UART_SCR, 0xa5);
+	status1 = __serial_in(up, UART_SCR);
+	__serial_outp(up, UART_SCR, 0x5a);
+	status2 = __serial_in(up, UART_SCR);
+	__serial_outp(up, UART_SCR, scratch);
 
 	if (status1 == 0xa5 && status2 == 0x5a)
 		up->port.type = PORT_16450;
@@ -850,17 +873,17 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 	 * Check for presence of the EFR when DLAB is set.
 	 * Only ST16C650V1 UARTs pass this test.
 	 */
-	serial_outp(up, UART_LCR, UART_LCR_DLAB);
-	if (serial_in(up, UART_EFR) == 0) {
-		serial_outp(up, UART_EFR, 0xA8);
-		if (serial_in(up, UART_EFR) != 0) {
+	__serial_outp(up, UART_LCR, UART_LCR_DLAB);
+	if (__serial_in(up, UART_EFR) == 0) {
+		__serial_outp(up, UART_EFR, 0xA8);
+		if (__serial_in(up, UART_EFR) != 0) {
 			DEBUG_AUTOCONF("EFRv1 ");
 			up->port.type = PORT_16650;
 			up->capabilities |= UART_CAP_EFR | UART_CAP_SLEEP;
 		} else {
 			DEBUG_AUTOCONF("Motorola 8xxx DUART ");
 		}
-		serial_outp(up, UART_EFR, 0);
+		__serial_outp(up, UART_EFR, 0);
 		return;
 	}
 
@@ -868,8 +891,8 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 	 * Maybe it requires 0xbf to be written to the LCR.
 	 * (other ST16C650V2 UARTs, TI16C752A, etc)
 	 */
-	serial_outp(up, UART_LCR, 0xBF);
-	if (serial_in(up, UART_EFR) == 0 && !broken_efr(up)) {
+	__serial_outp(up, UART_LCR, 0xBF);
+	if (__serial_in(up, UART_EFR) == 0 && !broken_efr(up)) {
 		DEBUG_AUTOCONF("EFRv2 ");
 		autoconfig_has_efr(up);
 		return;
@@ -882,35 +905,35 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 	 * switch back to bank 2, read it from EXCR1 again and check
 	 * it's changed. If so, set baud_base in EXCR2 to 921600. -- dwmw2
 	 */
-	serial_outp(up, UART_LCR, 0);
-	status1 = serial_in(up, UART_MCR);
-	serial_outp(up, UART_LCR, 0xE0);
-	status2 = serial_in(up, 0x02); /* EXCR1 */
+	__serial_outp(up, UART_LCR, 0);
+	status1 = __serial_in(up, UART_MCR);
+	__serial_outp(up, UART_LCR, 0xE0);
+	status2 = __serial_in(up, 0x02); /* EXCR1 */
 
 	if (!((status2 ^ status1) & UART_MCR_LOOP)) {
-		serial_outp(up, UART_LCR, 0);
-		serial_outp(up, UART_MCR, status1 ^ UART_MCR_LOOP);
-		serial_outp(up, UART_LCR, 0xE0);
-		status2 = serial_in(up, 0x02); /* EXCR1 */
-		serial_outp(up, UART_LCR, 0);
-		serial_outp(up, UART_MCR, status1);
+		__serial_outp(up, UART_LCR, 0);
+		__serial_outp(up, UART_MCR, status1 ^ UART_MCR_LOOP);
+		__serial_outp(up, UART_LCR, 0xE0);
+		status2 = __serial_in(up, 0x02); /* EXCR1 */
+		__serial_outp(up, UART_LCR, 0);
+		__serial_outp(up, UART_MCR, status1);
 
 		if ((status2 ^ status1) & UART_MCR_LOOP) {
 			unsigned short quot;
 
-			serial_outp(up, UART_LCR, 0xE0);
+			__serial_outp(up, UART_LCR, 0xE0);
 
 			quot = serial_dl_read(up);
 			quot <<= 3;
 
-			status1 = serial_in(up, 0x04); /* EXCR2 */
+			status1 = __serial_in(up, 0x04); /* EXCR2 */
 			status1 &= ~0xB0; /* Disable LOCK, mask out PRESL[01] */
 			status1 |= 0x10;  /* 1.625 divisor for baud_base --> 921600 */
-			serial_outp(up, 0x04, status1);
+			__serial_outp(up, 0x04, status1);
 
 			serial_dl_write(up, quot);
 
-			serial_outp(up, UART_LCR, 0);
+			__serial_outp(up, UART_LCR, 0);
 
 			up->port.uartclk = 921600*16;
 			up->port.type = PORT_NS16550A;
@@ -925,15 +948,15 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 	 * Try setting it with and without DLAB set.  Cheap clones
 	 * set bit 5 without DLAB set.
 	 */
-	serial_outp(up, UART_LCR, 0);
-	serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO | UART_FCR7_64BYTE);
-	status1 = serial_in(up, UART_IIR) >> 5;
-	serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO);
-	serial_outp(up, UART_LCR, UART_LCR_DLAB);
-	serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO | UART_FCR7_64BYTE);
-	status2 = serial_in(up, UART_IIR) >> 5;
-	serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO);
-	serial_outp(up, UART_LCR, 0);
+	__serial_outp(up, UART_LCR, 0);
+	__serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO | UART_FCR7_64BYTE);
+	status1 = __serial_in(up, UART_IIR) >> 5;
+	__serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO);
+	__serial_outp(up, UART_LCR, UART_LCR_DLAB);
+	__serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO | UART_FCR7_64BYTE);
+	status2 = __serial_in(up, UART_IIR) >> 5;
+	__serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO);
+	__serial_outp(up, UART_LCR, 0);
 
 	DEBUG_AUTOCONF("iir1=%d iir2=%d ", status1, status2);
 
@@ -951,15 +974,15 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 	 * trying to write and read a 1 just to make sure it's not
 	 * already a 1 and maybe locked there before we even start start.
 	 */
-	iersave = serial_in(up, UART_IER);
-	serial_outp(up, UART_IER, iersave & ~UART_IER_UUE);
-	if (!(serial_in(up, UART_IER) & UART_IER_UUE)) {
+	iersave = __serial_in(up, UART_IER);
+	__serial_outp(up, UART_IER, iersave & ~UART_IER_UUE);
+	if (!(__serial_in(up, UART_IER) & UART_IER_UUE)) {
 		/*
 		 * OK it's in a known zero state, try writing and reading
 		 * without disturbing the current state of the other bits.
 		 */
-		serial_outp(up, UART_IER, iersave | UART_IER_UUE);
-		if (serial_in(up, UART_IER) & UART_IER_UUE) {
+		__serial_outp(up, UART_IER, iersave | UART_IER_UUE);
+		if (__serial_in(up, UART_IER) & UART_IER_UUE) {
 			/*
 			 * It's an Xscale.
 			 * We'll leave the UART_IER_UUE bit set to 1 (enabled).
@@ -976,7 +999,7 @@ static void autoconfig_16550a(struct uart_8250_port *up)
 		 */
 		DEBUG_AUTOCONF("Couldn't force IER_UUE to 0 ");
 	}
-	serial_outp(up, UART_IER, iersave);
+	__serial_outp(up, UART_IER, iersave);
 }
 
 /*
@@ -1021,8 +1044,8 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 		 * Note: this is safe as long as MCR bit 4 is clear
 		 * and the device is in "PC" mode.
 		 */
-		scratch = serial_inp(up, UART_IER);
-		serial_outp(up, UART_IER, 0);
+		scratch = __serial_inp(up, UART_IER);
+		__serial_outp(up, UART_IER, 0);
 #ifdef __i386__
 		outb(0xff, 0x080);
 #endif
@@ -1030,13 +1053,13 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 		 * Mask out IER[7:4] bits for test as some UARTs (e.g. TL
 		 * 16C754B) allow only to modify them if an EFR bit is set.
 		 */
-		scratch2 = serial_inp(up, UART_IER) & 0x0f;
-		serial_outp(up, UART_IER, 0x0F);
+		scratch2 = __serial_inp(up, UART_IER) & 0x0f;
+		__serial_outp(up, UART_IER, 0x0F);
 #ifdef __i386__
 		outb(0, 0x080);
 #endif
-		scratch3 = serial_inp(up, UART_IER) & 0x0f;
-		serial_outp(up, UART_IER, scratch);
+		scratch3 = __serial_inp(up, UART_IER) & 0x0f;
+		__serial_outp(up, UART_IER, scratch);
 		if (scratch2 != 0 || scratch3 != 0x0F) {
 			/*
 			 * We failed; there's nothing here
@@ -1047,8 +1070,8 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 		}
 	}
 
-	save_mcr = serial_in(up, UART_MCR);
-	save_lcr = serial_in(up, UART_LCR);
+	save_mcr = __serial_in(up, UART_MCR);
+	save_lcr = __serial_in(up, UART_LCR);
 
 	/*
 	 * Check to see if a UART is really there.  Certain broken
@@ -1060,9 +1083,9 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	 * that conflicts with COM 1-4 --- we hope!
 	 */
 	if (!(up->port.flags & UPF_SKIP_TEST)) {
-		serial_outp(up, UART_MCR, UART_MCR_LOOP | 0x0A);
-		status1 = serial_inp(up, UART_MSR) & 0xF0;
-		serial_outp(up, UART_MCR, save_mcr);
+		__serial_outp(up, UART_MCR, UART_MCR_LOOP | 0x0A);
+		status1 = __serial_inp(up, UART_MSR) & 0xF0;
+		__serial_outp(up, UART_MCR, save_mcr);
 		if (status1 != 0x90) {
 			DEBUG_AUTOCONF("LOOP test failed (%02x) ",
 				       status1);
@@ -1079,12 +1102,12 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	 * We also initialise the EFR (if any) to zero for later.  The
 	 * EFR occupies the same register location as the FCR and IIR.
 	 */
-	serial_outp(up, UART_LCR, 0xBF);
-	serial_outp(up, UART_EFR, 0);
-	serial_outp(up, UART_LCR, 0);
+	__serial_outp(up, UART_LCR, 0xBF);
+	__serial_outp(up, UART_EFR, 0);
+	__serial_outp(up, UART_LCR, 0);
 
-	serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO);
-	scratch = serial_in(up, UART_IIR) >> 6;
+	__serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO);
+	scratch = __serial_in(up, UART_IIR) >> 6;
 
 	DEBUG_AUTOCONF("iir=%d ", scratch);
 
@@ -1126,7 +1149,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 		up->bugs |= UART_BUG_NOMSR;
 #endif
 
-	serial_outp(up, UART_LCR, save_lcr);
+	__serial_outp(up, UART_LCR, save_lcr);
 
 	if (up->capabilities != uart_config[up->port.type].flags) {
 		printk(KERN_WARNING
@@ -1147,15 +1170,15 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	 */
 #ifdef CONFIG_SERIAL_8250_RSA
 	if (up->port.type == PORT_RSA)
-		serial_outp(up, UART_RSA_FRR, 0);
+		__serial_outp(up, UART_RSA_FRR, 0);
 #endif
-	serial_outp(up, UART_MCR, save_mcr);
+	__serial_outp(up, UART_MCR, save_mcr);
 	serial8250_clear_fifos(up);
-	serial_in(up, UART_RX);
+	__serial_in(up, UART_RX);
 	if (up->capabilities & UART_CAP_UUE)
-		serial_outp(up, UART_IER, UART_IER_UUE);
+		__serial_outp(up, UART_IER, UART_IER_UUE);
 	else
-		serial_outp(up, UART_IER, 0);
+		__serial_outp(up, UART_IER, 0);
 
  out:
 	spin_unlock_irqrestore(&up->port.lock, flags);
@@ -1179,31 +1202,31 @@ static void autoconfig_irq(struct uart_8250_port *up)
 
 	/* forget possible initially masked and pending IRQ */
 	probe_irq_off(probe_irq_on());
-	save_mcr = serial_inp(up, UART_MCR);
-	save_ier = serial_inp(up, UART_IER);
-	serial_outp(up, UART_MCR, UART_MCR_OUT1 | UART_MCR_OUT2);
+	save_mcr = __serial_inp(up, UART_MCR);
+	save_ier = __serial_inp(up, UART_IER);
+	__serial_outp(up, UART_MCR, UART_MCR_OUT1 | UART_MCR_OUT2);
 
 	irqs = probe_irq_on();
-	serial_outp(up, UART_MCR, 0);
+	__serial_outp(up, UART_MCR, 0);
 	udelay (10);
 	if (up->port.flags & UPF_FOURPORT)  {
-		serial_outp(up, UART_MCR,
+		__serial_outp(up, UART_MCR,
 			    UART_MCR_DTR | UART_MCR_RTS);
 	} else {
-		serial_outp(up, UART_MCR,
+		__serial_outp(up, UART_MCR,
 			    UART_MCR_DTR | UART_MCR_RTS | UART_MCR_OUT2);
 	}
-	serial_outp(up, UART_IER, 0x0f);	/* enable all intrs */
-	(void)serial_inp(up, UART_LSR);
-	(void)serial_inp(up, UART_RX);
-	(void)serial_inp(up, UART_IIR);
-	(void)serial_inp(up, UART_MSR);
-	serial_outp(up, UART_TX, 0xFF);
+	__serial_outp(up, UART_IER, 0x0f);	/* enable all intrs */
+	(void)__serial_inp(up, UART_LSR);
+	(void)__serial_inp(up, UART_RX);
+	(void)__serial_inp(up, UART_IIR);
+	(void)__serial_inp(up, UART_MSR);
+	__serial_outp(up, UART_TX, 0xFF);
 	udelay (20);
 	irq = probe_irq_off(irqs);
 
-	serial_outp(up, UART_MCR, save_mcr);
-	serial_outp(up, UART_IER, save_ier);
+	__serial_outp(up, UART_MCR, save_mcr);
+	__serial_outp(up, UART_IER, save_ier);
 
 	if (up->port.flags & UPF_FOURPORT)
 		outb_p(save_ICP, ICP);
@@ -1215,7 +1238,7 @@ static inline void __stop_tx(struct uart_8250_port *p)
 {
 	if (p->ier & UART_IER_THRI) {
 		p->ier &= ~UART_IER_THRI;
-		serial_out(p, UART_IER, p->ier);
+		__serial_out(p, UART_IER, p->ier);
 	}
 }
 
@@ -1242,13 +1265,13 @@ static void serial8250_start_tx(struct uart_port *port)
 
 	if (!(up->ier & UART_IER_THRI)) {
 		up->ier |= UART_IER_THRI;
-		serial_out(up, UART_IER, up->ier);
+		__serial_out(up, UART_IER, up->ier);
 
 		if (up->bugs & UART_BUG_TXEN) {
 			unsigned char lsr, iir;
-			lsr = serial_in(up, UART_LSR);
+			lsr = __serial_in(up, UART_LSR);
 			up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
-			iir = serial_in(up, UART_IIR) & 0x0f;
+			iir = __serial_in(up, UART_IIR) & 0x0f;
 			if ((up->port.type == PORT_RM9000) ?
 				(lsr & UART_LSR_THRE &&
 				(iir == UART_IIR_NO_INT || iir == UART_IIR_THRI)) :
@@ -1272,7 +1295,7 @@ static void serial8250_stop_rx(struct uart_port *port)
 
 	up->ier &= ~UART_IER_RLSI;
 	up->port.read_status_mask &= ~UART_LSR_DR;
-	serial_out(up, UART_IER, up->ier);
+	__serial_out(up, UART_IER, up->ier);
 }
 
 static void serial8250_enable_ms(struct uart_port *port)
@@ -1284,7 +1307,7 @@ static void serial8250_enable_ms(struct uart_port *port)
 		return;
 
 	up->ier |= UART_IER_MSI;
-	serial_out(up, UART_IER, up->ier);
+	__serial_out(up, UART_IER, up->ier);
 }
 
 static void
@@ -1296,7 +1319,7 @@ receive_chars(struct uart_8250_port *up, unsigned int *status)
 	char flag;
 
 	do {
-		ch = serial_inp(up, UART_RX);
+		ch = __serial_inp(up, UART_RX);
 		flag = TTY_NORMAL;
 		up->port.icount.rx++;
 
@@ -1344,7 +1367,7 @@ receive_chars(struct uart_8250_port *up, unsigned int *status)
 		uart_insert_char(&up->port, lsr, UART_LSR_OE, ch, flag);
 
 	ignore_char:
-		lsr = serial_inp(up, UART_LSR);
+		lsr = __serial_inp(up, UART_LSR);
 	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
 	spin_unlock(&up->port.lock);
 	tty_flip_buffer_push(tty);
@@ -1358,7 +1381,7 @@ static void transmit_chars(struct uart_8250_port *up)
 	int count;
 
 	if (up->port.x_char) {
-		serial_outp(up, UART_TX, up->port.x_char);
+		__serial_outp(up, UART_TX, up->port.x_char);
 		up->port.icount.tx++;
 		up->port.x_char = 0;
 		return;
@@ -1374,7 +1397,7 @@ static void transmit_chars(struct uart_8250_port *up)
 
 	count = up->tx_loadsz;
 	do {
-		serial_out(up, UART_TX, xmit->buf[xmit->tail]);
+		__serial_out(up, UART_TX, xmit->buf[xmit->tail]);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		up->port.icount.tx++;
 		if (uart_circ_empty(xmit))
@@ -1392,7 +1415,7 @@ static void transmit_chars(struct uart_8250_port *up)
 
 static unsigned int check_modem_status(struct uart_8250_port *up)
 {
-	unsigned int status = serial_in(up, UART_MSR);
+	unsigned int status = __serial_in(up, UART_MSR);
 
 	status |= up->msr_saved_flags;
 	up->msr_saved_flags = 0;
@@ -1424,7 +1447,7 @@ serial8250_handle_port(struct uart_8250_port *up)
 
 	spin_lock_irqsave(&up->port.lock, flags);
 
-	status = serial_inp(up, UART_LSR);
+	status = __serial_inp(up, UART_LSR);
 
 	DEBUG_INTR("status = %x...", status);
 
@@ -1471,7 +1494,7 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 
 		up = list_entry(l, struct uart_8250_port, list);
 
-		iir = serial_in(up, UART_IIR);
+		iir = __serial_in(up, UART_IIR);
 		if (!(iir & UART_IIR_NO_INT)) {
 			serial8250_handle_port(up);
 
@@ -1486,7 +1509,7 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 			 * the UART status register (USR) and the LCR re-written. */
 			unsigned int status;
 			status = *(volatile u32 *)up->port.private_data;
-			serial_out(up, UART_LCR, up->lcr);
+			__serial_out(up, UART_LCR, up->lcr);
 
 			handled = 1;
 
@@ -1595,7 +1618,7 @@ static void serial8250_timeout(unsigned long data)
 	struct uart_8250_port *up = (struct uart_8250_port *)data;
 	unsigned int iir;
 
-	iir = serial_in(up, UART_IIR);
+	iir = __serial_in(up, UART_IIR);
 	if (!(iir & UART_IIR_NO_INT))
 		serial8250_handle_port(up);
 	mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout));
@@ -1612,11 +1635,11 @@ static void serial8250_backup_timeout(unsigned long data)
 	 * based handler.
 	 */
 	if (is_real_interrupt(up->port.irq)) {
-		ier = serial_in(up, UART_IER);
-		serial_out(up, UART_IER, 0);
+		ier = __serial_in(up, UART_IER);
+		__serial_out(up, UART_IER, 0);
 	}
 
-	iir = serial_in(up, UART_IIR);
+	iir = __serial_in(up, UART_IIR);
 
 	/*
 	 * This should be a safe test for anyone who doesn't trust the
@@ -1639,7 +1662,7 @@ static void serial8250_backup_timeout(unsigned long data)
 		serial8250_handle_port(up);
 
 	if (is_real_interrupt(up->port.irq))
-		serial_out(up, UART_IER, ier);
+		__serial_out(up, UART_IER, ier);
 
 	/* Standard timer interval plus 0.2s to keep the port running */
 	mod_timer(&up->timer, jiffies + poll_timeout(up->port.timeout) + HZ/5);
@@ -1652,7 +1675,7 @@ static unsigned int serial8250_tx_empty(struct uart_port *port)
 	unsigned int lsr;
 
 	spin_lock_irqsave(&up->port.lock, flags);
-	lsr = serial_in(up, UART_LSR);
+	lsr = __serial_in(up, UART_LSR);
 	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 	spin_unlock_irqrestore(&up->port.lock, flags);
 
@@ -1697,7 +1720,7 @@ static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 	mcr = (mcr & up->mcr_mask) | up->mcr_force | up->mcr;
 
-	serial_out(up, UART_MCR, mcr);
+	__serial_out(up, UART_MCR, mcr);
 }
 
 static void serial8250_break_ctl(struct uart_port *port, int break_state)
@@ -1710,7 +1733,7 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 		up->lcr |= UART_LCR_SBC;
 	else
 		up->lcr &= ~UART_LCR_SBC;
-	serial_out(up, UART_LCR, up->lcr);
+	__serial_out(up, UART_LCR, up->lcr);
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
@@ -1725,7 +1748,7 @@ static inline void wait_for_xmitr(struct uart_8250_port *up, int bits)
 
 	/* Wait up to 10ms for the character(s) to be sent. */
 	do {
-		status = serial_in(up, UART_LSR);
+		status = __serial_in(up, UART_LSR);
 
 		up->lsr_saved_flags |= status & LSR_SAVE_FLAGS;
 
@@ -1738,7 +1761,7 @@ static inline void wait_for_xmitr(struct uart_8250_port *up, int bits)
 	if (up->port.flags & UPF_CONS_FLOW) {
 		unsigned int tmout;
 		for (tmout = 1000000; tmout; tmout--) {
-			unsigned int msr = serial_in(up, UART_MSR);
+			unsigned int msr = __serial_in(up, UART_MSR);
 			up->msr_saved_flags |= msr & MSR_SAVE_FLAGS;
 			if (msr & UART_MSR_CTS)
 				break;
@@ -1761,14 +1784,14 @@ static int serial8250_startup(struct uart_port *port)
 	if (up->port.type == PORT_16C950) {
 		/* Wake up and initialize UART */
 		up->acr = 0;
-		serial_outp(up, UART_LCR, 0xBF);
-		serial_outp(up, UART_EFR, UART_EFR_ECB);
-		serial_outp(up, UART_IER, 0);
-		serial_outp(up, UART_LCR, 0);
+		__serial_outp(up, UART_LCR, 0xBF);
+		__serial_outp(up, UART_EFR, UART_EFR_ECB);
+		__serial_outp(up, UART_IER, 0);
+		__serial_outp(up, UART_LCR, 0);
 		serial_icr_write(up, UART_CSR, 0); /* Reset the UART */
-		serial_outp(up, UART_LCR, 0xBF);
-		serial_outp(up, UART_EFR, UART_EFR_ECB);
-		serial_outp(up, UART_LCR, 0);
+		__serial_outp(up, UART_LCR, 0xBF);
+		__serial_outp(up, UART_EFR, UART_EFR_ECB);
+		__serial_outp(up, UART_LCR, 0);
 	}
 
 #ifdef CONFIG_SERIAL_8250_RSA
@@ -1788,10 +1811,10 @@ static int serial8250_startup(struct uart_port *port)
 	/*
 	 * Clear the interrupt registers.
 	 */
-	(void) serial_inp(up, UART_LSR);
-	(void) serial_inp(up, UART_RX);
-	(void) serial_inp(up, UART_IIR);
-	(void) serial_inp(up, UART_MSR);
+	(void) __serial_inp(up, UART_LSR);
+	(void) __serial_inp(up, UART_RX);
+	(void) __serial_inp(up, UART_IIR);
+	(void) __serial_inp(up, UART_MSR);
 
 	/*
 	 * At this point, there's no way the LSR could still be 0xff;
@@ -1799,7 +1822,7 @@ static int serial8250_startup(struct uart_port *port)
 	 * here.
 	 */
 	if (!(up->port.flags & UPF_BUGGY_UART) &&
-	    (serial_inp(up, UART_LSR) == 0xff)) {
+	    (__serial_inp(up, UART_LSR) == 0xff)) {
 		printk("ttyS%d: LSR safety check engaged!\n", up->port.line);
 		return -ENODEV;
 	}
@@ -1810,15 +1833,15 @@ static int serial8250_startup(struct uart_port *port)
 	if (up->port.type == PORT_16850) {
 		unsigned char fctr;
 
-		serial_outp(up, UART_LCR, 0xbf);
+		__serial_outp(up, UART_LCR, 0xbf);
 
-		fctr = serial_inp(up, UART_FCTR) & ~(UART_FCTR_RX|UART_FCTR_TX);
-		serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD | UART_FCTR_RX);
-		serial_outp(up, UART_TRG, UART_TRG_96);
-		serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD | UART_FCTR_TX);
-		serial_outp(up, UART_TRG, UART_TRG_96);
+		fctr = __serial_inp(up, UART_FCTR) & ~(UART_FCTR_RX|UART_FCTR_TX);
+		__serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD | UART_FCTR_RX);
+		__serial_outp(up, UART_TRG, UART_TRG_96);
+		__serial_outp(up, UART_FCTR, fctr | UART_FCTR_TRGD | UART_FCTR_TX);
+		__serial_outp(up, UART_TRG, UART_TRG_96);
 
-		serial_outp(up, UART_LCR, 0);
+		__serial_outp(up, UART_LCR, 0);
 	}
 
 	if (is_real_interrupt(up->port.irq)) {
@@ -1835,12 +1858,12 @@ static int serial8250_startup(struct uart_port *port)
 		wait_for_xmitr(up, UART_LSR_THRE);
 		serial_out_sync(up, UART_IER, UART_IER_THRI);
 		udelay(1); /* allow THRE to set */
-		serial_in(up, UART_IIR);
-		serial_out(up, UART_IER, 0);
+		__serial_in(up, UART_IIR);
+		__serial_out(up, UART_IER, 0);
 		serial_out_sync(up, UART_IER, UART_IER_THRI);
 		udelay(1); /* allow a working UART time to re-assert THRE */
-		iir = serial_in(up, UART_IIR);
-		serial_out(up, UART_IER, 0);
+		iir = __serial_in(up, UART_IIR);
+		__serial_out(up, UART_IER, 0);
 
 		spin_unlock_irqrestore(&up->port.lock, flags);
 
@@ -1874,7 +1897,7 @@ static int serial8250_startup(struct uart_port *port)
 	/*
 	 * Now, initialize the UART
 	 */
-	serial_outp(up, UART_LCR, UART_LCR_WLEN8);
+	__serial_outp(up, UART_LCR, UART_LCR_WLEN8);
 
 	spin_lock_irqsave(&up->port.lock, flags);
 	if (up->port.flags & UPF_FOURPORT) {
@@ -1893,10 +1916,10 @@ static int serial8250_startup(struct uart_port *port)
 	 * Do a quick test to see if we receive an
 	 * interrupt when we enable the TX irq.
 	 */
-	serial_outp(up, UART_IER, UART_IER_THRI);
-	lsr = serial_in(up, UART_LSR);
-	iir = serial_in(up, UART_IIR);
-	serial_outp(up, UART_IER, 0);
+	__serial_outp(up, UART_IER, UART_IER_THRI);
+	lsr = __serial_in(up, UART_LSR);
+	iir = __serial_in(up, UART_IIR);
+	__serial_outp(up, UART_IER, 0);
 
 	if (lsr & UART_LSR_TEMT && iir & UART_IIR_NO_INT) {
 		if (!(up->bugs & UART_BUG_TXEN)) {
@@ -1915,10 +1938,10 @@ static int serial8250_startup(struct uart_port *port)
 	 * saved flags to avoid getting false values from polling
 	 * routines or the previous session.
 	 */
-	serial_inp(up, UART_LSR);
-	serial_inp(up, UART_RX);
-	serial_inp(up, UART_IIR);
-	serial_inp(up, UART_MSR);
+	__serial_inp(up, UART_LSR);
+	__serial_inp(up, UART_RX);
+	__serial_inp(up, UART_IIR);
+	__serial_inp(up, UART_MSR);
 	up->lsr_saved_flags = 0;
 	up->msr_saved_flags = 0;
 
@@ -1928,7 +1951,7 @@ static int serial8250_startup(struct uart_port *port)
 	 * anyway, so we don't enable them here.
 	 */
 	up->ier = UART_IER_RLSI | UART_IER_RDI;
-	serial_outp(up, UART_IER, up->ier);
+	__serial_outp(up, UART_IER, up->ier);
 
 	if (up->port.flags & UPF_FOURPORT) {
 		unsigned int icp;
@@ -1952,7 +1975,7 @@ static void serial8250_shutdown(struct uart_port *port)
 	 * Disable interrupts from this port
 	 */
 	up->ier = 0;
-	serial_outp(up, UART_IER, 0);
+	__serial_outp(up, UART_IER, 0);
 
 	spin_lock_irqsave(&up->port.lock, flags);
 	if (up->port.flags & UPF_FOURPORT) {
@@ -1968,7 +1991,7 @@ static void serial8250_shutdown(struct uart_port *port)
 	/*
 	 * Disable break condition and FIFOs
 	 */
-	serial_out(up, UART_LCR, serial_inp(up, UART_LCR) & ~UART_LCR_SBC);
+	__serial_out(up, UART_LCR, __serial_inp(up, UART_LCR) & ~UART_LCR_SBC);
 	serial8250_clear_fifos(up);
 
 #ifdef CONFIG_SERIAL_8250_RSA
@@ -1982,7 +2005,7 @@ static void serial8250_shutdown(struct uart_port *port)
 	 * Read data port to reset things, and then unlink from
 	 * the IRQ chain.
 	 */
-	(void) serial_in(up, UART_RX);
+	(void) __serial_in(up, UART_RX);
 
 	del_timer_sync(&up->timer);
 	up->timer.function = serial8250_timeout;
@@ -2128,7 +2151,7 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (up->capabilities & UART_CAP_UUE)
 		up->ier |= UART_IER_UUE | UART_IER_RTOIE;
 
-	serial_out(up, UART_IER, up->ier);
+	__serial_out(up, UART_IER, up->ier);
 
 	if (up->capabilities & UART_CAP_EFR) {
 		unsigned char efr = 0;
@@ -2140,8 +2163,8 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 		if (termios->c_cflag & CRTSCTS)
 			efr |= UART_EFR_CTS;
 
-		serial_outp(up, UART_LCR, 0xBF);
-		serial_outp(up, UART_EFR, efr);
+		__serial_outp(up, UART_LCR, 0xBF);
+		__serial_outp(up, UART_EFR, efr);
 	}
 
 #ifdef CONFIG_ARCH_OMAP15XX
@@ -2149,17 +2172,17 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (cpu_is_omap1510() && is_omap_port((unsigned int)up->port.membase)) {
 		if (baud == 115200) {
 			quot = 1;
-			serial_out(up, UART_OMAP_OSC_12M_SEL, 1);
+			__serial_out(up, UART_OMAP_OSC_12M_SEL, 1);
 		} else
-			serial_out(up, UART_OMAP_OSC_12M_SEL, 0);
+			__serial_out(up, UART_OMAP_OSC_12M_SEL, 0);
 	}
 #endif
 
 	if (up->capabilities & UART_NATSEMI) {
 		/* Switch to bank 2 not bank 1, to avoid resetting EXCR2 */
-		serial_outp(up, UART_LCR, 0xe0);
+		__serial_outp(up, UART_LCR, 0xe0);
 	} else {
-		serial_outp(up, UART_LCR, cval | UART_LCR_DLAB);/* set DLAB */
+		__serial_outp(up, UART_LCR, cval | UART_LCR_DLAB);/* set DLAB */
 	}
 
 	serial_dl_write(up, quot);
@@ -2169,16 +2192,16 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * is written without DLAB set, this mode will be disabled.
 	 */
 	if (up->port.type == PORT_16750)
-		serial_outp(up, UART_FCR, fcr);
+		__serial_outp(up, UART_FCR, fcr);
 
-	serial_outp(up, UART_LCR, cval);		/* reset DLAB */
+	__serial_outp(up, UART_LCR, cval);		/* reset DLAB */
 	up->lcr = cval;					/* Save LCR */
 	if (up->port.type != PORT_16750) {
 		if (fcr & UART_FCR_ENABLE_FIFO) {
 			/* emulated UARTs (Lucent Venus 167x) need two steps */
-			serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO);
+			__serial_outp(up, UART_FCR, UART_FCR_ENABLE_FIFO);
 		}
-		serial_outp(up, UART_FCR, fcr);		/* set fcr */
+		__serial_outp(up, UART_FCR, fcr);		/* set fcr */
 	}
 	serial8250_set_mctrl(&up->port, up->port.mctrl);
 	spin_unlock_irqrestore(&up->port.lock, flags);
@@ -2463,7 +2486,7 @@ static void serial8250_console_putchar(struct uart_port *port, int ch)
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
 
 	wait_for_xmitr(up, UART_LSR_THRE);
-	serial_out(up, UART_TX, ch);
+	__serial_out(up, UART_TX, ch);
 }
 
 /*
@@ -2490,12 +2513,12 @@ serial8250_console_write(struct console *co, const char *s, unsigned int count)
 	/*
 	 *	First save the IER then disable the interrupts
 	 */
-	ier = serial_in(up, UART_IER);
+	ier = __serial_in(up, UART_IER);
 
 	if (up->capabilities & UART_CAP_UUE)
-		serial_out(up, UART_IER, UART_IER_UUE);
+		__serial_out(up, UART_IER, UART_IER_UUE);
 	else
-		serial_out(up, UART_IER, 0);
+		__serial_out(up, UART_IER, 0);
 
 	uart_console_write(&up->port, s, count, serial8250_console_putchar);
 
@@ -2504,7 +2527,7 @@ serial8250_console_write(struct console *co, const char *s, unsigned int count)
 	 *	and restore the IER
 	 */
 	wait_for_xmitr(up, BOTH_EMPTY);
-	serial_out(up, UART_IER, ier);
+	__serial_out(up, UART_IER, ier);
 
 	/*
 	 *	The receive handling will happen properly because the
@@ -2640,14 +2663,14 @@ void serial8250_resume_port(int line)
 		unsigned char tmp;
 
 		/* Ensure it's still in high speed mode */
-		serial_outp(up, UART_LCR, 0xE0);
+		__serial_outp(up, UART_LCR, 0xE0);
 
-		tmp = serial_in(up, 0x04); /* EXCR2 */
+		tmp = __serial_in(up, 0x04); /* EXCR2 */
 		tmp &= ~0xB0; /* Disable LOCK, mask out PRESL[01] */
 		tmp |= 0x10;  /* 1.625 divisor for baud_base --> 921600 */
-		serial_outp(up, 0x04, tmp);
+		__serial_outp(up, 0x04, tmp);
 
-		serial_outp(up, UART_LCR, 0);
+		__serial_outp(up, UART_LCR, 0);
 	}
 	uart_resume_port(&serial8250_reg, &up->port);
 }

