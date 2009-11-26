Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbZKZJ4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbZKZJ4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZKZJ4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:56:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:59949 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbZKZJ4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:56:16 -0500
Date: Thu, 26 Nov 2009 09:55:16 GMT
From: tip-bot for Mike Travis <travis@sgi.com>
Cc: mingo@redhat.com, rusty@rustcorp.com.au, fweisbec@gmail.com,
       yhlu.kernel@gmail.com, rostedt@goodmis.org, gregkh@suse.de,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, rientjes@google.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, andi@firstfloor.org,
       travis@sgi.com, seto.hidetoshi@jp.fujitsu.com, rdunlap@xenotime.net,
       rdreier@cisco.com, steiner@sgi.com, tj@kernel.org, mingo@elte.hu
Reply-To: mingo@redhat.com, rusty@rustcorp.com.au, fweisbec@gmail.com,
       yhlu.kernel@gmail.com, rostedt@goodmis.org, gregkh@suse.de,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, rientjes@google.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, andi@firstfloor.org,
       travis@sgi.com, seto.hidetoshi@jp.fujitsu.com, rdunlap@xenotime.net,
       steiner@sgi.com, rdreier@cisco.com, tj@kernel.org, mingo@elte.hu
In-Reply-To: <20091118002222.181053000@alcatraz.americas.sgi.com>
References: <20091118002222.181053000@alcatraz.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Limit number of per cpu TSC sync messages
Message-ID: <tip-9b3660a55a9052518c91cc7c62d89e22f3f6f490@git.kernel.org>
Git-Commit-ID: 9b3660a55a9052518c91cc7c62d89e22f3f6f490
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b3660a55a9052518c91cc7c62d89e22f3f6f490
Gitweb:     http://git.kernel.org/tip/9b3660a55a9052518c91cc7c62d89e22f3f6f490
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Tue, 17 Nov 2009 18:22:16 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Nov 2009 10:17:45 +0100

x86: Limit number of per cpu TSC sync messages

Limit the number of per cpu TSC sync messages by only printing
to the console if an error occurs, otherwise print as a DEBUG
message.

The info message "Skipping synchronization ..." is only printed
after the last cpu has booted.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091118002222.181053000@alcatraz.americas.sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/tsc_sync.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index f379309..eed1568 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -114,13 +114,12 @@ void __cpuinit check_tsc_sync_source(int cpu)
 		return;
 
 	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
-		printk_once(KERN_INFO "Skipping synchronization checks as TSC is reliable.\n");
+		if (cpu == (nr_cpu_ids-1) || system_state != SYSTEM_BOOTING)
+			pr_info(
+			"Skipped synchronization checks as TSC is reliable.\n");
 		return;
 	}
 
-	pr_info("checking TSC synchronization [CPU#%d -> CPU#%d]:",
-		smp_processor_id(), cpu);
-
 	/*
 	 * Reset it - in case this is a second bootup:
 	 */
@@ -142,12 +141,14 @@ void __cpuinit check_tsc_sync_source(int cpu)
 		cpu_relax();
 
 	if (nr_warps) {
-		printk("\n");
+		pr_warning("TSC synchronization [CPU#%d -> CPU#%d]:\n",
+			smp_processor_id(), cpu);
 		pr_warning("Measured %Ld cycles TSC warp between CPUs, "
 			   "turning off TSC clock.\n", max_warp);
 		mark_tsc_unstable("check_tsc_sync_source failed");
 	} else {
-		printk(" passed.\n");
+		pr_debug("TSC synchronization [CPU#%d -> CPU#%d]: passed\n",
+			smp_processor_id(), cpu);
 	}
 
 	/*
