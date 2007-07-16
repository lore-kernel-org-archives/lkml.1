Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbXGPW1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbXGPW1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 18:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXGPW0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 18:26:55 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:40755 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbXGPW0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 18:26:54 -0400
Date: Mon, 16 Jul 2007 15:26:50 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, shai@scalex86.org
Subject: [patch] Change softlockup trigger limit using a kernel parameter
Message-ID: <20070716222650.GA5947@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel warns of softlockups if the softlockup thread is not able to run
on a CPU for 10s.  It is useful to lower the softlockup warning
threshold in testing environments to catch potential lockups early.
Following patch adds a kernel parameter 'softlockup_lim' to control
the softlockup threshold.

Thanks,
Kiran


Control the trigger limit for softlockup warnings.  This is useful for
debugging softlockups, by lowering the softlockup_lim to identify
possible softlockups earlier.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>

Index: linux-2.6.22/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.22.orig/Documentation/kernel-parameters.txt	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22/Documentation/kernel-parameters.txt	2007-07-16 14:07:34.907116001 -0700
@@ -1781,6 +1781,10 @@ and is between 256 and 4096 characters. 
 
 	snd-ymfpci=	[HW,ALSA]
 
+	softlockup_lim=
+			[KNL] Soft lock up tolerance limit in seconds
+			{ 1 - 10 }
+
 	sonycd535=	[HW,CD]
 			Format: <io>[,<irq>]
 
Index: linux-2.6.22/kernel/softlockup.c
===================================================================
--- linux-2.6.22.orig/kernel/softlockup.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.22/kernel/softlockup.c	2007-07-11 12:50:05.280460591 -0700
@@ -21,6 +21,7 @@ static DEFINE_PER_CPU(unsigned long, pri
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
 static int did_panic = 0;
+static int softlockup_lim = 10;
 
 static int
 softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
@@ -34,6 +35,20 @@ static struct notifier_block panic_block
 	.notifier_call = softlock_panic,
 };
 
+static int __init softlockup_lim_setup(char *str)
+{
+	int lim = simple_strtol(str, NULL, 0);
+	if(lim > 0 && lim <= 10) {
+		softlockup_lim = lim;
+	} else {
+		printk("%s: Invalid softlockup_lim parameter.  ", __func__);
+		printk("Using defaults.\n");
+	}
+	return 1;
+}
+
+__setup("softlockup_lim=", softlockup_lim_setup);
+
 /*
  * Returns seconds, approximately.  We don't need nanosecond
  * resolution, and we don't need to waste time with a big divide when
@@ -97,7 +112,7 @@ void softlockup_tick(void)
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable 10+ seconds delays: */
-	if (now > (touch_timestamp + 10)) {
+	if (now > (touch_timestamp + softlockup_lim)) {
 		per_cpu(print_timestamp, this_cpu) = touch_timestamp;
 
 		spin_lock(&print_lock);
