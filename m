Return-Path: <linux-kernel-owner+w=401wt.eu-S935928AbXGXJm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935928AbXGXJm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933441AbXGXJmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:42:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42032 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763434AbXGXJmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:42:38 -0400
Date: Tue, 24 Jul 2007 11:42:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin ??lusarz <marcin.slusarz@gmail.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Jean-Baptiste Vignaud <vignaud@xandmail.fr>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       shemminger <shemminger@linux-foundation.org>,
       linux-net <linux-net@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.20->2.6.21 - networking dies after random time
Message-ID: <20070724094202.GA11610@elte.hu>
References: <JKE37W$0126317E099DF36884CC046B6F8A7AA9@xandmail.com> <20070629150759.GC2771@ff.dom.local> <4bacf17f0707222244p664e7a6ap850b3357a57d73c@mail.gmail.com> <20070724080534.GC18740@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724080534.GC18740@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> thanks for tracking it down! Could you try the patch below (ontop an 
> otherwise unmodified kernel)? This tests the theory whether the 
> problem is related to the disable_irq_nosync() call in the ne2k 
> driver's xmit path. Does this solve the hangs too?

please try the patch below instead.

	Ingo

Index: linux/kernel/irq/chip.c
===================================================================
--- linux.orig/kernel/irq/chip.c
+++ linux/kernel/irq/chip.c
@@ -231,7 +231,7 @@ static void default_enable(unsigned int 
 /*
  * default disable function
  */
-static void default_disable(unsigned int irq)
+void default_disable(unsigned int irq)
 {
 }
 
Index: linux/kernel/irq/internals.h
===================================================================
--- linux.orig/kernel/irq/internals.h
+++ linux/kernel/irq/internals.h
@@ -10,6 +10,8 @@ extern void irq_chip_set_defaults(struct
 /* Set default handler: */
 extern void compat_irq_chip_set_default_handler(struct irq_desc *desc);
 
+extern void default_disable(unsigned int irq);
+
 #ifdef CONFIG_PROC_FS
 extern void register_irq_proc(unsigned int irq);
 extern void register_handler_proc(unsigned int irq, struct irqaction *action);
Index: linux/kernel/irq/manage.c
===================================================================
--- linux.orig/kernel/irq/manage.c
+++ linux/kernel/irq/manage.c
@@ -102,7 +102,19 @@ void disable_irq_nosync(unsigned int irq
 	spin_lock_irqsave(&desc->lock, flags);
 	if (!desc->depth++) {
 		desc->status |= IRQ_DISABLED;
-		desc->chip->disable(irq);
+		/*
+		 * the _nosync variant of irq-disable suggests that the
+		 * caller is not worried about concurrency but about the
+		 * ordering of the irq flow itself. (such as hardware
+		 * getting confused about certain, normally valid irq
+		 * handling sequences.) So if the default disable handler
+		 * is in place then try the more conservative masking
+		 * instead:
+		 */
+		if (desc->chip->disable == default_disable && desc->chip->mask)
+			desc->chip->mask(irq);
+		else
+			desc->chip->disable(irq);
 	}
 	spin_unlock_irqrestore(&desc->lock, flags);
 }
