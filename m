Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbXJUHwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbXJUHwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbXJUHwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:14 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59081 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbXJUHwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:13 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/17] drivers/char/ip2: split out irq core logic into
	separate function
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075212.9A81A19041B@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:12 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 630a62678c4be9cb00500904185212cdb221c92a
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 15:24:59 2007 -0400

    drivers/char/ip2: split out irq core logic into separate function
    
    No changes besides code movement and glue.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/char/ip2/ip2main.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

630a62678c4be9cb00500904185212cdb221c92a
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 2124dce..150e1e3 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -1166,6 +1166,31 @@ ip2_interrupt_bh(struct work_struct *work)
 /*                                                                            */
 /*                                                                            */
 /******************************************************************************/
+static void
+ip2_irq_work(i2eBordStrPtr pB)
+{
+#ifdef USE_IQI
+	if (NO_MAIL_HERE != ( pB->i2eStartMail = iiGetMail(pB))) {
+//		Disable his interrupt (will be enabled when serviced)
+//		This is mostly to protect from reentrancy.
+		iiDisableMailIrq(pB);
+
+//		Park the board on the immediate queue for processing.
+		schedule_work(&pB->tqueue_interrupt);
+
+//		Make sure the immediate queue is flagged to fire.
+	}
+#else
+
+//	We are using immediate servicing here.  This sucks and can
+//	cause all sorts of havoc with ppp and others.  The failsafe
+//	check on iiSendPendingMail could also throw a hairball.
+
+	i2ServiceBoard( pB );
+
+#endif /* USE_IQI */
+}
+
 static irqreturn_t
 ip2_interrupt(int irq, void *dev_id)
 {
@@ -1184,24 +1209,7 @@ ip2_interrupt(int irq, void *dev_id)
 
 		if ( pB && (pB->i2eUsingIrq == irq) ) {
 			handled = 1;
-#ifdef USE_IQI
-
-		    if (NO_MAIL_HERE != ( pB->i2eStartMail = iiGetMail(pB))) {
-//			Disable his interrupt (will be enabled when serviced)
-//			This is mostly to protect from reentrancy.
-			iiDisableMailIrq(pB);
-
-//			Park the board on the immediate queue for processing.
-			schedule_work(&pB->tqueue_interrupt);
-
-//			Make sure the immediate queue is flagged to fire.
-		    }
-#else
-//		We are using immediate servicing here.  This sucks and can
-//		cause all sorts of havoc with ppp and others.  The failsafe
-//		check on iiSendPendingMail could also throw a hairball.
-			i2ServiceBoard( pB );
-#endif /* USE_IQI */
+			ip2_irq_work(pB);
 		}
 	}
 
