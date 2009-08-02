Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbZHBIvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbZHBIvI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 04:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZHBIvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 04:51:07 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53091 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZHBIvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 04:51:05 -0400
Date: Sun, 2 Aug 2009 10:49:13 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 13/15] drivers/char: Use DIV_ROUND_CLOSEST
Message-ID: <Pine.LNX.4.64.0908021048470.15557@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The kernel.h macro DIV_ROUND_CLOSEST performs the computation (x + d/2)/d
but is perhaps more readable.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@haskernel@
@@

#include <linux/kernel.h>

@depends on haskernel@
expression x,__divisor;
@@

- (((x) + ((__divisor) / 2)) / (__divisor))
+ DIV_ROUND_CLOSEST(x,__divisor)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/mmtimer.c |    5 +++--
 drivers/char/riscom8.c |   12 ++++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index 918711a..e33acb8 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -788,8 +788,9 @@ static int __init mmtimer_init(void)
 		goto out1;
 	}
 
-	mmtimer_femtoperiod = ((unsigned long)1E15 + sn_rtc_cycles_per_second /
-			       2) / sn_rtc_cycles_per_second;
+	mmtimer_femtoperiod =
+		DIV_ROUND_CLOSEST((unsigned long)1E15,
+				  sn_rtc_cycles_per_second);
 
 	if (request_irq(SGI_MMTIMER_VECTOR, mmtimer_interrupt, IRQF_PERCPU, MMTIMER_NAME, NULL)) {
 		printk(KERN_WARNING "%s: unable to allocate interrupt.",
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 171711a..7f1bb27 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -665,8 +665,8 @@ static void rc_change_speed(struct riscom_board *bp, struct riscom_port *port)
 	 */
 
 	/* Set baud rate for port */
-	tmp = (((RC_OSCFREQ + baud/2) / baud +
-		CD180_TPC/2) / CD180_TPC);
+	tmp = DIV_ROUND_CLOSEST(DIV_ROUND_CLOSEST(RC_OSCFREQ, baud),
+				CD180_TPC);
 
 	rc_out(bp, CD180_RBPRH, (tmp >> 8) & 0xff);
 	rc_out(bp, CD180_TBPRH, (tmp >> 8) & 0xff);
@@ -676,12 +676,12 @@ static void rc_change_speed(struct riscom_board *bp, struct riscom_port *port)
 	baud = (baud + 5) / 10;   /* Estimated CPS */
 
 	/* Two timer ticks seems enough to wakeup something like SLIP driver */
-	tmp = ((baud + HZ/2) / HZ) * 2 - CD180_NFIFO;
+	tmp = DIV_ROUND_CLOSEST(baud, HZ) * 2 - CD180_NFIFO;
 	port->wakeup_chars = (tmp < 0) ? 0 : ((tmp >= SERIAL_XMIT_SIZE) ?
 					      SERIAL_XMIT_SIZE - 1 : tmp);
 
 	/* Receiver timeout will be transmission time for 1.5 chars */
-	tmp = (RISCOM_TPS + RISCOM_TPS/2 + baud/2) / baud;
+	tmp = DIV_ROUND_CLOSEST(RISCOM_TPS + RISCOM_TPS / 2, baud);
 	tmp = (tmp > 0xff) ? 0xff : tmp;
 	rc_out(bp, CD180_RTPR, tmp);
 
@@ -1184,7 +1184,7 @@ static int rc_set_serial_info(struct riscom_port *port,
 	if ((tmp.irq != bp->irq) ||
 	    (tmp.port != bp->base) ||
 	    (tmp.type != PORT_CIRRUS) ||
-	    (tmp.baud_base != (RC_OSCFREQ + CD180_TPC/2) / CD180_TPC) ||
+	    (tmp.baud_base != DIV_ROUND_CLOSEST(RC_OSCFREQ, CD180_TPC)) ||
 	    (tmp.custom_divisor != 0) ||
 	    (tmp.xmit_fifo_size != CD180_NFIFO) ||
 	    (tmp.flags & ~RISCOM_LEGAL_FLAGS))
@@ -1230,7 +1230,7 @@ static int rc_get_serial_info(struct riscom_port *port,
 	tmp.port = bp->base;
 	tmp.irq  = bp->irq;
 	tmp.flags = port->port.flags;
-	tmp.baud_base = (RC_OSCFREQ + CD180_TPC/2) / CD180_TPC;
+	tmp.baud_base = DIV_ROUND_CLOSEST(RC_OSCFREQ, CD180_TPC);
 	tmp.close_delay = port->port.close_delay * HZ/100;
 	tmp.closing_wait = port->port.closing_wait * HZ/100;
 	tmp.xmit_fifo_size = CD180_NFIFO;
