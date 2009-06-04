Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbZFDKlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbZFDKlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 06:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbZFDKlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 06:41:14 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:41185 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZFDKlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 06:41:13 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i6bh17ch61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KKPN0E-01-PHL-01
Date: Thu, 4 Jun 2009 12:40:16 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: detect use of extended APIC ID for AMD CPUs
Message-ID: <20090604104016.GT5736@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 Jun 2009 10:41:03.0542 (UTC) FILETIME=[F5537D60:01C9E500]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Booting a 32-bit kernel on Magny-Cours results in the following panic

  ...
  Using APIC driver default
  ...
  Overriding APIC driver with bigsmp
  ...
  Getting VERSION: 80050010
  Getting VERSION: 80050010
  Getting ID: 10000000
  Getting ID: ef000000
  Getting LVT0: 700
  Getting LVT1: 10000
  Kernel panic - not syncing: Boot APIC ID in local APIC unexpected (16 vs 0)
  Pid: 1, comm: swapper Not tainted 2.6.30-rcX #2
  Call Trace:
   [<c05194da>] ? panic+0x38/0xd3
   [<c0743102>] ? native_smp_prepare_cpus+0x259/0x31f
   [<c073b19d>] ? kernel_init+0x3e/0x141
   [<c073b15f>] ? kernel_init+0x0/0x141
   [<c020325f>] ? kernel_thread_helper+0x7/0x10

The reason is that default_get_apic_id handled extension of local APIC
ID field just in case of XAPIC.
Thus for this AMD CPU, default_get_apic_id() returns 0 and
bigsmp_get_apic_id() returns 16 which leads to the respective kernel
panic.

This patch introduces a Linux specific feature flag to indicate
support for extended APIC id (8 bits instead of 4 bits width) and sets
the flag on AMD CPUs if applicable.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/apic.h       |    2 +-
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |    9 +++++++++
 3 files changed, 11 insertions(+), 1 deletions(-)

Normally you would run 64-bit kernel on such a CPU which correctly
handles 8-bit APIC id. So this is not a big issue, but it's still a
bug in the 32-bit case.

Patch is against tip/master plus 5 patches from
"[PATCH 0/5 v3] x86: adapt CPU topology detection for AMD Magny-Cours"
Please apply.


Thanks,

Andreas

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 229d0be..bb7d479 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -402,7 +402,7 @@ static inline unsigned default_get_apic_id(unsigned long x)
 {
 	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
 
-	if (APIC_XAPIC(ver))
+	if (APIC_XAPIC(ver) || boot_cpu_has(X86_FEATURE_EXTD_APICID))
 		return (x >> 24) & 0xFF;
 	else
 		return (x >> 24) & 0x0F;
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 7abe596..6143bfb 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -95,6 +95,7 @@
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
 #define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
 #define X86_FEATURE_AMD_DCM     (3*32+26) /* multi-node processor */
+#define X86_FEATURE_EXTD_APICID	(3*32+27) /* has extended APICID (8 bits) */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 8c27925..551adb8 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -409,6 +409,15 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 		    (c->x86_model == 8 && c->x86_mask >= 8))
 			set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 #endif
+#ifdef CONFIG_X86_LOCAL_APIC
+	/* check CPU config space for extended APIC ID */
+	if (c->x86 >= 0xf) {
+		unsigned int val;
+		val = read_pci_config(0, 24, 0, 0x68);
+		if ((val & ((1 << 17) | (1 << 18))) == ((1 << 17) | (1 << 18)))
+			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
+	}
+#endif
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
-- 
1.6.0.4



