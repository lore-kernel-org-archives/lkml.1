Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbXJUH4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbXJUH4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXJUHwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:45 -0400
Received: from havoc.gtf.org ([69.61.125.42]:46908 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbXJUHwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:43 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, akpm@linux-foundation.org
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 12/17] isdn/sc: irq handler clean
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075243.1C39219041B@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:43 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit ebf0fb18d5c19bb0201912850d14a9fda292ee0e
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 19:31:27 2007 -0400

    isdn/sc: irq handler clean
    
    * pass card number to irq handler
    
    * use card number in irq handler to avoid looping through each adapter
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/isdn/sc/init.c      |    3 ++-
 drivers/isdn/sc/interrupt.c |   17 ++---------------
 2 files changed, 4 insertions(+), 16 deletions(-)

ebf0fb18d5c19bb0201912850d14a9fda292ee0e
diff --git a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
index d09c854..dd0acd0 100644
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -334,7 +334,8 @@ static int __init sc_init(void)
 		 */
 		sc_adapter[cinst]->interrupt = irq[b];
 		if (request_irq(sc_adapter[cinst]->interrupt, interrupt_handler,
-				IRQF_DISABLED, interface->id, NULL))
+				IRQF_DISABLED, interface->id,
+				(void *)(unsigned long) cinst))
 		{
 			kfree(sc_adapter[cinst]->channel);
 			indicate_status(cinst, ISDN_STAT_UNLOAD, 0, NULL);	/* Fix me */
diff --git a/drivers/isdn/sc/interrupt.c b/drivers/isdn/sc/interrupt.c
index bef7963..485be8b 100644
--- a/drivers/isdn/sc/interrupt.c
+++ b/drivers/isdn/sc/interrupt.c
@@ -21,28 +21,15 @@
 #include "card.h"
 #include <linux/interrupt.h>
 
-static int get_card_from_irq(int irq)
-{
-	int i;
-
-	for(i = 0 ; i < cinst ; i++) {
-		if(sc_adapter[i]->interrupt == irq)
-			return i;
-	}
-	return -1;
-}
-
 /*
  * 
  */
-irqreturn_t interrupt_handler(int interrupt, void *cardptr)
+irqreturn_t interrupt_handler(int dummy, void *card_inst)
 {
 
 	RspMessage rcvmsg;
 	int channel;
-	int card;
-
-	card = get_card_from_irq(interrupt);
+	int card = (int)(unsigned long) card_inst;
 
 	if(!IS_VALID_CARD(card)) {
 		pr_debug("Invalid param: %d is not a valid card id\n", card);
