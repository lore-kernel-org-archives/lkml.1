Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbXEQRp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbXEQRp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbXEQRpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:45:16 -0400
Received: from h155.mvista.com ([63.81.120.155]:24913 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756524AbXEQRpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:45:15 -0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: tglx@linutronix.de, mingo@elte.hu
Subject: [PATCH 2.6.21-rt2] PowerPC: enable HRT and dynticks support
Date: Thu, 17 May 2007 21:46:46 +0400
User-Agent: KMail/1.5
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200705172146.46769.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Enable HRT and dynamic ticks support for PowerPC.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
This patch has been reworked against the 2.6.21 clockevents framework.
It has only been tested on the Book E 32-bit CPU this time, so re-testing on
"classic" PowerPC CPUs is needed (there have been issues as of 2.6.18-rt7 but
those should now be fixed)...

 arch/powerpc/Kconfig       |    1 +
 arch/powerpc/kernel/idle.c |    3 +++
 2 files changed, 4 insertions(+)

Index: linux-2.6/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig
+++ linux-2.6/arch/powerpc/Kconfig
@@ -770,6 +770,7 @@ config GENERIC_CLOCKEVENTS
 	  NOTE: This is not compatible with the deterministic time accounting
 	  option on PPC64.
 
+source kernel/time/Kconfig
 source kernel/Kconfig.preempt
 
 config RWSEM_GENERIC_SPINLOCK
Index: linux-2.6/arch/powerpc/kernel/idle.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/idle.c
+++ linux-2.6/arch/powerpc/kernel/idle.c
@@ -24,6 +24,7 @@
 #include <linux/smp.h>
 #include <linux/cpu.h>
 #include <linux/sysctl.h>
+#include <linux/tick.h>
 
 #include <asm/system.h>
 #include <asm/processor.h>
@@ -56,6 +57,7 @@ void cpu_idle(void)
 
 	set_thread_flag(TIF_POLLING_NRFLAG);
 	while (1) {
+		tick_nohz_stop_sched_tick();
 		while (!need_resched() && !need_resched_delayed() &&
 				!cpu_should_die()) {
 			ppc64_runlatch_off();
@@ -92,6 +94,7 @@ void cpu_idle(void)
 		ppc64_runlatch_on();
 		if (cpu_should_die())
 			cpu_die();
+		tick_nohz_restart_sched_tick();
 		__preempt_enable_no_resched();
 		schedule();
 		preempt_disable();

