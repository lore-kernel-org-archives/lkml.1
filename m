Return-Path: <linux-kernel-owner+w=401wt.eu-S1761545AbZE0ABQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761545AbZE0ABQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbZEZXzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:55:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38628 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbZEZXyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:54 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 22/31] x86: MCE: Extend struct mce user interface with more information.
Date: Wed, 27 May 2009 01:54:24 +0200
Message-Id: <d9664a5ed1cdbfcd7888c7c7114619494114d4ab.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <ecbed09ba385129558d6341f6a48c64edaa164b4.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
 <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
 <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
 <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
 <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
 <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
 <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
 <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com>
 <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com>
 <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com>
 <314f7c278aaaa41854bf4f0837a4ca6126160fc8.1243381848.git.ak@linux.intel.com>
 <ecbed09ba385129558d6341f6a48c64edaa164b4.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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
 arch/x86/include/asm/mce.h       |   10 ++++++++--
 arch/x86/kernel/cpu/mcheck/mce.c |   12 ++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index ee7d427..e958322 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -36,13 +36,19 @@ struct mce {
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
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index aa87530..04cb0d4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -110,6 +110,15 @@ void mce_setup(struct mce *m)
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
 
 DEFINE_PER_CPU(struct mce, injectm);
@@ -187,6 +196,9 @@ static void print_mce(struct mce *m)
 	if (m->misc)
 		printk("MISC %llx ", m->misc);
 	printk("\n");
+	printk(KERN_EMERG "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
+			m->cpuvendor, m->cpuid, m->time, m->socketid,
+			m->apicid);
 	printk(KERN_EMERG "This is not a software problem!\n");
 	printk(KERN_EMERG "Run through mcelog --ascii to decode "
 	       "and contact your hardware vendor\n");
-- 
1.6.0.2

