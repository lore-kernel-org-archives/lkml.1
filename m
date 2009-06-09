Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZFIIaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZFIIaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZFII3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:29:44 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:52483 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543AbZFII3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:29:42 -0400
Date: Tue, 9 Jun 2009 16:29:31 +0800
From: Harald Welte <HaraldWelte@viatech.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Subject: [PATCH] X86: cpu_debug support for VIA / Centaur CPU's
Message-ID: <20090609082931.GD25316@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the MSR definitions for the VIA/Centaur CPU models
to cpu_debug.c

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
---
 arch/x86/include/asm/cpu_debug.h |   21 +++++-
 arch/x86/kernel/cpu/cpu_debug.c  |  176 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 196 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index 2228020..3790657 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -134,6 +134,12 @@ enum cpu_processor_bit {
 	CPU_AMD_0F_BIT,
 	CPU_AMD_10_BIT,
 	CPU_AMD_11_BIT,
+/* Centaur */
+	CPU_CENTAUR_C3_BIT,
+	CPU_CENTAUR_C5_BIT,
+	CPU_CENTAUR_C7A_BIT,
+	CPU_CENTAUR_C7D_BIT,
+	CPU_CENTAUR_NANO_BIT,
 };
 
 #define	CPU_INTEL_PENTIUM	(1 << CPU_INTEL_PENTIUM_BIT)
@@ -183,8 +189,21 @@ enum cpu_processor_bit {
 /* Select all supported AMD CPUs */
 #define	CPU_AMD_ALL		(CPU_AMD_K6 | CPU_K7_PLUS)
 
+
+#define CPU_CENT_C3		(1 << CPU_CENTAUR_C3_BIT)
+#define CPU_CENT_C5		(1 << CPU_CENTAUR_C5_BIT)
+#define CPU_CENT_C7A		(1 << CPU_CENTAUR_C7A_BIT)
+#define CPU_CENT_C7D		(1 << CPU_CENTAUR_C7D_BIT)
+#define CPU_CENT_NANO		(1 << CPU_CENTAUR_NANO_BIT)
+
+#define CPU_CENT_C7		(CPU_CENT_C7A | CPU_CENT_C7D)
+#define CPU_CENT_C7_PLUS	(CPU_CENT_C7 | CPU_CENT_NANO)
+
+#define CPU_CENT_ALL		(CPU_CENT_C3 | CPU_CENT_C5 | CPU_CENT_C7 \
+				 | CPU_CENT_NANO)
+
 /* Select all supported CPUs */
-#define	CPU_ALL			(CPU_INTEL_ALL | CPU_AMD_ALL)
+#define	CPU_ALL			(CPU_INTEL_ALL | CPU_AMD_ALL | CPU_CENT_ALL)
 
 #define MAX_CPU_FILES		512
 
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 46e29ab..7add52b 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -2,6 +2,7 @@
  * CPU x86 architecture debug code
  *
  * Copyright(C) 2009 Jaswinder Singh Rajput
+ * Copyright(C) 2009 VIA Technology, Inc.
  *
  * For licencing details see kernel-base/COPYING
  */
@@ -225,6 +226,93 @@ static struct cpu_debug_range cpu_amd_range[] = {
 	{ 0xC0011022, 0xC0011023, CPU_CONF,	CPU_K10_PLUS,		},
 };
 
+/* Centaur Registers Range */
+static struct cpu_debug_range cpu_centaur_range[] = {
+	{ 0x00000000, 0x00000001, CPU_MC,	CPU_CENT_NANO		},
+	{ 0x00000006, 0x00000007, CPU_MONITOR,	CPU_CENT_NANO		},
+	{ 0x00000010, 0x00000010, CPU_TIME,	CPU_CENT_C7_PLUS	},
+	{ 0x00000017, 0x00000017, CPU_PLATFORM,	CPU_CENT_NANO		},
+	{ 0x0000001B, 0x0000001B, CPU_APIC,	CPU_CENT_C7_PLUS,	},
+	{ 0x0000002A, 0x0000002A, CPU_POWERON,	CPU_CENT_C7_PLUS,	},
+	{ 0x0000003A, 0x0000003A, CPU_CONTROL,	CPU_CENT_NANO,		},
+	/* IUA32_BIOS_UDPT_TRIG, trigger bios update */
+	{ 0x00000079, 0x00000079, CPU_BIOS,	CPU_CENT_NANO,		},
+	/* IA32_BIOS_SIGN_ID, determine ucode update level */
+	{ 0x0000008B, 0x0000008B, CPU_BIOS,	CPU_CENT_NANO,		},
+	/* IA32_SMM_MONITOR_CTL */
+	{ 0x0000009B, 0x0000009B, CPU_MONITOR,	CPU_CENT_NANO,		},
+	{ 0x000000C1, 0x000000C2, CPU_PMC,	CPU_CENT_C7_PLUS,	},
+	{ 0x000000C3, 0x000000C3, CPU_PMC,	CPU_CENT_NANO,		},
+	/* MSR_FSB_FREQ */
+	{ 0x000000CD, 0x000000CD, CPU_FREQ,	CPU_CENT_NANO,		},
+	/* IA32_MPERF, IA32_APERF */
+	{ 0x000000E7, 0x000000E8, CPU_PERF,	CPU_CENT_C7_PLUS,	},
+	/* IA32_MTRCAP */
+	{ 0x000000FE, 0x000000FE, CPU_MTRR,	CPU_CENT_C7_PLUS,	},
+	/* MSR_BBL_CR_CTL3 */
+	{ 0x0000011E, 0x0000011E, CPU_CACHE,	CPU_CENT_C7_PLUS,	},
+	/* IA32_SYSENTER_{CS,ESP,EIP} */
+	{ 0x00000174, 0x00000176, CPU_SYSENTER,	CPU_CENT_C7_PLUS,	},
+	{ 0x00000186, 0x00000187, CPU_PMC,	CPU_CENT_C7_PLUS,	},
+	/* performance status, performance control */
+	{ 0x00000198, 0x00000199, CPU_PERF,	CPU_CENT_C7_PLUS,	},
+	/* clock modulation */
+	{ 0x0000019A, 0x0000019A, CPU_FREQ,	CPU_CENT_C7_PLUS	},
+	/* thermal interrupt / status / control */
+	{ 0x0000019B, 0x0000019D, CPU_THERM,	CPU_CENT_C7_PLUS	},
+	/* MISC_Enable, enable TM1/TM2/TM3 */
+	{ 0x000001A0, 0x000001A0, CPU_MISC,	CPU_CENT_C7_PLUS,	},
+	/* IA32_LATFORM_BRV */
+	{ 0x000001A1, 0x000001A1, CPU_PLATFORM,	CPU_CENT_NANO,		},
+	/* IA32_DEBUGCTLA */
+	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	CPU_CENT_NANO,		},
+	{ 0x00000200, 0x0000020F, CPU_MTRR,	CPU_CENT_C7_PLUS,	},
+	{ 0x00000250, 0x00000250, CPU_MTRR,	CPU_CENT_C7_PLUS,	},
+	{ 0x00000258, 0x00000259, CPU_MTRR,	CPU_CENT_C7_PLUS,	},
+	{ 0x00000268, 0x0000026F, CPU_MTRR,	CPU_CENT_C7_PLUS,	},
+	/* IA32_CR_PAT */
+	{ 0x00000277, 0x00000277, CPU_PAT,	CPU_CENT_NANO,		},
+	{ 0x000002FF, 0x000002FF, CPU_MTRR,	CPU_CENT_C7_PLUS,	},
+	{ 0x00000309, 0x0000030B, CPU_PMC,	CPU_CENT_NANO,		},
+	/* IA32_PERF_CAPABILITIES */
+	{ 0x00000345, 0x00000345, CPU_PMC,	CPU_CENT_NANO,		},
+	/* IA32_PERF_{FIXED_CTR_CTRL,GLOBAL_{STATUS,CTRL,OVF_CTRL}} */
+	{ 0x0000038D, 0x00000390, CPU_PMC,	CPU_CENT_NANO,		},
+	/* IA32_PEBS_ENABLE */
+	{ 0x000003F1, 0x000003F1, CPU_PMC,	CPU_CENT_NANO,		},
+	{ 0x00000400, 0x00000412, CPU_MC,	CPU_CENT_NANO,		},
+	{ 0x00000480, 0x0000048B, CPU_VMX,	CPU_CENT_NANO,		},
+	/* FCR5: ucode update status */
+	{ 0x00001025, 0x00001025, CPU_BIOS,	CPU_CENT_NANO,		},
+	{ 0x00001107, 0x00001109, CPU_FEATURES,	CPU_CENT_C7,		},
+	/* Performance Status Register */
+	{ 0x0000110A, 0x0000110A, CPU_FEATURES,	CPU_CENT_C7D,		},
+	{ 0x0000110B, 0x0000110B, CPU_MISC,	CPU_CENT_C7,		},
+	/* HCR2/DSCR2: Overstress VID, Parallax Temp, Inflection ratio */
+	{ 0x00001140, 0x00001142, CPU_FREQ,	CPU_CENT_C7D,		},
+	/* user defined temperature threshuld */
+	{ 0x00001167, 0x00001167, CPU_THERM,	CPU_CENT_C7,		},
+	/* die temperature in degrees C */
+	{ 0x00001169, 0x00001169, CPU_THERM,	CPU_CENT_C7,		},
+	/* CENT_HARDWARECTRL3 */
+	{ 0x00001203, 0x00001203, CPU_FEATURES,	CPU_CENT_NANO,		},
+	/* change reported steppling/model/family */
+	{ 0x00001204, 0x00001204, CPU_MISC,	CPU_CENT_C7_PLUS,	},
+	/* characters of alternate vendor string */
+	{ 0x00001206, 0x00001207, CPU_MISC,	CPU_CENT_C7_PLUS,	},
+	/* CENT_INFLECTION_RATIO */
+	{ 0x00001406, 0x00001406, CPU_THERM,	CPU_CENT_NANO,		},
+	/* thermal monitor temperature in celsius */
+	{ 0x00001423, 0x00001423, CPU_THERM,	CPU_CENT_NANO,		},
+	/* CENT_TMREFCNT{0,1} */
+	{ 0x00001424, 0x00001425, CPU_TIME,	CPU_CENT_NANO,		},
+	/* IA32_EFER */
+	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	CPU_CENT_NANO,		},
+	/* IA32_{STAR,LSTAR,CSTAR,FMASK} */
+	{ 0xC0000081, 0xC0000084, CPU_CALL,	CPU_CENT_NANO,		},
+	/* IA32_{FS_BASE,GS_BASE,KERNEL_GS_BASE} */
+	{ 0xC0000100, 0xC0000102, CPU_BASE,	CPU_CENT_NANO,		},
+};
 
 /* Intel */
 static int get_intel_modelflag(unsigned model)
@@ -310,6 +398,77 @@ static int get_amd_modelflag(unsigned model)
 	return flag;
 }
 
+/* VIA / Centaur */
+static int get_centaur_modelflag(unsigned model)
+{
+	int flag;
+
+	switch ((model >> 8) & 0xff) {
+	case 5:
+		switch (model & 0xff) {
+		case 4:
+			/* IDT WinChip C6 */
+		case 8:
+			/* IDT WinChip 2 */
+		case 9:
+			/* IDT WinChip 3 */
+		default:
+			flag = CPU_NONE;
+			break;
+		}
+		break;
+	case 6:
+		switch (model & 0xff) {
+		case 0x00:
+			/* Cyrix 6x86 MX */
+			flag = CPU_NONE;
+			break;
+		case 0x05:
+			/* VIA Cyrix III */
+			flag = CPU_NONE;
+			break;
+		case 0x06:
+			/* VIA Cyrix III Samuel */
+			flag = CPU_NONE;
+			break;
+		case 0x07:
+			/* 0..7 VIA C3 Samuel II / C3 */
+			/* 8..F VIA C3 Ezra / Eden ESP */
+			flag = CPU_CENT_C3;
+			break;
+		case 0x08:
+			/* 0..7 VIA C3 Ezra-T / Eden ESP */
+			flag = CPU_CENT_C5;
+			break;
+		case 0x09:
+			/* VIA Antaur */
+			flag = CPU_NONE;
+			break;
+		case 0x0a:
+			/* C7-M Type A, Esther core 90nm SOI */
+			flag = CPU_CENT_C7A;
+			break;
+		case 0x0d:
+			/* C7-M Type D, Esther core 90nm */
+			flag = CPU_CENT_C7D;
+			break;
+		case 0x0f:
+			/* Nano 65nm */
+			flag = CPU_CENT_NANO;
+			break;
+		default:
+			flag = CPU_NONE;
+			break;
+		}
+		break;
+	default:
+		flag = CPU_NONE;
+		break;
+	}
+
+	return flag;
+}
+
 static int get_cpu_modelflag(unsigned cpu)
 {
 	int flag;
@@ -323,6 +482,9 @@ static int get_cpu_modelflag(unsigned cpu)
 	case X86_VENDOR_AMD:
 		flag = get_amd_modelflag(flag & 0xffff);
 		break;
+	case X86_VENDOR_CENTAUR:
+		flag = get_centaur_modelflag(flag);
+		break;
 	default:
 		flag = CPU_NONE;
 		break;
@@ -342,6 +504,9 @@ static int get_cpu_range_count(unsigned cpu)
 	case X86_VENDOR_AMD:
 		index = ARRAY_SIZE(cpu_amd_range);
 		break;
+	case X86_VENDOR_CENTAUR:
+		index = ARRAY_SIZE(cpu_centaur_range);
+		break;
 	default:
 		index = 0;
 		break;
@@ -375,6 +540,11 @@ static int is_typeflag_valid(unsigned cpu, unsigned flag)
 			    (cpu_amd_range[i].flag & flag))
 				return 1;
 			break;
+		case X86_VENDOR_CENTAUR:
+			if ((cpu_centaur_range[i].model & modelflag) &&
+			    (cpu_centaur_range[i].flag & flag))
+				return 1;
+			break;
 		}
 	}
 
@@ -404,6 +574,12 @@ static unsigned get_cpu_range(unsigned cpu, unsigned *min, unsigned *max,
 			*max = cpu_amd_range[index].max;
 		}
 		break;
+	case X86_VENDOR_CENTAUR:
+		if ((cpu_centaur_range[index].model & modelflag) &&
+		    (cpu_centaur_range[index].flag & flag)) {
+			*min = cpu_centaur_range[index].min;
+			*max = cpu_centaur_range[index].max;
+		}
 	}
 
 	return *max;
-- 
1.6.3.1
