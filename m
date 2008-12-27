Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYL0Hke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYL0Hke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 02:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYL0HkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 02:40:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:51242 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbYL0HkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 02:40:24 -0500
Message-ID: <4955DBBC.4070508@kernel.org>
Date: Fri, 26 Dec 2008 23:39:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333	smp_call_function_mask
References: <495153A4.5060201@kernel.org> <20081224163400.GA11562@linux.vnet.ibm.com> <49529CE1.4040005@kernel.org> <20081226091217.GA5100@linux.vnet.ibm.com> <4954AC7B.3020603@kernel.org> <20081226102716.GA31450@uranus.ravnborg.org> <20081226152804.GB5100@linux.vnet.ibm.com> <20081226153318.GA4514@elte.hu> <20081226170452.GC5100@linux.vnet.ibm.com> <20081226181733.GA24439@elte.hu> <20081227071138.GA4530@linux.vnet.ibm.com>
In-Reply-To: <20081227071138.GA4530@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> * Ingo Molnar <mingo@elte.hu> [2008-12-26 19:17:34]:
> 
>> * Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>
>>>> how about the patch below, does that work too? (after removing 
>>>> Yinghai's patch)
>>> Hi Ingo,
>>>
>>> 	Kernel crashes with the same trace, after the applying the patch.
>> okay, thanks - does the below cleaner variant of Yinghai's patch solve the 
>> problem too?
>>
>> 	Ingo
>>
>> -------------------->
>> From 9c93fc72ec95dc97d65b840978f9d605f4e5823a Mon Sep 17 00:00:00 2001
>> From: Yinghai Lu <yinghai@kernel.org>
>> Date: Fri, 26 Dec 2008 02:05:47 -0800
>> Subject: [PATCH] sparseirq: work around compiler optimizing away __weak functions
>>
>> Impact: fix panic on null pointer with sparseirq
>>
>> Some GCC versions seem to inline the weak global function,
>> when that function is empty.
>>
>> Work it around, by putting a barrier into the function.
>>
>> Signed-off-by: Yinghai <yinghai@kernel.org>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  init/main.c         |    9 +++++++++
>>  kernel/irq/handle.c |    3 ++-
>>  2 files changed, 11 insertions(+), 1 deletions(-)
>>
>> diff --git a/init/main.c b/init/main.c
>> index c1f999a..841d2b2 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -531,20 +531,29 @@ static void __init boot_cpu_init(void)
>>  	cpu_set(cpu, cpu_possible_map);
>>  }
>>
>> +/*
>> + * The barriers are needed to keep a GCC bug from optimizing
>> + * away these weak functions:
>> + */
>> +
>>  void __init __weak smp_setup_processor_id(void)
>>  {
>> +	barrier();
>>  }
>>
>>  void __init __weak thread_info_cache_init(void)
>>  {
>> +	barrier();
>>  }
>>
>>  void __init __weak arch_early_irq_init(void)
>>  {
>> +	barrier();
>>  }
>>
>>  void __init __weak early_irq_init(void)
>>  {
>> +	barrier();
>>  	arch_early_irq_init();
>>  }
>>
>> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
>> index 06b05a4..a6d16a4 100644
>> --- a/kernel/irq/handle.c
>> +++ b/kernel/irq/handle.c
>> @@ -86,8 +86,9 @@ void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
>>  		desc->kstat_irqs = (unsigned int *)ptr;
>>  }
>>
>> -void __attribute__((weak)) arch_init_chip_data(struct irq_desc *desc, int cpu)
>> +void __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
>>  {
>> +	barrier();
>>  }
>>
>>  static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
>> --
> 
> Hi Ingo,
> 
> 	Kernel still crashes after applying the patch,

please try it again...

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 0fb91df..1f164a1 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -170,7 +170,7 @@ static struct irq_cfg irq_cfgx[NR_IRQS] = {
 	[15] = { .vector = IRQ15_VECTOR, },
 };
 
-void __init arch_early_irq_init(void)
+int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
@@ -188,6 +188,8 @@ void __init arch_early_irq_init(void)
 		if (i < NR_IRQS_LEGACY)
 			cpumask_setall(cfg[i].domain);
 	}
+
+	return 0;
 }
 
 #ifdef CONFIG_SPARSE_IRQ
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7bac2d4..8337e58 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -194,9 +194,9 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
-extern void early_irq_init(void);
-extern void arch_early_irq_init(void);
-extern void arch_init_chip_data(struct irq_desc *desc, int cpu);
+extern int early_irq_init(void);
+extern int arch_early_irq_init(void);
+extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
 extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
 					struct irq_desc *desc, int cpu);
 extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
diff --git a/init/main.c b/init/main.c
index 5149dbd..9e2fafd 100644
--- a/init/main.c
+++ b/init/main.c
@@ -549,15 +549,14 @@ void __init __weak thread_info_cache_init(void)
 	barrier();
 }
 
-void __init __weak arch_early_irq_init(void)
+int __init __weak arch_early_irq_init(void)
 {
-	barrier();
+	return 0;
 }
 
-void __init __weak early_irq_init(void)
+int __init __weak early_irq_init(void)
 {
-	barrier();
-	arch_early_irq_init();
+	return arch_early_irq_init();
 }
 
 asmlinkage void __init start_kernel(void)
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 925e36c..0bef3ec 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -86,9 +86,9 @@ void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
 		desc->kstat_irqs = (unsigned int *)ptr;
 }
 
-void __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
+int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
 {
-	barrier();
+	return 0;
 }
 
 static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
@@ -133,7 +133,7 @@ static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_sm
 /* FIXME: use bootmem alloc ...*/
 static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
 
-void __init early_irq_init(void)
+int __init early_irq_init(void)
 {
 	struct irq_desc *desc;
 	int legacy_count;
@@ -152,7 +152,7 @@ void __init early_irq_init(void)
 	for (i = legacy_count; i < NR_IRQS; i++)
 		irq_desc_ptrs[i] = NULL;
 
-	arch_early_irq_init();
+	return arch_early_irq_init();
 }
 
 struct irq_desc *irq_to_desc(unsigned int irq)
