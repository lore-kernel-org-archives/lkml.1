Return-Path: <linux-kernel-owner+w=401wt.eu-S934208AbXC0WJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208AbXC0WJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934210AbXC0WJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:09:45 -0400
Received: from gw.goop.org ([64.81.55.164]:36492 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934208AbXC0WJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:09:44 -0400
Message-ID: <46099624.30606@goop.org>
Date: Tue, 27 Mar 2007 15:09:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Zachary Amsden <zach@vmware.com>
Subject: [PATCH] Add smp_ops interface
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a smp_ops interface.  This abstracts the API defined by
<linux/smp.h> for use within arch/i386.  The primary intent is that it
be used by a paravirtualizing hypervisor to implement SMP, but it
could also be used by non-APIC-using sub-architectures.

This is related to CONFIG_PARAVIRT, but is implemented unconditionally
since it is simpler that way and not a highly performance-sensitive
interface.

[ Andrew: Patch is based on 2.6.21-rc5-mm1 + the pda->percpu patch I
  posted the other day.  It will have a minor context conflict without
  that patch, but is otherwise standalone. ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

---
 arch/i386/kernel/smp.c     |   21 +++++++++++++----
 arch/i386/kernel/smpboot.c |    8 +++---
 include/asm-i386/smp.h     |   53 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 9 deletions(-)

===================================================================
--- a/arch/i386/kernel/smp.c
+++ b/arch/i386/kernel/smp.c
@@ -483,7 +483,7 @@ void flush_tlb_all(void)
  * it goes straight through and wastes no time serializing
  * anything. Worst case is that we lose a reschedule ...
  */
-void smp_send_reschedule(int cpu)
+void native_smp_send_reschedule(int cpu)
 {
 	WARN_ON(cpu_is_offline(cpu));
 	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
@@ -576,9 +576,9 @@ static int __smp_call_function_mask(cpum
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int smp_call_function_mask(cpumask_t mask,
-			     void (*func)(void *), void *info,
-			     int wait)
+int native_smp_call_function_mask(cpumask_t mask,
+				  void (*func)(void *), void *info,
+				  int wait)
 {
 	int ret;
 
@@ -657,7 +657,7 @@ static void stop_this_cpu (void * dummy)
  * this function calls the 'stop' function on all other CPUs in the system.
  */
 
-void smp_send_stop(void)
+void native_smp_send_stop(void)
 {
 	/* Don't deadlock on the call lock in panic */
 	int nolock = !spin_trylock(&call_lock);
@@ -733,3 +733,14 @@ int safe_smp_processor_id(void)
 
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
===================================================================
--- a/arch/i386/kernel/smpboot.c
+++ b/arch/i386/kernel/smpboot.c
@@ -1169,7 +1169,7 @@ static void __init smp_boot_cpus(unsigne
 
 /* These are wrappers to interface to the new boot process.  Someone
    who understands all this stuff should rewrite it properly. --RR 15/Jul/02 */
-void __init smp_prepare_cpus(unsigned int max_cpus)
+void __init native_smp_prepare_cpus(unsigned int max_cpus)
 {
 	smp_commenced_mask = cpumask_of_cpu(0);
 	cpu_callin_map = cpumask_of_cpu(0);
@@ -1189,7 +1189,7 @@ static inline void switch_to_new_gdt(voi
 	asm ("mov %0, %%fs" : : "r" (__KERNEL_PERCPU) : "memory");
 }
 
-void __init smp_prepare_boot_cpu(void)
+void __init native_smp_prepare_boot_cpu(void)
 {
 	unsigned int cpu = smp_processor_id();
 
@@ -1290,7 +1290,7 @@ void __cpu_die(unsigned int cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit native_cpu_up(unsigned int cpu)
 {
 	unsigned long flags;
 #ifdef CONFIG_HOTPLUG_CPU
@@ -1335,7 +1335,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	return 0;
 }
 
-void __init smp_cpus_done(unsigned int max_cpus)
+void __init native_smp_cpus_done(unsigned int max_cpus)
 {
 #ifdef CONFIG_X86_IO_APIC
 	setup_ioapic_dest();
===================================================================
--- a/include/asm-i386/smp.h
+++ b/include/asm-i386/smp.h
@@ -47,6 +47,59 @@ extern void cpu_exit_clear(void);
 extern void cpu_exit_clear(void);
 extern void cpu_uninit(void);
 #endif
+
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
 
 #ifndef CONFIG_PARAVIRT
 #define startup_ipi_hook(phys_apicid, start_eip, start_esp) 		\

