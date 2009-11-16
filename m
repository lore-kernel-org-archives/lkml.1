Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbZKPWvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbZKPWvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZKPWvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:51:43 -0500
Received: from relay3.sgi.com ([192.48.152.1]:53810 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750995AbZKPWvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:51:42 -0500
Message-ID: <4B01D77D.3010006@sgi.com>
Date: Mon, 16 Nov 2009 14:51:41 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] INIT: Limit the number of per cpu calibration bootup
 messages
References: <20091116210718.412792000@alcatraz.americas.sgi.com> <20091116210728.267482000@alcatraz.americas.sgi.com> <20091116212427.GC2221@elte.hu> <4B01C803.1010303@sgi.com> <4B01C8B5.7060903@zytor.com>
In-Reply-To: <4B01C8B5.7060903@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



H. Peter Anvin wrote:
> On 11/16/2009 01:45 PM, Mike Travis wrote:
>>
>> Ingo Molnar wrote:
>>> * Mike Travis <travis@sgi.com> wrote:
>>>
>>>> --- linux.orig/init/calibrate.c
>>>> +++ linux/init/calibrate.c
>>>> @@ -123,23 +123,26 @@
>>>>  {
>>>>  	unsigned long ticks, loopbit;
>>>>  	int lps_precision = LPS_PREC;
>>>> +	bool boot_cpu = (smp_processor_id() == 0);
>>> this code is shared by other architectures too - are you sure 
>>> smp_processor_id()==0 is a proper 'I am the boot CPU' assumption 
>>> everywhere?
>>>
>>> 	Ingo
>> This was where having the boot_cpu_id would have been handy.
>>
>> I could add something like:
>>
>> --- linux.orig/init/main.c
>> +++ linux/init/main.c
>> @@ -539,13 +539,15 @@
>>   *     Activate the first processor.
>>   */
>>
>> +int boot_cpu_id __read_mostly;
>    ^^^^^^^^^^^^^^^
>> +
>>  static void __init boot_cpu_init(void)
>>  {
>> -       int cpu = smp_processor_id();
>> +       int boot_cpu_id = smp_processor_id();
>           ^^^^^^^^^^^^^^^
>>         /* Mark the boot cpu "present", "online" etc for SMP and UP case */
> 
> Doesn't really work, does it?
> 
> I also still think that wrapping it in an inline would be good.
> 
> 	-hpa

Yes, a bit quick on the reply button.  But the proposal was clear enough?

I've just looked at this, and there are many, many references in arch-specific
code to a scalar "boot_cpu_id".  Maybe a better approach would be to add an
inline named something else?  get_boot_cpu_id() perhaps?  Or an inline
function "is_boot_cpu()" ... ?

There's also some confusion on whether the boot_cpu_id is the APIC id (ia64)
or the cpu_index (x86) or some other number (others).   (cpu_index 0 by
definition will always be the boot cpu.)

Here's an initial stab (by no means complete) at adding boot_cpu_id().  As
you can see the reach is quite extensive.


INIT: Identify processor id of boot cpu

Provide an architecture-independent means of identifying
the boot cpu's processor id.

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/alpha/kernel/smp.c        |    2 +-
 arch/sparc/kernel/smp_32.c     |    1 -
 arch/x86/include/asm/cpu.h     |    2 --
 arch/x86/kernel/apic/io_apic.c |   10 +++++-----
 arch/x86/kernel/cpu/amd.c      |    2 +-
 arch/x86/kernel/cpu/common.c   |    4 ++--
 arch/x86/kernel/cpu/intel.c    |    2 +-
 arch/x86/kernel/setup.c        |    2 --
 arch/x86/kernel/setup_percpu.c |    4 ++--
 include/linux/smp.h            |   13 +++++++++++++
 init/main.c                    |   12 +++++++-----
 11 files changed, 32 insertions(+), 22 deletions(-)

--- linux.orig/arch/alpha/kernel/smp.c
+++ linux/arch/alpha/kernel/smp.c
@@ -633,7 +633,7 @@
 	cpumask_t to_whom = cpu_possible_map;
 	cpu_clear(smp_processor_id(), to_whom);
 #ifdef DEBUG_IPI_MSG
-	if (hard_smp_processor_id() != boot_cpu_id)
+	if (hard_smp_processor_id() != boot_cpu_id())
 		printk(KERN_WARNING "smp_send_stop: Not on boot cpu.\n");
 #endif
 	send_ipi_message(&to_whom, IPI_CPU_STOP);
--- linux.orig/arch/sparc/kernel/smp_32.c
+++ linux/arch/sparc/kernel/smp_32.c
@@ -36,7 +36,6 @@
 #include "irq.h"
 
 volatile unsigned long cpu_callin_map[NR_CPUS] __cpuinitdata = {0,};
-unsigned char boot_cpu_id = 0;
 unsigned char boot_cpu_id4 = 0; /* boot_cpu_id << 2 */
 
 cpumask_t smp_commenced_mask = CPU_MASK_NONE;
--- linux.orig/arch/x86/include/asm/cpu.h
+++ linux/arch/x86/include/asm/cpu.h
@@ -32,6 +32,4 @@
 
 DECLARE_PER_CPU(int, cpu_state);
 
-extern unsigned int boot_cpu_id;
-
 #endif /* _ASM_X86_CPU_H */
--- linux.orig/arch/x86/kernel/apic/io_apic.c
+++ linux/arch/x86/kernel/apic/io_apic.c
@@ -197,7 +197,7 @@
 
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
-	node= cpu_to_node(boot_cpu_id);
+	node= cpu_to_node(boot_cpu_id());
 
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
@@ -1496,7 +1496,7 @@
 	int notcon = 0;
 	struct irq_desc *desc;
 	struct irq_cfg *cfg;
-	int node = cpu_to_node(boot_cpu_id);
+	int node = cpu_to_node(boot_cpu_id());
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "init IO_APIC IRQs\n");
 
@@ -2828,7 +2828,7 @@
 {
 	struct irq_desc *desc = irq_to_desc(0);
 	struct irq_cfg *cfg = desc->chip_data;
-	int node = cpu_to_node(boot_cpu_id);
+	int node = cpu_to_node(boot_cpu_id());
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
 	int no_pin1 = 0;
@@ -3184,7 +3184,7 @@
 
 int create_irq(void)
 {
-	int node = cpu_to_node(boot_cpu_id);
+	int node = cpu_to_node(boot_cpu_id());
 	unsigned int irq_want;
 	int irq;
 
@@ -3861,7 +3861,7 @@
 	if (dev)
 		node = dev_to_node(dev);
 	else
-		node = cpu_to_node(boot_cpu_id);
+		node = cpu_to_node(boot_cpu_id());
 
 	desc = irq_to_desc_alloc_node(irq, node);
 	if (!desc) {
--- linux.orig/arch/x86/kernel/cpu/amd.c
+++ linux/arch/x86/kernel/cpu/amd.c
@@ -148,7 +148,7 @@
 {
 #ifdef CONFIG_SMP
 	/* calling is from identify_secondary_cpu() ? */
-	if (c->cpu_index == boot_cpu_id)
+	if (raw_smp_processor_id() == boot_cpu_id())
 		return;
 
 	/*
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -649,7 +649,7 @@
 		this_cpu->c_early_init(c);
 
 #ifdef CONFIG_SMP
-	c->cpu_index = boot_cpu_id;
+	c->cpu_index = boot_cpu_id();
 #endif
 	filter_cpuid_features(c, false);
 }
@@ -1251,7 +1251,7 @@
 	/*
 	 * Boot processor to setup the FP and extended state context info.
 	 */
-	if (smp_processor_id() == boot_cpu_id)
+	if (smp_processor_id() == boot_cpu_id())
 		init_thread_xstate();
 
 	xsave_init();
--- linux.orig/arch/x86/kernel/cpu/intel.c
+++ linux/arch/x86/kernel/cpu/intel.c
@@ -149,7 +149,7 @@
 {
 #ifdef CONFIG_SMP
 	/* calling is from identify_secondary_cpu() ? */
-	if (c->cpu_index == boot_cpu_id)
+	if (raw_smp_processor_id() == boot_cpu_id())
 		return;
 
 	/*
--- linux.orig/arch/x86/kernel/setup.c
+++ linux/arch/x86/kernel/setup.c
@@ -120,8 +120,6 @@
 
 RESERVE_BRK(dmi_alloc, 65536);
 
-unsigned int boot_cpu_id __read_mostly;
-
 static __initdata unsigned long _brk_start = (unsigned long)__brk_base;
 unsigned long _brk_end = (unsigned long)__brk_base;
 
--- linux.orig/arch/x86/kernel/setup_percpu.c
+++ linux/arch/x86/kernel/setup_percpu.c
@@ -243,7 +243,7 @@
 		 * Up to this point, the boot CPU has been using .data.init
 		 * area.  Reload any changed state for the boot CPU.
 		 */
-		if (cpu == boot_cpu_id)
+		if (cpu == boot_cpu_id())
 			switch_to_new_gdt(cpu);
 	}
 
@@ -261,7 +261,7 @@
 	 * make sure boot cpu node_number is right, when boot cpu is on the
 	 * node that doesn't have mem installed
 	 */
-	per_cpu(node_number, boot_cpu_id) = cpu_to_node(boot_cpu_id);
+	per_cpu(node_number, boot_cpu_id()) = cpu_to_node(boot_cpu_id());
 #endif
 
 	/* Setup node to cpumask map */
--- linux.orig/include/linux/smp.h
+++ linux/include/linux/smp.h
@@ -109,6 +109,17 @@
  */
 void smp_prepare_boot_cpu(void);
 
+/*
+ * Identify processor ID of boot cpu
+ */
+extern int _boot_cpu_id;
+
+static inline int boot_cpu_id(void)
+{
+	return _boot_cpu_id;
+}
+
+
 extern unsigned int setup_max_cpus;
 
 #else /* !SMP */
@@ -119,6 +130,8 @@
  *	These macros fold the SMP functionality into a single CPU system
  */
 #define raw_smp_processor_id()			0
+#define	boot_cpu_id()				0
+
 static inline int up_smp_call_function(void (*func)(void *), void *info)
 {
 	return 0;
--- linux.orig/init/main.c
+++ linux/init/main.c
@@ -538,14 +538,16 @@
 /*
  *	Activate the first processor.
  */
+int _boot_cpu_id __read_mostly;
+EXPORT_SYMBOL(_boot_cpu_id);
 
-static void __init boot_cpu_init(void)
+void __init __weak boot_cpu_init(void)
 {
-	int cpu = smp_processor_id();
 	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
-	set_cpu_online(cpu, true);
-	set_cpu_present(cpu, true);
-	set_cpu_possible(cpu, true);
+	_boot_cpu_id = raw_smp_processor_id();
+	set_cpu_online(_boot_cpu_id, true);
+	set_cpu_present(_boot_cpu_id, true);
+	set_cpu_possible(_boot_cpu_id, true);
 }
 
 void __init __weak smp_setup_processor_id(void)
