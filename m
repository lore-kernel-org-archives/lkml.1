Return-Path: <linux-kernel-owner+w=401wt.eu-S1759763AbYFLKak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763AbYFLKak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759371AbYFLK3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:29:20 -0400
Received: from www.tglx.de ([62.245.132.106]:59820 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757151AbYFLK3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:29:19 -0400
Message-Id: <20080610171712.357812343@linutronix.de>
References: <20080610171639.551369443@linutronix.de>
User-Agent: quilt/0.46-1
Date: Thu, 12 Jun 2008 10:28:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [patch 4/6] x86: use cpuid to check MWAIT support for C1
Content-Disposition: inline;
	filename=0004-eb744213eda636f876ec8f9de12169350a5f44f8.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuid(0x05) provides extended information about MWAIT in EDX when bit
0 of ECX is set. Bit 4-7 of EDX determine whether MWAIT is supported
for C1. C1E enabled CPUs have these bits set to 0.

Based on an ealier patch from Andi Kleen.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>

---
 arch/x86/kernel/process.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process.c
+++ linux-2.6/arch/x86/kernel/process.c
@@ -122,19 +122,31 @@ static void poll_idle(void)
  *
  * idle=mwait overrides this decision and forces the usage of mwait.
  */
+
+#define MWAIT_INFO			0x05
+#define MWAIT_ECX_EXTENDED_INFO		0x01
+#define MWAIT_EDX_C1			0xf0
+
 static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 {
+	u32 eax, ebx, ecx, edx;
+
 	if (force_mwait)
 		return 1;
 
-	if (c->x86_vendor == X86_VENDOR_AMD) {
-		switch(c->x86) {
-		case 0x10:
-		case 0x11:
-			return 0;
-		}
-	}
-	return 1;
+	if (c->cpuid_level < MWAIT_INFO)
+		return 0;
+
+	cpuid(MWAIT_INFO, &eax, &ebx, &ecx, &edx);
+	/* Check, whether EDX has extended info about MWAIT */
+	if (!(ecx & MWAIT_ECX_EXTENDED_INFO))
+		return 1;
+
+	/*
+	 * edx enumerates MONITOR/MWAIT extensions. Check, whether C1
+	 * supports MWAIT
+	 */
+	return edx & MWAIT_EDX_C1;
 }
 
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)

-- 

