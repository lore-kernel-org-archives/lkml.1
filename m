Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYIHKjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYIHKjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 06:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYIHKjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 06:39:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:45188 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYIHKjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 06:39:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,357,1217833200"; 
   d="scan'208";a="43255222"
From: Sheng Yang <sheng.yang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@qumranet.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 2/2] x86: Add "virt flags" in /proc/cpuinfo
Date: Mon,  8 Sep 2008 18:42:35 +0800
Message-Id: <12208705552047-git-send-email-sheng.yang@intel.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12208705553277-git-send-email-sheng.yang@intel.com>
References: <12208705553277-git-send-email-sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hardware virtualization technology evolves very fast. But currently
it's hard to tell if your CPU support a certain kind of HW technology
without digging into the source code.

The patch add a new item under /proc/cpuinfo, named "virt flags". The "virt
flags" got the similar purpose as "flags". It is used to indicate what
HW virtulization features does this CPU supported, and it don't cover all
features but only the important ones.

Current implementation just cover Intel VMX side.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
---
 arch/x86/kernel/cpu/proc.c   |   28 ++++++++++++++++++++++++++++
 include/asm-x86/cpufeature.h |    8 ++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index a26c480..737a1bd 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -77,6 +77,31 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 }
 #endif
 
+static void show_cpuinfo_vmx_virtflags(struct seq_file *m)
+{
+	u32 vmx_msr_low, vmx_msr_high, msr_ctl, msr_ctl2;
+
+	seq_printf(m, "\nvirt flags\t:");
+	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, vmx_msr_low, vmx_msr_high);
+	msr_ctl = vmx_msr_high | vmx_msr_low;
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW)
+		seq_printf(m, " tpr_shadow");
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_VNMI)
+		seq_printf(m, " vnmi");
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS) {
+		rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
+		      vmx_msr_low, vmx_msr_high);
+		msr_ctl2 = vmx_msr_high | vmx_msr_low;
+		if ((msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC) &&
+		    (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW))
+			seq_printf(m, " flexpriority");
+		if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_EPT)
+			seq_printf(m, " ept");
+		if (msr_ctl2 & X86_VMX_FEATURE_PROC_CTLS2_VPID)
+			seq_printf(m, " vpid");
+	}
+}
+
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	struct cpuinfo_x86 *c = v;
@@ -123,6 +148,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		if (cpu_has(c, i) && x86_cap_flags[i] != NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
 
+	if (cpu_has(c, X86_FEATURE_VMX))
+		show_cpuinfo_vmx_virtflags(m);
+
 	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
 		   c->loops_per_jiffy/(500000/HZ),
 		   (c->loops_per_jiffy/(5000/HZ)) % 100);
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 7ac4d93..b5e4aef 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -150,6 +150,14 @@
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 
+/* Intel VMX MSR indicated features */
+#define X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW	0x00200000
+#define X86_VMX_FEATURE_PROC_CTLS_VNMI		0x00400000
+#define X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS	0x80000000
+#define X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC	0x00000001
+#define X86_VMX_FEATURE_PROC_CTLS2_EPT		0x00000002
+#define X86_VMX_FEATURE_PROC_CTLS2_VPID		0x00000020
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 
 #include <linux/bitops.h>
-- 
1.5.4.5

