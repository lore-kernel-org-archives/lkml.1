Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbXJUHyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbXJUHyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbXJUHw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:28 -0400
Received: from havoc.gtf.org ([69.61.125.42]:34212 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbXJUHw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:26 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 6/17] drivers/char/riscom8: irq handler cleanups
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075225.A1F9819041C@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:25 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 93ea6d56f83b7b614c103222fa098cb30d26f608
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 16:41:23 2007 -0400

    drivers/char/riscom8: irq handler cleanups
    
    No need to lookup board ptr, we already have it.
    
    Also, remove a few 'inline' markers and let the compiler make that
    decision.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/char/riscom8.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

93ea6d56f83b7b614c103222fa098cb30d26f608
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index b37e626..d307320 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -537,16 +537,14 @@ static inline void rc_check_modem(struct riscom_board const * bp)
 }
 
 /* The main interrupt processing routine */
-static irqreturn_t rc_interrupt(int irq, void * dev_id)
+static irqreturn_t rc_interrupt(int dummy, void * dev_id)
 {
 	unsigned char status;
 	unsigned char ack;
-	struct riscom_board *bp;
+	struct riscom_board *bp = dev_id;
 	unsigned long loop = 0;
 	int handled = 0;
 
-	bp = IRQ_to_board[irq];
-
 	if (!(bp->flags & RC_BOARD_ACTIVE))
 		return IRQ_NONE;
 
@@ -603,7 +601,7 @@ static irqreturn_t rc_interrupt(int irq, void * dev_id)
  */
 
 /* Called with disabled interrupts */
-static inline int rc_setup_board(struct riscom_board * bp)
+static int rc_setup_board(struct riscom_board * bp)
 {
 	int error;
 
@@ -611,7 +609,7 @@ static inline int rc_setup_board(struct riscom_board * bp)
 		return 0;
 	
 	error = request_irq(bp->irq, rc_interrupt, IRQF_DISABLED,
-			    "RISCom/8", NULL);
+			    "RISCom/8", bp);
 	if (error) 
 		return error;
 	
@@ -626,7 +624,7 @@ static inline int rc_setup_board(struct riscom_board * bp)
 }
 
 /* Called with disabled interrupts */
-static inline void rc_shutdown_board(struct riscom_board *bp)
+static void rc_shutdown_board(struct riscom_board *bp)
 {
 	if (!(bp->flags & RC_BOARD_ACTIVE))
 		return;
