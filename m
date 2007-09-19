Return-Path: <linux-kernel-owner+w=401wt.eu-S1762301AbXISRD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762301AbXISRD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760351AbXISRDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:03:07 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53151 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbXISRDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:03:05 -0400
Date: Wed, 19 Sep 2007 13:02:24 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 5/11] UML - GENERIC_TIME support
Message-ID: <20070919170224.GA10181@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enable CONFIG_GENERIC_TIME.

As a side-effect of this, the UML implementations of do_gettimeofday
and do_settimeofday go away, as these are provided by generic code.
set_time also goes away since it was only used by do_settimeofday.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Kconfig        |    5 +++++
 arch/um/kernel/ksyms.c |    3 ---
 arch/um/kernel/time.c  |   40 ----------------------------------------
 3 files changed, 5 insertions(+), 43 deletions(-)

Index: linux-2.6.20/arch/um/Kconfig
===================================================================
--- linux-2.6.20.orig/arch/um/Kconfig	2007-09-19 12:24:52.000000000 -0400
+++ linux-2.6.20/arch/um/Kconfig	2007-09-19 12:25:06.000000000 -0400
@@ -55,6 +55,10 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
+config GENERIC_TIME
+	bool
+	default y
+
 # Used in kernel/irq/manage.c and include/linux/irq.h
 config IRQ_RELEASE_METHOD
 	bool
@@ -75,6 +79,7 @@ config STATIC_LINK
 
 source "arch/um/Kconfig.arch"
 source "mm/Kconfig"
+source "kernel/time/Kconfig"
 
 config LD_SCRIPT_STATIC
 	bool
Index: linux-2.6.20/arch/um/kernel/ksyms.c
===================================================================
--- linux-2.6.20.orig/arch/um/kernel/ksyms.c	2007-09-19 12:24:52.000000000 -0400
+++ linux-2.6.20/arch/um/kernel/ksyms.c	2007-09-19 12:25:06.000000000 -0400
@@ -67,9 +67,6 @@ EXPORT_SYMBOL(run_helper);
 EXPORT_SYMBOL(start_thread);
 EXPORT_SYMBOL(dump_thread);
 
-EXPORT_SYMBOL(do_gettimeofday);
-EXPORT_SYMBOL(do_settimeofday);
-
 #ifdef CONFIG_SMP
 
 /* required for SMP */
Index: linux-2.6.20/arch/um/kernel/time.c
===================================================================
--- linux-2.6.20.orig/arch/um/kernel/time.c	2007-09-19 12:25:06.000000000 -0400
+++ linux-2.6.20/arch/um/kernel/time.c	2007-09-19 12:25:06.000000000 -0400
@@ -123,46 +123,6 @@ void time_init(void)
 	late_time_init = register_timer;
 }
 
-void do_gettimeofday(struct timeval *tv)
-{
-#ifdef CONFIG_UML_REAL_TIME_CLOCK
-	unsigned long long nsecs = get_time();
-#else
-	unsigned long long nsecs = (unsigned long long) xtime.tv_sec * BILLION +
-		xtime.tv_nsec;
-#endif
-	tv->tv_sec = nsecs / NSEC_PER_SEC;
-	/*
-	 * Careful about calculations here - this was originally done as
-	 * (nsecs - tv->tv_sec * NSEC_PER_SEC) / NSEC_PER_USEC
-	 * which gave bogus (> 1000000) values.  Dunno why, suspect gcc
-	 * (4.0.0) miscompiled it, or there's a subtle 64/32-bit conversion
-	 * problem that I missed.
-	 */
-	nsecs -= tv->tv_sec * NSEC_PER_SEC;
-	tv->tv_usec = (unsigned long) nsecs / NSEC_PER_USEC;
-}
-
-static inline void set_time(unsigned long long nsecs)
-{
-	unsigned long long now;
-	unsigned long flags;
-
-	spin_lock_irqsave(&timer_spinlock, flags);
-	now = os_nsecs();
-	local_offset = nsecs - now;
-	spin_unlock_irqrestore(&timer_spinlock, flags);
-
-	clock_was_set();
-}
-
-int do_settimeofday(struct timespec *tv)
-{
-	set_time((unsigned long long) tv->tv_sec * NSEC_PER_SEC + tv->tv_nsec);
-
-	return 0;
-}
-
 void timer_handler(int sig, struct uml_pt_regs *regs)
 {
 	if (current_thread->cpu == 0)
