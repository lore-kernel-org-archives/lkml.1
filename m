Return-Path: <linux-kernel-owner+w=401wt.eu-S1762349AbZFJVQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762349AbZFJVQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbZFJVQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:16:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZFJVQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:16:34 -0400
Date: Wed, 10 Jun 2009 23:16:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cpufeature for v2.6.31
Message-ID: <20090610211629.GA11105@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cpufeature-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpufeature-for-linus

 Thanks,

	Ingo

------------------>
Jaswinder Singh Rajput (1):
      x86: cpufeature.h fix name for X86_FEATURE_MCE

Yinghai Lu (1):
      x86: clean up and fix setup_clear/force_cpu_cap handling


 arch/x86/include/asm/cpufeature.h |    6 +++---
 arch/x86/include/asm/processor.h  |    3 ++-
 arch/x86/kernel/cpu/common.c      |   17 ++++++++++++-----
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb83b1c..13cc6a5 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -22,7 +22,7 @@
 #define X86_FEATURE_TSC		(0*32+ 4) /* Time Stamp Counter */
 #define X86_FEATURE_MSR		(0*32+ 5) /* Model-Specific Registers */
 #define X86_FEATURE_PAE		(0*32+ 6) /* Physical Address Extensions */
-#define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Architecture */
+#define X86_FEATURE_MCE		(0*32+ 7) /* Machine Check Exception */
 #define X86_FEATURE_CX8		(0*32+ 8) /* CMPXCHG8 instruction */
 #define X86_FEATURE_APIC	(0*32+ 9) /* Onboard APIC */
 #define X86_FEATURE_SEP		(0*32+11) /* SYSENTER/SYSEXIT */
@@ -192,11 +192,11 @@ extern const char * const x86_power_flags[32];
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
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c2cceae..fed93fe 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -135,7 +135,8 @@ extern struct cpuinfo_x86	boot_cpu_data;
 extern struct cpuinfo_x86	new_cpu_data;
 
 extern struct tss_struct	doublefault_tss;
-extern __u32			cleared_cpu_caps[NCAPINTS];
+extern __u32			cpu_caps_cleared[NCAPINTS];
+extern __u32			cpu_caps_set[NCAPINTS];
 
 #ifdef CONFIG_SMP
 DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c4f6678..e7fd5c4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -292,7 +292,8 @@ static const char *__cpuinit table_lookup_model(struct cpuinfo_x86 *c)
 	return NULL;		/* Not found */
 }
 
-__u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
+__u32 cpu_caps_cleared[NCAPINTS] __cpuinitdata;
+__u32 cpu_caps_set[NCAPINTS] __cpuinitdata;
 
 void load_percpu_segment(int cpu)
 {
@@ -806,6 +807,16 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
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
@@ -818,10 +829,6 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
 
-	/* Clear all flags overriden by options */
-	for (i = 0; i < NCAPINTS; i++)
-		c->x86_capability[i] &= ~cleared_cpu_caps[i];
-
 #ifdef CONFIG_X86_MCE
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
