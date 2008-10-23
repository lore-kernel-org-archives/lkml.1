Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYJWWaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYJWWaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYJWW37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:29:59 -0400
Received: from ozlabs.org ([203.10.76.45]:55404 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbYJWW36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:29:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [bug #2] Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct cpumask
Date: Fri, 24 Oct 2008 09:29:46 +1100
User-Agent: KMail/1.9.10
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <49009639.3050603@sgi.com> <20081023160959.GB8853@elte.hu>
In-Reply-To: <20081023160959.GB8853@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240929.46985.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2008 03:09:59 Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> > Rusty Russell wrote:
> > > On Friday 24 October 2008 01:20:25 Ingo Molnar wrote:
> > >> Thomas has started a -tip cross-build test, and there's massive
> > >> cross-build failures as well due to the cpumask changes:
> > >
> > > Yes.  linux-next reported the same thing.  I've backed out various arch
> > > changes for this reason.
> > >
> > >> it seems to me that this commit is massively borked:
> > >>
> > >>   4a792c2: cpumask: make CONFIG_NR_CPUS always valid
> > >
> > > Yep.  This is the big one I dropped.  There are a few others; Mike is
> > > just porting the changes across to your tree now.
> > >
> > > Cheers,
> > > Rusty.
> >
> > Hi Ingo,
> >
> > It would seem easier to back out previous patches and apply the
> > replacements. Does this work for you?
>
> no, it does not work fine. As i said, i reworked various small bits
> along the way of reviewing and integrating them, under the obvious
> assumption that you submitted the latest and greatest. I spent hours
> testing every single step as well. If you cannot get your workflow right
> then we cannot have this stuff in v2.6.28.

Indeed, though to be honest it's been easier to do the fixes in linux-next.

Here's the interdiff; it's not too bad (you already reverted the
arch-destroying config changes).

Summary:
1) Alpha defines cpu_possible_map to cpu_present_map: this isn't possible
   under centralization, so just manipulate both together.
2) IA64, cris and m32r gratuitously re-declared cpu_possible_map; remove.
3) PowerPC Cell used __cpu_setall in a questionable way.
   Arnd approved this version.
4) That also leads to weakening the BUG_ON() to WARN_ON_ONCE() for
   CONFIG_DEBUG_PER_CPU_MAPS; Arnd wants to be reminded, but only once :)
5) Revert most of S390 smp_call_function_mask->smp_call_function_many: it's
   safer to just do the minimal conversion.
6) Remove __deprecated from smp_call_function_mask: we're not pushing
   replacement patches yet so it's not appropriate, and it breaks sparc64
   which compiles arch/sparc with -Werror.
7) Hack header to set CONFIG_NR_CPUS for UP on archs; safer than touching
   Kconfigs for them.  Also update comment.

Thanks,
Rusty.

diff --git a/arch/alpha/include/asm/smp.h b/arch/alpha/include/asm/smp.h
index 544c69a..547e909 100644
--- a/arch/alpha/include/asm/smp.h
+++ b/arch/alpha/include/asm/smp.h
@@ -45,7 +45,6 @@ extern struct cpuinfo_alpha cpu_data[NR_CPUS];
 #define raw_smp_processor_id()	(current_thread_info()->cpu)
 
 extern int smp_num_cpus;
-#define cpu_possible_map	cpu_present_map
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi(cpumask_t mask);
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 351407e..f238370 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -94,6 +94,7 @@ common_shutdown_1(void *generic_ptr)
 		flags |= 0x00040000UL; /* "remain halted" */
 		*pflags = flags;
 		cpu_clear(cpuid, cpu_present_map);
+		cpu_clear(cpuid, cpu_possible_map);
 		halt();
 	}
 #endif
@@ -120,6 +121,7 @@ common_shutdown_1(void *generic_ptr)
 #ifdef CONFIG_SMP
 	/* Wait for the secondaries to halt. */
 	cpu_clear(boot_cpuid, cpu_present_map);
+	cpu_clear(boot_cpuid, cpu_possible_map);
 	while (cpus_weight(cpu_present_map))
 		barrier();
 #endif
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index ac26335..ce6791a 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -435,6 +435,7 @@ setup_smp(void)
 				((char *)cpubase + i*hwrpb->processor_size);
 			if ((cpu->flags & 0x1cc) == 0x1cc) {
 				smp_num_probed++;
+				cpu_set(i, cpu_possible_map);
 				cpu_set(i, cpu_present_map);
 				cpu->pal_revision = boot_cpu_palrev;
 			}
@@ -468,6 +469,7 @@ smp_prepare_cpus(unsigned int max_cpus)
 
 	/* Nothing to do on a UP box, or when told not to.  */
 	if (smp_num_probed == 1 || max_cpus == 0) {
+		cpu_possible_map = cpumask_of_cpu(boot_cpuid);
 		cpu_present_map = cpumask_of_cpu(boot_cpuid);
 		printk(KERN_INFO "SMP mode deactivated.\n");
 		return;
diff --git a/arch/ia64/include/asm/smp.h b/arch/ia64/include/asm/smp.h
index 12d96e0..21c4023 100644
--- a/arch/ia64/include/asm/smp.h
+++ b/arch/ia64/include/asm/smp.h
@@ -57,7 +57,6 @@ extern struct smp_boot_data {
 
 extern char no_int_routing __devinitdata;
 
-extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_core_map[NR_CPUS];
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 extern int smp_num_siblings;
diff --git a/arch/powerpc/platforms/cell/spu_base.c b/arch/powerpc/platforms/cell/spu_base.c
index a5bdb89..402c183 100644
--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -111,10 +111,11 @@ void spu_flush_all_slbs(struct mm_struct *mm)
  */
 static inline void mm_needs_global_tlbie(struct mm_struct *mm)
 {
-	int nr = (NR_CPUS > 1) ? NR_CPUS : NR_CPUS + 1;
+	cpumask_setall(&mm->cpu_vm_mask);
 
 	/* Global TLBIE broadcast required with SPEs. */
-	__cpus_setall(&mm->cpu_vm_mask, nr);
+	if (nr_cpu_ids == 1)
+		cpumask_set_cpu(1, &mm->cpu_vm_mask);
 }
 
 void spu_associate_mm(struct spu *spu, struct mm_struct *mm)
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 10e7f97..29a3eb1 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -103,7 +103,7 @@ static void do_call_function(void)
 }
 
 static void __smp_call_function_map(void (*func) (void *info), void *info,
-				    int wait, struct cpumask *map)
+				    int wait, cpumask_t map)
 {
 	struct call_data_struct data;
 	int cpu, local = 0;
@@ -163,16 +163,14 @@ out:
  * You must not call this function with disabled interrupts, from a
  * hardware interrupt handler or from a bottom half.
  */
-
-/* protected by call_lock */
-static DEFINE_BITMAP(smp_call_map, CONFIG_NR_CPUS);
-
 int smp_call_function(void (*func) (void *info), void *info, int wait)
 {
+	cpumask_t map;
+
 	spin_lock(&call_lock);
-	cpumask_copy(to_cpumask(smp_call_map), cpu_online_mask);
-	cpumask_clear_cpu(smp_processor_id(), to_cpumask(smp_call_map));
-	__smp_call_function_map(func, info, wait, to_cpumask(smp_call_map));
+	map = cpu_online_map;
+	cpu_clear(smp_processor_id(), map);
+	__smp_call_function_map(func, info, wait, map);
 	spin_unlock(&call_lock);
 	return 0;
 }
@@ -194,8 +192,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 			     int wait)
 {
 	spin_lock(&call_lock);
-	cpumask_copy(to_cpumask(smp_call_map), cpumask_of(cpu));
-	__smp_call_function_map(func, info, wait, cpumask_of(cpu));
+	__smp_call_function_map(func, info, wait, cpumask_of_cpu(cpu));
 	spin_unlock(&call_lock);
 	return 0;
 }
@@ -216,13 +213,13 @@ EXPORT_SYMBOL(smp_call_function_single);
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int smp_call_function_many(const struct cpumask *mask,
+int smp_call_function_many(const struct cpumask *maskp,
 			   void (*func)(void *), void *info, bool wait)
 {
+	cpumask_t mask = *maskp;
 	spin_lock(&call_lock);
-	cpumask_copy(to_cpumask(smp_call_map), cpu_online_mask);
-	cpumask_clear_cpu(smp_processor_id(), to_cpumask(smp_call_map));
-	__smp_call_function_map(func, info, wait, to_cpumask(smp_call_map));
+	cpu_clear(smp_processor_id(), mask);
+	__smp_call_function_map(func, info, wait, mask);
 	spin_unlock(&call_lock);
 	return 0;
 }
diff --git a/include/asm-cris/smp.h b/include/asm-cris/smp.h
index dba33ab..c615a06 100644
--- a/include/asm-cris/smp.h
+++ b/include/asm-cris/smp.h
@@ -4,7 +4,6 @@
 #include <linux/cpumask.h>
 
 extern cpumask_t phys_cpu_present_map;
-extern cpumask_t cpu_possible_map;
 
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
diff --git a/include/asm-m32r/smp.h b/include/asm-m32r/smp.h
index c5dd669..b96a6d2 100644
--- a/include/asm-m32r/smp.h
+++ b/include/asm-m32r/smp.h
@@ -63,8 +63,6 @@ extern volatile int cpu_2_physid[NR_CPUS];
 #define raw_smp_processor_id()	(current_thread_info()->cpu)
 
 extern cpumask_t cpu_callout_map;
-extern cpumask_t cpu_possible_map;
-extern cpumask_t cpu_present_map;
 
 static __inline__ int hard_smp_processor_id(void)
 {
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index d1f22ee..295d9e8 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -254,8 +254,7 @@ extern cpumask_t _unused_cpumask_arg_;
 static inline unsigned int cpumask_check(unsigned int cpu)
 {
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
-	/* This breaks at runtime. */
-	BUG_ON(cpu >= nr_cpumask_bits);
+	WARN_ON_ONCE(cpu >= nr_cpumask_bits);
 #endif /* CONFIG_DEBUG_PER_CPU_MAPS */
 	return cpu;
 }
diff --git a/include/linux/smp.h b/include/linux/smp.h
index c7bc2fa..748ebc9 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -71,7 +71,7 @@ int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
 void __smp_call_function_single(int cpuid, struct call_single_data *data);
 
 /* Use smp_call_function_many, which takes a pointer to the mask. */
-static inline int __deprecated
+static inline int
 smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
 		       int wait)
 {
diff --git a/include/linux/threads.h b/include/linux/threads.h
index 38d1a5d..08a0286 100644
--- a/include/linux/threads.h
+++ b/include/linux/threads.h
@@ -8,17 +8,18 @@
  */
 
 /*
- * Maximum supported processors that can run under SMP.  This value is
- * set via configure setting.  The maximum is equal to the size of the
- * bitmasks used on that platform, i.e. 32 or 64.  Setting this smaller
- * saves quite a bit of memory.
+ * Maximum supported processors that can run under SMP.  Setting this smaller
+ * saves quite a bit of memory.  Use nr_cpu_ids instead of this except for
+ * static bitmaps.
  */
-#ifdef CONFIG_SMP
-#define NR_CPUS		CONFIG_NR_CPUS
-#else
-#define NR_CPUS		1
+#ifndef CONFIG_NR_CPUS
+/* FIXME: This should be fixed in the arch's Kconfig */
+#define CONFIG_NR_CPUS	1
 #endif
 
+/* Places which use this should consider cpumask_var_t. */
+#define NR_CPUS		CONFIG_NR_CPUS
+
 #define MIN_THREADS_LEFT_FOR_ROOT 4
 
 /*
