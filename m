Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbZCJO1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbZCJO1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbZCJO0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:26:50 -0400
Received: from www.tglx.de ([62.245.132.106]:33427 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746AbZCJO0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:26:49 -0400
Date: Tue, 10 Mar 2009 15:26:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Free setup_irq() interrupt V2
In-Reply-To: <20090310102459.23422.80761.sendpatchset@rx1.opensource.se>
Message-ID: <alpine.LFD.2.00.0903101510040.29264@localhost.localdomain>
References: <20090310102459.23422.80761.sendpatchset@rx1.opensource.se>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus,

On Tue, 10 Mar 2009, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> This patch adds a __free_irq() function for releasing 
> interrupts requested with setup_irq().

I think there is a simpler solution than adding yet another function
for the confusion of driver writers. See below.

>  Why again are we not using struct list_head for the irqaction list?

Why should we ? The add/remove of interrupt handlers is not a high
frequency hot path operation.

Thanks,

	tglx
--------

Subject: genirq: make free_irq() aware of static irqactions
From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 10 Mar 2009 15:00:59 +0100

Impact: enhancement

Interrupts which are set up via setup_irq() with a static irqaction
can not be released via free_irq(). The irqs set up via request_irq()
use a kmalloc'ed irqaction. Mark them as allocated in irqaction->flags
and check the flag in free_irq().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |    2 ++
 kernel/irq/manage.c       |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -49,6 +49,7 @@
  * IRQF_IRQPOLL - Interrupt is used for polling (only the interrupt that is
  *                registered first in an shared interrupt is considered for
  *                performance reasons)
+ * IRQF_ALLOCATED - Mark the irqaction as allocated by request_irq
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -58,6 +59,7 @@
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
+#define IRQF_ALLOCATED		0x00002000
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -623,7 +623,8 @@ void free_irq(unsigned int irq, void *de
 				local_irq_restore(flags);
 			}
 #endif
-			kfree(action);
+			if (action->flags & IRQF_ALLOCATED)
+				kfree(action);
 			return;
 		}
 		printk(KERN_ERR "Trying to free already-free IRQ %d\n", irq);
@@ -714,7 +715,7 @@ int request_irq(unsigned int irq, irq_ha
 		return -ENOMEM;
 
 	action->handler = handler;
-	action->flags = irqflags;
+	action->flags = irqflags | IRQF_ALLOCATED;
 	cpus_clear(action->mask);
 	action->name = devname;
 	action->next = NULL;
