Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZCRIwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZCRIwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 04:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbZCRIwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 04:52:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:44484 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230AbZCRIwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 04:52:17 -0400
Date: Wed, 18 Mar 2009 08:51:35 GMT
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       travis@sgi.com, rusty@rustcorp.com.au, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, travis@sgi.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <200903171450.34549.rusty@rustcorp.com.au>
References: <200903171450.34549.rusty@rustcorp.com.au>
Subject: [tip:cpus4096] cpumask: fix CONFIG_CPUMASK_OFFSTACK=y cpu hotunplug crash
Message-ID: <tip-30e1e6d1af2b67558bccf322af2b3e0676b209ae@git.kernel.org>
Git-Commit-ID: 30e1e6d1af2b67558bccf322af2b3e0676b209ae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 08:51:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30e1e6d1af2b67558bccf322af2b3e0676b209ae
Gitweb:     http://git.kernel.org/tip/30e1e6d1af2b67558bccf322af2b3e0676b209ae
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Tue, 17 Mar 2009 14:50:34 +1030
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 09:40:35 +0100

cpumask: fix CONFIG_CPUMASK_OFFSTACK=y cpu hotunplug crash

Impact: Fix cpu offline when CONFIG_MAXSMP=y

Changeset bc9b83dd1f66402b870301c3c7117b9c1484abb4 "cpumask: convert
c1e_mask in arch/x86/kernel/process.c to cpumask_var_t" contained a
bug: c1e_mask is manipulated even if C1E isn't detected (and hence
not allocated).

This is simply fixed by checking for NULL (which gcc optimizes out
anyway of CONFIG_CPUMASK_OFFSTACK=n, since it knows ce1_mask can never
be NULL).

In addition, fix a leak where select_idle_routine re-allocates
(and re-clears) c1e_mask on every cpu init.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
LKML-Reference: <200903171450.34549.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/common.c     |    1 +
 arch/x86/kernel/process.c        |   14 +++++++++++---
 3 files changed, 13 insertions(+), 3 deletions(-)

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
