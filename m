Return-Path: <linux-kernel-owner+w=401wt.eu-S1763975AbXKIXmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763975AbXKIXmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbXKIXmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:42:12 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57184 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbXKIXmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:42:10 -0500
Message-id: <24107163261430414665.slaby@pripojeni.net>
In-reply-to: <987255352099662.slaby@pripojeni.net>
Subject: [PATCH 5/6] Char: serial167, remove bottomhalf
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 9 Nov 2007 18:42:10 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

serial167, remove bottomhalf

- Cy_EVENT_OPEN_WAKEUP is simple wake_up
- Cy_EVENT_HANGUP is wake_up + tty_hangup, which schedules its own work
- Cy_EVENT_WRITE_WAKEUP is tty_wakeup which may be called directly too

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
commit 961f0508a584436d4e41ddf5ccf47ab4a7b6a3de
tree 056c19b77aae9ca6c77b1d7d314166f4bfb177e9
parent 695ec3fa93346e03d33392504ca99aaaeb4cb5f7
author Jiri Slaby <jirislaby@gmail.com> Mon, 05 Nov 2007 16:34:48 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:45:28 +0100

 drivers/char/serial167.c  |   76 +++++----------------------------------------
 include/linux/serial167.h |   14 --------
 2 files changed, 8 insertions(+), 82 deletions(-)

diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index cbf21cc..df8cd0c 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -357,18 +357,6 @@ static void cy_start(struct tty_struct *tty)
 	local_irq_restore(flags);
 }				/* cy_start */
 
-/*
- * This routine is used by the interrupt handler to schedule
- * processing in the software interrupt portion of the driver
- * (also known as the "bottom half").  This can be called any
- * number of times for any channel without harm.
- */
-static inline void cy_sched_event(struct cyclades_port *info, int event)
-{
-	info->event |= 1 << event;	/* remember what kind of event and who */
-	schedule_work(&info->tqueue);
-}				/* cy_sched_event */
-
 /* The real interrupt service routines are called
    whenever the card wants its hand held--chars
    received, out buffer empty, modem change, etc.
@@ -483,10 +471,12 @@ static irqreturn_t cd2401_modem_interrupt(int irq, void *dev_id)
 		    && (info->flags & ASYNC_CHECK_CD)) {
 			if (mdm_status & CyDCD) {
 /* CP('!'); */
-				cy_sched_event(info, Cy_EVENT_OPEN_WAKEUP);
+				wake_up_interruptible(&info->open_wait);
 			} else {
 /* CP('@'); */
-				cy_sched_event(info, Cy_EVENT_HANGUP);
+				tty_hangup(info->tty);
+				wake_up_interruptible(&info->open_wait);
+				info->flags &= ~ASYNC_NORMAL_ACTIVE;
 			}
 		}
 		if ((mdm_change & CyCTS)
@@ -496,8 +486,7 @@ static irqreturn_t cd2401_modem_interrupt(int irq, void *dev_id)
 					/* !!! cy_start isn't used because... */
 					info->tty->stopped = 0;
 					base_addr[CyIER] |= CyTxMpty;
-					cy_sched_event(info,
-						       Cy_EVENT_WRITE_WAKEUP);
+					tty_wakeup(info->tty);
 				}
 			} else {
 				if (!(mdm_status & CyCTS)) {
@@ -543,9 +532,6 @@ static irqreturn_t cd2401_tx_interrupt(int irq, void *dev_id)
 	info->last_active = jiffies;
 	if (info->tty == 0) {
 		base_addr[CyIER] &= ~(CyTxMpty | CyTxRdy);
-		if (info->xmit_cnt < WAKEUP_CHARS) {
-			cy_sched_event(info, Cy_EVENT_WRITE_WAKEUP);
-		}
 		base_addr[CyTEOIR] = CyNOTRANS;
 		return IRQ_HANDLED;
 	}
@@ -627,9 +613,9 @@ static irqreturn_t cd2401_tx_interrupt(int irq, void *dev_id)
 		}
 	}
 
-	if (info->xmit_cnt < WAKEUP_CHARS) {
-		cy_sched_event(info, Cy_EVENT_WRITE_WAKEUP);
-	}
+	if (info->xmit_cnt < WAKEUP_CHARS)
+		tty_wakeup(info->tty);
+
 	base_addr[CyTEOIR] = (char_count != saved_cnt) ? 0 : CyNOTRANS;
 	return IRQ_HANDLED;
 }				/* cy_tx_interrupt */
@@ -690,49 +676,6 @@ static irqreturn_t cd2401_rx_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }				/* cy_rx_interrupt */
 
-/*
- * This routine is used to handle the "bottom half" processing for the
- * serial driver, known also the "software interrupt" processing.
- * This processing is done at the kernel interrupt level, after the
- * cy#/_interrupt() has returned, BUT WITH INTERRUPTS TURNED ON.  This
- * is where time-consuming activities which can not be done in the
- * interrupt driver proper are done; the interrupt driver schedules
- * them using cy_sched_event(), and they get done here.
- *
- * This is done through one level of indirection--the task queue.
- * When a hardware interrupt service routine wants service by the
- * driver's bottom half, it enqueues the appropriate tq_struct (one
- * per port) to the keventd work queue and sets a request flag
- * that the work queue be processed.
- *
- * Although this may seem unwieldy, it gives the system a way to
- * pass an argument (in this case the pointer to the cyclades_port
- * structure) to the bottom half of the driver.  Previous kernels
- * had to poll every port to see if that port needed servicing.
- */
-static void do_softint(struct work_struct *ugly_api)
-{
-	struct cyclades_port *info =
-	    container_of(ugly_api, struct cyclades_port, tqueue);
-	struct tty_struct *tty;
-
-	tty = info->tty;
-	if (!tty)
-		return;
-
-	if (test_and_clear_bit(Cy_EVENT_HANGUP, &info->event)) {
-		tty_hangup(info->tty);
-		wake_up_interruptible(&info->open_wait);
-		info->flags &= ~ASYNC_NORMAL_ACTIVE;
-	}
-	if (test_and_clear_bit(Cy_EVENT_OPEN_WAKEUP, &info->event)) {
-		wake_up_interruptible(&info->open_wait);
-	}
-	if (test_and_clear_bit(Cy_EVENT_WRITE_WAKEUP, &info->event)) {
-		tty_wakeup(tty);
-	}
-}				/* do_softint */
-
 /* This is called whenever a port becomes active;
    interrupts are enabled and DTR & RTS are turned on.
  */
@@ -1743,7 +1686,6 @@ static void cy_close(struct tty_struct *tty, struct file *filp)
 	if (tty->driver->flush_buffer)
 		tty->driver->flush_buffer(tty);
 	tty_ldisc_flush(tty);
-	info->event = 0;
 	info->tty = NULL;
 	if (info->blocked_open) {
 		if (info->close_delay) {
@@ -2234,7 +2176,6 @@ static int __init serial167_init(void)
 				info->rco = baud_co[DefSpeed] >> 5;	/* Rx CO */
 				info->close_delay = 0;
 				info->x_char = 0;
-				info->event = 0;
 				info->count = 0;
 #ifdef SERIAL_DEBUG_COUNT
 				printk("cyc: %d: setting count to 0\n",
@@ -2243,7 +2184,6 @@ static int __init serial167_init(void)
 				info->blocked_open = 0;
 				info->default_threshold = 0;
 				info->default_timeout = 0;
-				INIT_WORK(&info->tqueue, do_softint);
 				init_waitqueue_head(&info->open_wait);
 				init_waitqueue_head(&info->close_wait);
 				/* info->session */
diff --git a/include/linux/serial167.h b/include/linux/serial167.h
index 71b6df2..59c81b7 100644
--- a/include/linux/serial167.h
+++ b/include/linux/serial167.h
@@ -37,7 +37,6 @@ struct cyclades_port {
 	int			ignore_status_mask;
 	int			close_delay;
 	int			IER; 	/* Interrupt Enable Register */
-	unsigned long		event;
 	unsigned long		last_active;
 	int			count;	/* # of fd on device */
 	int                     x_char; /* to be pushed out ASAP */
@@ -49,7 +48,6 @@ struct cyclades_port {
 	int			xmit_cnt;
         int                     default_threshold;
         int                     default_timeout;
-	struct work_struct	tqueue;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
         struct cyclades_monitor mon;
@@ -67,18 +65,6 @@ struct cyclades_port {
 #define CYGETDEFTIMEOUT         0x435908
 #define CYSETDEFTIMEOUT         0x435909
 
-/*
- * Events are used to schedule things to happen at timer-interrupt
- * time, instead of at cy interrupt time.
- */
-#define Cy_EVENT_READ_PROCESS	0
-#define Cy_EVENT_WRITE_WAKEUP	1
-#define Cy_EVENT_HANGUP		2
-#define Cy_EVENT_BREAK		3
-#define Cy_EVENT_OPEN_WAKEUP	4
-
-
-
 #define CyMaxChipsPerCard 1
 
 /**** cd2401 registers ****/
