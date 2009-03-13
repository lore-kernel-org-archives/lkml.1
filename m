Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbZCMIQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbZCMIQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZCMIMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:12:24 -0400
Received: from gw.goop.org ([64.81.55.164]:34807 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754311AbZCMIMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:12:22 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/24] xen: mask XSAVE from cpuid
Date: Fri, 13 Mar 2009 01:11:46 -0700
Message-Id: <1236931920-6861-11-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236931920-6861-1-git-send-email-jeremy@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Xen leaves XSAVE set in cpuid, but doesn't allow cr4.OSXSAVE
to be set.  This confuses the kernel and it ends up crashing on
an xsetbv instruction.

At boot time, try to set cr4.OSXSAVE, and mask XSAVE out of
cpuid it we can't.  This will produce a spurious error from Xen,
but allows us to support XSAVE if/when Xen does.

This also factors out the cpuid mask decisions to boot time.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   50 ++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 75b7a0f..da33e0c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -168,21 +168,23 @@ static void __init xen_banner(void)
 	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
 }
 
+static __read_mostly unsigned int cpuid_leaf1_edx_mask = ~0;
+static __read_mostly unsigned int cpuid_leaf1_ecx_mask = ~0;
+
 static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 		      unsigned int *cx, unsigned int *dx)
 {
+	unsigned maskecx = ~0;
 	unsigned maskedx = ~0;
 
 	/*
 	 * Mask out inconvenient features, to try and disable as many
 	 * unsupported kernel subsystems as possible.
 	 */
-	if (*ax == 1)
-		maskedx = ~((1 << X86_FEATURE_APIC) |  /* disable APIC */
-			    (1 << X86_FEATURE_ACPI) |  /* disable ACPI */
-			    (1 << X86_FEATURE_MCE)  |  /* disable MCE */
-			    (1 << X86_FEATURE_MCA)  |  /* disable MCA */
-			    (1 << X86_FEATURE_ACC));   /* thermal monitoring */
+	if (*ax == 1) {
+		maskecx = cpuid_leaf1_ecx_mask;
+		maskedx = cpuid_leaf1_edx_mask;
+	}
 
 	asm(XEN_EMULATE_PREFIX "cpuid"
 		: "=a" (*ax),
@@ -190,9 +192,43 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 		  "=c" (*cx),
 		  "=d" (*dx)
 		: "0" (*ax), "2" (*cx));
+
+	*cx &= maskecx;
 	*dx &= maskedx;
 }
 
+static __init void xen_init_cpuid_mask(void)
+{
+	unsigned int ax, bx, cx, dx;
+
+	cpuid_leaf1_edx_mask =
+		~((1 << X86_FEATURE_MCE)  |  /* disable MCE */
+		  (1 << X86_FEATURE_MCA)  |  /* disable MCA */
+		  (1 << X86_FEATURE_ACC));   /* thermal monitoring */
+
+	if (!xen_initial_domain())
+		cpuid_leaf1_edx_mask &=
+			~((1 << X86_FEATURE_APIC) |  /* disable local APIC */
+			  (1 << X86_FEATURE_ACPI));  /* disable ACPI */
+
+	ax = 1;
+	xen_cpuid(&ax, &bx, &cx, &dx);
+
+	/* cpuid claims we support xsave; try enabling it to see what happens */
+	if (cx & (1 << (X86_FEATURE_XSAVE % 32))) {
+		unsigned long cr4;
+
+		set_in_cr4(X86_CR4_OSXSAVE);
+		
+		cr4 = read_cr4();
+
+		if ((cr4 & X86_CR4_OSXSAVE) == 0)
+			cpuid_leaf1_ecx_mask &= ~(1 << (X86_FEATURE_XSAVE % 32));
+
+		clear_in_cr4(X86_CR4_OSXSAVE);
+	}
+}
+
 static void xen_set_debugreg(int reg, unsigned long val)
 {
 	HYPERVISOR_set_debugreg(reg, val);
@@ -901,6 +937,8 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_init_irq_ops();
 
+	xen_init_cpuid_mask();
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	/*
 	 * set up the basic apic ops.
-- 
1.6.0.6

