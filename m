Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbYACAzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbYACAzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759933AbYACAuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:19 -0500
Received: from ns.suse.de ([195.135.220.2]:51786 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759815AbYACAuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:13 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [16/20] x86: Allow TSC clock source on AMD Fam10h and some cleanup
Message-Id: <20080103005012.124DE14D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After a lot of discussions with AMD it turns out that TSC
on Fam10h CPUs is synchronized when the CONSTANT_TSC cpuid bit is set. 
Or rather that if there are ever systems where that is not
true it would be their BIOS' task to disable the bit.

So finally use TSC gettimeofday on Fam10h by default.

Or rather it is always used now on CPUs where the AMD 
specific CONSTANT_TSC bit is set.

This gives a nice speed bost for gettimeofday() on these systems
which tends to be by far the most common v/syscall.

On a Fam10h system here TSC gtod uses about 20% of the CPU time of 
acpi_pm based gtod(). This was measured on 32bit, on 64bit
it is even better because TSC gtod() can use a vsyscall
and stay in ring 3, which acpi_pm doesn't.

The Intel check simply checks for CONSTANT_TSC too without hardcoding
Intel vendor. This is equivalent on 64bit because all 64bit capable Intel 
CPUs will have CONSTANT_TSC set. 

On Intel there is no CPU supplied CONSTANT_TSC bit currently,
but we synthesize one based on hardcoded knowledge which steppings
have p-state invariant TSC.

So the new logic is now: On CPUs which have the AMD specific
CONSTANT_TSC bit set or on Intel CPUs which are new enough
to be known to have p-state invariant TSC always use 
TSC based gettimeofday()

Cc: lenb@kernel.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/tsc_32.c |    5 +++++
 arch/x86/kernel/tsc_64.c |    5 ++---
 2 files changed, 7 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/tsc_32.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc_32.c
+++ linux/arch/x86/kernel/tsc_32.c
@@ -354,6 +354,11 @@ __cpuinit int unsynchronized_tsc(void)
 {
 	if (!cpu_has_tsc || tsc_unstable)
 		return 1;
+
+	/* Anything with constant TSC should be synchronized */
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		return 0;
+
 	/*
 	 * Intel systems are normally all synchronized.
 	 * Exceptions must mark TSC as unstable:
Index: linux/arch/x86/kernel/tsc_64.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc_64.c
+++ linux/arch/x86/kernel/tsc_64.c
@@ -276,9 +276,8 @@ __cpuinit int unsynchronized_tsc(void)
 	if (apic_is_clustered_box())
 		return 1;
 #endif
-	/* Most intel systems have synchronized TSCs except for
-	   multi node systems */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
+
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 #ifdef CONFIG_ACPI
 		/* But TSC doesn't tick in C3 so don't use it there */
 		if (acpi_gbl_FADT.header.length > 0 &&
