Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZA1Qqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZA1Qqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 11:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZA1Qqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 11:46:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:53573 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbZA1Qqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:46:37 -0500
Subject: Re: Buggy IPI and MTRR code on low memory
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, jens.axboe@oracle.com
In-Reply-To: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 17:46:22 +0100
Message-Id: <1233161182.10992.52.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 11:38 -0500, Steven Rostedt wrote:

> The problem is that if we use the stack, then we must wait for the 
> function to finish. But in the mtrr code, the called functions are waiting 
> for the caller to do something after the smp_call_function. Thus we 
> deadlock!

You'd have to 'fix' the regular fallback paths to use your scheme as
well.

Below is a fix for the mtrr code to not rely on this.

---
Subject: x86: fix potential deadlock in set_mtrr()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Jan 28 17:17:32 CET 2009

smp_call_function() can fall-back to waiting on completion in case of
low memory (GFP_ATOMIC). set_mtrr() relies on the async behaviour of !wait.

This would deadlock.

Fix this by providing per-cpu csd's and using __smp_call_function_single().

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/mtrr/main.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/main.c
@@ -38,6 +38,7 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/sort.h>
+#include <linux/smp.h>
 
 #include <asm/e820.h>
 #include <asm/mtrr.h>
@@ -130,12 +131,12 @@ struct set_mtrr_data {
 	mtrr_type	smp_type;
 };
 
+#ifdef CONFIG_SMP
 static void ipi_handler(void *info)
 /*  [SUMMARY] Synchronisation handler. Executed by "other" CPUs.
     [RETURNS] Nothing.
 */
 {
-#ifdef CONFIG_SMP
 	struct set_mtrr_data *data = info;
 	unsigned long flags;
 
@@ -158,9 +159,31 @@ static void ipi_handler(void *info)
 
 	atomic_dec(&data->count);
 	local_irq_restore(flags);
-#endif
 }
 
+DEFINE_PER_CPU(struct call_single_data, mtrr_csd);
+
+static void set_mtrr_smp(struct set_mtrr_data *data)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		struct call_single_data *csd = &per_cpu(mtrr_csd, cpu);
+
+		if (cpu == smp_processor_id())
+			continue;
+
+		csd->func = ipi_handler;
+		csd->info = data;
+		__smp_call_function_single(cpu, csd);
+	}
+}
+#else
+static void set_mtrr_smp(struct set_mtrr_data *data)
+{
+}
+#endif
+
 static inline int types_compatible(mtrr_type type1, mtrr_type type2) {
 	return type1 == MTRR_TYPE_UNCACHABLE ||
 	       type2 == MTRR_TYPE_UNCACHABLE ||
@@ -222,12 +245,11 @@ static void set_mtrr(unsigned int reg, u
 	smp_wmb();
 	atomic_set(&data.gate,0);
 
-	/*  Start the ball rolling on other CPUs  */
-	if (smp_call_function(ipi_handler, &data, 0) != 0)
-		panic("mtrr: timed out waiting for other CPUs\n");
-
 	local_irq_save(flags);
 
+	/*  Start the ball rolling on other CPUs  */
+	set_mtrr_smp(&data);
+
 	while(atomic_read(&data.count))
 		cpu_relax();
 


