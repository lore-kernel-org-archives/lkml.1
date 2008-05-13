Return-Path: <linux-kernel-owner+w=401wt.eu-S1760517AbYEMN3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760517AbYEMN3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbYEMN30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:29:26 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:58840 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbYEMN3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:29:25 -0400
Date: Tue, 13 May 2008 14:26:57 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Glauber Costa <gcosta@redhat.com>
cc: Glauber Costa <glommer@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix app crashes after SMP resume
Message-ID: <Pine.LNX.4.64.0805131420030.5781@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After resume on a 2cpu laptop, kernel builds collapse with a sed hang,
sh or make segfault (often on 20295564), real-time signal to cc1 etc.

Several hurdles to jump, but a manually-assisted bisect led to -rc1's
d2bcbad5f3ad38a1c09861bca7e252dde7bb8259 x86: do not zap_low_mappings
in __smp_prepare_cpus.  Though the low mappings were removed at bootup,
they were left behind (with Global flags helping to keep them in TLB)
after resume or cpu online, causing the crashes seen.

Reinstate zap_low_mappings (with local __flush_tlb_all) for each cpu_up
on x86_32.  This used to be serialized by smp_commenced_mask: that's now
gone, but a low_mappings flag will do.  No need for native_smp_cpus_done
to repeat the zap: let mem_init zap BSP's low mappings just like on UP.

(In passing, fix error code from native_cpu_up: do_boot_cpu returns a
variety of diagnostic values, Dprintk what it says but convert to -EIO.
And save_pg_dir separately before zap_low_mappings: doesn't matter now,
but zapping twice in succession wiped out resume's swsusp_pg_dir.)

That worked well on the duo and one quad, but wouldn't boot 3rd or 4th
cpu on P4 Xeon, oopsing just after unlock_ipi_call_lock.  The TLB flush
IPI now being sent reveals a long-standing bug: the booting cpu has its
APIC readied in smp_callin at the top of start_secondary, but isn't put
into the cpu_online_map until just before that unlock_ipi_call_lock.

So native_smp_call_function_mask to online cpus would send_IPI_allbutself,
including the cpu just coming up, though it has been excluded from the
count to wait for: by the time it handles the IPI, the call data on
native_smp_call_function_mask's stack may well have been overwritten.

So fall back to send_IPI_mask while cpu_online_map does not match
cpu_callout_map: perhaps there's a better APICological fix to be
made at the start_secondary end, but I wouldn't know that.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
I've often wondered: should git reject any commit with "bad" in the id?

 arch/x86/kernel/smp.c     |    3 ++-
 arch/x86/kernel/smpboot.c |   24 +++++++++++++++++-------
 arch/x86/mm/init_32.c     |   12 +-----------
 3 files changed, 20 insertions(+), 19 deletions(-)

--- 2.6.26-rc2/arch/x86/kernel/smp.c	2008-05-03 21:54:40.000000000 +0100
+++ linux/arch/x86/kernel/smp.c	2008-05-13 11:31:26.000000000 +0100
@@ -231,7 +231,8 @@ native_smp_call_function_mask(cpumask_t 
 	wmb();
 
 	/* Send a message to other CPUs */
-	if (cpus_equal(mask, allbutself))
+	if (cpus_equal(mask, allbutself) &&
+	    cpus_equal(cpu_online_map, cpu_callout_map))
 		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
 		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
--- 2.6.26-rc2/arch/x86/kernel/smpboot.c	2008-05-12 02:01:05.000000000 +0100
+++ linux/arch/x86/kernel/smpboot.c	2008-05-12 14:07:06.000000000 +0100
@@ -86,6 +86,7 @@ void *x86_bios_cpu_apicid_early_ptr;
 
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
+static int low_mappings;
 #endif
 
 /* State of each CPU */
@@ -326,6 +327,12 @@ static void __cpuinit start_secondary(vo
 		enable_8259A_irq(0);
 	}
 
+#ifdef CONFIG_X86_32
+	while (low_mappings)
+		cpu_relax();
+	__flush_tlb_all();
+#endif
+
 	/* This must be done before setting cpu_online_map */
 	set_cpu_sibling_map(raw_smp_processor_id());
 	wmb();
@@ -1040,14 +1047,20 @@ int __cpuinit native_cpu_up(unsigned int
 #ifdef CONFIG_X86_32
 	/* init low mem mapping */
 	clone_pgd_range(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-			min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
+		min_t(unsigned long, KERNEL_PGD_PTRS, KERNEL_PGD_BOUNDARY));
 	flush_tlb_all();
-#endif
+	low_mappings = 1;
 
 	err = do_boot_cpu(apicid, cpu);
-	if (err < 0) {
+
+	zap_low_mappings();
+	low_mappings = 0;
+#else
+	err = do_boot_cpu(apicid, cpu);
+#endif
+	if (err) {
 		Dprintk("do_boot_cpu failed %d\n", err);
-		return err;
+		return -EIO;
 	}
 
 	/*
@@ -1259,9 +1272,6 @@ void __init native_smp_cpus_done(unsigne
 	setup_ioapic_dest();
 #endif
 	check_nmi_watchdog();
-#ifdef CONFIG_X86_32
-	zap_low_mappings();
-#endif
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
--- 2.6.26-rc2/arch/x86/mm/init_32.c	2008-05-03 21:54:41.000000000 +0100
+++ linux/arch/x86/mm/init_32.c	2008-05-12 14:07:06.000000000 +0100
@@ -438,8 +438,6 @@ void zap_low_mappings(void)
 {
 	int i;
 
-	save_pg_dir();
-
 	/*
 	 * Zap initial low-memory mappings.
 	 *
@@ -663,16 +661,8 @@ void __init mem_init(void)
 		test_wp_bit();
 
 	cpa_init();
-
-	/*
-	 * Subtle. SMP is doing it's boot stuff late (because it has to
-	 * fork idle threads) - but it also needs low mappings for the
-	 * protected-mode entry to work. We zap these entries only after
-	 * the WP-bit has been tested.
-	 */
-#ifndef CONFIG_SMP
+	save_pg_dir();
 	zap_low_mappings();
-#endif
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
