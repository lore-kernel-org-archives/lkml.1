Return-Path: <linux-kernel-owner+w=401wt.eu-S1764191AbYARR3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764191AbYARR3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762948AbYARR1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:27:25 -0500
Received: from ns2.suse.de ([195.135.220.15]:35706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762389AbYARR1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:27:24 -0500
From: Andi Kleen <ak@suse.de>
References: <20080118627.198787000@suse.de>
In-Reply-To: <20080118627.198787000@suse.de>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [7/7] Add generic clearcpuid=... option
Message-Id: <20080118172723.B604B14AAE@wotan.suse.de>
Date: Fri, 18 Jan 2008 18:27:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a generic option to clear any cpuid bit. I added it because it was
very easy to add with the new generic cpuid disable bitmap and perhaps
it will be useful in the future.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/kernel-parameters.txt |   13 +++++++++++++
 arch/x86/kernel/cpu/common.c        |   11 +++++++++++
 arch/x86/kernel/setup_64.c          |   11 +++++++++++
 3 files changed, 35 insertions(+)

Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -572,6 +572,17 @@ void __cpuinit print_cpu_info(struct cpu
 		printk("\n");
 }
 
+static __init int setup_disablecpuid(char *arg)
+{
+	int bit;
+	if (get_option(&arg, &bit) && bit < NCAPINTS*32)
+		setup_clear_cpu_cap(bit);
+	else
+		return 0;
+	return 1;
+}
+__setup("clearcpuid=", setup_disablecpuid);
+
 cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
 
 /* This is hacky. :)
Index: linux/arch/x86/kernel/setup_64.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_64.c
+++ linux/arch/x86/kernel/setup_64.c
@@ -1060,6 +1060,17 @@ void __cpuinit print_cpu_info(struct cpu
 		printk(KERN_CONT "\n");
 }
 
+static __init int setup_disablecpuid(char *arg)
+{
+	int bit;
+	if (get_option(&arg, &bit) && bit < NCAPINTS*32)
+		setup_clear_cpu_cap(bit);
+	else
+		return 0;
+	return 1;
+}
+__setup("clearcpuid=", setup_disablecpuid);
+
 /*
  *	Get CPU information for use by the procfs.
  */
Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -408,6 +408,19 @@ and is between 256 and 4096 characters. 
 			[SPARC64] tick
 			[X86-64] hpet,tsc
 
+	clearcpuid=BITNUM [X86]
+			Disable CPUID feature X for the kernel. See
+			include/asm-x86/cpufeature.h for the valid bit numbers.
+			Note the Linux specific bits are not necessarily
+			stable over kernel options, but the vendor specific
+			ones should be.
+			Also note that user programs calling CPUID directly
+			or using the feature without checking anything
+			will still see it. This just prevents it from
+			being used by the kernel or shown in /proc/cpuinfo.
+			Also note the kernel might malfunction if you disable
+			some critical bits.
+
 	code_bytes	[IA32/X86_64] How many bytes of object code to print
 			in an oops report.
 			Range: 0 - 8192
