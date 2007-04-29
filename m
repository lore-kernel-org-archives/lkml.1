Return-Path: <linux-kernel-owner+w=401wt.eu-S1161597AbXD2XvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161597AbXD2XvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161603AbXD2XrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:47:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:38478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161600AbXD2Xq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:27 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/26] i386: Add smp_ops interface
Message-Id: <20070429234609.BE731151C5@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Add smp_ops interface

Add a smp_ops interface.  This abstracts the API defined by
<linux/smp.h> for use within arch/i386.  The primary intent is that it
be used by a paravirtualizing hypervisor to implement SMP, but it
could also be used by non-APIC-using sub-architectures.

This is related to CONFIG_PARAVIRT, but is implemented unconditionally
since it is simpler that way and not a highly performance-sensitive
interface.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

---
 arch/i386/kernel/smp.c     |   21 +++++++++++++----
 arch/i386/kernel/smpboot.c |    8 +++---
 include/asm-i386/smp.h     |   53 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 9 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/smp.c
===================================================================
--- linux.orig/arch/i386/kernel/smp.c
+++ linux/arch/i386/kernel/smp.c
@@ -483,7 +483,7 @@ void flush_tlb_all(void)
  * it goes straight through and wastes no time serializing
  * anything. Worst case is that we lose a reschedule ...
  */
-void smp_send_reschedule(int cpu)
+void native_smp_send_reschedule(int cpu)
 {
 	WARN_ON(cpu_is_offline(cpu));
 	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
@@ -560,9 +560,9 @@ static void __smp_call_function(void (*f
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int smp_call_function_mask(cpumask_t mask,
-			   void (*func)(void *), void *info,
-			   int wait)
+int native_smp_call_function_mask(cpumask_t mask,
+				  void (*func)(void *), void *info,
+				  int wait)
 {
 	struct call_data_struct data;
 	cpumask_t allbutself;
@@ -681,7 +681,7 @@ static void stop_this_cpu (void * dummy)
  * this function calls the 'stop' function on all other CPUs in the system.
  */
 
-void smp_send_stop(void)
+void native_smp_send_stop(void)
 {
 	/* Don't deadlock on the call lock in panic */
 	int nolock = !spin_trylock(&call_lock);
@@ -757,3 +757,14 @@ int safe_smp_processor_id(void)
 
 	return cpuid >= 0 ? cpuid : 0;
 }
+
+struct smp_ops smp_ops = {
+	.smp_prepare_boot_cpu = native_smp_prepare_boot_cpu,
+	.smp_prepare_cpus = native_smp_prepare_cpus,
+	.cpu_up = native_cpu_up,
+	.smp_cpus_done = native_smp_cpus_done,
+
+	.smp_send_stop = native_smp_send_stop,
+	.smp_send_reschedule = native_smp_send_reschedule,
+	.smp_call_function_mask = native_smp_call_function_mask,
+};
Index: linux/arch/i386/kernel/smpboot.c
===================================================================
--- linux.orig/arch/i386/kernel/smpboot.c
+++ linux/arch/i386/kernel/smpboot.c
@@ -1171,7 +1171,7 @@ static void __init smp_boot_cpus(unsigne
 
 /* These are wrappers to interface to the new boot process.  Someone
    who understands all this stuff should rewrite it properly. --RR 15/Jul/02 */
-void __init smp_prepare_cpus(unsigned int max_cpus)
+void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
 	smp_commenced_mask = cpumask_of_cpu(0);
 	cpu_callin_map = cpumask_of_cpu(0);
@@ -1191,7 +1191,7 @@ static inline void switch_to_new_gdt(voi
 	asm volatile ("mov %0, %%fs" : : "r" (__KERNEL_PDA) : "memory");
 }
 
-void __init smp_prepare_boot_cpu(void)
+void __init native_smp_prepare_boot_cpu(void)
 {
 	unsigned int cpu = smp_processor_id();
 
@@ -1292,7 +1292,7 @@ void __cpu_die(unsigned int cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit native_cpu_up(unsigned int cpu)
 {
 	unsigned long flags;
 #ifdef CONFIG_HOTPLUG_CPU
@@ -1337,7 +1337,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	return 0;
 }
 
-void __init smp_cpus_done(unsigned int max_cpus)
+void __init native_smp_cpus_done(unsigned int max_cpus)
 {
 #ifdef CONFIG_X86_IO_APIC
 	setup_ioapic_dest();
Index: linux/include/asm-i386/smp.h
===================================================================
--- linux.orig/include/asm-i386/smp.h
+++ linux/include/asm-i386/smp.h
@@ -49,6 +49,59 @@ extern void cpu_exit_clear(void);
 extern void cpu_uninit(void);
 #endif
 
+struct smp_ops
+{
+	void (*smp_prepare_boot_cpu)(void);
+	void (*smp_prepare_cpus)(unsigned max_cpus);
+	int (*cpu_up)(unsigned cpu);
+	void (*smp_cpus_done)(unsigned max_cpus);
+
+	void (*smp_send_stop)(void);
+	void (*smp_send_reschedule)(int cpu);
+	int (*smp_call_function_mask)(cpumask_t mask,
+				      void (*func)(void *info), void *info,
+				      int wait);
+};
+
+extern struct smp_ops smp_ops;
+
+static inline void smp_prepare_boot_cpu(void)
+{
+	smp_ops.smp_prepare_boot_cpu();
+}
+static inline void smp_prepare_cpus(unsigned int max_cpus)
+{
+	smp_ops.smp_prepare_cpus(max_cpus);
+}
+static inline int __cpu_up(unsigned int cpu)
+{
+	return smp_ops.cpu_up(cpu);
+}
+static inline void smp_cpus_done(unsigned int max_cpus)
+{
+	smp_ops.smp_cpus_done(max_cpus);
+}
+
+static inline void smp_send_stop(void)
+{
+	smp_ops.smp_send_stop();
+}
+static inline void smp_send_reschedule(int cpu)
+{
+	smp_ops.smp_send_reschedule(cpu);
+}
+static inline int smp_call_function_mask(cpumask_t mask,
+					 void (*func) (void *info), void *info,
+					 int wait)
+{
+	return smp_ops.smp_call_function_mask(mask, func, info, wait);
+}
+
+void native_smp_prepare_boot_cpu(void);
+void native_smp_prepare_cpus(unsigned int max_cpus);
+int native_cpu_up(unsigned int cpunum);
+void native_smp_cpus_done(unsigned int max_cpus);
+
 #ifndef CONFIG_PARAVIRT
 #define startup_ipi_hook(phys_apicid, start_eip, start_esp) 		\
 do { } while (0)
