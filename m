Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab0CARsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:48:18 -0500
Received: from relay3.sgi.com ([192.48.152.1]:37285 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750976Ab0CARsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:48:17 -0500
Date: Mon, 1 Mar 2010 11:48:15 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, venkatesh.pallipadi@intel.com,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] x86: Fix sched_clock_cpu for systems with
	unsynchronized TSC
Message-ID: <20100301174815.GC8224@sgi.com>
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

Only set sched_clock_stable if tsc has not been marked unstable.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

Only affects x86 arch.

 arch/x86/kernel/cpu/intel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/intel.c
+++ linux/arch/x86/kernel/cpu/intel.c
@@ -70,7 +70,8 @@ static void __cpuinit early_init_intel(s
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		sched_clock_stable = 1;
+		if (!check_tsc_unstable())
+			sched_clock_stable = 1;
 	}
 
 	/*
