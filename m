Return-Path: <linux-kernel-owner+w=401wt.eu-S1763690AbXKIXji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763690AbXKIXji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbXKIXj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:39:29 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57158 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbXKIXj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:39:28 -0500
Message-id: <987255352099662.slaby@pripojeni.net>
Subject: [PATCH 1/6] Char: esp, remove hangup and wakeup bottomhalves
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 9 Nov 2007 18:39:28 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

esp, remove hangup and wakeup bottomhalves

There is no need to schedule a bottomhalf for either of them. One is fast
and the another schedules a bottomhalf itself.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
commit ee7ef7fcd70a75d11d05429e5ac7ac31aca381b1
tree d484eff41e6c6dde9835a48f91df59239b211f8d
parent da1c9104ea38d0ca6e5ce0ee9be8cb6adff0ee71
author Jiri Slaby <jirislaby@gmail.com> Mon, 05 Nov 2007 16:13:09 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:41:51 +0100

 drivers/char/esp.c       |   58 ++++------------------------------------------
 include/linux/hayesesp.h |    4 ---
 2 files changed, 5 insertions(+), 57 deletions(-)

diff --git a/drivers/char/esp.c b/drivers/char/esp.c
index b5df2dc..c01e26d 100644
--- a/drivers/char/esp.c
+++ b/drivers/char/esp.c
@@ -242,17 +242,6 @@ static void rs_start(struct tty_struct *tty)
  * -----------------------------------------------------------------------
  */
 
-/*
- * This routine is used by the interrupt handler to schedule
- * processing in the software interrupt portion of the driver.
- */
-static inline void rs_sched_event(struct esp_struct *info,
-				  int event)
-{
-	info->event |= 1 << event;
-	schedule_work(&info->tqueue);
-}
-
 static DEFINE_SPINLOCK(pio_lock);
 
 static inline struct esp_pio_buffer *get_pio_buffer(void)
@@ -474,7 +463,8 @@ static inline void transmit_chars_pio(struct esp_struct *info,
 	}
 
 	if (info->xmit_cnt < WAKEUP_CHARS) {
-		rs_sched_event(info, ESP_EVENT_WRITE_WAKEUP);
+		if (info->tty)
+			tty_wakeup(info->tty);
 
 #ifdef SERIAL_DEBUG_INTR
 		printk("THRE...");
@@ -512,7 +502,8 @@ static inline void transmit_chars_dma(struct esp_struct *info, int num_bytes)
 	info->xmit_tail = (info->xmit_tail + dma_bytes) & (ESP_XMIT_SIZE - 1);
 
 	if (info->xmit_cnt < WAKEUP_CHARS) {
-		rs_sched_event(info, ESP_EVENT_WRITE_WAKEUP);
+		if (info->tty)
+			tty_wakeup(info->tty);
 
 #ifdef SERIAL_DEBUG_INTR
 		printk("THRE...");
@@ -604,7 +595,7 @@ static inline void check_modem_status(struct esp_struct *info)
 #ifdef SERIAL_DEBUG_OPEN
 			printk("scheduling hangup...");
 #endif
-			schedule_work(&info->tqueue_hangup);
+			tty_hangup(info->tty);
 		}
 	}
 }
@@ -720,41 +711,6 @@ static irqreturn_t rs_interrupt_single(int irq, void *dev_id)
  * -------------------------------------------------------------------
  */
 
-static void do_softint(struct work_struct *work)
-{
-	struct esp_struct	*info =
-		container_of(work, struct esp_struct, tqueue);
-	struct tty_struct	*tty;
-	
-	tty = info->tty;
-	if (!tty)
-		return;
-
-	if (test_and_clear_bit(ESP_EVENT_WRITE_WAKEUP, &info->event)) {
-		tty_wakeup(tty);
-	}
-}
-
-/*
- * This routine is called from the scheduler tqueue when the interrupt
- * routine has signalled that a hangup has occurred.  The path of
- * hangup processing is:
- *
- * 	serial interrupt routine -> (scheduler tqueue) ->
- * 	do_serial_hangup() -> tty->hangup() -> esp_hangup()
- * 
- */
-static void do_serial_hangup(struct work_struct *work)
-{
-	struct esp_struct	*info =
-		container_of(work, struct esp_struct, tqueue_hangup);
-	struct tty_struct	*tty;
-	
-	tty = info->tty;
-	if (tty)
-		tty_hangup(tty);
-}
-
 /*
  * ---------------------------------------------------------------
  * Low level utility subroutines for the serial driver:  routines to
@@ -2038,7 +1994,6 @@ static void rs_close(struct tty_struct *tty, struct file * filp)
 		tty->driver->flush_buffer(tty);
 	tty_ldisc_flush(tty);
 	tty->closing = 0;
-	info->event = 0;
 	info->tty = NULL;
 
 	if (info->blocked_open) {
@@ -2106,7 +2061,6 @@ static void esp_hangup(struct tty_struct *tty)
 	
 	rs_flush_buffer(tty);
 	shutdown(info);
-	info->event = 0;
 	info->count = 0;
 	info->flags &= ~ASYNC_NORMAL_ACTIVE;
 	info->tty = NULL;
@@ -2492,8 +2446,6 @@ static int __init espserial_init(void)
 		info->magic = ESP_MAGIC;
 		info->close_delay = 5*HZ/10;
 		info->closing_wait = 30*HZ;
-		INIT_WORK(&info->tqueue, do_softint);
-		INIT_WORK(&info->tqueue_hangup, do_serial_hangup);
 		info->config.rx_timeout = rx_timeout;
 		info->config.flow_on = flow_on;
 		info->config.flow_off = flow_off;
diff --git a/include/linux/hayesesp.h b/include/linux/hayesesp.h
index b436be7..2177ee5 100644
--- a/include/linux/hayesesp.h
+++ b/include/linux/hayesesp.h
@@ -71,7 +71,6 @@ struct hayes_esp_config {
 #define ESP_STAT_NEVER_DMA      0x08
 #define ESP_STAT_USE_PIO        0x10
 
-#define ESP_EVENT_WRITE_WAKEUP	0
 #define ESP_MAGIC		0x53ee
 #define ESP_XMIT_SIZE		4096
 
@@ -92,7 +91,6 @@ struct esp_struct {
 	unsigned short		closing_wait2;
 	int			IER; 	/* Interrupt Enable Register */
 	int			MCR; 	/* Modem control register */
-	unsigned long		event;
 	unsigned long		last_active;
 	int			line;
 	int			count;	    /* # of fd on device */
@@ -101,8 +99,6 @@ struct esp_struct {
 	int			xmit_head;
 	int			xmit_tail;
 	int			xmit_cnt;
-	struct work_struct	tqueue;
-	struct work_struct	tqueue_hangup;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
 	wait_queue_head_t	delta_msr_wait;
