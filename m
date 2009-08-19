Return-Path: <linux-kernel-owner+w=401wt.eu-S1751179AbZHSGVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179AbZHSGVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 02:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbZHSGVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 02:21:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:4367 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbZHSGVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 02:21:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,406,1246863600"; 
   d="scan'208";a="485135767"
Subject: Re: [patch] x86: Rendezvous all the cpu's for MTRR/PAT init
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>, Nick Piggin <npiggin@suse.de>,
       "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090818180107.29d3f39b.akpm@linux-foundation.org>
References: <1250641835.2744.56.camel@sbs-t61.sc.intel.com>
	 <20090818180107.29d3f39b.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 18 Aug 2009 23:20:57 -0700
Message-Id: <1250662857.2615.42.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 18:01 -0700, Andrew Morton wrote:
> On Tue, 18 Aug 2009 17:30:35 -0700 Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > @@ -880,7 +880,12 @@ void __cpuinit identify_secondary_cpu(st
> >  #ifdef CONFIG_X86_32
> >  	enable_sep_cpu();
> >  #endif
> > +	/*
> > +	 * mtrr_ap_init() uses smp_call_function. Enable interrupts.
> > +	 */
> > +	local_irq_enable();
> >  	mtrr_ap_init();
> > +	local_irq_disable();
> >  }
> 
> Ick.

oops. thought it will miss the radar of the sharp eyes. I was wrong :(

> 
> It's quite unobvious (to me) that this function is reliably called with
> local interrupts disabled.
> 
> If it _is_ reliably called with interrupts disabled then why is it safe
> to randomly reenable them here?  Why not just stop disabling interrupts
> at the top level?

identify_secondary_cpu() always get called on APs. And APs have
interrupts disabled at this point. I did this
local_irq_enable()/disable() safely and thought I can getaway because
just before calling this, in smpboot.c in smp_callin() we do this:

	local_irq_enable();
	calibrate_delay();
	local_irq_disable();

So having local_irq_enable()/disable() around mtrr_ap_init() is safe.

To make it clean I can move the smp_store_cpu_info() call before
local_irq_disable() in smp_callin(). But that needs more changes (for
xen etc). So thinking more, I think it is safe to do smp_call_function()
with interrupts disabled as the caller is currently not in the
cpu_online_mask.

i.e., no one else sends smp_call_function interrupt to this AP who is
doing smp_call_function() with interrupts disabled and as such there
won't be any deadlocks typically associated with calling
smp_call_function() with interrupts disabled. Copied Nick to confirm or
correct my understanding.

New patch appended removes this irq enable/disable sequence around
mtrr_ap_init() and add's a cpu_online() check in smp_call_function
warn-on's.


> > +void mtrr_aps_init(void)
> > +{
> > +	if (!use_intel())
> > +		return;
> > +
> > +	/*
> > +	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries changed,
> > +	 * but this routine will be called in cpu boot time, holding the lock
> > +	 * breaks it. This routine is called in two cases: 1.very earily time
> > +	 * of software resume, when there absolutely isn't mtrr entry changes;
> > +	 * 2.cpu hotadd time. We let mtrr_add/del_page hold cpuhotplug lock to
> > +	 * prevent mtrr entry changes
> > +	 */
> 
> That's a tantalising little comment.  What does "breaks it" mean?  How
> can reviewers and later code-readers possibly suggest alternative fixes
> to this breakage if they aren't told what it is?

This is a cut and paste comment coming from the previous code. Shaohua
added this comment originally and I think this is the case he is trying
to avoid.

cpu - A modifying/adding a  MTRR register

cpu - B is coming online

if cpu - A doesn't take the cpu hotplug lock, then potentially what can
happen is that cpu B will update its mtrr's with old state and now A can
change the state and before B comes completely online, A can do send the
MTRR update to all cpu's except B.

So Shaohua's code is taking cpu hotplug lock before A updates MTRR's so
that B's MTRRs are always is in sync with rest of the cpu's in the
system. Only the mtrr_mutex is not enough.

Nevertheless as far as this patch is concerned mtrr_aps_init() gets
called during early boot/resume time and as such we never hit this
condition. So I removed this comment in the new patch appended.

Shaohua if you agree with my explanation we can have a separate patch to
make the original comment more meaningful.

> >  
> > +void __attribute__((weak)) arch_enable_nonboot_cpus_begin(void)
> > +{
> > +}
> > +
> > +void __attribute__((weak)) arch_enable_nonboot_cpus_end(void)
> > +{
> > +}
> 
> Please use __weak.

Oops. Fixed.

New patch appended. I can split the smp.c warn_on() changes into another
patch, if needed. But for distribution pickups, I thought single patch
might be easy.

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: Rendezvous all the cpu's for MTRR/PAT init

SDM Vol 3a section titled "MTRR considerations in MP systems" specifies
the need for synchronizing the logical cpu's while initializing/updating
MTRR.

Currently Linux kernel does the synchronization of all cpu's only when
a single MTRR register is programmed/updated. During an AP online
(during boot/cpu-online/resume)  where we initialize all the MTRR/PAT registers,
we don't follow this synchronization algorithm.

This can lead to scenarios where during a dynamic cpu online, that logical cpu
is initializing MTRR/PAT with cache disabled (cr0.cd=1) etc while other logical
HT sibling continue to run (also with cache disabled because of cr0.cd=1
on its sibling).

Starting from Westmere, VMX transitions with cr0.cd=1 don't work properly
(because of some VMX performance optimizations) and the above scenario
(with one logical cpu doing VMX activity and another logical cpu coming online)
can result in system crash.

Fix the MTRR initialization by doing rendezvous of all the cpus. During
boot and resume, we delay the MTRR/PAT init for APs till all the
logical cpu's come online and the rendezvous process at the end of AP's bringup,
will initialize the MTRR/PAT for all AP's.

For dynamic single cpu online, we synchronize all the logical cpus and
do the MTRR/PAT init on the AP that is coming online.

Also fix the warn_on's in smp_call_function() to check for online cpu,
as it is safe for a cpu that is still not online to call smp_call_function()
with interrupts disabled.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/include/asm/mtrr.h
===================================================================
--- tip.orig/arch/x86/include/asm/mtrr.h
+++ tip/arch/x86/include/asm/mtrr.h
@@ -121,8 +121,12 @@ extern int mtrr_del_page(int reg, unsign
 extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
+extern void set_mtrr_aps_delayed_init(void);
+extern void mtrr_aps_init(void);
+extern void mtrr_bp_restore(void);
 extern int mtrr_trim_uncached_memory(unsigned long end_pfn);
 extern int amd_special_default_mtrr(void);
+extern u32 mtrr_aps_delayed_init;
 #  else
 static inline u8 mtrr_type_lookup(u64 addr, u64 end)
 {
@@ -161,6 +165,9 @@ static inline void mtrr_centaur_report_m
 
 #define mtrr_ap_init() do {} while (0)
 #define mtrr_bp_init() do {} while (0)
+#define set_mtrr_aps_delayed_init() do {} while (0)
+#define mtrr_aps_init() do {} while (0)
+#define mtrr_bp_restore() do {} while (0)
 #  endif
 
 #ifdef CONFIG_COMPAT
Index: tip/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ tip/arch/x86/kernel/cpu/mtrr/main.c
@@ -58,6 +58,7 @@ unsigned int mtrr_usage_table[MTRR_MAX_V
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
+u32 mtrr_aps_delayed_init;
 
 static struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM];
 
@@ -163,7 +164,10 @@ static void ipi_handler(void *info)
 	if (data->smp_reg != ~0U) {
 		mtrr_if->set(data->smp_reg, data->smp_base,
 			     data->smp_size, data->smp_type);
-	} else {
+	} else if (mtrr_aps_delayed_init) {
+		/*
+		 * Initialize the MTRRs inaddition to the synchronisation.
+		 */
 		mtrr_if->set_all();
 	}
 
@@ -265,6 +269,8 @@ set_mtrr(unsigned int reg, unsigned long
 	 */
 	if (reg != ~0U)
 		mtrr_if->set(reg, base, size, type);
+	else if (!mtrr_aps_delayed_init)
+		mtrr_if->set_all();
 
 	/* Wait for the others */
 	while (atomic_read(&data.count))
@@ -721,9 +727,7 @@ void __init mtrr_bp_init(void)
 
 void mtrr_ap_init(void)
 {
-	unsigned long flags;
-
-	if (!mtrr_if || !use_intel())
+	if (!use_intel() || mtrr_aps_delayed_init)
 		return;
 	/*
 	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries
@@ -738,11 +742,7 @@ void mtrr_ap_init(void)
 	 *   2. cpu hotadd time. We let mtrr_add/del_page hold cpuhotplug
 	 *      lock to prevent mtrr entry changes
 	 */
-	local_irq_save(flags);
-
-	mtrr_if->set_all();
-
-	local_irq_restore(flags);
+	set_mtrr(~0U, 0, 0, 0);
 }
 
 /**
@@ -753,6 +753,34 @@ void mtrr_save_state(void)
 	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1);
 }
 
+void set_mtrr_aps_delayed_init(void)
+{
+	if (!use_intel())
+		return;
+
+	mtrr_aps_delayed_init = 1;
+}
+
+/*
+ * MTRR initialization for all AP's
+ */
+void mtrr_aps_init(void)
+{
+	if (!use_intel())
+		return;
+
+	set_mtrr(~0U, 0, 0, 0);
+	mtrr_aps_delayed_init = 0;
+}
+
+void mtrr_bp_restore(void)
+{
+	if (!use_intel())
+		return;
+
+	mtrr_if->set_all();
+}
+
 static int __init mtrr_init_finialize(void)
 {
 	if (!mtrr_if)
Index: tip/arch/x86/kernel/smpboot.c
===================================================================
--- tip.orig/arch/x86/kernel/smpboot.c
+++ tip/arch/x86/kernel/smpboot.c
@@ -1118,9 +1118,22 @@ void __init native_smp_prepare_cpus(unsi
 
 	if (is_uv_system())
 		uv_system_init();
+
+	set_mtrr_aps_delayed_init();
 out:
 	preempt_enable();
 }
+
+void arch_enable_nonboot_cpus_begin(void)
+{
+	set_mtrr_aps_delayed_init();
+}
+
+void arch_enable_nonboot_cpus_end(void)
+{
+	mtrr_aps_init();
+}
+
 /*
  * Early setup to make printk work.
  */
@@ -1142,6 +1155,7 @@ void __init native_smp_cpus_done(unsigne
 	setup_ioapic_dest();
 #endif
 	check_nmi_watchdog();
+	mtrr_aps_init();
 }
 
 static int __initdata setup_possible_cpus = -1;
Index: tip/arch/x86/power/cpu.c
===================================================================
--- tip.orig/arch/x86/power/cpu.c
+++ tip/arch/x86/power/cpu.c
@@ -224,7 +224,7 @@ static void __restore_processor_state(st
 	fix_processor_context();
 
 	do_fpu_end();
-	mtrr_ap_init();
+	mtrr_bp_restore();
 
 #ifdef CONFIG_X86_OLD_MCE
 	mcheck_init(&boot_cpu_data);
Index: tip/kernel/cpu.c
===================================================================
--- tip.orig/kernel/cpu.c
+++ tip/kernel/cpu.c
@@ -413,6 +413,14 @@ int disable_nonboot_cpus(void)
 	return error;
 }
 
+void __weak arch_enable_nonboot_cpus_begin(void)
+{
+}
+
+void __weak arch_enable_nonboot_cpus_end(void)
+{
+}
+
 void __ref enable_nonboot_cpus(void)
 {
 	int cpu, error;
@@ -424,6 +432,9 @@ void __ref enable_nonboot_cpus(void)
 		goto out;
 
 	printk("Enabling non-boot CPUs ...\n");
+
+	arch_enable_nonboot_cpus_begin();
+
 	for_each_cpu(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
@@ -432,6 +443,9 @@ void __ref enable_nonboot_cpus(void)
 		}
 		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
 	}
+
+	arch_enable_nonboot_cpus_end();
+
 	cpumask_clear(frozen_cpus);
 out:
 	cpu_maps_update_done();
Index: tip/kernel/smp.c
===================================================================
--- tip.orig/kernel/smp.c
+++ tip/kernel/smp.c
@@ -286,7 +286,8 @@ int smp_call_function_single(int cpu, vo
 	this_cpu = get_cpu();
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
+	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
+		     && !oops_in_progress);
 
 	if (cpu == this_cpu) {
 		local_irq_save(flags);
@@ -330,7 +331,8 @@ void __smp_call_function_single(int cpu,
 	csd_lock(data);
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON_ONCE(wait && irqs_disabled() && !oops_in_progress);
+	WARN_ON_ONCE(cpu_online(smp_processor_id()) && wait && irqs_disabled()
+		     && !oops_in_progress);
 
 	generic_exec_single(cpu, data, wait);
 }
@@ -366,7 +368,8 @@ void smp_call_function_many(const struct
 	int cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
+	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
+		     && !oops_in_progress);
 
 	/* So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);


