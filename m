Return-Path: <linux-kernel-owner+w=401wt.eu-S933570AbZDIK26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570AbZDIK26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933481AbZDIK21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:28:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59603 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443AbZDIK20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:28:26 -0400
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       seto.hidetoshi@jp.fujitsu.com
Subject: [PATCH] [1/4] x86: MCE: Make polling timer interval per CPU v2
From: Andi Kleen <andi@firstfloor.org>
References: <20090407506.675031434@firstfloor.org>
	<20090407150654.071D21D046E@basil.firstfloor.org>
Date: Thu, 09 Apr 2009 12:28:22 +0200
In-Reply-To: <20090407150654.071D21D046E@basil.firstfloor.org> (Andi Kleen's message of "Tue,  7 Apr 2009 17:06:53 +0200 (CEST)")
Message-ID: <873aci9l4p.fsf_-_@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This v2 version fixes the check_interval == 0 case noticed by Seto-san.
Please apply.

-Andi

---

x86: MCE: Make polling timer interval per CPU v2

Impact: bug fix

The polling timer while running per CPU still uses a global next_interval
variable, which lead to some CPUs either polling too fast or too slow.
This was not a serious problem because all errors get picked up eventually,
but it's still better to avoid it. Turn next_interval into a per cpu variable.

v2: Fix check_interval == 0 case (Hidetoshi Seto)

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-09 11:43:58.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-09 12:16:33.000000000 +0200
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
 
@@ -632,14 +633,13 @@
 static void mce_init_timer(void)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
+	int *n = &__get_cpu_var(next_interval);
 
-	/* data race harmless because everyone sets to the same value */
-	if (!next_interval)
-		next_interval = check_interval * HZ;
-	if (!next_interval)
+	*n = check_interval * HZ;
+	if (!*n)
 		return;
 	setup_timer(t, mcheck_timer, smp_processor_id());
-	t->expires = round_jiffies(jiffies + next_interval);
+	t->expires = round_jiffies(jiffies + *n);
 	add_timer(t);
 }
 
@@ -907,7 +907,6 @@
 /* Reinit MCEs after user configuration changes */
 static void mce_restart(void)
 {
-	next_interval = check_interval * HZ;
 	on_each_cpu(mce_cpu_restart, NULL, 1);
 }
 
@@ -1110,7 +1109,8 @@
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		t->expires = round_jiffies(jiffies + next_interval);
+		t->expires = round_jiffies(jiffies +
+						__get_cpu_var(next_interval));
 		add_timer_on(t, cpu);
 		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
 		break;
