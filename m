Return-Path: <linux-kernel-owner+w=401wt.eu-S1761135AbYGPA1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761135AbYGPA1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758408AbYGPAZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:25:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:8513 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860AbYGPAZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=fqDiMj75VTSlBadZ2+6eqZRVS651boOjRSDAsR+tXDtgja57LLbxkU5bk5x4/O5BaO
         ZU1JMTdV21fVJBILUp8gPhCP71exF7hcTjf+ndwV1WD8UTiIRU92Fzbjj2xHJm9K7fCY
         AEGYSlux5+gNfBPDPA9CgHCa4+Y6bzWG8O5e0=
Date: Wed, 16 Jul 2008 02:25:00 +0200
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] kmemcheck: enable in the x86 Kconfig
Message-ID: <20080716002500.GN12564@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 443d8b28cb141b3fe8bbe6dd1daa0ef41bc21d80 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 4 Apr 2008 00:51:41 +0200
Subject: [PATCH 13/13] kmemcheck: enable in the x86 Kconfig

let it rip!

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
---
 arch/x86/Kconfig.debug |  109 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 1836337..552cf57 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -246,6 +246,115 @@ config DEFAULT_IO_DELAY_TYPE
 	default IO_DELAY_TYPE_NONE
 endif
 
+menuconfig KMEMCHECK
+	bool "kmemcheck: trap use of uninitialized memory"
+	depends on X86
+	depends on !X86_USE_3DNOW
+	depends on SLUB || (SLAB && !DEBUG_SLAB)
+	depends on !CC_OPTIMIZE_FOR_SIZE
+	depends on !DEBUG_PAGEALLOC
+	select FRAME_POINTER
+	select STACKTRACE
+	default n
+	help
+	  This option enables tracing of dynamically allocated kernel memory
+	  to see if memory is used before it has been given an initial value.
+	  Be aware that this requires half of your memory for bookkeeping and
+	  will insert extra code at *every* read and write to tracked memory
+	  thus slow down the kernel code (but user code is unaffected).
+
+	  The kernel may be started with kmemcheck=0 or kmemcheck=1 to disable
+	  or enable kmemcheck at boot-time. If the kernel is started with
+	  kmemcheck=0, the large memory and CPU overhead is not incurred.
+
+choice
+	prompt "kmemcheck: default mode at boot"
+	depends on KMEMCHECK
+	default KMEMCHECK_ONESHOT_BY_DEFAULT
+	help
+	  This option controls the default behaviour of kmemcheck when the
+	  kernel boots and no kmemcheck= parameter is given.
+
+config KMEMCHECK_DISABLED_BY_DEFAULT
+	bool "disabled"
+	depends on KMEMCHECK
+
+config KMEMCHECK_ENABLED_BY_DEFAULT
+	bool "enabled"
+	depends on KMEMCHECK
+
+config KMEMCHECK_ONESHOT_BY_DEFAULT
+	bool "one-shot"
+	depends on KMEMCHECK
+	help
+	  In one-shot mode, only the first error detected is reported before
+	  kmemcheck is disabled.
+
+endchoice
+
+config KMEMCHECK_USE_SMP
+	bool "kmemcheck: use multiple CPUs"
+	depends on KMEMCHECK
+	depends on SMP
+	depends on BROKEN
+	default n
+	help
+	  This option will prevent kmemcheck from disabling all but one CPU
+	  on boot. This means that whenever a page fault is taken, all the
+	  other CPUs in the system are halted. This is potentially extremely
+	  expensive, depending on the number of CPUs in the system (the more
+	  the worse).
+
+	  The upside is that kmemcheck can be compiled into the kernel with
+	  very little overhead by default if kmemcheck is disabled at run-
+	  time.
+
+	  If you want to compile a kernel specifically for the purpose of
+	  playing with kmemcheck, you should say N here. If you want a normal
+	  kernel with the possibility of enabling kmemcheck without
+	  recompiling, you should say Y here.
+
+config KMEMCHECK_QUEUE_SIZE
+	int "kmemcheck: error queue size"
+	depends on KMEMCHECK
+	default 64
+	help
+	  Select the maximum number of errors to store in the queue. This
+	  queue will be emptied once every second, so this is effectively a
+	  limit on how many reports to print in one go. Note however, that
+	  if the number of errors occuring between two bursts is larger than
+	  this number, the extra error reports will get lost.
+
+config KMEMCHECK_SHADOW_COPY_SHIFT
+	int "kmemcheck: shadow copy size (5 => 32 bytes, 6 => 64 bytes)"
+	depends on KMEMCHECK
+	range 2 8
+	default 6
+	help
+	  Select the number of shadow bytes to save along with each entry of
+	  the queue. These bytes indicate what parts of an allocation are
+	  initialized, uninitialized, etc. and will be displayed when an
+	  error is detected to help the debugging of a particular problem.
+
+config KMEMCHECK_PARTIAL_OK
+	bool "kmemcheck: allow partially uninitialized memory"
+	depends on KMEMCHECK
+	default y
+	help
+	  This option works around certain GCC optimizations that produce
+	  32-bit reads from 16-bit variables where the upper 16 bits are
+	  thrown away afterwards. This may of course also hide some real
+	  bugs.
+
+config KMEMCHECK_BITOPS_OK
+	bool "kmemcheck: allow bit-field manipulation"
+	depends on KMEMCHECK
+	default n
+	help
+	  This option silences warnings that would be generated for bit-field
+	  accesses where not all the bits are initialized at the same time.
+	  This may also hide some real bugs.
+
 config DEBUG_BOOT_PARAMS
 	bool "Debug boot parameters"
 	depends on DEBUG_KERNEL
-- 
1.5.5.1

