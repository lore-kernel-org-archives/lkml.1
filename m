Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbYACAvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbYACAvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758219AbYACAuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:06 -0500
Received: from ns2.suse.de ([195.135.220.15]:58342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199AbYACAuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:02 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [6/20] x86: Remove get_cycles_sync
Message-Id: <20080103005001.72C6314D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


And replace with nsec_barrier() as needed which has the same effect
of preventing unnecessary speculation around RDTSC.

For the standard gtod() like calls the previous patch already added the 
necessary barriers

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/time_64.c  |    4 +++-
 arch/x86/kernel/tsc_64.c   |   17 +++++++++++------
 arch/x86/kernel/tsc_sync.c |    6 ++++--
 include/asm-x86/tsc.h      |   44 ++++----------------------------------------
 4 files changed, 22 insertions(+), 49 deletions(-)

Index: linux/arch/x86/kernel/time_64.c
===================================================================
--- linux.orig/arch/x86/kernel/time_64.c
+++ linux/arch/x86/kernel/time_64.c
@@ -81,9 +81,11 @@ unsigned long __init native_calculate_cp
 	wrmsrl(MSR_K7_PERFCTR0 + i, 0);
 	wrmsrl(MSR_K7_EVNTSEL0 + i, 1 << 22 | 3 << 16 | 0x76);
 	rdtscl(tsc_start);
+	nsec_barrier();
 	do {
 		rdmsrl(MSR_K7_PERFCTR0 + i, pmc_now);
-		tsc_now = get_cycles_sync();
+		nsec_barrier();
+		tsc_now = get_cycles();
 	} while ((tsc_now - tsc_start) < TICK_COUNT);
 
 	local_irq_restore(flags);
Index: linux/arch/x86/kernel/tsc_64.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc_64.c
+++ linux/arch/x86/kernel/tsc_64.c
@@ -181,12 +181,14 @@ static unsigned long __init tsc_read_ref
 	int i;
 
 	for (i = 0; i < MAX_RETRIES; i++) {
-		t1 = get_cycles_sync();
+		nsec_barrier();
+		t1 = get_cycles();
 		if (hpet)
 			*hpet = hpet_readl(HPET_COUNTER) & 0xFFFFFFFF;
 		else
 			*pm = acpi_pm_read_early();
-		t2 = get_cycles_sync();
+		nsec_barrier();
+		t2 = get_cycles();
 		if ((t2 - t1) < SMI_TRESHOLD)
 			return t2;
 	}
@@ -210,9 +212,11 @@ void __init tsc_calibrate(void)
 	outb(0xb0, 0x43);
 	outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
 	outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
-	tr1 = get_cycles_sync();
+	tr1 = get_cycles();
+	nsec_barrier();
 	while ((inb(0x61) & 0x20) == 0);
-	tr2 = get_cycles_sync();
+	nsec_barrier();
+	tr2 = get_cycles();
 
 	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
 
@@ -298,15 +302,16 @@ __setup("notsc", notsc_setup);
 
 
 /* clock source code: */
+/* Caller must do nsec_barrier()s */
 static cycle_t read_tsc(void)
 {
-	cycle_t ret = (cycle_t)get_cycles_sync();
+	cycle_t ret = (cycle_t)get_cycles();
 	return ret;
 }
 
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
-	cycle_t ret = (cycle_t)vget_cycles_sync();
+	cycle_t ret = (cycle_t)vget_cycles();
 	return ret;
 }
 
Index: linux/include/asm-x86/tsc.h
===================================================================
--- linux.orig/include/asm-x86/tsc.h
+++ linux/include/asm-x86/tsc.h
@@ -36,61 +36,25 @@ static inline cycles_t get_cycles(void)
 	return ret;
 }
 
-/* Like get_cycles, but make sure the CPU is synchronized. */
-static __always_inline cycles_t __get_cycles_sync(void)
-{
-	unsigned long long ret;
-	unsigned eax, edx;
-
-	/*
-	 * Use RDTSCP if possible; it is guaranteed to be synchronous
-	 * and doesn't cause a VMEXIT on Hypervisors
-	 */
-	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
-		       ASM_OUTPUT2("=a" (eax), "=d" (edx)),
-		       "a" (0U), "d" (0U) : "ecx", "memory");
-	ret = (((unsigned long long)edx) << 32) | ((unsigned long long)eax);
-	if (ret)
-		return ret;
-
-	/*
-	 * Don't do an additional sync on CPUs where we know
-	 * RDTSC is already synchronous:
-	 */
-	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
-			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
-
-	return 0;
-}
-
-static __always_inline cycles_t get_cycles_sync(void)
-{
-	unsigned long long ret;
-	ret = __get_cycles_sync();
-	if (!ret)
-		rdtscll(ret);
-	return ret;
-}
-
 #ifdef CONFIG_PARAVIRT
 /*
  * For paravirt guests, some functionalities are executed through function
  * pointers in the various pvops structures.
  * These function pointers exist inside the kernel and can not
  * be accessed by user space. To avoid this, we make a copy of the
- * get_cycles_sync (called in kernel) but force the use of native_read_tsc.
+ * get_cycles (called in kernel) but force the use of native_read_tsc.
  * Ideally, the guest should set up it's own clock and vread
  */
-static __always_inline long long vget_cycles_sync(void)
+static __always_inline long long vget_cycles(void)
 {
 	unsigned long long ret;
-	ret = __get_cycles_sync();
+	ret = get_cycles();
 	if (!ret)
 		ret = native_read_tsc();
 	return ret;
 }
 #else
-# define vget_cycles_sync() get_cycles_sync()
+# define vget_cycles() get_cycles()
 #endif
 
 extern void tsc_init(void);
Index: linux/arch/x86/kernel/tsc_sync.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc_sync.c
+++ linux/arch/x86/kernel/tsc_sync.c
@@ -46,7 +46,8 @@ static __cpuinit void check_tsc_warp(voi
 	cycles_t start, now, prev, end;
 	int i;
 
-	start = get_cycles_sync();
+	start = get_cycles();
+	nsec_barrier();
 	/*
 	 * The measurement runs for 20 msecs:
 	 */
@@ -61,7 +62,8 @@ static __cpuinit void check_tsc_warp(voi
 		 */
 		__raw_spin_lock(&sync_lock);
 		prev = last_tsc;
-		now = get_cycles_sync();
+		nsec_barrier();
+		now = get_cycles();
 		last_tsc = now;
 		__raw_spin_unlock(&sync_lock);
 
