Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZB1B7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZB1B7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbZB1B73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:59:29 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:59151
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755353AbZB1B72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:59:28 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] xen-dom0: only selectively disable cpu features
Date: Fri, 27 Feb 2009 17:59:10 -0800
Message-Id: <1235786365-17744-5-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235786365-17744-1-git-send-email-jeremy@goop.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dom0 kernels actually want most of the CPU features to be enabled.
Some, like MCA/MCE, are still handled by Xen itself.

We leave APIC enabled even though we don't really have a functional
local apic so that the ACPI code will parse the corresponding tables
properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index d5fc434..468aa23 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -171,18 +171,23 @@ static void __init xen_banner(void)
 static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 		      unsigned int *cx, unsigned int *dx)
 {
-	unsigned maskedx = ~0;
+	unsigned maskedx = 0;
 
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
+		maskedx =
+			(1 << X86_FEATURE_MCE)  |  /* disable MCE */
+			(1 << X86_FEATURE_MCA)  |  /* disable MCA */
+			(1 << X86_FEATURE_ACC);   /* thermal monitoring */
+
+		if (!xen_initial_domain())
+			maskedx |=
+				(1 << X86_FEATURE_APIC) |  /* disable local APIC */
+				(1 << X86_FEATURE_ACPI);  /* disable ACPI */
+	}
 
 	asm(XEN_EMULATE_PREFIX "cpuid"
 		: "=a" (*ax),
@@ -190,7 +195,7 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 		  "=c" (*cx),
 		  "=d" (*dx)
 		: "0" (*ax), "2" (*cx));
-	*dx &= maskedx;
+	*dx &= ~maskedx;
 }
 
 static void xen_set_debugreg(int reg, unsigned long val)
-- 
1.6.0.6

