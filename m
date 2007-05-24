Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbXEXMVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbXEXMVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbXEXMVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:21:16 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:37988 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755707AbXEXMVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:21:16 -0400
Message-id: <413724674190309006@wsc.cz>
In-reply-to: <21152561019300868@wsc.cz>
Subject: [PATCH 2/3] Char: specialix, remove busy waiting
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Roger Wolff <R.E.Wolff@BitWizard.nl>
Date: Thu, 24 May 2007 14:21:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

specialix, remove busy waiting

use msleep instead, because not in atomic

Cc: Roger Wolff <R.E.Wolff@BitWizard.nl>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit a677db846e7951118d0409956f4197cc01194f99
tree f0b69d293f8c779111a1a7f0cf9cc37cf164a0c6
parent 3f4308a387d98370556455e729787cc47f200757
author Jiri Slaby <jirislaby@gmail.com> Wed, 23 May 2007 16:46:36 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 23 May 2007 16:46:36 +0200

 drivers/char/specialix.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index baf7234..4558556 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -345,18 +345,6 @@ static inline void sx_release_io_range(struct specialix_board * bp)
 }
 
 
-/* Must be called with enabled interrupts */
-/* Ugly. Very ugly. Don't use this for anything else than initialization
-   code */
-static inline void sx_long_delay(unsigned long delay)
-{
-	unsigned long i;
-
-	for (i = jiffies + delay; time_after(i, jiffies); ) ;
-}
-
-
-
 /* Set the IRQ using the RTS lines that run to the PAL on the board.... */
 static int sx_set_irq ( struct specialix_board *bp)
 {
@@ -397,7 +385,7 @@ static int sx_init_CD186x(struct specialix_board  * bp)
 	spin_lock_irqsave(&bp->lock, flags);
 	sx_out_off(bp, CD186x_CCR, CCR_HARDRESET);      /* Reset CD186x chip          */
 	spin_unlock_irqrestore(&bp->lock, flags);
-	sx_long_delay(HZ/20);                      /* Delay 0.05 sec            */
+	msleep(50);					/* Delay 0.05 sec            */
 	spin_lock_irqsave(&bp->lock, flags);
 	sx_out_off(bp, CD186x_GIVR, SX_ID);             /* Set ID for this chip      */
 	sx_out_off(bp, CD186x_GICR, 0);                 /* Clear all bits            */
@@ -533,7 +521,7 @@ static int sx_probe(struct specialix_board *bp)
 		sx_wait_CCR(bp);
 		sx_out(bp, CD186x_CCR, CCR_TXEN);        /* Enable transmitter     */
 		sx_out(bp, CD186x_IER, IER_TXRDY);       /* Enable tx empty intr   */
-		sx_long_delay(HZ/20);
+		msleep(50);
 		irqs = probe_irq_off(irqs);
 
 		dprintk (SX_DEBUG_INIT, "SRSR = %02x, ", sx_in(bp, CD186x_SRSR));
