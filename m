Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYDEBax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYDEBax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYDEBaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:30:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57202 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751792AbYDEBaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:30:15 -0400
Message-Id: <20080405013014.843047000@polaris-admin.engr.sgi.com>
References: <20080405013014.478571000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:30:16 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: Modify Kconfig to allow up to 4096 cpus
Content-Disposition: inline; filename=Kconfig
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Increase the limit of NR_CPUS to 4096 and introduce a boolean
    called "MAXSMP" which when set (e.g. "allyesconfig"), will set
    NR_CPUS = 4096 and NODES_SHIFT = 9 (512).
    
  * Changed max setting for NODES_SHIFT from 15 to 9 to accurately
    reflect the real limit.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig |   37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

--- linux-2.6.x86.sched.orig/arch/x86/Kconfig
+++ linux-2.6.x86.sched/arch/x86/Kconfig
@@ -526,20 +526,35 @@ config SWIOTLB
 	  access 32-bits of memory can be used on systems with more than
 	  3 GB of memory. If unsure, say Y.
 
+config MAXSMP
+	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
+	depends on X86_64 && SMP
+	default n
+	help
+	  Configure maximum number of CPUS and NUMA Nodes for this architecture.
+	  If unsure, say N.
+
+if MAXSMP
+config NR_CPUS
+	int
+	default "4096"
+endif
 
+if !MAXSMP
 config NR_CPUS
-	int "Maximum number of CPUs (2-255)"
-	range 2 255
+	int "Maximum number of CPUs (2-4096)"
+	range 2 4096
 	depends on SMP
 	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
 	default "8"
 	help
 	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support.  The maximum supported value is 255 and the
+	  kernel will support.  The maximum supported value is 4096 and the
 	  minimum value which makes sense is 2.
 
 	  This is purely to save memory - each supported CPU adds
 	  approximately eight kilobytes to the kernel image.
+endif
 
 config SCHED_SMT
 	bool "SMT (Hyperthreading) scheduler support"
@@ -921,13 +936,25 @@ config NUMA_EMU
 	  into virtual nodes when booted with "numa=fake=N", where N is the
 	  number of nodes. This is only useful for debugging.
 
+if MAXSMP
+
 config NODES_SHIFT
-	int "Max num nodes shift(1-15)"
-	range 1 15  if X86_64
+	int
+	default "9"
+endif
+
+if !MAXSMP
+config NODES_SHIFT
+	int "Maximum NUMA Nodes (as a power of 2)"
+	range 1 9   if X86_64
 	default "6" if X86_64
 	default "4" if X86_NUMAQ
 	default "3"
 	depends on NEED_MULTIPLE_NODES
+	help
+	  Specify the maximum number of NUMA Nodes available on the target
+	  system.  Increases memory reserved to accomodate various tables.
+endif
 
 config HAVE_ARCH_BOOTMEM_NODE
 	def_bool y

-- 
