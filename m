Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbXDJRYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbXDJRYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXDJRYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:24:13 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:8461 "EHLO
	outbound2-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbXDJRYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:24:11 -0400
X-BigFish: VP
X-FB-SS: 0
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Tue, 10 Apr 2007 19:24:25 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>
Subject: [PATCH] x86_64: prevent auto select of mwait_idle for AMD CPUs
Message-ID: <20070410172425.GE24680@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Apr 2007 17:23:56.0888 (UTC)
 FILETIME=[0513DD80:01C77B95]
X-WSS-ID: 6A0517A53283678826-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fix is needed for AMD family 10h CPUs.

It prevents auto select of mwait_idle for AMD CPUs.
MWAIT does not enter C-states on family 10h and more
power saving is reached by entering C1 with
default_idle.

The patch also adds an idle=mwait command line option
to select mwait_idle for benchmarking.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86_64/kernel/process.c    |    9 +++++++--
 arch/x86_64/kernel/setup.c      |    4 ++++
 include/asm-x86_64/cpufeature.h |    1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86_64/kernel/process.c b/arch/x86_64/kernel/process.c
index d8d5ccc..18fe9de 100644
--- a/arch/x86_64/kernel/process.c
+++ b/arch/x86_64/kernel/process.c
@@ -271,7 +271,8 @@ static void mwait_idle(void)
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 	static int printed;
-	if (cpu_has(c, X86_FEATURE_MWAIT)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT) &&
+	    !cpu_has(c, X86_FEATURE_MWAIT_NO_CSTATE)) {
 		/*
 		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait
@@ -291,7 +292,11 @@ static int __init idle_setup (char *str)
 	if (!strncmp(str, "poll", 4)) {
 		printk("using polling idle threads.\n");
 		pm_idle = poll_idle;
-	}
+	} else if (!strncmp(str, "mwait", 5))
+		if (boot_cpu_has(X86_FEATURE_MWAIT)) {
+			printk(KERN_INFO "using mwait in idle threads.\n");
+			pm_idle = mwait_idle;
+		}
 
 	boot_option_idle_override = 1;
 	return 1;
diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index 3d98b69..b707025 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -612,6 +612,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 
 	/* RDTSC can be speculated around */
 	clear_bit(X86_FEATURE_SYNC_RDTSC, &c->x86_capability);
+
+	/* prevent auto select of mwait_idle */
+	if (cpu_has(c, X86_FEATURE_MWAIT))
+		set_bit(X86_FEATURE_MWAIT_NO_CSTATE, c->x86_capability);
 }
 
 static void __cpuinit detect_ht(struct cpuinfo_x86 *c)
diff --git a/include/asm-x86_64/cpufeature.h b/include/asm-x86_64/cpufeature.h
index 0b3c686..9331d1a 100644
--- a/include/asm-x86_64/cpufeature.h
+++ b/include/asm-x86_64/cpufeature.h
@@ -70,6 +70,7 @@
 #define X86_FEATURE_ARCH_PERFMON (3*32+9) /* Intel Architectural PerfMon */
 #define X86_FEATURE_PEBS	(3*32+10) /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+11) /* Branch Trace Store */
+#define X86_FEATURE_MWAIT_NO_CSTATE (3*32+12) /* mwait does not enter c-state */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
-- 
1.5.0.6




