Return-Path: <linux-kernel-owner+w=401wt.eu-S1757737AbXJ3Je4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737AbXJ3Je4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758108AbXJ3Jds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:33:48 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:36633 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbXJ3Jdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:33:43 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2007 05:33:42 EDT
Date: Tue, 30 Oct 2007 10:33:28 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: [PATCH 10/16] CRIS architecture: Correct compile errors
Message-ID: <20071030093328.GM11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

New and improved serial driver for cris v10.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 linux-2.6.23-mod/drivers/serial/crisv10.h |  151 +++++
 linux-2.6.23/drivers/serial/crisv10.c     |  797 +++++++++++++-----------------
 2 files changed, 520 insertions(+), 428 deletions(-)

diff -urBb -X /h/jespern/.exclude_files clean_linux-2.6.23/drivers/serial/crisv10.c linux-2.6.23/drivers/serial/crisv10.c
--- clean_linux-2.6.23/drivers/serial/crisv10.c	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/drivers/serial/crisv10.c	2007-10-23 10:49:53.000000000 +0200
@@ -2,7 +2,7 @@
  *
  * Serial port driver for the ETRAX 100LX chip
  *
- *    Copyright (C) 1998, 1999, 2000, 2001, 2002, 2003  Axis Communications AB
+ *    Copyright (C) 1998-2007  Axis Communications AB
  *
  *    Many, many authors. Based once upon a time on serial.c for 16x50.
  *
@@ -445,6 +445,7 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
+#include <asm/dma.h>
 #include <asm/system.h>
 #include <asm/bitops.h>
 #include <linux/delay.h>
@@ -454,8 +455,9 @@
 /* non-arch dependent serial structures are in linux/serial.h */
 #include <linux/serial.h>
 /* while we keep our own stuff (struct e100_serial) in a local .h file */
-#include "serial.h"
+#include "crisv10.h"
 #include <asm/fasttimer.h>
+#include <asm/arch/io_interface_mux.h>
 
 #ifdef CONFIG_ETRAX_SERIAL_FAST_TIMER
 #ifndef CONFIG_ETRAX_FAST_TIMER
@@ -586,11 +588,10 @@
 static void change_speed(struct e100_serial *info);
 static void rs_throttle(struct tty_struct * tty);
 static void rs_wait_until_sent(struct tty_struct *tty, int timeout);
-static int rs_write(struct tty_struct * tty, int from_user,
+static int rs_write(struct tty_struct * tty,
                     const unsigned char *buf, int count);
 #ifdef CONFIG_ETRAX_RS485
-static int e100_write_rs485(struct tty_struct * tty, int from_user,
-                            const unsigned char *buf, int count);
+static int e100_write_rs485(struct tty_struct * tty, const unsigned char *buf, int count);
 #endif
 static int get_lsr_info(struct e100_serial * info, unsigned int *value);
 
@@ -677,20 +678,39 @@
 	  .rx_ctrl     = DEF_RX,
 	  .tx_ctrl     = DEF_TX,
 	  .iseteop     = 2,
+	  .dma_owner   = dma_ser0,
+	  .io_if       = if_serial_0,
 #ifdef CONFIG_ETRAX_SERIAL_PORT0
           .enabled  = 1,
 #ifdef CONFIG_ETRAX_SERIAL_PORT0_DMA6_OUT
 	  .dma_out_enabled = 1,
+	  .dma_out_nbr = SER0_TX_DMA_NBR,
+	  .dma_out_irq_nbr = SER0_DMA_TX_IRQ_NBR,
+	  .dma_out_irq_flags = IRQF_DISABLED,
+	  .dma_out_irq_description = "serial 0 dma tr",
 #else
 	  .dma_out_enabled = 0,
+	  .dma_out_nbr = UINT_MAX,
+	  .dma_out_irq_nbr = 0,
+	  .dma_out_irq_flags = 0,
+	  .dma_out_irq_description = NULL,
 #endif
 #ifdef CONFIG_ETRAX_SERIAL_PORT0_DMA7_IN
 	  .dma_in_enabled = 1,
+	  .dma_in_nbr = SER0_RX_DMA_NBR,
+	  .dma_in_irq_nbr = SER0_DMA_RX_IRQ_NBR,
+	  .dma_in_irq_flags = IRQF_DISABLED,
+	  .dma_in_irq_description = "serial 0 dma rec",
 #else
-	  .dma_in_enabled = 0
+	  .dma_in_enabled = 0,
+	  .dma_in_nbr = UINT_MAX,
+	  .dma_in_irq_nbr = 0,
+	  .dma_in_irq_flags = 0,
+	  .dma_in_irq_description = NULL,
 #endif
 #else
           .enabled  = 0,
+	  .io_if_description = NULL,
 	  .dma_out_enabled = 0,
 	  .dma_in_enabled = 0
 #endif
@@ -712,20 +732,42 @@
 	  .rx_ctrl     = DEF_RX,
 	  .tx_ctrl     = DEF_TX,
 	  .iseteop     = 3,
+	  .dma_owner   = dma_ser1,
+	  .io_if       = if_serial_1,
 #ifdef CONFIG_ETRAX_SERIAL_PORT1
           .enabled  = 1,
+	  .io_if_description = "ser1",
 #ifdef CONFIG_ETRAX_SERIAL_PORT1_DMA8_OUT
 	  .dma_out_enabled = 1,
+	  .dma_out_nbr = SER1_TX_DMA_NBR,
+	  .dma_out_irq_nbr = SER1_DMA_TX_IRQ_NBR,
+	  .dma_out_irq_flags = IRQF_DISABLED,
+	  .dma_out_irq_description = "serial 1 dma tr",
 #else
 	  .dma_out_enabled = 0,
+	  .dma_out_nbr = UINT_MAX,
+	  .dma_out_irq_nbr = 0,
+	  .dma_out_irq_flags = 0,
+	  .dma_out_irq_description = NULL,
 #endif
 #ifdef CONFIG_ETRAX_SERIAL_PORT1_DMA9_IN
 	  .dma_in_enabled = 1,
+	  .dma_in_nbr = SER1_RX_DMA_NBR,
+	  .dma_in_irq_nbr = SER1_DMA_RX_IRQ_NBR,
+	  .dma_in_irq_flags = IRQF_DISABLED,
+	  .dma_in_irq_description = "serial 1 dma rec",
 #else
-	  .dma_in_enabled = 0
+	  .dma_in_enabled = 0,
+	  .dma_in_enabled = 0,
+	  .dma_in_nbr = UINT_MAX,
+	  .dma_in_irq_nbr = 0,
+	  .dma_in_irq_flags = 0,
+	  .dma_in_irq_description = NULL,
 #endif
 #else
           .enabled  = 0,
+	  .io_if_description = NULL,
+	  .dma_in_irq_nbr = 0,
 	  .dma_out_enabled = 0,
 	  .dma_in_enabled = 0
 #endif
@@ -746,20 +788,40 @@
 	  .rx_ctrl     = DEF_RX,
 	  .tx_ctrl     = DEF_TX,
 	  .iseteop     = 0,
+	  .dma_owner   = dma_ser2,
+	  .io_if       = if_serial_2,
 #ifdef CONFIG_ETRAX_SERIAL_PORT2
           .enabled  = 1,
+	  .io_if_description = "ser2",
 #ifdef CONFIG_ETRAX_SERIAL_PORT2_DMA2_OUT
 	  .dma_out_enabled = 1,
+	  .dma_out_nbr = SER2_TX_DMA_NBR,
+	  .dma_out_irq_nbr = SER2_DMA_TX_IRQ_NBR,
+	  .dma_out_irq_flags = IRQF_DISABLED,
+	  .dma_out_irq_description = "serial 2 dma tr",
 #else
 	  .dma_out_enabled = 0,
+	  .dma_out_nbr = UINT_MAX,
+	  .dma_out_irq_nbr = 0,
+	  .dma_out_irq_flags = 0,
+	  .dma_out_irq_description = NULL,
 #endif
 #ifdef CONFIG_ETRAX_SERIAL_PORT2_DMA3_IN
 	  .dma_in_enabled = 1,
+	  .dma_in_nbr = SER2_RX_DMA_NBR,
+	  .dma_in_irq_nbr = SER2_DMA_RX_IRQ_NBR,
+	  .dma_in_irq_flags = IRQF_DISABLED,
+	  .dma_in_irq_description = "serial 2 dma rec",
 #else
-	  .dma_in_enabled = 0
+	  .dma_in_enabled = 0,
+	  .dma_in_nbr = UINT_MAX,
+	  .dma_in_irq_nbr = 0,
+	  .dma_in_irq_flags = 0,
+	  .dma_in_irq_description = NULL,
 #endif
 #else
           .enabled  = 0,
+	  .io_if_description = NULL,
 	  .dma_out_enabled = 0,
 	  .dma_in_enabled = 0
 #endif
@@ -780,20 +842,40 @@
 	  .rx_ctrl     = DEF_RX,
 	  .tx_ctrl     = DEF_TX,
 	  .iseteop     = 1,
+	  .dma_owner   = dma_ser3,
+	  .io_if       = if_serial_3,
 #ifdef CONFIG_ETRAX_SERIAL_PORT3
           .enabled  = 1,
+	  .io_if_description = "ser3",
 #ifdef CONFIG_ETRAX_SERIAL_PORT3_DMA4_OUT
 	  .dma_out_enabled = 1,
+	  .dma_out_nbr = SER3_TX_DMA_NBR,
+	  .dma_out_irq_nbr = SER3_DMA_TX_IRQ_NBR,
+	  .dma_out_irq_flags = IRQF_DISABLED,
+	  .dma_out_irq_description = "serial 3 dma tr",
 #else
 	  .dma_out_enabled = 0,
+	  .dma_out_nbr = UINT_MAX,
+	  .dma_out_irq_nbr = 0,
+	  .dma_out_irq_flags = 0,
+	  .dma_out_irq_description = NULL,
 #endif
 #ifdef CONFIG_ETRAX_SERIAL_PORT3_DMA5_IN
 	  .dma_in_enabled = 1,
+	  .dma_in_nbr = SER3_RX_DMA_NBR,
+	  .dma_in_irq_nbr = SER3_DMA_RX_IRQ_NBR,
+	  .dma_in_irq_flags = IRQF_DISABLED,
+	  .dma_in_irq_description = "serial 3 dma rec",
 #else
-	  .dma_in_enabled = 0
+	  .dma_in_enabled = 0,
+	  .dma_in_nbr = UINT_MAX,
+	  .dma_in_irq_nbr = 0,
+	  .dma_in_irq_flags = 0,
+	  .dma_in_irq_description = NULL
 #endif
 #else
           .enabled  = 0,
+	  .io_if_description = NULL,
 	  .dma_out_enabled = 0,
 	  .dma_in_enabled = 0
 #endif
@@ -1414,12 +1496,11 @@
 	{
 		unsigned long flags;
 
-		save_flags(flags);
-		cli();
+		local_irq_save(flags);
 		*e100_modem_pins[info->line].dtr_shadow &= ~mask;
 		*e100_modem_pins[info->line].dtr_shadow |= (set ? 0 : mask);
 		*e100_modem_pins[info->line].dtr_port = *e100_modem_pins[info->line].dtr_shadow;
-		restore_flags(flags);
+		local_irq_restore(flags);
 	}
 
 #ifdef SERIAL_DEBUG_IO
@@ -1438,12 +1519,11 @@
 {
 #ifndef CONFIG_SVINTO_SIM
 	unsigned long flags;
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 	info->rx_ctrl &= ~E100_RTS_MASK;
 	info->rx_ctrl |= (set ? 0 : E100_RTS_MASK);  /* RTS is active low */
 	info->port[REG_REC_CTRL] = info->rx_ctrl;
-	restore_flags(flags);
+	local_irq_restore(flags);
 #ifdef SERIAL_DEBUG_IO
 	printk("ser%i rts %i\n", info->line, set);
 #endif
@@ -1461,12 +1541,11 @@
 		unsigned char mask = e100_modem_pins[info->line].ri_mask;
 		unsigned long flags;
 
-		save_flags(flags);
-		cli();
+		local_irq_save(flags);
 		*e100_modem_pins[info->line].ri_shadow &= ~mask;
 		*e100_modem_pins[info->line].ri_shadow |= (set ? 0 : mask);
 		*e100_modem_pins[info->line].ri_port = *e100_modem_pins[info->line].ri_shadow;
-		restore_flags(flags);
+		local_irq_restore(flags);
 	}
 #endif
 }
@@ -1479,12 +1558,11 @@
 		unsigned char mask = e100_modem_pins[info->line].cd_mask;
 		unsigned long flags;
 
-		save_flags(flags);
-		cli();
+		local_irq_save(flags);
 		*e100_modem_pins[info->line].cd_shadow &= ~mask;
 		*e100_modem_pins[info->line].cd_shadow |= (set ? 0 : mask);
 		*e100_modem_pins[info->line].cd_port = *e100_modem_pins[info->line].cd_shadow;
-		restore_flags(flags);
+		local_irq_restore(flags);
 	}
 #endif
 }
@@ -1558,8 +1636,7 @@
 	/* Disable output DMA channel for the serial port in question
 	 * ( set to something other then serialX)
 	 */
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 	DFLOW(DEBUG_LOG(info->line, "disable_txdma_channel %i\n", info->line));
 	if (info->line == 0) {
 		if ((genconfig_shadow & IO_MASK(R_GEN_CONFIG, dma6)) ==
@@ -1587,7 +1664,7 @@
 		}
 	}
 	*R_GEN_CONFIG = genconfig_shadow;
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 
@@ -1595,8 +1672,7 @@
 {
 	unsigned long flags;
 
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 	DFLOW(DEBUG_LOG(info->line, "enable_txdma_channel %i\n", info->line));
 	/* Enable output DMA channel for the serial port in question */
 	if (info->line == 0) {
@@ -1613,7 +1689,7 @@
 		genconfig_shadow |= IO_STATE(R_GEN_CONFIG, dma4, serial3);
 	}
 	*R_GEN_CONFIG = genconfig_shadow;
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 static void e100_disable_rxdma_channel(struct e100_serial *info)
@@ -1623,8 +1699,7 @@
 	/* Disable input DMA channel for the serial port in question
 	 * ( set to something other then serialX)
 	 */
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 	if (info->line == 0) {
 		if ((genconfig_shadow & IO_MASK(R_GEN_CONFIG, dma7)) ==
 		    IO_STATE(R_GEN_CONFIG, dma7, serial0)) {
@@ -1651,7 +1726,7 @@
 		}
 	}
 	*R_GEN_CONFIG = genconfig_shadow;
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 
@@ -1659,8 +1734,7 @@
 {
 	unsigned long flags;
 
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 	/* Enable input DMA channel for the serial port in question */
 	if (info->line == 0) {
 		genconfig_shadow &=  ~IO_MASK(R_GEN_CONFIG, dma7);
@@ -1676,7 +1750,7 @@
 		genconfig_shadow |= IO_STATE(R_GEN_CONFIG, dma5, serial3);
 	}
 	*R_GEN_CONFIG = genconfig_shadow;
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 #ifdef SERIAL_HANDLE_EARLY_ERRORS
@@ -1783,7 +1857,7 @@
 }
 
 static int
-e100_write_rs485(struct tty_struct *tty, int from_user,
+e100_write_rs485(struct tty_struct *tty,
                  const unsigned char *buf, int count)
 {
 	struct e100_serial * info = (struct e100_serial *)tty->driver_data;
@@ -1796,7 +1870,7 @@
 	 */
 	info->rs485.enabled = 1;
 	/* rs_write now deals with RS485 if enabled */
-	count = rs_write(tty, from_user, buf, count);
+	count = rs_write(tty, buf, count);
 	info->rs485.enabled = old_enabled;
 	return count;
 }
@@ -1834,7 +1908,7 @@
 		unsigned long flags;
 		unsigned long xoff;
 
-		save_flags(flags); cli();
+		local_irq_save(flags);
 		DFLOW(DEBUG_LOG(info->line, "XOFF rs_stop xmit %i\n",
 				CIRC_CNT(info->xmit.head,
 					 info->xmit.tail,SERIAL_XMIT_SIZE)));
@@ -1846,7 +1920,7 @@
 		}
 
 		*((unsigned long *)&info->port[REG_XOFF]) = xoff;
-		restore_flags(flags);
+		local_irq_restore(flags);
 	}
 }
 
@@ -1858,7 +1932,7 @@
 		unsigned long flags;
 		unsigned long xoff;
 
-		save_flags(flags); cli();
+		local_irq_save(flags);
 		DFLOW(DEBUG_LOG(info->line, "XOFF rs_start xmit %i\n",
 				CIRC_CNT(info->xmit.head,
 					 info->xmit.tail,SERIAL_XMIT_SIZE)));
@@ -1873,7 +1947,7 @@
 		    info->xmit.head != info->xmit.tail && info->xmit.buf)
 			e100_enable_serial_tx_ready_irq(info);
 
-		restore_flags(flags);
+		local_irq_restore(flags);
 	}
 }
 
@@ -2053,8 +2127,7 @@
 static void flush_timeout_function(unsigned long data);
 #define START_FLUSH_FAST_TIMER_TIME(info, string, usec) {\
   unsigned long timer_flags; \
-  save_flags(timer_flags); \
-  cli(); \
+  local_irq_save(timer_flags); \
   if (fast_timers[info->line].function == NULL) { \
     serial_fast_timer_started++; \
     TIMERD(DEBUG_LOG(info->line, "start_timer %i ", info->line)); \
@@ -2068,7 +2141,7 @@
   else { \
     TIMERD(DEBUG_LOG(info->line, "timer %i already running\n", info->line)); \
   } \
-  restore_flags(timer_flags); \
+  local_irq_restore(timer_flags); \
 }
 #define START_FLUSH_FAST_TIMER(info, string) START_FLUSH_FAST_TIMER_TIME(info, string, info->flush_time_usec)
 
@@ -2097,8 +2170,7 @@
 {
 	unsigned long flags;
 
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 
 	if (!info->first_recv_buffer)
 		info->first_recv_buffer = buffer;
@@ -2111,7 +2183,7 @@
 	if (info->recv_cnt > info->max_recv_cnt)
 		info->max_recv_cnt = info->recv_cnt;
 
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 static int
@@ -2131,11 +2203,7 @@
 		info->icount.rx++;
 	} else {
 		struct tty_struct *tty = info->tty;
-		*tty->flip.char_buf_ptr = data;
-		*tty->flip.flag_buf_ptr = flag;
-		tty->flip.flag_buf_ptr++;
-		tty->flip.char_buf_ptr++;
-		tty->flip.count++;
+		tty_insert_flip_char(tty, data, flag);
 		info->icount.rx++;
 	}
 
@@ -2320,7 +2388,6 @@
 	 */
 	return;
 #endif
-	info->tty->flip.count = 0;
 	if (info->uses_dma_in) {
 		/* reset the input dma channel to be sure it works */
 
@@ -2482,70 +2549,21 @@
 {
 	struct tty_struct *tty;
 	struct etrax_recv_buffer *buffer;
-	unsigned int length;
 	unsigned long flags;
-	int max_flip_size;
-
-	if (!info->first_recv_buffer)
-		return;
 
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
+	tty = info->tty;
 
-	if (!(tty = info->tty)) {
-		restore_flags(flags);
+	if (!tty) {
+		local_irq_restore(flags);
 		return;
 	}
 
-	length = tty->flip.count;
-	/* Don't flip more than the ldisc has room for.
-	 * The return value from ldisc.receive_room(tty) - might not be up to
-	 * date, the previous flip of up to TTY_FLIPBUF_SIZE might be on the
-	 * processed and not accounted for yet.
-	 * Since we use DMA, 1 SERIAL_DESCR_BUF_SIZE could be on the way.
-	 * Lets buffer data here and let flow control take care of it.
-	 * Since we normally flip large chunks, the ldisc don't react
-	 * with throttle until too late if we flip to much.
-	 */
-	max_flip_size = tty->ldisc.receive_room(tty);
-	if (max_flip_size < 0)
-		max_flip_size = 0;
-	if (max_flip_size <= (TTY_FLIPBUF_SIZE +         /* Maybe not accounted for */
-			      length + info->recv_cnt +  /* We have this queued */
-			      2*SERIAL_DESCR_BUF_SIZE +    /* This could be on the way */
-			      TTY_THRESHOLD_THROTTLE)) { /* Some slack */
-		/* check TTY_THROTTLED first so it indicates our state */
-		if (!test_and_set_bit(TTY_THROTTLED, &tty->flags)) {
-			DFLOW(DEBUG_LOG(info->line,"flush_to_flip throttles room %lu\n", max_flip_size));
-			rs_throttle(tty);
-		}
-#if 0
-		else if (max_flip_size <= (TTY_FLIPBUF_SIZE +         /* Maybe not accounted for */
-					   length + info->recv_cnt +  /* We have this queued */
-					   SERIAL_DESCR_BUF_SIZE +    /* This could be on the way */
-					   TTY_THRESHOLD_THROTTLE)) { /* Some slack */
-			DFLOW(DEBUG_LOG(info->line,"flush_to_flip throttles again! %lu\n", max_flip_size));
-			rs_throttle(tty);
-		}
-#endif
-	}
-
-	if (max_flip_size > TTY_FLIPBUF_SIZE)
-		max_flip_size = TTY_FLIPBUF_SIZE;
-
-	while ((buffer = info->first_recv_buffer) && length < max_flip_size) {
+	while ((buffer = info->first_recv_buffer)) {
 		unsigned int count = buffer->length;
 
-		if (length + count > max_flip_size)
-			count = max_flip_size - length;
-
-		memcpy(tty->flip.char_buf_ptr + length, buffer->buffer, count);
-		memset(tty->flip.flag_buf_ptr + length, TTY_NORMAL, count);
-		tty->flip.flag_buf_ptr[length] = buffer->error;
-
-		length += count;
+		tty_insert_flip_string(tty, buffer->buffer, count);
 		info->recv_cnt -= count;
-		DFLIP(DEBUG_LOG(info->line,"flip: %i\n", length));
 
 		if (count == buffer->length) {
 			info->first_recv_buffer = buffer->next;
@@ -2560,24 +2578,7 @@
 	if (!info->first_recv_buffer)
 		info->last_recv_buffer = NULL;
 
-	tty->flip.count = length;
-	DFLIP(if (tty->ldisc.chars_in_buffer(tty) > 3500) {
-		DEBUG_LOG(info->line, "ldisc %lu\n",
-			  tty->ldisc.chars_in_buffer(tty));
-		DEBUG_LOG(info->line, "flip.count %lu\n",
-			  tty->flip.count);
-	      }
-	      );
-	restore_flags(flags);
-
-	DFLIP(
-	  if (1) {
-		  DEBUG_LOG(info->line, "*** rxtot %i\n", info->icount.rx);
-		  DEBUG_LOG(info->line, "ldisc %lu\n", tty->ldisc.chars_in_buffer(tty));
-		  DEBUG_LOG(info->line, "room  %lu\n", tty->ldisc.receive_room(tty));
-	  }
-
-	);
+	local_irq_restore(flags);
 
 	/* this includes a check for low-latency */
 	tty_flip_buffer_push(tty);
@@ -2722,21 +2723,7 @@
 		printk("!NO TTY!\n");
 		return info;
 	}
-	if (tty->flip.count >= TTY_FLIPBUF_SIZE - TTY_THRESHOLD_THROTTLE) {
-		/* check TTY_THROTTLED first so it indicates our state */
-		if (!test_and_set_bit(TTY_THROTTLED, &tty->flags)) {
-			DFLOW(DEBUG_LOG(info->line, "rs_throttle flip.count: %i\n", tty->flip.count));
-			rs_throttle(tty);
-		}
-	}
-	if (tty->flip.count >= TTY_FLIPBUF_SIZE) {
-		DEBUG_LOG(info->line, "force FLIP! %i\n", tty->flip.count);
-		tty->flip.work.func((void *) tty);
-		if (tty->flip.count >= TTY_FLIPBUF_SIZE) {
-			DEBUG_LOG(info->line, "FLIP FULL! %i\n", tty->flip.count);
-			return info;		/* if TTY_DONT_FLIP is set */
-		}
-	}
+
 	/* Read data and status at the same time */
 	data_read = *((unsigned long *)&info->port[REG_DATA_STATUS32]);
 more_data:
@@ -2789,27 +2776,25 @@
 				DEBUG_LOG(info->line, "EBRK %i\n", info->break_detected_cnt);
 				info->errorcode = ERRCODE_INSERT_BREAK;
 			} else {
+				unsigned char data = IO_EXTRACT(R_SERIAL0_READ, data_in, data_read);
+				char flag = TTY_NORMAL;
 				if (info->errorcode == ERRCODE_INSERT_BREAK) {
-					info->icount.brk++;
-					*tty->flip.char_buf_ptr = 0;
-					*tty->flip.flag_buf_ptr = TTY_BREAK;
-					tty->flip.flag_buf_ptr++;
-					tty->flip.char_buf_ptr++;
-					tty->flip.count++;
+					struct tty_struct *tty = info->tty;
+					tty_insert_flip_char(tty, 0, flag);
 					info->icount.rx++;
 				}
-				*tty->flip.char_buf_ptr = IO_EXTRACT(R_SERIAL0_READ, data_in, data_read);
 
 				if (data_read & IO_MASK(R_SERIAL0_READ, par_err)) {
 					info->icount.parity++;
-					*tty->flip.flag_buf_ptr = TTY_PARITY;
+					flag = TTY_PARITY;
 				} else if (data_read & IO_MASK(R_SERIAL0_READ, overrun)) {
 					info->icount.overrun++;
-					*tty->flip.flag_buf_ptr = TTY_OVERRUN;
+					flag = TTY_OVERRUN;
 				} else if (data_read & IO_MASK(R_SERIAL0_READ, framing_err)) {
 					info->icount.frame++;
-					*tty->flip.flag_buf_ptr = TTY_FRAME;
+					flag = TTY_FRAME;
 				}
+				tty_insert_flip_char(tty, data, flag);
 				info->errorcode = 0;
 			}
 			info->break_detected_cnt = 0;
@@ -2825,16 +2810,12 @@
 			log_int(rdpc(), 0, 0);
 		}
 		);
-		*tty->flip.char_buf_ptr = IO_EXTRACT(R_SERIAL0_READ, data_in, data_read);
-		*tty->flip.flag_buf_ptr = 0;
+		tty_insert_flip_char(tty, IO_EXTRACT(R_SERIAL0_READ, data_in, data_read), TTY_NORMAL);
 	} else {
 		DEBUG_LOG(info->line, "ser_rx int but no data_avail  %08lX\n", data_read);
 	}
 
 
-	tty->flip.flag_buf_ptr++;
-	tty->flip.char_buf_ptr++;
-	tty->flip.count++;
 	info->icount.rx++;
 	data_read = *((unsigned long *)&info->port[REG_DATA_STATUS32]);
 	if (data_read & IO_MASK(R_SERIAL0_READ, data_avail)) {
@@ -2972,7 +2953,7 @@
 	if (info->x_char) {
 		unsigned char rstat;
 		DFLOW(DEBUG_LOG(info->line, "tx_int: xchar 0x%02X\n", info->x_char));
-		save_flags(flags); cli();
+		local_irq_save(flags);
 		rstat = info->port[REG_STATUS];
 		DFLOW(DEBUG_LOG(info->line, "stat %x\n", rstat));
 
@@ -2981,7 +2962,7 @@
 		info->x_char = 0;
 		/* We must enable since it is disabled in ser_interrupt */
 		e100_enable_serial_tx_ready_irq(info);
-		restore_flags(flags);
+		local_irq_restore(flags);
 		return;
 	}
 	if (info->uses_dma_out) {
@@ -2989,7 +2970,7 @@
 		int i;
 		/* We only use normal tx interrupt when sending x_char */
 		DFLOW(DEBUG_LOG(info->line, "tx_int: xchar sent\n", 0));
-		save_flags(flags); cli();
+		local_irq_save(flags);
 		rstat = info->port[REG_STATUS];
 		DFLOW(DEBUG_LOG(info->line, "stat %x\n", rstat));
 		e100_disable_serial_tx_ready_irq(info);
@@ -3002,7 +2983,7 @@
 			nop();
 
 		*info->ocmdadr = IO_STATE(R_DMA_CH6_CMD, cmd, continue);
-		restore_flags(flags);
+		local_irq_restore(flags);
 		return;
 	}
 	/* Normal char-by-char interrupt */
@@ -3016,7 +2997,7 @@
 	}
 	DINTR2(DEBUG_LOG(info->line, "tx_int %c\n", info->xmit.buf[info->xmit.tail]));
 	/* Send a byte, rs485 timing is critical so turn of ints */
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	info->port[REG_TR_DATA] = info->xmit.buf[info->xmit.tail];
 	info->xmit.tail = (info->xmit.tail + 1) & (SERIAL_XMIT_SIZE-1);
 	info->icount.tx++;
@@ -3040,7 +3021,7 @@
 		/* We must enable since it is disabled in ser_interrupt */
 		e100_enable_serial_tx_ready_irq(info);
 	}
-	restore_flags(flags);
+	local_irq_restore(flags);
 
 	if (CIRC_CNT(info->xmit.head,
 		     info->xmit.tail,
@@ -3065,7 +3046,7 @@
 	int handled = 0;
 	static volatile unsigned long reentered_ready_mask = 0;
 
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	irq_mask1_rd = *R_IRQ_MASK1_RD;
 	/* First handle all rx interrupts with ints disabled */
 	info = rs_table;
@@ -3110,7 +3091,7 @@
 			/* Unblock the serial interrupt */
 			*R_VECT_MASK_SET = IO_STATE(R_VECT_MASK_SET, serial, set);
 
-			sti();
+			local_irq_enable();
 			ready_mask = (1 << (8+1+2*0)); /* ser0 tr_ready */
 			info = rs_table;
 			for (i = 0; i < NR_PORTS; i++) {
@@ -3123,11 +3104,11 @@
 				ready_mask <<= 2;
 			}
 			/* handle_ser_tx_interrupt enables tr_ready interrupts */
-			cli();
+			local_irq_disable();
 			/* Handle reentered TX interrupt */
 			irq_mask1_rd = reentered_ready_mask;
 		}
-		cli();
+		local_irq_disable();
 		tx_started = 0;
 	} else {
 		unsigned long ready_mask;
@@ -3143,7 +3124,7 @@
 		}
 	}
 
-	restore_flags(flags);
+	local_irq_restore(flags);
 	return IRQ_RETVAL(handled);
 } /* ser_interrupt */
 #endif
@@ -3164,11 +3145,13 @@
  * them using rs_sched_event(), and they get done here.
  */
 static void
-do_softint(void *private_)
+do_softint(struct work_struct* work)
 {
-	struct e100_serial	*info = (struct e100_serial *) private_;
+	struct e100_serial	*info;
 	struct tty_struct	*tty;
 
+	info = container_of(work, struct e100_serial, work);
+
 	tty = info->tty;
 	if (!tty)
 		return;
@@ -3188,13 +3171,12 @@
 	if (!xmit_page)
 		return -ENOMEM;
 
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 
 	/* if it was already initialized, skip this */
 
 	if (info->flags & ASYNC_INITIALIZED) {
-		restore_flags(flags);
+		local_irq_restore(flags);
 		free_page(xmit_page);
 		return 0;
 	}
@@ -3320,7 +3302,7 @@
 
 	info->flags |= ASYNC_INITIALIZED;
 
-	restore_flags(flags);
+	local_irq_restore(flags);
 	return 0;
 }
 
@@ -3371,8 +3353,7 @@
 	       info->irq);
 #endif
 
-	save_flags(flags);
-	cli(); /* Disable interrupts */
+	local_irq_save(flags);
 
 	if (info->xmit.buf) {
 		free_page((unsigned long)info->xmit.buf);
@@ -3396,7 +3377,7 @@
 		set_bit(TTY_IO_ERROR, &info->tty->flags);
 
 	info->flags &= ~ASYNC_INITIALIZED;
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 
@@ -3454,7 +3435,6 @@
 				DBAUD(printk("using external baudrate: %lu\n", CONFIG_ETRAX_EXTERN_PB6CLK_FREQ/8));
 				info->baud = CONFIG_ETRAX_EXTERN_PB6CLK_FREQ/8;
 			}
-		}
 #endif
 		else
 		{
@@ -3488,8 +3468,7 @@
 
 #ifndef CONFIG_SVINTO_SIM
 	/* start with default settings and then fill in changes */
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 	/* 8 bit, no/even parity */
 	info->rx_ctrl &= ~(IO_MASK(R_SERIAL0_REC_CTRL, rec_bitnr) |
 			   IO_MASK(R_SERIAL0_REC_CTRL, rec_par_en) |
@@ -3553,7 +3532,7 @@
 	}
 
 	*((unsigned long *)&info->port[REG_XOFF]) = xoff;
-	restore_flags(flags);
+	local_irq_restore(flags);
 #endif /* !CONFIG_SVINTO_SIM */
 
 	update_char_time(info);
@@ -3581,13 +3560,12 @@
 
 	/* this protection might not exactly be necessary here */
 
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 	start_transmit(info);
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
-static int rs_raw_write(struct tty_struct * tty, int from_user,
+static int rs_raw_write(struct tty_struct * tty,
 			const unsigned char *buf, int count)
 {
 	int	c, ret = 0;
@@ -3610,53 +3588,19 @@
 	SIMCOUT(buf, count);
 	return count;
 #endif
-	save_flags(flags);
+	local_save_flags(flags);
 	DFLOW(DEBUG_LOG(info->line, "write count %i ", count));
 	DFLOW(DEBUG_LOG(info->line, "ldisc %i\n", tty->ldisc.chars_in_buffer(tty)));
 
 
-	/* the cli/restore_flags pairs below are needed because the
+	/* the local_irq_disable/restore_flags pairs below are needed because the
 	 * DMA interrupt handler moves the info->xmit values. the memcpy
 	 * needs to be in the critical region unfortunately, because we
 	 * need to read xmit values, memcpy, write xmit values in one
 	 * atomic operation... this could perhaps be avoided by more clever
 	 * design.
 	 */
-	if (from_user) {
-		mutex_lock(&tmp_buf_mutex);
-		while (1) {
-			int c1;
-			c = CIRC_SPACE_TO_END(info->xmit.head,
-					      info->xmit.tail,
-					      SERIAL_XMIT_SIZE);
-			if (count < c)
-				c = count;
-			if (c <= 0)
-				break;
-
-			c -= copy_from_user(tmp_buf, buf, c);
-			if (!c) {
-				if (!ret)
-					ret = -EFAULT;
-				break;
-			}
-			cli();
-			c1 = CIRC_SPACE_TO_END(info->xmit.head,
-					       info->xmit.tail,
-					       SERIAL_XMIT_SIZE);
-			if (c1 < c)
-				c = c1;
-			memcpy(info->xmit.buf + info->xmit.head, tmp_buf, c);
-			info->xmit.head = ((info->xmit.head + c) &
-					   (SERIAL_XMIT_SIZE-1));
-			restore_flags(flags);
-			buf += c;
-			count -= c;
-			ret += c;
-		}
-		mutex_unlock(&tmp_buf_mutex);
-	} else {
-		cli();
+	local_irq_disable();
 		while (count) {
 			c = CIRC_SPACE_TO_END(info->xmit.head,
 					      info->xmit.tail,
@@ -3674,8 +3618,7 @@
 			count -= c;
 			ret += c;
 		}
-		restore_flags(flags);
-	}
+	local_irq_restore(flags);
 
 	/* enable transmitter if not running, unless the tty is stopped
 	 * this does not need IRQ protection since if tr_running == 0
@@ -3694,7 +3637,7 @@
 } /* raw_raw_write() */
 
 static int
-rs_write(struct tty_struct * tty, int from_user,
+rs_write(struct tty_struct * tty,
 	 const unsigned char *buf, int count)
 {
 #if defined(CONFIG_ETRAX_RS485)
@@ -3721,7 +3664,7 @@
 	}
 #endif /* CONFIG_ETRAX_RS485 */
 
-	count = rs_raw_write(tty, from_user, buf, count);
+	count = rs_raw_write(tty, buf, count);
 
 #if defined(CONFIG_ETRAX_RS485)
 	if (info->rs485.enabled)
@@ -3789,10 +3732,9 @@
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 	unsigned long flags;
 
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 	info->xmit.head = info->xmit.tail = 0;
-	restore_flags(flags);
+	local_irq_restore(flags);
 
 	tty_wakeup(tty);
 }
@@ -3810,7 +3752,7 @@
 {
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 	unsigned long flags;
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	if (info->uses_dma_out) {
 		/* Put the DMA on hold and disable the channel */
 		*info->ocmdadr = IO_STATE(R_DMA_CH6_CMD, cmd, hold);
@@ -3827,7 +3769,7 @@
 	DFLOW(DEBUG_LOG(info->line, "rs_send_xchar 0x%02X\n", ch));
 	info->x_char = ch;
 	e100_enable_serial_tx_ready_irq(info);
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 /*
@@ -4039,120 +3981,89 @@
 }
 #endif
 
-static int
-get_modem_info(struct e100_serial * info, unsigned int *value)
+static void
+rs_break(struct tty_struct *tty, int break_state)
 {
-	unsigned int result;
-	/* Polarity isn't verified */
-#if 0 /*def SERIAL_DEBUG_IO  */
-
-	printk("get_modem_info: RTS: %i DTR: %i CD: %i RI: %i DSR: %i CTS: %i\n",
-	       E100_RTS_GET(info),
-	       E100_DTR_GET(info),
-	       E100_CD_GET(info),
-	       E100_RI_GET(info),
-	       E100_DSR_GET(info),
-	       E100_CTS_GET(info));
-#endif
-
-	result =
-		(!E100_RTS_GET(info) ? TIOCM_RTS : 0)
-		| (!E100_DTR_GET(info) ? TIOCM_DTR : 0)
-		| (!E100_RI_GET(info) ? TIOCM_RNG : 0)
-		| (!E100_DSR_GET(info) ? TIOCM_DSR : 0)
-		| (!E100_CD_GET(info) ? TIOCM_CAR : 0)
-		| (!E100_CTS_GET(info) ? TIOCM_CTS : 0);
+	struct e100_serial * info = (struct e100_serial *)tty->driver_data;
+	unsigned long flags;
 
-#ifdef SERIAL_DEBUG_IO
-	printk("e100ser: modem state: %i 0x%08X\n", result, result);
-	{
-		char s[100];
+	if (!info->port)
+		return;
 
-		get_control_state_str(result, s);
-		printk("state: %s\n", s);
+	local_irq_save(flags);
+	if (break_state == -1) {
+		/* Go to manual mode and set the txd pin to 0 */
+		info->tx_ctrl &= 0x3F; /* Clear bit 7 (txd) and 6 (tr_enable) */
+	} else {
+		info->tx_ctrl |= (0x80 | 0x40); /* Set bit 7 (txd) and 6 (tr_enable) */
 	}
-#endif
-	if (copy_to_user(value, &result, sizeof(int)))
-		return -EFAULT;
-	return 0;
+	info->port[REG_TR_CTRL] = info->tx_ctrl;
+	local_irq_restore(flags);
 }
 
-
 static int
-set_modem_info(struct e100_serial * info, unsigned int cmd,
-	       unsigned int *value)
+rs_tiocmset(struct tty_struct *tty, struct file * file, unsigned int set, unsigned int clear)
 {
-	unsigned int arg;
-
-	if (copy_from_user(&arg, value, sizeof(int)))
-		return -EFAULT;
+	struct e100_serial * info = (struct e100_serial *)tty->driver_data;
 
-	switch (cmd) {
-	case TIOCMBIS:
-		if (arg & TIOCM_RTS) {
-			e100_rts(info, 1);
-		}
-		if (arg & TIOCM_DTR) {
-			e100_dtr(info, 1);
-		}
-		/* Handle FEMALE behaviour */
-		if (arg & TIOCM_RI) {
-			e100_ri_out(info, 1);
-		}
-		if (arg & TIOCM_CD) {
-			e100_cd_out(info, 1);
-		}
-		break;
-	case TIOCMBIC:
-		if (arg & TIOCM_RTS) {
+	if (clear & TIOCM_RTS) {
 			e100_rts(info, 0);
 		}
-		if (arg & TIOCM_DTR) {
+	if (clear & TIOCM_DTR) {
 			e100_dtr(info, 0);
 		}
 		/* Handle FEMALE behaviour */
-		if (arg & TIOCM_RI) {
+	if (clear & TIOCM_RI) {
 			e100_ri_out(info, 0);
 		}
-		if (arg & TIOCM_CD) {
+	if (clear & TIOCM_CD) {
 			e100_cd_out(info, 0);
 		}
-		break;
-	case TIOCMSET:
-		e100_rts(info, arg & TIOCM_RTS);
-		e100_dtr(info, arg & TIOCM_DTR);
+
+	if (set & TIOCM_RTS) {
+		e100_rts(info, 1);
+	}
+	if (set & TIOCM_DTR) {
+		e100_dtr(info, 1);
+	}
 		/* Handle FEMALE behaviour */
-		e100_ri_out(info, arg & TIOCM_RI);
-		e100_cd_out(info, arg & TIOCM_CD);
-		break;
-	default:
-		return -EINVAL;
+	if (set & TIOCM_RI) {
+		e100_ri_out(info, 1);
+	}
+	if (set & TIOCM_CD) {
+		e100_cd_out(info, 1);
 	}
 	return 0;
 }
 
-
-static void
-rs_break(struct tty_struct *tty, int break_state)
+static int
+rs_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct e100_serial * info = (struct e100_serial *)tty->driver_data;
-	unsigned long flags;
+	unsigned int result;
 
-	if (!info->port)
-		return;
+	result =
+		(!E100_RTS_GET(info) ? TIOCM_RTS : 0)
+		| (!E100_DTR_GET(info) ? TIOCM_DTR : 0)
+		| (!E100_RI_GET(info) ? TIOCM_RNG : 0)
+		| (!E100_DSR_GET(info) ? TIOCM_DSR : 0)
+		| (!E100_CD_GET(info) ? TIOCM_CAR : 0)
+		| (!E100_CTS_GET(info) ? TIOCM_CTS : 0);
 
-	save_flags(flags);
-	cli();
-	if (break_state == -1) {
-		/* Go to manual mode and set the txd pin to 0 */
-		info->tx_ctrl &= 0x3F; /* Clear bit 7 (txd) and 6 (tr_enable) */
-	} else {
-		info->tx_ctrl |= (0x80 | 0x40); /* Set bit 7 (txd) and 6 (tr_enable) */
+#ifdef SERIAL_DEBUG_IO
+	printk("ser%i: modem state: %i 0x%08X\n", info->line, result, result);
+	{
+		char s[100];
+
+		get_control_state_str(result, s);
+		printk("state: %s\n", s);
 	}
-	info->port[REG_TR_CTRL] = info->tx_ctrl;
-	restore_flags(flags);
+#endif
+	return result;
+
 }
 
+
 static int
 rs_ioctl(struct tty_struct *tty, struct file * file,
 	 unsigned int cmd, unsigned long arg)
@@ -4167,12 +4078,6 @@
 	}
 
 	switch (cmd) {
-		case TIOCMGET:
-			return get_modem_info(info, (unsigned int *) arg);
-		case TIOCMBIS:
-		case TIOCMBIC:
-		case TIOCMSET:
-			return set_modem_info(info, cmd, (unsigned int *) arg);
 		case TIOCGSERIAL:
 			return get_serial_info(info,
 					       (struct serial_struct *) arg);
@@ -4204,7 +4109,7 @@
 			if (copy_from_user(&rs485wr, (struct rs485_write*)arg, sizeof(rs485wr)))
 				return -EFAULT;
 
-			return e100_write_rs485(tty, 1, rs485wr.outc, rs485wr.outc_size);
+			return e100_write_rs485(tty, rs485wr.outc, rs485wr.outc_size);
 		}
 #endif
 
@@ -4234,46 +4139,6 @@
 
 }
 
-/* In debugport.c - register a console write function that uses the normal
- * serial driver
- */
-typedef int (*debugport_write_function)(int i, const char *buf, unsigned int len);
-
-extern debugport_write_function debug_write_function;
-
-static int rs_debug_write_function(int i, const char *buf, unsigned int len)
-{
-	int cnt;
-	int written = 0;
-        struct tty_struct *tty;
-        static int recurse_cnt = 0;
-
-        tty = rs_table[i].tty;
-        if (tty)  {
-		unsigned long flags;
-		if (recurse_cnt > 5) /* We skip this debug output */
-			return 1;
-
-		local_irq_save(flags);
-		recurse_cnt++;
-		local_irq_restore(flags);
-                do {
-                        cnt = rs_write(tty, 0, buf + written, len);
-                        if (cnt >= 0) {
-				written += cnt;
-                                buf += cnt;
-                                len -= cnt;
-                        } else
-                                len = cnt;
-                } while(len > 0);
-		local_irq_save(flags);
-		recurse_cnt--;
-		local_irq_restore(flags);
-                return 1;
-        }
-        return 0;
-}
-
 /*
  * ------------------------------------------------------------
  * rs_close()
@@ -4295,11 +4160,10 @@
 
 	/* interrupts are disabled for this entire function */
 
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 
 	if (tty_hung_up_p(filp)) {
-		restore_flags(flags);
+		local_irq_restore(flags);
 		return;
 	}
 
@@ -4326,7 +4190,7 @@
 		info->count = 0;
 	}
 	if (info->count) {
-		restore_flags(flags);
+		local_irq_restore(flags);
 		return;
 	}
 	info->flags |= ASYNC_CLOSING;
@@ -4380,7 +4244,7 @@
 	}
 	info->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
 	wake_up_interruptible(&info->close_wait);
-	restore_flags(flags);
+	local_irq_restore(flags);
 
 	/* port closed */
 
@@ -4402,6 +4266,28 @@
 #endif
 	}
 #endif
+
+	/*
+	 * Release any allocated DMA irq's.
+	 */
+	if (info->dma_in_enabled) {
+		cris_free_dma(info->dma_in_nbr, info->dma_in_irq_description);
+		free_irq(info->dma_in_irq_nbr,
+			 info);
+		info->uses_dma_in = 0;
+#ifdef SERIAL_DEBUG_OPEN
+		printk("DMA irq '%s' freed\n", info->dma_in_irq_description);
+#endif
+	}
+	if (info->dma_out_enabled) {
+		free_irq(info->dma_out_irq_nbr,
+			 info);
+		cris_free_dma(info->dma_out_nbr, info->dma_out_irq_description);
+		info->uses_dma_out = 0;
+#ifdef SERIAL_DEBUG_OPEN
+		printk("DMA irq '%s' freed\n", info->dma_out_irq_description);
+#endif
+	}
 }
 
 /*
@@ -4477,7 +4363,7 @@
 	if (tty_hung_up_p(filp) ||
 	    (info->flags & ASYNC_CLOSING)) {
 		if (info->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->close_wait);
+			wait_event_interruptible(info->close_wait, 0);
 #ifdef SERIAL_DO_RESTART
 		if (info->flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
@@ -4515,21 +4401,19 @@
 	printk("block_til_ready before block: ttyS%d, count = %d\n",
 	       info->line, info->count);
 #endif
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 	if (!tty_hung_up_p(filp)) {
 		extra_count++;
 		info->count--;
 	}
-	restore_flags(flags);
+	local_irq_restore(flags);
 	info->blocked_open++;
 	while (1) {
-		save_flags(flags);
-		cli();
+		local_irq_save(flags);
 		/* assert RTS and DTR */
 		e100_rts(info, 1);
 		e100_dtr(info, 1);
-		restore_flags(flags);
+		local_irq_restore(flags);
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
 		    !(info->flags & ASYNC_INITIALIZED)) {
@@ -4581,9 +4465,9 @@
 	struct e100_serial	*info;
 	int 			retval, line;
 	unsigned long           page;
+	int                     allocated_resources = 0;
 
 	/* find which port we want to open */
-
 	line = tty->index;
 
 	if (line < 0 || line >= NR_PORTS)
@@ -4624,7 +4508,7 @@
 	if (tty_hung_up_p(filp) ||
 	    (info->flags & ASYNC_CLOSING)) {
 		if (info->flags & ASYNC_CLOSING)
-			interruptible_sleep_on(&info->close_wait);
+			wait_event_interruptible(info->close_wait, 0);
 #ifdef SERIAL_DO_RESTART
 		return ((info->flags & ASYNC_HUP_NOTIFY) ?
 			-EAGAIN : -ERESTARTSYS);
@@ -4634,19 +4518,99 @@
 	}
 
 	/*
+	 * If DMA is enabled try to allocate the irq's.
+	 */
+	if (info->count == 1) {
+		allocated_resources = 1;
+		if (info->dma_in_enabled) {
+			if (request_irq(info->dma_in_irq_nbr,
+					rec_interrupt,
+					info->dma_in_irq_flags,
+					info->dma_in_irq_description,
+					info)) {
+				printk(KERN_WARNING "DMA irq '%s' busy; falling back to non-DMA mode\n", info->dma_in_irq_description);
+				/* Make sure we never try to use DMA in for the port again. */
+				info->dma_in_enabled = 0;
+			} else if (cris_request_dma(info->dma_in_nbr,
+						    info->dma_in_irq_description,
+						    DMA_VERBOSE_ON_ERROR,
+						    info->dma_owner)) {
+				free_irq(info->dma_in_irq_nbr, info);
+				printk(KERN_WARNING "DMA '%s' busy; falling back to non-DMA mode\n", info->dma_in_irq_description);
+				/* Make sure we never try to use DMA in for the port again. */
+				info->dma_in_enabled = 0;
+			}
+#ifdef SERIAL_DEBUG_OPEN
+			else printk("DMA irq '%s' allocated\n", info->dma_in_irq_description);
+#endif
+		}
+		if (info->dma_out_enabled) {
+			if (request_irq(info->dma_out_irq_nbr,
+					       tr_interrupt,
+					       info->dma_out_irq_flags,
+					       info->dma_out_irq_description,
+					       info)) {
+				printk(KERN_WARNING "DMA irq '%s' busy; falling back to non-DMA mode\n", info->dma_out_irq_description);
+				/* Make sure we never try to use DMA out for the port again. */
+				info->dma_out_enabled = 0;
+			} else if (cris_request_dma(info->dma_out_nbr,
+					     info->dma_out_irq_description,
+					     DMA_VERBOSE_ON_ERROR,
+					     info->dma_owner)) {
+				free_irq(info->dma_out_irq_nbr, info);
+				printk(KERN_WARNING "DMA '%s' busy; falling back to non-DMA mode\n", info->dma_out_irq_description);
+				/* Make sure we never try to use DMA in for the port again. */
+				info->dma_out_enabled = 0;
+			}
+#ifdef SERIAL_DEBUG_OPEN
+			else printk("DMA irq '%s' allocated\n", info->dma_out_irq_description);
+#endif
+		}
+	}
+
+	/*
 	 * Start up the serial port
 	 */
 
 	retval = startup(info);
-	if (retval)
+	if (retval) {
+		if (allocated_resources) {
+			if (info->dma_out_enabled) {
+				cris_free_dma(info->dma_out_nbr, info->dma_out_irq_description);
+				free_irq(info->dma_out_irq_nbr,
+					 info);
+			}
+			if (info->dma_in_enabled) {
+				cris_free_dma(info->dma_in_nbr, info->dma_in_irq_description);
+				free_irq(info->dma_in_irq_nbr,
+					 info);
+			}
+		}
+		/* FIXME Decrease count info->count here too? */
 		return retval;
 
+	}
+
+
 	retval = block_til_ready(tty, filp, info);
 	if (retval) {
 #ifdef SERIAL_DEBUG_OPEN
 		printk("rs_open returning after block_til_ready with %d\n",
 		       retval);
 #endif
+		if (allocated_resources) {
+			if (info->dma_out_enabled) {
+				cris_free_dma(info->dma_out_nbr, info->dma_out_irq_description);
+				free_irq(info->dma_out_irq_nbr,
+					 info);
+			}
+			if (info->dma_in_enabled) {
+				cris_free_dma(info->dma_in_nbr, info->dma_in_irq_description);
+				free_irq(info->dma_in_irq_nbr,
+					 info);
+			}
+		}
+		
 		return retval;
 	}
 
@@ -4836,6 +4800,8 @@
 	.send_xchar = rs_send_xchar,
 	.wait_until_sent = rs_wait_until_sent,
 	.read_proc = rs_read_proc,
+	.tiocmget = rs_tiocmget,
+	.tiocmset = rs_tiocmset
 };
 
 static int __init
@@ -4855,7 +4821,22 @@
 #if !defined(CONFIG_ETRAX_SERIAL_FAST_TIMER)
 	init_timer(&flush_timer);
 	flush_timer.function = timed_flush_handler;
-	mod_timer(&flush_timer, jiffies + CONFIG_ETRAX_SERIAL_RX_TIMEOUT_TICKS);
+	mod_timer(&flush_timer, jiffies + 5);
+#endif
+
+#if defined(CONFIG_ETRAX_RS485)
+#if defined(CONFIG_ETRAX_RS485_ON_PA)
+	if (cris_io_interface_allocate_pins(if_ser0, 'a', rs485_pa_bit, rs485_pa_bit)) {
+ 		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate RS485 pin\n");
+		return -EBUSY;
+	}
+#endif
+#if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
+	if (cris_io_interface_allocate_pins(if_ser0, 'g', rs485_pa_bit, rs485_port_g_bit)) {
+ 		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate RS485 pin\n");
+		return -EBUSY;
+	}
+#endif
 #endif
 
 	/* Initialize the tty_driver structure */
@@ -4882,6 +4863,14 @@
 	/* do some initializing for the separate ports */
 
 	for (i = 0, info = rs_table; i < NR_PORTS; i++,info++) {
+		if (info->enabled) {
+			if (cris_request_io_interface(info->io_if, info->io_if_description)) {
+				printk(KERN_CRIT "ETRAX100LX async serial: Could not allocate IO pins for %s, port %d\n",
+				       info->io_if_description,
+				       i);
+				info->enabled = 0;
+			}
+		}
 		info->uses_dma_in = 0;
 		info->uses_dma_out = 0;
 		info->line = i;
@@ -4915,7 +4904,7 @@
 		info->rs485.delay_rts_before_send = 0;
 		info->rs485.enabled = 0;
 #endif
-		INIT_WORK(&info->work, do_softint, info);
+		INIT_WORK(&info->work, do_softint);
 
 		if (info->enabled) {
 			printk(KERN_INFO "%s%d at 0x%x is a builtin UART with DMA\n",
@@ -4933,64 +4922,16 @@
 #endif
 
 #ifndef CONFIG_SVINTO_SIM
+#ifndef CONFIG_ETRAX_KGDB
 	/* Not needed in simulator.  May only complicate stuff. */
 	/* hook the irq's for DMA channel 6 and 7, serial output and input, and some more... */
 
-	if (request_irq(SERIAL_IRQ_NBR, ser_interrupt, IRQF_SHARED | IRQF_DISABLED, "serial ", NULL))
-		panic("irq8");
-
-#ifdef CONFIG_ETRAX_SERIAL_PORT0
-#ifdef CONFIG_ETRAX_SERIAL_PORT0_DMA6_OUT
-	if (request_irq(SER0_DMA_TX_IRQ_NBR, tr_interrupt, IRQF_DISABLED, "serial 0 dma tr", NULL))
-		panic("irq22");
-#endif
-#ifdef CONFIG_ETRAX_SERIAL_PORT0_DMA7_IN
-	if (request_irq(SER0_DMA_RX_IRQ_NBR, rec_interrupt, IRQF_DISABLED, "serial 0 dma rec", NULL))
-		panic("irq23");
-#endif
-#endif
-
-#ifdef CONFIG_ETRAX_SERIAL_PORT1
-#ifdef CONFIG_ETRAX_SERIAL_PORT1_DMA8_OUT
-	if (request_irq(SER1_DMA_TX_IRQ_NBR, tr_interrupt, IRQF_DISABLED, "serial 1 dma tr", NULL))
-		panic("irq24");
-#endif
-#ifdef CONFIG_ETRAX_SERIAL_PORT1_DMA9_IN
-	if (request_irq(SER1_DMA_RX_IRQ_NBR, rec_interrupt, IRQF_DISABLED, "serial 1 dma rec", NULL))
-		panic("irq25");
-#endif
-#endif
-#ifdef CONFIG_ETRAX_SERIAL_PORT2
-	/* DMA Shared with par0 (and SCSI0 and ATA) */
-#ifdef CONFIG_ETRAX_SERIAL_PORT2_DMA2_OUT
-	if (request_irq(SER2_DMA_TX_IRQ_NBR, tr_interrupt, IRQF_SHARED | IRQF_DISABLED, "serial 2 dma tr", NULL))
-		panic("irq18");
-#endif
-#ifdef CONFIG_ETRAX_SERIAL_PORT2_DMA3_IN
-	if (request_irq(SER2_DMA_RX_IRQ_NBR, rec_interrupt, IRQF_SHARED | IRQF_DISABLED, "serial 2 dma rec", NULL))
-		panic("irq19");
-#endif
-#endif
-#ifdef CONFIG_ETRAX_SERIAL_PORT3
-	/* DMA Shared with par1 (and SCSI1 and Extern DMA 0) */
-#ifdef CONFIG_ETRAX_SERIAL_PORT3_DMA4_OUT
-	if (request_irq(SER3_DMA_TX_IRQ_NBR, tr_interrupt, IRQF_SHARED | IRQF_DISABLED, "serial 3 dma tr", NULL))
-		panic("irq20");
-#endif
-#ifdef CONFIG_ETRAX_SERIAL_PORT3_DMA5_IN
-	if (request_irq(SER3_DMA_RX_IRQ_NBR, rec_interrupt, IRQF_SHARED | IRQF_DISABLED, "serial 3 dma rec", NULL))
-		panic("irq21");
-#endif
-#endif
+	if (request_irq(SERIAL_IRQ_NBR, ser_interrupt, IRQF_SHARED | IRQF_DISABLED, "serial ", driver))
+		panic("%s: Failed to request irq8", __FUNCTION__);
 
-#ifdef CONFIG_ETRAX_SERIAL_FLUSH_DMA_FAST
-	if (request_irq(TIMER1_IRQ_NBR, timeout_interrupt, IRQF_SHARED | IRQF_DISABLED,
-		       "fast serial dma timeout", NULL)) {
-		printk(KERN_CRIT "err: timer1 irq\n");
-	}
 #endif
 #endif /* CONFIG_SVINTO_SIM */
-	debug_write_function = rs_debug_write_function;
+
 	return 0;
 }
 
--- /dev/null	2007-10-06 06:38:38.348072750 +0200
+++ linux-2.6.23-mod/drivers/serial/crisv10.h	2007-10-26 14:14:00.000000000 +0200
@@ -0,0 +1,151 @@
+/*
+ * serial.h: Arch-dep definitions for the Etrax100 serial driver.
+ *
+ * Copyright (C) 1998-2007 Axis Communications AB
+ */
+
+#ifndef _ETRAX_SERIAL_H
+#define _ETRAX_SERIAL_H
+
+#include <linux/circ_buf.h>
+#include <asm/termios.h>
+#include <asm/dma.h>
+#include <asm/arch/io_interface_mux.h>
+
+/* Software state per channel */
+
+#ifdef __KERNEL__
+/*
+ * This is our internal structure for each serial port's state.
+ *
+ * Many fields are paralleled by the structure used by the serial_struct
+ * structure.
+ *
+ * For definitions of the flags field, see tty.h
+ */
+
+#define SERIAL_RECV_DESCRIPTORS 8
+
+struct etrax_recv_buffer {
+	struct etrax_recv_buffer *next;
+	unsigned short length;
+	unsigned char error;
+	unsigned char pad;
+
+	unsigned char buffer[0];
+};
+
+struct e100_serial {
+	int			baud;
+	volatile u8		*port; /* R_SERIALx_CTRL */
+	u32			irq;  /* bitnr in R_IRQ_MASK2 for dmaX_descr */
+
+	/* Output registers */
+	volatile u8		*oclrintradr; /* adr to R_DMA_CHx_CLR_INTR */
+	volatile u32		*ofirstadr;   /* adr to R_DMA_CHx_FIRST */
+	volatile u8		*ocmdadr;     /* adr to R_DMA_CHx_CMD */
+	const volatile u8	*ostatusadr;  /* adr to R_DMA_CHx_STATUS */
+
+	/* Input registers */
+	volatile u8		*iclrintradr; /* adr to R_DMA_CHx_CLR_INTR */
+	volatile u32		*ifirstadr;   /* adr to R_DMA_CHx_FIRST */
+	volatile u8		*icmdadr;     /* adr to R_DMA_CHx_CMD */
+	volatile u32		*idescradr;   /* adr to R_DMA_CHx_DESCR */
+
+	int			flags;	/* defined in tty.h */
+
+	u8			rx_ctrl; /* shadow for R_SERIALx_REC_CTRL */
+	u8			tx_ctrl; /* shadow for R_SERIALx_TR_CTRL */
+	u8			iseteop; /* bit number for R_SET_EOP for the input dma */
+	int			enabled; /* Set to 1 if the port is enabled in HW config */
+
+	u8		dma_out_enabled:1; /* Set to 1 if DMA should be used */
+	u8		dma_in_enabled:1;  /* Set to 1 if DMA should be used */
+
+	/* end of fields defined in rs_table[] in .c-file */
+	int		dma_owner;
+	unsigned int	dma_in_nbr;
+	unsigned int	dma_out_nbr;
+	unsigned int	dma_in_irq_nbr;
+	unsigned int	dma_out_irq_nbr;
+	unsigned long	dma_in_irq_flags;
+	unsigned long	dma_out_irq_flags;
+	char		*dma_in_irq_description;
+	char		*dma_out_irq_description;
+
+	enum cris_io_interface io_if;
+	char            *io_if_description;
+
+	u8		uses_dma_in;  /* Set to 1 if DMA is used */
+	u8		uses_dma_out; /* Set to 1 if DMA is used */
+	u8		forced_eop;   /* a fifo eop has been forced */
+	int			baud_base;     /* For special baudrates */
+	int			custom_divisor; /* For special baudrates */
+	struct etrax_dma_descr	tr_descr;
+	struct etrax_dma_descr	rec_descr[SERIAL_RECV_DESCRIPTORS];
+	int			cur_rec_descr;
+
+	volatile int		tr_running; /* 1 if output is running */
+
+	struct tty_struct	*tty;
+	int			read_status_mask;
+	int			ignore_status_mask;
+	int			x_char;	/* xon/xoff character */
+	int			close_delay;
+	unsigned short		closing_wait;
+	unsigned short		closing_wait2;
+	unsigned long		event;
+	unsigned long		last_active;
+	int			line;
+	int			type;  /* PORT_ETRAX */
+	int			count;	    /* # of fd on device */
+	int			blocked_open; /* # of blocked opens */
+	struct circ_buf		xmit;
+	struct etrax_recv_buffer *first_recv_buffer;
+	struct etrax_recv_buffer *last_recv_buffer;
+	unsigned int		recv_cnt;
+	unsigned int		max_recv_cnt;
+
+	struct work_struct	work;
+	struct async_icount	icount;   /* error-statistics etc.*/
+	struct ktermios		normal_termios;
+	struct ktermios		callout_termios;
+#ifdef DECLARE_WAITQUEUE
+	wait_queue_head_t	open_wait;
+	wait_queue_head_t	close_wait;
+#else
+	struct wait_queue	*open_wait;
+	struct wait_queue	*close_wait;
+#endif
+
+	unsigned long		char_time_usec;       /* The time for 1 char, in usecs */
+	unsigned long		flush_time_usec;      /* How often we should flush */
+	unsigned long		last_tx_active_usec;  /* Last tx usec in the jiffies */
+	unsigned long		last_tx_active;       /* Last tx time in jiffies */
+	unsigned long		last_rx_active_usec;  /* Last rx usec in the jiffies */
+	unsigned long		last_rx_active;       /* Last rx time in jiffies */
+
+	int			break_detected_cnt;
+	int			errorcode;
+
+#ifdef CONFIG_ETRAX_RS485
+	struct rs485_control	rs485;  /* RS-485 support */
+#endif
+};
+
+/* this PORT is not in the standard serial.h. it's not actually used for
+ * anything since we only have one type of async serial-port anyway in this
+ * system.
+ */
+
+#define PORT_ETRAX 1
+
+/*
+ * Events are used to schedule things to happen at timer-interrupt
+ * time, instead of at rs interrupt time.
+ */
+#define RS_EVENT_WRITE_WAKEUP	0
+
+#endif /* __KERNEL__ */
+
+#endif /* !_ETRAX_SERIAL_H */

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
