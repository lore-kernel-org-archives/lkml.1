Return-Path: <linux-kernel-owner+w=401wt.eu-S1764910AbZLQU1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764910AbZLQU1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 15:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762723AbZLQU1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 15:27:07 -0500
Received: from mga14.intel.com ([143.182.124.37]:2749 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765133AbZLQU1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 15:27:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="224155614"
Date: Thu, 17 Dec 2009 12:27:02 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: Reenable TSC sync check at boot, even with NONSTOP_TSC
Message-ID: <20091217202702.GA18015@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 83ce4009 did the following change
If the TSC is constant and non-stop, also set it reliable.

But, there seems to be few systems that will end up with TSC warp across
sockets, depending on how the cpus come out of reset. Skipping TSC sync
test on such systems may result in time inconsistency later.

So, reenable TSC sync test even on constant and non-stop TSC systems.
Set, sched_clock_stable to 1 by default and reset it in
mark_tsc_unstable, if TSC sync fails.

This change still gives perf benefit mentioned in 83ce4009 for systems
where TSC is reliable.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/kernel/cpu/intel.c |    1 -
 arch/x86/kernel/tsc.c       |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 9c31e8b..879666f 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -70,7 +70,6 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
 		sched_clock_stable = 1;
 	}
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cd982f4..597683a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -763,6 +763,7 @@ void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
+		sched_clock_stable = 0;
 		printk(KERN_INFO "Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
-- 
1.6.0.6

