Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbZEKJ41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbZEKJ41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbZEKJyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:54:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:53911 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962AbZEKJyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:54:10 -0400
Date: Mon, 11 May 2009 09:53:32 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au,
       jeremy.fitzhardinge@citrix.com, yinghai.lu@kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au,
       jeremy.fitzhardinge@citrix.com, yinghai.lu@kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:x86/cpufeature] x86: clean up and fix setup_clear/force_cpu_cap handling
Message-ID: <tip-3e0c373749d7eb5b354ac0b043f2b2cdf84eefef@git.kernel.org>
Git-Commit-ID: 3e0c373749d7eb5b354ac0b043f2b2cdf84eefef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:53:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e0c373749d7eb5b354ac0b043f2b2cdf84eefef
Gitweb:     http://git.kernel.org/tip/3e0c373749d7eb5b354ac0b043f2b2cdf84eefef
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 9 May 2009 23:47:42 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 10:57:24 +0200

x86: clean up and fix setup_clear/force_cpu_cap handling

setup_force_cpu_cap() only have one user (Xen guest code),
but it should not reuse cleared_cpu_cpus, otherwise it
will have problems on SMP.

Need to have a separate cpu_cpus_set array too, for forced-on
flags, beyond the forced-off flags.

Also need to setup handling before all cpus caps are combined.

[ Impact: fix the forced-set CPU feature flag logic ]

Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/cpufeature.h |    4 ++--
 arch/x86/include/asm/processor.h  |    3 ++-
 arch/x86/kernel/cpu/common.c      |   17 ++++++++++++-----
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index ccc1061..13cc6a5 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
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
