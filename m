Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbZFOIT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbZFOIT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbZFOITt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:19:49 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45451 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbZFOITs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:19:48 -0400
Message-ID: <4A36041C.9050202@jp.fujitsu.com>
Date: Mon, 15 Jun 2009 17:19:40 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/16] x86, mce: call-in should be after updating global_nwo
References: <4A3601BF.2000201@jp.fujitsu.com>
In-Reply-To: <4A3601BF.2000201@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the beginning of Monarch synchronization, processors wait until
all of them have entered the exception handler and then check the
global_nwo to determine if any of them saw a fatal event.

However since current code does call-in before updating global_nwo,
it might happen that the global_nwo does not reflect some of local
nwo at the time.  This might break printing corrected errors not
handled yet on panic.

Reported-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   65 ++++++++++++++++++--------------------
 1 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 6f9db11..84b2630 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -691,18 +691,18 @@ static atomic_t global_nwo;
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
+
+	order = atomic_add_return(1, &mce_callin);
 
 	/*
 	 * Wait for everyone.
@@ -710,40 +710,38 @@ static int mce_start(int no_way_out, int *order)
 	while (atomic_read(&mce_callin) != cpus) {
 		if (mce_timed_out(&timeout)) {
 			atomic_set(&global_nwo, 0);
-			*order = -1;
-			return no_way_out;
+			return -1;
 		}
 		ndelay(SPINUNIT);
 	}
 
-	/*
-	 * Cache the global no_way_out state.
-	 */
-	nwo = atomic_read(&global_nwo);
-
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
@@ -887,7 +885,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	if (!banks)
 		goto out;
 
-	order = atomic_add_return(1, &mce_callin);
 	mce_setup(&m);
 
 	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
@@ -909,7 +906,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
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


