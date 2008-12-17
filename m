Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753124AbYLQXGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbYLQXGZ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYLQXGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:06:16 -0500
Received: from gw.goop.org ([64.81.55.164]:36724 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbYLQXGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:06:15 -0500
Message-ID: <494985E1.90304@goop.org>
Date: Wed, 17 Dec 2008 15:06:09 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add handle_irq() to allow interrupt injection
References: <494810F0.1010101@goop.org> <20081216204946.GE14787@elte.hu>
In-Reply-To: <20081216204946.GE14787@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Xen uses a different interrupt path, so introduce handle_irq() to
>> allow interrupts to be inserted into the normal interrupt path.  This
>> is handled slightly differently on 32 and 64-bit.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> ---
>> arch/x86/include/asm/irq.h |    1 +
>> arch/x86/kernel/irq_32.c   |   34 +++++++++++++++++++++-------------
>> arch/x86/kernel/irq_64.c   |   23 ++++++++++++++++-------
>> 3 files changed, 38 insertions(+), 20 deletions(-)
>>
>> ===================================================================
>> --- a/arch/x86/include/asm/irq.h
>> +++ b/arch/x86/include/asm/irq.h
>> @@ -39,6 +39,7 @@
>> extern unsigned int do_IRQ(struct pt_regs *regs);
>> extern void init_IRQ(void);
>> extern void native_init_IRQ(void);
>> +extern bool handle_irq(unsigned irq, struct pt_regs *regs);
>>
>> /* Interrupt vector management */
>> extern DECLARE_BITMAP(used_vectors, NR_VECTORS);
>> ===================================================================
>> --- a/arch/x86/kernel/irq_32.c
>> +++ b/arch/x86/kernel/irq_32.c
>> @@ -191,6 +191,26 @@
>> execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq) { return 0; }
>> #endif
>>
>> +bool handle_irq(unsigned irq, struct pt_regs *regs)
>> +{
>> +	struct irq_desc *desc;
>> +	int overflow;
>> +
>> +	overflow = check_stack_overflow();
>> +
>> +	desc = irq_to_desc(irq);
>> +	if (unlikely(!desc))
>> +		return false;
>> +
>> +	if (!execute_on_irq_stack(overflow, desc, irq)) {
>> +		if (unlikely(overflow))
>> +			print_stack_overflow();
>> +		desc->handle_irq(irq, desc);
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> /*
>>  * do_IRQ handles all normal device IRQ's (the special
>>  * SMP cross-CPU interrupts have their own specific
>> @@ -200,31 +220,19 @@
>> {
>> 	struct pt_regs *old_regs;
>> 	/* high bit used in ret_from_ code */
>> -	int overflow;
>> 	unsigned vector = ~regs->orig_ax;
>> -	struct irq_desc *desc;
>> 	unsigned irq;
>>
>> -
>> 	old_regs = set_irq_regs(regs);
>> 	irq_enter();
>> 	irq = __get_cpu_var(vector_irq)[vector];
>>
>> -	overflow = check_stack_overflow();
>> -
>> -	desc = irq_to_desc(irq);
>> -	if (unlikely(!desc)) {
>> +	if (!handle_irq(irq, regs)) {
>> 		printk(KERN_EMERG "%s: cannot handle IRQ %d vector %#x cpu %d\n",
>> 					__func__, irq, vector, smp_processor_id());
>> 		BUG();
>> 	}
>>
>> -	if (!execute_on_irq_stack(overflow, desc, irq)) {
>> -		if (unlikely(overflow))
>> -			print_stack_overflow();
>> -		desc->handle_irq(irq, desc);
>> -	}
>> -
>> 	irq_exit();
>> 	set_irq_regs(old_regs);
>> 	return 1;
>> ===================================================================
>> --- a/arch/x86/kernel/irq_64.c
>> +++ b/arch/x86/kernel/irq_64.c
>> @@ -40,6 +40,20 @@
>> #endif
>> }
>>
>> +bool handle_irq(unsigned irq, struct pt_regs *regs)
>> +{
>> +	struct irq_desc *desc;
>> +
>> +	stack_overflow_check(regs);
>> +
>> +	desc = irq_to_desc(irq);
>> +	if (unlikely(!desc))
>> +		return false;
>> +
>> +	generic_handle_irq_desc(irq, desc);
>> +	return true;
>> +}
>> +
>> /*
>>  * do_IRQ handles all normal device IRQ's (the special
>>  * SMP cross-CPU interrupts have their own specific
>> @@ -48,7 +62,6 @@
>> asmlinkage unsigned int do_IRQ(struct pt_regs *regs)
>> {
>> 	struct pt_regs *old_regs = set_irq_regs(regs);
>> -	struct irq_desc *desc;
>>
>> 	/* high bit used in ret_from_ code  */
>> 	unsigned vector = ~regs->orig_ax;
>> @@ -56,14 +69,10 @@
>>
>> 	exit_idle();
>> 	irq_enter();
>> +
>> 	irq = __get_cpu_var(vector_irq)[vector];
>>
>> -	stack_overflow_check(regs);
>> -
>> -	desc = irq_to_desc(irq);
>> -	if (likely(desc))
>> -		generic_handle_irq_desc(irq, desc);
>> -	else {
>> +	if (!handle_irq(irq, regs)) {
>> 		if (!disable_apic)
>> 			ack_APIC_irq();
>>
>>     
>
> the changes look rather similar. Could you please look into unifying 
> irq_*.c before adding more logic to it?
>   

I didn't really add more logic - I just hoisted some existing code into 
a new function.

It does make do_IRQ() itself trivial to unify now.  But the rest looks 
non-trivial: fixup_irqs() is quite different, as is the interrupt stack 
stuff.

Hm, what does asmlinkage do on x86-64?

    J

Subject: x86: unify do_IRQ()

With the differences in interrupt handling hoisted into handle_irq(),
do_IRQ is more or less identical between 32 and 64 bit, so unify it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/irq.h |    1 -
 arch/x86/kernel/irq.c      |   41 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/irq_32.c   |   27 ---------------------------
 arch/x86/kernel/irq_64.c   |   33 ---------------------------------
 4 files changed, 41 insertions(+), 61 deletions(-)

===================================================================
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -36,7 +36,6 @@
 extern void fixup_irqs(cpumask_t map);
 #endif
 
-extern unsigned int do_IRQ(struct pt_regs *regs);
 extern void init_IRQ(void);
 extern void native_init_IRQ(void);
 extern bool handle_irq(unsigned irq, struct pt_regs *regs);
===================================================================
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -5,10 +5,12 @@
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/seq_file.h>
+#include <linux/ftrace.h>
 
 #include <asm/apic.h>
 #include <asm/io_apic.h>
 #include <asm/smp.h>
+#include <asm/idle.h>
 
 atomic_t irq_err_count;
 
@@ -195,3 +197,42 @@
 #endif
 	return sum;
 }
+
+
+/*
+ * do_IRQ handles all normal device IRQ's (the special
+ * SMP cross-CPU interrupts have their own specific
+ * handlers).
+ */
+#ifdef CONFIG_X86_64
+asmlinkage
+#endif
+unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	/* high bit used in ret_from_ code  */
+	unsigned vector = ~regs->orig_ax;
+	unsigned irq;
+
+	exit_idle();
+	irq_enter();
+
+	irq = __get_cpu_var(vector_irq)[vector];
+
+	if (!handle_irq(irq, regs)) {
+#ifdef CONFIG_X86_64
+		if (!disable_apic)
+			ack_APIC_irq();
+#endif
+
+		if (printk_ratelimit())
+			printk(KERN_EMERG "%s: %d.%d No irq handler for vector (irq %d)\n",
+			       __func__, smp_processor_id(), vector, irq);
+	}
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
+	return 1;
+}
===================================================================
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -211,33 +211,6 @@
 	return true;
 }
 
-/*
- * do_IRQ handles all normal device IRQ's (the special
- * SMP cross-CPU interrupts have their own specific
- * handlers).
- */
-unsigned int do_IRQ(struct pt_regs *regs)
-{
-	struct pt_regs *old_regs;
-	/* high bit used in ret_from_ code */
-	unsigned vector = ~regs->orig_ax;
-	unsigned irq;
-
-	old_regs = set_irq_regs(regs);
-	irq_enter();
-	irq = __get_cpu_var(vector_irq)[vector];
-
-	if (!handle_irq(irq, regs)) {
-		printk(KERN_EMERG "%s: cannot handle IRQ %d vector %#x cpu %d\n",
-					__func__, irq, vector, smp_processor_id());
-		BUG();
-	}
-
-	irq_exit();
-	set_irq_regs(old_regs);
-	return 1;
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 #include <mach_apic.h>
 
===================================================================
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -55,39 +55,6 @@
 	return true;
 }
 
-/*
- * do_IRQ handles all normal device IRQ's (the special
- * SMP cross-CPU interrupts have their own specific
- * handlers).
- */
-asmlinkage unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
-{
-	struct pt_regs *old_regs = set_irq_regs(regs);
-
-	/* high bit used in ret_from_ code  */
-	unsigned vector = ~regs->orig_ax;
-	unsigned irq;
-
-	exit_idle();
-	irq_enter();
-
-	irq = __get_cpu_var(vector_irq)[vector];
-
-	if (!handle_irq(irq, regs)) {
-		if (!disable_apic)
-			ack_APIC_irq();
-
-		if (printk_ratelimit())
-			printk(KERN_EMERG "%s: %d.%d No irq handler for vector\n",
-				__func__, smp_processor_id(), vector);
-	}
-
-	irq_exit();
-
-	set_irq_regs(old_regs);
-	return 1;
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 void fixup_irqs(cpumask_t map)
 {


