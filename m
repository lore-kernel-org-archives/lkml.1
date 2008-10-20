Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbYJTRSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbYJTRSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbYJTREm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:04:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33596 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753886AbYJTRDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:03:25 -0400
Message-Id: <20081020170321.119844000@polaris-admin.engr.sgi.com>
References: <20081020170319.539427000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Oct 2008 10:03:30 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       peterz@infradead.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, IA64 <linux-ia64@vger.kernel.org>,
       PowerPC <linuxppc-dev@ozlabs.org>, S390 <linux-s390@vger.kernel.org>,
       SPARC <sparclinux@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/35] x86: enable MAXSMP
Content-Disposition: inline; filename=x86:enable-MAXSMP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set MAXSMP to enable a configuration with the maximum amount of CPUS and
NODES.  Also enables CONFIG_CPUMASK_OFFSTACK which moves cpumask's off
the stack (and in structs) when using cpumask_var_t.

From: Mike Travis <travis@sgi.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/Kconfig |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- test-compile.orig/arch/x86/Kconfig
+++ test-compile/arch/x86/Kconfig
@@ -571,12 +571,20 @@ config IOMMU_HELPER
 
 config MAXSMP
 	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
-	depends on X86_64 && SMP && BROKEN
+ 	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
+	select CPUMASK_OFFSTACK
 	default n
 	help
 	  Configure maximum number of CPUS and NUMA Nodes for this architecture.
 	  If unsure, say N.
 
+if MAXSMP
+config NR_CPUS
+	int
+	default "4096"
+endif
+
+if !MAXSMP
 config NR_CPUS
 	int "Maximum number of CPUs (2-512)" if !MAXSMP
 	range 2 512
@@ -591,6 +599,14 @@ config NR_CPUS
 
 	  This is purely to save memory - each supported CPU adds
 	  approximately eight kilobytes to the kernel image.
+endif
+
+config CPUMASK_OFFSTACK
+	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
+	help
+	  Use dynamic allocation for cpumask_var_t, instead of putting
+	  them on the stack.  This is a bit more expensive, but avoids
+	  stack overflow.
 
 config SCHED_SMT
 	bool "SMT (Hyperthreading) scheduler support"
@@ -1027,10 +1043,16 @@ config NUMA_EMU
 	  into virtual nodes when booted with "numa=fake=N", where N is the
 	  number of nodes. This is only useful for debugging.
 
+if MAXSMP
+config NODES_SHIFT
+	int
+	default "9"
+endif
+
+if !MAXSMP
 config NODES_SHIFT
-	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
+	int "Maximum NUMA Nodes (as a power of 2)"
 	range 1 9   if X86_64
-	default "9" if MAXSMP
 	default "6" if X86_64
 	default "4" if X86_NUMAQ
 	default "3"
@@ -1038,6 +1060,7 @@ config NODES_SHIFT
 	help
 	  Specify the maximum number of NUMA Nodes available on the target
 	  system.  Increases memory reserved to accomodate various tables.
+endif
 
 config HAVE_ARCH_BOOTMEM_NODE
 	def_bool y

-- 
