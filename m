Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974Ab0BYSgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:36:45 -0500
Received: from relay3.sgi.com ([192.48.152.1]:50476 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932838Ab0BYSgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:36:44 -0500
Date: Thu, 25 Feb 2010 12:36:43 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] Fix sched_clock_cpu for systems with unsynchronized TSC
Message-ID: <20100225183643.GA21302@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On UV systems, the TSC is not synchronized across blades.  The
sched_clock_cpu() function is returning values that can go backwards 
(I've seen as much as 8 seconds) when switching between cpus.

As each cpu comes up, early_init_intel() will currently set the
sched_clock_stable flag true.  When mark_tsc_unstable() runs, it clears
the flag, but this only occurs once (the first time a cpu comes up whose
TSC is not synchronized with cpu 0).  After this, early_init_intel() will
set the flag again as the next cpu comes up.

This patch changes the logic to assume that the sched_clock is stable at
first.  From then on it is only cleared.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 arch/x86/kernel/cpu/intel.c |    4 ++--
 kernel/sched_clock.c        |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/intel.c
+++ linux/arch/x86/kernel/cpu/intel.c
@@ -70,8 +70,8 @@ static void __cpuinit early_init_intel(s
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		sched_clock_stable = 1;
-	}
+	} else
+		sched_clock_stable = 0;
 
 	/*
 	 * There is a known erratum on Pentium III and Core Solo
Index: linux/kernel/sched_clock.c
===================================================================
--- linux.orig/kernel/sched_clock.c
+++ linux/kernel/sched_clock.c
@@ -45,7 +45,7 @@ unsigned long long __attribute__((weak))
 static __read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
-__read_mostly int sched_clock_stable;
+__read_mostly int sched_clock_stable = 1;
 
 struct sched_clock_data {
 	u64			tick_raw;
