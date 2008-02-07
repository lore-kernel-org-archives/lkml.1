Return-Path: <linux-kernel-owner+w=401wt.eu-S964834AbYBGVXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbYBGVXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935714AbYBGVUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:20:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52263 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935349AbYBGVUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:20:00 -0500
Message-ID: <47AB75EB.3040405@zytor.com>
Date: Thu, 07 Feb 2008 13:19:39 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 says "serial8250: too much work for irq4" a lot.
References: <200802051455.10831.rob@landley.net> <20080207123937.GC15647@elte.hu> <47AB41C8.3010001@zytor.com> <200802071413.45085.rob@landley.net>
In-Reply-To: <200802071413.45085.rob@landley.net>
Content-Type: multipart/mixed;
 boundary="------------090109090804000709000801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090109090804000709000801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Rob Landley wrote:
> 
> Specifically, qemu isn't paravirtualized, it's fully virtualized.  The same 
> kernel can run on real hardware just fine.  (Sort of the point of the 
> project...)
> 
> I can yank the warning for the kernels I build (or set PASS_LIMIT to 9999999), 
> but I'd rather not carry any more patches than I can avoid...
> 

Patch attached, completely untested beyond compilation.

In particular:

	- we should probably clear the burst counter when the interrupt
	  line goes from inactive to active.
	- there probably should be a timer which clears the burst
  	  counter.

However, I think I've covered most of the bases...

	-hpa

--------------090109090804000709000801
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/hw/serial.c b/hw/serial.c
index b1bd0ff..c902792 100644
--- a/hw/serial.c
+++ b/hw/serial.c
@@ -73,6 +73,15 @@
 #define UART_LSR_OE	0x02	/* Overrun error indicator */
 #define UART_LSR_DR	0x01	/* Receiver data ready */
 
+/*
+ * It's common for an IRQ handler to keep reading the RBR until
+ * the LSR indicates that the FIFO is empty, expecting that the
+ * CPU is vastly faster than the serial line.  This can cause
+ * overruns or error indications if the FIFO never empties, so
+ * give the target OS a breather every so often.
+ */
+#define MAX_BURST	512
+
 struct SerialState {
     uint16_t divider;
     uint8_t rbr; /* receive register */
@@ -91,8 +100,14 @@ struct SerialState {
     int last_break_enable;
     target_phys_addr_t base;
     int it_shift;
+    int burst_len;
 };
 
+static void serial_clear_burst(SerialState *s)
+{
+    s->burst_len = 0;
+}
+
 static void serial_update_irq(SerialState *s)
 {
     if ((s->lsr & UART_LSR_DR) && (s->ier & UART_IER_RDI)) {
@@ -114,6 +129,8 @@ static void serial_update_parameters(SerialState *s)
     int speed, parity, data_bits, stop_bits;
     QEMUSerialSetParams ssp;
 
+    serial_clear_burst(s);
+
     if (s->lcr & 0x08) {
         if (s->lcr & 0x10)
             parity = 'E';
@@ -221,9 +238,12 @@ static uint32_t serial_ioport_read(void *opaque, uint32_t addr)
             ret = s->divider & 0xff;
         } else {
             ret = s->rbr;
-            s->lsr &= ~(UART_LSR_DR | UART_LSR_BI);
-            serial_update_irq(s);
-            qemu_chr_accept_input(s->chr);
+	    if (s->burst_len < MAX_BURST) {
+		s->burst_len++;
+		s->lsr &= ~(UART_LSR_DR | UART_LSR_BI);
+		serial_update_irq(s);
+		qemu_chr_accept_input(s->chr);
+	    }
         }
         break;
     case 1:
@@ -235,6 +255,7 @@ static uint32_t serial_ioport_read(void *opaque, uint32_t addr)
         break;
     case 2:
         ret = s->iir;
+	serial_clear_burst(s);
         /* reset THR pending bit */
         if ((ret & 0x7) == UART_IIR_THRI)
             s->thr_ipending = 0;
@@ -248,6 +269,10 @@ static uint32_t serial_ioport_read(void *opaque, uint32_t addr)
         break;
     case 5:
         ret = s->lsr;
+	if (s->burst_len >= MAX_BURST)
+	    ret &= ~(UART_LSR_DR|UART_LSR_BI);
+	if (!(ret & UART_LSR_DR))
+	    serial_clear_burst(s);
         break;
     case 6:
         if (s->mcr & UART_MCR_LOOP) {

--------------090109090804000709000801--
