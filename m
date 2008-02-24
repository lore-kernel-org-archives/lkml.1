Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYBXPdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYBXPdW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbYBXPdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:33:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37246 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYBXPdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:33:11 -0500
Date: Sun, 24 Feb 2008 16:32:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Subject: Re: [BUG] 2.6.25-rc2-git8 fails to boot on 486 due to TSC breakage
Message-ID: <20080224153255.GA21348@elte.hu>
References: <200802241107.m1OB7bHb022801@harpo.it.uu.se> <20080224135720.GA5323@elte.hu> <18369.35401.678391.183329@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18369.35401.678391.183329@harpo.it.uu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> 2.6.24-git8 changed include/asm-x86/tsc.h:get_cycles() to call 
> rdtscll() even if CONFIG_X86_TSC isn't set. The call is protected by a 
> cpu_has_tsc test, but starting with 2.6.24-git8 cpu_has_tsc is 
> non-zero on this machine, which is very very wrong.

does reverting the commit below solve the problem?

	Ingo

-------------->
commit 404ee5b14b68d3cba287c2596588b83790c49f7b
Author: Andi Kleen <ak@suse.de>
Date:   Wed Jan 30 13:33:20 2008 +0100

    x86: convert TSC disabling to generic cpuid disable bitmap
    
    Fix from: Ian Campbell <ijc@hellion.org.uk>
    
    Signed-off-by: Andi Kleen <ak@suse.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index a96abd4..9b95edc 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -154,7 +154,7 @@ static void __init check_config(void)
  * If we configured ourselves for a TSC, we'd better have one!
  */
 #ifdef CONFIG_X86_TSC
-	if (!cpu_has_tsc && !tsc_disable)
+	if (!cpu_has_tsc)
 		panic("Kernel compiled for Pentium+, requires TSC feature!");
 #endif
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c66991a..dfc9563 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -446,10 +446,6 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	 * we do "generic changes."
 	 */
 
-	/* TSC disabled? */
-	if ( tsc_disable )
-		clear_bit(X86_FEATURE_TSC, c->x86_capability);
-
 	/* If the model name is still unset, do table lookup. */
 	if ( !c->x86_model_id[0] ) {
 		char *p;
@@ -650,11 +646,6 @@ void __cpuinit cpu_init(void)
 
 	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
 		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
-	if (tsc_disable && cpu_has_tsc) {
-		printk(KERN_NOTICE "Disabling TSC...\n");
-		/**** FIX-HPA: DOES THIS REALLY BELONG HERE? ****/
-		clear_bit(X86_FEATURE_TSC, boot_cpu_data.x86_capability);
-	}
 
 	load_idt(&idt_descr);
 	switch_to_new_gdt();
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 9000d82..e65281b 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -82,7 +82,7 @@ static int __init numaq_tsc_disable(void)
 {
 	if (num_online_nodes() > 1) {
 		printk(KERN_DEBUG "NUMAQ: disabling TSC\n");
-		tsc_disable = 1;
+		setup_clear_cpu_cap(X86_FEATURE_TSC);
 	}
 	return 0;
 }
diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 2a7b95b..43517e3 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -24,8 +24,6 @@ static int tsc_enabled;
 unsigned int tsc_khz;
 EXPORT_SYMBOL_GPL(tsc_khz);
 
-int tsc_disable;
-
 #ifdef CONFIG_X86_TSC
 static int __init tsc_setup(char *str)
 {
@@ -40,8 +38,7 @@ static int __init tsc_setup(char *str)
  */
 static int __init tsc_setup(char *str)
 {
-	tsc_disable = 1;
-
+	setup_clear_cpu_cap(X86_FEATURE_TSC);
 	return 1;
 }
 #endif
@@ -395,7 +392,7 @@ void __init tsc_init(void)
 {
 	int cpu;
 
-	if (!cpu_has_tsc || tsc_disable)
+	if (!cpu_has_tsc)
 		goto out_no_tsc;
 
 	cpu_khz = calculate_cpu_khz();
@@ -439,10 +436,5 @@ void __init tsc_init(void)
 	return;
 
 out_no_tsc:
-	/*
-	 * Set the tsc_disable flag if there's no TSC support, this
-	 * makes it a fast flag for the kernel to see whether it
-	 * should be using the TSC.
-	 */
-	tsc_disable = 1;
+	setup_clear_cpu_cap(X86_FEATURE_TSC);
 }
diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index 81257a8..5ae5466 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -37,7 +37,7 @@ void __init pre_setup_arch_hook(void)
 {
 	/* Voyagers run their CPUs from independent clocks, so disable
 	 * the TSC code because we can't sync them */
-	tsc_disable = 1;
+	setup_clear_cpu_cap(X86_FEATURE_TSC);
 }
 
 void __init trap_init_hook(void)
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index d083ff5..b3721fd 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -592,7 +592,7 @@ __init void xen_time_init(void)
 	set_normalized_timespec(&wall_to_monotonic,
 				-xtime.tv_sec, -xtime.tv_nsec);
 
-	tsc_disable = 0;
+	setup_force_cpu_cap(X86_FEATURE_TSC);
 
 	xen_setup_timer(cpu);
 	xen_setup_cpu_clockevents();
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index b8f53f8..3fb7dfa 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -135,6 +135,10 @@
 	clear_cpu_cap(&boot_cpu_data, bit);	\
 	set_bit(bit, cleared_cpu_caps); 	\
 } while (0)
+#define setup_force_cpu_cap(bit) do { \
+	set_cpu_cap(&boot_cpu_data, bit);	\
+	clear_bit(bit, cleared_cpu_caps); 	\
+} while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
 #define cpu_has_vme		boot_cpu_has(X86_FEATURE_VME)
diff --git a/include/asm-x86/tsc.h b/include/asm-x86/tsc.h
index 071e0ce..a6e8d35 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -16,8 +16,6 @@ typedef unsigned long long cycles_t;
 
 extern unsigned int cpu_khz;
 extern unsigned int tsc_khz;
-/* flag for disabling the tsc */
-extern int tsc_disable;
 
 extern void disable_TSC(void);
 
