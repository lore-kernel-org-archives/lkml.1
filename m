Return-Path: <linux-kernel-owner+w=401wt.eu-S966927AbXJSHfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966927AbXJSHfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 03:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934330AbXJSHe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 03:34:57 -0400
Received: from havoc.gtf.org ([69.61.125.42]:38341 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764400AbXJSHez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 03:34:55 -0400
Date: Fri, 19 Oct 2007 03:34:54 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       dmitry.torokhov@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] atm/stallion/ucb1400_ts: remove needless use of irq
	handler first arg
Message-ID: <20071019073454.GA5783@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit aeb16d7836f97576218fae6f3959c415b0fd09f0
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 03:19:08 2007 -0400

    [ATM, CHAR, TOUCHSCREEN] remove needless use of irq handler first arg
    
    Like the vast majority of other drivers, these drivers do not need to
    reference their 'irq' function argument at all.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/atm/ambassador.c               |    2 +-
 drivers/char/stallion.c                |    2 +-
 drivers/input/touchscreen/ucb1400_ts.c |   11 ++++-------
 3 files changed, 6 insertions(+), 9 deletions(-)

aeb16d7836f97576218fae6f3959c415b0fd09f0
diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index b34b382..c2b9464 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -872,7 +872,7 @@ static irqreturn_t interrupt_handler(int irq, void *dev_id) {
   
     // for us or someone else sharing the same interrupt
     if (!interrupt) {
-      PRINTD (DBG_IRQ, "irq not for me: %d", irq);
+      PRINTD (DBG_IRQ, "irq not for me");
       return IRQ_NONE;
     }
     
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 45758d5..bf5a134 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -1629,7 +1629,7 @@ static irqreturn_t stl_intr(int irq, void *dev_id)
 {
 	struct stlbrd *brdp = dev_id;
 
-	pr_debug("stl_intr(brdp=%p,irq=%d)\n", brdp, irq);
+	pr_debug("stl_intr(brdp=%p,irq=%d)\n", brdp, brdp->irq);
 
 	return IRQ_RETVAL((* brdp->isr)(brdp));
 }
diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
index 89373b0..68dac18 100644
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -360,13 +360,10 @@ static irqreturn_t ucb1400_hard_irq(int irqnr, void *devid)
 {
 	struct ucb1400 *ucb = devid;
 
-	if (irqnr == ucb->irq) {
-		disable_irq(ucb->irq);
-		ucb->irq_pending = 1;
-		wake_up(&ucb->ts_wait);
-		return IRQ_HANDLED;
-	}
-	return IRQ_NONE;
+	disable_irq(ucb->irq);
+	ucb->irq_pending = 1;
+	wake_up(&ucb->ts_wait);
+	return IRQ_HANDLED;
 }
 
 static int ucb1400_ts_open(struct input_dev *idev)
