Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYHYVQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYHYVQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYHYVQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:16:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbYHYVQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:16:05 -0400
Date: Mon, 25 Aug 2008 14:15:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B29F7B.6080405@hp.com> <48B2A421.7080705@hp.com>
 <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Aug 2008, Linus Torvalds wrote:
> 
> checkstack.pl shows these things as the top problems:
> 
> 	0xffffffff80266234 smp_call_function_mask [vmlinux]:    2736
> 	0xffffffff80234747 __build_sched_domains [vmlinux]:     2232
> 	0xffffffff8023523f __build_sched_domains [vmlinux]:     2232
> 
> Anyway, the reason smp_call_function_mask and friends have such _huge_ 
> stack usages for you is that they contain a 'cpumask_t' on the stack.

In fact, they contain multiple CPU-masks, each 4k-bits - 512 bytes - in 
size. And they tend to call each other.

Quite frankly, I don't think we were really ready for 4k CPU's. I'm going 
to commit this patch to make sure others don't do that many CPU's by 
mistake. It marks MAXCPU's as being 'broken' so you cannot select it, and 
also limits the number of CPU's that you _can_ select to "just" 512.

Right now, 4k cpu's is known broken because of the stack usage. I'm not 
willing to debug more of these kinds of stack smashers, they're really 
nasty to work with. I wonder how many other random failures these have 
been involved with?

This patch also makes the ifdef mess in Kconfig much cleaner and avoids 
duplicate definitions by just conditionally suppressing the question and 
giving higher defaults. 

We can enable MAXSMP and raise the CPU limits some time in the future. But 
that future is not going to be before 2.6.27 - the code simply isn't ready 
for it.

The reason I picked 512 CPU's as the limit is that we _used_ to limit 
things to 255. So it's higher than it used to be, but low enough to still 
feel safe. Considering that a 4k-bit CPU mask (512 bytes) _almost_ worked, 
the 512-bit (64 bytes) masks are almost certainly fine.

Still, sane people should limit their NR_CPUS to 8 or 16 or something like 
that. Very very few people really need the pain of big NR_CPUS. Not even 
"just" 512 CPU's.

Travis, Ingo and Thomas cc'd, since they were involved in the original 
commit (1184dc2ffe2c8fb9afb766d870850f2c3165ef25) that raised the limit.

		Linus

---
 arch/x86/Kconfig |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 68d91c8..ed92864 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -577,35 +577,29 @@ config SWIOTLB
 
 config IOMMU_HELPER
 	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU)
+
 config MAXSMP
 	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
-	depends on X86_64 && SMP
+	depends on X86_64 && SMP && BROKEN
 	default n
 	help
 	  Configure maximum number of CPUS and NUMA Nodes for this architecture.
 	  If unsure, say N.
 
-if MAXSMP
-config NR_CPUS
-	int
-	default "4096"
-endif
-
-if !MAXSMP
 config NR_CPUS
-	int "Maximum number of CPUs (2-4096)"
-	range 2 4096
+	int "Maximum number of CPUs (2-512)" if !MAXSMP
+	range 2 512
 	depends on SMP
+	default "4096" if MAXSMP
 	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
 	default "8"
 	help
 	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support.  The maximum supported value is 4096 and the
+	  kernel will support.  The maximum supported value is 512 and the
 	  minimum value which makes sense is 2.
 
 	  This is purely to save memory - each supported CPU adds
 	  approximately eight kilobytes to the kernel image.
-endif
 
 config SCHED_SMT
 	bool "SMT (Hyperthreading) scheduler support"
@@ -996,17 +990,10 @@ config NUMA_EMU
 	  into virtual nodes when booted with "numa=fake=N", where N is the
 	  number of nodes. This is only useful for debugging.
 
-if MAXSMP
-
 config NODES_SHIFT
-	int
-	default "9"
-endif
-
-if !MAXSMP
-config NODES_SHIFT
-	int "Maximum NUMA Nodes (as a power of 2)"
+	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
 	range 1 9   if X86_64
+	default "9" if MAXSMP
 	default "6" if X86_64
 	default "4" if X86_NUMAQ
 	default "3"
@@ -1014,7 +1001,6 @@ config NODES_SHIFT
 	help
 	  Specify the maximum number of NUMA Nodes available on the target
 	  system.  Increases memory reserved to accomodate various tables.
-endif
 
 config HAVE_ARCH_BOOTMEM_NODE
 	def_bool y
