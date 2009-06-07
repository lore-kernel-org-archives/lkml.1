Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZFGOno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZFGOno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbZFGOn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:43:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:52879 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbZFGOnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:43:23 -0400
Date: Sun, 7 Jun 2009 14:42:56 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090604104016.GT5736@alberich.amd.com>
References: <20090604104016.GT5736@alberich.amd.com>
Subject: [tip:x86/urgent] x86: Detect use of extended APIC ID for AMD CPUs
Message-ID: <tip-37f36c1017f0032fa7a1fb85a0cddfc0d526d17f@git.kernel.org>
Git-Commit-ID: 37f36c1017f0032fa7a1fb85a0cddfc0d526d17f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 14:42:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37f36c1017f0032fa7a1fb85a0cddfc0d526d17f
Gitweb:     http://git.kernel.org/tip/37f36c1017f0032fa7a1fb85a0cddfc0d526d17f
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 4 Jun 2009 12:40:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 16:39:38 +0200

x86: Detect use of extended APIC ID for AMD CPUs

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
Cc: <stable@kernel.org>
LKML-Reference: <20090604104016.GT5736@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/apic.h       |    2 +-
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |   10 ++++++++++
 3 files changed, 12 insertions(+), 1 deletions(-)

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
index 7e4a459..fae8be8 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -351,6 +351,16 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 		    (c->x86_model == 8 && c->x86_mask >= 8))
 			set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 #endif
+#ifdef CONFIG_X86_LOCAL_APIC
+	/* check CPU config space for extended APIC ID */
+	if (c->x86 >= 0xf) {
+		unsigned int val;
+
+		val = read_pci_config(0, 24, 0, 0x68);
+		if ((val & ((1 << 17) | (1 << 18))) == ((1 << 17) | (1 << 18)))
+			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
+	}
+#endif
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
