Return-Path: <linux-kernel-owner+w=401wt.eu-S1764449AbZGAAzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764449AbZGAAzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761430AbZGAAeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:37 -0400
Received: from kroah.org ([198.145.64.141]:60236 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760079AbZGAAee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:22 2009
Message-Id: <20090701002421.984876144@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 030/108] x86: Detect use of extended APIC ID for AMD CPUs
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=x86-detect-use-of-extended-apic-id-for-amd-cpus.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 42937e81a82b6bbc51a309c83da140b3a7ca5945 upstream.

Booting a 32-bit kernel on Magny-Cours results in the following panic:

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
LKML-Reference: <20090608135509.GA12431@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/apic.h       |    2 +-
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |   10 ++++++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -410,7 +410,7 @@ static inline unsigned default_get_apic_
 {
 	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
 
-	if (APIC_XAPIC(ver))
+	if (APIC_XAPIC(ver) || boot_cpu_has(X86_FEATURE_EXTD_APICID))
 		return (x >> 24) & 0xFF;
 	else
 		return (x >> 24) & 0x0F;
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -94,6 +94,7 @@
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
 #define X86_FEATURE_CLFLUSH_MONITOR (3*32+25) /* "" clflush reqd with monitor */
+#define X86_FEATURE_EXTD_APICID	(3*32+26) /* has extended APICID (8 bits) */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -6,6 +6,7 @@
 #include <asm/processor.h>
 #include <asm/apic.h>
 #include <asm/cpu.h>
+#include <asm/pci-direct.h>
 
 #ifdef CONFIG_X86_64
 # include <asm/numa_64.h>
@@ -351,6 +352,15 @@ static void __cpuinit early_init_amd(str
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


