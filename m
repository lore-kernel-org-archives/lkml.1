Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbYACAxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbYACAxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759803AbYACAuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:12 -0500
Received: from ns2.suse.de ([195.135.220.15]:58345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759607AbYACAuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:07 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: andreas.herrmann3@amd.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [11/20] x86: Use the correct cpuid method to detect MWAIT support for C states
Message-Id: <20080103005006.BE79A14D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Previously there was a AMD specific quirk to handle the case of
AMD Fam10h MWAIT not supporting any C states. But it turns out
that CPUID already has ways to detectly detect that without
using special quirks. 

The new code simply checks if MWAIT supports at least C1 and doesn't
use it if it doesn't. No more vendor specific code.

Credit goes to Ben Serebrin for pointing out the (nearly) obvious.

Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/amd.c    |    3 ---
 arch/x86/kernel/process_32.c |   10 +++++++++-
 arch/x86/kernel/process_64.c |   11 ++++++++++-
 arch/x86/kernel/setup_64.c   |    4 ----
 4 files changed, 19 insertions(+), 9 deletions(-)

Index: linux/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/amd.c
+++ linux/arch/x86/kernel/cpu/amd.c
@@ -295,9 +295,6 @@ static void __cpuinit init_amd(struct cp
 		local_apic_timer_disabled = 1;
 #endif
 
-	if (c->x86 == 0x10 && !force_mwait)
-		clear_bit(X86_FEATURE_MWAIT, c->x86_capability);
-
 	/* K6s reports MCEs but don't actually have all the MSRs */
 	if (c->x86 < 6)
 		clear_bit(X86_FEATURE_MCE, c->x86_capability);
Index: linux/arch/x86/kernel/process_32.c
===================================================================
--- linux.orig/arch/x86/kernel/process_32.c
+++ linux/arch/x86/kernel/process_32.c
@@ -271,9 +271,17 @@ static void mwait_idle(void)
 	mwait_idle_with_hints(0, 0);
 }
 
+static int mwait_usable(const struct cpuinfo_x86 *c)
+{
+	if (force_mwait)
+		return 1;
+	/* Any C1 states supported? */
+	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
+}
+
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_MWAIT)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
 		printk("monitor/mwait feature present.\n");
 		/*
 		 * Skip, if setup has overridden idle.
Index: linux/arch/x86/kernel/process_64.c
===================================================================
--- linux.orig/arch/x86/kernel/process_64.c
+++ linux/arch/x86/kernel/process_64.c
@@ -270,10 +270,19 @@ static void mwait_idle(void)
 	}
 }
 
+
+static int mwait_usable(const struct cpuinfo_x86 *c)
+{
+	if (force_mwait)
+		return 1;
+	/* Any C1 states supported? */
+	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
+}
+
 void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
 {
 	static int printed;
-	if (cpu_has(c, X86_FEATURE_MWAIT)) {
+	if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
 		/*
 		 * Skip, if setup has overridden idle.
 		 * One CPU supports mwait => All CPUs supports mwait
Index: linux/arch/x86/kernel/setup_64.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_64.c
+++ linux/arch/x86/kernel/setup_64.c
@@ -760,10 +760,6 @@ static void __cpuinit init_amd(struct cp
 	/* MFENCE stops RDTSC speculation */
 	set_cpu_cap(c, X86_FEATURE_MFENCE_RDTSC);
 
-	/* Family 10 doesn't support C states in MWAIT so don't use it */
-	if (c->x86 == 0x10 && !force_mwait)
-		clear_cpu_cap(c, X86_FEATURE_MWAIT);
-
 	if (amd_apic_timer_broken())
 		disable_apic_timer = 1;
 }
