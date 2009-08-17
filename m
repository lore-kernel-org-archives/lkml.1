Return-Path: <linux-kernel-owner+w=401wt.eu-S1757768AbZHQL0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768AbZHQL0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbZHQL0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:26:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43145 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757720AbZHQL0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:26:01 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com, tglx@linutronix.de,
       Yinghai Lu <yinghai@kernel.org>, Huang@firstfloor.org,
       "Ying <ying"@firstfloor.org, linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:x86/mce3] x86, mce: use 64bit machine check code on 32bit
From: Andi Kleen <andi@firstfloor.org>
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org>
	<20090812113652.GA19632@elte.hu>
Date: Mon, 17 Aug 2009 13:25:58 +0200
In-Reply-To: <20090812113652.GA19632@elte.hu> (Ingo Molnar's message of "Wed, 12 Aug 2009 13:36:52 +0200")
Message-ID: <87ljlismux.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

Weird the original mail didn't make it through, only saw the replies.

>> all quirks.
>
> This commit causes a new regression, it broke the bootup on one of 
> my -tip testsystems, an older, Pentium-M based HP laptop (HP 
> OmniBook 6000 EA).
>
> The symptom is that the bootup hard-hangs after MCE init:
>
>  [    0.022996] Mount-cache hash table entries: 512
>  [    0.024996] Initializing cgroup subsys debug
>  [    0.025996] Initializing cgroup subsys cpuacct
>  [    0.026995] Initializing cgroup subsys devices
>  [    0.027995] Initializing cgroup subsys freezer
>  [    0.028995] mce: CPU supports 5 MCE banks

Thanks for testing. 

I assume the system boots with CONFIG_X86_NEW_MCE disabled and machine checks 
enabled, correct? As in you never booted with mce=off or a similar option
on older kernels.

First please test with the patch I posted in 

http://article.gmane.org/gmane.linux.kernel/875563

I don't see that one in tip. 

If that doesn't help please boot with the appended debug patch and post the console
log again, then we will hopefully  see where it hangs.

-Andi

commit 09f099eafbff70ecf55f7f111d2fb497ddb9a915
Author: Andi Kleen <ak@linux.intel.com>
Date:   Mon Aug 17 13:15:50 2009 +0200

    Debug patch: trace mce init
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 1cfb623..bfaed40 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -45,6 +45,8 @@
 
 #include "mce-internal.h"
 
+#define D printk("%s:%d\n", __FILE__, __LINE__)
+
 /* Handle unconfigured int18 (should never happen) */
 static void unexpected_machine_check(struct pt_regs *regs, long error_code)
 {
@@ -1196,6 +1198,8 @@ static int mce_cap_init(void)
 	if (cap & MCG_SER_P)
 		mce_ser = 1;
 
+	D;
+
 	return 0;
 }
 
@@ -1209,20 +1213,30 @@ static void mce_init(void)
 	 * Log the machine checks left over from the previous reset.
 	 */
 	bitmap_fill(all_banks, MAX_NR_BANKS);
+	D;
 	machine_check_poll(MCP_UC|(!mce_bootlog ? MCP_DONTLOG : 0), &all_banks);
 
+	D;
+
 	set_in_cr4(X86_CR4_MCE);
 
+	D;
+
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
+	D;
 	if (cap & MCG_CTL_P)
 		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
+	D;
 
 	for (i = 0; i < banks; i++) {
 		if (skip_bank_init(i))
 			continue;
+		printk("init bank %d\n", i);
 		wrmsrl(MSR_IA32_MC0_CTL+4*i, bank[i]);
 		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	}
+
+	D;
 }
 
 /* Add per CPU specific workarounds here */
@@ -1319,9 +1333,12 @@ static void mce_init_timer(void)
 	*n = check_interval * HZ;
 	if (!*n)
 		return;
+
+	D;
 	setup_timer(t, mcheck_timer, smp_processor_id());
 	t->expires = round_jiffies(jiffies + *n);
 	add_timer_on(t, smp_processor_id());
+	D;
 }
 
 /*
@@ -1340,15 +1357,21 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 
 	if (mce_cap_init() < 0) {
 		mce_disabled = 1;
+		D;
 		return;
 	}
+	D;
 	mce_cpu_quirks(c);
+	D;
 
 	machine_check_vector = do_machine_check;
 
 	mce_init();
+	D;
 	mce_cpu_features(c);
+	D;
 	mce_init_timer();
+	D;
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
 }
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index e1acec0..0d6aeab 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -13,6 +13,8 @@
 #include <asm/msr.h>
 #include <asm/mce.h>
 
+#define D printk("%s:%d\n", __FILE__, __LINE__)
+
 /*
  * Support for Intel Correct Machine Check Interrupts. This allows
  * the CPU to raise an interrupt when a corrected machine check happened.
@@ -207,6 +209,8 @@ static void intel_init_cmci(void)
 	if (!cmci_supported(&banks))
 		return;
 
+	D;
+
 	mce_threshold_vector = intel_threshold_interrupt;
 	cmci_discover(banks, 1);
 	/*
@@ -217,10 +221,15 @@ static void intel_init_cmci(void)
 	 */
 	apic_write(APIC_LVTCMCI, THRESHOLD_APIC_VECTOR|APIC_DM_FIXED);
 	cmci_recheck();
+
+	D;
 }
 
 void mce_intel_feature_init(struct cpuinfo_x86 *c)
 {
+	D;
 	intel_init_thermal(c);
+	D;
 	intel_init_cmci();
+	D;
 }
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index bff8dd1..b4c6ca0 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -31,6 +31,8 @@
 #include <asm/mce.h>
 #include <asm/msr.h>
 
+#define D printk("%s:%d\n", __FILE__, __LINE__)
+
 /* How long to wait between reporting thermal events */
 #define CHECK_INTERVAL		(300 * HZ)
 
@@ -236,10 +238,14 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	int tm2 = 0;
 	u32 l, h;
 
+	D;
+
 	/* Thermal monitoring depends on ACPI and clock modulation*/
 	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
 		return;
 
+	D;
+
 	/*
 	 * First check if its enabled already, in which case there might
 	 * be some SMM goo which handles it, so we can't even put a handler
@@ -253,6 +259,9 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 		return;
 	}
 
+	D;
+
+
 	if (cpu_has(c, X86_FEATURE_TM2) && (l & MSR_IA32_MISC_ENABLE_TM2))
 		tm2 = 1;
 
@@ -264,6 +273,8 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 		return;
 	}
 
+	D;
+
 	/* We'll mask the thermal vector in the lapic till we're ready: */
 	h = THERMAL_APIC_VECTOR | APIC_DM_FIXED | APIC_LVT_MASKED;
 	apic_write(APIC_LVTTHMR, h);
@@ -286,4 +297,6 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 
 	/* enable thermal throttle processing */
 	atomic_set(&therm_throt_en, 1);
+
+	D;
 }


-- 
ak@linux.intel.com -- Speaking for myself only.
