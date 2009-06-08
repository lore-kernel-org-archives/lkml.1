Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZFHNOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZFHNOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbZFHNOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:14:40 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:8382 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbZFHNOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:14:39 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh17ch61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KKX8RW-01-O7L-01
Date: Mon, 8 Jun 2009 15:12:52 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: [PATCH v2] x86: detect use of extended APIC ID for AMD CPUs
Message-ID: <20090608131252.GC8699@alberich.amd.com>
References: <20090604104016.GT5736@alberich.amd.com> <tip-37f36c1017f0032fa7a1fb85a0cddfc0d526d17f@git.kernel.org> <20090607153327.GA8973@elte.hu> <20090608120131.GA8699@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090608120131.GA8699@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 08 Jun 2009 13:13:40.0818 (UTC) FILETIME=[F123EB20:01C9E83A]
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
  Kernel panic - not syncing: Boot APIC ID in local APIC unexpected (16
vs 0)
  Pid: 1, comm: swapper Not tainted 2.6.30-rc3-numa-fixup-nonuma #2
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
 arch/x86/kernel/cpu/amd.c         |   10 ++++++++++
 3 files changed, 12 insertions(+), 1 deletions(-)

New patch version
- is against tip/x86/urgent (as you have tried to integrate the previous
  patch version into this branch)
- avoids linker error in case of CONFIG_PCI=n

Regards,
Andreas

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 42f2f83..9b2c049 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -410,7 +410,7 @@ static inline unsigned default_get_apic_id(unsigned long x)
 {
 	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
 
-	if (APIC_XAPIC(ver))
+	if (APIC_XAPIC(ver) || boot_cpu_has(X86_FEATURE_EXTD_APICID))
 		return (x >> 24) & 0xFF;
 	else
 		return (x >> 24) & 0x0F;
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb83b1c..78dee4f 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -94,6 +94,7 @@
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
 #define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
+#define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7e4a459..841ed9f 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -6,6 +6,7 @@
 #include <asm/processor.h>
 #include <asm/apic.h>
 #include <asm/cpu.h>
+#include <asm/pci-direct.h>
 
 #ifdef CONFIG_X86_64
 # include <asm/numa_64.h>
@@ -351,6 +352,15 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 		    (c->x86_model == 8 && c->x86_mask >= 8))
 			set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 #endif
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_PCI)
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
1.6.3.1



