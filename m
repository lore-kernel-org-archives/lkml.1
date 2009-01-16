Return-Path: <linux-kernel-owner+w=401wt.eu-S1765334AbZAPTzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765334AbZAPTzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbZAPTzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:55:07 -0500
Received: from relay2.sgi.com ([192.48.179.30]:60785 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754239AbZAPTzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:55:05 -0500
Message-ID: <4970E614.5040607@sgi.com>
Date: Fri, 16 Jan 2009 11:55:00 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL}: latest tip/cpus4096 changes
References: <49704DF6.8040205@sgi.com> <20090116093442.GE4305@elte.hu> <4970BF1C.2020201@goop.org>
In-Reply-To: <4970BF1C.2020201@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
>>> commit beec9183a43f8a42f5b790326a3b120a3b513590
>>> Author: Mike Travis <travis@sgi.com>
>>> Date:   Fri Jan 16 00:22:33 2009 -0800
>>>
>>>     xen: reduce static memory usage
>>>     
>>
>> this one looks good in a quick check but please send it to Jeremy
>> first or get his Ack.
>>   
> 
> Yeah, send me a copy (I can't find it if you already have).
> 
> Thanks,
>    J

Hi Jeremy,

Here tis... Christophe was kind enough to test it for me.  (I believe
he said you were on vacation, though he did mention that you had some
changes in the queue?)

Thanks!
Mike
--- 

Subject: xen: reduce static memory usage

Impact: reduce memory usage

By allocating the irq_info and irq_bindcount based
on nr_irqs instead of NR_IRQS, it will contain only
enough entries as needed by the running system.

This addresses this memory bump when NR_CPUS bumped
from 128 to 4096:

  17408   132096  +114688  +658%  irq_info(.bss)
  17408   132096  +114688  +658%  irq_bindcount(.bss)

This is only effective when CONFIG_SPARSE_IRQS=y.

Signed-off-by: Mike Travis <travis@sgi.com>
Tested-by: Christophe Saout <christophe@saout.de>
---
 drivers/xen/events.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- linux-2.6-for-ingo.orig/drivers/xen/events.c
+++ linux-2.6-for-ingo/drivers/xen/events.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/bootmem.h>
+#include <linux/irqnr.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq.h>
@@ -59,7 +60,7 @@ struct packed_irq
 	unsigned char type;
 };
 
-static struct packed_irq irq_info[NR_IRQS];
+static struct packed_irq *irq_info;
 
 /* Binding types. */
 enum {
@@ -87,7 +88,7 @@ static inline unsigned long *cpu_evtchn_
 static u8 cpu_evtchn[NR_EVENT_CHANNELS];
 
 /* Reference counts for bindings to IRQs. */
-static int irq_bindcount[NR_IRQS];
+static int *irq_bindcount;
 
 /* Xen will never allocate port zero for any purpose. */
 #define VALID_EVTCHN(chn)	((chn) != 0)
@@ -833,7 +834,10 @@ void __init xen_init_IRQ(void)
 	size_t size = nr_cpu_ids * sizeof(struct cpu_evtchn_s);
 
 	cpu_evtchn_mask_p = alloc_bootmem(size);
-	BUG_ON(cpu_evtchn_mask_p == NULL);
+
+	irq_info = alloc_bootmem(nr_irqs * sizeof(struct packed_irq));
+
+	irq_bindcount = alloc_bootmem(nr_irqs * sizeof(int));
 
 	init_evtchn_cpu_bindings();
 
