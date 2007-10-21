Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbXJUHxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbXJUHxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbXJUHwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:17 -0400
Received: from havoc.gtf.org ([69.61.125.42]:51247 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbXJUHwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:16 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 3/17] drivers/char/ip2: separate polling and irq-driven work
	entry points
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075215.3320019041B@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:15 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5fd7ce2334028e79571afef911f938dd20715bc0
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 15:38:40 2007 -0400

    drivers/char/ip2: separate polling and irq-driven work entry points
    
    Polling currently calls the irq handler, which loops through all the
    boards, calling the work function for all polling boards with work.
    
    irq handling loops through all the boards, finding the specific board
    that applies to us, and calling the work just for that one board.
    
    The two logics are sufficiently different to warrant different
    functions, rather than being slack and calling the same function in two
    different ways.
    
    This serves to make the interrupt handler a -lot- more efficient.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/char/ip2/ip2main.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

5fd7ce2334028e79571afef911f938dd20715bc0
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 150e1e3..e04e66c 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -752,7 +752,7 @@ retry:
 					continue;
 				rc = request_irq( ip2config.irq[i], ip2_interrupt,
 					IP2_SA_FLAGS | (ip2config.type[i] == PCI ? IRQF_SHARED : 0),
-					pcName, (void *)&pcName);
+					pcName, i2BoardPtrTable[i]);
 				if (rc) {
 					printk(KERN_ERR "IP2: an request_irq failed: error %d\n",rc);
 					ip2config.irq[i] = CIR_POLL;
@@ -1191,12 +1191,12 @@ ip2_irq_work(i2eBordStrPtr pB)
 #endif /* USE_IQI */
 }
 
-static irqreturn_t
-ip2_interrupt(int irq, void *dev_id)
+static void
+ip2_polled_interrupt(void)
 {
 	int i;
 	i2eBordStrPtr  pB;
-	int handled = 0;
+	const int irq = 0;
 
 	ip2trace (ITRC_NO_PORT, ITRC_INTR, 99, 1, irq );
 
@@ -1208,7 +1208,6 @@ ip2_interrupt(int irq, void *dev_id)
 //			IRQ = 0 for polled boards, we won't poll "IRQ" boards
 
 		if ( pB && (pB->i2eUsingIrq == irq) ) {
-			handled = 1;
 			ip2_irq_work(pB);
 		}
 	}
@@ -1216,7 +1215,21 @@ ip2_interrupt(int irq, void *dev_id)
 	++irq_counter;
 
 	ip2trace (ITRC_NO_PORT, ITRC_INTR, ITRC_RETURN, 0 );
-	return IRQ_RETVAL(handled);
+}
+
+static irqreturn_t
+ip2_interrupt(int irq, void *dev_id)
+{
+	i2eBordStrPtr pB = dev_id;
+
+	ip2trace (ITRC_NO_PORT, ITRC_INTR, 99, 1, pB->i2eUsingIrq );
+
+	ip2_irq_work(pB);
+
+	++irq_counter;
+
+	ip2trace (ITRC_NO_PORT, ITRC_INTR, ITRC_RETURN, 0 );
+	return IRQ_HANDLED;
 }
 
 /******************************************************************************/
@@ -1239,7 +1252,7 @@ ip2_poll(unsigned long arg)
 	// Just polled boards, IRQ = 0 will hit all non-interrupt boards.
 	// It will NOT poll boards handled by hard interrupts.
 	// The issue of queued BH interrups is handled in ip2_interrupt().
-	ip2_interrupt(0, NULL);
+	ip2_polled_interrupt();
 
 	PollTimer.expires = POLL_TIMEOUT;
 	add_timer( &PollTimer );
