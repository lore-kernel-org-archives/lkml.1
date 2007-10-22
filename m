Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbXJVMEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbXJVMEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXJVME1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:04:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:37216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXJVME1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:04:27 -0400
Date: Mon, 22 Oct 2007 14:04:25 +0200
From: Karsten Keil <kkeil@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: kkeil@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 12/17] isdn/sc: irq handler clean
Message-ID: <20071022120425.GB28552@pingi.kke.suse.de>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>, kkeil@suse.de,
	akpm@linux-foundation.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.53-0.16-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit ebf0fb18d5c19bb0201912850d14a9fda292ee0e
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 19:31:27 2007 -0400

    isdn/sc: irq handler clean
    
    * pass card number to irq handler
    
    * use card number in irq handler to avoid looping through each adapter
    
    Acked-by: Karsten Keil <kkeil@suse.de>
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

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
