Return-Path: <linux-kernel-owner+w=401wt.eu-S1764136AbXKIXnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764136AbXKIXnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761785AbXKIXmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:42:52 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57191 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462AbXKIXmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:42:50 -0500
Message-id: <3245615502121108570.slaby@pripojeni.net>
In-reply-to: <987255352099662.slaby@pripojeni.net>
Subject: [PATCH 6/6] Char: riscom8, remove wakeup anf hangup bottomhalves
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 9 Nov 2007 18:42:50 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

riscom8, remove wakeup anf hangup bottomhalves

Both of them may be called directly from the code, don't add special code
and variables and schedule a work for them.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
commit 9d50b0aba24ca0b601820663939987990db134c6
tree 46524b3fe1a7a7d4b7d414bf3c4984b61875e64e
parent 961f0508a584436d4e41ddf5ccf47ab4a7b6a3de
author Jiri Slaby <jirislaby@gmail.com> Mon, 05 Nov 2007 16:40:16 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 22:48:42 +0100

 drivers/char/riscom8.c |   51 ++++--------------------------------------------
 drivers/char/riscom8.h |    3 ---
 2 files changed, 4 insertions(+), 50 deletions(-)

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 9b19abf..8fc4fe4 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -78,8 +78,6 @@
 	 ASYNC_SPD_HI       | ASYNC_SPEED_VHI    | ASYNC_SESSION_LOCKOUT | \
 	 ASYNC_PGRP_LOCKOUT | ASYNC_CALLOUT_NOHUP)
 
-#define RS_EVENT_WRITE_WAKEUP	0
-
 static struct tty_driver *riscom_driver;
 
 static DEFINE_SPINLOCK(riscom_lock);
@@ -314,12 +312,6 @@ out_release:
  * 
  */
 
-static inline void rc_mark_event(struct riscom_port * port, int event)
-{
-	set_bit(event, &port->event);
-	schedule_work(&port->tqueue);
-}
-
 static inline struct riscom_port * rc_get_port(struct riscom_board const * bp,
 					       unsigned char const * what)
 {
@@ -486,7 +478,7 @@ static inline void rc_transmit(struct riscom_board const * bp)
 		rc_out(bp, CD180_IER, port->IER);
 	}
 	if (port->xmit_cnt <= port->wakeup_chars)
-		rc_mark_event(port, RS_EVENT_WRITE_WAKEUP);
+		tty_wakeup(tty);
 }
 
 static inline void rc_check_modem(struct riscom_board const * bp)
@@ -505,7 +497,7 @@ static inline void rc_check_modem(struct riscom_board const * bp)
 		if (rc_in(bp, CD180_MSVR) & MSVR_CD) 
 			wake_up_interruptible(&port->open_wait);
 		else
-			schedule_work(&port->tqueue_hangup);
+			tty_hangup(tty);
 	}
 	
 #ifdef RISCOM_BRAIN_DAMAGED_CTS
@@ -514,7 +506,7 @@ static inline void rc_check_modem(struct riscom_board const * bp)
 			tty->hw_stopped = 0;
 			port->IER |= IER_TXRDY;
 			if (port->xmit_cnt <= port->wakeup_chars)
-				rc_mark_event(port, RS_EVENT_WRITE_WAKEUP);
+				tty_wakeup(tty);
 		} else  {
 			tty->hw_stopped = 1;
 			port->IER &= ~IER_TXRDY;
@@ -526,7 +518,7 @@ static inline void rc_check_modem(struct riscom_board const * bp)
 			tty->hw_stopped = 0;
 			port->IER |= IER_TXRDY;
 			if (port->xmit_cnt <= port->wakeup_chars)
-				rc_mark_event(port, RS_EVENT_WRITE_WAKEUP);
+				tty_wakeup(tty);
 		} else  {
 			tty->hw_stopped = 1;
 			port->IER &= ~IER_TXRDY;
@@ -1091,7 +1083,6 @@ static void rc_close(struct tty_struct * tty, struct file * filp)
 	tty_ldisc_flush(tty);
 
 	tty->closing = 0;
-	port->event = 0;
 	port->tty = NULL;
 	if (port->blocked_open) {
 		if (port->close_delay) {
@@ -1526,25 +1517,6 @@ static void rc_start(struct tty_struct * tty)
 	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
-/*
- * This routine is called from the work queue when the interrupt
- * routine has signalled that a hangup has occurred.  The path of
- * hangup processing is:
- *
- * 	serial interrupt routine -> (workqueue) ->
- * 	do_rc_hangup() -> tty->hangup() -> rc_hangup()
- * 
- */
-static void do_rc_hangup(struct work_struct *ugly_api)
-{
-	struct riscom_port	*port = container_of(ugly_api, struct riscom_port, tqueue_hangup);
-	struct tty_struct	*tty;
-	
-	tty = port->tty;
-	if (tty)
-		tty_hangup(tty);	/* FIXME: module removal race still here */
-}
-
 static void rc_hangup(struct tty_struct * tty)
 {
 	struct riscom_port *port = (struct riscom_port *)tty->driver_data;
@@ -1556,7 +1528,6 @@ static void rc_hangup(struct tty_struct * tty)
 	bp = port_Board(port);
 	
 	rc_shutdown_port(bp, port);
-	port->event = 0;
 	port->count = 0;
 	port->flags &= ~ASYNC_NORMAL_ACTIVE;
 	port->tty = NULL;
@@ -1586,18 +1557,6 @@ static void rc_set_termios(struct tty_struct * tty, struct ktermios * old_termio
 	}
 }
 
-static void do_softint(struct work_struct *ugly_api)
-{
-	struct riscom_port	*port = container_of(ugly_api, struct riscom_port, tqueue);
-	struct tty_struct	*tty;
-	
-	if(!(tty = port->tty)) 
-		return;
-
-	if (test_and_clear_bit(RS_EVENT_WRITE_WAKEUP, &port->event))
-		tty_wakeup(tty);
-}
-
 static const struct tty_operations riscom_ops = {
 	.open  = rc_open,
 	.close = rc_close,
@@ -1650,8 +1609,6 @@ static int __init rc_init_drivers(void)
 	memset(rc_port, 0, sizeof(rc_port));
 	for (i = 0; i < RC_NPORT * RC_NBOARD; i++)  {
 		rc_port[i].magic = RISCOM8_MAGIC;
-		INIT_WORK(&rc_port[i].tqueue, do_softint);
-		INIT_WORK(&rc_port[i].tqueue_hangup, do_rc_hangup);
 		rc_port[i].close_delay = 50 * HZ/100;
 		rc_port[i].closing_wait = 3000 * HZ/100;
 		init_waitqueue_head(&rc_port[i].open_wait);
diff --git a/drivers/char/riscom8.h b/drivers/char/riscom8.h
index 9cc1313..cdfdf43 100644
--- a/drivers/char/riscom8.h
+++ b/drivers/char/riscom8.h
@@ -71,7 +71,6 @@ struct riscom_port {
 	struct tty_struct 	* tty;
 	int			count;
 	int			blocked_open;
-	unsigned long		event; /* long req'd for set_bit --RR */
 	int			timeout;
 	int			close_delay;
 	unsigned char 		* xmit_buf;
@@ -81,8 +80,6 @@ struct riscom_port {
 	int			xmit_cnt;
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
-	struct work_struct	tqueue;
-	struct work_struct	tqueue_hangup;
 	short			wakeup_chars;
 	short			break_length;
 	unsigned short		closing_wait;
