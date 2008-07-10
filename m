Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbYGJXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbYGJXXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYGJXXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:23:10 -0400
Received: from gw.goop.org ([64.81.55.164]:48978 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYGJXXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:23:09 -0400
Message-ID: <487699D0.4030508@goop.org>
Date: Thu, 10 Jul 2008 16:22:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86_64: add pseudo-features for 32-bit compat syscall
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pseudo-feature bits to describe whether the CPU supports sysenter
and/or syscall from ia32-compat userspace.  This removes a hardcoded
test in vdso32-setup.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/cpu/centaur_64.c |    2 ++
 arch/x86/kernel/cpu/common_64.c  |    3 +++
 arch/x86/kernel/cpu/intel_64.c   |    2 ++
 include/asm-x86/cpufeature.h     |    4 ++--
 4 files changed, 9 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/kernel/cpu/centaur_64.c
+++ b/arch/x86/kernel/cpu/centaur_64.c
@@ -10,6 +10,8 @@ static void __cpuinit early_init_centaur
 {
 	if (c->x86 == 0x6 && c->x86_model >= 0xf)
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+
+	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
 }
 
 static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
===================================================================
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -315,6 +315,9 @@ static void __cpuinit early_identify_cpu
 	if (c->extended_cpuid_level >= 0x80000007)
 		c->x86_power = cpuid_edx(0x80000007);
 
+	/* Assume all 64-bit CPUs support 32-bit syscall */
+	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
+
 	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
 	    cpu_devs[c->x86_vendor]->c_early_init)
 		cpu_devs[c->x86_vendor]->c_early_init(c);
===================================================================
--- a/arch/x86/kernel/cpu/intel_64.c
+++ b/arch/x86/kernel/cpu/intel_64.c
@@ -12,6 +12,8 @@ static void __cpuinit early_init_intel(s
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+
+	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
 }
 
 /*
===================================================================
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -74,8 +74,8 @@
 #define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
 #define X86_FEATURE_PEBS	(3*32+12)  /* Precise-Event Based Sampling */
 #define X86_FEATURE_BTS		(3*32+13)  /* Branch Trace Store */
-/* 14 free */
-/* 15 free */
+#define X86_FEATURE_SYSCALL32	(3*32+14)  /* syscall in ia32 userspace */
+#define X86_FEATURE_SYSENTER32	(3*32+15)  /* sysenter in ia32 userspace */
 #define X86_FEATURE_REP_GOOD	(3*32+16) /* rep microcode works well on this CPU */
 #define X86_FEATURE_MFENCE_RDTSC (3*32+17) /* Mfence synchronizes RDTSC */
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */


