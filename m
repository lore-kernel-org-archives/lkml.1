Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYLWHeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYLWHeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 02:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYLWHdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 02:33:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:58361 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbYLWHdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 02:33:53 -0500
Message-ID: <49509418.6040905@kernel.org>
Date: Mon, 22 Dec 2008 23:32:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: clean up setup_clear/force_cpu_cap handling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
@@ -190,11 +190,11 @@ extern const char * const x86_power_flag
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
@@ -134,7 +134,8 @@ extern struct cpuinfo_x86	boot_cpu_data;
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
@@ -221,7 +221,8 @@ static char __cpuinit *table_lookup_mode
 	return NULL;		/* Not found */
 }
 
-__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
+__u32 cpu_caps_cleared[NCAPINTS] __cpuinitdata;
+__u32 cpu_caps_set[NCAPINTS] __cpuinitdata;
 
 /* Current gdt points %fs at the "master" per-cpu area: after this,
  * it's on the real one. */
@@ -706,6 +707,16 @@ static void __cpuinit identify_cpu(struc
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
@@ -718,10 +729,6 @@ static void __cpuinit identify_cpu(struc
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
 
-	/* Clear all flags overriden by options */
-	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] &= ~cleared_cpu_caps[i];
-
 #ifdef CONFIG_X86_MCE
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
