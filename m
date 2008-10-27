Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYJ0Vit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYJ0Vit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYJ0ViJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:38:09 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:42592 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752087AbYJ0ViG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:38:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nXfzAgNAQrjrEFQ5xZ0HTSQRt6u9DZL5AQVGFLwIe5G9UJJxeXNfqUmpL0ygRAi1982gjVjgx9QgY00m19P2yGHy00APADbQuwZ+mdrL/PuuAorut665WAhPZKPtKwBpeWSTXCGgC1wJaEy/TDwpAlLO0LZaJrmiqiUKlHJiykg=  ;
X-YMail-OSG: m5uqFaEVM1k_ARCxvK7iiOsyPHGyWYhwRBGGLN4XMLGXVEYrGchfqY_l3fT25JjF.UAwqLRuPgV84f0KW4xPyFA1Y6w0n6Ia_1E2TcL3EGjD0SiAxSpMdXRzNAUqPIJ2diBtw8fqyrlasO2HB3Jni.Sf
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.28-rc2] genirq:  record IRQ_LEVEL in irq_desc[]
Date: Mon, 27 Oct 2008 13:55:23 -0700
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810271355.23588.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

When recording the irq trigger type, let's also make sure
that IRQ_LEVEL gets set correctly.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
So long as IRQ_LEVEL exists and is used through enable_irq() and
setup_irq(), I suspect it should get set correctly!  However, now
that we record IRQ_TYPE_LEVEL_* maybe IRQ_LEVEL should vanish...

 kernel/irq/chip.c   |    1 +
 kernel/irq/manage.c |   15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -124,6 +124,7 @@ int set_irq_type(unsigned int irq, unsig
 		return -ENODEV;
 	}
 
+	type &= IRQ_TYPE_SENSE_MASK;
 	if (type == IRQ_TYPE_NONE)
 		return 0;
 
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -332,16 +332,18 @@ int __irq_set_trigger(struct irq_desc *d
 		return 0;
 	}
 
-	ret = chip->set_type(irq, flags & IRQF_TRIGGER_MASK);
+	/* caller masked out all except trigger mode flags */
+	ret = chip->set_type(irq, flags);
 
 	if (ret)
 		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
-				(int)(flags & IRQF_TRIGGER_MASK),
-				irq, chip->set_type);
+				(int)flags, irq, chip->set_type);
 	else {
+		if (flags & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
+			flags |= IRQ_LEVEL;
 		/* note that IRQF_TRIGGER_MASK == IRQ_TYPE_SENSE_MASK */
-		desc->status &= ~IRQ_TYPE_SENSE_MASK;
-		desc->status |= flags & IRQ_TYPE_SENSE_MASK;
+		desc->status &= ~(IRQ_LEVEL | IRQ_TYPE_SENSE_MASK);
+		desc->status |= flags;
 	}
 
 	return ret;
@@ -421,7 +423,8 @@ __setup_irq(unsigned int irq, struct irq
 
 		/* Setup the type (level, edge polarity) if configured: */
 		if (new->flags & IRQF_TRIGGER_MASK) {
-			ret = __irq_set_trigger(desc, irq, new->flags);
+			ret = __irq_set_trigger(desc, irq,
+					new->flags & IRQF_TRIGGER_MASK);
 
 			if (ret) {
 				spin_unlock_irqrestore(&desc->lock, flags);
