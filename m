Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbXGTDoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbXGTDoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbXGTDoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:44:38 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:49420 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbXGTDoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:44:37 -0400
Subject: Re: v2.6.22.1-rt3
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1184325752.12353.312.camel@chaos>
References: <1184325752.12353.312.camel@chaos>
Content-Type: text/plain
Date: Thu, 19 Jul 2007 20:37:05 -0700
Message-Id: <1184902625.25414.8.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I reworked the broken out series for 2.6.22.1-rt5 (note not -rt3) so
that it's a little more bisectable. I found that many of the patches
would compile but wouldn't boot. 

Combined patch,
ftp://source.mvista.com/pub/dwalker/rt/patch-2.6.22.1-rt4-dw1


The broken out series is here,
ftp://source.mvista.com/pub/dwalker/rt/patch-2.6.22.1-rt4-dw1.tar.gz

Below is a diff between the 2.6.22.1-rt4 series and mine, and a
interdiff between the two combined patches.

--- patches-2.6.22.1-rt4/series	2007-07-16 02:29:51.000000000 -0700
+++ patches/series	2007-07-19 20:40:00.000000000 -0700
@@ -306,18 +306,21 @@
 #
 # IRQ threading
 #
+preempt-softirqs-core.patch
 preempt-irqs-core.patch
+preempt-irqs-softirq-in-hardirq.patch
+preempt-irqs-direct-debug-keyboard.patch
 preempt-irqs-timer.patch
 preempt-irqs-hrtimer.patch
 
 preempt-irqs-i386.patch
+preempt-irqs-i386-ioapic-mask-quirk.patch
 
 preempt-irqs-mips.patch
 
 preempt-irqs-x86-64.patch
 preempt-irqs-x86-64-ioapic-mask-quirk.patch
 
-preempt-irqs-i386-ioapic-mask-quirk.patch
 preempt-irqs-arm.patch
 preempt-irqs-arm-fix-oprofile.patch
 
@@ -352,7 +355,7 @@
 rt-mutex-mips.patch
 
 rt-mutex-ppc.patch
-rt-mtex-ppc-fix-a5.patch
+rt-mutex-ppc-fix-a5.patch
 
 rt-mutex-x86-64.patch
 
@@ -402,6 +405,7 @@
 #
 # Posix-cpu-timers in a thread
 #
+preempt-realtime-warn-and-bug-on.patch
 cputimer-thread-rt_A0.patch
 cputimer-thread-rt-fix.patch
 posix-cpu-timers-fix.patch
@@ -501,7 +505,6 @@
 preempt-realtime-timer.patch
 preempt-realtime-usb.patch
 
-preempt-realtime-warn-and-bug-on.patch
 preempt-realtime-warn-and-bug-on-fix.patch
 
 #
@@ -611,7 +614,6 @@
 # Softirq modifications
 #
 new-softirq-code.patch
-new-softirq-code-fixlets.patch
 softirq-per-cpu-assumptions-fixes.patch
 smp-processor-id-fixups.patch
 fix-migrating-softirq.patch
@@ -659,13 +661,9 @@
 #
 # not yet backmerged tail patches:
 #
-hrt-rt-fix-merge-artifact.patch
 preempt-rt-no-slub.patch
 rfkill-input-fix.patch
-fork.c-takeover-tasklets-warning-fix.patch
 
 paravirt-function-pointer-fix.patch
-hpet-build-fix.patch
-rtc.c-build-fix.patch
 version.patch
 

diff -u linux/arch/i386/kernel/hpet.c linux-2.6.22.1/arch/i386/kernel/hpet.c
--- linux/arch/i386/kernel/hpet.c
+++ linux-2.6.22.1/arch/i386/kernel/hpet.c	2007-07-20 02:22:56.000000000 +0000
@@ -9,7 +9,6 @@
 #include <linux/pm.h>
 
 #include <asm/fixmap.h>
-#include <asm/i8253.h>
 #include <asm/hpet.h>
 #include <asm/i8253.h>
 #include <asm/io.h>
diff -u linux/include/asm-generic/bug.h linux-2.6.22.1/include/asm-generic/bug.h
--- linux/include/asm-generic/bug.h
+++ linux-2.6.22.1/include/asm-generic/bug.h	2007-07-20 03:15:15.000000000 +0000
@@ -94,14 +94,2 @@
 
-#ifdef CONFIG_PREEMPT_RT
-# define BUG_ON_RT(c)			BUG_ON(c)
-# define BUG_ON_NONRT(c)		do { } while (0)
-# define WARN_ON_RT(condition)		WARN_ON(condition)
-# define WARN_ON_NONRT(condition)	do { } while (0)
-#else
-# define BUG_ON_RT(c)			do { } while (0)
-# define BUG_ON_NONRT(c)		BUG_ON(c)
-# define WARN_ON_RT(condition)		do { } while (0)
-# define WARN_ON_NONRT(condition)	WARN_ON(condition)
-#endif
-
 #endif
diff -u linux/kernel/softirq.c linux-2.6.22.1/kernel/softirq.c
--- linux/kernel/softirq.c
+++ linux-2.6.22.1/kernel/softirq.c	2007-07-20 03:15:17.000000000 +0000
@@ -102,7 +102,6 @@
 
 	if (unlikely(!tsk))
 		return;
-#if 1
 #if defined(CONFIG_PREEMPT_SOFTIRQS) && defined(CONFIG_PREEMPT_HARDIRQS)
 	/*
 	 * Optimization: if we are in a hardirq thread context, and
@@ -117,7 +116,6 @@
 			(tsk->normal_prio == current->normal_prio))
 		return;
 #endif
-#endif
 	/*
 	 * Wake up the softirq task:
 	 */


