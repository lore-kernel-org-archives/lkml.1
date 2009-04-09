Return-Path: <linux-kernel-owner+w=401wt.eu-S1761260AbZDIGkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260AbZDIGkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 02:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbZDIGkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 02:40:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:56997 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbZDIGkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 02:40:06 -0400
Message-ID: <49DD97F3.2060005@kernel.org>
Date: Wed, 08 Apr 2009 23:38:43 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: clean up setup_clear/force_cpu_cap handling - resend
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it looks get lost somehow,... resend again.

Impact: fix and cleanup

setup_force_cpu_cap() only have one user xen
but it should not reuse cleared_cpu_cpus. it will have problem
for smp.

need to have cpu_cpus_set array too.
also need to setup handling before all cpus cap AND

Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>

---
 arch/x86/include/asm/cpufeature.h |    4 ++--
 arch/x86/include/asm/processor.h  |    3 ++-
 arch/x86/kernel/cpu/common.c      |   17 ++++++++++++-----
 3 files changed, 16 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/include/asm/cpufeature.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cpufeature.h
+++ linux-2.6/arch/x86/include/asm/cpufeature.h
@@ -192,11 +192,11 @@ extern const char * const x86_power_flag
 #define clear_cpu_cap(c, bit)	clear_bit(bit, (unsigned long *)((c)->x86_capability))
 #define setup_clear_cpu_cap(bit) do { \
 	clear_cpu_cap(&boot_cpu_data, bit);	\
-	set_bit(bit, (unsigned long *)cleared_cpu_caps); \
+	set_bit(bit, (unsigned long *)cpu_caps_cleared); \
 } while (0)
 #define setup_force_cpu_cap(bit) do { \
 	set_cpu_cap(&boot_cpu_data, bit);	\
-	clear_bit(bit, (unsigned long *)cleared_cpu_caps);	\
+	set_bit(bit, (unsigned long *)cpu_caps_set);	\
 } while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
Index: linux-2.6/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/processor.h
+++ linux-2.6/arch/x86/include/asm/processor.h
@@ -135,7 +135,8 @@ extern struct cpuinfo_x86	boot_cpu_data;
 extern struct cpuinfo_x86	new_cpu_data;
 
 extern struct tss_struct	doublefault_tss;
-extern __u32			cleared_cpu_caps[NCAPINTS];
+extern __u32			cpu_caps_cleared[NCAPINTS];
+extern __u32			cpu_caps_set[NCAPINTS];
 
 #ifdef CONFIG_SMP
 DECLARE_PER_CPU(struct cpuinfo_x86, cpu_info);
Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -293,7 +293,8 @@ static const char *__cpuinit table_looku
 	return NULL;		/* Not found */
 }
 
-__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
+__u32 cpu_caps_cleared[NCAPINTS] __cpuinitdata;
+__u32 cpu_caps_set[NCAPINTS] __cpuinitdata;
 
 void load_percpu_segment(int cpu)
 {
@@ -807,6 +808,16 @@ static void __cpuinit identify_cpu(struc
 #endif
 
 	init_hypervisor(c);
+
+	/*
+	 * Clear/Set all flags overriden by options, need do it
+	 * before following smp all cpus cap AND.
+	 */
+	for (i = 0; i < NCAPINTS; i++) {
+		c->x86_capability[i] &= ~cpu_caps_cleared[i];
+		c->x86_capability[i] |= cpu_caps_set[i];
+	}
+
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
 	 * all CPUs; so make sure that we indicate which features are
@@ -819,10 +830,6 @@ static void __cpuinit identify_cpu(struc
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
 
-	/* Clear all flags overriden by options */
-	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] &= ~cleared_cpu_caps[i];
-
 #ifdef CONFIG_X86_MCE
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
