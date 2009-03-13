Return-Path: <linux-kernel-owner+w=401wt.eu-S1758448AbZCMO4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbZCMO4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 10:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbZCMO4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 10:56:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:50383 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbZCMO4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 10:56:20 -0400
Subject: [git-pull -tip] x86: cpu_debug add support for various AMD CPUs
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 20:25:41 +0530
Message-Id: <1236956141.16936.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 81c183a05e4b9f5468a6db5b20ad430cb8805bbe:
  Ingo Molnar (1):
        manual merge of cpus4096

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-cpu.git master

Jaswinder Singh Rajput (1):
      x86: cpu_debug add support for various AMD CPUs

 arch/x86/include/asm/cpu_debug.h |   33 ++++++++-
 arch/x86/kernel/cpu/cpu_debug.c  |  150 +++++++++++++++++++++++++++-----------
 2 files changed, 136 insertions(+), 47 deletions(-)

Complete diff:
diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index 56f1635..d79af88 100755
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -33,6 +33,8 @@ enum cpu_debug_bit {
 	CPU_VMX_BIT,				/* VMX			*/
 	CPU_CALL_BIT,				/* System Call		*/
 	CPU_BASE_BIT,				/* BASE Address		*/
+	CPU_VER_BIT,				/* Version ID		*/
+	CPU_CONF_BIT,				/* Configuration	*/
 	CPU_SMM_BIT,				/* System mgmt mode	*/
 	CPU_SVM_BIT,				/*Secure Virtual Machine*/
 	CPU_OSVM_BIT,				/* OS-Visible Workaround*/
@@ -69,6 +71,8 @@ enum cpu_debug_bit {
 #define	CPU_VMX			(1 << CPU_VMX_BIT)
 #define	CPU_CALL		(1 << CPU_CALL_BIT)
 #define	CPU_BASE		(1 << CPU_BASE_BIT)
+#define	CPU_VER			(1 << CPU_VER_BIT)
+#define	CPU_CONF		(1 << CPU_CONF_BIT)
 #define	CPU_SMM			(1 << CPU_SMM_BIT)
 #define	CPU_SVM			(1 << CPU_SVM_BIT)
 #define	CPU_OSVM		(1 << CPU_OSVM_BIT)
@@ -123,10 +127,15 @@ enum cpu_processor_bit {
 	CPU_INTEL_ATOM_BIT,
 	CPU_INTEL_XEON_P4_BIT,
 	CPU_INTEL_XEON_MP_BIT,
+/* AMD */
+	CPU_AMD_K6_BIT,
+	CPU_AMD_K7_BIT,
+	CPU_AMD_K8_BIT,
+	CPU_AMD_0F_BIT,
+	CPU_AMD_10_BIT,
+	CPU_AMD_11_BIT,
 };
 
-#define	CPU_ALL			(~0)		/* Select all CPUs	*/
-
 #define	CPU_INTEL_PENTIUM	(1 << CPU_INTEL_PENTIUM_BIT)
 #define	CPU_INTEL_P6		(1 << CPU_INTEL_P6_BIT)
 #define	CPU_INTEL_PENTIUM_M	(1 << CPU_INTEL_PENTIUM_M_BIT)
@@ -156,9 +165,27 @@ enum cpu_processor_bit {
 #define	CPU_PX_CX_AT		(CPU_INTEL_PX | CPU_CX_AT)
 #define	CPU_PX_CX_AT_XE		(CPU_INTEL_PX | CPU_CX_AT_XE)
 
-/* Select all Intel CPUs*/
+/* Select all supported Intel CPUs */
 #define	CPU_INTEL_ALL		(CPU_INTEL_PENTIUM | CPU_PX_CX_AT_XE)
 
+#define	CPU_AMD_K6		(1 << CPU_AMD_K6_BIT)
+#define	CPU_AMD_K7		(1 << CPU_AMD_K7_BIT)
+#define	CPU_AMD_K8		(1 << CPU_AMD_K8_BIT)
+#define	CPU_AMD_0F		(1 << CPU_AMD_0F_BIT)
+#define	CPU_AMD_10		(1 << CPU_AMD_10_BIT)
+#define	CPU_AMD_11		(1 << CPU_AMD_11_BIT)
+
+#define	CPU_K10_PLUS		(CPU_AMD_10 | CPU_AMD_11)
+#define	CPU_K0F_PLUS		(CPU_AMD_0F | CPU_K10_PLUS)
+#define	CPU_K8_PLUS		(CPU_AMD_K8 | CPU_K10_PLUS)
+#define	CPU_K7_PLUS		(CPU_AMD_K7 | CPU_K8_PLUS)
+
+/* Select all supported AMD CPUs */
+#define	CPU_AMD_ALL		(CPU_AMD_K6 | CPU_K7_PLUS)
+
+/* Select all supported CPUs */
+#define	CPU_ALL			(CPU_INTEL_ALL | CPU_AMD_ALL)
+
 #define MAX_CPU_FILES		512
 
 struct cpu_private {
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 21c0cf8..46e29ab 100755
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -64,6 +64,8 @@ static struct cpu_debug_base cpu_base[] = {
 	{ "vmx",	CPU_VMX,	0	},
 	{ "call",	CPU_CALL,	0	},
 	{ "base",	CPU_BASE,	0	},
+	{ "ver",	CPU_VER,	0	},
+	{ "conf",	CPU_CONF,	0	},
 	{ "smm",	CPU_SMM,	0	},
 	{ "svm",	CPU_SVM,	0	},
 	{ "osvm",	CPU_OSVM,	0	},
@@ -177,54 +179,59 @@ static struct cpu_debug_range cpu_intel_range[] = {
 
 /* AMD Registers Range */
 static struct cpu_debug_range cpu_amd_range[] = {
-	{ 0x00000010, 0x00000010, CPU_TIME,	CPU_ALL,		},
-	{ 0x0000001B, 0x0000001B, CPU_APIC,	CPU_ALL,		},
-	{ 0x000000FE, 0x000000FE, CPU_MTRR,	CPU_ALL,		},
-
-	{ 0x00000174, 0x00000176, CPU_SYSENTER,	CPU_ALL,		},
-	{ 0x00000179, 0x0000017A, CPU_MC,	CPU_ALL,		},
-	{ 0x0000017B, 0x0000017B, CPU_MC,	CPU_ALL,		},
-	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	CPU_ALL,		},
-	{ 0x000001DB, 0x000001DE, CPU_LBRANCH,	CPU_ALL,		},
-
-	{ 0x00000200, 0x0000020F, CPU_MTRR,	CPU_ALL,		},
-	{ 0x00000250, 0x00000250, CPU_MTRR,	CPU_ALL,		},
-	{ 0x00000258, 0x00000259, CPU_MTRR,	CPU_ALL,		},
-	{ 0x00000268, 0x0000026F, CPU_MTRR,	CPU_ALL,		},
-	{ 0x00000277, 0x00000277, CPU_PAT,	CPU_ALL,		},
-	{ 0x000002FF, 0x000002FF, CPU_MTRR,	CPU_ALL,		},
-
-	{ 0x00000400, 0x00000417, CPU_MC,	CPU_ALL,		},
-
-	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	CPU_ALL,		},
-	{ 0xC0000081, 0xC0000084, CPU_CALL,	CPU_ALL,		},
-	{ 0xC0000100, 0xC0000102, CPU_BASE,	CPU_ALL,		},
-	{ 0xC0000103, 0xC0000103, CPU_TIME,	CPU_ALL,		},
-
-	{ 0xC0000408, 0xC000040A, CPU_MC,	CPU_ALL,		},
-
-	{ 0xc0010000, 0xc0010007, CPU_PMC,	CPU_ALL,		},
-	{ 0xc0010010, 0xc0010010, CPU_MTRR,	CPU_ALL,		},
-	{ 0xc0010016, 0xc001001A, CPU_MTRR,	CPU_ALL,		},
-	{ 0xc001001D, 0xc001001D, CPU_MTRR,	CPU_ALL,		},
-	{ 0xc0010030, 0xc0010035, CPU_BIOS,	CPU_ALL,		},
-	{ 0xc0010056, 0xc0010056, CPU_SMM,	CPU_ALL,		},
-	{ 0xc0010061, 0xc0010063, CPU_SMM,	CPU_ALL,		},
-	{ 0xc0010074, 0xc0010074, CPU_MC,	CPU_ALL,		},
-	{ 0xc0010111, 0xc0010113, CPU_SMM,	CPU_ALL,		},
-	{ 0xc0010114, 0xc0010118, CPU_SVM,	CPU_ALL,		},
-	{ 0xc0010119, 0xc001011A, CPU_SMM,	CPU_ALL,		},
-	{ 0xc0010140, 0xc0010141, CPU_OSVM,	CPU_ALL,		},
-	{ 0xc0010156, 0xc0010156, CPU_SMM,	CPU_ALL,		},
+	{ 0x00000000, 0x00000001, CPU_MC,	CPU_K10_PLUS,		},
+	{ 0x00000010, 0x00000010, CPU_TIME,	CPU_K8_PLUS,		},
+	{ 0x0000001B, 0x0000001B, CPU_APIC,	CPU_K8_PLUS,		},
+	{ 0x0000002A, 0x0000002A, CPU_POWERON,	CPU_K7_PLUS		},
+	{ 0x0000008B, 0x0000008B, CPU_VER,	CPU_K8_PLUS		},
+	{ 0x000000FE, 0x000000FE, CPU_MTRR,	CPU_K8_PLUS,		},
+
+	{ 0x00000174, 0x00000176, CPU_SYSENTER,	CPU_K8_PLUS,		},
+	{ 0x00000179, 0x0000017B, CPU_MC,	CPU_K8_PLUS,		},
+	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	CPU_K8_PLUS,		},
+	{ 0x000001DB, 0x000001DE, CPU_LBRANCH,	CPU_K8_PLUS,		},
+
+	{ 0x00000200, 0x0000020F, CPU_MTRR,	CPU_K8_PLUS,		},
+	{ 0x00000250, 0x00000250, CPU_MTRR,	CPU_K8_PLUS,		},
+	{ 0x00000258, 0x00000259, CPU_MTRR,	CPU_K8_PLUS,		},
+	{ 0x00000268, 0x0000026F, CPU_MTRR,	CPU_K8_PLUS,		},
+	{ 0x00000277, 0x00000277, CPU_PAT,	CPU_K8_PLUS,		},
+	{ 0x000002FF, 0x000002FF, CPU_MTRR,	CPU_K8_PLUS,		},
+
+	{ 0x00000400, 0x00000413, CPU_MC,	CPU_K8_PLUS,		},
+
+	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	CPU_AMD_ALL,		},
+	{ 0xC0000081, 0xC0000084, CPU_CALL,	CPU_K8_PLUS,		},
+	{ 0xC0000100, 0xC0000102, CPU_BASE,	CPU_K8_PLUS,		},
+	{ 0xC0000103, 0xC0000103, CPU_TIME,	CPU_K10_PLUS,		},
+
+	{ 0xC0010000, 0xC0010007, CPU_PMC,	CPU_K8_PLUS,		},
+	{ 0xC0010010, 0xC0010010, CPU_CONF,	CPU_K7_PLUS,		},
+	{ 0xC0010015, 0xC0010015, CPU_CONF,	CPU_K7_PLUS,		},
+	{ 0xC0010016, 0xC001001A, CPU_MTRR,	CPU_K8_PLUS,		},
+	{ 0xC001001D, 0xC001001D, CPU_MTRR,	CPU_K8_PLUS,		},
+	{ 0xC001001F, 0xC001001F, CPU_CONF,	CPU_K8_PLUS,		},
+	{ 0xC0010030, 0xC0010035, CPU_BIOS,	CPU_K8_PLUS,		},
+	{ 0xC0010044, 0xC0010048, CPU_MC,	CPU_K8_PLUS,		},
+	{ 0xC0010050, 0xC0010056, CPU_SMM,	CPU_K0F_PLUS,		},
+	{ 0xC0010058, 0xC0010058, CPU_CONF,	CPU_K10_PLUS,		},
+	{ 0xC0010060, 0xC0010060, CPU_CACHE,	CPU_AMD_11,		},
+	{ 0xC0010061, 0xC0010068, CPU_SMM,	CPU_K10_PLUS,		},
+	{ 0xC0010069, 0xC001006B, CPU_SMM,	CPU_AMD_11,		},
+	{ 0xC0010070, 0xC0010071, CPU_SMM,	CPU_K10_PLUS,		},
+	{ 0xC0010111, 0xC0010113, CPU_SMM,	CPU_K8_PLUS,		},
+	{ 0xC0010114, 0xC0010118, CPU_SVM,	CPU_K10_PLUS,		},
+	{ 0xC0010140, 0xC0010141, CPU_OSVM,	CPU_K10_PLUS,		},
+	{ 0xC0011022, 0xC0011023, CPU_CONF,	CPU_K10_PLUS,		},
 };
 
 
-static int get_cpu_modelflag(unsigned cpu)
+/* Intel */
+static int get_intel_modelflag(unsigned model)
 {
 	int flag;
 
-	switch (per_cpu(cpu_model, cpu)) {
-	/* Intel */
+	switch (model) {
 	case 0x0501:
 	case 0x0502:
 	case 0x0504:
@@ -271,6 +278,59 @@ static int get_cpu_modelflag(unsigned cpu)
 	return flag;
 }
 
+/* AMD */
+static int get_amd_modelflag(unsigned model)
+{
+	int flag;
+
+	switch (model >> 8) {
+	case 0x6:
+		flag = CPU_AMD_K6;
+		break;
+	case 0x7:
+		flag = CPU_AMD_K7;
+		break;
+	case 0x8:
+		flag = CPU_AMD_K8;
+		break;
+	case 0xf:
+		flag = CPU_AMD_0F;
+		break;
+	case 0x10:
+		flag = CPU_AMD_10;
+		break;
+	case 0x11:
+		flag = CPU_AMD_11;
+		break;
+	default:
+		flag = CPU_NONE;
+		break;
+	}
+
+	return flag;
+}
+
+static int get_cpu_modelflag(unsigned cpu)
+{
+	int flag;
+
+	flag = per_cpu(cpu_model, cpu);
+
+	switch (flag >> 16) {
+	case X86_VENDOR_INTEL:
+		flag = get_intel_modelflag(flag);
+		break;
+	case X86_VENDOR_AMD:
+		flag = get_amd_modelflag(flag & 0xffff);
+		break;
+	default:
+		flag = CPU_NONE;
+		break;
+	}
+
+	return flag;
+}
+
 static int get_cpu_range_count(unsigned cpu)
 {
 	int index;
@@ -311,7 +371,8 @@ static int is_typeflag_valid(unsigned cpu, unsigned flag)
 				return 1;
 			break;
 		case X86_VENDOR_AMD:
-			if (cpu_amd_range[i].flag & flag)
+			if ((cpu_amd_range[i].model & modelflag) &&
+			    (cpu_amd_range[i].flag & flag))
 				return 1;
 			break;
 		}
@@ -337,7 +398,8 @@ static unsigned get_cpu_range(unsigned cpu, unsigned *min, unsigned *max,
 		}
 		break;
 	case X86_VENDOR_AMD:
-		if (cpu_amd_range[index].flag & flag) {
+		if ((cpu_amd_range[index].model & modelflag) &&
+		    (cpu_amd_range[index].flag & flag)) {
 			*min = cpu_amd_range[index].min;
 			*max = cpu_amd_range[index].max;
 		}


