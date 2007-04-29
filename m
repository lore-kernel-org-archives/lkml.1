Return-Path: <linux-kernel-owner+w=401wt.eu-S1161568AbXD2Xqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161568AbXD2Xqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161622AbXD2Xqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:46:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161611AbXD2Xqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:37 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [21/26] x86: Clean up x86 control register and MSR macros (corrected)
Message-Id: <20070429234631.2116A151C5@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:31 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "H. Peter Anvin" <hpa@zytor.com>
This patch is based on Rusty's recent cleanup of the EFLAGS-related
macros; it extends the same kind of cleanup to control registers and
MSRs.

It also unifies these between i386 and x86-64; at least with regards
to MSRs, the two had definitely gotten out of sync.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-i386/Kbuild              |    2 
 include/asm-i386/msr-index.h         |  273 ++++++++++++++++++++++++++++++++++
 include/asm-i386/msr.h               |  237 ------------------------------
 include/asm-i386/processor-flags.h   |   65 ++++++++
 include/asm-i386/processor.h         |   35 ----
 include/asm-x86_64/Kbuild            |    3 
 include/asm-x86_64/msr-index.h       |    1 
 include/asm-x86_64/msr.h             |  274 -----------------------------------
 include/asm-x86_64/processor-flags.h |   27 ---
 include/asm-x86_64/processor.h       |   31 ---
 10 files changed, 356 insertions(+), 592 deletions(-)

Index: linux/include/asm-i386/Kbuild
===================================================================
--- linux.orig/include/asm-i386/Kbuild
+++ linux/include/asm-i386/Kbuild
@@ -3,8 +3,10 @@ include include/asm-generic/Kbuild.asm
 header-y += boot.h
 header-y += debugreg.h
 header-y += ldt.h
+header-y += msr-index.h
 header-y += ptrace-abi.h
 header-y += ucontext.h
 
+unifdef-y += msr.h
 unifdef-y += mtrr.h
 unifdef-y += vm86.h
Index: linux/include/asm-i386/msr-index.h
===================================================================
--- /dev/null
+++ linux/include/asm-i386/msr-index.h
@@ -0,0 +1,273 @@
+#ifndef __ASM_MSR_INDEX_H
+#define __ASM_MSR_INDEX_H
+
+/* CPU model specific register (MSR) numbers */
+
+/* x86-64 specific MSRs */
+#define MSR_EFER		0xc0000080 /* extended feature register */
+#define MSR_STAR		0xc0000081 /* legacy mode SYSCALL target */
+#define MSR_LSTAR		0xc0000082 /* long mode SYSCALL target */
+#define MSR_CSTAR		0xc0000083 /* compat mode SYSCALL target */
+#define MSR_SYSCALL_MASK	0xc0000084 /* EFLAGS mask for syscall */
+#define MSR_FS_BASE		0xc0000100 /* 64bit FS base */
+#define MSR_GS_BASE		0xc0000101 /* 64bit GS base */
+#define MSR_KERNEL_GS_BASE	0xc0000102 /* SwapGS GS shadow */
+
+/* EFER bits: */
+#define _EFER_SCE		0  /* SYSCALL/SYSRET */
+#define _EFER_LME		8  /* Long mode enable */
+#define _EFER_LMA		10 /* Long mode active (read-only) */
+#define _EFER_NX		11 /* No execute enable */
+
+#define EFER_SCE		(1<<_EFER_SCE)
+#define EFER_LME		(1<<_EFER_LME)
+#define EFER_LMA		(1<<_EFER_LMA)
+#define EFER_NX			(1<<_EFER_NX)
+
+/* Intel MSRs. Some also available on other CPUs */
+#define MSR_IA32_PERFCTR0		0x000000c1
+#define MSR_IA32_PERFCTR1		0x000000c2
+#define MSR_FSB_FREQ			0x000000cd
+
+#define MSR_MTRRcap			0x000000fe
+#define MSR_IA32_BBL_CR_CTL		0x00000119
+
+#define MSR_IA32_SYSENTER_CS		0x00000174
+#define MSR_IA32_SYSENTER_ESP		0x00000175
+#define MSR_IA32_SYSENTER_EIP		0x00000176
+
+#define MSR_IA32_MCG_CAP		0x00000179
+#define MSR_IA32_MCG_STATUS		0x0000017a
+#define MSR_IA32_MCG_CTL		0x0000017b
+
+#define MSR_IA32_PEBS_ENABLE		0x000003f1
+#define MSR_IA32_DS_AREA		0x00000600
+#define MSR_IA32_PERF_CAPABILITIES	0x00000345
+
+#define MSR_MTRRfix64K_00000		0x00000250
+#define MSR_MTRRfix16K_80000		0x00000258
+#define MSR_MTRRfix16K_A0000		0x00000259
+#define MSR_MTRRfix4K_C0000		0x00000268
+#define MSR_MTRRfix4K_C8000		0x00000269
+#define MSR_MTRRfix4K_D0000		0x0000026a
+#define MSR_MTRRfix4K_D8000		0x0000026b
+#define MSR_MTRRfix4K_E0000		0x0000026c
+#define MSR_MTRRfix4K_E8000		0x0000026d
+#define MSR_MTRRfix4K_F0000		0x0000026e
+#define MSR_MTRRfix4K_F8000		0x0000026f
+#define MSR_MTRRdefType			0x000002ff
+
+#define MSR_IA32_DEBUGCTLMSR		0x000001d9
+#define MSR_IA32_LASTBRANCHFROMIP	0x000001db
+#define MSR_IA32_LASTBRANCHTOIP		0x000001dc
+#define MSR_IA32_LASTINTFROMIP		0x000001dd
+#define MSR_IA32_LASTINTTOIP		0x000001de
+
+#define MSR_IA32_MC0_CTL		0x00000400
+#define MSR_IA32_MC0_STATUS		0x00000401
+#define MSR_IA32_MC0_ADDR		0x00000402
+#define MSR_IA32_MC0_MISC		0x00000403
+
+#define MSR_P6_PERFCTR0			0x000000c1
+#define MSR_P6_PERFCTR1			0x000000c2
+#define MSR_P6_EVNTSEL0			0x00000186
+#define MSR_P6_EVNTSEL1			0x00000187
+
+/* K7/K8 MSRs. Not complete. See the architecture manual for a more
+   complete list. */
+#define MSR_K7_EVNTSEL0			0xc0010000
+#define MSR_K7_PERFCTR0			0xc0010004
+#define MSR_K7_EVNTSEL1			0xc0010001
+#define MSR_K7_PERFCTR1			0xc0010005
+#define MSR_K7_EVNTSEL2			0xc0010002
+#define MSR_K7_PERFCTR2			0xc0010006
+#define MSR_K7_EVNTSEL3			0xc0010003
+#define MSR_K7_PERFCTR3			0xc0010007
+#define MSR_K8_TOP_MEM1			0xc001001a
+#define MSR_K7_CLK_CTL			0xc001001b
+#define MSR_K8_TOP_MEM2			0xc001001d
+#define MSR_K8_SYSCFG			0xc0010010
+#define MSR_K7_HWCR			0xc0010015
+#define MSR_K8_HWCR			0xc0010015
+#define MSR_K7_FID_VID_CTL		0xc0010041
+#define MSR_K7_FID_VID_STATUS		0xc0010042
+#define MSR_K8_ENABLE_C1E		0xc0010055
+
+/* K6 MSRs */
+#define MSR_K6_EFER			0xc0000080
+#define MSR_K6_STAR			0xc0000081
+#define MSR_K6_WHCR			0xc0000082
+#define MSR_K6_UWCCR			0xc0000085
+#define MSR_K6_EPMR			0xc0000086
+#define MSR_K6_PSOR			0xc0000087
+#define MSR_K6_PFIR			0xc0000088
+
+/* Centaur-Hauls/IDT defined MSRs. */
+#define MSR_IDT_FCR1			0x00000107
+#define MSR_IDT_FCR2			0x00000108
+#define MSR_IDT_FCR3			0x00000109
+#define MSR_IDT_FCR4			0x0000010a
+
+#define MSR_IDT_MCR0			0x00000110
+#define MSR_IDT_MCR1			0x00000111
+#define MSR_IDT_MCR2			0x00000112
+#define MSR_IDT_MCR3			0x00000113
+#define MSR_IDT_MCR4			0x00000114
+#define MSR_IDT_MCR5			0x00000115
+#define MSR_IDT_MCR6			0x00000116
+#define MSR_IDT_MCR7			0x00000117
+#define MSR_IDT_MCR_CTRL		0x00000120
+
+/* VIA Cyrix defined MSRs*/
+#define MSR_VIA_FCR			0x00001107
+#define MSR_VIA_LONGHAUL		0x0000110a
+#define MSR_VIA_RNG			0x0000110b
+#define MSR_VIA_BCR2			0x00001147
+
+/* Transmeta defined MSRs */
+#define MSR_TMTA_LONGRUN_CTRL		0x80868010
+#define MSR_TMTA_LONGRUN_FLAGS		0x80868011
+#define MSR_TMTA_LRTI_READOUT		0x80868018
+#define MSR_TMTA_LRTI_VOLT_MHZ		0x8086801a
+
+/* Intel defined MSRs. */
+#define MSR_IA32_P5_MC_ADDR		0x00000000
+#define MSR_IA32_P5_MC_TYPE		0x00000001
+#define MSR_IA32_TSC			0x00000010
+#define MSR_IA32_PLATFORM_ID		0x00000017
+#define MSR_IA32_EBL_CR_POWERON		0x0000002a
+
+#define MSR_IA32_APICBASE		0x0000001b
+#define MSR_IA32_APICBASE_BSP		(1<<8)
+#define MSR_IA32_APICBASE_ENABLE	(1<<11)
+#define MSR_IA32_APICBASE_BASE		(0xfffff<<12)
+
+#define MSR_IA32_UCODE_WRITE		0x00000079
+#define MSR_IA32_UCODE_REV		0x0000008b
+
+#define MSR_IA32_PERF_STATUS		0x00000198
+#define MSR_IA32_PERF_CTL		0x00000199
+
+#define MSR_IA32_MPERF			0x000000e7
+#define MSR_IA32_APERF			0x000000e8
+
+#define MSR_IA32_THERM_CONTROL		0x0000019a
+#define MSR_IA32_THERM_INTERRUPT	0x0000019b
+#define MSR_IA32_THERM_STATUS		0x0000019c
+#define MSR_IA32_MISC_ENABLE		0x000001a0
+
+/* Intel Model 6 */
+#define MSR_P6_EVNTSEL0			0x00000186
+#define MSR_P6_EVNTSEL1			0x00000187
+
+/* P4/Xeon+ specific */
+#define MSR_IA32_MCG_EAX		0x00000180
+#define MSR_IA32_MCG_EBX		0x00000181
+#define MSR_IA32_MCG_ECX		0x00000182
+#define MSR_IA32_MCG_EDX		0x00000183
+#define MSR_IA32_MCG_ESI		0x00000184
+#define MSR_IA32_MCG_EDI		0x00000185
+#define MSR_IA32_MCG_EBP		0x00000186
+#define MSR_IA32_MCG_ESP		0x00000187
+#define MSR_IA32_MCG_EFLAGS		0x00000188
+#define MSR_IA32_MCG_EIP		0x00000189
+#define MSR_IA32_MCG_RESERVED		0x0000018a
+
+/* Pentium IV performance counter MSRs */
+#define MSR_P4_BPU_PERFCTR0		0x00000300
+#define MSR_P4_BPU_PERFCTR1		0x00000301
+#define MSR_P4_BPU_PERFCTR2		0x00000302
+#define MSR_P4_BPU_PERFCTR3		0x00000303
+#define MSR_P4_MS_PERFCTR0		0x00000304
+#define MSR_P4_MS_PERFCTR1		0x00000305
+#define MSR_P4_MS_PERFCTR2		0x00000306
+#define MSR_P4_MS_PERFCTR3		0x00000307
+#define MSR_P4_FLAME_PERFCTR0		0x00000308
+#define MSR_P4_FLAME_PERFCTR1		0x00000309
+#define MSR_P4_FLAME_PERFCTR2		0x0000030a
+#define MSR_P4_FLAME_PERFCTR3		0x0000030b
+#define MSR_P4_IQ_PERFCTR0		0x0000030c
+#define MSR_P4_IQ_PERFCTR1		0x0000030d
+#define MSR_P4_IQ_PERFCTR2		0x0000030e
+#define MSR_P4_IQ_PERFCTR3		0x0000030f
+#define MSR_P4_IQ_PERFCTR4		0x00000310
+#define MSR_P4_IQ_PERFCTR5		0x00000311
+#define MSR_P4_BPU_CCCR0		0x00000360
+#define MSR_P4_BPU_CCCR1		0x00000361
+#define MSR_P4_BPU_CCCR2		0x00000362
+#define MSR_P4_BPU_CCCR3		0x00000363
+#define MSR_P4_MS_CCCR0			0x00000364
+#define MSR_P4_MS_CCCR1			0x00000365
+#define MSR_P4_MS_CCCR2			0x00000366
+#define MSR_P4_MS_CCCR3			0x00000367
+#define MSR_P4_FLAME_CCCR0		0x00000368
+#define MSR_P4_FLAME_CCCR1		0x00000369
+#define MSR_P4_FLAME_CCCR2		0x0000036a
+#define MSR_P4_FLAME_CCCR3		0x0000036b
+#define MSR_P4_IQ_CCCR0			0x0000036c
+#define MSR_P4_IQ_CCCR1			0x0000036d
+#define MSR_P4_IQ_CCCR2			0x0000036e
+#define MSR_P4_IQ_CCCR3			0x0000036f
+#define MSR_P4_IQ_CCCR4			0x00000370
+#define MSR_P4_IQ_CCCR5			0x00000371
+#define MSR_P4_ALF_ESCR0		0x000003ca
+#define MSR_P4_ALF_ESCR1		0x000003cb
+#define MSR_P4_BPU_ESCR0		0x000003b2
+#define MSR_P4_BPU_ESCR1		0x000003b3
+#define MSR_P4_BSU_ESCR0		0x000003a0
+#define MSR_P4_BSU_ESCR1		0x000003a1
+#define MSR_P4_CRU_ESCR0		0x000003b8
+#define MSR_P4_CRU_ESCR1		0x000003b9
+#define MSR_P4_CRU_ESCR2		0x000003cc
+#define MSR_P4_CRU_ESCR3		0x000003cd
+#define MSR_P4_CRU_ESCR4		0x000003e0
+#define MSR_P4_CRU_ESCR5		0x000003e1
+#define MSR_P4_DAC_ESCR0		0x000003a8
+#define MSR_P4_DAC_ESCR1		0x000003a9
+#define MSR_P4_FIRM_ESCR0		0x000003a4
+#define MSR_P4_FIRM_ESCR1		0x000003a5
+#define MSR_P4_FLAME_ESCR0		0x000003a6
+#define MSR_P4_FLAME_ESCR1		0x000003a7
+#define MSR_P4_FSB_ESCR0		0x000003a2
+#define MSR_P4_FSB_ESCR1		0x000003a3
+#define MSR_P4_IQ_ESCR0			0x000003ba
+#define MSR_P4_IQ_ESCR1			0x000003bb
+#define MSR_P4_IS_ESCR0			0x000003b4
+#define MSR_P4_IS_ESCR1			0x000003b5
+#define MSR_P4_ITLB_ESCR0		0x000003b6
+#define MSR_P4_ITLB_ESCR1		0x000003b7
+#define MSR_P4_IX_ESCR0			0x000003c8
+#define MSR_P4_IX_ESCR1			0x000003c9
+#define MSR_P4_MOB_ESCR0		0x000003aa
+#define MSR_P4_MOB_ESCR1		0x000003ab
+#define MSR_P4_MS_ESCR0			0x000003c0
+#define MSR_P4_MS_ESCR1			0x000003c1
+#define MSR_P4_PMH_ESCR0		0x000003ac
+#define MSR_P4_PMH_ESCR1		0x000003ad
+#define MSR_P4_RAT_ESCR0		0x000003bc
+#define MSR_P4_RAT_ESCR1		0x000003bd
+#define MSR_P4_SAAT_ESCR0		0x000003ae
+#define MSR_P4_SAAT_ESCR1		0x000003af
+#define MSR_P4_SSU_ESCR0		0x000003be
+#define MSR_P4_SSU_ESCR1		0x000003bf /* guess: not in manual */
+
+#define MSR_P4_TBPU_ESCR0		0x000003c2
+#define MSR_P4_TBPU_ESCR1		0x000003c3
+#define MSR_P4_TC_ESCR0			0x000003c4
+#define MSR_P4_TC_ESCR1			0x000003c5
+#define MSR_P4_U2L_ESCR0		0x000003b0
+#define MSR_P4_U2L_ESCR1		0x000003b1
+
+/* Intel Core-based CPU performance counters */
+#define MSR_CORE_PERF_FIXED_CTR0	0x00000309
+#define MSR_CORE_PERF_FIXED_CTR1	0x0000030a
+#define MSR_CORE_PERF_FIXED_CTR2	0x0000030b
+#define MSR_CORE_PERF_FIXED_CTR_CTRL	0x0000038d
+#define MSR_CORE_PERF_GLOBAL_STATUS	0x0000038e
+#define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
+#define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
+
+/* Geode defined MSRs */
+#define MSR_GEODE_BUSCONT_CONF0		0x00001900
+
+#endif /* __ASM_MSR_INDEX_H */
Index: linux/include/asm-i386/msr.h
===================================================================
--- linux.orig/include/asm-i386/msr.h
+++ linux/include/asm-i386/msr.h
@@ -1,6 +1,11 @@
 #ifndef __ASM_MSR_H
 #define __ASM_MSR_H
 
+#include <asm/msr-index.h>
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
 #include <asm/errno.h>
 
 static inline unsigned long long native_read_msr(unsigned int msr)
@@ -153,234 +158,6 @@ static inline void wrmsr_on_cpu(unsigned
 	wrmsr(msr_no, l, h);
 }
 #endif  /*  CONFIG_SMP  */
-
-/* symbolic names for some interesting MSRs */
-/* Intel defined MSRs. */
-#define MSR_IA32_P5_MC_ADDR		0
-#define MSR_IA32_P5_MC_TYPE		1
-#define MSR_IA32_PLATFORM_ID		0x17
-#define MSR_IA32_EBL_CR_POWERON		0x2a
-
-#define MSR_IA32_APICBASE		0x1b
-#define MSR_IA32_APICBASE_BSP		(1<<8)
-#define MSR_IA32_APICBASE_ENABLE	(1<<11)
-#define MSR_IA32_APICBASE_BASE		(0xfffff<<12)
-
-#define MSR_IA32_UCODE_WRITE		0x79
-#define MSR_IA32_UCODE_REV		0x8b
-
-#define MSR_P6_PERFCTR0		0xc1
-#define MSR_P6_PERFCTR1		0xc2
-#define MSR_FSB_FREQ		0xcd
-
-
-#define MSR_IA32_BBL_CR_CTL		0x119
-
-#define MSR_IA32_SYSENTER_CS		0x174
-#define MSR_IA32_SYSENTER_ESP		0x175
-#define MSR_IA32_SYSENTER_EIP		0x176
-
-#define MSR_IA32_MCG_CAP		0x179
-#define MSR_IA32_MCG_STATUS		0x17a
-#define MSR_IA32_MCG_CTL		0x17b
-
-/* P4/Xeon+ specific */
-#define MSR_IA32_MCG_EAX		0x180
-#define MSR_IA32_MCG_EBX		0x181
-#define MSR_IA32_MCG_ECX		0x182
-#define MSR_IA32_MCG_EDX		0x183
-#define MSR_IA32_MCG_ESI		0x184
-#define MSR_IA32_MCG_EDI		0x185
-#define MSR_IA32_MCG_EBP		0x186
-#define MSR_IA32_MCG_ESP		0x187
-#define MSR_IA32_MCG_EFLAGS		0x188
-#define MSR_IA32_MCG_EIP		0x189
-#define MSR_IA32_MCG_RESERVED		0x18A
-
-#define MSR_P6_EVNTSEL0			0x186
-#define MSR_P6_EVNTSEL1			0x187
-
-#define MSR_IA32_PERF_STATUS		0x198
-#define MSR_IA32_PERF_CTL		0x199
-
-#define MSR_IA32_MPERF			0xE7
-#define MSR_IA32_APERF			0xE8
-
-#define MSR_IA32_THERM_CONTROL		0x19a
-#define MSR_IA32_THERM_INTERRUPT	0x19b
-#define MSR_IA32_THERM_STATUS		0x19c
-#define MSR_IA32_MISC_ENABLE		0x1a0
-
-#define MSR_IA32_DEBUGCTLMSR		0x1d9
-#define MSR_IA32_LASTBRANCHFROMIP	0x1db
-#define MSR_IA32_LASTBRANCHTOIP		0x1dc
-#define MSR_IA32_LASTINTFROMIP		0x1dd
-#define MSR_IA32_LASTINTTOIP		0x1de
-
-#define MSR_IA32_MC0_CTL		0x400
-#define MSR_IA32_MC0_STATUS		0x401
-#define MSR_IA32_MC0_ADDR		0x402
-#define MSR_IA32_MC0_MISC		0x403
-
-#define MSR_IA32_PEBS_ENABLE		0x3f1
-#define MSR_IA32_DS_AREA		0x600
-#define MSR_IA32_PERF_CAPABILITIES	0x345
-
-/* Pentium IV performance counter MSRs */
-#define MSR_P4_BPU_PERFCTR0 		0x300
-#define MSR_P4_BPU_PERFCTR1 		0x301
-#define MSR_P4_BPU_PERFCTR2 		0x302
-#define MSR_P4_BPU_PERFCTR3 		0x303
-#define MSR_P4_MS_PERFCTR0 		0x304
-#define MSR_P4_MS_PERFCTR1 		0x305
-#define MSR_P4_MS_PERFCTR2 		0x306
-#define MSR_P4_MS_PERFCTR3 		0x307
-#define MSR_P4_FLAME_PERFCTR0 		0x308
-#define MSR_P4_FLAME_PERFCTR1 		0x309
-#define MSR_P4_FLAME_PERFCTR2 		0x30a
-#define MSR_P4_FLAME_PERFCTR3 		0x30b
-#define MSR_P4_IQ_PERFCTR0 		0x30c
-#define MSR_P4_IQ_PERFCTR1 		0x30d
-#define MSR_P4_IQ_PERFCTR2 		0x30e
-#define MSR_P4_IQ_PERFCTR3 		0x30f
-#define MSR_P4_IQ_PERFCTR4 		0x310
-#define MSR_P4_IQ_PERFCTR5 		0x311
-#define MSR_P4_BPU_CCCR0 		0x360
-#define MSR_P4_BPU_CCCR1 		0x361
-#define MSR_P4_BPU_CCCR2 		0x362
-#define MSR_P4_BPU_CCCR3 		0x363
-#define MSR_P4_MS_CCCR0 		0x364
-#define MSR_P4_MS_CCCR1 		0x365
-#define MSR_P4_MS_CCCR2 		0x366
-#define MSR_P4_MS_CCCR3 		0x367
-#define MSR_P4_FLAME_CCCR0 		0x368
-#define MSR_P4_FLAME_CCCR1 		0x369
-#define MSR_P4_FLAME_CCCR2 		0x36a
-#define MSR_P4_FLAME_CCCR3 		0x36b
-#define MSR_P4_IQ_CCCR0 		0x36c
-#define MSR_P4_IQ_CCCR1 		0x36d
-#define MSR_P4_IQ_CCCR2 		0x36e
-#define MSR_P4_IQ_CCCR3 		0x36f
-#define MSR_P4_IQ_CCCR4 		0x370
-#define MSR_P4_IQ_CCCR5 		0x371
-#define MSR_P4_ALF_ESCR0 		0x3ca
-#define MSR_P4_ALF_ESCR1 		0x3cb
-#define MSR_P4_BPU_ESCR0 		0x3b2
-#define MSR_P4_BPU_ESCR1 		0x3b3
-#define MSR_P4_BSU_ESCR0 		0x3a0
-#define MSR_P4_BSU_ESCR1 		0x3a1
-#define MSR_P4_CRU_ESCR0 		0x3b8
-#define MSR_P4_CRU_ESCR1 		0x3b9
-#define MSR_P4_CRU_ESCR2 		0x3cc
-#define MSR_P4_CRU_ESCR3 		0x3cd
-#define MSR_P4_CRU_ESCR4 		0x3e0
-#define MSR_P4_CRU_ESCR5 		0x3e1
-#define MSR_P4_DAC_ESCR0 		0x3a8
-#define MSR_P4_DAC_ESCR1 		0x3a9
-#define MSR_P4_FIRM_ESCR0 		0x3a4
-#define MSR_P4_FIRM_ESCR1 		0x3a5
-#define MSR_P4_FLAME_ESCR0 		0x3a6
-#define MSR_P4_FLAME_ESCR1 		0x3a7
-#define MSR_P4_FSB_ESCR0 		0x3a2
-#define MSR_P4_FSB_ESCR1 		0x3a3
-#define MSR_P4_IQ_ESCR0 		0x3ba
-#define MSR_P4_IQ_ESCR1 		0x3bb
-#define MSR_P4_IS_ESCR0 		0x3b4
-#define MSR_P4_IS_ESCR1 		0x3b5
-#define MSR_P4_ITLB_ESCR0 		0x3b6
-#define MSR_P4_ITLB_ESCR1 		0x3b7
-#define MSR_P4_IX_ESCR0 		0x3c8
-#define MSR_P4_IX_ESCR1 		0x3c9
-#define MSR_P4_MOB_ESCR0 		0x3aa
-#define MSR_P4_MOB_ESCR1 		0x3ab
-#define MSR_P4_MS_ESCR0 		0x3c0
-#define MSR_P4_MS_ESCR1 		0x3c1
-#define MSR_P4_PMH_ESCR0 		0x3ac
-#define MSR_P4_PMH_ESCR1 		0x3ad
-#define MSR_P4_RAT_ESCR0 		0x3bc
-#define MSR_P4_RAT_ESCR1 		0x3bd
-#define MSR_P4_SAAT_ESCR0 		0x3ae
-#define MSR_P4_SAAT_ESCR1 		0x3af
-#define MSR_P4_SSU_ESCR0 		0x3be
-#define MSR_P4_SSU_ESCR1 		0x3bf    /* guess: not defined in manual */
-#define MSR_P4_TBPU_ESCR0 		0x3c2
-#define MSR_P4_TBPU_ESCR1 		0x3c3
-#define MSR_P4_TC_ESCR0 		0x3c4
-#define MSR_P4_TC_ESCR1 		0x3c5
-#define MSR_P4_U2L_ESCR0 		0x3b0
-#define MSR_P4_U2L_ESCR1 		0x3b1
-
-/* AMD Defined MSRs */
-#define MSR_K6_EFER			0xC0000080
-#define MSR_K6_STAR			0xC0000081
-#define MSR_K6_WHCR			0xC0000082
-#define MSR_K6_UWCCR			0xC0000085
-#define MSR_K6_EPMR			0xC0000086
-#define MSR_K6_PSOR			0xC0000087
-#define MSR_K6_PFIR			0xC0000088
-
-#define MSR_K7_EVNTSEL0			0xC0010000
-#define MSR_K7_EVNTSEL1			0xC0010001
-#define MSR_K7_EVNTSEL2			0xC0010002
-#define MSR_K7_EVNTSEL3			0xC0010003
-#define MSR_K7_PERFCTR0			0xC0010004
-#define MSR_K7_PERFCTR1			0xC0010005
-#define MSR_K7_PERFCTR2			0xC0010006
-#define MSR_K7_PERFCTR3			0xC0010007
-#define MSR_K7_HWCR			0xC0010015
-#define MSR_K7_CLK_CTL			0xC001001b
-#define MSR_K7_FID_VID_CTL		0xC0010041
-#define MSR_K7_FID_VID_STATUS		0xC0010042
-
-#define MSR_K8_ENABLE_C1E		0xC0010055
-
-/* extended feature register */
-#define MSR_EFER 			0xc0000080
-
-/* EFER bits: */
-
-/* Execute Disable enable */
-#define _EFER_NX			11
-#define EFER_NX				(1<<_EFER_NX)
-
-/* Centaur-Hauls/IDT defined MSRs. */
-#define MSR_IDT_FCR1			0x107
-#define MSR_IDT_FCR2			0x108
-#define MSR_IDT_FCR3			0x109
-#define MSR_IDT_FCR4			0x10a
-
-#define MSR_IDT_MCR0			0x110
-#define MSR_IDT_MCR1			0x111
-#define MSR_IDT_MCR2			0x112
-#define MSR_IDT_MCR3			0x113
-#define MSR_IDT_MCR4			0x114
-#define MSR_IDT_MCR5			0x115
-#define MSR_IDT_MCR6			0x116
-#define MSR_IDT_MCR7			0x117
-#define MSR_IDT_MCR_CTRL		0x120
-
-/* VIA Cyrix defined MSRs*/
-#define MSR_VIA_FCR			0x1107
-#define MSR_VIA_LONGHAUL		0x110a
-#define MSR_VIA_RNG			0x110b
-#define MSR_VIA_BCR2			0x1147
-
-/* Transmeta defined MSRs */
-#define MSR_TMTA_LONGRUN_CTRL		0x80868010
-#define MSR_TMTA_LONGRUN_FLAGS		0x80868011
-#define MSR_TMTA_LRTI_READOUT		0x80868018
-#define MSR_TMTA_LRTI_VOLT_MHZ		0x8086801a
-
-/* Intel Core-based CPU performance counters */
-#define MSR_CORE_PERF_FIXED_CTR0	0x309
-#define MSR_CORE_PERF_FIXED_CTR1	0x30a
-#define MSR_CORE_PERF_FIXED_CTR2	0x30b
-#define MSR_CORE_PERF_FIXED_CTR_CTRL	0x38d
-#define MSR_CORE_PERF_GLOBAL_STATUS	0x38e
-#define MSR_CORE_PERF_GLOBAL_CTRL	0x38f
-#define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x390
-
-/* Geode defined MSRs */
-#define MSR_GEODE_BUSCONT_CONF0         0x1900
-
+#endif
+#endif
 #endif /* __ASM_MSR_H */
Index: linux/include/asm-i386/processor-flags.h
===================================================================
--- linux.orig/include/asm-i386/processor-flags.h
+++ linux/include/asm-i386/processor-flags.h
@@ -23,4 +23,69 @@
 #define X86_EFLAGS_VIP	0x00100000 /* Virtual Interrupt Pending */
 #define X86_EFLAGS_ID	0x00200000 /* CPUID detection flag */
 
+/*
+ * Basic CPU control in CR0
+ */
+#define X86_CR0_PE	0x00000001 /* Protection Enable */
+#define X86_CR0_MP	0x00000002 /* Monitor Coprocessor */
+#define X86_CR0_EM	0x00000004 /* Emulation */
+#define X86_CR0_TS	0x00000008 /* Task Switched */
+#define X86_CR0_ET	0x00000010 /* Extension Type */
+#define X86_CR0_NE	0x00000020 /* Numeric Error */
+#define X86_CR0_WP	0x00010000 /* Write Protect */
+#define X86_CR0_AM	0x00040000 /* Alignment Mask */
+#define X86_CR0_NW	0x20000000 /* Not Write-through */
+#define X86_CR0_CD	0x40000000 /* Cache Disable */
+#define X86_CR0_PG	0x80000000 /* Paging */
+
+/*
+ * Paging options in CR3
+ */
+#define X86_CR3_PWT	0x00000008 /* Page Write Through */
+#define X86_CR3_PCD	0x00000010 /* Page Cache Disable */
+
+/*
+ * Intel CPU features in CR4
+ */
+#define X86_CR4_VME	0x00000001 /* enable vm86 extensions */
+#define X86_CR4_PVI	0x00000002 /* virtual interrupts flag enable */
+#define X86_CR4_TSD	0x00000004 /* disable time stamp at ipl 3 */
+#define X86_CR4_DE	0x00000008 /* enable debugging extensions */
+#define X86_CR4_PSE	0x00000010 /* enable page size extensions */
+#define X86_CR4_PAE	0x00000020 /* enable physical address extensions */
+#define X86_CR4_MCE	0x00000040 /* Machine check enable */
+#define X86_CR4_PGE	0x00000080 /* enable global pages */
+#define X86_CR4_PCE	0x00000100 /* enable performance counters at ipl 3 */
+#define X86_CR4_OSFXSR	0x00000200 /* enable fast FPU save and restore */
+#define X86_CR4_OSXMMEXCPT 0x00000400 /* enable unmasked SSE exceptions */
+#define X86_CR4_VMXE	0x00002000 /* enable VMX virtualization */
+
+/*
+ * x86-64 Task Priority Register, CR8
+ */
+#define X86_CR8_TPR	0x00000007 /* task priority register */
+
+/*
+ * AMD and Transmeta use MSRs for configuration; see <asm/msr-index.h>
+ */
+
+/*
+ *      NSC/Cyrix CPU configuration register indexes
+ */
+#define CX86_PCR0	0x20
+#define CX86_GCR	0xb8
+#define CX86_CCR0	0xc0
+#define CX86_CCR1	0xc1
+#define CX86_CCR2	0xc2
+#define CX86_CCR3	0xc3
+#define CX86_CCR4	0xe8
+#define CX86_CCR5	0xe9
+#define CX86_CCR6	0xea
+#define CX86_CCR7	0xeb
+#define CX86_PCR1	0xf0
+#define CX86_DIR0	0xfe
+#define CX86_DIR1	0xff
+#define CX86_ARR_BASE	0xc4
+#define CX86_RCR_BASE	0xdc
+
 #endif	/* __ASM_I386_PROCESSOR_FLAGS_H */
Index: linux/include/asm-i386/processor.h
===================================================================
--- linux.orig/include/asm-i386/processor.h
+++ linux/include/asm-i386/processor.h
@@ -143,21 +143,6 @@ static inline void native_cpuid(unsigned
 #define load_cr3(pgdir) write_cr3(__pa(pgdir))
 
 /*
- * Intel CPU features in CR4
- */
-#define X86_CR4_VME		0x0001	/* enable vm86 extensions */
-#define X86_CR4_PVI		0x0002	/* virtual interrupts flag enable */
-#define X86_CR4_TSD		0x0004	/* disable time stamp at ipl 3 */
-#define X86_CR4_DE		0x0008	/* enable debugging extensions */
-#define X86_CR4_PSE		0x0010	/* enable page size extensions */
-#define X86_CR4_PAE		0x0020	/* enable physical address extensions */
-#define X86_CR4_MCE		0x0040	/* Machine check enable */
-#define X86_CR4_PGE		0x0080	/* enable global pages */
-#define X86_CR4_PCE		0x0100	/* enable performance counters at ipl 3 */
-#define X86_CR4_OSFXSR		0x0200	/* enable fast FPU save and restore */
-#define X86_CR4_OSXMMEXCPT	0x0400	/* enable unmasked SSE exceptions */
-
-/*
  * Save the cr4 feature set we're using (ie
  * Pentium 4MB enable and PPro Global page
  * enable), so that any CPU's that boot up
@@ -184,26 +169,6 @@ static inline void clear_in_cr4 (unsigne
 }
 
 /*
- *      NSC/Cyrix CPU configuration register indexes
- */
-
-#define CX86_PCR0 0x20
-#define CX86_GCR  0xb8
-#define CX86_CCR0 0xc0
-#define CX86_CCR1 0xc1
-#define CX86_CCR2 0xc2
-#define CX86_CCR3 0xc3
-#define CX86_CCR4 0xe8
-#define CX86_CCR5 0xe9
-#define CX86_CCR6 0xea
-#define CX86_CCR7 0xeb
-#define CX86_PCR1 0xf0
-#define CX86_DIR0 0xfe
-#define CX86_DIR1 0xff
-#define CX86_ARR_BASE 0xc4
-#define CX86_RCR_BASE 0xdc
-
-/*
  *      NSC/Cyrix CPU indexed register access macros
  */
 
Index: linux/include/asm-x86_64/Kbuild
===================================================================
--- linux.orig/include/asm-x86_64/Kbuild
+++ linux/include/asm-x86_64/Kbuild
@@ -8,7 +8,7 @@ header-y += boot.h
 header-y += bootsetup.h
 header-y += debugreg.h
 header-y += ldt.h
-header-y += msr.h
+header-y += msr-index.h
 header-y += prctl.h
 header-y += ptrace-abi.h
 header-y += sigcontext32.h
@@ -16,6 +16,7 @@ header-y += ucontext.h
 header-y += vsyscall32.h
 
 unifdef-y += mce.h
+unifdef-y += msr.h
 unifdef-y += mtrr.h
 unifdef-y += vsyscall.h
 unifdef-y += const.h
Index: linux/include/asm-x86_64/msr-index.h
===================================================================
--- /dev/null
+++ linux/include/asm-x86_64/msr-index.h
@@ -0,0 +1 @@
+#include <asm-i386/msr-index.h>
Index: linux/include/asm-x86_64/msr.h
===================================================================
--- linux.orig/include/asm-x86_64/msr.h
+++ linux/include/asm-x86_64/msr.h
@@ -1,6 +1,8 @@
 #ifndef X86_64_MSR_H
 #define X86_64_MSR_H 1
 
+#include <asm/msr-index.h>
+
 #ifndef __ASSEMBLY__
 /*
  * Access to machine-specific registers (available on 586 and better only)
@@ -157,9 +159,6 @@ static inline unsigned int cpuid_edx(uns
 	return edx;
 }
 
-#define MSR_IA32_UCODE_WRITE		0x79
-#define MSR_IA32_UCODE_REV		0x8b
-
 #ifdef CONFIG_SMP
 void rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
 void wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
@@ -172,269 +171,6 @@ static inline void wrmsr_on_cpu(unsigned
 {
 	wrmsr(msr_no, l, h);
 }
-#endif  /*  CONFIG_SMP  */
-
-#endif
-
-/* AMD/K8 specific MSRs */ 
-#define MSR_EFER 0xc0000080		/* extended feature register */
-#define MSR_STAR 0xc0000081		/* legacy mode SYSCALL target */
-#define MSR_LSTAR 0xc0000082 		/* long mode SYSCALL target */
-#define MSR_CSTAR 0xc0000083		/* compatibility mode SYSCALL target */
-#define MSR_SYSCALL_MASK 0xc0000084	/* EFLAGS mask for syscall */
-#define MSR_FS_BASE 0xc0000100		/* 64bit FS base */
-#define MSR_GS_BASE 0xc0000101		/* 64bit GS base */
-#define MSR_KERNEL_GS_BASE  0xc0000102	/* SwapGS GS shadow (or USER_GS from kernel) */ 
-/* EFER bits: */ 
-#define _EFER_SCE 0  /* SYSCALL/SYSRET */
-#define _EFER_LME 8  /* Long mode enable */
-#define _EFER_LMA 10 /* Long mode active (read-only) */
-#define _EFER_NX 11  /* No execute enable */
-
-#define EFER_SCE (1<<_EFER_SCE)
-#define EFER_LME (1<<_EFER_LME)
-#define EFER_LMA (1<<_EFER_LMA)
-#define EFER_NX (1<<_EFER_NX)
-
-/* Intel MSRs. Some also available on other CPUs */
-#define MSR_IA32_TSC		0x10
-#define MSR_IA32_PLATFORM_ID	0x17
-
-#define MSR_IA32_PERFCTR0      0xc1
-#define MSR_IA32_PERFCTR1      0xc2
-#define MSR_FSB_FREQ		0xcd
-
-#define MSR_MTRRcap		0x0fe
-#define MSR_IA32_BBL_CR_CTL        0x119
-
-#define MSR_IA32_SYSENTER_CS	0x174
-#define MSR_IA32_SYSENTER_ESP	0x175
-#define MSR_IA32_SYSENTER_EIP	0x176
-
-#define MSR_IA32_MCG_CAP       0x179
-#define MSR_IA32_MCG_STATUS        0x17a
-#define MSR_IA32_MCG_CTL       0x17b
-
-#define MSR_IA32_EVNTSEL0      0x186
-#define MSR_IA32_EVNTSEL1      0x187
-
-#define MSR_IA32_DEBUGCTLMSR       0x1d9
-#define MSR_IA32_LASTBRANCHFROMIP  0x1db
-#define MSR_IA32_LASTBRANCHTOIP        0x1dc
-#define MSR_IA32_LASTINTFROMIP     0x1dd
-#define MSR_IA32_LASTINTTOIP       0x1de
-
-#define MSR_IA32_PEBS_ENABLE		0x3f1
-#define MSR_IA32_DS_AREA		0x600
-#define MSR_IA32_PERF_CAPABILITIES	0x345
-
-#define MSR_MTRRfix64K_00000	0x250
-#define MSR_MTRRfix16K_80000	0x258
-#define MSR_MTRRfix16K_A0000	0x259
-#define MSR_MTRRfix4K_C0000	0x268
-#define MSR_MTRRfix4K_C8000	0x269
-#define MSR_MTRRfix4K_D0000	0x26a
-#define MSR_MTRRfix4K_D8000	0x26b
-#define MSR_MTRRfix4K_E0000	0x26c
-#define MSR_MTRRfix4K_E8000	0x26d
-#define MSR_MTRRfix4K_F0000	0x26e
-#define MSR_MTRRfix4K_F8000	0x26f
-#define MSR_MTRRdefType		0x2ff
-
-#define MSR_IA32_MC0_CTL       0x400
-#define MSR_IA32_MC0_STATUS        0x401
-#define MSR_IA32_MC0_ADDR      0x402
-#define MSR_IA32_MC0_MISC      0x403
-
-#define MSR_P6_PERFCTR0			0xc1
-#define MSR_P6_PERFCTR1			0xc2
-#define MSR_P6_EVNTSEL0			0x186
-#define MSR_P6_EVNTSEL1			0x187
-
-/* K7/K8 MSRs. Not complete. See the architecture manual for a more complete list. */
-#define MSR_K7_EVNTSEL0            0xC0010000
-#define MSR_K7_PERFCTR0            0xC0010004
-#define MSR_K7_EVNTSEL1            0xC0010001
-#define MSR_K7_PERFCTR1            0xC0010005
-#define MSR_K7_EVNTSEL2            0xC0010002
-#define MSR_K7_PERFCTR2            0xC0010006
-#define MSR_K7_EVNTSEL3            0xC0010003
-#define MSR_K7_PERFCTR3            0xC0010007
-#define MSR_K8_TOP_MEM1		   0xC001001A
-#define MSR_K8_TOP_MEM2		   0xC001001D
-#define MSR_K8_SYSCFG		   0xC0010010
-#define MSR_K8_HWCR		   0xC0010015
-
-/* K6 MSRs */
-#define MSR_K6_EFER			0xC0000080
-#define MSR_K6_STAR			0xC0000081
-#define MSR_K6_WHCR			0xC0000082
-#define MSR_K6_UWCCR			0xC0000085
-#define MSR_K6_PSOR			0xC0000087
-#define MSR_K6_PFIR			0xC0000088
-
-/* Centaur-Hauls/IDT defined MSRs. */
-#define MSR_IDT_FCR1			0x107
-#define MSR_IDT_FCR2			0x108
-#define MSR_IDT_FCR3			0x109
-#define MSR_IDT_FCR4			0x10a
-
-#define MSR_IDT_MCR0			0x110
-#define MSR_IDT_MCR1			0x111
-#define MSR_IDT_MCR2			0x112
-#define MSR_IDT_MCR3			0x113
-#define MSR_IDT_MCR4			0x114
-#define MSR_IDT_MCR5			0x115
-#define MSR_IDT_MCR6			0x116
-#define MSR_IDT_MCR7			0x117
-#define MSR_IDT_MCR_CTRL		0x120
-
-/* VIA Cyrix defined MSRs*/
-#define MSR_VIA_FCR			0x1107
-#define MSR_VIA_LONGHAUL		0x110a
-#define MSR_VIA_RNG			0x110b
-#define MSR_VIA_BCR2			0x1147
-
-/* Intel defined MSRs. */
-#define MSR_IA32_P5_MC_ADDR		0
-#define MSR_IA32_P5_MC_TYPE		1
-#define MSR_IA32_PLATFORM_ID		0x17
-#define MSR_IA32_EBL_CR_POWERON		0x2a
-
-#define MSR_IA32_APICBASE               0x1b
-#define MSR_IA32_APICBASE_BSP           (1<<8)
-#define MSR_IA32_APICBASE_ENABLE        (1<<11)
-#define MSR_IA32_APICBASE_BASE          (0xfffff<<12)
-
-/* P4/Xeon+ specific */
-#define MSR_IA32_MCG_EAX		0x180
-#define MSR_IA32_MCG_EBX		0x181
-#define MSR_IA32_MCG_ECX		0x182
-#define MSR_IA32_MCG_EDX		0x183
-#define MSR_IA32_MCG_ESI		0x184
-#define MSR_IA32_MCG_EDI		0x185
-#define MSR_IA32_MCG_EBP		0x186
-#define MSR_IA32_MCG_ESP		0x187
-#define MSR_IA32_MCG_EFLAGS		0x188
-#define MSR_IA32_MCG_EIP		0x189
-#define MSR_IA32_MCG_RESERVED		0x18A
-
-#define MSR_P6_EVNTSEL0			0x186
-#define MSR_P6_EVNTSEL1			0x187
-
-#define MSR_IA32_PERF_STATUS		0x198
-#define MSR_IA32_PERF_CTL		0x199
-
-#define MSR_IA32_MPERF			0xE7
-#define MSR_IA32_APERF			0xE8
-
-#define MSR_IA32_THERM_CONTROL		0x19a
-#define MSR_IA32_THERM_INTERRUPT	0x19b
-#define MSR_IA32_THERM_STATUS		0x19c
-#define MSR_IA32_MISC_ENABLE		0x1a0
-
-#define MSR_IA32_DEBUGCTLMSR		0x1d9
-#define MSR_IA32_LASTBRANCHFROMIP	0x1db
-#define MSR_IA32_LASTBRANCHTOIP		0x1dc
-#define MSR_IA32_LASTINTFROMIP		0x1dd
-#define MSR_IA32_LASTINTTOIP		0x1de
-
-#define MSR_IA32_MC0_CTL		0x400
-#define MSR_IA32_MC0_STATUS		0x401
-#define MSR_IA32_MC0_ADDR		0x402
-#define MSR_IA32_MC0_MISC		0x403
-
-/* Pentium IV performance counter MSRs */
-#define MSR_P4_BPU_PERFCTR0 		0x300
-#define MSR_P4_BPU_PERFCTR1 		0x301
-#define MSR_P4_BPU_PERFCTR2 		0x302
-#define MSR_P4_BPU_PERFCTR3 		0x303
-#define MSR_P4_MS_PERFCTR0 		0x304
-#define MSR_P4_MS_PERFCTR1 		0x305
-#define MSR_P4_MS_PERFCTR2 		0x306
-#define MSR_P4_MS_PERFCTR3 		0x307
-#define MSR_P4_FLAME_PERFCTR0 		0x308
-#define MSR_P4_FLAME_PERFCTR1 		0x309
-#define MSR_P4_FLAME_PERFCTR2 		0x30a
-#define MSR_P4_FLAME_PERFCTR3 		0x30b
-#define MSR_P4_IQ_PERFCTR0 		0x30c
-#define MSR_P4_IQ_PERFCTR1 		0x30d
-#define MSR_P4_IQ_PERFCTR2 		0x30e
-#define MSR_P4_IQ_PERFCTR3 		0x30f
-#define MSR_P4_IQ_PERFCTR4 		0x310
-#define MSR_P4_IQ_PERFCTR5 		0x311
-#define MSR_P4_BPU_CCCR0 		0x360
-#define MSR_P4_BPU_CCCR1 		0x361
-#define MSR_P4_BPU_CCCR2 		0x362
-#define MSR_P4_BPU_CCCR3 		0x363
-#define MSR_P4_MS_CCCR0 		0x364
-#define MSR_P4_MS_CCCR1 		0x365
-#define MSR_P4_MS_CCCR2 		0x366
-#define MSR_P4_MS_CCCR3 		0x367
-#define MSR_P4_FLAME_CCCR0 		0x368
-#define MSR_P4_FLAME_CCCR1 		0x369
-#define MSR_P4_FLAME_CCCR2 		0x36a
-#define MSR_P4_FLAME_CCCR3 		0x36b
-#define MSR_P4_IQ_CCCR0 		0x36c
-#define MSR_P4_IQ_CCCR1 		0x36d
-#define MSR_P4_IQ_CCCR2 		0x36e
-#define MSR_P4_IQ_CCCR3 		0x36f
-#define MSR_P4_IQ_CCCR4 		0x370
-#define MSR_P4_IQ_CCCR5 		0x371
-#define MSR_P4_ALF_ESCR0 		0x3ca
-#define MSR_P4_ALF_ESCR1 		0x3cb
-#define MSR_P4_BPU_ESCR0 		0x3b2
-#define MSR_P4_BPU_ESCR1 		0x3b3
-#define MSR_P4_BSU_ESCR0 		0x3a0
-#define MSR_P4_BSU_ESCR1 		0x3a1
-#define MSR_P4_CRU_ESCR0 		0x3b8
-#define MSR_P4_CRU_ESCR1 		0x3b9
-#define MSR_P4_CRU_ESCR2 		0x3cc
-#define MSR_P4_CRU_ESCR3 		0x3cd
-#define MSR_P4_CRU_ESCR4 		0x3e0
-#define MSR_P4_CRU_ESCR5 		0x3e1
-#define MSR_P4_DAC_ESCR0 		0x3a8
-#define MSR_P4_DAC_ESCR1 		0x3a9
-#define MSR_P4_FIRM_ESCR0 		0x3a4
-#define MSR_P4_FIRM_ESCR1 		0x3a5
-#define MSR_P4_FLAME_ESCR0 		0x3a6
-#define MSR_P4_FLAME_ESCR1 		0x3a7
-#define MSR_P4_FSB_ESCR0 		0x3a2
-#define MSR_P4_FSB_ESCR1 		0x3a3
-#define MSR_P4_IQ_ESCR0 		0x3ba
-#define MSR_P4_IQ_ESCR1 		0x3bb
-#define MSR_P4_IS_ESCR0 		0x3b4
-#define MSR_P4_IS_ESCR1 		0x3b5
-#define MSR_P4_ITLB_ESCR0 		0x3b6
-#define MSR_P4_ITLB_ESCR1 		0x3b7
-#define MSR_P4_IX_ESCR0 		0x3c8
-#define MSR_P4_IX_ESCR1 		0x3c9
-#define MSR_P4_MOB_ESCR0 		0x3aa
-#define MSR_P4_MOB_ESCR1 		0x3ab
-#define MSR_P4_MS_ESCR0 		0x3c0
-#define MSR_P4_MS_ESCR1 		0x3c1
-#define MSR_P4_PMH_ESCR0 		0x3ac
-#define MSR_P4_PMH_ESCR1 		0x3ad
-#define MSR_P4_RAT_ESCR0 		0x3bc
-#define MSR_P4_RAT_ESCR1 		0x3bd
-#define MSR_P4_SAAT_ESCR0 		0x3ae
-#define MSR_P4_SAAT_ESCR1 		0x3af
-#define MSR_P4_SSU_ESCR0 		0x3be
-#define MSR_P4_SSU_ESCR1 		0x3bf    /* guess: not defined in manual */
-#define MSR_P4_TBPU_ESCR0 		0x3c2
-#define MSR_P4_TBPU_ESCR1 		0x3c3
-#define MSR_P4_TC_ESCR0 		0x3c4
-#define MSR_P4_TC_ESCR1 		0x3c5
-#define MSR_P4_U2L_ESCR0 		0x3b0
-#define MSR_P4_U2L_ESCR1 		0x3b1
-
-/* Intel Core-based CPU performance counters */
-#define MSR_CORE_PERF_FIXED_CTR0	0x309
-#define MSR_CORE_PERF_FIXED_CTR1	0x30a
-#define MSR_CORE_PERF_FIXED_CTR2	0x30b
-#define MSR_CORE_PERF_FIXED_CTR_CTRL	0x38d
-#define MSR_CORE_PERF_GLOBAL_STATUS	0x38e
-#define MSR_CORE_PERF_GLOBAL_CTRL	0x38f
-#define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x390
-
-#endif
+#endif  /* CONFIG_SMP */
+#endif /* __ASSEMBLY__ */
+#endif	/* X86_64_MSR_H */
Index: linux/include/asm-x86_64/processor-flags.h
===================================================================
--- linux.orig/include/asm-x86_64/processor-flags.h
+++ linux/include/asm-x86_64/processor-flags.h
@@ -1,26 +1 @@
-#ifndef __ASM_X86_64_PROCESSOR_FLAGS_H
-#define __ASM_X86_64_PROCESSOR_FLAGS_H
-/* Various flags defined: can be included from assembler. */
-
-/*
- * EFLAGS bits
- */
-#define X86_EFLAGS_CF	0x00000001 /* Carry Flag */
-#define X86_EFLAGS_PF	0x00000004 /* Parity Flag */
-#define X86_EFLAGS_AF	0x00000010 /* Auxillary carry Flag */
-#define X86_EFLAGS_ZF	0x00000040 /* Zero Flag */
-#define X86_EFLAGS_SF	0x00000080 /* Sign Flag */
-#define X86_EFLAGS_TF	0x00000100 /* Trap Flag */
-#define X86_EFLAGS_IF	0x00000200 /* Interrupt Flag */
-#define X86_EFLAGS_DF	0x00000400 /* Direction Flag */
-#define X86_EFLAGS_OF	0x00000800 /* Overflow Flag */
-#define X86_EFLAGS_IOPL	0x00003000 /* IOPL mask */
-#define X86_EFLAGS_NT	0x00004000 /* Nested Task */
-#define X86_EFLAGS_RF	0x00010000 /* Resume Flag */
-#define X86_EFLAGS_VM	0x00020000 /* Virtual Mode */
-#define X86_EFLAGS_AC	0x00040000 /* Alignment Check */
-#define X86_EFLAGS_VIF	0x00080000 /* Virtual Interrupt Flag */
-#define X86_EFLAGS_VIP	0x00100000 /* Virtual Interrupt Pending */
-#define X86_EFLAGS_ID	0x00200000 /* CPUID detection flag */
-
-#endif /* __ASM_X86_64_PROCESSOR_FLAGS_H */
+#include <asm-i386/processor-flags.h>
Index: linux/include/asm-x86_64/processor.h
===================================================================
--- linux.orig/include/asm-x86_64/processor.h
+++ linux/include/asm-x86_64/processor.h
@@ -104,21 +104,6 @@ extern unsigned int init_intel_cacheinfo
 extern unsigned short num_cache_leaves;
 
 /*
- * Intel CPU features in CR4
- */
-#define X86_CR4_VME		0x0001	/* enable vm86 extensions */
-#define X86_CR4_PVI		0x0002	/* virtual interrupts flag enable */
-#define X86_CR4_TSD		0x0004	/* disable time stamp at ipl 3 */
-#define X86_CR4_DE		0x0008	/* enable debugging extensions */
-#define X86_CR4_PSE		0x0010	/* enable page size extensions */
-#define X86_CR4_PAE		0x0020	/* enable physical address extensions */
-#define X86_CR4_MCE		0x0040	/* Machine check enable */
-#define X86_CR4_PGE		0x0080	/* enable global pages */
-#define X86_CR4_PCE		0x0100	/* enable performance counters at ipl 3 */
-#define X86_CR4_OSFXSR		0x0200	/* enable fast FPU save and restore */
-#define X86_CR4_OSXMMEXCPT	0x0400	/* enable unmasked SSE exceptions */
-
-/*
  * Save the cr4 feature set we're using (ie
  * Pentium 4MB enable and PPro Global page
  * enable), so that any CPU's that boot up
@@ -407,22 +392,6 @@ static inline void prefetchw(void *x) 
 #define cpu_relax()   rep_nop()
 
 /*
- *      NSC/Cyrix CPU configuration register indexes
- */
-#define CX86_CCR0 0xc0
-#define CX86_CCR1 0xc1
-#define CX86_CCR2 0xc2
-#define CX86_CCR3 0xc3
-#define CX86_CCR4 0xe8
-#define CX86_CCR5 0xe9
-#define CX86_CCR6 0xea
-#define CX86_CCR7 0xeb
-#define CX86_DIR0 0xfe
-#define CX86_DIR1 0xff
-#define CX86_ARR_BASE 0xc4
-#define CX86_RCR_BASE 0xdc
-
-/*
  *      NSC/Cyrix CPU indexed register access macros
  */
 
