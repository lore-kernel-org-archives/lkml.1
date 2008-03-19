Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbYCSUQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbYCSUQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbYCSTjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:03 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbYCSTiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:54 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 33/79] [PATCH] do smp tainting checks in a separate function
Date: Wed, 19 Mar 2008 14:25:28 -0300
Message-Id: <12059477234148-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1205947719906-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com> <1205947580526-git-send-email-gcosta@redhat.com> <12059475853453-git-send-email-gcosta@redhat.com> <12059475892790-git-send-email-gcosta@redhat.com> <12059475944070-git-send-email-gcosta@redhat.com> <12059475982810-git-send-email-gcosta@redhat.com> <12059476032561-git-send-email-gcosta@redhat.com> <1205947607406-git-send-email-gcosta@redhat.com> <12059476123203-git-send-email-gcosta@redhat.com> <12059476162900-git-send-email-gcosta@redhat.com> <12059476212769-git-send-email-gcosta@redhat.com> <1205947625472-git-send-email-gcosta@redhat.com> <12059476302473-git-send-email-gcosta@redhat.com> <12059476351524-git-send-email-gcosta@redhat.com> <12059476393279-git-send-email-gcosta@redhat.com> <12059476441057-git-send-email-gcosta@redhat.com> <12059476482875-git-send-email-gcosta@redhat.com> <12059476531095-git-send-email-gcosta@redhat.com> <1205947657993-git-send-email-gcosta@redhat.com> <1205947661385-git-send-email-g!
 costa@redhat.com> <12059476663034-git-send-email-gcosta@redhat.com> <12059476703608-git-send-email-gcosta@redhat.com> <1205947675605-git-send-email-gcosta@redhat.com> <12059476802159-git-send-email-gcosta@redhat.com> <12059476844196-git-send-email-gcosta@redhat.com> <12059476883852-git-send-email-gcosta@redhat.com> <12059476932397-git-send-email-gcosta@redhat.com> <12059476971309-git-send-email-gcosta@redhat.com> <1205947702588-git-send-email-gcosta@redhat.com> <12059477063046-git-send-email-gcosta@redhat.com> <12059477102394-git-send-email-gcosta@redhat.com> <12059477143205-git-send-email-gcosta@redhat.com> <1205947719906-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <gcosta@redhat.com>

It will ease integration for x86_64

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot.c    |   21 +++++++++++++++++++--
 arch/x86/kernel/smpboot_32.c |   20 ++------------------
 2 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 02427d1..ddb94ef 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -45,10 +45,8 @@ unsigned char *trampoline_base = __va(SMP_TRAMPOLINE_BASE);
 /* representing cpus for which sibling maps can be computed */
 static cpumask_t cpu_sibling_setup_map;
 
-#ifdef CONFIG_X86_32
 /* Set if we find a B stepping CPU */
 int __cpuinitdata smp_b_stepping;
-#endif
 
 static void __cpuinit smp_apply_quirks(struct cpuinfo_x86 *c)
 {
@@ -105,6 +103,25 @@ valid_k7:
 #endif
 }
 
+void smp_checks(void)
+{
+	if (smp_b_stepping)
+		printk(KERN_WARNING "WARNING: SMP operation may be unreliable"
+				    "with B stepping processors.\n");
+
+	/*
+	 * Don't taint if we are running SMP kernel on a single non-MP
+	 * approved Athlon
+	 */
+	if (tainted & TAINT_UNSAFE_SMP) {
+		if (cpus_weight(cpu_present_map))
+			printk(KERN_INFO "WARNING: This combination of AMD"
+				"processors is not suitable for SMP.\n");
+		else
+			tainted &= ~TAINT_UNSAFE_SMP;
+	}
+}
+
 /*
  * The bootstrap kernel entry code has set these up. Save them for
  * a given CPU
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 34493f8..361851c 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -59,8 +59,6 @@
 #include <asm/vmi.h>
 #include <asm/mtrr.h>
 
-extern int smp_b_stepping;
-
 static cpumask_t smp_commenced_mask;
 
 /* which logical CPU number maps to which CPU (physical APIC ID) */
@@ -791,6 +789,7 @@ static int __init smp_sanity_check(unsigned max_cpus)
 }
 
 extern void impress_friends(void);
+extern void smp_checks(void);
 /*
  * Cycle through the processors sending APIC IPIs to boot each.
  */
@@ -865,22 +864,7 @@ static void __init smp_boot_cpus(unsigned int max_cpus)
 
 	impress_friends();
 
-	if (smp_b_stepping)
-		printk(KERN_WARNING "WARNING: SMP operation may be unreliable with B stepping processors.\n");
-
-	/*
-	 * Don't taint if we are running SMP kernel on a single non-MP
-	 * approved Athlon
-	 */
-	if (tainted & TAINT_UNSAFE_SMP) {
-		if (cpus_weight(cpu_present_map))
-			printk (KERN_INFO "WARNING: This combination of AMD processors is not suitable for SMP.\n");
-		else
-			tainted &= ~TAINT_UNSAFE_SMP;
-	}
-
-	Dprintk("Boot done.\n");
-
+	smp_checks();
 	/*
 	 * construct cpu_sibling_map, so that we can tell sibling CPUs
 	 * efficiently.
-- 
1.5.0.6

