Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbXEXMWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbXEXMWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 08:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbXEXMV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 08:21:57 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:37995 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756270AbXEXMV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 08:21:56 -0400
Message-id: <14679305782221614362@wsc.cz>
In-reply-to: <21152561019300868@wsc.cz>
Subject: [PATCH 3/3] Char: riscom8, eliminate busy loop
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Thu, 24 May 2007 14:21:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

riscom8, eliminate busy loop

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 221eebee5eedfa7c2463dcbfb545b92595512310
tree ea667b3ef038cff3a0e86266d37d364766a17303
parent a677db846e7951118d0409956f4197cc01194f99
author Jiri Slaby <jirislaby@gmail.com> Wed, 23 May 2007 17:30:19 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 23 May 2007 17:30:19 +0200

 drivers/char/riscom8.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 3494e3f..8ea231f 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -213,14 +213,6 @@ static inline void rc_release_io_range(struct riscom_board * const bp)
 		release_region(RC_TO_ISA(rc_ioport[i]) + bp->base, 1);
 }
 	
-/* Must be called with enabled interrupts */
-static inline void rc_long_delay(unsigned long delay)
-{
-	unsigned long i;
-	
-	for (i = jiffies + delay; time_after(i,jiffies); ) ;
-}
-
 /* Reset and setup CD180 chip */
 static void __init rc_init_CD180(struct riscom_board const * bp)
 {
@@ -231,7 +223,7 @@ static void __init rc_init_CD180(struct riscom_board const * bp)
 	rc_wait_CCR(bp);			   /* Wait for CCR ready        */
 	rc_out(bp, CD180_CCR, CCR_HARDRESET);      /* Reset CD180 chip          */
 	sti();
-	rc_long_delay(HZ/20);                      /* Delay 0.05 sec            */
+	msleep(50);				   /* Delay 0.05 sec            */
 	cli();
 	rc_out(bp, CD180_GIVR, RC_ID);             /* Set ID for this chip      */
 	rc_out(bp, CD180_GICR, 0);                 /* Clear all bits            */
@@ -280,7 +272,7 @@ static int __init rc_probe(struct riscom_board *bp)
 		rc_wait_CCR(bp);
 		rc_out(bp, CD180_CCR, CCR_TXEN);        /* Enable transmitter     */
 		rc_out(bp, CD180_IER, IER_TXRDY);       /* Enable tx empty intr   */
-		rc_long_delay(HZ/20);	       		
+		msleep(50);	       		
 		irqs = probe_irq_off(irqs);
 		val1 = rc_in(bp, RC_BSR);		/* Get Board Status reg   */
 		val2 = rc_in(bp, RC_ACK_TINT);          /* ACK interrupt          */
