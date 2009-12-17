Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbZLQX6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbZLQX6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZLQX6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:58:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:52540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbZLQX6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:58:12 -0500
Date: Thu, 17 Dec 2009 23:57:38 GMT
From: "tip-bot for Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de
In-Reply-To: <20091217202702.GA18015@linux-os.sc.intel.com>
References: <20091217202702.GA18015@linux-os.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Reenable TSC sync check at boot, even with NONSTOP_TSC
Message-ID: <tip-6c56ccecf05fafe100ab4ea94f6fccbf5ff00db7@git.kernel.org>
Git-Commit-ID: 6c56ccecf05fafe100ab4ea94f6fccbf5ff00db7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c56ccecf05fafe100ab4ea94f6fccbf5ff00db7
Gitweb:     http://git.kernel.org/tip/6c56ccecf05fafe100ab4ea94f6fccbf5ff00db7
Author:     Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
AuthorDate: Thu, 17 Dec 2009 12:27:02 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 17 Dec 2009 14:44:35 -0800

x86: Reenable TSC sync check at boot, even with NONSTOP_TSC

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
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20091217202702.GA18015@linux-os.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
