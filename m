Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbXJVMCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbXJVMCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXJVMCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:02:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:35245 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbXJVMCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:02:02 -0400
Date: Mon, 22 Oct 2007 14:02:00 +0200
From: Karsten Keil <kkeil@suse.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org
Subject: Re: [PATCH 11/17] isdn/act2000: fix major bug. clean irq handler
Message-ID: <20071022120200.GA28552@pingi.kke.suse.de>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.53-0.16-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit e295b1287f0f559f4795ae75acb793b480594a04
Author: Jeff Garzik <jeff@garzik.org>
Date:   Fri Oct 19 19:30:28 2007 -0400

    isdn/act2000: fix major bug. clean irq handler.
    
    * invert sense of request_irq() test.  otherwise we will always fail,
      when IRQ is available.
    
    * no need to use 'irq' function arg, its stored in a data struct already
    
    Acked-by: Karsten Keil <kkeil@suse.de>
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


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
