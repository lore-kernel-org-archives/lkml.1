Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXJUHy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXJUHy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXJUHwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:30 -0400
Received: from havoc.gtf.org ([69.61.125.42]:58805 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbXJUHw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:29 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: R.E.Wolff@BitWizard.nl
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 7/17] drivers/char/{rio,specialix,sx}: irq handler
	cleanups
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075228.3C703190418@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:28 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit ac608e65f5c2a99affced5f02eefe24125f9c5bd
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 16:43:21 2007 -0400

    drivers/char/{rio,specialix,sx}: irq handler cleanups
    
    * explicitly separate polled and irq-driven modes of operation
    
    * no need to reference 'irq' function arg
    
    * mark a free_irq() -in-irq-handler use with a FIXME (ugh!)
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/char/rio/rio_linux.c |   23 +++++++++++++----------
 drivers/char/specialix.c     |   10 ++++------
 drivers/char/sx.c            |   22 ++++++++++++++--------
 3 files changed, 31 insertions(+), 24 deletions(-)

ac608e65f5c2a99affced5f02eefe24125f9c5bd
diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index 0ce9667..fb06665 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -362,14 +362,11 @@ static void rio_reset_interrupt(struct Host *HostP)
 	func_exit();
 }
 
-
-static irqreturn_t rio_interrupt(int irq, void *ptr)
+static irqreturn_t __rio_interrupt(struct Host *HostP, bool polled)
 {
-	struct Host *HostP;
 	func_enter();
 
-	HostP = ptr;			/* &p->RIOHosts[(long)ptr]; */
-	rio_dprintk(RIO_DEBUG_IFLOW, "rio: enter rio_interrupt (%d/%d)\n", irq, HostP->Ivec);
+	rio_dprintk(RIO_DEBUG_IFLOW, "rio: enter rio_interrupt (%d)\n", HostP->Ivec);
 
 	/* AAargh! The order in which to do these things is essential and
 	   not trivial.
@@ -389,7 +386,7 @@ static irqreturn_t rio_interrupt(int irq, void *ptr)
 	 */
 
 	rio_dprintk(RIO_DEBUG_IFLOW, "rio: We've have noticed the interrupt\n");
-	if (HostP->Ivec == irq) {
+	if (!polled) {
 		/* Tell the card we've noticed the interrupt. */
 		rio_reset_interrupt(HostP);
 	}
@@ -398,26 +395,32 @@ static irqreturn_t rio_interrupt(int irq, void *ptr)
 		return IRQ_HANDLED;
 
 	if (test_and_set_bit(RIO_BOARD_INTR_LOCK, &HostP->locks)) {
-		printk(KERN_ERR "Recursive interrupt! (host %p/irq%d)\n", ptr, HostP->Ivec);
+		printk(KERN_ERR "Recursive interrupt! (host %p/irq%d)\n",
+		       HostP, HostP->Ivec);
 		return IRQ_HANDLED;
 	}
 
 	RIOServiceHost(p, HostP);
 
-	rio_dprintk(RIO_DEBUG_IFLOW, "riointr() doing host %p type %d\n", ptr, HostP->Type);
+	rio_dprintk(RIO_DEBUG_IFLOW, "riointr() doing host %p type %d\n",
+		    HostP, HostP->Type);
 
 	clear_bit(RIO_BOARD_INTR_LOCK, &HostP->locks);
-	rio_dprintk(RIO_DEBUG_IFLOW, "rio: exit rio_interrupt (%d/%d)\n", irq, HostP->Ivec);
+	rio_dprintk(RIO_DEBUG_IFLOW, "rio: exit rio_interrupt (%d)\n", HostP->Ivec);
 	func_exit();
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t rio_interrupt(int dummy, void *ptr)
+{
+	return __rio_interrupt(ptr, false);
+}
 
 static void rio_pollfunc(unsigned long data)
 {
 	func_enter();
 
-	rio_interrupt(0, &p->RIOHosts[data]);
+	__rio_interrupt(&p->RIOHosts[data], true);
 	mod_timer(&p->RIOHosts[data].timer, jiffies + rio_poll);
 
 	func_exit();
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 4558556..706e74f 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -446,8 +446,7 @@ void missed_irq (unsigned long data)
 	spin_unlock_irqrestore(&bp->lock, flags);
 	if (irq) {
 		printk (KERN_INFO "Missed interrupt... Calling int from timer. \n");
-		sx_interrupt (((struct specialix_board *)data)->irq,
-				(void*)data);
+		sx_interrupt (-1, bp);
 	}
 	mod_timer(&missed_irq_timer, jiffies + sx_poll);
 }
@@ -876,23 +875,22 @@ static inline void sx_check_modem(struct specialix_board * bp)
 
 
 /* The main interrupt processing routine */
-static irqreturn_t sx_interrupt(int irq, void *dev_id)
+static irqreturn_t sx_interrupt(int dummy, void *dev_id)
 {
 	unsigned char status;
 	unsigned char ack;
-	struct specialix_board *bp;
+	struct specialix_board *bp = dev_id;
 	unsigned long loop = 0;
 	int saved_reg;
 	unsigned long flags;
 
 	func_enter();
 
-	bp = dev_id;
 	spin_lock_irqsave(&bp->lock, flags);
 
 	dprintk (SX_DEBUG_FLOW, "enter %s port %d room: %ld\n", __FUNCTION__, port_No(sx_get_port(bp, "INT")), SERIAL_XMIT_SIZE - sx_get_port(bp, "ITN")->xmit_cnt - 1);
 	if (!(bp->flags & SX_BOARD_ACTIVE)) {
-		dprintk (SX_DEBUG_IRQ, "sx: False interrupt. irq %d.\n", irq);
+		dprintk (SX_DEBUG_IRQ, "sx: False interrupt. irq %d.\n", bp->irq);
 		spin_unlock_irqrestore(&bp->lock, flags);
 		func_exit();
 		return IRQ_NONE;
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index a6e1c9b..ae9e973 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -1241,15 +1241,13 @@ static inline void sx_check_modem_signals(struct sx_port *port)
  * Small, elegant, clear.
  */
 
-static irqreturn_t sx_interrupt(int irq, void *ptr)
+static irqreturn_t __sx_interrupt(struct sx_board *board, bool polled)
 {
-	struct sx_board *board = ptr;
 	struct sx_port *port;
 	int i;
 
 	func_enter();
-	sx_dprintk(SX_DEBUG_FLOW, "sx: enter sx_interrupt (%d/%d)\n", irq,
-			board->irq);
+	sx_dprintk(SX_DEBUG_FLOW, "sx: enter sx_interrupt (%d)\n", board->irq);
 
 	/* AAargh! The order in which to do these things is essential and
 	   not trivial. 
@@ -1281,6 +1279,10 @@ static irqreturn_t sx_interrupt(int irq, void *ptr)
 
 		if (lastjif == jiffies) {
 			if (++nintr > IRQ_RATE_LIMIT) {
+				/*
+				 * FIXME: free_irq() inside irq handler
+				 * is unwise
+				 */
 				free_irq(board->irq, board);
 				printk(KERN_ERR "sx: Too many interrupts. "
 						"Turning off interrupt %d.\n",
@@ -1293,7 +1295,7 @@ static irqreturn_t sx_interrupt(int irq, void *ptr)
 	}
 #endif
 
-	if (board->irq == irq) {
+	if (!polled) {
 		/* Tell the card we've noticed the interrupt. */
 
 		sx_write_board_word(board, cc_int_pending, 0);
@@ -1339,19 +1341,23 @@ static irqreturn_t sx_interrupt(int irq, void *ptr)
 
 	clear_bit(SX_BOARD_INTR_LOCK, &board->locks);
 
-	sx_dprintk(SX_DEBUG_FLOW, "sx: exit sx_interrupt (%d/%d)\n", irq,
-			board->irq);
+	sx_dprintk(SX_DEBUG_FLOW, "sx: exit sx_interrupt (%d)\n", board->irq);
 	func_exit();
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t sx_interrupt(int dummy, void *data)
+{
+	return __sx_interrupt(data, false);
+}
+
 static void sx_pollfunc(unsigned long data)
 {
 	struct sx_board *board = (struct sx_board *)data;
 
 	func_enter();
 
-	sx_interrupt(0, board);
+	__sx_interrupt(board, true);
 
 	mod_timer(&board->timer, jiffies + sx_poll);
 	func_exit();
