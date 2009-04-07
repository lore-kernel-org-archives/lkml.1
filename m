Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbZDGBvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbZDGBvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZDGBvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:51:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:7471 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZDGBvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:51:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,334,1235980800"; 
   d="scan'208";a="128571456"
Date: Mon, 6 Apr 2009 18:51:29 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       H Peter Anvin <hpa@zytor.com>, Len Brown <lenb@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86 ACPI: Add support for Always Running APIC timer
Message-ID: <20090407015129.GB3493@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add support for Always Running APIC timer, CPUID_0x6_EAX_Bit2.
This bit means the APIC timer continues to run even when CPU is
in deep C-states.

The advantage is that we can use LAPIC timer on these CPUs
always, and there is no need for "slow to read and program"
external timers (HPET/PIT) and the timer broadcast logic
and related code in C-state entry and exit.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/kernel/apic/apic.c                |    6 ++++++
 arch/x86/kernel/cpu/addon_cpuid_features.c |    1 +
 drivers/acpi/processor_idle.c              |    3 +++
 4 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0beba0d..bb83b1c 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -154,6 +154,7 @@
  * CPUID levels like 0x6, 0xA etc
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
+#define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 85eb8e1..4324435 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -431,6 +431,12 @@ static void __cpuinit setup_APIC_timer(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
+	if (cpu_has(&current_cpu_data, X86_FEATURE_ARAT)) {
+		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_C3STOP;
+		/* Make LAPIC timer preferrable over percpu HPET */
+		lapic_clockevent.rating = 150;
+	}
+
 	memcpy(levt, &lapic_clockevent, sizeof(*levt));
 	levt->cpumask = cpumask_of(smp_processor_id());
 
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 8220ae6..c965e52 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -31,6 +31,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 
 	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
 		{ X86_FEATURE_IDA, CR_EAX, 1, 0x00000006 },
+		{ X86_FEATURE_ARAT, CR_EAX, 2, 0x00000006 },
 		{ 0, 0, 0, 0 }
 	};
 
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 4e6e758..6fe1214 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -145,6 +145,9 @@ static void acpi_timer_check_state(int state, struct acpi_processor *pr,
 	struct acpi_processor_power *pwr = &pr->power;
 	u8 type = local_apic_timer_c2_ok ? ACPI_STATE_C3 : ACPI_STATE_C2;
 
+	if (cpu_has(&cpu_data(pr->id), X86_FEATURE_ARAT))
+		return;
+
 	/*
 	 * Check, if one of the previous states already marked the lapic
 	 * unstable
-- 
1.6.0.6

