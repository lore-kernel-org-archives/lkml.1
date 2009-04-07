Return-Path: <linux-kernel-owner+w=401wt.eu-S1760513AbZDGPSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513AbZDGPSG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbZDGPIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48880 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758776AbZDGPIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:11 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [25/28] x86: MCE: Extend struct mce user interface with more information.
Message-Id: <20090407150808.9AEDC1D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:08:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Experience has shown that struct mce which is used to pass an machine check 
to the user space daemon currently a few limitations.  Also some data
which is useful to print at panic level is also missing.

This patch addresses most of them. The same information is also
printed out together with mce panic.

struct mce can be painlessly extended in a compatible way, the mcelog user space 
code just ignores additional fields with a warning.

- It doesn't provide a wall time timestamp. There have been a few
complaints about that. Fix that by adding a 64bit time_t
- It doesn't provide the exact CPU identification. This makes
it awkward for mcelog to decode the event correctly, especially
when there are variations in the supported MCE codes on different
CPU models or when mcelog is running on a different host after a panic.  
Previously the administrator had to specify the correct CPU 
when mcelog ran on a different host, but with the more variation
in machine checks now it's better to auto detect that.
It's also useful for more detailed analysis of CPU events.
Pass CPUID 1.EAX and the cpu vendor (as encoded in processor.h) instead.
- Socket ID and initial APIC ID are useful to report because they
allow to identify the failing CPU in some (not all) cases.
This is also especially useful for the panic situation.
This addresses one of the complaints from Thomas Gleixner earlier.
- The MCG capabilities MSR needs to be reported for some advanced 
error processing in mcelog

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h          |   10 ++++++++--
 arch/x86/kernel/cpu/mcheck/mce_64.c |   12 ++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/include/asm/mce.h	2009-04-07 16:43:09.000000000 +0200
@@ -36,13 +36,19 @@
 	__u64 mcgstatus;
 	__u64 ip;
 	__u64 tsc;	/* cpu time stamp counter */
-	__u64 res1;	/* for future extension */
-	__u64 res2;	/* dito. */
+	__u64 time;	/* wall time_t when error was detected */
+	__u8  cpuvendor;	/* cpu vendor as encoded in system.h */
+	__u8  pad1;
+	__u16 pad2;
+	__u32 cpuid;	/* CPUID 1 EAX */
 	__u8  cs;		/* code segment */
 	__u8  bank;	/* machine check bank */
 	__u8  cpu;	/* cpu number; obsolete; use extcpu now */
 	__u8  finished;   /* entry is valid */
 	__u32 extcpu;	/* linux cpu number that detected the error */
+	__u32 socketid;	/* CPU socket ID */
+	__u32 apicid;	/* CPU initial apic ID */
+	__u64 mcgcap;	/* MCGCAP MSR: machine check capabilities of CPU */
 };
 
 /*
Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:09.000000000 +0200
@@ -84,6 +84,15 @@
 	memset(m, 0, sizeof(struct mce));
 	m->cpu = m->extcpu = smp_processor_id();
 	rdtscll(m->tsc);
+	/* We hope get_seconds stays lockless */
+	m->time = get_seconds();
+	m->cpuvendor = boot_cpu_data.x86_vendor;
+	m->cpuid = cpuid_eax(1);
+#ifdef CONFIG_SMP
+	m->socketid = cpu_data(m->extcpu).phys_proc_id;
+#endif
+	m->apicid = cpu_data(m->extcpu).initial_apicid;
+	rdmsrl(MSR_IA32_MCG_CAP, m->mcgcap);
 }
 
 DEFINE_PER_CPU(unsigned, mce_exception_count);
@@ -155,6 +164,9 @@
 	if (m->misc)
 		printk("MISC %llx ", m->misc);
 	printk("\n");
+	printk(KERN_EMERG "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
+			m->cpuvendor, m->cpuid, m->time, m->socketid,
+			m->apicid);
 	printk(KERN_EMERG "This is not a software problem!\n");
 	printk(KERN_EMERG "Run through mcelog --ascii to decode "
 	       "and contact your hardware vendor\n");
