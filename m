Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbYFXJIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbYFXJIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYFXJIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:08:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:58913 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758496AbYFXJId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:08:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,695,1204531200"; 
   d="scan'208,223";a="581323652"
From: "Yang, Sheng" <sheng.yang@intel.com>
Organization: Intel
To: kvm@vger.kernel.org
Subject: [PATCH 2/2] x86: Add "virt flag" in /proc/cpuinfo
Date: Tue, 24 Jun 2008 17:08:49 +0800
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hmLYIYJPkdsuHxp"
Message-Id: <200806241708.49462.sheng.yang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_hmLYIYJPkdsuHxp
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=46rom 54b1bb9fe5d2fe40fc047b43dd4e1a480d41a977 Mon Sep 17 00:00:00 2001
=46rom: Sheng Yang <sheng.yang@intel.com>
Date: Tue, 24 Jun 2008 17:03:17 +0800
Subject: [PATCH] x86: Add "virt flag" in /proc/cpuinfo

The hardware virtualization technology evolves very fast. But currently
it's hard to tell if your CPU support a certain kind of HW technology witho=
ut
dig into the source code.

The patch add a new item under /proc/cpuinfo, named "virt flag". The "virt
flag" got the similar function as "flag". It is used to indicate what
features does this CPU supported. It don't cover all features but only the
important ones.

Current implement just cover Intel VMX side.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
=2D--
 arch/x86/kernel/cpu/proc.c   |   28 ++++++++++++++++++++++++++++
 include/asm-x86/cpufeature.h |    9 +++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 0d0d905..03b30d0 100644
=2D-- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -77,6 +77,31 @@ static void show_cpuinfo_misc(struct seq_file *m, struct=
=20
cpuinfo_x86 *c)
 }
 #endif

+static void show_cpuinfo_vmx_virtflag(struct seq_file *m)
+{
+	u32 vmx_msr_low, vmx_msr_high, msr_ctl, msr_ctl2;
+
+	seq_printf(m, "\nvirt flag\t:");
+	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, vmx_msr_low, vmx_msr_high);
+	msr_ctl =3D 0xffffffff & vmx_msr_high | vmx_msr_low;
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW)
+		seq_printf(m, " tpr_shadow");
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_VNMI)
+		seq_printf(m, " vnmi");
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS) {
+		rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
+		      vmx_msr_low, vmx_msr_high);
+		msr_ctl2 =3D 0xffffffff & vmx_msr_high | vmx_msr_low;
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
 	struct cpuinfo_x86 *c =3D v;
@@ -123,6 +148,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		if (cpu_has(c, i) && x86_cap_flags[i] !=3D NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);

+	if (cpu_has(c, X86_FEATURE_VMX))
+		show_cpuinfo_vmx_virtflag(m);
+
 	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
 		   c->loops_per_jiffy/(500000/HZ),
 		   (c->loops_per_jiffy/(5000/HZ)) % 100);
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 0d609c8..87d8084 100644
=2D-- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -84,6 +84,7 @@
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
 #define X86_FEATURE_MWAIT	(4*32+ 3) /* Monitor/Mwait support */
 #define X86_FEATURE_DSCPL	(4*32+ 4) /* CPL Qualified Debug Store */
+#define X86_FEATURE_VMX		(4*32+ 5) /* Virtual Machine eXtensions */
 #define X86_FEATURE_EST		(4*32+ 7) /* Enhanced SpeedStep */
 #define X86_FEATURE_TM2		(4*32+ 8) /* Thermal Monitor 2 */
 #define X86_FEATURE_CID		(4*32+10) /* Context ID */
@@ -113,6 +114,14 @@
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
=2D-
1.5.5


--Boundary-00=_hmLYIYJPkdsuHxp
Content-Type: text/x-diff;
  charset="utf-8";
  name="0003-x86-Add-virt-flag-in-proc-cpuinfo.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0003-x86-Add-virt-flag-in-proc-cpuinfo.patch"

=46rom 54b1bb9fe5d2fe40fc047b43dd4e1a480d41a977 Mon Sep 17 00:00:00 2001
=46rom: Sheng Yang <sheng.yang@intel.com>
Date: Tue, 24 Jun 2008 17:03:17 +0800
Subject: [PATCH] x86: Add "virt flag" in /proc/cpuinfo

The hardware virtualization technology evolves very fast. But currently
it's hard to tell if your CPU support a certain kind of HW technology witho=
ut
dig into the source code.

The patch add a new item under /proc/cpuinfo, named "virt flag". The "virt
flag" got the similar function as "flag". It is used to indicate what
features does this CPU supported. It don't cover all features but only the
important ones.

Current implement just cover Intel VMX side.

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
=2D--
 arch/x86/kernel/cpu/proc.c   |   28 ++++++++++++++++++++++++++++
 include/asm-x86/cpufeature.h |    9 +++++++++
 2 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 0d0d905..03b30d0 100644
=2D-- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -77,6 +77,31 @@ static void show_cpuinfo_misc(struct seq_file *m, struct=
 cpuinfo_x86 *c)
 }
 #endif
=20
+static void show_cpuinfo_vmx_virtflag(struct seq_file *m)
+{
+	u32 vmx_msr_low, vmx_msr_high, msr_ctl, msr_ctl2;
+
+	seq_printf(m, "\nvirt flag\t:");
+	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS, vmx_msr_low, vmx_msr_high);
+	msr_ctl =3D 0xffffffff & vmx_msr_high | vmx_msr_low;
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW)
+		seq_printf(m, " tpr_shadow");
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_VNMI)
+		seq_printf(m, " vnmi");
+	if (msr_ctl & X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS) {
+		rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
+		      vmx_msr_low, vmx_msr_high);
+		msr_ctl2 =3D 0xffffffff & vmx_msr_high | vmx_msr_low;
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
 	struct cpuinfo_x86 *c =3D v;
@@ -123,6 +148,9 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		if (cpu_has(c, i) && x86_cap_flags[i] !=3D NULL)
 			seq_printf(m, " %s", x86_cap_flags[i]);
=20
+	if (cpu_has(c, X86_FEATURE_VMX))
+		show_cpuinfo_vmx_virtflag(m);
+
 	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
 		   c->loops_per_jiffy/(500000/HZ),
 		   (c->loops_per_jiffy/(5000/HZ)) % 100);
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 0d609c8..87d8084 100644
=2D-- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -84,6 +84,7 @@
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
 #define X86_FEATURE_MWAIT	(4*32+ 3) /* Monitor/Mwait support */
 #define X86_FEATURE_DSCPL	(4*32+ 4) /* CPL Qualified Debug Store */
+#define X86_FEATURE_VMX		(4*32+ 5) /* Virtual Machine eXtensions */
 #define X86_FEATURE_EST		(4*32+ 7) /* Enhanced SpeedStep */
 #define X86_FEATURE_TM2		(4*32+ 8) /* Thermal Monitor 2 */
 #define X86_FEATURE_CID		(4*32+10) /* Context ID */
@@ -113,6 +114,14 @@
  */
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
=20
+/* Intel VMX MSR indicated features */
+#define X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW	0x00200000
+#define X86_VMX_FEATURE_PROC_CTLS_VNMI		0x00400000
+#define X86_VMX_FEATURE_PROC_CTLS_2ND_CTLS	0x80000000
+#define X86_VMX_FEATURE_PROC_CTLS2_VIRT_APIC	0x00000001
+#define X86_VMX_FEATURE_PROC_CTLS2_EPT		0x00000002
+#define X86_VMX_FEATURE_PROC_CTLS2_VPID		0x00000020
+
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
=20
 #include <linux/bitops.h>
=2D-=20
1.5.5


--Boundary-00=_hmLYIYJPkdsuHxp--
