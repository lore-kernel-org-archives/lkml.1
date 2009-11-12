Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZKLRVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZKLRVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZKLRVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:21:39 -0500
Received: from relay1.sgi.com ([192.48.179.29]:45215 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753495AbZKLRVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:21:39 -0500
Message-Id: <20091112172126.739895000@alcatraz.americas.sgi.com>
References: <20091112171934.584037000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Nov 2009 11:19:41 -0600
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
Subject: [PATCH 7/7] x86: Limit number of per cpu TSC sync messages
Content-Disposition: inline; filename=limit_tsc_sync_messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the number of per cpu TSC sync messages when system is booting to
prevent clogging up the console output with repetitious messages.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/tsc_sync.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- linux.orig/arch/x86/kernel/tsc_sync.c
+++ linux/arch/x86/kernel/tsc_sync.c
@@ -118,9 +118,6 @@
 		return;
 	}
 
-	pr_info("checking TSC synchronization [CPU#%d -> CPU#%d]:",
-		smp_processor_id(), cpu);
-
 	/*
 	 * Reset it - in case this is a second bootup:
 	 */
@@ -142,12 +139,13 @@
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
+		pr_debug("TSC synchronization [CPU#%d -> CPU#%d]: passed\n");
 	}
 
 	/*

-- 
