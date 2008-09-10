Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYIJKu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYIJKu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 06:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYIJKuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 06:50:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:65430 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbYIJKuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 06:50:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,371,1217833200"; 
   d="scan'208";a="614748268"
From: Sheng Yang <sheng.yang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, Andi Kleen <ak@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 2/2] x86: Extended "flags" to show virtualization HW feature in /proc/cpuinfo
Date: Wed, 10 Sep 2008 18:53:34 +0800
Message-Id: <1221044014-32632-1-git-send-email-sheng.yang@intel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080910080421.GC15255@elte.hu>
References: <20080910080421.GC15255@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hardware virtualization technology evolves very fast. But currently
it's hard to tell if your CPU support a certain kind of HW technology
without digging into the source code.

The patch add a new catagory in "flags" under /proc/cpuinfo. Now "flags"
can indicate the (important) HW virtulization features the CPU supported
as well.

Current implementation just cover Intel VMX side.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
---
 arch/x86/kernel/cpu/intel.c  |   41 +++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/cpufeature.h |    9 ++++++++-
 2 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5f76bf1..99468db 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -196,6 +196,44 @@ static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 		return 1;
 }
 
+static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
+{
+	/* Intel VMX MSR indicated features */
+#define X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW	0x00200000
+#define X86_VMX_FEATURE_PROC_CTLS_VNMI		0x00400000
+#define X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS	0x80000000
+#define X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC	0x00000001
+#define X86_VMX_FEATURE_PROC_CTLS2_EPT		0x00000002
+#define X86_VMX_FEATURE_PROC_CTLS2_VPID		0x00000020
+
+	u32 vmx_msr_low, vmx_msr_high, msr_ctl, msr_ctl2;
+
+	clear_cpu_cap(c, X86_FEATURE_TPR_SHADOW);
+	clear_cpu_cap(c, X86_FEATURE_VNMI);
+	clear_cpu_cap(c, X86_FEATURE_FLEXPRIORITY);
+	clear_cpu_cap(c, X86_FEATURE_EPT);
+	clear_cpu_cap(c, X86_FEATURE_VPID);
+
+	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, vmx_msr_low, vmx_msr_high);
+	msr_ctl = vmx_msr_high | vmx_msr_low;
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW)
+		set_cpu_cap(c, X86_FEATURE_TPR_SHADOW);
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_VNMI)
+		set_cpu_cap(c, X86_FEATURE_VNMI);
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS) {
+		rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
+		      vmx_msr_low, vmx_msr_high);
+		msr_ctl2 = vmx_msr_high | vmx_msr_low;
+		if ((msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC) &&
+		    (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW))
+			set_cpu_cap(c, X86_FEATURE_FLEXPRIORITY);
+		if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_EPT)
+			set_cpu_cap(c, X86_FEATURE_EPT);
+		if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VPID)
+			set_cpu_cap(c, X86_FEATURE_VPID);
+	}
+}
+
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
@@ -289,6 +327,9 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 	/* Work around errata */
 	srat_detect_node();
+
+	if (cpu_has(c, X86_FEATURE_VMX))
+		detect_vmx_virtcap(c);
 }
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 7ac4d93..8d45690 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -6,7 +6,7 @@
 
 #include <asm/required-features.h>
 
-#define NCAPINTS	8	/* N 32-bit words worth of info */
+#define NCAPINTS	9	/* N 32-bit words worth of info */
 
 /*
  * Note: If the comment begins with a quoted string, that string is used
@@ -150,6 +150,13 @@
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 
+/* Virtualization flags: Linux defined */
+#define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
+#define X86_FEATURE_VNMI        (8*32+ 1) /* Intel Virtual NMI */
+#define X86_FEATURE_FLEXPRIORITY (8*32+ 2) /* Intel FlexPriority */
+#define X86_FEATURE_EPT         (8*32+ 3) /* Intel Extended Page Table */
+#define X86_FEATURE_VPID        (8*32+ 4) /* Intel Virtual Processor ID */
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <linux/bitops.h>
-- 
1.5.4.5

