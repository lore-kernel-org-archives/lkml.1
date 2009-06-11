Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbZFKXP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbZFKXP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZFKXPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 19:15:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:48036 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757511AbZFKXPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:15:20 -0400
Message-ID: <4A318FD5.7090908@kernel.org>
Date: Thu, 11 Jun 2009 16:14:29 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hannes@cmpxchg.org, mpm@selenic.com, npiggin@suse.de
Subject: Re: [GIT PULL v3] Early boot SLAB for 2.6.31
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain> <alpine.LFD.2.01.0906101332440.6847@localhost.localdomain> <Pine.LNX.4.64.0906111416070.10394@melkki.cs.Helsinki.FI> <alpine.DEB.1.10.0906110954030.29827@gentwo.org> <84144f020906110706y8df301bhd930dc48f3188d3c@mail.gmail.com> <84144f020906110824g7b3981abmdbcf94ae2f9068de@mail.gmail.com> <4A3143E3.3090705@kernel.org> <Pine.LNX.4.64.0906112101020.21593@melkki.cs.Helsinki.FI> <20090611214342.GA12762@elte.hu>
In-Reply-To: <20090611214342.GA12762@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> 
>> Hi Linus,
>>
>> Here's third take on the early boot SLAB patches for 2.6.31. I 
>> fixed the problems found by Ingo in his testing and rebased the 
>> series to be bisectable. I have tested the tree on 32-bit UMA and 
>> on x86-64 with qemu and Yanghai has tested them on NUMA+SLUB 
>> (thanks Yanghai!). Note: The series has not been tested on non-x86 
>> architectures so we may introduce some breakage there.
> 
> Latest -git now produces this boot warning on x86:
> 
> [    0.000000] Memory: 885032k/915540k available (5993k kernel code, 29844k reserved, 3842k data, 428k init, 0k highmem)
> [    0.000000] virtual kernel memory layout:
> [    0.000000]     fixmap  : 0xffe17000 - 0xfffff000   (1952 kB)
> [    0.000000]     vmalloc : 0xf8615000 - 0xffe15000   ( 120 MB)
> [    0.000000]     lowmem  : 0xc0000000 - 0xf7e15000   ( 894 MB)
> [    0.000000]       .init : 0xc19a5000 - 0xc1a10000   ( 428 kB)
> [    0.000000]       .data : 0xc15da4bb - 0xc199af6c   (3842 kB)
> [    0.000000]       .text : 0xc1000000 - 0xc15da4bb   (5993 kB)
> [    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at kernel/smp.c:369 smp_call_function_many+0x50/0x1b0()
> [    0.000000] Hardware name: System Product Name
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.30-tip #52504
> [    0.000000] Call Trace:
> [    0.000000]  [<c104aa16>] warn_slowpath_common+0x65/0x95
> [    0.000000]  [<c104aa58>] warn_slowpath_null+0x12/0x15
> [    0.000000]  [<c1073bbe>] smp_call_function_many+0x50/0x1b0
> [    0.000000]  [<c1037615>] ? do_flush_tlb_all+0x0/0x41
> [    0.000000]  [<c1037615>] ? do_flush_tlb_all+0x0/0x41
> [    0.000000]  [<c1073d4f>] smp_call_function+0x31/0x58
> [    0.000000]  [<c1037615>] ? do_flush_tlb_all+0x0/0x41
> [    0.000000]  [<c104f635>] on_each_cpu+0x26/0x65
> [    0.000000]  [<c10374b5>] flush_tlb_all+0x19/0x1b
> [    0.000000]  [<c1032ab3>] zap_low_mappings+0x4d/0x56
> [    0.000000]  [<c15d64b5>] ? printk+0x14/0x17
> [    0.000000]  [<c19b42a8>] mem_init+0x23d/0x245
> [    0.000000]  [<c19a56a1>] start_kernel+0x17a/0x2d5
> [    0.000000]  [<c19a5347>] ? unknown_bootoption+0x0/0x19a
> [    0.000000]  [<c19a5039>] __init_begin+0x39/0x41
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at kernel/lockdep.c:2128 trace_hardirqs_on_caller+0xc6/0x143()
> [    0.000000] Hardware name: System Product Name
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Tainted: G        W  2.6.30-tip #52504
> [    0.000000] Call Trace:
> [    0.000000]  [<c104aa16>] warn_slowpath_common+0x65/0x95
> [    0.000000]  [<c104f64b>] ? on_each_cpu+0x3c/0x65
> [    0.000000]  [<c1037615>] ? do_flush_tlb_all+0x0/0x41
> [    0.000000]  [<c104aa58>] warn_slowpath_null+0x12/0x15
> [    0.000000]  [<c106c883>] trace_hardirqs_on_caller+0xc6/0x143
> [    0.000000]  [<c106c90b>] trace_hardirqs_on+0xb/0xd
> [    0.000000]  [<c104f64b>] on_each_cpu+0x3c/0x65
> [    0.000000]  [<c10374b5>] flush_tlb_all+0x19/0x1b
> [    0.000000]  [<c1032ab3>] zap_low_mappings+0x4d/0x56
> [    0.000000]  [<c15d64b5>] ? printk+0x14/0x17
> [    0.000000]  [<c19b42a8>] mem_init+0x23d/0x245
> [    0.000000]  [<c19a56a1>] start_kernel+0x17a/0x2d5
> [    0.000000]  [<c19a5347>] ? unknown_bootoption+0x0/0x19a
> [    0.000000]  [<c19a5039>] __init_begin+0x39/0x41
> [    0.000000] ---[ end trace 4eaa2a86a8e2da23 ]---
> [    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
> [    0.000000] start_kernel(): bug: interrupts were enabled *very* early, fixing it
> [    0.000000] Preemptible RCU implementation.
> [    0.000000] NR_IRQS:2304 nr_irqs:424
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 2010.509 MHz processor.
> [    0.010000] spurious 8259A interrupt: IRQ7.
> [    0.010000] Console: colour VGA+ 80x25
> [    0.010000] console [tty0] enabled
> 
> config attached.

please check

[PATCH] x86: make zap_low_mapping could be used early

only one cpu is there, just call __flush_tlb for it

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/tlbflush.h |    2 +-
 arch/x86/kernel/smpboot.c       |    2 +-
 arch/x86/mm/init_32.c           |   10 +++++++---
 3 files changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/include/asm/tlbflush.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/tlbflush.h
+++ linux-2.6/arch/x86/include/asm/tlbflush.h
@@ -172,6 +172,6 @@ static inline void flush_tlb_kernel_rang
 	flush_tlb_all();
 }
 
-extern void zap_low_mappings(void);
+extern void zap_low_mappings(bool early);
 
 #endif /* _ASM_X86_TLBFLUSH_H */
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -875,7 +875,7 @@ int __cpuinit native_cpu_up(unsigned int
 
 	err = do_boot_cpu(apicid, cpu);
 
-	zap_low_mappings();
+	zap_low_mappings(false);
 	low_mappings = 0;
 #else
 	err = do_boot_cpu(apicid, cpu);
Index: linux-2.6/arch/x86/mm/init_32.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_32.c
+++ linux-2.6/arch/x86/mm/init_32.c
@@ -576,7 +576,7 @@ static inline void save_pg_dir(void)
 }
 #endif /* !CONFIG_ACPI_SLEEP */
 
-void zap_low_mappings(void)
+void zap_low_mappings(bool early)
 {
 	int i;
 
@@ -593,7 +593,11 @@ void zap_low_mappings(void)
 		set_pgd(swapper_pg_dir+i, __pgd(0));
 #endif
 	}
-	flush_tlb_all();
+
+	if (early)
+		__flush_tlb();
+	else
+		flush_tlb_all();
 }
 
 pteval_t __supported_pte_mask __read_mostly = ~(_PAGE_NX | _PAGE_GLOBAL | _PAGE_IOMAP);
@@ -968,7 +972,7 @@ void __init mem_init(void)
 		test_wp_bit();
 
 	save_pg_dir();
-	zap_low_mappings();
+	zap_low_mappings(true);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
