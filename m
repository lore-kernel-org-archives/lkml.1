Return-Path: <linux-kernel-owner+w=401wt.eu-S1031173AbXDJR2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031173AbXDJR2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031209AbXDJR2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:28:33 -0400
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:16104 "EHLO
	outbound3-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031173AbXDJR2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:28:32 -0400
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Tue, 10 Apr 2007 19:28:45 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org
cc: "Andi Kleen" <ak@suse.de>
Subject: [PATCH] i386: prevent auto select of mwait_idle for AMD CPUs
Message-ID: <20070410172845.GA12476@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Apr 2007 17:28:16.0864 (UTC)
 FILETIME=[A0090E00:01C77B95]
X-WSS-ID: 6A0516B92EW3664823-02-01
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

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/i386/kernel/cpu/amd.c    |    4 ++++
 arch/i386/kernel/process.c    |    3 ++-
 include/asm-i386/cpufeature.h |    1 +
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/i386/kernel/cpu/amd.c b/arch/i386/kernel/cpu/amd.c
index 2d47db4..e056271 100644
--- a/arch/i386/kernel/cpu/amd.c
+++ b/arch/i386/kernel/cpu/amd.c
@@ -275,6 +275,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 
 	if (amd_apic_timer_broken())
 		set_bit(X86_FEATURE_LAPIC_TIMER_BROKEN, c->x86_capability);
+
+	/* prevent auto select of mwait_idle */
+	if (cpu_has(c, X86_FEATURE_MWAIT))
+		set_bit(X86_FEATURE_MWAIT_NO_CSTATE, c->x86_capability);
 }
 
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 * c, unsigned int size)
diff --git a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
index 393a67d..64db049 100644
--- a/arch/i386/kernel/process.c
+++ b/arch/i386/kernel/process.c
@@ -259,7 +259,8 @@ static void mwait_idle(void)
 
 void __devinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_MWAIT)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT) &&
+	    !cpu_has(c, X86_FEATURE_MWAIT_NO_CSTATE)) {
 		printk("monitor/mwait feature present.\n");
 		/*
 		 * Skip, if setup has overridden idle.
diff --git a/include/asm-i386/cpufeature.h b/include/asm-i386/cpufeature.h
index d1b8e4a..f7f633d 100644
--- a/include/asm-i386/cpufeature.h
+++ b/include/asm-i386/cpufeature.h
@@ -76,6 +76,7 @@
 #define X86_FEATURE_PEBS	(3*32+12)  /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
 #define X86_FEATURE_LAPIC_TIMER_BROKEN (3*32+ 14) /* lapic timer broken in C1 */
+#define X86_FEATURE_MWAIT_NO_CSTATE (3*32+15) /* mwait does not enter c-state */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
-- 
1.5.0.6




