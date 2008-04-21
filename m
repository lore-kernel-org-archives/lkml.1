Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYDUMBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYDUMBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbYDUMBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:01:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53060 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbYDUMBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:01:15 -0400
Date: Mon, 21 Apr 2008 14:00:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       hpa@zytor.com, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080421120054.GA6788@elte.hu>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421085314.GI26897@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> I shouldn't send bug reports at 3 in the morning...
> 
> Attached is the .config for both Voyager build errors I reported.

thanks, the three patches below should fix it.

i ended up excluding Voyager configs from our test space some time ago 
(and VISWS as well - there's one more visws fix in x86.git), that's how 
this broke. These subarchitectures seem not to be used at all and the 
code wont boot on normal PCs. We could mark it BROKEN but the fix seems 
simple in any case.

	Ingo

---------------------->
Subject: x86: voyager fix
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Apr 21 13:39:53 CEST 2008

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig                    |    2 +-
 arch/x86/kernel/setup.c             |    2 ++
 arch/x86/mach-voyager/voyager_smp.c |   17 -----------------
 3 files changed, 3 insertions(+), 18 deletions(-)

Index: linux-x86.q/arch/x86/Kconfig
===================================================================
--- linux-x86.q.orig/arch/x86/Kconfig
+++ linux-x86.q/arch/x86/Kconfig
@@ -23,7 +23,7 @@ config X86
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
 	select HAVE_KVM if ((X86_32 && !X86_VOYAGER && !X86_VISWS && !X86_NUMAQ) || X86_64)
-	select HAVE_ARCH_KGDB
+	select HAVE_ARCH_KGDB if !X86_VOYAGER
 
 
 config GENERIC_LOCKBREAK
Index: linux-x86.q/arch/x86/kernel/setup.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/setup.c
+++ linux-x86.q/arch/x86/kernel/setup.c
@@ -21,8 +21,10 @@ EXPORT_SYMBOL(boot_cpu_physical_apicid);
 DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
+#ifndef CONFIG_X86_VOYAGER
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
+#endif
 
 #if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
 /*
Index: linux-x86.q/arch/x86/mach-voyager/voyager_smp.c
===================================================================
--- linux-x86.q.orig/arch/x86/mach-voyager/voyager_smp.c
+++ linux-x86.q/arch/x86/mach-voyager/voyager_smp.c
@@ -208,11 +208,6 @@ static struct irq_chip vic_chip = {
 /* used to count up as CPUs are brought on line (starts at 0) */
 static int cpucount = 0;
 
-/* steal a page from the bottom of memory for the trampoline and
- * squirrel its address away here.  This will be in kernel virtual
- * space */
-unsigned char *trampoline_base;
-
 /* The per cpu profile stuff - used in smp_local_timer_interrupt */
 static DEFINE_PER_CPU(int, prof_multiplier) = 1;
 static DEFINE_PER_CPU(int, prof_old_multiplier) = 1;
@@ -429,18 +424,6 @@ void __init smp_store_cpu_info(int id)
 	identify_secondary_cpu(c);
 }
 
-/* set up the trampoline and return the physical address of the code */
-unsigned long __init setup_trampoline(void)
-{
-	/* these two are global symbols in trampoline.S */
-	extern const __u8 trampoline_end[];
-	extern const __u8 trampoline_data[];
-
-	memcpy(trampoline_base, trampoline_data,
-	       trampoline_end - trampoline_data);
-	return virt_to_phys(trampoline_base);
-}
-
 /* Routine initially called when a non-boot CPU is brought online */
 static void __init start_secondary(void *unused)
 {

Subject: x86: Drop duplicate from setup.c
From: Alexey Starikovskiy <astarikovskiy@suse.de>
Date: Mon, 21 Apr 2008 13:31:55 +0400

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-x86.q/arch/x86/kernel/setup.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/setup.c
+++ linux-x86.q/arch/x86/kernel/setup.c
@@ -18,8 +18,6 @@ unsigned disabled_cpus __cpuinitdata;
 unsigned int boot_cpu_physical_apicid = -1U;
 EXPORT_SYMBOL(boot_cpu_physical_apicid);
 
-physid_mask_t phys_cpu_present_map;
-
 DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
Subject: x86: fix compilation error in VisWS
From: Alexey Starikovskiy <astarikovskiy@suse.de>
Date: Mon, 21 Apr 2008 13:32:01 +0400

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mach-visws/mpparse.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

Index: linux-x86.q/arch/x86/mach-visws/mpparse.c
===================================================================
--- linux-x86.q.orig/arch/x86/mach-visws/mpparse.c
+++ linux-x86.q/arch/x86/mach-visws/mpparse.c
@@ -11,22 +11,9 @@
 /* Have we found an MP table */
 int smp_found_config;
 
-/*
- * Various Linux-internal data structures created from the
- * MP-table.
- */
-int apic_version [MAX_APICS];
-
 int pic_mode;
-unsigned long mp_lapic_addr;
-
-/* Processor that is doing the boot up */
-unsigned int boot_cpu_physical_apicid = -1U;
-
-/* Bitmask of physically existing CPUs */
-physid_mask_t phys_cpu_present_map;
 
-unsigned int __initdata maxcpus = NR_CPUS;
+extern unsigned int __cpuinitdata maxcpus;
 
 /*
  * The Visual Workstation is Intel MP compliant in the hardware
