Return-Path: <linux-kernel-owner+w=401wt.eu-S938531AbXGSK1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938531AbXGSK1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760996AbXGSJ4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:56:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761125AbXGSJzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:52 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: venkatesh.pallipadi@intel.com, ak@suse.de, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [56/58] x86: round_jiffies() for i386 and x86-64 non-critical/corrected MCE polling
Message-Id: <20070719095543.7843514E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

This helps to reduce the frequency at which the CPU must be taken out of a
lower-power state.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Acked-by: Tim Hockin <thockin@hockin.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/mcheck/non-fatal.c |    4 ++--
 arch/x86_64/kernel/mce.c                |    9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

Index: linux/arch/i386/kernel/cpu/mcheck/non-fatal.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/non-fatal.c
+++ linux/arch/i386/kernel/cpu/mcheck/non-fatal.c
@@ -57,7 +57,7 @@ static DECLARE_DELAYED_WORK(mce_work, mc
 static void mce_work_fn(struct work_struct *work)
 { 
 	on_each_cpu(mce_checkregs, NULL, 1, 1);
-	schedule_delayed_work(&mce_work, MCE_RATE);
+	schedule_delayed_work(&mce_work, round_jiffies_relative(MCE_RATE));
 } 
 
 static int __init init_nonfatal_mce_checker(void)
@@ -82,7 +82,7 @@ static int __init init_nonfatal_mce_chec
 	/*
 	 * Check for non-fatal errors every MCE_RATE s
 	 */
-	schedule_delayed_work(&mce_work, MCE_RATE);
+	schedule_delayed_work(&mce_work, round_jiffies_relative(MCE_RATE));
 	printk(KERN_INFO "Machine check exception polling timer started.\n");
 	return 0;
 }
Index: linux/arch/x86_64/kernel/mce.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mce.c
+++ linux/arch/x86_64/kernel/mce.c
@@ -375,7 +375,8 @@ static void mcheck_timer(struct work_str
 	if (mce_notify_user()) {
 		next_interval = max(next_interval/2, HZ/100);
 	} else {
-		next_interval = min(next_interval*2, check_interval*HZ);
+		next_interval = min(next_interval*2,
+				(int)round_jiffies_relative(check_interval*HZ));
 	}
 
 	schedule_delayed_work(&mcheck_work, next_interval);
@@ -428,7 +429,8 @@ static __init int periodic_mcheck_init(v
 { 
 	next_interval = check_interval * HZ;
 	if (next_interval)
-		schedule_delayed_work(&mcheck_work, next_interval);
+		schedule_delayed_work(&mcheck_work,
+				      round_jiffies_relative(next_interval));
 	idle_notifier_register(&mce_idle_notifier);
 	return 0;
 } 
@@ -720,7 +722,8 @@ static void mce_restart(void) 
 	on_each_cpu(mce_init, NULL, 1, 1);       
 	next_interval = check_interval * HZ;
 	if (next_interval)
-		schedule_delayed_work(&mcheck_work, next_interval);
+		schedule_delayed_work(&mcheck_work,
+				      round_jiffies_relative(next_interval));
 }
 
 static struct sysdev_class mce_sysclass = {
