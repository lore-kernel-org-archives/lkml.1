Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbXEOCU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbXEOCU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 22:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXEOCUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 22:20:21 -0400
Received: from koto.vergenet.net ([210.128.90.7]:56283 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbXEOCUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 22:20:21 -0400
To: linux-kernel@vger.kernel.org
Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
From: Simon Horman <horms@verge.net.au>
Subject: [ARM] Fix hard_smp_processor_id compile error
Date: Tue, 15 May 2007 11:18:50 +0900
Message-Id: <20070515022014.CC2A44F910@tabatha.lab.ultramonkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Remove hardcoding of hard_smp_processor_id on UP systems",
2f4dfe206a2fc07099dfad77a8ea2f4b4ae2140f in Linus' tree, moved
the definition of hard_smp_processor_id linux/smp.h to asm/smp.h
for UP systems. This causes a regression on ARM as the definition
was not added to asm-arm/smp.h.

Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Simon Horman <horms@verge.net.au>

--- 
 arch/arm/mach-integrator/core.c |    1 +
 include/asm-arm/smp.h           |   10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

arm-unknown-linux-gnu-gcc (GCC) 4.1.1
Copyright (C) 2006 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  CC      arch/arm/mach-integrator/core.o
arch/arm/mach-integrator/core.c: In function 'integrator_timer_interrupt':
arch/arm/mach-integrator/core.c:264: warning: implicit declaration of function 'hard_smp_processor_id'
[snip]
  LD      .tmp_vmlinux1
arch/arm/mach-integrator/built-in.o: In function `integrator_timer_interrupt':
cpu.c:(.text+0x398): undefined reference to `hard_smp_processor_id'
make: *** [.tmp_vmlinux1] error 1

This was produced by running the following in a crosstool cross-compiling
environment:
 cp arch/arm/configs/integrator_defconfig .config
 yes "" | make modconfig
 make

Index: linux-2.6/arch/arm/mach-integrator/core.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-integrator/core.c	2007-05-15 10:56:06.000000000 +0900
+++ linux-2.6/arch/arm/mach-integrator/core.c	2007-05-15 10:56:16.000000000 +0900
@@ -28,6 +28,7 @@
 #include <asm/system.h>
 #include <asm/leds.h>
 #include <asm/mach/time.h>
+#include <asm/smp.h>
 
 #include "common.h"
 
Index: linux-2.6/include/asm-arm/smp.h
===================================================================
--- linux-2.6.orig/include/asm-arm/smp.h	2007-05-15 10:51:54.000000000 +0900
+++ linux-2.6/include/asm-arm/smp.h	2007-05-15 10:56:34.000000000 +0900
@@ -10,16 +10,16 @@
 #ifndef __ASM_ARM_SMP_H
 #define __ASM_ARM_SMP_H
 
+#ifndef CONFIG_SMP
+#define hard_smp_processor_id()		0
+#else
+
 #include <linux/threads.h>
 #include <linux/cpumask.h>
 #include <linux/thread_info.h>
 
 #include <asm/arch/smp.h>
 
-#ifndef CONFIG_SMP
-# error "<asm-arm/smp.h> included in non-SMP build"
-#endif
-
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
 /*
@@ -134,4 +134,6 @@ extern void show_local_irqs(struct seq_f
  */
 asmlinkage void do_local_timer(struct pt_regs *);
 
+#endif /* CONFIG_SMP */
+
 #endif /* ifndef __ASM_ARM_SMP_H */
