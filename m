Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZFOHhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZFOHhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZFOHhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:37:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:59148 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbZFOHhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:37:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,220,1243839600"; 
   d="scan'208";a="154340084"
Subject: [PATCH] x86: MCE: Fix a race condition about mce_callin and
 no_way_out
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 15:37:07 +0800
Message-Id: <1245051427.5320.334.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one CPU has no_way_out == 1, all other CPUs should have no_way_out
== 1. But despite global_nwo is read after mce_callin, global_nwo is
updated after mce_callin too. So it is possible that some CPU read
global_nwo before some other CPU update global_nwo, so that no_way_out
== 1 for some CPU, while no_way_out == 0 for some other CPU.

This patch fixes this race condition via moving mce_callin updating
after global_nwo updating, with a smp_wmb in between. A smp_rmb is
added between their reading too.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -703,6 +703,11 @@ static int mce_start(int no_way_out, int
 	}
 
 	atomic_add(no_way_out, &global_nwo);
+	/*
+	 * global_nwo should be updated before mce_callin
+	 */
+	smp_wmb();
+	*order = atomic_add_return(1, &mce_callin);
 
 	/*
 	 * Wait for everyone.
@@ -717,6 +722,10 @@ static int mce_start(int no_way_out, int
 	}
 
 	/*
+	 * mce_callin should be read before global_nwo
+	 */
+	smp_rmb();
+	/*
 	 * Cache the global no_way_out state.
 	 */
 	nwo = atomic_read(&global_nwo);
@@ -862,7 +871,7 @@ void do_machine_check(struct pt_regs *re
 	 * Establish sequential order between the CPUs entering the machine
 	 * check handler.
 	 */
-	int order;
+	int order = -1;
 
 	/*
 	 * If no_way_out gets set, there is no safe way to recover from this
@@ -887,7 +896,6 @@ void do_machine_check(struct pt_regs *re
 	if (!banks)
 		goto out;
 
-	order = atomic_add_return(1, &mce_callin);
 	mce_setup(&m);
 
 	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);


