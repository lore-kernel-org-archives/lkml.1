Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbZBPXxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbZBPXxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbZBPXqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:46:35 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:50853
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755879AbZBPXq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:46:27 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 04/19] xen-dom0: only selectively disable cpu features
Date: Mon, 16 Feb 2009 15:45:57 -0800
Message-Id: <f1402ed2345e1d654faa823afefa53fc4745e368.1234826723.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <f47f399029ba9035a14ae381b6ae504a5c5bd445.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <edde7fdd064390d321bdafcfb993b28b4d2588b1.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <9fbd402b72d6c494f453ff86e071ac1b2658ece9.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f47f399029ba9035a14ae381b6ae504a5c5bd445.1234826723.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
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

