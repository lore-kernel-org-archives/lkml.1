Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbYKMTkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbYKMTkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYKMTeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:20 -0500
Received: from gw.goop.org ([64.81.55.164]:34388 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbYKMTeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:08 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 23 of 38] xen-dom0: only selectively disable cpu features
X-Mercurial-Node: fc221c6be28d0aa386d50ea4a9021ed61e30a299
Message-Id: <fc221c6be28d0aa386d5.1226603421@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
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
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -205,18 +205,23 @@
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
@@ -224,7 +229,7 @@
 		  "=c" (*cx),
 		  "=d" (*dx)
 		: "0" (*ax), "2" (*cx));
-	*dx &= maskedx;
+	*dx &= ~maskedx;
 }
 
 static void xen_set_debugreg(int reg, unsigned long val)


