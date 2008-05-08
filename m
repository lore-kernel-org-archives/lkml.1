Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbYEHB4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbYEHB4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 21:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbYEHB4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 21:56:13 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:53922 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbYEHB4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 21:56:11 -0400
Message-ID: <48225DEC.2030502@keyaccess.nl>
Date: Thu, 08 May 2008 03:57:00 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH] x86: introduce a new Linux defined feature flag for PAT support
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl>
In-Reply-To: <48224930.9030901@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-05-08 02:28, Rene Herman wrote:

> I completely and fully agree with your new flag suggestion. Was just
> in a git bisect and am actually on the lowly thing in question so I'm
> not fast but was looking already. X86_FEATURE_PAT_GOOD. Is it safe to
> reuse bit 14 now?

Okay, so how's this? Seem to work well for me and makes me happy. Only
tested on UP.

(hope the inline thing works)

 arch/x86/kernel/cpu/common.c        |   12 ++++--------
 arch/x86/kernel/cpu/feature_names.c |    2 +-
 arch/x86/kernel/setup_64.c          |    7 ++-----
 arch/x86/mm/pat.c                   |    2 +-
 include/asm-x86/cpufeature.h        |    3 ++-
 5 files changed, 10 insertions(+), 16 deletions(-)

x86: introduce a new Linux defined feature flag for PAT support

Use a new Linux defined X86_FEATURE_PAT_GOOD feature flag to
indicate we're on a CPU we want to support PAT on, so as to
keep the CPU defined X86_FEATURE_PAT readily available for
indicating if the CPU even has the PAT feature.

Signed-off-by: Rene Herman <rene.herman@gmail.com>

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 35b4f6a..7bec5e0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -308,16 +308,14 @@ static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
 
 	}
 
-	clear_cpu_cap(c, X86_FEATURE_PAT);
-
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
 		if (c->x86 >= 0xf && c->x86 <= 0x11)
-			set_cpu_cap(c, X86_FEATURE_PAT);
+			set_cpu_cap(c, X86_FEATURE_PAT_GOOD);
 		break;
 	case X86_VENDOR_INTEL:
 		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
-			set_cpu_cap(c, X86_FEATURE_PAT);
+			set_cpu_cap(c, X86_FEATURE_PAT_GOOD);
 		break;
 	}
 
@@ -409,16 +407,14 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 		init_scattered_cpuid_features(c);
 	}
 
-	clear_cpu_cap(c, X86_FEATURE_PAT);
-
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
 		if (c->x86 >= 0xf && c->x86 <= 0x11)
-			set_cpu_cap(c, X86_FEATURE_PAT);
+			set_cpu_cap(c, X86_FEATURE_PAT_GOOD);
 		break;
 	case X86_VENDOR_INTEL:
 		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
-			set_cpu_cap(c, X86_FEATURE_PAT);
+			set_cpu_cap(c, X86_FEATURE_PAT_GOOD);
 		break;
 	}
 }
diff --git a/arch/x86/kernel/cpu/feature_names.c b/arch/x86/kernel/cpu/feature_names.c
index e43ad4a..04f996d 100644
--- a/arch/x86/kernel/cpu/feature_names.c
+++ b/arch/x86/kernel/cpu/feature_names.c
@@ -38,7 +38,7 @@ const char * const x86_cap_flags[NCAPINTS*32] = {
 	"cxmmx", "k6_mtrr", "cyrix_arr", "centaur_mcr",
 	NULL, NULL, NULL, NULL,
 	"constant_tsc", "up", NULL, "arch_perfmon",
-	"pebs", "bts", NULL, NULL,
+	"pebs", "bts", "pat_good", NULL,
 	"rep_good", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 22c14e2..460134e 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1063,19 +1063,16 @@ static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
-
-	clear_cpu_cap(c, X86_FEATURE_PAT);
-
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
 		early_init_amd(c);
 		if (c->x86 >= 0xf && c->x86 <= 0x11)
-			set_cpu_cap(c, X86_FEATURE_PAT);
+			set_cpu_cap(c, X86_FEATURE_PAT_GOOD);
 		break;
 	case X86_VENDOR_INTEL:
 		early_init_intel(c);
 		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
-			set_cpu_cap(c, X86_FEATURE_PAT);
+			set_cpu_cap(c, X86_FEATURE_PAT_GOOD);
 		break;
 	case X86_VENDOR_CENTAUR:
 		early_init_centaur(c);
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 277446c..6ee3efb 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -43,7 +43,7 @@ static int pat_known_cpu(void)
 	if (!pat_wc_enabled)
 		return 0;
 
-	if (cpu_has_pat)
+	if (cpu_has_pat && cpu_has_pat_good)
 		return 1;
 
 	pat_wc_enabled = 0;
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 0d609c8..63c14e4 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -74,7 +74,7 @@
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
 #define X86_FEATURE_PEBS	(3*32+12)  /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
-/* 14 free */
+#define X86_FEATURE_PAT_GOOD	(3*32+14) /* PAT works correctly */
 /* 15 free */
 #define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
 #define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
@@ -187,6 +187,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
+#define cpu_has_pat_good	boot_cpu_has(X86_FEATURE_PAT_GOOD)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1
