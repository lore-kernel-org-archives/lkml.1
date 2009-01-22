Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZAVIkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZAVIkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbZAVIkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:40:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:53897 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbZAVIkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:40:09 -0500
Message-ID: <497830A0.3070805@kernel.org>
Date: Thu, 22 Jan 2009 00:38:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, mpm@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: sparc64 build breakage...
References: <20090121.171553.142827920.davem@davemloft.net> <20090121.172451.72573335.davem@davemloft.net> <20090122081101.GA32212@elte.hu>
In-Reply-To: <20090122081101.GA32212@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * David Miller <davem@davemloft.net> wrote:
> 
>> From: David Miller <davem@davemloft.net>
>> Date: Wed, 21 Jan 2009 17:15:53 -0800 (PST)
>>
>>> This change:
>>>
>>> commit d7e51e66899f95dabc89b4d4c6674a6e50fa37fc
>>> Author: Yinghai Lu <yinghai@kernel.org>
>>> Date:   Wed Jan 7 15:03:13 2009 -0800
>>>
>>>     sparseirq: make some func to be used with genirq
>>>
>>> breaks the sparc64 build:
>> ..
>>> This should fix it:
>>>
>>> sparc64: Fix build by using kstat_irqs_cpu().
>> And here is a mix for the next failure.
> 
> Applied your fixes to tip/irq/sparseirq:
> 
>  e81838d: sparc64: Fix build by using kstat_irqs_cpu()
>  623d3f0: sparc64: Fix build by including linux/irq.h into time_64.c
> 
> thanks David!
> 
>> But really, either linux/kernel_stat.h provides the 
>> kstat_incr_irqs_this_cpu interface or linux/irq.h does, not both.
> 
> Yes, but every time someone tries to clean those dependencies up, it gets 
> held up by non-genirq architectures:
> 
>  /*
>   * Please do not include this file in generic code.  There is currently
>   * no requirement for any architecture to implement anything held
>   * within this file.
>   *
>   * Thanks. --rmk
>   */
> 
> Meanwhile that particular comment is moot because ARM is genirq - but 
> there's a handful of other non-genirq architectures so this area of code 
> continues to be a mess.
> 
> I guess we could move all the APIs to kernel_stat.h. Yinghai?

sth like:

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 5d6ad5d..7977d54 100644
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
index 51d2129..b6d2887 100644
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
