Return-Path: <linux-kernel-owner+w=401wt.eu-S1763631AbXGFS3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763631AbXGFS3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 14:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761137AbXGFS3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 14:29:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54872 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760891AbXGFS3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 14:29:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 6 Jul 2007 20:29:04 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] I386: Deactivate the test for the dead
 CONFIG_BALANCED_IRQ_DEBUG variable.
To: Ingo Molnar <mingo@redhat.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>
In-Reply-To: <Pine.LNX.4.64.0707060957390.27008@localhost.localdomain>
Message-ID: <tkrat.5e491e648dabfb08@s5r6.in-berlin.de>
References: <Pine.LNX.4.64.0707060844280.23613@localhost.localdomain>
 <468E49DE.1000100@s5r6.in-berlin.de>
 <Pine.LNX.4.64.0707060957390.27008@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On  6 Jul, Robert P. J. Day wrote:
> On Fri, 6 Jul 2007, Stefan Richter wrote:
>> Robert P. J. Day wrote:
>> > --- a/arch/i386/kernel/io_apic.c
>> > +++ b/arch/i386/kernel/io_apic.c
>> > @@ -353,7 +353,7 @@ static void set_ioapic_affinity_irq(unsigned int irq, cpumask_t cpumask)
>> >  # include <linux/slab.h>		/* kmalloc() */
>> >  # include <linux/timer.h>	/* time_after() */
>> >
>> > -#ifdef CONFIG_BALANCED_IRQ_DEBUG
>> > +#if 0 /* debug IRQ balancing */
[...]
>> BTW, when I suggested the "#if 0" to you, I forgot that some
>> developers might be interested in compiling their kernel with
>> -DCONFIG_BALANCED_IRQ_DEBUG injected via the commandline. But we'll
>> hear from them if that's the case.
>>
>> On the other hand, these debug macros seem to be very old.  I'll
>> have a closer look with qgit/git-blame later today.  Maybe it's time
>> to remove them now.
> 
> ok, why don't i leave all that in your capable hands?  typically, when
> i describe a CONFIG_ prefixed variable as "dead", it's because it's
> not being set *anywhere* in the tree -- not in a Kconfig file or a
> header file or a source file or a Makefile.
> 
> so i'm not just checking for its existence in a Kconfig file.  i
> learned that lesson.  :-)
> 
> rday
> 
> p.s.  and i've bitched and moaned about this before, but anyone who
> deliberately names their debugging variables with a "CONFIG_" prefix
> *deserves* to have their builds break.  :-P


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: i386 IOAPIC: remove old IRQ balancing debug cruft

Dead or misnamed CONFIG_BALANCED_IRQ_DEBUG found by Robert P. J. Day.
It's not a Kconfig variable.

Since this debug code is ancient, I suggest to get rid of this
misleading CONFIG_ macro by deleting all of this debug code.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Supercedes patch "I386: Deactivate the test for the dead
CONFIG_BALANCED_IRQ_DEBUG variable."

 arch/i386/kernel/io_apic.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

Index: linux/arch/i386/kernel/io_apic.c
===================================================================
--- linux.orig/arch/i386/kernel/io_apic.c
+++ linux/arch/i386/kernel/io_apic.c
@@ -353,14 +353,6 @@ static void set_ioapic_affinity_irq(unsi
 # include <linux/slab.h>		/* kmalloc() */
 # include <linux/timer.h>	/* time_after() */
  
-#ifdef CONFIG_BALANCED_IRQ_DEBUG
-#  define TDprintk(x...) do { printk("<%ld:%s:%d>: ", jiffies, __FILE__, __LINE__); printk(x); } while (0)
-#  define Dprintk(x...) do { TDprintk(x); } while (0)
-# else
-#  define TDprintk(x...) 
-#  define Dprintk(x...) 
-# endif
-
 #define IRQBALANCE_CHECK_ARCH -999
 #define MAX_BALANCED_IRQ_INTERVAL	(5*HZ)
 #define MIN_BALANCED_IRQ_INTERVAL	(HZ/2)
@@ -443,7 +435,7 @@ static inline void balance_irq(int cpu, 
 static inline void rotate_irqs_among_cpus(unsigned long useful_load_threshold)
 {
 	int i, j;
-	Dprintk("Rotating IRQs among CPUs.\n");
+
 	for_each_online_cpu(i) {
 		for (j = 0; j < NR_IRQS; j++) {
 			if (!irq_desc[j].action)
@@ -560,19 +552,11 @@ tryanothercpu:
 	max_loaded = tmp_loaded;	/* processor */
 	imbalance = (max_cpu_irq - min_cpu_irq) / 2;
 	
-	Dprintk("max_loaded cpu = %d\n", max_loaded);
-	Dprintk("min_loaded cpu = %d\n", min_loaded);
-	Dprintk("max_cpu_irq load = %ld\n", max_cpu_irq);
-	Dprintk("min_cpu_irq load = %ld\n", min_cpu_irq);
-	Dprintk("load imbalance = %lu\n", imbalance);
-
 	/* if imbalance is less than approx 10% of max load, then
 	 * observe diminishing returns action. - quit
 	 */
-	if (imbalance < (max_cpu_irq >> 3)) {
-		Dprintk("Imbalance too trivial\n");
+	if (imbalance < (max_cpu_irq >> 3))
 		goto not_worth_the_effort;
-	}
 
 tryanotherirq:
 	/* if we select an IRQ to move that can't go where we want, then
@@ -629,9 +613,6 @@ tryanotherirq:
 	cpus_and(tmp, target_cpu_mask, allowed_mask);
 
 	if (!cpus_empty(tmp)) {
-
-		Dprintk("irq = %d moved to cpu = %d\n",
-				selected_irq, min_loaded);
 		/* mark for change destination */
 		set_pending_irq(selected_irq, cpumask_of_cpu(min_loaded));
 
@@ -651,7 +632,6 @@ not_worth_the_effort:
 	 */
 	balanced_irq_interval = min((long)MAX_BALANCED_IRQ_INTERVAL,
 		balanced_irq_interval + BALANCED_IRQ_MORE_DELTA);	
-	Dprintk("IRQ worth rotating not found\n");
 	return;
 }
 
-- 
Stefan Richter
-=====-=-=== -=== --==-
http://arcgraph.de/sr/

