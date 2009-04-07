Return-Path: <linux-kernel-owner+w=401wt.eu-S1757615AbZDGOt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbZDGOt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbZDGOtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:49:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34151 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755610AbZDGOtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:49:46 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/11] tty: Use the generic RS485 ioctl on CRIS
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2009 16:48:19 +0100
Message-ID: <20090407154813.18020.87507.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk>
References: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Claudio Scordino <claudio@evidence.eu.com>

Use the new general RS485 Linux data structure (introduced by Alan with
commit number c26c56c0f40e200e61d1390629c806f6adaffbcc) in the Cris
architecture too (currently, Cris still uses the old private data
structure instead of the new one).


Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Tested-by: Hinko Kocevar <hinko.kocevar@cetrtapot.si>
Tested-by: Janez Cufer <janez.cufer@cetrtapot.si>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 arch/cris/include/asm/ioctls.h  |    5 +-
 arch/cris/include/asm/rs485.h   |    8 +---
 arch/cris/include/asm/termios.h |    1 
 drivers/serial/crisv10.c        |   79 +++++++++++++++++++++++++++++----------
 drivers/serial/crisv10.h        |    2 -
 5 files changed, 66 insertions(+), 29 deletions(-)


diff --git a/arch/cris/include/asm/ioctls.h b/arch/cris/include/asm/ioctls.h
index 4f4e525..35bbc18 100644
--- a/arch/cris/include/asm/ioctls.h
+++ b/arch/cris/include/asm/ioctls.h
@@ -74,8 +74,9 @@
 #define TIOCSHAYESESP   0x545F  /* Set Hayes ESP configuration */
 #define FIOQSIZE	0x5460
 
-#define TIOCSERSETRS485 0x5461  /* enable rs-485 */
-#define TIOCSERWRRS485  0x5462  /* write rs-485 */
+#define TIOCSERSETRS485	0x5461  /* enable rs-485 (deprecated) */
+#define TIOCSERWRRS485	0x5462  /* write rs-485 */
+#define TIOCSRS485	0x5463  /* enable rs-485 */
 
 /* Used for packet mode */
 #define TIOCPKT_DATA		 0
diff --git a/arch/cris/include/asm/rs485.h b/arch/cris/include/asm/rs485.h
index c331c51..ad40f9f 100644
--- a/arch/cris/include/asm/rs485.h
+++ b/arch/cris/include/asm/rs485.h
@@ -1,15 +1,13 @@
 /* RS-485 structures */
 
-/* RS-485 support */
-/* Used with ioctl() TIOCSERSETRS485 */
+/* Used with ioctl() TIOCSERSETRS485 for backward compatibility!
+ * XXX: Do not use it for new code!
+ */
 struct rs485_control {
         unsigned short rts_on_send;
         unsigned short rts_after_sent;
         unsigned long delay_rts_before_send;
         unsigned short enabled;
-#ifdef __KERNEL__
-        int disable_serial_loopback;
-#endif
 };
 
 /* Used with ioctl() TIOCSERWRRS485 */
diff --git a/arch/cris/include/asm/termios.h b/arch/cris/include/asm/termios.h
index b0124e6..1265109 100644
--- a/arch/cris/include/asm/termios.h
+++ b/arch/cris/include/asm/termios.h
@@ -4,6 +4,7 @@
 #include <asm/termbits.h>
 #include <asm/ioctls.h>
 #include <asm/rs485.h>
+#include <linux/serial.h>
 
 struct winsize {
 	unsigned short ws_row;
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index e642c22..7ba7d70 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -1391,7 +1391,7 @@ static inline void e100_disable_rx_irq(struct e100_serial *info)
 #if defined(CONFIG_ETRAX_RS485)
 /* Enable RS-485 mode on selected port. This is UGLY. */
 static int
-e100_enable_rs485(struct tty_struct *tty,struct rs485_control *r)
+e100_enable_rs485(struct tty_struct *tty, struct serial_rs485 *r)
 {
 	struct e100_serial * info = (struct e100_serial *)tty->driver_data;
 
@@ -1409,13 +1409,11 @@ e100_enable_rs485(struct tty_struct *tty,struct rs485_control *r)
 		       CONFIG_ETRAX_RS485_LTC1387_RXEN_PORT_G_BIT, 1);
 #endif
 
-	info->rs485.rts_on_send = 0x01 & r->rts_on_send;
-	info->rs485.rts_after_sent = 0x01 & r->rts_after_sent;
+	info->rs485.flags = r->flags;
 	if (r->delay_rts_before_send >= 1000)
 		info->rs485.delay_rts_before_send = 1000;
 	else
 		info->rs485.delay_rts_before_send = r->delay_rts_before_send;
-	info->rs485.enabled = r->enabled;
 /*	printk("rts: on send = %i, after = %i, enabled = %i",
 		    info->rs485.rts_on_send,
 		    info->rs485.rts_after_sent,
@@ -1430,17 +1428,18 @@ e100_write_rs485(struct tty_struct *tty,
                  const unsigned char *buf, int count)
 {
 	struct e100_serial * info = (struct e100_serial *)tty->driver_data;
-	int old_enabled = info->rs485.enabled;
+	int old_value = (info->rs485.flags) & SER_RS485_ENABLED;
 
 	/* rs485 is always implicitly enabled if we're using the ioctl()
-	 * but it doesn't have to be set in the rs485_control
+	 * but it doesn't have to be set in the serial_rs485
 	 * (to be backward compatible with old apps)
 	 * So we store, set and restore it.
 	 */
-	info->rs485.enabled = 1;
+	info->rs485.flags |= SER_RS485_ENABLED;
 	/* rs_write now deals with RS485 if enabled */
 	count = rs_write(tty, buf, count);
-	info->rs485.enabled = old_enabled;
+	if (!old_value)
+		info->rs485.flags &= ~(SER_RS485_ENABLED);
 	return count;
 }
 
@@ -1451,7 +1450,7 @@ static void rs485_toggle_rts_timer_function(unsigned long data)
 	struct e100_serial *info = (struct e100_serial *)data;
 
 	fast_timers_rs485[info->line].function = NULL;
-	e100_rts(info, info->rs485.rts_after_sent);
+	e100_rts(info, (info->rs485.flags & SER_RS485_RTS_AFTER_SEND));
 #if defined(CONFIG_ETRAX_RS485_DISABLE_RECEIVER)
 	e100_enable_rx(info);
 	e100_enable_rx_irq(info);
@@ -1647,7 +1646,7 @@ transmit_chars_dma(struct e100_serial *info)
 		info->tr_running = 0;
 
 #if defined(CONFIG_ETRAX_RS485) && defined(CONFIG_ETRAX_FAST_TIMER)
-		if (info->rs485.enabled) {
+		if (info->rs485.flags & SER_RS485_ENABLED) {
 			/* Set a short timer to toggle RTS */
 			start_one_shot_timer(&fast_timers_rs485[info->line],
 			                     rs485_toggle_rts_timer_function,
@@ -2577,7 +2576,7 @@ static void handle_ser_tx_interrupt(struct e100_serial *info)
 	info->icount.tx++;
 	if (info->xmit.head == info->xmit.tail) {
 #if defined(CONFIG_ETRAX_RS485) && defined(CONFIG_ETRAX_FAST_TIMER)
-		if (info->rs485.enabled) {
+		if (info->rs485.flags & SER_RS485_ENABLED) {
 			/* Set a short timer to toggle RTS */
 			start_one_shot_timer(&fast_timers_rs485[info->line],
 			                     rs485_toggle_rts_timer_function,
@@ -3218,7 +3217,7 @@ rs_write(struct tty_struct *tty,
 #if defined(CONFIG_ETRAX_RS485)
 	struct e100_serial *info = (struct e100_serial *)tty->driver_data;
 
-	if (info->rs485.enabled)
+	if (info->rs485.flags & SER_RS485_ENABLED)
 	{
 		/* If we are in RS-485 mode, we need to toggle RTS and disable
 		 * the receiver before initiating a DMA transfer
@@ -3228,7 +3227,7 @@ rs_write(struct tty_struct *tty,
 		fast_timers_rs485[info->line].function = NULL;
 		del_fast_timer(&fast_timers_rs485[info->line]);
 #endif
-		e100_rts(info, info->rs485.rts_on_send);
+		e100_rts(info, (info->rs485.flags & SER_RS485_RTS_ON_SEND));
 #if defined(CONFIG_ETRAX_RS485_DISABLE_RECEIVER)
 		e100_disable_rx(info);
 		e100_enable_rx_irq(info);
@@ -3242,7 +3241,7 @@ rs_write(struct tty_struct *tty,
 	count = rs_raw_write(tty, buf, count);
 
 #if defined(CONFIG_ETRAX_RS485)
-	if (info->rs485.enabled)
+	if (info->rs485.flags & SER_RS485_ENABLED)
 	{
 		unsigned int val;
 		/* If we are in RS-485 mode the following has to be done:
@@ -3263,7 +3262,7 @@ rs_write(struct tty_struct *tty,
 			get_lsr_info(info, &val);
 		}while (!(val & TIOCSER_TEMT));
 
-		e100_rts(info, info->rs485.rts_after_sent);
+		e100_rts(info, (info->rs485.flags & SER_RS485_RTS_AFTER_SEND));
 
 #if defined(CONFIG_ETRAX_RS485_DISABLE_RECEIVER)
 		e100_enable_rx(info);
@@ -3678,14 +3677,52 @@ rs_ioctl(struct tty_struct *tty, struct file * file,
 #if defined(CONFIG_ETRAX_RS485)
 	case TIOCSERSETRS485:
 	{
+		/* In this ioctl we still use the old structure
+		 * rs485_control for backward compatibility
+		 * (if we use serial_rs485, then old user-level code
+		 * wouldn't work anymore...).
+		 * The use of this ioctl is deprecated: use TIOCSRS485
+		 * instead.*/
 		struct rs485_control rs485ctrl;
+		struct serial_rs485 rs485data;
+		printk(KERN_DEBUG "The use of this ioctl is deprecated. Use TIOCSRS485 instead\n");
 		if (copy_from_user(&rs485ctrl, (struct rs485_control *)arg,
 				sizeof(rs485ctrl)))
 			return -EFAULT;
 
-		return e100_enable_rs485(tty, &rs485ctrl);
+		rs485data.delay_rts_before_send = rs485ctrl.delay_rts_before_send;
+		rs485data.flags = 0;
+		if (rs485ctrl.enabled)
+			rs485data.flags |= SER_RS485_ENABLED;
+		else
+			rs485data.flags &= ~(SER_RS485_ENABLED);
+
+		if (rs485ctrl.rts_on_send)
+			rs485data.flags |= SER_RS485_RTS_ON_SEND;
+		else
+			rs485data.flags &= ~(SER_RS485_RTS_ON_SEND);
+
+		if (rs485ctrl.rts_after_sent)
+			rs485data.flags |= SER_RS485_RTS_AFTER_SEND;
+		else
+			rs485data.flags &= ~(SER_RS485_RTS_AFTER_SEND);
+
+		return e100_enable_rs485(tty, &rs485data);
 	}
 
+	case TIOCSRS485:
+	{
+		/* This is the new version of TIOCSRS485, with new
+		 * data structure serial_rs485 */
+		struct serial_rs485 rs485data;
+		if (copy_from_user(&rs485data, (struct rs485_control *)arg,
+				sizeof(rs485data)))
+			return -EFAULT;
+
+		return e100_enable_rs485(tty, &rs485data);
+	}
+
+
 	case TIOCSERWRRS485:
 	{
 		struct rs485_write rs485wr;
@@ -3827,8 +3864,8 @@ rs_close(struct tty_struct *tty, struct file * filp)
 	/* port closed */
 
 #if defined(CONFIG_ETRAX_RS485)
-	if (info->rs485.enabled) {
-		info->rs485.enabled = 0;
+	if (info->rs485.flags & SER_RS485_ENABLED) {
+		info->rs485.flags &= ~(SER_RS485_ENABLED);
 #if defined(CONFIG_ETRAX_RS485_ON_PA)
 		*R_PORT_PA_DATA = port_pa_data_shadow &= ~(1 << rs485_pa_bit);
 #endif
@@ -4493,10 +4530,10 @@ rs_init(void)
 
 #if defined(CONFIG_ETRAX_RS485)
 		/* Set sane defaults */
-		info->rs485.rts_on_send = 0;
-		info->rs485.rts_after_sent = 1;
+		info->rs485.flags &= ~(SER_RS485_RTS_ON_SEND);
+		info->rs485.flags |= SER_RS485_RTS_AFTER_SEND;
 		info->rs485.delay_rts_before_send = 0;
-		info->rs485.enabled = 0;
+		info->rs485.flags &= ~(SER_RS485_ENABLED);
 #endif
 		INIT_WORK(&info->work, do_softint);
 
diff --git a/drivers/serial/crisv10.h b/drivers/serial/crisv10.h
index f36a729..ea0beb4 100644
--- a/drivers/serial/crisv10.h
+++ b/drivers/serial/crisv10.h
@@ -125,7 +125,7 @@ struct e100_serial {
 	int errorcode;
 
 #ifdef CONFIG_ETRAX_RS485
-	struct rs485_control	rs485;  /* RS-485 support */
+	struct serial_rs485	rs485;  /* RS-485 support */
 #endif
 };
 

