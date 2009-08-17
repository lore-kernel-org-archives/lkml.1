Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbZHQMOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbZHQMOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 08:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbZHQMOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 08:14:05 -0400
Received: from www.tglx.de ([62.245.132.106]:53904 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802AbZHQMOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 08:14:05 -0400
Date: Mon, 17 Aug 2009 14:14:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Buesch <mb@bu3sch.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Threaded interrupt handlers broken?
In-Reply-To: <200908171337.58713.mb@bu3sch.de>
Message-ID: <alpine.LFD.2.00.0908171411410.2782@localhost.localdomain>
References: <200908161153.14081.mb@bu3sch.de> <alpine.LFD.2.00.0908171302430.2782@localhost.localdomain> <alpine.LFD.2.00.0908171311260.2782@localhost.localdomain> <200908171337.58713.mb@bu3sch.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

On Mon, 17 Aug 2009, Michael Buesch wrote:
> This fixes it :)

can you please test the final version of the fix ?

Thanks,

	tglx
---
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -607,7 +607,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 */
 		get_task_struct(t);
 		new->thread = t;
-		wake_up_process(t);
 	}
 
 	/*
@@ -690,6 +689,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 				(int)(new->flags & IRQF_TRIGGER_MASK));
 	}
 
+	new->irq = irq;
 	*old_ptr = new;
 
 	/* Reset broken irq detection when installing new handler */
@@ -707,7 +707,6 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 
 	spin_unlock_irqrestore(&desc->lock, flags);
 
-	new->irq = irq;
 	register_irq_proc(irq, desc);
 	new->dir = NULL;
 	register_handler_proc(irq, new);
