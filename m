Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZKQTSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZKQTSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 14:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbZKQTSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 14:18:03 -0500
Received: from relay3.sgi.com ([192.48.152.1]:46646 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756211AbZKQTR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 14:17:59 -0500
Message-Id: <20091117191802.926927000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 17 Nov 2009 13:17:57 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86: Limit number of per cpu TSC sync messages
References: <20091117191752.164451000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=limit_tsc_sync_messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the number of per cpu TSC sync messages by only printing
to the console if an error occurs, otherwise print as a DEBUG
message.

The info message "Skipping synchronization ..." is only printed
after the last cpu has booted.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/tsc_sync.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- linux.orig/arch/x86/kernel/tsc_sync.c
+++ linux/arch/x86/kernel/tsc_sync.c
@@ -114,13 +114,12 @@
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
@@ -142,12 +141,14 @@
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

