Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbXE2SF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbXE2SF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbXE2SFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:05:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:56871 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbXE2SFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:05:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,589,1170662400"; 
   d="scan'208";a="248466742"
Date: Tue, 29 May 2007 11:01:50 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] Make mce polling timers 1 sec jiffy aligned
Message-ID: <20070529180150.GD5411@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


round_jiffies() for i386 and x86-64 non-critical/corrected MCE polling.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.22-rc-mm/arch/x86_64/kernel/mce.c
===================================================================
--- linux-2.6.22-rc-mm.orig/arch/x86_64/kernel/mce.c	2007-05-24 11:15:57.000000000 -0700
+++ linux-2.6.22-rc-mm/arch/x86_64/kernel/mce.c	2007-05-25 17:29:21.000000000 -0700
@@ -366,7 +366,8 @@
 		next_interval = min(next_interval*2, check_interval*HZ);
 	}
 
-	schedule_delayed_work(&mcheck_work, next_interval);
+	schedule_delayed_work(&mcheck_work,
+			      round_jiffies_relative(next_interval));
 }
 
 
@@ -374,7 +375,8 @@
 { 
 	next_interval = check_interval * HZ;
 	if (next_interval)
-		schedule_delayed_work(&mcheck_work, next_interval);
+		schedule_delayed_work(&mcheck_work,
+				      round_jiffies_relative(next_interval));
 	return 0;
 } 
 __initcall(periodic_mcheck_init);
@@ -618,7 +620,8 @@
 	on_each_cpu(mce_init, NULL, 1, 1);       
 	next_interval = check_interval * HZ;
 	if (next_interval)
-		schedule_delayed_work(&mcheck_work, next_interval);
+		schedule_delayed_work(&mcheck_work,
+				      round_jiffies_relative(next_interval));
 }
 
 static struct sysdev_class mce_sysclass = {
Index: linux-2.6.22-rc-mm/arch/i386/kernel/cpu/mcheck/non-fatal.c
===================================================================
--- linux-2.6.22-rc-mm.orig/arch/i386/kernel/cpu/mcheck/non-fatal.c	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22-rc-mm/arch/i386/kernel/cpu/mcheck/non-fatal.c	2007-05-25 17:27:49.000000000 -0700
@@ -57,7 +57,7 @@
 static void mce_work_fn(struct work_struct *work)
 { 
 	on_each_cpu(mce_checkregs, NULL, 1, 1);
-	schedule_delayed_work(&mce_work, MCE_RATE);
+	schedule_delayed_work(&mce_work, round_jiffies_relative(MCE_RATE));
 } 
 
 static int __init init_nonfatal_mce_checker(void)
@@ -82,7 +82,7 @@
 	/*
 	 * Check for non-fatal errors every MCE_RATE s
 	 */
-	schedule_delayed_work(&mce_work, MCE_RATE);
+	schedule_delayed_work(&mce_work, round_jiffies_relative(MCE_RATE));
 	printk(KERN_INFO "Machine check exception polling timer started.\n");
 	return 0;
 }
