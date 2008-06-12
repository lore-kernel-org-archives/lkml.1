Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbYFLK35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbYFLK35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759517AbYFLK3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:29:13 -0400
Received: from www.tglx.de ([62.245.132.106]:59803 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759495AbYFLK3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:29:11 -0400
Message-Id: <20080610171712.304283554@linutronix.de>
References: <20080610171639.551369443@linutronix.de>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 10:28:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [patch 3/6] x86: use cpuinfo to check for interrupt pending message
	msr
Content-Disposition: inline;
	filename=0003-1635146fac398a95d5320ac8484f393f18786190.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to do a cpuid(1) again. The cpuinfo structure has all
necessary information already.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>

---
 arch/x86/kernel/cpu/amd.c  |   41 +++++++++++++++--------------------------
 arch/x86/kernel/setup_64.c |   38 +++++++++++++++-----------------------
 2 files changed, 30 insertions(+), 49 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -25,35 +25,24 @@ extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
 #ifdef CONFIG_X86_LOCAL_APIC
-#define CPUID_PROCESSOR_SIGNATURE       1
-#define CPUID_XFAM              0x0ff00000
-#define CPUID_XFAM_K8           0x00000000
-#define CPUID_XFAM_10H          0x00100000
-#define CPUID_XFAM_11H          0x00200000
-#define CPUID_XMOD              0x000f0000
-#define CPUID_XMOD_REV_F        0x00040000
 
 /* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
-static __cpuinit int amd_apic_timer_broken(void)
+static __cpuinit int amd_apic_timer_broken(struct cpuinfo_x86 *c)
 {
 	u32 lo, hi;
-	u32 eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
-	switch (eax & CPUID_XFAM) {
-	case CPUID_XFAM_K8:
-		if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
-			break;
-	case CPUID_XFAM_10H:
-	case CPUID_XFAM_11H:
-		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
-		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
-			if (smp_processor_id() != boot_cpu_physical_apicid)
-				printk(KERN_INFO "AMD C1E detected late. "
-				       "	Force timer broadcast.\n");
-			return 1;
-		}
-		break;
-	default:
-		/* err on the side of caution */
+
+	if (c->x86 < 0x0F)
+		return 0;
+
+	/* Family 0x0f models < rev F do not have this MSR */
+	if (c->x86 == 0x0f && c->x86_model < 0x40)
+		return 0;
+
+	rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
+	if (lo & K8_INTP_C1E_ACTIVE_MASK) {
+		if (smp_processor_id() != boot_cpu_physical_apicid)
+			printk(KERN_INFO "AMD C1E detected late. "
+			       "Force timer broadcast.\n");
 		return 1;
 	}
 	return 0;
@@ -297,7 +286,7 @@ static void __cpuinit init_amd(struct cp
 	}
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	if (amd_apic_timer_broken())
+	if (amd_apic_timer_broken(c))
 		local_apic_timer_disabled = 1;
 #endif
 
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -682,31 +682,23 @@ static void __cpuinit early_init_amd_mc(
 #endif
 }
 
-#define CPUID_PROCESSOR_SIGNATURE	1
-#define CPUID_XFAM		0x0ff00000
-#define CPUID_XFAM_K8		0x00000000
-#define CPUID_XFAM_10H		0x00100000
-#define CPUID_XFAM_11H		0x00200000
-#define CPUID_XMOD		0x000f0000
-#define CPUID_XMOD_REV_F	0x00040000
-
 /* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
-static __cpuinit int amd_apic_timer_broken(void)
+static __cpuinit int amd_apic_timer_broken(struct cpuinfo_x86 *c)
 {
-	u32 lo, hi, eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
+	u32 lo, hi;
 
-	switch (eax & CPUID_XFAM) {
-	case CPUID_XFAM_K8:
-		if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
-			break;
-	case CPUID_XFAM_10H:
-	case CPUID_XFAM_11H:
-		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
-		if (lo & K8_INTP_C1E_ACTIVE_MASK)
-			return 1;
-		break;
-	default:
-		/* err on the side of caution */
+	if (c->x86 < 0x0F)
+		return 0;
+
+	/* Family 0x0f models < rev F do not have this MSR */
+	if (c->x86 == 0x0f && c->x86_model < 0x40)
+		return 0;
+
+	rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
+	if (lo & K8_INTP_C1E_ACTIVE_MASK) {
+		if (smp_processor_id() != boot_cpu_physical_apicid)
+			printk(KERN_INFO "AMD C1E detected late. "
+			       "Force timer broadcast.\n");
 		return 1;
 	}
 	return 0;
@@ -789,7 +781,7 @@ static void __cpuinit init_amd(struct cp
 	if (c->x86 == 0x10)
 		fam10h_check_enable_mmcfg();
 
-	if (amd_apic_timer_broken())
+	if (amd_apic_timer_broken(c))
 		disable_apic_timer = 1;
 
 	if (c == &boot_cpu_data && c->x86 >= 0xf && c->x86 <= 0x11) {

-- 

