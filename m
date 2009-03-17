Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbZCQEUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbZCQEUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 00:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbZCQEUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 00:20:39 -0400
Received: from ozlabs.org ([203.10.76.45]:48491 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZCQEUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 00:20:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PULL] x86 cpumask work
Date: Tue, 17 Mar 2009 14:50:34 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
References: <200903121453.45163.rusty@rustcorp.com.au> <200903161333.16632.rusty@rustcorp.com.au> <20090316084802.GB1062@elte.hu>
In-Reply-To: <20090316084802.GB1062@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200903171450.34549.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009 19:18:02 Ingo Molnar wrote:
> 
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > As the comments says, it can only be NULL during boot of the first CPU.
> > 
> > start_kernel -> check_bugs -> identify_boot_cpu -> identify_cpu
> >   -> select_idle_routine.
> > 
> > Did you want me to panic if it fails?
> 
> Ah, ok. But i think it's very unobvious to embedd a "once per 
> bootup" dynamic allocation like that. Please put it into a 
> separate init routine instead. That way select_idle() [which 
> runs during every CPU hotplug event] wont have this allocation.

There wasn't an obvious place to put the init; I've created one.

How's this?
===

Subject: cpumask: fix CONFIG_CPUMASK_OFFSTACK=y cpu hotunplug crash

Impact: Fix cpu offline when CONFIG_MAXSMP=y

Changeset bc9b83dd1f66402b870301c3c7117b9c1484abb4 "cpumask: convert c1e_mask
in arch/x86/kernel/process.c to cpumask_var_t" contained a bug: c1e_mask is
manipulated even if C1E isn't detected (and hence not allocated).  This is
simply fixed by checking for NULL (which gcc optimizes out anyway of
CONFIG_CPUMASK_OFFSTACK=n, since it knows ce1_mask can never be NULL).

In addition, fix a leak where select_idle_routine re-allocates (and re-clears)
c1e_mask on every cpu init.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index d794d94..9874dd9 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -733,6 +733,7 @@ static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
 
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
+extern void init_c1e_mask(void);
 
 extern unsigned long		boot_option_idle_override;
 extern unsigned long		idle_halt;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 82f6cc0..d7dd3c2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -812,6 +812,7 @@ static void vgetcpu_set_mode(void)
 void __init identify_boot_cpu(void)
 {
 	identify_cpu(&boot_cpu_data);
+	init_c1e_mask();
 #ifdef CONFIG_X86_32
 	sysenter_setup();
 	enable_sep_cpu();
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 6638294..78533a5 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -479,7 +479,8 @@ static int c1e_detected;
 
 void c1e_remove_cpu(int cpu)
 {
-	cpumask_clear_cpu(cpu, c1e_mask);
+	if (c1e_mask != NULL)
+		cpumask_clear_cpu(cpu, c1e_mask);
 }
 
 /*
@@ -556,13 +557,20 @@ void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 		pm_idle = mwait_idle;
 	} else if (check_c1e_idle(c)) {
 		printk(KERN_INFO "using C1E aware idle routine\n");
-		alloc_cpumask_var(&c1e_mask, GFP_KERNEL);
-		cpumask_clear(c1e_mask);
 		pm_idle = c1e_idle;
 	} else
 		pm_idle = default_idle;
 }
 
+void __init init_c1e_mask(void)
+{
+	/* If we're using c1e_idle, we need to allocate c1e_mask. */
+	if (pm_idle == c1e_idle) {
+		alloc_cpumask_var(&c1e_mask, GFP_KERNEL);
+		cpumask_clear(c1e_mask);
+	}
+}
+
 static int __init idle_setup(char *str)
 {
 	if (!str)
