Return-Path: <linux-kernel-owner+w=401wt.eu-S1753475AbXJUHzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbXJUHzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 03:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXJUHwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 03:52:42 -0400
Received: from havoc.gtf.org ([69.61.125.42]:35359 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbXJUHwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 03:52:41 -0400
To: LKML <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, kkeil@suse.de
From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 11/17] isdn/act2000: fix major bug. clean irq handler
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org>
Message-Id: <20071021075240.84F85190418@havoc.gtf.org>
Date: Sun, 21 Oct 2007 03:52:40 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit e295b1287f0f559f4795ae75acb793b480594a04
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 19:30:28 2007 -0400

    isdn/act2000: fix major bug. clean irq handler.
    
    * invert sense of request_irq() test.  otherwise we will always fail,
      when IRQ is available.
    
    * no need to use 'irq' function arg, its stored in a data struct already
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/isdn/act2000/act2000_isa.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

e295b1287f0f559f4795ae75acb793b480594a04
diff --git a/drivers/isdn/act2000/act2000_isa.c b/drivers/isdn/act2000/act2000_isa.c
index 819ea85..1bd8960 100644
--- a/drivers/isdn/act2000/act2000_isa.c
+++ b/drivers/isdn/act2000/act2000_isa.c
@@ -61,7 +61,7 @@ act2000_isa_detect(unsigned short portbase)
 }
 
 static irqreturn_t
-act2000_isa_interrupt(int irq, void *dev_id)
+act2000_isa_interrupt(int dummy, void *dev_id)
 {
         act2000_card *card = dev_id;
         u_char istatus;
@@ -80,7 +80,7 @@ act2000_isa_interrupt(int irq, void *dev_id)
                 printk(KERN_WARNING "act2000: errIRQ\n");
         }
 	if (istatus)
-		printk(KERN_DEBUG "act2000: ?IRQ %d %02x\n", irq, istatus);
+		printk(KERN_DEBUG "act2000: ?IRQ %d %02x\n", card->irq, istatus);
 	return IRQ_HANDLED;
 }
 
@@ -131,6 +131,8 @@ act2000_isa_enable_irq(act2000_card * card)
 int
 act2000_isa_config_irq(act2000_card * card, short irq)
 {
+	int old_irq;
+
         if (card->flags & ACT2000_FLAGS_IVALID) {
                 free_irq(card->irq, card);
         }
@@ -139,8 +141,10 @@ act2000_isa_config_irq(act2000_card * card, short irq)
         if (!irq)
                 return 0;
 
-	if (!request_irq(irq, &act2000_isa_interrupt, 0, card->regname, card)) {
-		card->irq = irq;
+	old_irq = card->irq;
+	card->irq = irq;
+	if (request_irq(irq, &act2000_isa_interrupt, 0, card->regname, card)) {
+		card->irq = old_irq;
 		card->flags |= ACT2000_FLAGS_IVALID;
                 printk(KERN_WARNING
                        "act2000: Could not request irq %d\n",irq);
