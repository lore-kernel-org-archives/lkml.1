Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbZFOJS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbZFOJS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZFOJSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:18:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50747 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbZFOJSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:18:51 -0400
Message-ID: <4A3611F3.3020200@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 18:18:43 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>, Huang Ying <ying.huang@intel.com>
Subject: [PATCH] x86, mce: cleanup mce_start()
References: <4A3601BF.2000201@jp.fujitsu.com> <4A36041C.9050202@jp.fujitsu.com> <851fc09e0906150126x4bb003flbf099aff0eed2a66@mail.gmail.com>
In-Reply-To: <851fc09e0906150126x4bb003flbf099aff0eed2a66@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ my 02/16 should be replaced by combination of Huang's fix and this cleanup ]

Simplify interface of mce_start().

-       no_way_out = mce_start(no_way_out, &order);
+       order = mce_start(&no_way_out);

Now Monarch and Subjects share same exit(return) in usual path.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   66 ++++++++++++++++++--------------------
 1 files changed, 31 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index dda7721..739fd7e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -691,23 +691,21 @@ static atomic_t global_nwo;
  * in the entry order.
  * TBD double check parallel CPU hotunplug
  */
-static int mce_start(int no_way_out, int *order)
+static int mce_start(int *no_way_out)
 {
-	int nwo;
+	int order;
 	int cpus = num_online_cpus();
 	u64 timeout = (u64)monarch_timeout * NSEC_PER_USEC;
 
-	if (!timeout) {
-		*order = -1;
-		return no_way_out;
-	}
+	if (!timeout)
+		return -1;
 
-	atomic_add(no_way_out, &global_nwo);
+	atomic_add(*no_way_out, &global_nwo);
 	/*
 	 * global_nwo should be updated before mce_callin
 	 */
 	smp_wmb();
-	*order = atomic_add_return(1, &mce_callin);
+	order = atomic_add_return(1, &mce_callin);
 
 	/*
 	 * Wait for everyone.
@@ -715,8 +713,7 @@ static int mce_start(int no_way_out, int *order)
 	while (atomic_read(&mce_callin) != cpus) {
 		if (mce_timed_out(&timeout)) {
 			atomic_set(&global_nwo, 0);
-			*order = -1;
-			return no_way_out;
+			return -1;
 		}
 		ndelay(SPINUNIT);
 	}
@@ -725,34 +722,34 @@ static int mce_start(int no_way_out, int *order)
 	 * mce_callin should be read before global_nwo
 	 */
 	smp_rmb();
-	/*
-	 * Cache the global no_way_out state.
-	 */
-	nwo = atomic_read(&global_nwo);
 
-	/*
-	 * Monarch starts executing now, the others wait.
-	 */
-	if (*order == 1) {
+	if (order == 1) {
+		/*
+		 * Monarch: Starts executing now, the others wait.
+		 */
 		atomic_set(&mce_executing, 1);
-		return nwo;
+	} else {
+		/*
+		 * Subject: Now start the scanning loop one by one in
+		 * the original callin order.
+		 * This way when there are any shared banks it will be
+		 * only seen by one CPU before cleared, avoiding duplicates.
+		 */
+		while (atomic_read(&mce_executing) < order) {
+			if (mce_timed_out(&timeout)) {
+				atomic_set(&global_nwo, 0);
+				return -1;
+			}
+			ndelay(SPINUNIT);
+		}
 	}
 
 	/*
-	 * Now start the scanning loop one by one
-	 * in the original callin order.
-	 * This way when there are any shared banks it will
-	 * be only seen by one CPU before cleared, avoiding duplicates.
+	 * Cache the global no_way_out state.
 	 */
-	while (atomic_read(&mce_executing) < *order) {
-		if (mce_timed_out(&timeout)) {
-			atomic_set(&global_nwo, 0);
-			*order = -1;
-			return no_way_out;
-		}
-		ndelay(SPINUNIT);
-	}
-	return nwo;
+	*no_way_out = atomic_read(&global_nwo);
+
+	return order;
 }
 
 /*
@@ -871,8 +868,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * Establish sequential order between the CPUs entering the machine
 	 * check handler.
 	 */
-	int order = -1;
-
+	int order;
 	/*
 	 * If no_way_out gets set, there is no safe way to recover from this
 	 * MCE.  If tolerant is cranked up, we'll try anyway.
@@ -917,7 +913,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * This way we don't report duplicated events on shared banks
 	 * because the first one to see it will clear it.
 	 */
-	no_way_out = mce_start(no_way_out, &order);
+	order = mce_start(&no_way_out);
 	for (i = 0; i < banks; i++) {
 		__clear_bit(i, toclear);
 		if (!bank[i])
-- 
1.6.3

