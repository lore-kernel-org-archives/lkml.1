Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164Ab0AZXpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab0AZXpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117Ab0AZXph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:45:37 -0500
Received: from kroah.org ([198.145.64.141]:35561 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab0AZXo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:29 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:33 2010
Message-Id: <20100126233933.580324571@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:35:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [96/98] x86: Reenable TSC sync check at boot, even with NONSTOP_TSC
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>

commit 6c56ccecf05fafe100ab4ea94f6fccbf5ff00db7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/intel.c |    1 -
 arch/x86/kernel/tsc.c       |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -70,7 +70,6 @@ static void __cpuinit early_init_intel(s
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
 		sched_clock_stable = 1;
 	}
 
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


