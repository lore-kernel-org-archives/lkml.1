Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbZDGPHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbZDGPHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZDGPHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48804 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbZDGPHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:01 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407506.675031434@firstfloor.org>
In-Reply-To: <20090407506.675031434@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [1/4] x86: MCE: Make polling timer interval per CPU
Message-Id: <20090407150654.071D21D046E@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:06:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: bug fix

The polling timer while running per CPU still uses a global next_interval
variable, which lead to some CPUs either polling too fast or too slow.
This was not a serious problem because all errors get picked up eventually,
but it's still better to avoid it. Turn next_interval into a per cpu variable.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:57.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:16.000000000 +0200
@@ -452,13 +452,14 @@
  */
 
 static int check_interval = 5 * 60; /* 5 minutes */
-static int next_interval; /* in jiffies */
+static DEFINE_PER_CPU(int, next_interval); /* in jiffies */
 static void mcheck_timer(unsigned long);
 static DEFINE_PER_CPU(struct timer_list, mce_timer);
 
 static void mcheck_timer(unsigned long data)
 {
 	struct timer_list *t = &per_cpu(mce_timer, data);
+	int *n;
 
 	WARN_ON(smp_processor_id() != data);
 
@@ -470,14 +471,14 @@
 	 * Alert userspace if needed.  If we logged an MCE, reduce the
 	 * polling interval, otherwise increase the polling interval.
 	 */
+	n = &__get_cpu_var(next_interval);
 	if (mce_notify_user()) {
-		next_interval = max(next_interval/2, HZ/100);
+		*n = max(*n/2, HZ/100);
 	} else {
-		next_interval = min(next_interval * 2,
-				(int)round_jiffies_relative(check_interval*HZ));
+		*n = min(*n*2, (int)round_jiffies_relative(check_interval*HZ));
 	}
 
-	t->expires = jiffies + next_interval;
+	t->expires = jiffies + *n;
 	add_timer(t);
 }
 
@@ -632,14 +633,14 @@
 static void mce_init_timer(void)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
+	int *n = &__get_cpu_var(next_interval);
 
-	/* data race harmless because everyone sets to the same value */
-	if (!next_interval)
-		next_interval = check_interval * HZ;
-	if (!next_interval)
+	if (!*n)
+		*n = check_interval * HZ;
+	if (!*n)
 		return;
 	setup_timer(t, mcheck_timer, smp_processor_id());
-	t->expires = round_jiffies(jiffies + next_interval);
+	t->expires = round_jiffies(jiffies + *n);
 	add_timer(t);
 }
 
@@ -907,7 +908,6 @@
 /* Reinit MCEs after user configuration changes */
 static void mce_restart(void)
 {
-	next_interval = check_interval * HZ;
 	on_each_cpu(mce_cpu_restart, NULL, 1);
 }
 
@@ -1110,7 +1110,8 @@
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		t->expires = round_jiffies(jiffies + next_interval);
+		t->expires = round_jiffies(jiffies +
+						__get_cpu_var(next_interval));
 		add_timer_on(t, cpu);
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
 		break;
