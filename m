Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZAVJUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZAVJUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbZAVJUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:20:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40859 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbZAVJUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:20:30 -0500
Date: Thu, 22 Jan 2009 10:20:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: David Miller <davem@davemloft.net>, mpm@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: sparc64 build breakage...
Message-ID: <20090122092010.GA24758@elte.hu>
References: <20090121.171553.142827920.davem@davemloft.net> <20090121.172451.72573335.davem@davemloft.net> <20090122081101.GA32212@elte.hu> <497830A0.3070805@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497830A0.3070805@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> > Meanwhile that particular comment is moot because ARM is genirq - but 
> > there's a handful of other non-genirq architectures so this area of code 
> > continues to be a mess.
> > 
> > I guess we could move all the APIs to kernel_stat.h. Yinghai?
> 
> sth like:

yes. I've applied your cleanup to irq/sparseirq [see the commit below] and 
started doing some build testing to see what the general impact is.

	Ingo

-------------------->
>From d52a61c04c6c0814ca270a088feedb126436598e Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Thu, 22 Jan 2009 00:38:56 -0800
Subject: [PATCH] irq: clean up irq stat methods

David Miller suggested, related to a kstat_irqs related build breakage:

> Either linux/kernel_stat.h provides the kstat_incr_irqs_this_cpu
> interface or linux/irq.h does, not both.

So move them to kernel_stat.h.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/irq.h         |    6 ------
 include/linux/kernel_stat.h |    9 ++++++---
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index e9a8789..48901e9 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -202,12 +202,6 @@ extern struct irq_desc irq_desc[NR_IRQS];
 extern struct irq_desc *move_irq_desc(struct irq_desc *old_desc, int cpu);
 #endif /* CONFIG_SPARSE_IRQ */
 
-#define kstat_irqs_this_cpu(DESC) \
-	((DESC)->kstat_irqs[smp_processor_id()])
-#define kstat_incr_irqs_this_cpu(irqno, DESC) \
-	((DESC)->kstat_irqs[smp_processor_id()]++)
-
-
 extern struct irq_desc *irq_to_desc_alloc_cpu(unsigned int irq, int cpu);
 
 static inline struct irq_desc *
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index a3431b1..0c8b89f 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -52,16 +52,19 @@ static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
 {
 	kstat_this_cpu.irqs[irq]++;
 }
-#endif
-
 
-#ifndef CONFIG_GENERIC_HARDIRQS
 static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
        return kstat_cpu(cpu).irqs[irq];
 }
 #else
+#include <linux/irq.h>
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
+#define kstat_irqs_this_cpu(DESC) \
+	((DESC)->kstat_irqs[smp_processor_id()])
+#define kstat_incr_irqs_this_cpu(irqno, DESC) \
+	((DESC)->kstat_irqs[smp_processor_id()]++)
+
 #endif
 
 /*
