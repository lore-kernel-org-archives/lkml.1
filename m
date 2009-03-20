Return-Path: <linux-kernel-owner+w=401wt.eu-S1763149AbZCTX0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763149AbZCTX0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762925AbZCTXYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:20 -0400
Received: from kroah.org ([198.145.64.141]:48448 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762931AbZCTXYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:23 2009
Message-Id: <20090320222923.128981119@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Joe Korty <joe.korty@ccur.com>
Subject: [patch 02/43] Fix misreporting of #cores as #hyperthreads for Q9550
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=fix-misreporting-of-cores-as-hyperthreads-for-q9550.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joe Korty <joe.korty@ccur.com>

For the Q9550, in x86_64 mode, /proc/cpuinfo mistakenly
thinks the #cores present is the #hyperthreads present.
i386 mode was not examined but is assumed to have the
same problem.

A backport of the following three 2.6.29-rc1 patches
fixes the problem:

 066941bd4eeb159307a5d7d795100d0887c00442:
    [PATCH] x86: unmask CPUID levels on Intel CPUs
 99fb4d349db7e7dacb2099c5cc320a9e2d31c1ef:
    [PATCH] x86: unmask CPUID levels on Intel CPUs, fix
 bdf21a49bab28f0d9613e8d8724ef9c9168b61b9:
    [PATCH] x86: add MSR_IA32_MISC_ENABLE bits to <asm/msr-index.h>

>From the first patch: "If the CPUID limit bit in
MSR_IA32_MISC_ENABLE is set, clear it to make all CPUID
information available.  This is required for some features
to work, in particular XSAVE."

Originally-Developed-by: H. Peter Anvin <hpa@linux.intel.com>
Backported-by: Joe Korty <joe.korty@ccur.com>
Signed-off-by: Joe Korty <joe.korty@ccur.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/msr-index.h |   29 +++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c      |   13 +++++++++++++
 2 files changed, 42 insertions(+)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -200,6 +200,35 @@
 #define MSR_IA32_THERM_STATUS		0x0000019c
 #define MSR_IA32_MISC_ENABLE		0x000001a0
 
+/* MISC_ENABLE bits: architectural */
+#define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
+#define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
+#define MSR_IA32_MISC_ENABLE_EMON		(1ULL << 7)
+#define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL	(1ULL << 11)
+#define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL	(1ULL << 12)
+#define MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP	(1ULL << 16)
+#define MSR_IA32_MISC_ENABLE_MWAIT		(1ULL << 18)
+#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID	(1ULL << 22)
+#define MSR_IA32_MISC_ENABLE_XTPR_DISABLE	(1ULL << 23)
+#define MSR_IA32_MISC_ENABLE_XD_DISABLE		(1ULL << 34)
+
+/* MISC_ENABLE bits: model-specific, meaning may vary from core to core */
+#define MSR_IA32_MISC_ENABLE_X87_COMPAT		(1ULL << 2)
+#define MSR_IA32_MISC_ENABLE_TM1		(1ULL << 3)
+#define MSR_IA32_MISC_ENABLE_SPLIT_LOCK_DISABLE	(1ULL << 4)
+#define MSR_IA32_MISC_ENABLE_L3CACHE_DISABLE	(1ULL << 6)
+#define MSR_IA32_MISC_ENABLE_SUPPRESS_LOCK	(1ULL << 8)
+#define MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE	(1ULL << 9)
+#define MSR_IA32_MISC_ENABLE_FERR		(1ULL << 10)
+#define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX	(1ULL << 10)
+#define MSR_IA32_MISC_ENABLE_TM2		(1ULL << 13)
+#define MSR_IA32_MISC_ENABLE_ADJ_PREF_DISABLE	(1ULL << 19)
+#define MSR_IA32_MISC_ENABLE_SPEEDSTEP_LOCK	(1ULL << 20)
+#define MSR_IA32_MISC_ENABLE_L1D_CONTEXT	(1ULL << 24)
+#define MSR_IA32_MISC_ENABLE_DCU_PREF_DISABLE	(1ULL << 37)
+#define MSR_IA32_MISC_ENABLE_TURBO_DISABLE	(1ULL << 38)
+#define MSR_IA32_MISC_ENABLE_IP_PREF_DISABLE	(1ULL << 39)
+
 /* Intel Model 6 */
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -30,6 +30,19 @@
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
+	/* Unmask CPUID levels if masked: */
+	if (c->x86 == 6 && c->x86_model >= 15) {
+		u64 misc_enable;
+
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+
+		if (misc_enable & MSR_IA32_MISC_ENABLE_LIMIT_CPUID) {
+			misc_enable &= ~MSR_IA32_MISC_ENABLE_LIMIT_CPUID;
+			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+			c->cpuid_level = cpuid_eax(0);
+		}
+	}
+
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);


