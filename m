Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbYIIGwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbYIIGwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYIIGvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:51:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:9615 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbYIIGvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:51:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,363,1217833200"; 
   d="scan'208";a="334308101"
From: Sheng Yang <sheng.yang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       Andi Kleen <ak@linux.intel.com>, "\"H. Peter Anvin\"" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 2/2] x86: Extended cpuinfo to show virtualization HW features
Date: Tue,  9 Sep 2008 14:54:54 +0800
Message-Id: <1220943294312-git-send-email-sheng.yang@intel.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12209432941440-git-send-email-sheng.yang@intel.com>
References: <12209432941440-git-send-email-sheng.yang@intel.com>
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
 arch/x86/kernel/cpu/common.c |   45 ++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/cpufeature.h |    9 +++++++-
 2 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f7c1964..01432e2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -581,6 +581,50 @@ static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
 	}
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
+static void __cpuinit detect_virtcap(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_VMX))
+		detect_vmx_virtcap(c);
+}
+
 static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 {
 	if (!have_cpuid_p())
@@ -613,6 +657,7 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 
 	init_scattered_cpuid_features(c);
 	detect_nopl(c);
+	detect_virtcap(c);
 }
 
 /*
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

