Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbYFLK3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbYFLK3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759470AbYFLK3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:29:05 -0400
Received: from www.tglx.de ([62.245.132.106]:33230 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759430AbYFLK3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:29:03 -0400
Message-Id: <20080610171712.250787381@linutronix.de>
References: <20080610171639.551369443@linutronix.de>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 10:28:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [patch 2/6] x86: cleanup C1E enabled detection
Content-Disposition: inline;
	filename=0002-f9fd9011178b2797d28884836c6b60022bcfd359.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the MSR to INT_PENDING_MSG, which is the name in the data sheet
as well. Move the C1E mask to the header file.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>

---
 arch/x86/kernel/cpu/amd.c   |    5 ++---
 arch/x86/kernel/setup_64.c  |    5 ++---
 include/asm-x86/msr-index.h |    4 +++-
 3 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -25,7 +25,6 @@ extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
 #ifdef CONFIG_X86_LOCAL_APIC
-#define ENABLE_C1E_MASK         0x18000000
 #define CPUID_PROCESSOR_SIGNATURE       1
 #define CPUID_XFAM              0x0ff00000
 #define CPUID_XFAM_K8           0x00000000
@@ -45,8 +44,8 @@ static __cpuinit int amd_apic_timer_brok
 			break;
 	case CPUID_XFAM_10H:
 	case CPUID_XFAM_11H:
-		rdmsr(MSR_K8_ENABLE_C1E, lo, hi);
-		if (lo & ENABLE_C1E_MASK) {
+		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
+		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
 			if (smp_processor_id() != boot_cpu_physical_apicid)
 				printk(KERN_INFO "AMD C1E detected late. "
 				       "	Force timer broadcast.\n");
Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -682,7 +682,6 @@ static void __cpuinit early_init_amd_mc(
 #endif
 }
 
-#define ENABLE_C1E_MASK		0x18000000
 #define CPUID_PROCESSOR_SIGNATURE	1
 #define CPUID_XFAM		0x0ff00000
 #define CPUID_XFAM_K8		0x00000000
@@ -702,8 +701,8 @@ static __cpuinit int amd_apic_timer_brok
 			break;
 	case CPUID_XFAM_10H:
 	case CPUID_XFAM_11H:
-		rdmsr(MSR_K8_ENABLE_C1E, lo, hi);
-		if (lo & ENABLE_C1E_MASK)
+		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
+		if (lo & K8_INTP_C1E_ACTIVE_MASK)
 			return 1;
 		break;
 	default:
Index: linux-2.6/include/asm-x86/msr-index.h
===================================================================
--- linux-2.6.orig/include/asm-x86/msr-index.h
+++ linux-2.6/include/asm-x86/msr-index.h
@@ -111,7 +111,9 @@
 #define MSR_K8_TOP_MEM2			0xc001001d
 #define MSR_K8_SYSCFG			0xc0010010
 #define MSR_K8_HWCR			0xc0010015
-#define MSR_K8_ENABLE_C1E		0xc0010055
+#define MSR_K8_INT_PENDING_MSG		0xc0010055
+/* C1E active bits in int pending message */
+#define K8_INTP_C1E_ACTIVE_MASK		0x18000000
 #define MSR_K8_TSEG_ADDR		0xc0010112
 #define K8_MTRRFIXRANGE_DRAM_ENABLE	0x00040000 /* MtrrFixDramEn bit    */
 #define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */

-- 

